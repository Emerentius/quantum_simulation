% Calculate the second derivative from a vector and a given lattice
% distance under von Neumann boundary conditions of zero slope at both
% ends.
% The resulting vector has a length equal to the input vector.
function derivative_vector = second_derivative_von_neumann(vector, lattice_distance)
    if ~isvector(vector)
        error('The function "second_derivative_von_neumann" needs a vector');
    end
    if length(vector) < 3
        error('The function "second_derivative" needs at least 3 points');
    end
    len = length(vector);
    % d^2 y/dx^2 = ( y(n+1)-2*y(n)+y(n-1) )/a^2;
    % vector(0) = vector(2) and similarly at the other end
    derivative_vector = zeros(size(vector));
    derivative_vector(1)   = 2*(-vector(1)+vector(2))/lattice_distance^2;
    derivative_vector(len) = 2*(vector(len-1)-vector(len))/lattice_distance^2;
    
    derivative_vector(2:len-1) = helper.second_derivative(vector, lattice_distance);
end