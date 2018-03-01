#= Ex 2.2 problème de couverture d'ensemble modèle implicite
   Pour commencer, les indices des caméras sont remplacés par des entiers dans la modélisation
   (Il n'y a pas de moyen direct d'indicer un tableau avec autre chose que des entiers en Julia)
   La matrice des contraintes (pleine) est maintenant remplacée par une matrice creuse =#

using JuMP, GLPKMathProgInterface

# Fonction de modélisation implicite du problème

function modelMuseeImplicite(solverSelected, A::SparseMatrixCSC{Int64,Int64}, b::Vector{Int})
    # Déclaration d'un modèle (initialement vide)
    m = Model(solver = solverSelected)

    # Déduction du nombre de salles à partir des données
    nbSalles, nbCam = size(A)

    # Déclaration des variables
    @variable(m, x[1:nbCam], Bin)

    # Déclaration de la fonction objectif (avec le sens d'optimisation)
    @objective(m, Min, sum(x[j] for j in 1:nbCam))

    # Déclaration des contraintes
    @constraint(m, Salle[i=1:nbSalles], sum(A[i,j]x[j] for j in findn(A[i,:])) >= b[i])
    # Alternative (quand on sait d'avance que les valeurs de la matrice creuse sont des 1)
    # @constraint(m, Salle[i=1:nbSalles], sum(x[j] for j in findn(A[i,:])) >= b[i])

    # Valeur retournée
    return m
end

# Déclaration des données

#=   Une première possibilité : tranformer la matrice pleine en matrice creuse.
#    Cependant, on ne souhaite pas passer par le matrice pleine qui est lourde en mémoire dans le cas général!
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
S = sparse(A) =#

# Saisie directe d'une matrice creuse, en indiquant les indices des valeurs différentes de 0, puis les valeurs
I = [1, 1, 1,
     2, 2, 2,
     3, 3, 3,
     4, 4, 4, 4,
     5, 5, 5, 5, 5, 5,
     6, 6, 6,
     7, 7,
     8, 8, 8, 8, 8,
     9, 9, 9,
     10, 10]
J = [1, 4, 5,
     1, 2, 3,
     3, 7, 8,
     4, 6, 11, 12,
     2, 5, 6, 7, 9, 10,
     8, 9, 15,
     12, 13,
     10, 11, 13, 14, 17,
     14, 15, 16,
     16, 17]
V = [1 for i in 1:length(I)]
# Alternative pour le remplissage de V :
# V = ones(Int,lenght(I))

A = sparse(I,J,V)

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
