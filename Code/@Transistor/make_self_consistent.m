function iterations = make_self_consistent(obj, max_iterations)
    if ~exist('max_iterations', 'var')
        max_iterations = inf;
    end
    limit = obj.self_consistency_limit;
    
    iterations = 0;
    while ~obj.is_self_consistent
        if iterations >= max_iterations
            err('Did not achieve self consistency')
        end
        
        %% check limit for an entire pass of a phi update
%         phi = obj.phi; % save old phi
%         obj.update_phi;
%         delta_phi = phi - obj.phi; % old - new
%         if max(abs(delta_phi)) <= limit
%             obj.is_self_consistent = true;
%         end
        
        %% check limit for one newton step
        if max(abs(obj.update_phi)) <= limit
           obj.is_self_consistent = true;
        end
        %%
        iterations = iterations + 1;
    end
    % recalculate carrier density and DOS for internal consistency
    % This method also computes transmission probability and ensures
    % it has as many elements as obj.energy_range
    obj.compute_DOS_and_related;
end