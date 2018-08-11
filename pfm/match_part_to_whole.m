%
% This code accompanies the paper:
%
% "Partial Functional Correspondence"
% Rodola, Cosmo, Bronstein, Torsello, Cremers
% Computer Graphics Forum 2016
%
% Please cite the paper above if you use this code in your research.
%
% Written by Emanuele Rodola and Luca Cosmo
%
function [C, v, matches] = match_part_to_whole(N, M, G, F, C_init, options)

mu1 = options.mu1;
mu2 = options.mu2;
mu3 = options.mu3;
mu4 = options.mu4;

v_init = ones(M.n,1);

C_prev = [];
v_prev = [];
matches_prev = [];
objs = [];

for i=1:options.max_iters
    
    fprintf('------------------------- Iteration %d -------------------------\n',i);
    
    [C, est_rank, cost] = optimize_C(M, N, G, F, v_init, C_init, mu1, mu2);
    
    if i>1 && cost >= objs(end)
        fprintf('Cost increasing, stopping now and keeping previous solution.\n');
        C = C_prev;
        v = v_prev;
        matches = matches_prev;
        break;
    end
        
    objs = [objs cost];
    
    [Co, matches] = run_icp_partial(M, N, est_rank, C, options.icp_max_iters);
    
%     colors = create_colormap(M, M);
%     figure
%     subplot(121), colormap(colors), plot_scalar_map(M, 1:M.n)
%     axis off; light; lighting phong; camlight head; freeze_colors
%     subplot(122), colormap(colors(matches,:)), plot_scalar_map(N, 1:N.n)
%     axis off; light; lighting phong; camlight head;
    
    C_init = [Co zeros(size(C,1),size(C,1)-size(Co,2))];
    
%     figure
%     subplot(121), plot_mesh(N), shading interp, axis off; light; camlight head; title('part')
%     subplot(122), plot_scalar_map(M, M.evecs*C_init*(N.evecs'*N.S*ones(N.n,1))), axis off; light; camlight head; title('corresponding region')

    v = optimize_v(M, N, G, F, C_init, mu3, mu4, options);
    v = (0.5*tanh(6*(v-0.5))+0.5);
    v_init = v;
    
%     figure
%     subplot(121), plot_scalar_map(M, M.evecs*C*(N.evecs'*N.S*ones(N.n,1))), axis off; title('Before v-step')
%     subplot(122), plot_scalar_map(M,v), axis off; title(sprintf('Area agreement: %.2e',full(abs(sum(diag(N.S)) - sum(v.*diag(M.S))))))
    
    C_prev = C_init;
    v_prev = v_init;
    matches_prev = matches;
    
end

if i==options.max_iters
    fprintf('Maximum number of iterations reached in the alternating process.\n');
end

fprintf('Done.\n');

end
