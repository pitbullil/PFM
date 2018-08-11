function [evecs,evals,area,W] = calc_LB(shape,max_num_evals)
%%
    [evecs, evals, W, area] = main_mshlp('cotangent', shape,  min(size(shape.VERT,1),max_num_evals)); %#ok<ASGLU>
    %area = full(diag(A));
    %area = area/sum(area); %commented by R.Litman
    
    % added by E.Rodola
    evals = abs(real(evals));
    evecs = real(evecs);
end
