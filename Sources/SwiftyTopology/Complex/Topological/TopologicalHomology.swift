//
//  TopologicalHomology.swift
//  SwiftyHomology
//
//  Created by Taketo Sano on 2019/10/25.
//

import SwiftyMath
import SwiftyHomology

public struct TopologicalHomology<Complex: TopologicalComplex, R: EuclideanRing>: GridWrapper {
    public typealias GridDim = _1
    public typealias Grid = ModuleGrid1<LinearCombination<Complex.Cell, R>>
    public typealias Object = Grid.Object

    public let complex: Complex
    public let grid: Grid
    
    public init(_ K: Complex, relativeTo L: Complex? = nil, withGenerators: Bool = false, withVectorizer: Bool = false) {
        let C = K.asChainComplex(relativeTo: L, over: R.self)
        let H = C.homology(withGenerators: withGenerators, withVectorizer: withVectorizer)
        
        self.complex = K
        self.grid = H
    }
    
    public func shifted(_ shift: GridCoords<_1>) -> Self {
        fatalError()
    }
}

public struct TopologicalCohomology<Complex: TopologicalComplex, R: EuclideanRing>: GridWrapper {
    public typealias GridDim = _1
    public typealias Grid = ModuleGrid1<Dual<LinearCombination<Complex.Cell, R>>>
    public typealias Object = Grid.Object

    public let complex: Complex
    public let grid: Grid
    
    public init(_ K: Complex, relativeTo L: Complex? = nil, withGenerators: Bool = false, withVectorizer: Bool = false) {
        let C = K.asChainComplex(relativeTo: L, over: R.self).dual
        let H = C.homology(withGenerators: withGenerators, withVectorizer: withVectorizer)
        
        self.complex = K
        self.grid = H
    }
    
    public func shifted(_ shift: GridCoords<_1>) -> Self {
        fatalError()
    }
}
