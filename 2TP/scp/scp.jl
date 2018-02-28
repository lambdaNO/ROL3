using JuMP, GLPKMathProgInterface

# Fonction de modélisation du problème "mystère"

function modelSCP(solverSelected, A::Vector{Vector{Int}},nbvar::Int,nbcontr::Int)
    # Déclaration d'un modèle (initialement vide)
    m = Model(solver = solverSelected)

    # Déclaration des variables
    @variable(m, x[1:nbvar], Bin)

    # Déclaration de la fonction objectif (avec le sens d'optimisation)
    @objective(m, Min, sum(x[j] for j in 1:nbvar))

    # Déclaration des contraintes
    @constraint(m, Salle[i=1:nbcontr], sum(x[j] for j in A[i]) >= 1)

    # Valeur retournée
    return m
end

# Fonction de résolution de ce problème, puis d'affichage des résultats

function solveSCP(m::JuMP.Model)
    # Résolution
    status = solve(m)

    # Affichage des résultats (ici assez complet pour gérer certains cas d'"erreur")
    if status == :Optimal
        println("Problème résolu à l'optimalité")

        println("z = ",getobjectivevalue(m)) # affichage de la valeur optimale
        println("x = ",getvalue(m[:x])) # affichage des valeurs du vecteur de variables issues du modèle

        # On peut trouver le premier affichage lourd, et préférer se limiter aux variables fixées à 1 dans l'affichage
        print("Liste des variables fixées à 1")
        for i in 1:m.numCols
            if isapprox(getvalue(m[:x][i]),1) print(i," ")
            end
        end
        println()

    elseif status == :Unbounded
        println("Problème non-borné")

    elseif status == :Infeasible
        println("Problème impossible")
    end
end

#= Fonction qui parse un fichier (au format de l'ORLib pour le problème mystère) et retourne :
   - le nombre de contraintes
   - le nombre de variables
   - un vecteur de vecteurs d'entiers représentant pour chaque contrainte, les variables y intervenant =#

function parseFichier(nomFichier::String)
    # Ouverture d'un fichier en lecture
    f = open(nomFichier,"r")

    # Lecture de la première ligne pour connaître le nombre de contraintes et le nombre de variables
    s = readline(f) # lecture d'une ligne et stockage dans une chaîne de caractères
    tab = parse.(Int,split(s," ",keep = false)) # Segmentation de la ligne en plusieurs entiers, à stocker dans un tableau
    nbcontr = tab[1]
    nbvar = tab[2]

    # Allocation mémoire pour le vecteur de vecteur d'entiers
    A = Vector{Vector{Int}}(nbcontr)

    # Lecture des contraintes
    for i in 1:nbcontr
        s = readline(f)
        tab = parse.(Int,split(s," ",keep = false))
        nb = tab[1] # nombre de variables apparaissant dans la contrainte i
        A[i] = Vector{Int}(0)
        sizehint!(A[i],nb) # Indication de la taille du tableau au compilateur pour éviter des réallocations mémoires successives
        cpt = nb
        while(cpt > 0)
            s = readline(f)
            tab = parse.(Int,split(s," ",keep = false)) # Chaque ligne contient un certain nombre d'éléments de la contrainte...
            append!(A[i],tab) #... que l'on ajoute au tableau stockant ces éléments
            cpt = cpt - length(tab)
        end
    end

    # Fermeture du fichier
    close(f)

    return nbcontr, nbvar, A
end

# fonction qui lit une instance numérique, construit le modèle et le résout

function mainSCP(nomFichier::String)
    nbcontr, nbvar, A = parseFichier(nomFichier) # Lecture des données du problème dans un fichier

    m = modelSCP(GLPKSolverMIP(msg_lev = GLPK.MSG_ON),A,nbvar,nbcontr) # Construction du modèle
    #= (Remarque : le champs optionnel msg_lev = GLPK_MSG_ON
        réactive parciellement les affichages de GLPK qui sont désactivés par défaut avec JuMP) =#

    solveSCP(m) # Résolution et affichage des résultats
end
