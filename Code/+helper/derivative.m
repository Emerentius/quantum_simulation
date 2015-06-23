% Calculate the symmetric (averaged) first derivative in from a vector and a given lattice
% distance. The resulting vector has a length 2(!) less than the input vector.
function derivative_vector = derivative(vector, lattice_distance)
    if ~isvector(vector)
        error('The function "derivative" needs a vector');
    end
    if length(vector) < 3
        error('The function "derivative" needs at least 3 points');
    end
    len = length(vector);
    % d^2 y/dx^2 = ( y(n+1)-2*y(n)+y(n-1) )/a^2;
    derivative_vector = ( vector(3:len)-vector(1:len-2) )/2/lattice_distance;
end