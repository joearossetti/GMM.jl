# Weight Matrix

abstract type WeightMatrix end

struct WeightMatrixIdentity <: WeightMatrix 
    W
end

function WeightMatrixIdentity()
    return I
end
export WeightMatrixIdentity

struct WeightMatrixUnadj <: WeightMatrix
    W
end

function WeightMatrixUnadj(model::GMMLinearModel)
    n = length(model.y)
    return inv((1/n) * model.Z' * model.Z)
end
export WeightMatrixUnadj

struct WeightMatrixRobust <: WeightMatrix
    W
end

function WeightMatrixRobust(model::GMMLinearModel)
    n = length(model.y)
    u = model.y - model.X * model.estimates
    u_mat = Diagonal(u .^ 2)
    return inv((1/n) * model.Z' * u_mat * model.Z)
end
export WeightMatrixRobust