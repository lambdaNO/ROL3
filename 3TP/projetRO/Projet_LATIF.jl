
#= NOM1 - Prénom 1
   NOM2 - Prénom 2
   N'oubliez pas de modifier ce commentaire, ainsi que le nom du fichier! =#

using JuMP, GLPKMathProgInterface


#= Nombreuses autres fonctions à ajouter
   .
   .
   .
   .
   .
=#


# Fonction de résolution exacte du problème de voyageur de commerce, dont le distancier est passé en paramètre

function TSP(C::Array{Int64,2})
    #m = Model(solver =solverSelected)
    #C=parseTSP("plat/exemple.dat")
    m = Model(solver = GLPKSolverMIP())
    nbPoint = size(C,1)
    #=
    Notations :
        i : Villes de départ
        j : Villes d'arrivée
    Variable :
        x_{i,j} = 1 si on va de la ville i à la ville j
                  0 sinon
    =#
    @variable(m,x[1:nbPoint,1:nbPoint],Bin)
    #=
        Déterminer l'ordre de visite des points d'intérêts d'un drône de manière à minimiser le temps total d'exploration (consommation d'énergie)
    =#
    @objective(m,Min,(sum(sum(C[i,j]x[i,j] for j in 1:nbPoint)for i in 1:nbPoint)))
    #=
        Contrainte 1
        On part de la ville i une seule et unique fois
    =#
    ## @constraint(m,ctrDepart[i=1:nbPoint],sum(x[i,j] for j in 1:nbPoint,if j != i) ==1) ## A tester écriture du prof ,if j != i
    @constraint(m,ctrDepart[i=1:nbPoint],sum(x[i,j] for j in 1:nbPoint) ==1)

    #=
        Contrainte 2
        On arrive à la ville j une seule et unique fois
    =#
    @constraint(m,ctrArrivee[j=1:nbPoint],sum(x[i,j] for i in 1:nbPoint)==1)
    #=
        Contrainte 3 - ajout des i!=j
    =#
    @constraint(m,ctr2i[i=1:nbPoint],x[i,i]==0)
    #=
        Contrainte 4 - Probablement redondante avec la contrainte 3
    =#
    @constraint(m,ctr2j[j=1:nbPoint],x[j,j]==0)
    return m
end

function imp(m::Model)
    println("> Ordre de visite des drônes")
    if status == :Optimal
        println("temps total = ",getobjectivevalue(m))
        getvalue(m[:x])
    elseif status == :Unbounded
        println("Problème non-borné")
    elseif status == :Infeasible
        println("Problème impossible")
    end
end


#= Fonction qui résout l'ensemble des instances du projet avec la méthode de résolution exacte,
   le temps d'exécution de chacune des instances est mesuré =#

function scriptTSP()
    # Première exécution sur l'exemple pour forcer la compilation si elle n'a pas encore été exécutée
    C = parseTSP("plat/exemple.dat")
    TSP(C)

    # Série d'exécution avec mesure du temps pour les instances symétriques
    for i in 10:10:150
        file = "plat/plat" * string(i) * ".dat"
        C = parseTSP(file)
        println("Instance à résoudre : plat",i,".dat")
        @time TSP(C)
    end

    # Série d'exécution avec mesure du temps pour les instances asymétriques
    for i in 10:10:150
        file = "relief/relief" * string(i) * ".dat"
        println("Instance à résoudre : relief",i,".dat")
        C = parseTSP(file)
        @time TSP(C)
    end
end

# fonction qui prend en paramètre un fichier contenant un distancier et qui retourne le tableau bidimensionnel correspondant

function parseTSP(nomFichier::String)
    # Ouverture d'un fichier en lecture
    f = open(nomFichier,"r")

    # Lecture de la première ligne pour connaître la taille n du problème
    s = readline(f) # lecture d'une ligne et stockage dans une chaîne de caractères
    tab = parse.(Int,split(s," ",keep = false)) # Segmentation de la ligne en plusieurs entiers, à stocker dans un tableau (qui ne contient ici qu'un entier)
    n = tab[1]

    # Allocation mémoire pour le distancier
    C = Array{Int,2}(n,n)

    # Lecture du distancier
    for i in 1:n
        s = readline(f)
        tab = parse.(Int,split(s," ",keep = false))
        for j in 1:n
            C[i,j] = tab[j]
        end
    end

    # Fermeture du fichier
    close(f)

    # Retour de la matrice de coûts
    return C
end





function permutation(X::Array{Float64,2})
    nbPoint = size(X,1)
    V=[0 for i in 1:nbPoint]
        println("Permutations trouvées : ")
        for i in 1:nbPoint
            for j in 1:nbPoint
                if (X[i,j]==1)
                    println("(",i,")" ," - (",i," -> ",j,") ")
                    V[i]=j
                end
            end
        end
        println()
    return V
end









#https://zestedesavoir.com/tutoriels/681/a-la-decouverte-des-algorithmes-de-graphe/727_bases-de-la-theorie-des-graphes/3353_parcourir-un-graphe/
# Bien penser à faire une fonction qui initialise les 3 vecteurs suivants et qui fait appel à explorer.
## De manière générale, push! nécéssite que le vecteur dans lequel on veut pusher soit non vide.
## J'ajoute donc [0] que je veux shift à la fin (méthode sur les collections qui vire le premier élément)
## DFS(P,1,[0])

function DFS(G::Array{Int64,1},n::Int64,ss_cycle::Array{Int64,1},etat::Array{Int64,1},pere::Array{Int64,1})
    ss_cycle = push!(ss_cycle,n)
    println("ss_cycle : ", ss_cycle)
    println("       DFS Sommet départ : ", n)
    println("       @ DFS Ajouter sommet courant ici (",n,") au sous cycle " )
    etat[n] = 1
    println("       DFS Etat sommets : ", etat)
    v = G[n]
    println("       DFS Sommet successeur de  ",n," :  ", v)
    println("       DFS Etat père avant appel rec : ",pere)
    println(v," etat ",etat[v]==0)
    if (etat[v]==0)
        println("Si v ", v)
        println("Si n ", n)
        pere[v] = n
        DFS(P,v,ss_cycle,etat,pere)
    end
    println("       DFS Etat après appel rec : ",etat)
    println("       DFS Père après appel rec : ",pere)
    println()

    println("Fin n > ",n)
    println("Fin v > ",v)

    println("--------Fin DFS-------")
    return ss_cycle
end

function explorer(G::Array{Int64,1},etat::Array{Int64,1},pere::Array{Int64,1})
    ## On passe le vecteur [[0]] en paramètre pour que l'on puisse pusher à l'intérieur
    cycle = [[0]]
    println("EXP : Pere avant exploration : ", pere)
    println("EXP : Etat avant exploration : ", etat)
    for i in 1:nbPoint
        println("   EXP : Etat de ", i, " : avant exploration : ", etat[i])
        if (etat[i] ==0)
            pere[i] = 0
            ## On passe le vecteur [0] en paramètre pour que l'on puisse pusher à l'intérieur
            ss_cycle = DFS(G,i,[0],etat,pere)
            println("=> EXP - ss_cycle retourné avant shift! ", ss_cycle)
            ## On vire le [0] ajouté artificiellement précédemment.
            shift!(ss_cycle)
            println("=> EXP - ss_cycle retourné après shitf! ", ss_cycle)
            println("Ajouter le sous cycle au cycle ici")
            push!(cycle,ss_cycle)
            println("=> EXP - état cycle ",cycle)
        end
        println("   EXP : Etat de ", i, " :  après exploration", etat[i])
    end
    println("EXP : Pere après exploration : ", pere)
    println("EXP : Etat après exploration : ", etat)
    ## On vire le [0] ajouté artificiellement précédemment.
    shift!(cycle)
    return cycle
end

#=
    nbPoint = size(P,1)
    etat = zeros(Int64,nbPoint)
    pere = zeros(Int64,nbPoint)

    cycle = explorer(P,etat,pere)

=#


## tenter de trier les cycles en fonction de la première coordonnée du cycle



## PATH MAC
## cd Desktop/ÉTUDES/FAC/S6/RO/TP/3TP/projetRO



# Matrice des contraintes :
#=
C = parseTSP("plat/exemple.dat")
m = TSP(C)
status = solve(m)
imp(m)
x = getvalue(m[:x])
P=permutation(x)
=#


#=
## Déclaration permutations suivantes pour test
T = [7;5;4;3;6;2;1]


=#



#=
    Idée, utiliser la commande push! ajouter progressivement dans le modele les contraintes de cassage de cycle que l'on va trouvé
=#
