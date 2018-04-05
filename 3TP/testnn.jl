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
]

X = [
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
]

=#
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

function calculCout(X::Array{Int64,2},V::Array{Int64,1})
    T = 0
    nbPoint = size(V,1)
    i = 1
    while i <= nbPoint
        println("i = " , V[i], "| i+1 = ", V[i + 1])
        println("Cout arc (",V[i],",",V[i+1],") = ", X[V[i],V[i+1]])
        T = T + X[V[i],V[i+1]]
        i = i + 1
    end
    println(T)
    return T
end


function twoOPT(X::Array{Int64},V::Array{Int64,1})
    println(V)
end

## Deux arêtes sont consécutives si elles sont de la forme (i,j) (j,k) ou (i,j) (k,i)
## On peut parcourir le vecteur parc contenant les éléments

P = procheVoisin(X,1)
T = calculCout(C,P)

#####################################################################################
## On soustrait 1 à nbPoint pour récupérer le cycle sans le point de départ à la fin.
nbPoint = length(P) - 1
for a in 1:(nbPoint)
    #println("Arc (",i,",",i+1,").")
    println("a - Arc (",P[a],",",P[a+1],").")
    for b in (a+2):(nbPoint-1)
        println("   b - Arc (",P[b],",",P[b+1],").")
    end
end



#=
nbPoint = length(P)
theta = 0
for i in 1:(nbPoint)
    println("> (",P[i],",",P[i+1],")")
    for j in (i+2):(nbPoint-1)
        println("   > (",P[j],",",P[j+1],")")
        # (a,b) = (i,i+1)
        # (a',b') = (j,j+1)
        # delta = c(i,j)

        #println("Dist (",P[i],",",P[j],") = ", C[i,j])
        #println("Dist (",P[i+1],",",P[j+1],") = ", C[i+1,j+1])
        #println("Dist (",P[i],",",P[i+1],") = ", C[i,i+1])
        #println("Dist (",P[j],",",P[j+1],") = ", C[j,j+1])

        println()
    end
    println()
end

=#


#=

http://labo.algo.free.fr/pvc/algorithme_2opt.html

EN java

http://www.technical-recipes.com/2017/applying-the-2-opt-algorithm-to-traveling-salesman-problems-in-java/

wiki :


Voici une transcription directe appliquée au cas du voyageur de commerce géométrique :

fonction 2-opt ( G : Graphe, H : CycleHamiltonien )

    amélioration : booléen := vrai
    Tant que amélioration = vrai faire

        amélioration := faux;
        Pour tout sommet xi de H faire

            Pour tout sommet xj de H, avec j différent de i-1, de i et de i+1 faire

                Si distance(xi, xi+1) + distance(xj, xj+1) > distance(xi, xj) + distance(xi+1, xj+1) alors

                    Remplacer les arêtes (xi, xi+1) et (xj, xj+1) par (xi, xj) et (xi+1, xj+1) dans H
                    amélioration := vrai;

    retourner H
=#
