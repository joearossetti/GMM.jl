# Linear Models

struct GMMLinearModel <: GMMLstSqModel
    model_formula
    model_formula_iv
    y
    X
    Z
    estimates
end

function GMMLinearModel(linear_model_eqn, linear_iv_eqn, params, Data)
    model_formula = apply_schema(linear_model_eqn, schema(linear_model_eqn, Data))

    y, X = modelcols(model_formula, Data)

    model_formula_iv = apply_schema(linear_iv_eqn, schema(linear_iv_eqn, Data))

    temp, Z = modelcols(model_formula_iv, Data)

    return GMMLinearModel(model_formula, model_formula_iv, y, X, Z, params)
end
export GMMLinearModel

function moment_fun(model::GMMLinearModel)
    return θ -> model.Z' * (model.y - model.X * θ)
end
export moment_fun