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

extension AbstractComplexMap {
    public func asChainMap<R>(_ type: R.Type) -> ChainMap<Complex.Cell, Complex.Cell, R> {
        return ChainMap(degree: 0) { _ in
            ModuleHom.linearlyExtend {
                (cell: Complex.Cell) in
                let t = self.applied(to: cell)
                return (cell.dim == t.dim) ? .wrap(t) : .zero
            }
        }
    }
}
