function is_inside = is_inside_unit_cell(obj, vector)
    nanotube.initialise_constants;
    projection_C = dot(vector, obj.C);
    projection_P = dot(vector, obj.P);
    
    % some leeway afforded. Possible source for error
    is_inside = -0.01 <= projection_C && projection_C < dot(C,C) + 0.1 && ...
                -0.01 <= projection_P && projection_P < dot(P,P) + 0.1;
end