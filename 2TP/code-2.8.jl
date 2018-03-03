## Modèle implicite - Exercice 2.8
## Problème de couverture d'ensemble

using JuMP, GLPKMathProgInterface


function modelImplicite(solverSelected, coef::Dict{Char,Int}, A::Dict{Char,Vector{Char}},indPosVille::Vector{Char},p::Int)
    m = Model(solver = solverSelected)
    nbvar = length(coef)
    nbctr = length(A)
    ## On pose x_i une variable de décision binaire :
    ### 1 si une usine i est à moins de 25 km de la ville
    ### 0 sinon
    ### i \in {A,...,M}
    @variable(m,x[indPosVille],Bin)
    ## On pose y_i une variable de décision binaire :
    ### 1 si on implante une usine sur la ville i
    ### 0 sinon
    ### i \in {A,...,M}
    @variable(m,y[indPosVille],Bin)

    ## Attention : Il faut utiliser une indexation des coefficients de la fonction objectif par une table associative. Cela permet de se rapprocher au mieux du modele et d'effectuer un parcours sur tout indPosVille
    @objective(m,Max,sum(coef[j]x[j] for j in indPosVille))
    @constraint(m,CtrPos[i in indPosVille],x[i] <= sum(y[j] for j in A[i]))
    @constraint(m,CtrNb,sum(y[j] for j in indPosVille)==p)
    return m
end


function imp(m)
    println("> Implantation des usines de Naoned Cola")
    if status == :Optimal
        println("Problème résolu à l'optimalité")
        println("Nombre optimal de personnes touchées ",getobjectivevalue(m)*1000) # affichage de la valeur optimale
        println("Liste des villes où l'on doit implanter une usine pour pouvoir conquérir le monde avec notre succulente boisson")
        for i in indPosVille
            if isapprox(getvalue(m[:y][i]),1) print(i," ")
            end
        end
    elseif status == :Unbounded
        println("Problème non-borné")
    elseif status == :Infeasible
        println("Problème impossible")
    end
end

###############################################################################
## Déclaration des coefficients de la fonction objectif -
## Indexation des coefficients de la fonction objectif par lettre (une lettre => un cout)
coef = Dict(
    'A' => 53,
    'B' => 46,
    'C' => 16,
    'D' => 28,
    'E' => 96,
    'F' => 84,
    'G' => 32,
    'H' => 21,
    'I' => 15,
    'J' => 22,
    'K' => 41,
    'L' => 53,
    'M' => 66
    )
# On vérifie la taille en faisant length(coef)


## Nombre d'usine à implanter
p = 2
## Déclaration de la matrice creuse A - 13 lignes
indPosVille = ['A':'M'...]

A = Dict( 'A' => ['A','B','C','D'],
          'B' => ['A','B','C','D','E','F','G'],
          'C' => ['A','B','C','D'],
          'D' => ['A','B','C','D','E','F','G','J','K'],
          'E' => ['B','D','E','F','G','I','J','K'],
          'F' => ['B','D','E','F','G','I','J','K'],
          'G' => ['B','D','E','F','G','H','I','J','K'],
          'H' => ['G','H','I','J','K','L','M'],
          'I' => ['E','F','G','H','I','J','K','L'],
          'J' => ['D','E','F','G','H','I','J','K','L'],
          'K' => ['D','E','F','G','H','I','J','K','L'],
          'L' => ['H','I','J','K','L','M'],
          'M' => ['H','L','M']
)




m = modelImplicite(GLPKSolverMIP(),coef,A,indPosVille,p)
status = solve(m)
imp(m)


###############################################################################
