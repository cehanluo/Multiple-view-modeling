function recsurf = build_model(norms)
% norms is m*n*3 matrix

[m,n,~]=size(norms);
% initialize matrix for slant and tilt
slant = zeros([m,n]);
tilt = zeros([m,n]);
for i = 1:m
    for j=1:n
        % slant: angle between norm and z axis
        %slant(i,j) = acos(norms(i,j,3));
        % tilt: angle of between projection norm in x-y plane and x axis
        %tilt(i,j) = sign(norms(i,j,2))*acos(norms(i,j,2));
        
        n_ij = squeeze(norms(m+1-i,j,:));
        % calculate slant & tilt
        [slant(i,j), tilt(i,j)] = grad2slanttilt(-n_ij(1)/n_ij(3), -n_ij(2)/n_ij(3));
    end
end

%recsurf = shapletsurf(slant, tilt, nscales, minradius, mult, opt)
recsurf = shapeletsurf(slant, tilt, 6, 1, 2); % 6,1,2 default suggestion value
%figure,surf( recsurf );

figure;

surf(recsurf,'FaceColor','blue','EdgeColor','none');
camlight left;
lighting phong;
axis equal;
axis vis3d;
axis off;

end
