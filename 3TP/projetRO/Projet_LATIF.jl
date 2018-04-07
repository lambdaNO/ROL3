
#= LATIF - Mehdi
   681 - Maths info
   Life on Mars - Licence 3 - 2017/2018
   ##############################################
   ## PATH MAC
   ## cd Desktop/ÉTUDES/FAC/S6/RO/TP/3TP/projetRO
 =#

using JuMP, GLPKMathProgInterface

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
    Contraintes devenues redondantes après l'ajout de l'expression "if != j" dans la contrainte 2
=#
    return m
end

function imp(m::Model)
    if status == :Optimal
        println("> temps total = ",getobjectivevalue(m))
        #println(f,"> temps total = ",getobjectivevalue(m))
        #println("Ordre de visite des points :", permutation(getvalue(m[:x])))
    elseif status == :Unbounded
        println("Problème non-borné")
    elseif status == :Infeasible
        println("Problème impossible")
    end
end


#= Fonction qui résout l'ensemble des instances du projet avec la méthode de résolution exacte,
   le temps d'exécution de chacune des instances est mesuré =#
#=
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
=#
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
        #println(f,"   Permutations :")
        for i in 1:nbPoint
            for j in 1:nbPoint
                if (X[i,j]==1)
                    print("(",i," -> ",j,") ")
                    #print(f,"(",i," -> ",j,") ")
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
            ## Il n'a pas été visité pour le moment. Il est potentiellement le départ d'un nouveau (sous) cycle
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
        #print(f,C[i]," -> ")
    end
    print(C[1],". ")
    #print(f,C[1],". ")
    println()
    #println(f,"")
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

function procheVoisin(X::Array{Int64,2},dep::Int64)
    println("Proches voisins ")
    #println(f,"Proches voisins ")
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
    ## Ajout d'éléments infini (10000) sur la diagonale pour le calcul des plus proches voisins - Permet d'éviter qu'un
    ## élément ne soit lui même son plus proche voisin.
    for i in 1:size(C,1) X[i,i] = 10000 end

    while (m!= 10000)
        #println("Recherche du succ de ", x)#println(X[x,:])#println("Min de la ligne ",x," = ", minimum(X[x,:]), " atteint au point ", indmin(X[x,:]))
        t = indmin(X[x,:])
        X[:,x] = 10000
        succ[x] = t
        etat[x] = 1
        push!(parc,t)
        #println("E : ", etat) #println("S : ", succ) #println("P : ", parc)
        x = t
        m = minimum(X[x,:])
    end
    #println("Dernier point visité ", x)
    etat[x] = 1
    succ[x] = dep
    push!(parc,dep)
    #println("E : ", etat)#println("S : ", succ)
    println("P : ", parc)
    #println(f,"P : ", parc)
    return succ
end

function opt2(P::Array{Int64,1},dep::Int64)
    ## P, le parcours initial
    nbSommet = size(P,1)
    ## Le point de départ
    x = dep
    amelio = false
    cpt = 0
    nbcompa = 0
    println("Parcours de base :")
    println(P)
    println("Coût de base :")
    println(calculCout(C,P))
    println("##################")

    # println(f,"Parcours de base :")
    # println(f,P)
    # println(f,"Coût de base :")
    # println(f,calculCout(C,P))
    # println(f,"##################")

    while (amelio == false)
        while(P[x]!=1 && amelio != true)
            #println("x = ", x , "| P[x] = ", P[x])
            #println("Arc Base : (", x,",",P[x],")")
                y = P[P[x]]
                for j in 1:nbSommet-3
                    nbcompa = nbcompa + 1
                    #println("   y = ", y,"| P[y] = ", P[y]) #
                    #println("   Arc Pivot : (", y,",",P[y],")")
                    ###########################################
                    ###########################################
                    ### Etude Delta :
                    delta = 0
                    # arête (i,j) = (x,P[x]) - # arête (i',j') = (y,P[y])- non consécutive à (i,j)
                    #println("       Arêtes étudiées (i = ",x,",j = ",P[x],") et (i' = ",y,", j' = ",P[y],").") - ## Cii' : C1 -#println("          Cii' => Coût (",x,",",y,") = ", C[x,y])
                    C1 = C[x,y]
                    ## Cjj' : C2 - #println("          Cjj' => Coût (",P[x],",",P[y],") = ", C[P[x],P[y]])
                    C2 = C[P[x],P[y]]
                    ## Cij : C3 - #println("          Cij => Coût (",x,",",P[x],") = ", C[x,P[x]])
                    C3 = C[x,P[x]]
                    ## Ci'j' : C4 - #println("          Ci'j' => Coût (",y,",",P[y],") = ", C[y,P[y]])
                    C4 = C[y,P[y]]
                    ## Delta = A + B - C - D
                    delta = C1 + C2 - C3 - C4
                    #println("           Δ((",x,",",P[x],");(",y,",",P[y],") = ", delta)
                    if (delta < 0 )
                        cpt = cpt + 1
                        println("#########################################################################################")
                        println("Δ < 0 trouvé : ")
                        #println(f,"#########################################################################################")
                        #println(f,"Δ < 0 trouvé : ")
                        # Création d'une copie profonde du trajet initial pour amélioration potentielle
                        T = copy(P)
                        println("           Δ((i = ",x,", j = ",T[x],");(i' = ",y,", j' = ",T[y],") = ", delta)
                        #println(f,"           Δ((i = ",x,", j = ",T[x],");(i' = ",y,", j' = ",T[y],") = ", delta)
                        ## Modication à effectuer : (i=x,j=P[x]) devient (i=x,i'=y) (1) | (i'=y,j'=P[y]) devient (j=P[x],j'=P[y])
                        #println("i - x = ", x);println("j - P[x]= ",P[x]);println("i' - y = ", y);println("j' - P[y]= ",P[y])
                        ## Modification dans T (la copie)
                        tmpy = T[y]
                        T[y]=T[x]
                        T[x] = y
                        T[T[y]] = tmpy
                        println("           Parcours initial : ", P)
                        println("           Parcours modifié : ", T)
                        println("           Coût init ", calculCout(C,P), " - Coût modif ", calculCout(C,T))
                        println("           Variation de coût : ", calculCout(C,T) - calculCout(C,P))

                        #println(f,"           Parcours initial : ", P)
                        #println(f,"           Parcours modifié : ", T)
                        #println(f,"           Coût init ", calculCout(C,P), " - Coût modif ", calculCout(C,T))
                        #println(f,"           Variation de coût : ", calculCout(C,T) - calculCout(C,P))


                        ## Si la solution obtenue après amélioration (T) possède un cout inférieur à la solution de départ (P).
                        ## Alors T devient le nouveau parcours
                        ## Sinon, on continu à chercher
                        if (calculCout(C,P) > calculCout(C,T))
                            println("           > Coût inférieur obtenu avec ce nouveau parcours -> Solution améliorante.")
                            #println(f,"           > Coût inférieur obtenu avec ce nouveau parcours -> Solution améliorante.")

                            P = copy(T)
                            amelio = true
                        else
                            println("           > Coût supérieur obtenu avec ce nouveau parcours -> Solution non améliorante.")
                            #println(f,"           > Coût supérieur obtenu avec ce nouveau parcours -> Solution non améliorante.")
                        end
                        println("           Parcours retourné : ", P)
                        println("#########################################################################################")
                        #println(f,"           Parcours retourné : ", P)
                        #println(f,"#########################################################################################")
                    end
                ###########################################
                    y = P[y]
                end
                x = P[x]
            end
            amelio = true # Je le rajoute sinon on boucle à l'infini si il ne trouve pas de solution améliorante
    end
    #println(f,"Nombre de solutions potentiellement améliorantes détectées : ", cpt)
    println("Nombre de solutions potentiellement améliorantes détectées : ", cpt)
    println("Nombre de comparaisons effectuées : ", nbcompa)

    return P
end

#######################################################################
#######################################################################
#######################################################################
#######################################################################
#######################################################################
#######################################################################

#C = parseTSP("plat/exemple.dat")

#C = parseTSP("relief/relief10.dat")

#Nom = "plat/exemple.dat"
# Nom = "plat/plat10.dat"
# Nom = "plat/plat20.dat"
# Nom = "plat/plat30.dat"
# Nom = "plat/plat40.dat"
# Nom = "plat/plat50.dat"
# Nom = "plat/plat60.dat"
# Nom = "plat/plat70.dat"
# Nom = "plat/plat80.dat"
# Nom = "plat/plat90.dat"
# Nom = "plat/plat100.dat"
# Nom = "plat/plat110.dat"
# Nom = "plat/plat120.dat"
# Nom = "plat/plat130.dat"
# Nom = "plat/plat140.dat"
# Nom = "plat/plat150.dat"


# Nom = "relief/relief10.dat"
# Nom = "relief/relief20.dat"
# Nom = "relief/relief30.dat"
# Nom = "relief/relief40.dat"
# Nom = "relief/relief50.dat"
# Nom = "relief/relief60.dat"
# Nom = "relief/relief70.dat"
# Nom = "relief/relief80.dat"
# Nom = "relief/relief90.dat"
# Nom = "relief/relief100.dat"
# Nom = "relief/relief110.dat"
# Nom = "relief/relief120.dat"
# Nom = "relief/relief130.dat"
# Nom = "relief/relief140.dat"
# Nom = "relief/relief150.dat"
#=
C = parseTSP(Nom)

C = parseTSP(Nom)
outfile = Nom*"EXA - res.txt"
# writing to files is very similar:
f = open(outfile, "w")
# both print and println can be used as usual but with f as their first arugment
=#

################################################################################
################################################################################
################################################################################
##########################    EXACTE  ##########################################
################################################################################
################################################################################
################################################################################
#=
@time begin
    #println(f,"Résolution exacte pour ", Nom ," points à visiter :")
    println("Résolution exacte pour ", Nom ," points à visiter :")
    nbiter = 1
    nbcycle = 0
    ## Compteur d'itération avant l'obtention d'une solution optimale par la solution exacte
    nbiter = 1
    ## Compteur du nombre de contrainte ajoutées
    nbctr = 0
    ## Vecteur de taille des contraintes à casser - Partie expérimentale
    Tctr = [0]
    #######################################################################
    #######################################################################
    #println(f,"Résolution d'initiale :  ")
    println("Résolution d'initiale :  ")
    m = TSP(C)
    status = solve(m)
    imp(m)
    ## Attention : xval ne sont pas les variables de décisions mais les valeurs de variables - xval est un alias bien pratique
    ## x représente les variables de décision du modèle : xval = getvalue(m[:x]) P=permutation(xval)
    P = permutation(getvalue(m[:x]))
    nbPoint = size(P,1)
    etat = zeros(Int64,nbPoint)
    pere = zeros(Int64,nbPoint)
    cycle = explorer(P,etat,pere)
    #println(f,"> Cycle(s) trouvé(s) : ", cycle)
    println("> Cycle(s) trouvé(s) : ", cycle)
    nbcycle = length(cycle)
    #println(f,"> Nombre de cycle(s) trouvé(s) : ",nbcycle)
    println("> Nombre de cycle(s) trouvé(s) : ",nbcycle)
    println()
#######################################################################
#######################################################################
    while(nbcycle!= 1)
        #println(f,"Itération n° ", nbiter," Cassage de contrainte ")
        println("Itération n° ", nbiter," Cassage de contrainte ")
        ind = ind_min(cycle)
        aCasser = cycle[ind]
        ## ex : aCasser = [5, 8, 14, 13, 15]
        #println(f,"> Cycle à casser : ", aCasser)
        println("> Cycle à casser : ", aCasser)
        ## Récupérer la taille du cycle
        tailleACasser = length(aCasser)
        #println(f,"> Taille du cycle à casser : ", tailleACasser)
        println("> Taille du cycle à casser : ", tailleACasser)
        push!(Tctr,tailleACasser)
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
        #println(f,"> Nouvelle contrainte : ", con)
        println("> Nouvelle contrainte : ", con)
        nbctr = nbctr + 1
        println()
        #println(f,"> Nouvelle résolution après ajout de la nouvelle contrainte !")
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
        #println(f,"> Cycle(s) trouvé(s) : ", cycle)
        println("> Cycle(s) trouvé(s) : ", cycle)
        nbcycle = length(cycle)
        #println(f,"> Nombre de cycle(s) trouvé(s) : ",nbcycle)
        println("> Nombre de cycle(s) trouvé(s) : ",nbcycle)
        #println(f,"")
        println()
    end
    ################################################################################
    ################################################################################
    ## Au sortir de la boucle, on est sûr d'avoir casser tous les sous cycles et de n'avoir qu'un seul cycle
    #println(f,"FIN - Problème résolu :")
    println("FIN - Problème résolu :")
    imp(m)
    println("> Nombre d'itération nécéssaires : ", nbiter)
    #println(f,"> Nombre d'itération nécéssaires : ", nbiter)
    println("> Nombre de contraintes ajoutées : ", nbctr)
    #println(f,"> Nombre de contraintes ajoutées : ", nbctr)
    println("> Ordre de parcours des drônes : ")
    #println(f,"> Ordre de parcours des drônes : ")
    imp_cycle(cycle[1])
    ## Affichage des tailles de contraintes à casser - Analyse expérimentale
    #shift!(Tctr)
    #println(Tctr)
    #println(length(Tctr))
end

#close(f)
=#


################################################################################
################################################################################
################################################################################
##########################    APPROCHÉE  #######################################
################################################################################
################################################################################
################################################################################
## ATTENTION DANS CE CAS LÀ, LE DISTANCIER DOIT ÊTRE SYMÉTRIQUE

#Nom = "plat/exemple.dat"
# Nom = "plat/plat10.dat"
# Nom = "plat/plat20.dat"
# Nom = "plat/plat30.dat"
# Nom = "plat/plat40.dat"
# Nom = "plat/plat50.dat"
# Nom = "plat/plat60.dat"
# Nom = "plat/plat70.dat"
# Nom = "plat/plat80.dat"
# Nom = "plat/plat90.dat"
# Nom = "plat/plat100.dat"
# Nom = "plat/plat110.dat"
# Nom = "plat/plat120.dat"
# Nom = "plat/plat130.dat"
# Nom = "plat/plat140.dat"
# Nom = "plat/plat150.dat"

#=
C = parseTSP(Nom)
#outfile = Nom*"APP - res.txt"
# writing to files is very similar:
#f = open(outfile, "w")
# both print and println can be used as usual but with f as their first arugment
    #println(f,"Résolution approchée pour ", Nom ," points à visiter :")
    println("Résolution approchée pour ", Nom ," points à visiter :")
    ## Création d'une copie de la matrice que l'on va dégrader pour la recherche des plus proches voisins
    X = copy(C)
    ## Point de départ de la recherche
    dep = 1
    P = procheVoisin(X,dep)
    CoutAV = calculCout(C,P)
    @time begin
        O = opt2(P,dep)
    end
    CoutAP = calculCout(C,O)
    ## Variation constatée
    println("Cout AV = ", CoutAV)
    println("Cout AP = ", CoutAP)
    #println(f,"Cout AV = ", CoutAV)
    #println(f,"Cout AP = ", CoutAP)
    Var =  CoutAP - CoutAV
    println("Delta coût : ", Var )
    #println(f,"Delta coût : ", Var )
    println("Parcours final : ",O)
    #println(f,"Parcours final : ",O)

#close(f)
=#
