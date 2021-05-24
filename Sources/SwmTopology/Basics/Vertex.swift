//
//  Vertex.swift
//  SwiftyMath
//
//  Created by Taketo Sano on 2017/05/27.
//  Copyright © 2017年 Taketo Sano. All rights reserved.
//

import SwmCore

private var list: [Vertex] = []
private var productList: [String: Vertex] = [:]

public struct Vertex: Hashable, Comparable, CustomStringConvertible {
    public let id: Int
    public let label: String
    
    // TODO Vertex should be abstract.
    //      Extract product structure.
    private let _components: [Vertex] // for product-vertex
    
    private init(_ label: String, _ components: [Vertex]) {
        self.id = list.count
        self.label = label
        self._components = components
        
        list.append(self)
    }
    
    public init(_ label: String) {
        self.init(label, [])
    }
    
    public init(prefix: String = "v") {
        self.init(Format.symbol(prefix, list.count))
    }
    
    public var components: [Vertex] {
        _components.isEmpty ? [self] : _components
    }
    
    public static func ==(a: Vertex, b: Vertex) -> Bool {
        a.id == b.id
    }
    
    public static func <(a: Vertex, b: Vertex) -> Bool {
        a.id < b.id
    }
    
    public var description: String {
        label
    }
    
    public static func generate(_ n: Int, prefix: String = "v") -> [Vertex] {
        (0 ..< n).map { i in Vertex(prefix: prefix) }
    }
    
    public static func vertex(ofID id: Int) -> Vertex {
        list[id]
    }
    
    public static func ×(v1: Vertex, v2: Vertex) -> Vertex {
        let components = v1.components + v2.components
        let key = Vertex.productKey(components)
        
        if let v = productList[key] {
            return v
        } else {
            let label = "v\(components.map{ Format.sub($0.id) }.joined(separator: ","))"
            let v = Vertex(label, components)
            productList[key] = v
            return v
        }
    }

    public func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
    
    private static func productKey(_ components: [Vertex]) -> String {
        components.map{ "\($0.id)" }.joined(separator: ",")
    }
}
