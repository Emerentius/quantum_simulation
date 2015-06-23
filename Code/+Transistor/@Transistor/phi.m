%% phi access method
% Returns phi for the entire transistor. If not explicitly demanded to be
% self-consistent, this is the initial poisson solution assuming zero
% carrier density
function phi_ = phi(obj)
    phi_ = [obj.source.phi; obj.gate.phi; obj.drain.phi];
%% check if phi has been set  
%     phi_ = [obj.source.phi; obj.gate.phi; obj.drain.phi];
%     if ~isempty(phi_)
%         return
%     end
%     phi_ = obj.poisson();
%     obj.set_phi(phi_);
end