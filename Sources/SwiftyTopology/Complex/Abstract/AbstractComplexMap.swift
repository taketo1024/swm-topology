//
//  AbstractComplexMap.swift
//  SwiftyTopology
//
//  Created by Taketo Sano on 2018/03/10.
//  Copyright © 2018年 Taketo Sano. All rights reserved.
//

import Foundation
import SwiftyMath

public protocol AbstractComplexMap: MapType where Complex.Map == Self, Domain == Complex.Cell, Codomain == Complex.Cell {
    associatedtype Complex: AbstractComplex
    
    static func inclusion(from: Complex, to: Complex) -> Self
    static func diagonal(from: Complex) -> Self
}
