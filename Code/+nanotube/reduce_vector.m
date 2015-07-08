function new_vec = reduce_vector(vector, C,P)
    projection_C = dot(vector, C);
    projection_P = dot(vector, P);
    % vec = vec_0 + n*C, n integer
    % condition for vec_0:
    % 0 <= vec_0 * C / C^2 < 1
    % => floor(vec * C / C^2 ) = floor( vec_0 * C / C^2) + n = n
    % vec - n*C = vec_0
    new_vec = vector - floor(projection_C/dot(C,C))*C - floor(projection_P/dot(P,P))*P;
end