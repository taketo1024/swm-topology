//
//  AbstractCell.swift
//  SwiftyTopology
//
//  Created by Taketo Sano on 2018/03/10.
//  Copyright © 2018年 Taketo Sano. All rights reserved.
//

import Foundation
import SwiftyMath

public protocol AbstractCell: SetType, FreeModuleGenerator {
    var dim: Int { get }
    func boundary<R: Ring>(_ type: R.Type) -> FreeModule<Self, R>
}

extension AbstractCell {
    public var degree: Int { return dim }
}
