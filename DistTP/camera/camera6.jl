#= Ex 2.2 problème de couverture d'ensemble modèle implicite
   Une solution un peu moins efficace : remplacer le vecteur de vecteurs d'entiers,
   par un dictionnaire qui associe une clé entière à un vecteur de caractères
   Cette solution ne se justifie pas ici, mais elle serait utile si les indices des contraintes n'étaient pas entiers =#

using JuMP, GLPKMathProgInterface

# Fonction de modélisation implicite du problème

function modelMuseeImplicite(solverSelected, IndCam::Vector{Char}, SCam::Dict{Int,Vector{Char}}, b::Vector{Int})
    # Déclaration d'un modèle (initialement vide)
    m = Model(solver = solverSelected)

    # Déduction du nombre de salles à partir des données
    nbSalles = length(b)

    # Déclaration des variables
    @variable(m, x[IndCam], Bin)

    # Déclaration de la fonction objectif (avec le sens d'optimisation)
    @objective(m, Min, sum(x[j] for j in IndCam))

    # Déclaration des contraintes
    @constraint(m, Salle[i=1:nbSalles], sum(x[j] for j in SCam[i]) >= b[i])

    # Valeur retournée
    return m
end

# Déclaration des données

IndCam = ['B':'R'...] # Définition du tableau ['B','C','D',...,'Q','R']
SCam = Dict(1 => ['B','E','F'],
            2 => ['B','C','D'],
            3 => ['D','H','I'],
            4 => ['E','G','L','M'],
            5 => ['C','F','G','H','J','K'],
            6 => ['I','J','P'],
            7 => ['M','N'],
            8 => ['K','L','N','O','R'],
            9 => ['O','P','Q'],
            10 => ['Q','R'])
b = [if i != 4 1 else 2 end for i in 1:10]

# Création d'un modèle complété à partir des données

m = modelMuseeImplicite(GLPKSolverMIP(),IndCam,SCam,b)

#print(m)

# Résolution

status = solve(m)

# Affichage des résultats (ici assez complet pour gérer certains cas d'"erreur")

if status == :Optimal
    println("Problème résolu à l'optimalité")

    println("z = ",getobjectivevalue(m)) # affichage de la valeur optimale

    println("x = ",getvalue(m[:x])) # affichage des valeurs du vecteur de variables

    # On peut trouver le premier affichage lourd, et préférer se limiter aux variables fixées à 1 dans l'affichage
    print("Liste des portes sélectionnées pour le positionnement d'une caméra : ")
    for i in indCam
        if isapprox(getvalue(m[:x][i]),1) print(i," ")
        end
    end
    println()

elseif status == :Unbounded
    println("Problème non-borné")

elseif status == :Infeasible
    println("Problème impossible")
end
