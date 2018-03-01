#= Ex 2.2 problème de couverture d'ensemble modèle implicite
   Pour commencer, les indices des caméras sont remplacés par des entiers dans la modélisation
   (Il n'y a pas de moyen direct d'indicer un tableau avec autre chose que des entiers en Julia)
   Nous partons sur une modélisation implicite du même type que pour le TP1 =#

using JuMP, GLPKMathProgInterface

# Fonction de modélisation implicite du problème

function modelMuseeImplicite(solverSelected, A::Array{Int,2}, b::Vector{Int})
    # Déclaration d'un modèle (initialement vide)
    m = Model(solver = solverSelected)

    # Déduction du nombre de salles à partir des données
    nbSalles, nbCam = size(A)

    # Déclaration des variables
    @variable(m, x[1:nbCam], Bin)

    # Déclaration de la fonction objectif (avec le sens d'optimisation)
    @objective(m, Min, sum(x[j] for j in 1:nbCam))

    # Déclaration des contraintes
    @constraint(m, Salle[i=1:nbSalles], sum(A[i,j]x[j] for j in 1:nbCam) >= b[i])

    # Valeur retournée
    return m
end

# Déclaration des données

#    1 2 3 4 5 6 7 8 9 1011121314151617
#    B C D E F G H I J K L M N O P Q R
A = [1 0 0 1 1 0 0 0 0 0 0 0 0 0 0 0 0;
     1 1 1 0 0 0 0 0 0 0 0 0 0 0 0 0 0;
     0 0 1 0 0 0 1 1 0 0 0 0 0 0 0 0 0;
     0 0 0 1 0 1 0 0 0 0 1 1 0 0 0 0 0;
     0 1 0 0 1 1 1 0 1 1 0 0 0 0 0 0 0;
     0 0 0 0 0 0 0 1 1 0 0 0 0 0 1 0 0;
     0 0 0 0 0 0 0 0 0 0 0 1 1 0 0 0 0;
     0 0 0 0 0 0 0 0 0 1 1 0 1 1 0 0 1;
     0 0 0 0 0 0 0 0 0 0 0 0 0 1 1 1 0;
     0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 1 1]

b = [if i != 4 1 else 2 end for i in 1:10] # Tableau de 10 cases initialisées à 1 sauf si i == 4, on a alors 2

# Création d'un modèle complété à partir des données

m = modelMuseeImplicite(GLPKSolverMIP(),A,b)

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
