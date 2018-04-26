function refine_norm=refinement(initial_norm, lambda, sigma)
% use higher-preicision light direction sphere by 5 recursively subdevision icosahedron
% map initial_norm to the directions given by this subdivided iconsahedron.
% After 5 recursively subdivison, |labels| = L = 5057 of vertice with z>0
[vertex,~] = icosphere(5);
labels = vertex(vertex(:,3)>0,:);
L = size(labels,1);

% get size of initial normal estimation
[m,n,~] = size(initial_norm);

% initialize 1D expression based on the size of initial normal.
% reshape the matrix along each row because the number is assigne from left
% to right in the default setting of GCO library
renorm = zeros(m*n, 3);
for i=1:3
    renorm(:,i)=reshape(initial_norm(:,:,i)',[m*n,1]);
end

% GCO_create optimal object handle
% Handle = GCO_Create(NumSites,NumLabels)
handle = GCO_Create(m*n, L);

% GCO_SetDataCost, calculate datacost according to energy funciton E_data
datacost = pdist2(labels, renorm); 
datacost = int32(10000*datacost);
GCO_SetDataCost(handle, datacost);

% GCO_SetNeighbors, set weights 1 to neibours and set 0 to non-neighbours
weights=sparse(m*n,m*n);
for di=1:m
    for dj=1:n
        % connect lateral neighbor points p1 & p2
        if dj+1<n 
            p1 = (di-1)*n+dj;
            p2 = (di-1)*n+dj+1;
            weights(p1,p2) = 1;
        end
        % connect vertical neighbor points p1 & p3
        if di+1<m
            p3=di*n+dj;
            weights(p1,p3)=1;
        end
    end
end
                   
GCO_SetNeighbors(handle, weights);


% GCO_SetSmoothCost, calculate smoothcost E_smooth
smoothcost=log(1+pdist2(labels,labels)/(2*sigma*sigma));
smoothcost=int32(1000*lambda*smoothcost);
GCO_SetSmoothCost(handle,smoothcost);

% GCO_Expansion, do alpha expansion to optimal object return minimal energy
GCO_Expansion(handle);

% GCO_GetLabeling, get the label result of norms.
labeling = GCO_GetLabeling(handle);

% map the label result to get refine norms
refine_norm = zeros([m,n,3]);
for i = 1:m
    for j = 1:n
        p = (i-1)*n + j;
        ind = labeling(p);
        refine_norm(i,j,:)= labels(ind,:);
    end
end

end
