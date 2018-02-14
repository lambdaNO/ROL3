
#= Première modélisation vue en cours
   Afin de pouvoir réutiliser le modèle (on pourrait avoir d'autres médicaments et d'autres toxines),
   on le déclare indépendamment des données dans une fonction.
   Il s'agit ici d'une modélisation implicite =#

# On utilisera les packages suivants

using JuMP, GLPKMathProgInterface

#= fonction retournant un modèle dépendant de données en entrée (on parle de modélisation implicite car les données sont séparées)
    c représente le vecteur des coefficients de la fonction objectif
    A représente la matrice des contraintes
    b représente les membres de droite des contraintes
    solverSelected est un paramètre permettant de choisir le solveur utilisé pour résoudre le problème =#

function modelImplicite(solverSelected, c::Vector{Int}, A::Array{Int,2},b::Vector{Int})
    # Déclaration d'un modèle (initialement vide)
    m = Model(solver = solverSelected)

    # Déduction du nombre de variables et du nombre de contraintes à partir des données
    nbcontr = size(A,1) # taille de la matrice A sur la première dimension = nombre de lignes de A
    nbvar = size(A,2) # taille de la matrice A sur la deuxième dimension = nombre de colonnes de A

    #= Alternative possible (une fonction en Julia peut retourner plusieurs valeurs)
    nbcontr, nbvar = size(A) =#

    # Déclaration des variables
    @variable(m,x[1:nbvar] >= 0)

    # Déclaration de la fonction objectif (avec le sens d'optimisation)
    @objective(m, Max, sum(c[j]x[j] for j in 1:nbvar))

    # Déclaration des contraintes
    # (leur donner un nom est ici obligatoire pour grouper des contraintes en une seule déclaration)
    @constraint(m, Toxine[i=1:nbcontr], sum(A[i,j]x[j] for j in 1:nbvar) <= b[i])

    # Valeur retournée
    return m
end

# Déclaration des données

c = [15,60,4,20]
A = [20 20 10 40;
     10 30 20 0;
     20 40 30 10]
b = [21,6,14]

# Création d'un modèle complété à partir des données

m = modelImplicite(GLPKSolverLP(),c,A,b)

# Résolution

status = solve(m)

# Affichage des résultats (ici assez complet pour gérer certains cas d'"erreur")

if status == :Optimal
    println("Problème résolu à l'optimalité")

    println("z = ",getobjectivevalue(m)) # affichage de la valeur optimale

    println("x = ",getvalue(m[:x])) # affichage des valeurs du vecteur de variables

elseif status == :Unbounded
    println("Problème non-borné")

elseif status == :Infeasible
    println("Problème impossible")
end
