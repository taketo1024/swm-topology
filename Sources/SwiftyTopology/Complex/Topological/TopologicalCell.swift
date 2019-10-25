//
//  TopologicalCell.swift
//  SwiftyTopology
//
//  Created by Taketo Sano on 2018/03/10.
//  Copyright © 2018年 Taketo Sano. All rights reserved.
//

import SwiftyMath

public protocol TopologicalCell: SetType, FreeModuleGenerator {
    var dim: Int { get }
    func boundary<R: Ring>(_ type: R.Type) -> LinearCombination<Self, R>
}

extension TopologicalCell {
    public var degree: Int { return dim }
}
