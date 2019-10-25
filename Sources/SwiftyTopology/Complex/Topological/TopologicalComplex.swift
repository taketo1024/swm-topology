//
//  TopologicalComplex.swift
//  SwiftyMath
//
//  Created by Taketo Sano on 2017/05/28.
//  Copyright © 2017年 Taketo Sano. All rights reserved.
//

import SwiftyMath
import SwiftyHomology

public protocol TopologicalComplex: CustomStringConvertible where Map.Complex == Self {
    associatedtype Cell: TopologicalCell
    associatedtype Map: TopologicalChainMap
    
    var name: String { get }
    var dim: Int { get }
    
    func contains(_ cell: Cell) -> Bool
    
    var allCells: [Cell] { get }
    func cells(ofDim: Int) -> [Cell]
    func skeleton(_ dim: Int) -> Self
    
    func boundaryMap<R: Ring>(_ i: Int, _ type: R.Type) -> ModuleEnd<LinearCombination<Cell, R>>
}

extension TopologicalComplex {
    public var name: String {
        "_" // TODO
    }
    
    public func contains(_ cell: Cell) -> Bool {
        cells(ofDim: cell.dim).contains(cell)
    }
    
    internal var validDims: [Int] {
        (dim >= 0) ? (0 ... dim).toArray() : []
    }

    public var allCells: [Cell] {
        validDims.flatMap{ cells(ofDim: $0) }
    }
    
    public func boundaryMap<R: Ring>(_ i: Int, _ type: R.Type) -> ModuleEnd<LinearCombination<Cell, R>> {
        ModuleHom.linearlyExtend { s in
            (s.dim == i) ? s.boundary(R.self) : .zero
        }
    }
    
    public var description: String {
        (name == "_") ? "\(type(of: self))" : name
    }
    
    public var detailDescription: String {
        "\(description) {\n" +
            validDims.map{ (i) -> (Int, [Cell]) in (i, cells(ofDim: i)) }
                     .map{ (i, cells) -> String in "\t\(i): " + cells.map{"\($0)"}.joined(separator: ", ")}
                     .joined(separator: "\n")
            + "\n}"
    }
}

extension TopologicalComplex {
    public var eulerNumber: Int {
        validDims.sum{ i in (-1).pow(i) * cells(ofDim: i).count }
    }
    
    public func eulerNumber<R: EuclideanRing>(_ type: R.Type) -> R {
        R(from: eulerNumber)
    }
    
    public var isOrientable: Bool {
        orientationCycle != nil
    }
    
    public func isOrientable(relativeTo L: Self) -> Bool {
        orientationCycle(relativeTo: L) != nil
    }
    
    public func isOrientable<R: EuclideanRing>(relativeTo L: Self?, over: R.Type) -> Bool {
        orientationCycle(relativeTo: L, over: R.self) != nil
    }
    
    public var orientationCycle: LinearCombination<Cell, 𝐙>? {
        orientationCycle(relativeTo: nil, over: 𝐙.self)
    }
    
    public func orientationCycle(relativeTo L: Self) -> LinearCombination<Cell, 𝐙>? {
        orientationCycle(relativeTo: L, over: 𝐙.self)
    }
    
    public func orientationCycle<R: EuclideanRing>(relativeTo L: Self? = nil, over: R.Type) -> LinearCombination<Cell, R>? {
        let K = self
        let H = TopologicalHomology<Self, R>(K, relativeTo: L, withGenerators: true)
        let top = H[dim]
        if top.isFree, top.rank == 1 {
            return top.generator(0)
        } else {
            return nil
        }
    }
}

extension TopologicalComplex {
    public func asChainComplex<R: Ring>(relativeTo L: Self? = nil, over: R.Type) -> ChainComplex1<LinearCombination<Cell, R>> {
        ChainComplex1(
            type: .descending,
            support: 0 ... dim,
            sequence: { i in
                let cells = (L == nil)
                    ? self.cells(ofDim: i)
                    : self.cells(ofDim: i).subtract(L!.cells(ofDim: i))
                
                return self.validDims.contains(i) ? ModuleObject( basis: cells ) : .zeroModule
                
            },
            differential: { i in
                ModuleHom.linearlyExtend{ cell in cell.boundary(R.self) }
            }
        )
    }
}
