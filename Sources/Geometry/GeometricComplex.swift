//
//  GeometricComplex.swift
//  SwiftyAlgebra
//
//  Created by Taketo Sano on 2017/05/28.
//  Copyright © 2017年 Taketo Sano. All rights reserved.
//

import Foundation

public protocol GeometricComplex {
    associatedtype A: FreeModuleBase
    
    var dim: Int {get}
    
    func simplices(_ i: Int) -> [A]
    func boundaryMap<R: Ring>(_ i: Int) -> FreeModuleHom<A, R>
    func coboundaryMap<R: Ring>(_ i: Int) -> FreeModuleHom<A, R>
    
    func skeleton(_ dim: Int) -> Self
    func chainComplex<R: Ring>(type: R.Type) -> ChainComplex<A, R>
    func cochainComplex<R: Ring>(type: R.Type) -> CochainComplex<A, R>
}

public extension GeometricComplex {
    public func chainComplex<R: Ring>(type: R.Type) -> ChainComplex<A, R> {
        typealias F = FreeModuleHom<A, R>
        
        let chns: [[A]] = (0 ... dim).map { simplices($0) }
        let bmaps: [F]  = (0 ... dim).map { boundaryMap($0) }
        
        return ChainComplex<A, R>(chainBases: chns, boundaryMaps: bmaps)
    }
    
    public func cochainComplex<R: Ring>(type: R.Type) -> CochainComplex<A, R> {
        typealias F = FreeModuleHom<A, R>
        
        let chns: [[A]] = (0 ... dim).map { simplices($0) }
        let bmaps: [F] =  (0 ... dim).map { coboundaryMap($0) }
        
        return CochainComplex<A, R>(chainBases: chns, boundaryMaps: bmaps)
    }
}

public extension Homology where chainType == DescendingChainType, R: EuclideanRing {
    public init<C: GeometricComplex>(_ s: C, _ type: R.Type) where C.A == A {
        let c: ChainComplex<A, R> = s.chainComplex(type: R.self)
        self.init(c)
    }
}

public extension Cohomology where chainType == AscendingChainType, R: EuclideanRing {
    public init<C: GeometricComplex>(_ s: C, _ type: R.Type) where C.A == A {
        let c: CochainComplex<A, R> = s.cochainComplex(type: R.self)
        self.init(c)
    }
}