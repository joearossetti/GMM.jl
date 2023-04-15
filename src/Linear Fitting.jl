
function solve_normal_eqn(X, Z, y, W)
    A = X' * Z * W * Z' * X
    b = X' * Z * W * Z' * y

    return A \ b
end

function fit(model::GMMLinearModel, ::Type{OneStep})
    W_init = model.W.W

    results = solve_normal_eqn(model.X, model.Z, model.y, W_init)

    model_fitted = GMMLinearModel(model.model_formula,
    model.model_formula_iv, model.n, model.y,
    model.X, model.Z, W_init,  results)

    return model_fitted
end

function fit(model::GMMLinearModel, method::TwoStep)
    W_init = model.W.W
    
    results_1 = solve_normal_eqn(model.X, model.Z, model.y, W_init)

    W_hat = method.wmat_fun(model.n, model.y - model.X * results_1, model.Z).W

    results_2 = solve_normal_eqn(model.X, model.Z, model.y, W_hat)

    model_fitted = GMMLinearModel(model.model_formula,
    model.model_formula_iv, model.n, model.y,
    model.X, model.Z, W_hat, results_2)

    return model_fitted
end

function fit(model::GMMLinearModel, method::Iterated)
    W_hat = model.W.W
    results_i = similar(model.estimates)
    for i in 1:method.iterations
        results_i = solve_normal_eqn(model.X, model.Z, model.y, W_hat)

        if i<method.iterations
            W_hat = method.wmat_fun(model.n, model.y - model.X * results_i, model.Z).W
        end
    end

    model_fitted = GMMLinearModel(model, results_i, W_hat)

    return model_fitted
end
export fit