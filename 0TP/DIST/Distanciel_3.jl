#=
max z = 12*x_1 + 20*x_2
s.c.
0.2*x_1 + 0.4*x_2 ≤ 400
0.2*x_1 + 0.6*x_2 ≤ 800
x_1; x_2 \in N
=#

# Version implicite
# Déclaration de la fonction de modélisation du PL
# [Attention] à bien vérifier les type de contrainte {<,<=,==,>=,<}
# [Attention] à bien vérifier le type des éléments contenu dans les objets passés en paramètre (par exemple vector{type} ou dans le cas présent A::Array{Float64,2})
function modelImplicite(solverSelected, c::Vector{Int}, A::Array{Float64,2},b::Vector{Int})
    m = Model(solver = solverSelected)
    #nbcontr = size(A,1)
    #nbvar = size(A,2)
    nbcontr, nbvar = size(A)
    @variable(m,x[1:nbvar] >= 0,Int)
    @objective(m, Max, sum(c[j]x[j] for j in 1:nbvar))
    @constraint(m, C[i=1:nbcontr], sum(A[i,j]x[j] for j in 1:nbvar) <= b[i])
    return m
end
# Déclaration de la fonction d'affichage
function imp(m)
    if status == :Optimal
        println("Problème résolu à l'optimalité")
        println("z = ",getobjectivevalue(m)) # affichage de la valeur optimale
        println("x = ",getvalue(m[:x])) # affichage des valeurs du vecteur de variables
    elseif status == :Unbounded
        println("Problème non-borné")
    elseif status == :Infeasible
        println("Problème impossible")
    end
end
# Déclaration des données
# - coefficients fonction objectif :
c = [12,20]
# - Matrice des contraintes
A = [0.2 0.4;
    0.2 0.6]
# - Membres droits des contraintes
b = [400,800]
# Déclaration du PL (à l'aide de la fonction)
m = modelImplicite(GLPKSolverMIP(),c,A,b)
# Resolution du PL
status = solve(m)
# Impression des résultats
imp(m)
#=
julia> imp(m)
Problème résolu à l'optimalité
z = 24000.0
x = [2000.0, 0.0]
=#
