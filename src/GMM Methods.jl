abstract type GMMMethods end
abstract type OneStep <: GMMMethods end
export OneStep

struct TwoStep <: GMMMethods
    wmat_fun
end
export TwoStep

struct Iterated <: GMMMethods
    wmat_fun
    iterations
end
export Iterated

function gmm_obj(g, W)
    return θ -> g(θ)' * W * g(θ)
end
export gmm_obj