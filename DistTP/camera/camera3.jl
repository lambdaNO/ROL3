#= Ex 2.2 problème de couverture d'ensemble modèle implicite
   Pour commencer, les indices des caméras sont remplacés par des entiers dans la modélisation
   (Il n'y a pas de moyen direct d'indicer un tableau avec autre chose que des entiers en Julia)
   Nous utilisons ici un vecteur de vecteurs de tuples {Int,Int} pour représenter une matrice creuse
   avec un accès DIRECT aux éléments de la matrice =#

using JuMP, GLPKMathProgInterface

# Fonction de modélisation implicite du problème

function modelMuseeImplicite(solverSelected, A::Vector{Vector{Tuple{Int,Int}}}, b::Vector{Int},nbCam::Int)
    # Déclaration d'un modèle (initialement vide)
    m = Model(solver = solverSelected)

    # Déduction du nombre de salles à partir des données
    nbSalles = length(b)

    # Déclaration des variables
    @variable(m, x[1:nbCam], Bin)

    # Déclaration de la fonction objectif (avec le sens d'optimisation)
    @objective(m, Min, sum(x[j] for j in 1:nbCam))

    # Déclaration des contraintes
    @constraint(m, Salle[i=1:nbSalles], sum(v*x[j] for (j,v) in A[i]) >= b[i])

    # Valeur retournée
    return m
end

# Déclaration des données

# Saisie simple d'un vecteur de vecteurs d'entiers

A = Vector{Vector{Tuple{Int,Int}}}(10)
A[1] = [(1,1),(4,1),(5,1)]
A[2] = [(1,1),(2,1),(3,1)]
A[3] = [(3,1),(7,1),(8,1)]
A[4] = [(4,1),(6,1),(11,1),(12,1)]
A[5] = [(2,1),(5,1),(6,1),(7,1),(9,1),(10,1)]
A[6] = [(8,1),(9,1),(15,1)]
A[7] = [(12,1),(13,1)]
A[8] = [(10,1),(11,1),(13,1),(14,1),(17,1)]
A[9] = [(14,1),(15,1),(16,1)]
A[10] =[(16,1),(17,1)]

nbCam = 17

b = [if i != 4 1 else 2 end for i in 1:10] # Tableau de 10 cases initialisées à 1 sauf si i == 4, on a alors 2

# Création d'un modèle complété à partir des données

m = modelMuseeImplicite(GLPKSolverMIP(),A,b,nbCam)

#print(m)

# Résolution

status = solve(m)

# Affichage des résultats (ici assez complet pour gérer certains cas d'"erreur")

if status == :Optimal
    println("Problème résolu à l'optimalité")

    println("z = ",getobjectivevalue(m)) # affichage de la valeur optimale
    println("x = ",getvalue(m[:x])) # affichage des valeurs du vecteur de variables issues du modèle

    # Un autre affichage à l'adresse de l'utilisateur qui convertit les indices en lettres
    for i in 1:m.numCols
        @printf("x[%c] = %d\n",Char(65 + i),getvalue(m[:x][i])) # On n'a jamais fait mieux que le langage C pour formater des affichages!
        #println("x[",Char(65 + i),"] = ",getvalue(m[:x][i]))
    end

    # On peut trouver le premier affichage lourd, et préférer se limiter aux variables fixées à 1 dans l'affichage
    print("Liste des portes sélectionnées pour le positionnement d'une caméra : ")
    for i in 1:m.numCols
        if isapprox(getvalue(m[:x][i]),1) print(Char(65 + i)," ")
        end
    end
    println()

elseif status == :Unbounded
    println("Problème non-borné")

elseif status == :Infeasible
    println("Problème impossible")
end
