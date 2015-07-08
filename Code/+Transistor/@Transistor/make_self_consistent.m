function iterations = make_self_consistent(obj, newton_step_size, limit, max_iterations)
    iterations = 0;
    while ~obj.is_self_consistent
        if iterations >= max_iterations
            err('Did not achieve self consistency')
        end
        if max(abs(obj.update_phi(newton_step_size))) <= limit
            obj.is_self_consistent = true;
        end
        iterations = iterations + 1;
    end
    % recalculate carrier density and DOS
    obj.compute_carrier_density_and_DOS;
end