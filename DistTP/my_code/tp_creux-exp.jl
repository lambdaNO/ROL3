## TP Distanciel II - Matrice creuse
using JuMP, GLPKMathProgInterface
m = Model(solver = GLPKSolverMIP())
# Création du vecteur contenant les coefficients de la fonction objectif
coef = [1,3,7,3,12,4,9,4,3]
## size(c,1)

# Matrice des contrainte
## Moralité : A[ligne] = [(colonne,valeur)]
A = Vector{Vector{Tuple{Int,Int}}}(11)
A[1] = [(1,1),(5,1)]
A[2] = [(2,1),(5,1)]
A[3] = [(3,1),(5,1)]
A[4] = [(3,1),(4,1)]
A[5] = [(2,1),(7,1)]
A[6] = [(5,1),(7,1)]
A[7] = [(5,1),(4,1)]
A[8] = [(6,1),(7,1)]
A[9] = [(6,1),(8,1)]
A[10] = [(8,1),(4,1)]
A[11] = [(5,1),(9,1)]
## A

# création du membre droit des contraintes
b = ones(Int,length(A))
# Création de 9 variables de décisions de type binaires {0,1}:
## Vérifier si ça marche comme ça : @variable(m,x[1:9],Bin)  - Et oui ça marche
nbvar = size(c,1)
nbctr = size(A,1)
@variable(m,x[1:9],Bin)
##@variable(m,x[1:9]>=0,Bin)
@objective(m,Max,sum(coef[i]x[i] for i in 1:nbvar))
@constraint(m,Ctr[i=1:nbctr],sum(v*x[j] for (j,v) in A[i])<= b[i])

status = solve(m)
getobjectivevalue(m)
getvalue(x)
