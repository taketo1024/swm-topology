//
//  SimplicialMap.swift
//  SwiftyMath
//
//  Created by Taketo Sano on 2017/11/05.
//  Copyright © 2017年 Taketo Sano. All rights reserved.
//

import SwmCore

public struct SimplicialMap: TopologicalChainMap {
    public typealias Complex = SimplicialComplex
    public typealias Domain      = Simplex
    public typealias Codomain    = Simplex
    
    public let function: (Simplex) -> Simplex
    
    public init(_ f: @escaping (Vertex) -> Vertex) {
        self.init() { (s: Simplex) in
            Simplex(s.vertices.map(f).unique())
        }
    }
    
    public init(_ f: @escaping (Simplex) -> Simplex) {
        self.function = f
    }
    
    public init(_ map: [Vertex: Vertex]) {
        self.init { v in map[v] ?? v }
    }
    
    public func image(of K: SimplicialComplex) -> SimplicialComplex {
        let cells = K.maximalCells.map { s in self(s) }.unique()
        return SimplicialComplex(cells: cells, filterMaximalCells: true)
    }
    
    public func callAsFunction(_ v: Vertex) -> Vertex {
        function(Simplex(v)).vertices[0]
    }
    
    public func callAsFunction(_ s: Simplex) -> Simplex {
        function(s)
    }
    
    public static var identity: SimplicialMap {
        SimplicialMap { (s: Simplex) in s }
    }
    
    public static func inclusion(from: SimplicialComplex, to: SimplicialComplex) -> SimplicialMap {
        .identity
    }
    
    public static func diagonal(from: SimplicialComplex) -> SimplicialMap {
        SimplicialMap { (v: Vertex) in v × v }
    }
    
    public static func projection(_ i: Int) -> SimplicialMap {
        SimplicialMap { (v: Vertex) in v.components[i] }
    }
    
    public static func == (f: SimplicialMap, g: SimplicialMap) -> Bool {
        fatalError()
    }
    
    public var description: String {
        ""
    }
}
