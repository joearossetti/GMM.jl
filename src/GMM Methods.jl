abstract type GMMMethods end

struct OneStep <: GMMMethods
    wmat_init
end

function OneStep(model::GMMLinearModel)
    return OneStep(WeightMatrixUnadj(model))
end
export OneStep

struct TwoStep <: GMMMethods
    wmat_init
    wmat_fun
end

function TwoStep(model::GMMLinearModel, wmat_fun)
    return TwoStep(WeightMatrixUnadj(model), wmat_fun)
end
export TwoStep

struct Iterated <: GMMMethods
    wmat_init
    wmat_fun
    iterations
end

function Iterated(model::GMMLinearModel, wmat_fun, iterations)
    return Iterated(WeightMatrixUnadj(model), wmat_fun, iterations)
end
export Iterated

function gmm_obj(g, W)
    return θ -> g(θ)' * W * g(θ)
end
export gmm_obj