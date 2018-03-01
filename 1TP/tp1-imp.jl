# LATIF Mehdi
# TP1


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
function modelImplicite(solverSelected, Dem::Vector{Int},StockIni::Int,Kpa::Int,PNorm::Int,PSup::Int,PStock::Int)

    m = Model(solver = solverSelected)
    nbMois = size(Dem,1)
    # Quantités à produire - Variables de décisions
    @variable(m,QNorm[1:nbMois]>=0,Int)
    @variable(m,QSup[1:nbMois]>=0,Int)
    @variable(m,QStock[0:nbMois]>=0,Int)
    # Fonction objectif
    @objective(m,Min, sum(PNorm*QNorm[i] for i in 1:nbMois)+sum(PSup*QSup[i] for i in 1:nbMois)+sum(PStock*QStock[i] for i in 0:nbMois))
    # Déclaration des contraintes
    @constraint(m,CtrKpa[i=1:nbMois],QNorm[i]<= Kpa)
    @constraint(m,CtrSI,QStock[0]==StockIni)
    @constraint(m,CtrProd[i=1:nbMois],(QNorm[i]+QSup[i]+QStock[i-1]== Dem[i] + QStock[i]))

    return m
end

function imp(m)
    if status == :Optimal
        println("Problème résolu à l'optimalité")
        println("Recette de l'année = ",getobjectivevalue(m)," €") # affichage de la valeur optimale
        println("Quantité de vélos produits en Heures Normales = ",getvalue(m[:QNorm])) # affichage des valeurs du vecteur de variables - Heures de production normales
        println("Quantité de vélos produits en Heures Sup = ",getvalue(m[:QSup])) # affichage des valeurs du vecteur de variables - Heures de production supplémentaires
        println("Quantité de vélos stockés = ",getvalue(m[:QStock])) # affichage des valeurs du vecteur de variables - Quantités en stock
    elseif status == :Unbounded
        println("Problème non-borné")
    elseif status == :Infeasible
        println("Problème impossible")
    end
end

################################################################################
# Cout de revient d'un vélo en heure normale
PNorm = 20
# Cout de revient d'un vélo en heure sup
PSup = 30
# Cout de stockage
PStock = 3
# Capacité de stockage
Kpa = 30000
# Stock initial - Mois 0
StockIni = 2000
#Demande en K-Unité
d = 1000*[30,15,15,25,33,40,45,45,26,14,25,30]
###############################################################################
# function modelImplicite(solverSelected, Dem::Vector{Int},StockIni::Int,Kpa::Int,PNorm::Int,PSup::Int,PStock::Int)

m = modelImplicite(GLPKSolverMIP(),d,StockIni,Kpa,PNorm,PSup,PStock)
status = solve(m)
imp(m)
