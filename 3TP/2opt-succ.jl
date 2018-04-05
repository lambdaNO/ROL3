
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


C = [0 59 76 56 49 39 44 31 1 27 90 23 67 92 10 10 7 86 79 97; 59 0 92 70 82 41 2 86 15 38 16 68 49 93 24 99 84 20 82 85; 76 92 0 67 17 70 77 24 8 56 73 88 44 17 58 78 58 13 17 74; 56 70 67 0 26 18 51 11 39 86 48 39 10 9 58 27 31 87 4 40; 49 82 17 26 0 38 18 5 51 35 31 54 69 25 7 47 96 58 58 87; 39 41 70 18 38 0 34 51 23 90 43 71 68 23 11 15 62 82 20 65; 44 2 77 51 18 34 0 77 89 48 64 86 59 42 45 79 78 79 83 54; 31 86 24 11 5 51 77 0 23 77 81 92 81 5 35 63 84 73 92 74; 1 15 8 39 51 23 89 23 0 47 36 10 26 13 0 28 2 57 96 25; 27 38 56 86 35 90 48 77 47 0 45 55 85 57 40 36 66 57 18 7; 90 16 73 48 31 43 64 81 36 45 0 14 88 22 35 75 27 70 94 9; 23 68 88 39 54 71 86 92 10 55 14 0 97 92 5 17 14 19 39 42; 67 49 44 10 69 68 59 81 26 85 88 97 0 18 4 33 27 28 53 41; 92 93 17 9 25 23 42 5 13 57 22 92 18 0 40 33 37 85 25 55; 10 24 58 58 7 11 45 35 0 40 35 5 4 40 0 54 53 82 93 93; 10 99 78 27 47 15 79 63 28 36 75 17 33 33 54 0 15 77 92 70; 7 84 58 31 96 62 78 84 2 66 27 14 27 37 53 15 0 30 17 57; 86 20 13 87 58 82 79 73 57 57 70 19 28 85 82 77 30 0 50 24; 79 82 17 4 58 20 83 92 96 18 94 39 53 25 93 92 17 50 0 11; 97 85 74 40 87 65 54 74 25 7 9 42 41 55 93 70 57 24 11 0]

X = [0 59 76 56 49 39 44 31 1 27 90 23 67 92 10 10 7 86 79 97; 59 0 92 70 82 41 2 86 15 38 16 68 49 93 24 99 84 20 82 85; 76 92 0 67 17 70 77 24 8 56 73 88 44 17 58 78 58 13 17 74; 56 70 67 0 26 18 51 11 39 86 48 39 10 9 58 27 31 87 4 40; 49 82 17 26 0 38 18 5 51 35 31 54 69 25 7 47 96 58 58 87; 39 41 70 18 38 0 34 51 23 90 43 71 68 23 11 15 62 82 20 65; 44 2 77 51 18 34 0 77 89 48 64 86 59 42 45 79 78 79 83 54; 31 86 24 11 5 51 77 0 23 77 81 92 81 5 35 63 84 73 92 74; 1 15 8 39 51 23 89 23 0 47 36 10 26 13 0 28 2 57 96 25; 27 38 56 86 35 90 48 77 47 0 45 55 85 57 40 36 66 57 18 7; 90 16 73 48 31 43 64 81 36 45 0 14 88 22 35 75 27 70 94 9; 23 68 88 39 54 71 86 92 10 55 14 0 97 92 5 17 14 19 39 42; 67 49 44 10 69 68 59 81 26 85 88 97 0 18 4 33 27 28 53 41; 92 93 17 9 25 23 42 5 13 57 22 92 18 0 40 33 37 85 25 55; 10 24 58 58 7 11 45 35 0 40 35 5 4 40 0 54 53 82 93 93; 10 99 78 27 47 15 79 63 28 36 75 17 33 33 54 0 15 77 92 70; 7 84 58 31 96 62 78 84 2 66 27 14 27 37 53 15 0 30 17 57; 86 20 13 87 58 82 79 73 57 57 70 19 28 85 82 77 30 0 50 24; 79 82 17 4 58 20 83 92 96 18 94 39 53 25 93 92 17 50 0 11; 97 85 74 40 87 65 54 74 25 7 9 42 41 55 93 70 57 24 11 0]



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
        #println("Recherche du succ de ", x)
        #println(X[x,:])
        #println("Min de la ligne ",x," = ", minimum(X[x,:]), " atteint au point ", indmin(X[x,:]))
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
    println("E : ", etat)
    println("S : ", succ)
    println("P : ", parc)
    #return parc
    return succ
end





###############################################################
###############################################################
###############################################################
## Pour tout sommet xi de H faire


### Etape 1 : on va déjà lui demander qu'à partir d'un sommet, il affiche le sommet des autres
### On est sur des cycles - On sait que ça termine.
### On connait le nombre d'arc dans ce graphe (c'est nbSommet - 1)
#dep = 1
#x = P[dep]

function opt2(P::Array{Int64,1})
    nbSommet = size(P,1)
    ## Le point de départ
    x = 1
    amelio = false
    println("##################")
    println("Parcours de base :")
    println(P)
    println("##################")
    cpt = 1
    while (amelio == false)
    #while (amelio == false && cpt <= nbSommet)
        #amelio = false

        #for i in 1:nbSommet
        while(P[x]!=1 && amelio != true)
            println("x = ", x , "| P[x] = ", P[x])
            #println("x = ", x , "| P[x] = ", P[x])
            #println("Arc Base : (", x,",",P[x],")")
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
                        println("Δ < 0 trouvé : ")
                        println("       ",P)
                        ## IDEE : Sauvegarder par copie profonde le trajet initiale
                        R = copy(P)
                        println("           Δ((i = ",x,", j = ",P[x],");(i' = ",y,", j' = ",P[y],") = ", delta)
                        ## Modication à effectuer : (i=x,j=P[x]) devient (i=x,i'=y) (1) | (i'=y,j'=P[y]) devient (j=P[x],j'=P[y])
                        #println("i - x = ", x);println("j - P[x]= ",P[x]);println("i' - y = ", y);println("j' - P[y]= ",P[y])

                        ########
                        tmpy = P[y]
                        P[y]=P[x]
                        P[x] = y
                        P[P[y]] = tmpy
                        #println(P)
                        println("Avant : ", R)
                        println("Après : ", P)
                        println("Cout AVANT ", calculCout(C,R))
                        println("Cout APRES ", calculCout(C,P))

                        if (calculCout(C,R) > calculCout(C,P))
                            println(" > Coût inférieur obtenu avec cette nouvelle solution -> Solution améliorante.")
                            amelio = true
                        else
                            println(" > Coût supérieur obtenu avec cette nouvelle solution -> Solution non améliorante.")
                            ## On continu la recherche d'une solution améliorante avec l'ancien parcours
                            #P = copy(R) # L'utilisation de la copie profonde ne change rien ici
                            #P = R
                        end
                        println("APRESSI ", P)
                    end
                ###########################################
                    y = P[y]
                end
                x = P[x]
            end
    end
    return P
end


#C = parseTSP("relief/relief150.dat")
#X = parseTSP("relief/relief150.dat")

P = procheVoisin(X,1)
CoutAV = calculCout(C,P)
O = opt2(P)
CoutAP = calculCout(C,O)
## Variation constaté
println("Cout AV = ", CoutAV)
println("Cout AP = ", CoutAP)

Var =  CoutAP - CoutAV
println("Delta coût : ", Var )
