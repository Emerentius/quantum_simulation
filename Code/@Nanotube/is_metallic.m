function is_metallic_ = is_metallic(obj)
    is_metallic_ = mod(int32(obj.n)-int32(obj.m), int32(3)) == 0;
end