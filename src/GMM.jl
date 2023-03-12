module GMM

using LinearAlgebra
using StatsModels
using DataFrames
using Optim

# Write your package code here.
abstract type GMMModel end
abstract type GMMLstSqModel <: GMMModel  end

include("Linear Models.jl")
include("Weight Matrices.jl")

end
