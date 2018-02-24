#=
Exercice entreprise Deroo - Version implicite du solver PL
Intérêt - Définition d'une production par récurrence
Attention - Nécessite d'ajouter un indice 0

\left \{
\begin{array}{c @{ = } c}
    s_{0} & 2000 \\
    x_{i} + y_{i} + s_{i-1} & d_{i} + s_{i} \textrm{ }\forall i \in \{1\dots 12\} \\
\end{array}
\right.

=#
using JuMP, GLPKMathProgInterface

############## A REVOIR

#=
function modelImplicite(solverSelected, c::Vector{Int}, Sinit::Int,KpaNorm::Int,b::Vector{Int}, k::Int)
    m = Model(solver = solverSelected)
    nbctr = length(b)
    println("Nombre de contrainte : ", nbctr)
    println("Constante multiplicative : ", k)
    @variable(m,x[1:nbctr]>= 0,Int)
    @variable(m,y[1:nbctr]>= 0,Int)
    # Attention a bien mettre une case supplémentaire pour initialiser le stock initial
    @variable(m,s[0:nbctr]>= 0,Int)

    @objective(m,Min, sum(c[1]*x[i]for i in 1:nbctr)+sum(c[2]*y[i]for i in 1:nbctr)+sum(c[3]*s[i]for i in 0:nbctr))
    @constraint(m,Kpa,x.<= (KpaNorm * k))
    @constraint(m,StockIni,s[0]==Sinit * k)
    @constraint(m,Gnrl[i=1:nbctr],(x[i]+y[i]+s[i-1]-s[i]== k * d[i]))

    return m
end


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


# Constante multiplicative
k = 1000
#  Membre droit des contraintes - Déclaration demande en K-Unité
d = [30,15,15,25,33,40,45,45,26,14,25,30]
# Capacité de production en H Normale - en K-Unité
KpaNorm = 30
# Stock initial - en K-Unité
Sinit = 2
# Coefficients de la fonction objectifs
c = [20,30,3]

m = modelImplicite(GLPKSolverMIP(),c,Sinit,KpaNorm,d,k)
imp(m)
=#
