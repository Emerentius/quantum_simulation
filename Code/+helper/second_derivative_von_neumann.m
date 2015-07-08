% Calculate the second derivative from a data vector and lattice
% distance under the condition of zero slope at either end.
% The result vector has length equal to the input vector. 
function derivative_vector = second_derivative_von_neumann(vector, lattice_distance)
    if ~isvector(vector)
        error('The function "second_derivative_von_neumann" needs a vector');
    end
    if length(vector) < 3
        error('The function "second_derivative" needs at least 3 points');
    end
    % d^2 y/dx^2 = ( y(n+1)-2*y(n)+y(n-1) )/a^2;
    % vector(0) = vector(2) and similarly at the other end
    derivative_vector = zeros(size(vector));
    derivative_vector(1)   = 2*(-vector(1)+vector(2))/lattice_distance^2;
    derivative_vector(end) = 2*(vector(end-1)-vector(end))/lattice_distance^2;
    
    derivative_vector(2:end-1) = helper.second_derivative(vector, lattice_distance);
end