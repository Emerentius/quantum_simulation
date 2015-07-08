function ka = ka_source(obj, E)
    ka = real( acos( 1 + (-E + obj.source.phi(1))/2/obj.t ) );
end