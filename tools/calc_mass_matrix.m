function A = calc_mass_matrix(M)
    S_tri = calc_tri_areas(M);
    A = zeros(M.n,1);
    for i=1:M.m
        A(M.TRIV(i,1)) = A(M.TRIV(i,1)) + S_tri(i)/3;
        A(M.TRIV(i,2)) = A(M.TRIV(i,2)) + S_tri(i)/3;
        A(M.TRIV(i,3)) = A(M.TRIV(i,3)) + S_tri(i)/3;
    end
    A = sparse(1:M.n,1:M.n,A);
end