function ka = ka_drain(obj, E)
    ka = real( acos( 1 + (-E + obj.drain.phi(end))/2/obj.t ) );
end