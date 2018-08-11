%
% This code accompanies the paper:
%
% "Partial Functional Correspondence"
% Rodola, Cosmo, Bronstein, Torsello, Cremers
% Computer Graphics Forum 2016
%
% It reproduces the full pipeline used for the experiments shown in the
% paper. Please cite the paper above if you use this code in your research.
%
% Written by Emanuele Rodola and Luca Cosmo (2015-2017)
%
%%
clc, close all, clear all

% NOTE: this code requires manopt, please download it from:
% https://manopt.org/downloads.html
% and add it to your matlab path
addpath(genpath('D:\Users\NADAV\Documents\MATLAB\manopt\'))

addpath('./tools/')
addpath('./pfm/')
addpath('./pfm/mumford_shah_func/')

rng(1);

M = load_off('./data/cat7.off');
N = load_off('./data/cat10_partial.off');

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

colors = create_colormap(M, M);
figure
subplot(121), colormap(colors), plot_scalar_map(M, 1:M.n)
axis off; light; lighting phong; camlight head; freeze_colors
subplot(122), colormap(colors(matches_ref,:)), plot_scalar_map(N, 1:N.n)
axis off; light; lighting phong; camlight head;
