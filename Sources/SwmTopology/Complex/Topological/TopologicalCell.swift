//
//  TopologicalCell.swift
//  SwiftyTopology
//
//  Created by Taketo Sano on 2018/03/10.
//  Copyright © 2018年 Taketo Sano. All rights reserved.
//

import SwmCore

public protocol TopologicalCell: LinearCombinationGenerator {
    var dim: Int { get }
    func boundary<R: Ring>(_ type: R.Type) -> LinearCombination<R, Self>
}

extension TopologicalCell {
    public var degree: Int { return dim }
}
