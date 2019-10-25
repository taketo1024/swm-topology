import SwiftyMath
import SwiftyHomology
import SwiftyTopology

let K = SimplicialComplex.torus(dim: 3)
let H = SimplicialHomology<𝐙>(K)

print("H(\(K.name), Z)")
Debug.measure {
	H.printSequence()
}
