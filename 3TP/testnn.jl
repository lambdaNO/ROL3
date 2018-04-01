#=
C = [
10000	374	200	223	108	178	252	285	240	356;
374	10000	255	166	433	199	135	95	136	17;
200	255	10000	128	277	128	180	160	131	247;
223	166	128	10000	430	47	52	84	40	155;
108	433	277	430	10000	453	478	344	389	423;
178	199	128	47	453	10000	91	110	64	181;
252	135	180	52	478	91	10000	114	83	117;
285	965	160	84	344	110	114	10000	47	78;
240	136	131	40	389	64	83	47	10000	118;
356	17	247	155	423	117	118	78	118	10000
]=#
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
=#


###################################################
###################################################
###################################################

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

    return parc
    #return succ
end

X

C

parc = procheVoisin(X,1)

function calculCout(X::Array{Int64,2},V::Array{Int64,1})
    T = 0
    nbPoint = size(V,1)
    i = 1
    while i < nbPoint
        println("i = " , V[i], "| i+1 = ", V[i + 1])
        println("Cout arc (",V[i],",",V[i+1],") = ", X[V[i],V[i+1]])
        T = T + X[V[i],V[i+1]]
        i = i + 1
    end
    println(T)
    return T
end
