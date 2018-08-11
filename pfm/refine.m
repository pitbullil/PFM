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
function [C_ref, v_ref, matches_ref] = refine(N, M, C, matches, options)

% Refine by using landmarks

fps = fps_euclidean(N.VERT, options.refine_fps, 1);
FG = compute_indicator_functions({N,M}, [fps matches(fps)]', options.fps_variance);
F = FG{1};
G = FG{2};

[C_ref, v_ref, matches_ref] = ...
    match_part_to_whole(N, M, G, F, C, options);

end
