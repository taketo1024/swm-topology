//
//  TopologicalChainMap.swift
//  SwiftyTopology
//
//  Created by Taketo Sano on 2018/03/10.
//  Copyright © 2018年 Taketo Sano. All rights reserved.
//

import SwiftyMath
import SwiftyHomology

public protocol TopologicalChainMap: MapType where Complex.Map == Self, Domain == Complex.Cell, Codomain == Complex.Cell {
    associatedtype Complex: TopologicalComplex
    
    static func inclusion(from: Complex, to: Complex) -> Self
    static func diagonal(from: Complex) -> Self
}

extension TopologicalChainMap {
    public func asChainMap<R: Ring>(_ type: R.Type) -> ChainMap<Complex.AlgebraicComplex<R>, Complex.AlgebraicComplex<R>> {
        ChainMap(degree: 0) { _ in
            ModuleHom.linearlyExtend {
                (cell: Complex.Cell) in
                let t = self(cell)
                return (cell.dim == t.dim) ? .init(t) : .zero
            }
        }
    }
}
