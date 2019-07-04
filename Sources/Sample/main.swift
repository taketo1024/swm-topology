import SwiftyMath
import SwiftyHomology
import SwiftyTopology

let K = SimplicialComplex.torus(dim: 2)
let H = K.homology(𝐙.self)

print("H(\(K.name), Z)")
Debug.measure {
	H.printSequence()
}
