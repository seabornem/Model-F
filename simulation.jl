
function NN(n,direction) #0 is back 1 is forwards
    return mod1(n+(2*direction)-1,L)
end

function ΔH_phi(ϕ,ψ,m²,x,q)
    ϕold = ϕ[x...]
    ϕt = ϕold + q
    Δϕ_square = abs(ϕt)^2 - abs(ϕold)^2
    Δϕ_fourth = abs(ϕt)^4 - abs(ϕold)^4
    ∑NN = 0
    for i in 0:1
        ∑NN += ϕ[NN(x[1],i),x[2],x[3]] + ϕ[x[1],NN(x[2],i),x[3]] + ϕ[x[1],x[2],NN(x[3],i)] 
    end
    return 3*Δϕ_square - q * ∑NN + 0.5*m²*Δϕ_square + 0.25*λ*Δϕ_fourth + γ0*ψ[x...]*Δϕ_square 
end

function ΔH_psi(ϕ1,ϕ2,ψ,x,q)
    ψ_old = ψ[x...]
    Δψ_sqaure = (ψ+q)^2 - (ψ_old)^2
    return (1/(2*c0)) * Δψ_sqaure  + γ0*q*abs((ϕ1[x...]^2)+(ϕ2[x...]^2))^2  
end

function single_cell_phi(ϕ,ψ, m², x)
    q = rate*Normal(0,1)
    δH = ΔH_phi(ϕ,ψ, m², x, q)
    ϕ[x...] += q * (rand() < exp(-δH/T))
end
function sweep_phi(ϕ,ψ, m²)
    for l in 0:1
        Threads.@threads for i in 0:L^3/2 -1
        x=Int(mod1(2i,L))
        y =mod1(Int(div(i,L/2)),L)
        z =Int(div(i,L^2/2)) +1 
        single_cell_phi(ϕ,ψ, m²,(Int(mod1(x+y+z-l,L)),j,k))
        end            
    end
end

function single_cell_psi(ϕ1,ϕ2,ψ,x)
    q = sqrt(2*k*T*Δt)*λ
    twin =(NN(x[1],1),x[2],x[3])
    δH = ΔH_psi(ϕ1,ϕ2,ψ,x,q) + ΔH_psi(ϕ1,ϕ2,ψ,twin,-q)
    P = min(1.0f0, exp(-δH/T))
    r= rand()

    if(r < P) 
        ψ[x...] += q
        ψ[twin...] -= q
    end
end

function sweep_psi_1(ϕ1,ϕ2,ψ)
    for l in 0:1
    Threads.@threads for i in 0:L^3/4 -1 
        x =Int(mod1(4i+1,L))
        y =mod1(Int(div(i,L/4)),L)
        z =Int(div(i,L^2/4)) +1 
        single_cell_psi(ϕ1,ϕ2,ψ,(mod1(x+2y+2z+2l,L),y,z))   
    end
end
end
function sweep_psi_2(ϕ1,ϕ2,ψ)
    for l in 0:1
    Threads.@threads for i in 0:L^3/4 -1 
        x =Int(mod1(4i+1,L))
        y =mod1(Int(div(i,L/4)),L)
        z =Int(div(i,L^2/4)) +1 
        single_cell_psi(ϕ1,ϕ2,ψ,(z,mod1(x+2y+2z+2l,L),y))   
    end
end
end
function sweep_psi_3(ϕ1,ϕ2,ψ)
    for l in 0:1
    Threads.@threads for i in 0:L^3/4 -1 
        x =Int(mod1(4i+1,L))
        y =mod1(Int(div(i,L/4)),L)
        z =Int(div(i,L^2/4)) +1 
        single_cell_psi(ϕ1,ϕ2,ψ,(y,z,mod1(x+2y+2z+2l,L)))   
    end
end
end

function dissapative(ϕ1,ϕ2,ψ,m²)
    sweep_psi_1(ϕ1,ϕ2,ψ)
    sweep_psi_2(ϕ1,ϕ2,ψ)
    sweep_psi_3(ϕ1,ϕ2,ψ)
    sweep_phi(ϕ1,ψ,m²)
    sweep_phi(ϕ2,ψ,m²)
end

function thermalize(ϕ1,ϕ2,ψ,m²,N)
    for i in 1:N
        dissapative(ϕ1,ϕ2,ψ,m²)
    end
end
