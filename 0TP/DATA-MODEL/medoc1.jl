
#= Première modélisation vue en cours
   Il s'agit ici d'une modélisation explicite =#

# On utilisera les packages suivants

using JuMP, GLPKMathProgInterface

# Déclaration d'un modèle (initialement vide), on précise qu'on utilisera le solveur de GLPK pour les programmes linéaires

m = Model(solver = GLPKSolverLP())

# Déclaration des variables

@variable(m,x1 >= 0)
@variable(m,x2 >= 0)
@variable(m,x3 >= 0)
@variable(m,x4 >= 0)

# Déclaration de la fonction objectif (avec le sens d'optimisation)

@objective(m, Max, 15x1 + 60x2 + 4x3 + 20x4)

# Déclaration des contraintes
# (leur donner un nom est ici facultatif, mais s'imposera ensuite pour grouper des contraintes)

@constraint(m, Toxine1, 20x1 + 20x2 + 10x3 + 40x4 <= 21)
@constraint(m, Toxine2, 10x1 + 30x2 + 20x3 <= 6)
@constraint(m, Toxine3, 20x1 + 40x2 + 30x3 + 10x4 <= 14)

# Résolution

status = solve(m)

# Affichage des résultats (ici assez complet pour gérer certains cas d'"erreur")

if status == :Optimal
    println("Problème résolu à l'optimalité")

    println("z = ",getobjectivevalue(m)) # affichage de la valeur optimale

    println("x1 = ",getvalue(x1))
    println("x2 = ",getvalue(x2))
    println("x3 = ",getvalue(x3))
    println("x4 = ",getvalue(x4)) # affichage des valeurs des variables

elseif status == :Unbounded
    println("Problème non-borné")

elseif status == :Infeasible
    println("Problème impossible")
end
