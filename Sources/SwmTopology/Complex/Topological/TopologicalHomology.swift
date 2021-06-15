//
//  TopologicalHomology.swift
//  SwiftyHomology
//
//  Created by Taketo Sano on 2019/10/25.
//

import SwmCore
import SwmHomology

public struct TopologicalHomology<Complex: TopologicalComplex, R: HomologyCalculatable>: IndexedModuleStructureType {
    public typealias Index = Int
    public typealias BaseModule = LinearCombination<R, Complex.Cell>
    public typealias Grid = IndexedModuleStructure<Index, BaseModule>

    public let complex: Complex
    public let grid: Grid
    
    public init(_ K: Complex, relativeTo L: Complex? = nil, withGenerators: Bool = false, withVectorizer: Bool = false) {
        let C = K.asChainComplex(relativeTo: L, over: R.self)
        let H = C.homology()
        
        self.complex = K
        self.grid = H
    }
    
    public subscript(i: Int) -> Grid.Object {
        grid[i]
    }
    
    public var support: [Int] {
        grid.support
    }
}

public struct TopologicalCohomology<Complex: TopologicalComplex, R: HomologyCalculatable>: IndexedModuleStructureType {
    public typealias BaseModule = DualModule<LinearCombination<R, Complex.Cell>>
    public typealias Index = Int
    public typealias Grid = IndexedModuleStructure<Index, BaseModule>

    public let complex: Complex
    public let grid: Grid
    
    public init(_ K: Complex, relativeTo L: Complex? = nil, withGenerators: Bool = false, withVectorizer: Bool = false) {
        let C = K.asChainComplex(relativeTo: L, over: R.self).dual
        let H = C.homology()
        
        self.complex = K
        self.grid = H
    }
    
    public subscript(i: Int) -> Grid.Object {
        grid[i]
    }
    
    public var support: [Int] {
        grid.support
    }
}
