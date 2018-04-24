function [re_images,Lr]=resampling(images, Li)

% images: matrix with dimension [height*width*num_images] gray images set
% Li: light vector of ith image

% build a standard icosahedron. Then, perform subdivision on 
% each face 4 times recursively and get the vertices coordinates.
% get the vertex coordinates in the icosahedron and assigned to Lo
[Lo,~] = icosphere(4);

% find the nearest neighbour Lo of Li
index=nearestneighbour(Li',Lo');

% initialize Lr for resampling images from Lo but each element in Lor is unique
Lr = zeros(0, 3);
[m,n,num]=size(images);
re_images=zeros([m,n,num]); % re_images is 4 dimension

for i=1:size(Lo,1)
    % find all Li closest to Lo, then resampling pixel intensities
    % using corresponding images.
    % in equation of resampling, the denominator Lo*Li, Li should be
    % indices of Li closeat to Lo. Hence, the set of closeat Li should
    % be found before using the equation.
    index2=find(index==i);
    if ~isempty(index2)
        Io=zeros(m,n);
        de=0;
        
        % get the denominator of one resampling image
        % where there Lo*Li is the weight of raw image.
        for j=1:size(index2)
            de=de+Lo(i,:)*Li(index2(j),:)';
        end

        for j=1:size(index2)
            Io=Io+Lo(i,:)*Li(index2(j),:)'/de*images(:,:,index2(j));
        end
        re_images(:,:,size(re_images,3)+1)=Io;
        Lr=[Lr;Lo(i,:)];
    end
end
