% Compute components n_p, m_p of the translational vector P
function [n_p, m_p] = P_components(n,m)
    % negative from script
    % P points up, if C points to the right
    numerator = -2*n-m;
    denominator = n+2*m;
    gcd_ = gcd(numerator, denominator);
    
    n_p = denominator / gcd_;
    m_p = numerator / gcd_;
end

