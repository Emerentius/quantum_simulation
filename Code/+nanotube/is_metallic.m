% Check if nanotube defined by n and m has no band gap.
function is_metallic_ = is_metallic(n,m)
    is_metallic_ = mod(int32(n)-int32(m), int32(3)) == 0;
end