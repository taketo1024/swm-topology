//
//  AbstractComplexExtensions.swift
//  SwiftyMath
//
//  Created by Taketo Sano on 2018/02/10.
//  Copyright © 2018年 Taketo Sano. All rights reserved.
//

import Foundation
import SwiftyMath
import SwiftyHomology

extension AbstractComplex {
    public func chainComplex<R: Ring>(relativeTo L: Self? = nil, _ type: R.Type) -> ChainComplex1<FreeModule<Cell, R>> {
        return ChainComplex1(descendingSequence: { i in
            let cells = (L == nil)
                ? self.cells(ofDim: i)
                : self.cells(ofDim: i).subtract(L!.cells(ofDim: i))
            let indexer = cells.indexer()
            
            return self.validDims.contains(i)
                ? ModuleObject(
                    basis: cells.map{ .wrap($0) },
                    factorizer: { (z: FreeModule<Cell, R>) in
                        let comps = z.elements.compactMap { (cell, r) in indexer(cell).flatMap{ ($0, 0, r) }  }
                        return DVector<R>(size: cells.count, components: comps)
                })
                : .zeroModule
        }, differential: { i in
            ModuleHom.linearlyExtend{ cell in cell.boundary(R.self) }
        })
    }
    
    public func homology<R: EuclideanRing>(relativeTo L: Self? = nil, _ type: R.Type) -> Homology1<FreeModule<Cell, R>> {
        let C = chainComplex(relativeTo: L, type)
        return Homology(C)
    }

    public func cochainComplex<R: EuclideanRing>(relativeTo L: Self? = nil, _ type: R.Type) -> ChainComplex1<Dual<FreeModule<Cell, R>>> {
        return chainComplex(relativeTo: L, type).dual
    }

    public func cohomology<R: EuclideanRing>(relativeTo L: Self? = nil, _ type: R.Type) -> Homology1<Dual<FreeModule<Cell, R>>> {
        let C = cochainComplex(relativeTo: L, type)
        return C.homology
    }
}
