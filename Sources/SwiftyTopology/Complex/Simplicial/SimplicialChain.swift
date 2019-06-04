//
//  SimplicialChainOperations.swift
//  SwiftyMath
//
//  Created by Taketo Sano on 2018/02/10.
//  Copyright © 2018年 Taketo Sano. All rights reserved.
//

import Foundation
import SwiftyMath

public typealias SimplicialChain<R: Ring> = FreeModule<Simplex, R>

extension SimplicialChain where A == Simplex {
    public func boundary() -> SimplicialChain<R> {
        return self.elements.reduce(SimplicialChain<R>.zero) { (res, next) -> SimplicialChain<R> in
            let (s, r) = next
            return res + r * s.boundary(R.self)
        }
    }
}
