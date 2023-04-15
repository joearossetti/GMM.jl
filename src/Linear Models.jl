# Linear Models

struct GMMLinearModel <: GMMLstSqModel
    model_formula
    model_formula_iv
    n
    y
    X
    Z
    W
    estimates
end

function GMMLinearModel(linear_model_eqn, linear_iv_eqn, params, Data)
    model_formula = apply_schema(linear_model_eqn, schema(linear_model_eqn, Data))

    y, X = modelcols(model_formula, Data)

    n = length(y)

    model_formula_iv = apply_schema(linear_iv_eqn, schema(linear_iv_eqn, Data))

    temp, Z = modelcols(model_formula_iv, Data)

    W = WeightMatrixUnadj(n, Z)

    return GMMLinearModel(model_formula, model_formula_iv, n, y, X, Z, W, params)
end

function GMMLinearModel(model::GMMLinearModel, update_ests, update_W) 
    return GMMLinearModel(
        model.model_formula,
        model.model_formula_iv,
        model.n,
        model.y,
        model.X,
        model.Z,
        update_W,
        update_ests,
    )
end

export GMMLinearModel

function moment_fun(model::GMMLinearModel)
    return θ -> model.Z' * (model.y - model.X * θ)
end
export moment_fun