# input
function read_point()
	p_str = split(readline())
	if length(p_str) != 2
		throw(ArgumentError("points should have two coordinates"))
	end
	return map(x -> parse(Float64, x), p_str)
end

A, B, C, D = read_point(), read_point(), read_point(), read_point()


# homogenous coordinates
to_homogenous_coordinates(x) = [1, x...]
from_homogenous_coordinates(x) = map(xi -> xi/x[1], x[2:end]) # will fail for points at infinity
hA, hB, hC, hD = map(to_homogenous_coordinates, [A, B, C, D])


# geometry helper functions
function find_perpendicular(v1, v2)
	# given two vectors v1, v2, finds a v3 perpendicular to both
	# serves as coefficients of the equation of a subspace containing v1, v2
	return [v1[2]*v2[3]-v1[3]*v2[2], v1[3]*v2[1]-v1[1]*v2[3], v1[1]*v2[2]-v1[2]*v2[1]]
end

function intersect_projective_lines(hp1, hp2, hp3, hp4)
	# returns the unique point at the intersection of p1p2 and p3p4
	# (some duality business)
	return find_perpendicular(find_perpendicular(hp1, hp2), find_perpendicular(hp3, hp4))
end

function divide_projective_quadrangle(hA, hB, hC, hD)
	# compute relevant points
	hX = intersect_projective_lines(hA, hB, hD, hC)
	hY = intersect_projective_lines(hA, hD, hB, hC)
	hO = intersect_projective_lines(hA, hC, hB, hD)

	# compute vertices of subdivision
	hAB = intersect_projective_lines(hA, hB, hY, hO)
	hCD = intersect_projective_lines(hC, hD, hY, hO)
	hBC = intersect_projective_lines(hB, hC, hX, hO)
	hDA = intersect_projective_lines(hD, hA, hX, hO)

	return hAB, hBC, hCD, hDA, hO
end

divide_quadrangle(A, B, C, D) = map(from_homogenous_coordinates,
									divide_projective_quadrangle(map(to_homogenous_coordinates,
																	 [A, B, C, D])...))

AB, BC, CD, DA, O = divide_quadrangle(A, B, C, D)


#output
println(AB)
println(BC)
println(CD)
println(DA)
println(O)