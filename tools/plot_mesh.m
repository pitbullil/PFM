function plot_mesh(N, color)
    if nargin==1
        trisurf(N.TRIV,N.VERT(:,1),N.VERT(:,2),N.VERT(:,3),zeros(size(N.VERT,1),1))
    elseif nargin==2
        trisurf(N.TRIV,N.VERT(:,1),N.VERT(:,2),N.VERT(:,3),'FaceColor',color,'EdgeColor','none')
    end
    axis equal
	xlabel('X')
	ylabel('Y')
	zlabel('Z')
    rotate3d on
end
