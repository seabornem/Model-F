using ArgParse
using Distributions
using Random


function parse_commandline()
    s = ArgParseSettings()

    @add_arg_table s begin
        "--mass"
            help = "mass parameter m²"
            arg_type = Float64
            default = 0.0
        "--dt"
            help = "size of time step"
            arg_type = Float64
            default = 0.04
        "--rng"
            help = "seed for random number generation"
            arg_type = Int
            default = 0
        "--fp64"
            help = "flag to use Float64 type rather than Float32"
            action = :store_true
        "size"
            help = "side length of lattice"
            arg_type = Int
            default = 8
            

    end
    return parse_args(ARGS, s)
end

#=
 Parameters below are
 1. L is the number of lattice sites in each dimension; it accepts the second argument passed to julia   
 2. λ is the 4 field coupling
 3. Γ is the scalar field diffusion rate; in our calculations we set it to 1, assuming that the time is measured in the appropriate units 
 4. T is the temperature 
 5. m² = -2.28587 is the critical value of the mass parameter 
=#

parsed_args = parse_commandline()
const FloatType = parsed_args["fp64"] ? Float64 : Float32
const λ = FloatType(4.0)
const Γ = FloatType(1.0) + FloatType(1.0)im
const T = FloatType(1.0)

const L = parsed_args["size"]
const m² = FloatType(-2.28587 + parsed_args["mass"])
const Δt = FloatType(parsed_args["dt"]/real(Γ)) # took real part of gamma to get rid of error

const Rate= FloatType(sqrt(2.0*T*Δt*real(Γ)))
const ξ = Normal(FloatType(0.0), FloatType(1.0))
const c0 =1 #not sure 
const γ0 = 1#not sure 
const k =1 #not sure


const seed = parsed_args["rng"]

if seed != 0
    Random.seed!(seed)
end

function hotstart(n)
    return rand(ξ, n, n, n),rand(ξ, n, n, n),rand(ξ, n, n, n)
end

macro init_state() esc(:( ϕ1 = hotstart(L), ϕ2 = hotstart(L) )) end
#ϕ2 represents the imaginary part of ϕ

