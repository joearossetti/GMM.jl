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
    return inv(model.Z' * model.Z)
end
export WeightMatrixUnadj

struct WeightMatrixRobust <: WeightMatrix
    W
end

function WeightMatrixRobust(model::GMMLinearModel)
    u = model.y - model.X * model.estimates
    u_mat = Diagonal(u .^ 2)
    return inv(model.Z' * u_mat * model.Z)
end
export WeightMatrixRobust