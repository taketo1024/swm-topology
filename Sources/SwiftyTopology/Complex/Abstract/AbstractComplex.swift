//
//  AbstractComplex.swift
//  SwiftyMath
//
//  Created by Taketo Sano on 2017/05/28.
//  Copyright © 2017年 Taketo Sano. All rights reserved.
//

import SwiftyMath

public protocol AbstractComplex: CustomStringConvertible where Map.Complex == Self {
    associatedtype Cell: AbstractCell
    associatedtype Map: AbstractComplexMap
    
    var name: String { get }
    var dim: Int { get }
    
    func contains(_ cell: Cell) -> Bool
    
    var allCells: [Cell] { get }
    func cells(ofDim: Int) -> [Cell]
    func skeleton(_ dim: Int) -> Self
    
    func boundaryMap<R: Ring>(_ i: Int, _ type: R.Type) -> ModuleEnd<LinearCombination<Cell, R>>
}

extension AbstractComplex {
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
