#= Ex 2.2 problème de couverture d'ensemble modèle implicite
   Nous pouvons maintenant utiliser directement des caractères pour les indices des caméras
   JuMP permet d'utiliser n'importe quel intervalle ou tableau d'indices (de n'importe quel type) pour les variables de décisions
   (cela ne s'applique pas aux tableaux en général en Julia, ni aux matrices creuses)
   Un avantage d'utiliser un vecteur de vecteurs de tuples est qu'on peut utiliser des tuples {Char,Int},
   ce qui permet d'indicer les "colonnes" avec des lettres tout en conservant un accès direct aux éléments de la matrice =#

using JuMP, GLPKMathProgInterface

# Fonction de modélisation implicite du problème

function modelMuseeImplicite(solverSelected, A::Vector{Vector{Tuple{Char,Int}}}, b::Vector{Int},indCam::Vector{Char})
    # Déclaration d'un modèle (initialement vide)
    m = Model(solver = solverSelected)

    # Déduction du nombre de salles à partir des données
    nbSalles = length(b)

    # Déclaration des variables
    @variable(m, x[indCam], Bin)

    # Déclaration de la fonction objectif (avec le sens d'optimisation)
    @objective(m, Min, sum(x[j] for j in indCam))

    # Déclaration des contraintes
    @constraint(m, Salle[i=1:nbSalles], sum(v*x[j] for (j,v) in A[i]) >= b[i])

    # Valeur retournée
    return m
end

# Déclaration des données

# Saisie directe d'un vecteur de vecteurs creux pour remplacer la matrice creuse

indCam = ['B':'R'...] # Définition du tableau ['B','C','D',...,'Q','R']

A = Vector{Vector{Tuple{Char,Int}}}(10)
A[1] = [('B',1),('E',1),('F',1)]
A[2] = [('B',1),('C',1),('D',1)]
A[3] = [('D',1),('H',1),('I',1)]
A[4] = [('E',1),('G',1),('L',1),('M',1)]
A[5] = [('C',1),('F',1),('G',1),('H',1),('J',1),('K',1)]
A[6] = [('I',1),('J',1),('P',1)]
A[7] = [('M',1),('N',1)]
A[8] = [('K',1),('L',1),('N',1),('O',1),('R',1)]
A[9] = [('O',1),('P',1),('Q',1)]
A[10] = [('Q',1),('R',1)]

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
