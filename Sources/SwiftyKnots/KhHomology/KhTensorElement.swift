//
//  KHBasis.swift
//  SwiftyKnots
//
//  Created by Taketo Sano on 2018/04/04.
//

import Foundation
import SwiftyMath

public struct KhTensorElement: BasisElementType, Comparable {
    public let state: LinkSpliceState
    internal let factors: [KhBasisElement]
    public let shift: Int
    
    internal init(_ state: LinkSpliceState, _ factors: [KhBasisElement], _ shift: Int) {
        self.state = state
        self.factors = factors
        self.shift = shift
    }
    
    public static func generateBasis(state: LinkSpliceState, power n: Int, shift: Int) -> [KhTensorElement] {
        return (0 ..< n).reduce([[]]) { (res, _) -> [[KhBasisElement]] in
            res.flatMap{ factors -> [[KhBasisElement]] in
                [factors + [.I], factors + [.X]]
            }
        }.map{ factors in KhTensorElement.init(state, factors, shift) }
        .sorted()
    }
    
    public var degree: Int {
        return factors.sum{ e in e.degree } + state.degree + shift
    }
    
    internal func product<R: Ring>(_ μ: KhBasisElement.Product, _ from: (Int, Int), _ to: Int, _ toState: LinkSpliceState) -> FreeModule<KhTensorElement, R> {
        let (i1, i2) = from
        let (e1, e2) = (factors[i1], factors[i2])
        
        return μ(e1, e2).sum { e in
            var factor = factors
            factor.remove(at: i2)
            factor.remove(at: i1)
            factor.insert(e, at: to)
            return FreeModule( KhTensorElement(toState, factor, shift) )
        }
    }
    
    internal func coproduct<R: Ring>(_ Δ: KhBasisElement.Coproduct, _ from: Int, _ to: (Int, Int), _ toState: LinkSpliceState) -> FreeModule<KhTensorElement, R> {
        let (j1, j2) = to
        let e = factors[from]
        
        return Δ(e).sum { (e1, e2) -> FreeModule<KhTensorElement, R> in
            var factor = factors
            factor.remove(at: from)
            factor.insert(e1, at: j1)
            factor.insert(e2, at: j2)
            return FreeModule( KhTensorElement(toState, factor, shift) )
        }
    }
    
    public static func ==(b1: KhTensorElement, b2: KhTensorElement) -> Bool {
        return b1.state == b2.state && b1.factors == b2.factors
    }
    
    public static func <(b1: KhTensorElement, b2: KhTensorElement) -> Bool {
        return (b1.state < b2.state)
            || (b1.state == b2.state
                && (b1.degree < b2.degree
                    || (b1.degree == b2.degree
                        && b1.factors.lexicographicallyPrecedes(b2.factors)
                    )
                )
        )
    }
    
    public var hashValue: Int {
        return factors.reduce(0) { (res, e) in
            res &<< 2 | (e == .I ? 2 : 1)
        }
    }
    
    public var description: String {
        return "(" + factors.map{ "\($0)" }.joined(separator: "⊗") + ")" + Format.sub(state.description)
    }
}
