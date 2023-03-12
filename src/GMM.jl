module GMM

using StatsModels
using DataFrames
using LinearAlgebra
using Optim

# Write your package code here.
abstract type GMMModel end
abstract type GMMLstSqModel <: GMMModel  end

include("Linear Models.jl")
include("Weight Matrices.jl")
include("GMM Methods.jl")
include("Linear Fitting.jl")

end
