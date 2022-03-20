include("../src/FiberNlse.jl")
using Plots;
gr()
U = FiberNlse # Alias for units;

# Simulation dimension
Nₜ, Nₗ = (100,100);

# Fiber properties

D = -17*U.ps/U.nm/U.km;
α = 0.046/U.km;
γ =  1.1/U.W/U.km;
L = 5.0*U.km;

# Signal propoerties
T = 100*U.ps; # Signal duration
λ = 1550*U.nm; # Wavelength
τ = 5 * U.ps; # Pulse duration
N = 1 # Soliton number
sim = U.configure(Nₜ,Nₗ,D, γ, α, L, T, λ);
Pp = abs((sim.β2/γ/τ^2)*N^2) # Soliton power

# Input construction
t = T*0.5*range(-1, stop=1, length=Nₜ); # Time vector
Ψₒ = Vector{ComplexF64}(@. 0.5*sqrt(Pp)/cosh(t/τ)) # Soliton formula





U.initialSignal(sim,Ψₒ);
U.simulate(sim, false);

l = range(0,stop=L, length=Nₗ);

heatmap(abs.(sim.Ψ).^2)
xlabel!("Local time [ps]")

ylabel!("Distance [km]")
