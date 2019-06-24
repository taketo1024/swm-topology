import SwiftyMath
import SwiftyHomology
import SwiftyTopology

let K = SimplicialComplex.torus(dim: 5)
let H = K.homology(𝐙.self)

print("H(\(K.name), Z)")
Debug.measure {
	H.printSequence(range: 0 ... K.dim)
}
