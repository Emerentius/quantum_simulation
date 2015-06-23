% Calculate the second derivative from a vector and a given lattice
% distance. The resulting vector has a length 2 less than the input vector.
function derivative_vector = second_derivative(vector, lattice_distance)
    if ~isvector(vector)
        error('The function "second_derivative" needs a vector');
    end
    if length(vector) < 3
        error('The function "second_derivative" needs at least 3 points');
    end
    len = length(vector);
    % d^2 y/dx^2 = ( y(n+1)-2*y(n)+y(n-1) )/a^2;
    derivative_vector = (+vector(1:len-2)    ...
                        -2*vector(2:len-1)  ...
                        +vector(3:len))/lattice_distance^2;
end