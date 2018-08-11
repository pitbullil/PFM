function [bar] = corrs_to_bar_matlab(corrs,S,barmap)
    if ~isfield(S,'X')
    S.X = S.VERT(:,1);
end
    bar = zeros(length(S.X),4);
    bar(:,1)=-1;
    inds = corrs(:,1);%+1for c to matlab
    bar=barmap(corrs,:);
end
