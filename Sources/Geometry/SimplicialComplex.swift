//
//  SimplicialComplex.swift
//  SwiftyAlgebra
//
//  Created by Taketo Sano on 2017/05/17.
//  Copyright © 2017年 Taketo Sano. All rights reserved.
//

import Foundation

public class SimplicialComplex: GeometricComplex {
    public typealias Cell = Simplex
    
    public let dim: Int
    public let vertexSet: VertexSet
    internal let cellsList: [[Simplex]]
    
    // root initializer
    public required init(_ vertexSet: VertexSet, _ cells: [[Simplex]]) {
        self.dim = cells.count - 1
        self.vertexSet = vertexSet
        self.cellsList = cells
    }
    
    public convenience init<S: Sequence>(_ vertexSet: VertexSet, _ cells: S, generate: Bool = false) where S.Iterator.Element == Simplex {
        let cells = { () -> [[Simplex]] in
            let dim = cells.reduce(0) { max($0, $1.dim) }
            let set = generate ? cells.reduce(Set<Simplex>()){$0.union($1.allSubsimplices()) } : Set(cells)
            
            var cells: [[Simplex]] = (0 ... dim).map{_ in []}
            for s in set {
                cells[s.dim].append(s)
            }
            return cells
        }()
        self.init(vertexSet, cells)
    }
    
    public func skeleton(_ dim: Int) -> Self {
        let sub = Array(cellsList[0 ... dim])
        return type(of: self).init(vertexSet, sub)
    }
    
    public func allCells(ofDim i: Int) -> [Simplex] {
        return (0...dim).contains(i) ? cellsList[i] : []
    }
    
    public lazy var maximalCells: [Simplex] = { () -> [Simplex] in
        var list = Array(self.cellsList.reversed().joined())
        var i = 0
        while i < list.count {
            let s = list[i]
            let subs = s.allSubsimplices().dropFirst()
            for t in subs {
                if let j = list.index(of: t) {
                    list.remove(at: j)
                }
            }
            i += 1
        }
        return list
    }()
    
    public func star(_ v: Vertex) -> [Simplex] { // returns only maximal cells
        return maximalCells.filter{ $0.contains(v) }
    }
    
    public func star(_ s: Simplex) -> [Simplex] { // returns only maximal cells
        return maximalCells.filter{ $0.contains(s) }
    }
    
    public func link(_ v: Vertex) -> [Simplex] { // returns only maximal cells
        return star(v).map{ $0.subtract(v) }.filter{ $0.dim >= 0 }
    }
    
    public func link(_ s: Simplex) -> [Simplex] { // returns only maximal cells
        return star(s).map{ $0.subtract(s) }.filter{ $0.dim >= 0 }
    }
    
    public func boundary<R: Ring>(ofCell s: Simplex) -> FreeModule<Simplex, R> {
        return s.boundary()
    }
    
    public func cofaces(ofCell s: Simplex) -> [Simplex] {
        return allCells(ofDim: s.dim + 1).filter{ $0.contains(s) }
    }
}

public extension SimplicialComplex {
    static func point() -> SimplicialComplex {
        return SimplicialComplex.ball(dim: 0)
    }
    
    static func interval() -> SimplicialComplex {
        return SimplicialComplex.ball(dim: 1)
    }
    
    static func circle() -> SimplicialComplex {
        return SimplicialComplex.sphere(dim: 1)
    }
    
    static func ball(dim: Int) -> SimplicialComplex {
        let V = VertexSet(number: dim + 1)
        let s = Simplex(V, Array(0...dim))
        return SimplicialComplex(V, [s], generate: true)
    }
    
    static func sphere(dim: Int) -> SimplicialComplex {
        return ball(dim: dim + 1).skeleton(dim)
    }
    
    static func torus(dim: Int) -> SimplicialComplex {
        return (1 ..< dim).reduce(SimplicialComplex.circle()) { (r, _) in r ⨯ SimplicialComplex.circle() }
    }
    
    static func realProjectiveSpace(dim: Int) -> SimplicialComplex {
        switch dim {
        case 1:
            return circle()
        case 2:
            let V = VertexSet(number: 6)
            let faces = [(0,1,3),(1,4,3),(1,2,4),(4,2,0),(4,0,5),(0,1,5),(1,2,5),(2,3,5),(0,3,2),(3,4,5)].map {
                v in Simplex(V, [v.0, v.1, v.2])
            }
            return SimplicialComplex(V, faces, generate: true)
        default:
            fatalError("RP^n (n >= 3) not yet supported.")
        }
    }
}

// disjoint union
public func +(K1: SimplicialComplex, K2: SimplicialComplex) -> SimplicialComplex {
    let (n1, n2) = (K1.vertexSet.vertices.count, K2.vertexSet.vertices.count)
    let V = VertexSet(number: n1 + n2)
    let dim = max(K1.dim, K2.dim)
    
    let cells = (0 ... dim).map{ i in
        K1.allCells(ofDim: i).map{ s in Simplex(V, s.vertices.map{$0.index}) } +
            K2.allCells(ofDim: i).map{ s in Simplex(V, s.vertices.map{$0.index + n1}) }
    }
    return SimplicialComplex(V, cells)
}

// product complex
public func ⨯(K1: SimplicialComplex, K2: SimplicialComplex) -> SimplicialComplex {
    let (n1, n2) = (K1.vertexSet.vertices.count, K2.vertexSet.vertices.count)
    let V = VertexSet(number: n1 * n2)
    
    let simplexPairs = K1.maximalCells.pairs(with: K2.maximalCells)
    let indexPairs: [[(Int, Int)]] = simplexPairs.flatMap{(s, t) -> [[(Int, Int)]] in
        (0 ... s.dim + t.dim).flatMap{ k -> [[(Int, Int)]] in
            // list of ordered indices [(i0 <= i1 <= ... <= ik), ... ]
            let Is: [[Int]] = (s.dim + 1).multichoose(k + 1)
            let Js: [[Int]]  = (t.dim + 1).multichoose(k + 1)
            
            // list of pairs of ordered indices [(I, J), ...]
            let allPairs: [([Int], [Int])]  = Is.flatMap{ I in Js.map{ J in (I, J) } }
            
            // filter valid pairs that form a k-simplex
            let validPairs = allPairs.filter{ (I, J) in
                (0 ..< k).forAll{ (i: Int) -> Bool in
                    (I[i] != I[i + 1]) || (J[i] != J[i + 1])
                }
            }
            
            // indexPairs that correspond to the indices of each VertexSets
            return validPairs.map{ (I, J) -> [(Int, Int)] in
                zip(I, J).map{ (i, j) in (s.vertices[i].index, t.vertices[j].index) }
            }
        }
    }
    
    let cells = indexPairs.map { (list: [(Int, Int)]) -> Simplex in
        let indices = list.map{ (i, j) in i + j * n1 }
        return Simplex(V, indices)
    }.unique()
    
    return SimplicialComplex(V, cells)
}
