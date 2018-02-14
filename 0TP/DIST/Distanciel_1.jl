#=
max z = 12*x_1 + 20*x_2
s.c.
0.2*x_1 + 0.4*x_2 ≤ 400
0.2*x_1 + 0.6*x_2 ≤ 800
x_1; x_2 \in N
=#

# Version explicite
# Attention, ce sont des variables entières, on doit donc utiliser le GLPKSolverMIP

# Import des packages
using JuMP, GLPKMathProgInterface
# Déclaration d'un modèle vide - ATTENTION : bien choisir le solver associé au type des variables du problème
m = Model(solver = GLPKSolverMIP())
# Déclaration des variables de décisions - Elles sont de types entier ATTENTION
@variable(m,x1 >= 0,Int)
@variable(m,x2 >= 0,Int)
# On regarde le résultat actuel du modèle :
m
# On définit la fonction objectif - de type max sur le modèle m
@objective(m, Max, 12x1 + 20x2)
# On définit les fonctions contraintes sur le modèle m
@constraint(m, C1, 0.2x1 + 0.4x2 <= 400)
@constraint(m, C2, 0.2x1 + 0.6x2 <= 800)
# On regarde l'état du modèle
m
# On résoud :
status = solve(m)
#=
julia> getvalue(x1)
2000.0
julia> getvalue(x2)
0.0
julia> getobjectivevalue(m)
24000.0
=#
