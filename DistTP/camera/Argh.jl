#= Ex 2.2 problème de couverture d'ensemble modèle implicite
   La première solution tentée par Anthony Przybylski, et qui ne fonctionne pas!
   Il s'agit de la transposition naturelle de l'écriture d'un modèle dans les autres langages de modélisation
   (sans certaines facilités d'écriture pour la saisie d'un ensemble de couples) =#

using JuMP, GLPKMathProgInterface

# Fonction de modélisation implicite du problème

function modelMuseeImplicite(solverSelected, IndCam::Vector{Char}, SCam::Set{Tuple{Int,Char}}, b::Vector{Int})
    # Déclaration d'un modèle (initialement vide)
    m = Model(solver = solverSelected)

    # Déduction du nombre de salles à partir des données
    nbSalles = length(b)

    # Déclaration des variables
    @variable(m, x[IndCam], Bin)

    # Déclaration de la fonction objectif (avec le sens d'optimisation)
    @objective(m, Min, sum(x[j] for j in IndCam))

    # Déclaration des contraintes
    #= L'erreur se trouve dans la ligne ci-dessous, i est censé être fixé dans chaque contrainte,
       cependant cela ne s'applique pas au for (i,j) in SCam (qui parcourt à chaque fois complètement l'ensemble des couples)
       Par conséquent, la saisie des contraintes est incorrecte (à vérifier en décommentant l'affichage du modèle)
       De manière général, cet itérateur (sur les ensembles) refuse qu'on fixe un élément d'un couple (ex : for (1,j) in SCam donne une erreur) =#
    @constraint(m, Salle[i=1:nbSalles], sum(x[j] for (i,j) in SCam) >= b[i])

    # Valeur retournée
    return m
end

# Déclaration des données

IndCam = ['B':'R'...] # Définition du tableau ['B','C','D',...,'Q','R']

SCam = Set([(1,'B'), (1,'E'), (1,'F'),
            (2,'B'), (2,'C'), (2,'D'),
            (3,'D'), (3,'H'), (3,'I'),
            (4,'E'), (4,'G'), (4,'H'),
            (5,'C'), (5,'F'), (5,'G'), (5,'H'), (5,'J'), (5,'K'),
            (6,'I'), (6,'J'), (6,'P'),
            (7,'M'), (7,'M'),
            (8,'K'), (8,'L'), (8,'N'), (8,'O'), (8,'R'),
            (9,'O'), (9,'P'), (9,'Q'),
            (10,'Q'), (10,'R')])

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
