function matches_ref = partial_functional_correspondence(M,N)
%
% This code accompanies the paper:
%
% "Partial Functional Correspondence"
% E.Rodola, L.Cosmo, M.M.Bronstein, A.Torsello, D.Cremers
% Computer Graphics Forum
%
% Please cite the paper above if you use this code.
%
% Written by L.Cosmo and E.Rodola
% Universita' Ca' Foscari Venezia, Italy
% TU Munich, Germany
% (c) 2015
%

clc, close all
addpath('./tools/')
addpath('./partial/')
addpath(genpath('./manopt/manopt/'))

% *************************************************************************
% Note that this demo code is temporary and is not optimized for speed. As
% such, it may take several minutes to converge. You can reduce 
% options.maxiter inside optimize_C.m and especially in optimize_v.m to 
% achieve some speed-up.
%
% A final version of the code will be made available soon.
% *************************************************************************

options = struct;
options.n_eigen = 90;       % no. of eigenfunctions to use
options.max_iters = 6;      % max no. iterations for the alternating optimization
options.icp_max_iters = 30; % max no. iterations for intrinsic ICP
options.refine_fps = 50;    % no. of fps for the final refinement

% WARNING: the parameters below were chosen for the TOSCA dataset, and are
% scale-dependent. To use them as-is, make sure your shapes have surface
% area around 1.5 - 2.0 * 10^4.
options.tv_sigma = 0.2;     % variance of indicator func. in TV term
options.tv_mean = 0.5;      % mean =
options.fps_variance = 0.7; % variance of gaussians for the final refinement

% you can use your own Laplacian code here (we assume non-negative,
% increasing eigenvalues).
[M.evecs, M.evals, M.S, ~] = calc_LB(M, options.n_eigen);
[N.evecs, N.evals, N.S, ~] = calc_LB(N, options.n_eigen);

% you can use your own descriptors here
r = 0.04*sqrt(sum(calc_tri_areas(M)));
F = calc_shot(N.VERT', N.TRIV', 1:N.n, 9, r, 3)';
G = calc_shot(M.VERT', M.TRIV', 1:M.n, 9, r, 3)';

options.mu1 = 1;   % slanted-diagonal mask
options.mu2 = 1e3; % sub-orthogonality
options.mu3 = 1;   % area
options.mu4 = 1e2; % regularity

[C, ~, matches] = match_part_to_whole(N, M, G, F, [], options);
[C_ref, ~, matches_ref] = refine(N, M, C, matches, options);