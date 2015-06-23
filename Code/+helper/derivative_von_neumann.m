% Calculate the symmetric (averaged) first derivative in from a vector and a given lattice
% distance under von Neumann boundary conditions of zero slope at both
% ends.
% The derivative vector has same length(!) as input vector.
function derivative_vector = derivative_von_neumann(vector, lattice_distance)
    if ~isvector(vector)
        error('The function "derivative_von_neumann" needs a vector');
    end
    if length(vector) < 3
        error('The function "derivative" needs at least 3 points');
    end
    len = length(vector);
    % d^2 y/dx^2 = ( y(n+1)-2*y(n)+y(n-1) )/a^2;
    derivative_vector = zeros(size(vector)); % same orientation
    derivative_vector(2:len-1) = helper.derivative(vector, lattice_distance);
end