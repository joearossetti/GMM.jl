function fit(model::GMMLinearModel, method::OneStep)
    Q = gmm_obj(moment_fun(model), method.wmat_init)

    results = optimize(Q, model.estimates)
    
    model_fitted = GMMLinearModel(model.model_formula,
    model.model_formula_iv, model.n, model.y,
    model.X, model.Z, method.wmat_init, results.minimizer)

    return model_fitted
end

function fit(model::GMMLinearModel, method::TwoStep)
    model_1 = fit(model, OneStep(method.wmat_init))
    
    W = method.wmat_fun(model_1).W

    model_2 = fit(model_1, OneStep(W))
    
    return model_2
end

function fit(model::GMMLinearModel, method::Iterated)
    model_i = fit(model, OneStep(method.wmat_init))
    
    for i in 1:(method.iterations - 1)
        W = method.wmat_fun(model_i).W
        model_i = fit(model_i, OneStep(W))
    end
    
    return model_i
end 

export fit