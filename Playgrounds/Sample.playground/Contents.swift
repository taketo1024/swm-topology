import SwiftyMath
import SwiftyHomology
import SwiftyTopology

typealias R = 𝐙

let K = SimplicialComplex.torus(dim: 2)
let H = SimplicialHomology<R>(K)

print("H(\(K.name); \(R.symbol))")
H.printSequence(0 ... K.dim)
