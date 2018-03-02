## Modèle implicite - Exercice 2.8
## Problème de couverture d'ensemble

using JuMP, GLPKMathProgInterface


function modelImplicite(solverSelected, coef::Dict{Char,Int}, A::Dict{Char,Vector{Tuple{Char,Int}}},indPosVille::Vector{Char},p::Int)
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
    @constraint(m,CtrPos[i in indPosVille],x[i] <= sum(v*y[j] for (j,v) in A[i]))
    @constraint(m,CtrNb,sum(y[j] for j in indPosVille)==2)
    return m
end


function imp(m)
    println("> Implantation des usines de Naoned Cola")
    if status == :Optimal
        println("Problème résolu à l'optimalité - Vacances ? :) ")
        println("Nombre optimal de personnes touchées ",getobjectivevalue(m)*1000) # affichage de la valeur optimale
        println("Liste des villes où l'on doit implanter une usine pour pouvoir conquérir le monde avec notre succulente boisson")
        for i in indPosVille
            if isapprox(getvalue(m[:y][i]),1) print(i," ")
            end
        end
        println()
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
    'M'=> 66
    )
# On vérifie la taille en faisant length(coef)


## Nombre d'usine à implanter
p = 2
## Déclaration de la matrice creuse A - 13 lignes
indPosVille = ['A':'M'...]

A = Dict( 'A' => [('A',1),('B',1),('C',1),('D',1)],
          'B' => [('A',1),('B',1),('C',1),('D',1),('E',1),('F',1),('G',1)],
          'C' => [('A',1),('B',1),('C',1),('D',1)],
          'D' => [('A',1),('B',1),('C',1),('D',1),('E',1),('F',1),('G',1),('J',1),('K',1)],
          'E' => [('B',1),('D',1),('E',1),('F',1),('G',1),('I',1),('J',1),('K',1)],
          'F' => [('B',1),('D',1),('E',1),('F',1),('G',1),('I',1),('J',1),('K',1)],
          'G' => [('B',1),('D',1),('E',1),('F',1),('G',1),('H',1),('I',1),('J',1),('K',1)],
          'H' => [('G',1),('H',1),('I',1),('J',1),('K',1),('L',1),('M',1)],
          'I' => [('E',1),('F',1),('G',1),('H',1),('I',1),('J',1),('K',1),('L',1)],
          'J' => [('D',1),('E',1),('F',1),('G',1),('H',1),('I',1),('J',1),('K',1),('L',1)],
          'K' => [('D',1),('E',1),('F',1),('G',1),('H',1),('I',1),('J',1),('K',1),('L',1)],
          'L' => [('H',1),('I',1),('J',1),('K',1),('L',1),('M',1)],
          'M' => [('H',1),('L',1),('M',1)]
)




m = modelImplicite(GLPKSolverMIP(),coef,A,indPosVille,p)
status = solve(m)
imp(m)


###############################################################################
