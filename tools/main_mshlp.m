function [evecs, evals, W, A] = main_mshlp(dtype, shape, max_num_evecs)
% dtype = 'cotangent', 'euclidean', 'geodesic'

assert(strcmp(dtype, 'cotangent') | strcmp(dtype, 'euclidean') | strcmp(dtype, 'geodesic'));

[W,A] = mshlp_matrix(shape, struct('hs',2,'rho',3,'htype','ddr', 'dtype', dtype));
W = -W;
% A = sparse([1:length(A)], [1:length(A)], A);
A = calc_mass_matrix(shape);
num_evecs = min(size(W, 1) - 1, max_num_evecs);

[evecs, evals] = eigs(W, A, num_evecs, -1e-5, struct('disp', 0));
evals = diag(evals);

[evals, idx] = sort(evals);
evecs = evecs(:,idx);

end % function main_mshlp
