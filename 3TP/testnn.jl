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
## Je lui passe en entrée une matrice de cout et un point de départ


function procheVoisin(C::Array{Int64,2},dep::Int64)
#dep = 1
nbPoint = size(C,1)
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
    println(C[x,:])
    println("Min de la ligne ",x," = ", minimum(C[x,:]), " atteint au point ", indmin(C[x,:]))
    t = indmin(C[x,:])
    C[:,x] = 10000
    succ[x] = t
    etat[x] = 1
    push!(parc,t)
    C
    println("E : ", etat)
    println("S : ", succ)
    println("P : ", parc)
    x = t
    m = minimum(C[x,:])
end
println("Dernier point visité ", x)
etat[x] = 1
succ[x] = dep
push!(parc,dep)
println("E : ", etat)
println("S : ", succ)
println("P : ", parc)

    return succ
end
