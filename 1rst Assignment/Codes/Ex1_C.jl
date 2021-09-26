using AbstractAlgebra
using SymPy

#Define the 3 rows x 4 columns matrix space over the rationals.
S = MatrixSpace(QQ,3,4)

#Set the matrix with the three projectivized R^3 as row vectors.
M = S([1 2 3 3;
       1 3 2 3; 
       1 3 3 2])

#Compute the kernel of the above matrix. 
#Let d be the dimension of the kernel.
#Let r be a kernel representative.
d, r = kernel(M)

#Defining equation symbols.
x, y, z = sympy.symbols("x y z")

#Define the asked equation.
Eq(r[2,1]*x + r[3,1]*y + r[4,1]*z, r[1,1])