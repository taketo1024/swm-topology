//
//  SimplicialChainOperations.swift
//  SwiftyMath
//
//  Created by Taketo Sano on 2018/02/10.
//  Copyright © 2018年 Taketo Sano. All rights reserved.
//

import SwmCore

public typealias SimplicialChain<R: Ring> = LinearCombination<R, Simplex>

extension SimplicialChain where Generator == Simplex {
    public func boundary() -> SimplicialChain<R> {
        let f = ModuleEnd<SimplicialChain<R>>.linearlyExtend { s in
            s.boundary(R.self)
        }
        return f(self)
    }
}
