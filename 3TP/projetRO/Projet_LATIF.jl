
#= LATIF - Mehdi
   681 - Maths info
   Life on Mars - Licence 3 - 2017/2018
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
    @constraint(m,ctrDepart[i=1:nbPoint],sum(x[i,j] for j in 1:nbPoint if i!=j) ==1)
    #=
        Contrainte 2
        On arrive à la ville j une seule et unique fois
    =#
    @constraint(m,ctrArrivee[j=1:nbPoint],sum(x[i,j] for i in 1:nbPoint if i!=j)==1)
    #=
        Contrainte 3 - ajout des i!=j

    @constraint(m,ctr2i[i=1:nbPoint],x[i,i]==0)

        Contrainte 4 - Probablement redondante avec la contrainte 3

    @constraint(m,ctr2j[j=1:nbPoint],x[j,j]==0)
    =#
    return m
end

function imp(m::Model)
    if status == :Optimal
        println("> temps total = ",getobjectivevalue(m))
        #println("Ordre de visite des points :", permutation(getvalue(m[:x])))
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
    #TSP(C)

    # Série d'exécution avec mesure du temps pour les instances symétriques
    for i in 10:10:150
        file = "plat/plat" * string(i) * ".dat"
        C = parseTSP(file)
        println("Instance à résoudre : plat",i,".dat")
        #@time TSP(C)
        @time main()
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
        println("   Permutations :")
        for i in 1:nbPoint
            for j in 1:nbPoint
                if (X[i,j]==1)
                    print("(",i," -> ",j,") ")
                    V[i]=j
                end
            end
        end
        println()
    return V
end


# Bien penser à faire une fonction qui initialise les 3 vecteurs suivants et qui fait appel à explorer.
## De manière générale, push! nécéssite que le vecteur dans lequel on veut pusher soit non vide.
## J'ajoute donc [0] que je veux shift à la fin (méthode sur les collections qui vire le premier élément)
## DFS(P,1,[0])

function DFS(G::Array{Int64,1},n::Int64,ss_cycle::Array{Int64,1},etat::Array{Int64,1},pere::Array{Int64,1})
    ss_cycle = push!(ss_cycle,n)
    #println("ss_cycle : ", ss_cycle)
    #println("       DFS Sommet départ : ", n)
    #println("       @ DFS Ajouter sommet courant ici (",n,") au sous cycle " )
    etat[n] = 1
    #println("       DFS Etat sommets : ", etat)
    v = G[n]
    #println("       DFS Sommet successeur de  ",n," :  ", v)
    #println("       DFS Etat père avant appel rec : ",pere)
    #println(v," etat ",etat[v]==0)
    if (etat[v]==0)
        #println("Si v ", v)
        #println("Si n ", n)
        pere[v] = n
        DFS(P,v,ss_cycle,etat,pere)
    end
    #println("       DFS Etat après appel rec : ",etat)
    #println("       DFS Père après appel rec : ",pere)
    #println()
    #println("Fin n > ",n)
    #println("Fin v > ",v)

    #println("--------Fin DFS-------")
    return ss_cycle
end

function explorer(G::Array{Int64,1},etat::Array{Int64,1},pere::Array{Int64,1})
    ## On passe le vecteur [[0]] en paramètre pour que l'on puisse pusher à l'intérieur
    cycle = [[0]]
    #println("EXP : Pere avant exploration : ", pere)
    #println("EXP : Etat avant exploration : ", etat)
    for i in 1:nbPoint
        #println("   EXP : Etat de ", i, " : avant exploration : ", etat[i])
        if (etat[i] ==0)
            pere[i] = 0
            ## On passe le vecteur [0] en paramètre pour que l'on puisse pusher à l'intérieur
            ss_cycle = DFS(G,i,[0],etat,pere)
            #println("=> EXP - ss_cycle retourné avant shift! ", ss_cycle)
            ## On vire le [0] ajouté artificiellement précédemment.
            shift!(ss_cycle)
            #println("=> EXP - ss_cycle retourné après shitf! ", ss_cycle)
            #println("Ajouter le sous cycle au cycle ici")
            push!(cycle,ss_cycle)
            #println("=> EXP - état cycle ",cycle)
        end
        #println("   EXP : Etat de ", i, " :  après exploration", etat[i])
    end
    #println("EXP : Pere après exploration : ", pere)
    #println("EXP : Etat après exploration : ", etat)
    ## On vire le [0] ajouté artificiellement précédemment.
    shift!(cycle)
    return cycle
end

function ind_min(C::Array{Array{Int64,1},1})
    taille = zeros(length(C))
    for i = 1:length(C)
        taille[i] = length(C[i])
    end
    #println(taille)
    return indmin(taille)
end

function imp_cycle(C::Array{Int64,1})
    for i = 1:length(C)
        print(C[i]," -> ")
    end
    print(C[1],". ")
    println()
end


#######################################################################
#######################################################################
#######################################################################
#######################################################################
#######################################################################
#######################################################################

#C = parseTSP("plat/exemple.dat")
#C = parseTSP("plat/plat10.dat")
#C = parseTSP("plat/plat20.dat")
#C = parseTSP("plat/plat30.dat")
#C = parseTSP("plat/plat40.dat")
#C = parseTSP("plat/plat50.dat")
#C = parseTSP("plat/plat60.dat")
#C = parseTSP("plat/plat70.dat")
#C = parseTSP("plat/plat80.dat")
#C = parseTSP("plat/plat90.dat")
#C = parseTSP("plat/plat100.dat")
#C = parseTSP("plat/plat110.dat")
#C = parseTSP("plat/plat120.dat")
#C = parseTSP("plat/plat130.dat")
#C = parseTSP("plat/plat140.dat")
#C = parseTSP("plat/plat150.dat")

#C = parseTSP("relief/relief10.dat")

#C = parseTSP("relief/relief150.dat")

################################################################################
################################################################################
################################################################################
##########################    EXACTE  ##########################################
################################################################################
################################################################################
################################################################################
#=
@time begin
    #C =  parseTSP(S)
    nbiter = 1
    nbcycle = 0
    println("Résolution d'initiale :  ")
    m = TSP(C)
    status = solve(m)
    nbiter = 1
    imp(m)
    P = permutation(getvalue(m[:x]))
    nbPoint = size(P,1)
    etat = zeros(Int64,nbPoint)
    pere = zeros(Int64,nbPoint)
    cycle = explorer(P,etat,pere)
    println("> Cycle(s) trouvé(s) : ", cycle)
    nbcycle = length(cycle)
    println("> Nombre de cycle(s) trouvé(s) : ",nbcycle)
    println()
#######################################################################
#######################################################################
    while(nbcycle!= 1)
        println("Itération n° ", nbiter," Cassage de contrainte ")
        ind = ind_min(cycle)
        aCasser = cycle[ind]
        ## ex : aCasser = [5, 8, 14, 13, 15]
        println("> Cycle à casser : ", aCasser)
        ## Récupérer la taille du cycle
        tailleACasser = length(aCasser)
        println("> Taille du cycle à casser : ", tailleACasser)
        ## Ajouter le premier élément du cycle à casser pour que aCasser forme un cycle (x,y,...,z,x)
        push!(aCasser,aCasser[1])
        ## On créait alors les différentes composantes de la contrainte à casser
        x=m[:x]
        expr = AffExpr()
        i = 1
        while (i <= tailleACasser )
            push!(expr,1.0,x[aCasser[i],aCasser[i+1]])

            i = i + 1
        end
        con = @constraint(m,expr <= (tailleACasser - 1))
        println("> Nouvelle contrainte : ", con)
        println()
        println("> Nouvelle résolution après ajout de la nouvelle contrainte !")
        nbiter = nbiter + 1
        status = solve(m)
        imp(m)
        ############################################################################
        P = permutation(getvalue(m[:x]))
        nbPoint = size(P,1)
        etat = zeros(Int64,nbPoint)
        pere = zeros(Int64,nbPoint)
        cycle = explorer(P,etat,pere)
        println("> Cycle(s) trouvé(s) : ", cycle)
        nbcycle = length(cycle)
        println("> Nombre de cycle(s) trouvé(s) : ",nbcycle)
        println()
    end
    ################################################################################
    ################################################################################
    ## Au sortir de la boucle, on est sûr d'avoir casser tous les sous cycles et de n'avoir qu'un seul cycle
    println("FIN - Problème résolu :")
    imp(m)
    println("> Nombre d'itération nécéssaires : ", nbiter)
    println("> Ordre de parcours des drônes : ")
    imp_cycle(cycle[1])

end
=#
################################################################################
################################################################################
################################################################################
################################################################################



################################################################################
################################################################################
################################################################################
##########################    APPROCHÉE  #######################################
################################################################################
################################################################################
################################################################################
## ATTENTION DANS CE CAS LÀ, LE DISTANCIER DOIT ÊTRE SYMÉTRIQUE



#=
C = [
10000	786	549	657	331	559	250;
786	10000	668	979	593	224	905;
549	668	10000	316	607	472	467;
657	979	316	10000	890	769	400;
331	593	607	890	10000	386	559;
559	224	472	769	386	10000	681;
250	905	467	400	559	681	10000;
]
X = [
10000	786	549	657	331	559	250;
786	10000	668	979	593	224	905;
549	668	10000	316	607	472	467;
657	979	316	10000	890	769	400;
331	593	607	890	10000	386	559;
559	224	472	769	386	10000	681;
250	905	467	400	559	681	10000;
]
=#


function procheVoisin(X::Array{Int64,2},dep::Int64)
    #dep = 1
    nbPoint = size(X,1)
    ## Matrice des points visités
    etat = zeros(Int64,nbPoint)
    ## Matrice des successeurs
    succ = zeros(Int64,nbPoint)
    ### Sauvegarder le point de départ.
    x = dep
    ### Initialisation d'un vecteur parc permettant de vérifier le parcours obtenu
    parc = [x]
    ### Initialisation de la variable de boucle - comparaison du min
    m = 0


    while (m!= 10000)
        println("Recherche du succ de ", x)
        println(X[x,:])
        println("Min de la ligne ",x," = ", minimum(X[x,:]), " atteint au point ", indmin(X[x,:]))
        t = indmin(X[x,:])
        X[:,x] = 10000
        succ[x] = t
        etat[x] = 1
        push!(parc,t)
        #println("E : ", etat)
        #println("S : ", succ)
        #println("P : ", parc)
        x = t
        m = minimum(X[x,:])
    end
    #println("Dernier point visité ", x)
    etat[x] = 1
    succ[x] = dep
    push!(parc,dep)
    #println("E : ", etat)
    #println("S : ", succ)
    #println("P : ", parc)

    #return parc
    return succ
end

function calculCout(C::Array{Int64,2},P::Array{Int64,1})
    T = 0
    nbPoint = size(P,1)
    i = 1
    x = 1
    while i <= nbPoint
        #println("i = " , x, " | i+1 = ", P[x])
        #println("   Cout arc (",x,",",P[x],") = ", C[x,P[x]])
        T = T + C[x,P[x]]
        #println("   CumSum ", T)
        i = i + 1
        x = P[x]
    end
    return T
end


function opt2(P::Array{Int64,1})
    nbSommet = size(P,1)
    ## Le point de départ
    x = 1
    amelio = false
    println("Parcours de base :")
    println(P)
    println("##################")
    #cpt = 1
    #while (amelio == false && cpt <= nbSommet)
    while (amelio == false)
        #amelio = false
        for i in 1:nbSommet
            #println("x = ", x , "| P[x] = ", P[x])
            println("Arc Base : (", x,",",P[x],")")
                #y =P[x]
                y = P[P[x]]
                for j in 1:nbSommet-3
                    #println("   y = ", y,"| P[y] = ", P[y])
                    #println("   Arc Pivot : (", y,",",P[y],")")
                    ###########################################
                    ### Etude Delta :
                    delta = 0
                    # arête (i,j) = (x,P[x])
                    # arête (i',j') = (y,P[y])- non consécutive à (i,j)
                    #println("       Arêtes étudiées (i = ",x,",j = ",P[x],") et (i' = ",y,", j' = ",P[y],").")
                    ## Cii' : C1
                    #println("          Cii' => Coût (",x,",",y,") = ", C[x,y])
                    C1 = C[x,y]
                    ## Cjj' : C2
                    #println("          Cjj' => Coût (",P[x],",",P[y],") = ", C[P[x],P[y]])
                    C2 = C[P[x],P[y]]
                    ## Cij : C3
                    #println("          Cij => Coût (",x,",",P[x],") = ", C[x,P[x]])
                    C3 = C[x,P[x]]
                    ## Ci'j' : C4
                    #println("          Ci'j' => Coût (",y,",",P[y],") = ", C[y,P[y]])
                    C4 = C[y,P[y]]
                    ## Delta = A + B - C - D
                    delta = C1 + C2 - C3 - C4
                    println("           Δ((",x,",",P[x],");(",y,",",P[y],") = ", delta)
                    if (delta < 0 )
                        println("Solution améliorante : : ")
                        println(P)
                        println("           Δ((i = ",x,", j = ",P[x],");(i' = ",y,", j' = ",P[y],") = ", delta)
                        ## Modication à effectuer :
                        ### (i=x,j=P[x]) devient (i=x,i'=y) (1)
                        ### (i'=y,j'=P[y]) devient (j=P[x],j'=P[y])
                        ### CF Image Tableau
                        #println("i - x = ", x)
                        #println("j - P[x]= ",P[x])
                        #println("i' - y = ", y)
                        #println("j' - P[y]= ",P[y])

                        ########
                        #tmpx = P[x]
                        tmpy = P[y]
                        P[y]=P[x]
                        P[x] = y
                        P[P[y]] = tmpy
                        println(P)
                        amelio = true
                    end
                ###########################################
                    y = P[y]
                end
                x = P[x]
            end
            println(P)
            #calculCout(C,P)
            #cpt = 1 + cpt
    end
    return P
end

C = parseTSP("plat/plat20.dat")
X = parseTSP("plat/plat20.dat")

P = procheVoisin(X,1)
Tp = calculCout(C,P)
O = opt2(P)
F = calculCout(C,O)
















## PATH MAC
## cd Desktop/ÉTUDES/FAC/S6/RO/TP/3TP/projetRO

## m est notre modèle

# Matrice des contraintes :
#=
C = parseTSP("plat/exemple.dat")
m = TSP(C)
status = solve(m)
imp(m)

## Attention : xval ne sont pas les variables de décisions mais les valeurs de variables - xval est un alias bien pratique
## x représente les variables de décision du modèle :
xval = getvalue(m[:x])
P=permutation(xval)
=#

#=
    nbPoint = size(P,1)
    etat = zeros(Int64,nbPoint)
    pere = zeros(Int64,nbPoint)

    cycle = explorer(P,etat,pere)
    ## tester ici nbcycle = length(cycle)

=#
#=
ind = ind_min(cycle)
## cycle à détruire.
destr = cycle[ind]
i = destr[1]
j = destr[2]


x=m[:x]
expr = AffExpr()
push!(expr,1.0,x[i,j])
push!(expr,1.0,x[j,i])
## @constraint(m::Model, con) - add linear or quadratic constraints.
con = @constraint(m,expr <= 1)


## julia> m
## Minimization problem with:
## * 28 linear constraints
## * 49 variables: 49 binary
## julia> con = @constraint(m,expr <= 1)
## x[2,6] + x[6,2] ≤ 1
## julia> m
## Minimization problem with:
## * 29 linear constraints
## * 49 variables: 49 binary
## Solver is GLPKInterfaceMIP

status = solve(m)
imp(m)
xval = getvalue(m[:x])
P=permutation(xval)


nbPoint = size(P,1)
etat = zeros(Int64,nbPoint)
pere = zeros(Int64,nbPoint)

cycle = explorer(P,etat,pere)
length(cycle)





CONTINUER A TROUVER LES CYCLES ET SOLVER LE PROBLEME TANT QUE LE NOMBRE DE CYCLE EST DIFFERENT DE 1
## NECESSITE UNE AUTOMATISATION A BASE DE TANT QUE.
Idée : au début, pour initialiser la boucle, on peut définir le compteur nbcycle = 0.
Tant quu'il n'y a pas au moins un cycle. continuer le processus de suppression




=#




## Attention, le distancier est symétrique, il est donc possible de trouver deux cycles différents.




#=
## Déclaration permutations suivantes pour test
T = [7;5;4;3;6;2;1]


=#



#=
    Idée, utiliser la commande push! ajouter progressivement dans le modele les contraintes de cassage de cycle que l'on va trouvé
=#
