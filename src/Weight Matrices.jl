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

function WeightMatrixUnadj(n, Z)
    return WeightMatrixUnadj(inv((1/n) * Z' * Z))
end

function WeightMatrixUnadj(model::GMMLinearModel)
    return WeightMatrixUnadj(model.n, model.Z)
end
export WeightMatrixUnadj

struct WeightMatrixRobust <: WeightMatrix
    W
end

function WeightMatrixRobust(n, u, Z)
    u_mat = Diagonal(u .^ 2)
    return WeightMatrixRobust(inv((1/n) * Z' * u_mat * Z))
end

function WeightMatrixRobust(model::GMMLinearModel)
    return WeightMatrixRobust(model.n, model.y - model.X * model.estimates, model.Z)
end
export WeightMatrixRobust