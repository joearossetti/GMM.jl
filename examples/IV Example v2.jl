using StatFiles, DataFrames

df = DataFrame(load("./examples/Example Data Sets/hsng.dta")) 

## types are read as int16 and treated as categorical by StatsModel although not by GLM
df[!,:hsngval] = convert.(Float64,df[!,:hsngval])
df[!,:rent] = convert.(Float64,df[!,:rent])
df[!,:faminc] = convert.(Float64,df[!,:faminc])
df[!,:pcturban] = convert.(Float64,df[!,:pcturban])

using GMM
using StatsModels

θ_0 = fill(1.0, 3)

## can't use macro inside of the package so need to using StatsModel outside
## then we need to add that macro somehow to package or create macro for GMMLinearModel...
linear_model_ols = GMMLinearModel(@formula(rent ~ 1 + hsngval + pcturban), @formula(0 ~ 1 + pcturban + faminc + region), θ_0, df)

result_one_step = fit(linear_model_ols, OneStep(linear_model_ols))
se(result_one_step, CovUnadj)

result_two_step = fit(linear_model_ols, TwoStep(linear_model_ols, WeightMatrixRobust))
se(result_two_step, CovRobust)

result_2_step = fit(linear_model_ols, Iterated(linear_model_ols, WeightMatrixRobust, 2))

result_4_step = fit(linear_model_ols, Iterated(linear_model_ols, WeightMatrixRobust, 10))
se(result_4_step, CovRobust)