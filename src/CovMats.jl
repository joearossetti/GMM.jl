abstract type CovMatrix end

struct CovUnadj <: CovMatrix
    Σ
end

function CovUnadj(model::GMMLinearModel)
    n = length(model.y)

    u = (model.y - model.X * model.estimates)
    s2 = u' * u / n 
    S = (1/n) * model.Z' * model.Z * s2
    
    W = WeightMatrixUnadj(model)
    G = (1/n) * model.Z' * model.X
    M = G' * W * S * W * G
    B = inv(G' * W * G)

    return CovUnadj((1/n) * B * M * B)
end
export CovUnadj

struct CovRobust <: CovMatrix
    Σ
end

function CovRobust(model::GMMLinearModel)
    n = length(model.y)

    u = model.y - model.X * model.estimates
    u_mat = Diagonal(u .^ 2)
    S = (1/n) * model.Z' * u_mat * model.Z
    
    G = (1/n) * model.Z' * model.X
    W = WeightMatrixRobust(model)

    M = G' * W * S * W * G
    B = inv(G' * W * G)

    return CovRobust((1/n) * B * M * B)
end
export CovRobust

function se(model::GMMLinearModel, ::Type{CovUnadj})
    cov_mat = CovUnadj(model)
    
    return sqrt.(diag(cov_mat.Σ))
end

function se(model::GMMLinearModel, ::Type{CovRobust})
    cov_mat = CovRobust(model)
    
    return sqrt.(diag(cov_mat.Σ))
end
export se