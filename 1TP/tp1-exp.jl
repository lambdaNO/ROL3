using JuMP, GLPKMathProgInterface
# Déclaration d'un mdoèle vide :
m = Model(solver = GLPKSolverMIP())
# Déclaration des variables de décisions
## i \in |[1,12]|
###
@variable(m,x[1:12]>= 0,Int)
@variable(m,y[1:12]>= 0,Int)
# Indicer le tableau à partir de 0 pour prendre en compte le stock initial
@variable(m,s[0:12]>= 0,Int)

#d = [30000,15000,15000,25000,33000,40000,45000,45000,26000,14000,25000,30000]

d = 1000*[30,15,15,25,33,40,45,45,26,14,25,30]

@objective(m,Min, 6000 + sum(20*x[i]for i in 1:12)+sum(30*y[i]for i in 1:12)+sum(3*s[i]for i in 1:12))
# ERROR: The operators <=, >=, and == can only be used to specify scalar constraints. If you are trying to add a vectorized constraint, use the element-wise dot comparison operators (.<=, .>=, or .==) instead
@constraint(m,Kpa,x.<=30000)
# Imposer une valeur au stock initial
@constraint(m,sInit,s[0]==2000)
# Bien nommer ses contraintes pour pouvoir faire varier l'indicage
@constraint(m,Gnrl[i=1:12],(x[i]+y[i]+s[i-1]-s[i]==d[i]))
#=
julia> status = solve(m)
=#
function imp(m)
    if status == :Optimal
        println("Problème résolu à l'optimalité")
        println("z = ",getobjectivevalue(m)," €") # affichage de la valeur optimale
        println("x = ",getvalue(m[:x])) # affichage des valeurs du vecteur de variables - Heures de production normales
        println("y = ",getvalue(m[:y])) # affichage des valeurs du vecteur de variables - Heures de production supplémentaires
        println("s = ",getvalue(m[:s])) # affichage des valeurs du vecteur de variables - Quantités en stock
    elseif status == :Unbounded
        println("Problème non-borné")
    elseif status == :Infeasible
        println("Problème impossible")
    end
end
