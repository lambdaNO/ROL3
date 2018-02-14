
#= Première modélisation vue en cours
   Il s'agit ici d'une modélisation explicite
   Un tableau de variables est ici utilisé à la place des 4 variables =#

# On utilisera les packages suivants

using JuMP, GLPKMathProgInterface

# Déclaration d'un modèle (initialement vide), on précise qu'on utilisera le solveur de GLPK pour les programmes linéaires

m = Model(solver = GLPKSolverLP())

# Déclaration des variables

@variable(m,x[1:4] >= 0)

# Déclaration de la fonction objectif (avec le sens d'optimisation)

@objective(m, Max, 15x[1] + 60x[2] + 4x[3] + 20x[4])

# Déclaration des contraintes
# (leur donner un nom est ici facultatif, mais s'imposera ensuite pour grouper des contraintes)

@constraint(m, Toxine1, 20x[1] + 20x[2] + 10x[3] + 40x[4] <= 21)
@constraint(m, Toxine2, 10x[1] + 30x[2] + 20x[3] <= 6)
@constraint(m, Toxine3, 20x[1] + 40x[2] + 30x[3] + 10x[4] <= 14)

# Résolution

status = solve(m)

# Affichage des résultats (ici assez complet pour gérer certains cas d'"erreur")

if status == :Optimal
    println("Problème résolu à l'optimalité")

    println("z = ",getobjectivevalue(m)) # affichage de la valeur optimale

    println("x = ",getvalue(x)) # affichage des valeurs du vecteur de variables

elseif status == :Unbounded
    println("Problème non-borné")

elseif status == :Infeasible
    println("Problème impossible")
end
