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
        return .descending(
            supported: 0 ... dim,
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
