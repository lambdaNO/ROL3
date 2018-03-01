# LATIF Mehdi - 681
# Distanciel creux II
# Modèle implicite de l'exercice :
##############################################################

using JuMP, GLPKMathProgInterface
function modelImplicite(solverSelected, coef::Vector{Int}, A::Vector{Vector{Tuple{Int,Int}}}, b::Vector{Int})
    m = Model(solver = solverSelected)
    ## On récupère les dimensions qui nous intéressent
    nbvar = size(coef,1)
    nbctr = size(A,1)
    ## Déclaration des variables de décisions - Binaires - Autant que de coefficients dans c
    @variable(m,x[1:nbvar],Bin)
    ## Déclaration de la fonction objectif
    @objective(m,Max,sum(coef[i]x[i] for i in 1:nbvar))
    ## Déclaration des contraintes - Utilisation de la matrice de contrainte A - double indicage
    ## Dans la ligne i de A (A[i]), on prend la colonne j qui à pour valeur v ==>  (j,v) in A[i]
    @constraint(m,Ctr[i=1:nbctr],sum(v*x[j] for (j,v) in A[i])<= b[i])
    return m
end
function imp(m)
    println("> Optimisation avec matrice creuse")
    if status == :Optimal
        println("Problème résolu à l'optimalité - Vacances ? :) ")
        println("z = ",getobjectivevalue(m)) # affichage de la valeur optimale
        println("x = ",getvalue(m[:x])) # affichage des valeurs du vecteur de variables de décisions
    elseif status == :Unbounded
        println("Problème non-borné")
    elseif status == :Infeasible
        println("Problème impossible")
    end
end





##############################################################
##
## Déclaration des coefficients de la fonction objectif
coef = [1,3,7,3,12,4,9,4,3]
## Déclaration de la matrice - 11 lignes
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
## Déclaration des membres droits des contraintes -
### Note : Autant de membres droits que l'on a de contrainte - On a de la chance de n'avoir que des 1
b = ones(Int,length(A))


m = modelImplicite(GLPKSolverMIP(),coef,A,b)
status = solve(m)
imp(m)
