% Check if nanotube defined by n and m has no band gap.
function is_metallic_ = is_metallic(n,m)
    is_metallic_ = (m-n)/3 == round( (m-n)/3 );
end