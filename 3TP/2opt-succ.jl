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
        println("E : ", etat)
        println("S : ", succ)
        println("P : ", parc)
        x = t
        m = minimum(X[x,:])
    end
    println("Dernier point visité ", x)
    etat[x] = 1
    succ[x] = dep
    push!(parc,dep)
    println("E : ", etat)
    println("S : ", succ)
    println("P : ", parc)

    #return parc
    return succ
end
function calculCout(C::Array{Int64,2},P::Array{Int64,1})
    T = 0
    nbPoint = size(P,1)
    i = 1
    x = 1
    while i <= nbPoint
        println("i = " , x, " | i+1 = ", P[x])
        println("   Cout arc (",x,",",P[x],") = ", C[x,P[x]])
        T = T + C[x,P[x]]
        println("   CumSum ", T)
        i = i + 1
        x = P[x]
    end
    return T
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

function opt2(X::Array{Int64,1})
    nbSommet = size(X,1)
    ## Le point de départ
    x = 1
    amelio = false
    println("Parcours de base :")
    println(P)
    println("##################")
    cpt = 1
    while (amelio == false && cpt <= nbSommet)
        #amelio = false
        for i in 1:nbSommet
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
            cpt = 1 + cpt
    end
    return X
end


#C = parseTSP("relief/relief150.dat")
#X = parseTSP("relief/relief150.dat")

P = procheVoisin(X,1)
T = calculCout(C,P)
O = opt2(P)
F = calculCout(C,O)
## Variation constaté
Var = T - F
println("Delta coût : ", Var )
