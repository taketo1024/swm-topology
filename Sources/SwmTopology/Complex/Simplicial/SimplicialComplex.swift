//
//  SimplicialComplex.swift
//  SwiftyMath
//
//  Created by Taketo Sano on 2017/05/17.
//  Copyright © 2017年 Taketo Sano. All rights reserved.
//

import SwmCore
import SwmHomology

public struct SimplicialComplex: TopologicalComplex {
    public typealias Cell = Simplex
    public typealias Map = SimplicialMap
    
    public var name: String
    public let dim: Int
    
    public let vertices: [Vertex]
    public let maximalCells: [Simplex]
    private let allCells: Cache<Int, [Simplex]> = .empty
    
    public init<S: Sequence>(name: String? = nil, cells: S, filterMaximalCells: Bool = false) where S.Iterator.Element == Simplex {
        self.name = name ?? "_"
        self.maximalCells = filterMaximalCells ? SimplicialComplex.filterMaximalCells(cells) : cells.toArray()
        self.vertices = maximalCells.reduce(Set<Vertex>()){ (set, s) in set.union(s.vertices) }.sorted()
        self.dim = maximalCells.reduce(-1){ (res, s) in max(res, s.dim) }
    }
    
    public init(name: String? = nil, cells: Simplex...) {
        self.init(name: name, cells: cells)
    }
    
    public static var empty: SimplicialComplex {
        SimplicialComplex.init(name: "∅", cells: [])
    }
    
    public func skeleton(_ i: Int) -> SimplicialComplex {
        guard validDims.contains(i) else {
            return .empty
        }
        
        let cells = maximalCells.parallelFlatMap { s -> [Simplex] in
            (s.dim > i) ? s.subsimplicices(dim: i) : [s]
        }.uniqued()
        
        return SimplicialComplex(name: "\(self.name)_(\(i))", cells: cells)
    }
    
    public func cells(ofDim i: Int) -> [Simplex] {
        guard validDims.contains(i) else {
            return []
        }
        
        if let cells = allCells[i] {
            return cells
        }
            
        let cells = maximalCells.parallelFlatMap { s -> [Simplex] in
            s.subsimplicices(dim: i)
        }.uniqued().toArray()
        
        allCells[i] = cells
        
        return cells
    }
    
    public func cofaces(ofCell s: Simplex) -> [Simplex] {
        cells(ofDim: s.dim + 1).filter{ $0.contains(s) }
    }
    
    public func named(_ name: String) -> SimplicialComplex {
        var K = self
        K.name = name
        return K
    }
    
    static public func filterMaximalCells<S: Sequence>(_ _cells: S) -> [Simplex] where S.Element == Simplex {
        var result = [Simplex]()
        for s in _cells.sorted().reversed() {
            if result.allSatisfy({ t in !t.contains(s) }) {
                result.append(s)
            }
        }
        return result
    }
}

public typealias SimplicialHomology<R: HomologyCalculatable> = TopologicalHomology<SimplicialComplex, R>
public typealias SimplicialCohomology<R: HomologyCalculatable> = TopologicalCohomology<SimplicialComplex, R>
