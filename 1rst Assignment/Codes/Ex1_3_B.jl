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


hA, hB, hC, hD = map(to_homogenous_coordinates, [A, B, C, D])

hX = intersect_projective_lines(hA, hB, hD, hC)
hY = intersect_projective_lines(hA, hD, hB, hC)

diagonal_coords = Array{Float64}(undef, 9, 3)

diagonal_coords[1,:], diagonal_coords[9,:] = map(to_homogenous_coordinates, [A,C])
coord_indices_to_wangle = [(1,9)]

midpoint(x,y) = (x+y)÷2

while !isempty(coord_indices_to_wangle)
	minId, maxId = pop!(coord_indices_to_wangle)
	midId = midpoint(minId,maxId)

	lowerP, upperP = diagonal_coords[minId,:], diagonal_coords[maxId,:]
	leftP = intersect_projective_lines(hX, upperP, hY, lowerP)
	rightP = intersect_projective_lines(hY, upperP, hX, lowerP)
	middleP = intersect_projective_lines(lowerP, upperP, leftP, rightP)

	diagonal_coords[midId,:] = middleP

	if (midId-maxId)%2==0
		append!(coord_indices_to_wangle, [(minId, midId), (midId, maxId)])
	end
end

lines_from_X = map(i -> find_perpendicular(hX, diagonal_coords[i,:]), 1:9)
lines_from_Y = map(i -> find_perpendicular(hY, diagonal_coords[i,:]), 1:9)

coords = Array{Float64}(undef, 9, 9, 2)

for i in 1:9
	for j in 1:9
		coords[i,j,:] = from_homogenous_coordinates(find_perpendicular(lines_from_X[i], lines_from_Y[j]))
	end
end

for i in 1:9
	for j in 1:9
		println(coords[i,j,:])
	end
end