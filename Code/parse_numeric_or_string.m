% If input is numeric, return input
% If input is in the form of "number lambda", return number * lambda
function len = parse_numeric_or_lambda(input, lambda)
if ischar(input)
    len = lambda * sscanf( input, '%f lambda');
elseif isnumeric(input) && isscalar(input)
    len = input;
end