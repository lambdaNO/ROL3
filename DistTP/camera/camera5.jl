#= Ex 2.2 problème de couverture d'ensemble modèle implicite
   Nous pouvons maintenant utiliser directement des caractères pour les indices des caméras
   JuMP permet d'utiliser n'importe quel intervalle ou tableau d'indices (de n'importe quel type) pour les variables de décisions
   (cela ne s'applique pas aux tableaux en général en Julia, ni aux matrices creuses)
   Comme nous savons que nous n'avons que des 1 dans les valeurs significative de notre "matrice creuse",
   nous pouvons simplifier en utilisant simplement un vecteur de vecteurs de Char =#

using JuMP, GLPKMathProgInterface

# Fonction de modélisation implicite du problème

function modelMuseeImplicite(solverSelected, A::Vector{Vector{Char}}, b::Vector{Int},indCam::Vector{Char})
    # Déclaration d'un modèle (initialement vide)
    m = Model(solver = solverSelected)

    # Déduction du nombre de salles à partir des données
    nbSalles = length(b)

    # Déclaration des variables
    @variable(m, x[indCam], Bin)

    # Déclaration de la fonction objectif (avec le sens d'optimisation)
    @objective(m, Min, sum(x[j] for j in indCam))

    # Déclaration des contraintes
    @constraint(m, Salle[i=1:nbSalles], sum(x[j] for j in A[i]) >= b[i])

    # Valeur retournée
    return m
end

# Déclaration des données

# Saisie directe d'un vecteur de vecteurs creux pour remplacer la matrice creuse

indCam = ['B':'R'...] # Définition du tableau ['B','C','D',...,'Q','R']

A = Vector{Vector{Char}}(10)
A[1] = ['B','E','F']
A[2] = ['B','C','D']
A[3] = ['D','H','I']
A[4] = ['E','G','L','M']
A[5] = ['C','F','G','H','J','K']
A[6] = ['I','J','P']
A[7] = ['M','N']
A[8] = ['K','L','N','O','R']
A[9] = ['O','P','Q']
A[10] = ['Q','R']

b = [if i != 4 1 else 2 end for i in 1:10] # Tableau de 10 cases initialisées à 1 sauf si i == 4, on a alors 2

# Création d'un modèle complété à partir des données

m = modelMuseeImplicite(GLPKSolverMIP(),A,b,indCam)

#print(m)

# Résolution

status = solve(m)

# Affichage des résultats (ici assez complet pour gérer certains cas d'"erreur")

if status == :Optimal
    println("Problème résolu à l'optimalité")

    println("z = ",getobjectivevalue(m)) # affichage de la valeur optimale
    println("x = ",getvalue(m[:x])) # affichage des valeurs du vecteur de variables issues du modèle

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
