module SignedDistanceFunction
include("./sdistance.jl")
using .Sdistance # exportされたmethodのみ使える
export signedDistance2D
end