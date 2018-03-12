## Modèle implicite - Exercice 2.6
using JuMP, GLPKMathProgInterface
function modelImplicite(solverSelected, r::Vector{Int}, q::Vector{Int}, d::Vector{Int}, A::Array{Int64,2})
    #m = Model(solver = GLPKSolverMIP())
    m = Model(solver = solverSelected)
    nbSite = size(A,1)
    nbClient = size(A,2)
    #=
        x_{i,j} la quantité de service livrée au client i par le service j
        x_{i,j} \in [0,1]
    =#
    @variable(m, 0 <= x[1:nbSite,1:nbClient] <= 1)
    #=
        y_j = 1 Si le service j est ouvert
              0 sinon
    =#
    @variable(m,y[1:nbSite],Bin)
    @objective(m,Min,(sum(y[j]r[j] for j in 1:nbSite)+ sum(sum(A[i,j]x[i,j]for i in 1:nbClient)for j in 1:nbSite)))
    # Un client reçois son service depuis n'importe quel entrepot
    @constraint(m,Satisfaction[i=1:nbClient],(sum(x[i,j] for j in 1:nbSite)==1))
    # On livre un client via un dépôt suivant la demande exprimé - membre droit : Activation d'une contrainte de capacité (ou non)
    @constraint(m,Livraison[j=1:nbSite],(sum(d[i]x[i,j] for i in 1:nbClient)<=q[j]y[j]))
    return m
end

function imp(m)
    nbSite = size(A,1)
    println("> Implantation des entrepôts pour désservir des centrales d'achats")
    if status == :Optimal
        println("Problème résolu à l'optimalité")
        println("Coût minimal des implantations : ", round(getobjectivevalue(m),3), " k€")
        println("Sites retenus pour l'implantation d'entrepôts : ")
            for j in 1:nbSite
                if isapprox(getvalue(m[:y][j]),1) print(j," ")
                end
            end

    elseif status == :Unbounded
        println("Problème non-borné")
    elseif status == :Infeasible
        println("Problème impossible")
    end
end
################################################################################
###############################################################################
## Déclaration des données :
#### Les entrepôts
###### Coût de fonctionnement des entrepôts - en k-€
r = [3500,9000,10000,4000,3000,9000,9000,3000,4000,10000,9000,3500]
length(r)
###### Kpa de stockage des entrepots - en tonnes
q = [300,250,100,180,275,300,200,220,270,250,230,180]
#### Les clients
###### Demande du client - en tonnes
d = [120,80,75,100,110,100,90,60,30,150,95,120]
################################################################################
#= Utilisation d'une matrice creuse ?
Dans la discipline de l'analyse numérique des mathématiques, une matrice creuse est une matrice contenant beaucoup de zéros. - Wikipédia
Dans le cas suivant, nous avons des données non nulles pour chaque couple (i,j)
Une matrice "simple" me semble donc suffisante afin de le cout de livraison e livraison d'une centrale d'achat (en ligne) par des entrepots (en colonne)
Notation : ∞ sera égale à 1000
=#
#### Cout livraison (entrepot (i) x centrale (j))
inf = 10000
A = [
    100 80 50 50 60 100 120 90 60 70 65 110;
    120 90 60 70 65 110 140 110 80 80 75 130;
    140 110 80 80 75 130 160 125 100 100 80 150;
    160 125 100 100 80 150 190 150 130 inf inf inf;
    190 150 130 inf inf inf 200 180 150 inf inf inf;
    200 180 150 inf inf inf 100 80 50 50 60 100;
    100 80 50 50 60 100 120 90 60 70 65 110;
    120 90 60 70 65 110 140 110 80 80 75 130;
    140 110 80 80 75 130 160 125 100 100 80 150;
    160 125 100 100 80 150 190 150 130 inf inf inf;
    190 150 130 inf inf inf 200 180 150 inf inf inf;
    200 180 150 inf inf inf 100 80 50 50 60 100
]


################################################################################
################################################################################
m = modelImplicite(GLPKSolverMIP(),r,q,d,A)
status = solve(m)
imp(m)
