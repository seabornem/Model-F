cd(@__DIR__)

using JLD2
using CodecZlib
using Printf

save_dir = raw"C:\Users\ssuga\OneDrive\Desktop\julia\Model A\modelA-main\modelA-main\Model F\measurements" #make this your path
mkpath(save_dir)  




include("Model_F.jl")

function op(ϕ)
    (sum(ϕ)/L^2, sum(ϕ.^2))
end

function main()
    @init_state

    thermalize(ϕ1,ϕ2,ψ,m²,L^2)
    
    maxt = 100L^2
    skip = div(L^2,8)
    mass_id = round(m², digits=3)

    open(joinpath(save_dir, "magnetization_L_$(L)_mass_$(mass_id)_id_$(rand()).dat"), "w") do io
    for i in 0:maxt
        (M1,N1) = op(ϕ1)
        (M2,N2) = op(ϕ2)
        (M3,N3) = op(ψ)
        

        Printf.@printf(io, "%i %f %f %f\n", i, M1, M2, M3)

        thermalize(ϕ1,ϕ2,ψ,m²,skip)

        flush(stdout)
    end
    end
end

main()
