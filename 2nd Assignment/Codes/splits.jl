using Combinatorics 

function splits(n)
    return collect(powerset(collect(1:n),1,n-1))
end

splits(3)