function [initial_norm]=initial_norm(resample_img, Lo, de_ind)
% resample_img is images uniformly resampling from cluster images (h*w*num_images).
% Lo is light vector of uniformly resampling images.
% de_ind is the index of denominator image in resample_img.

[h,w,~]=size(resample_img);
img_deno = resample_img(:,:,de_ind); % get denominator image.
L_deno = Lo(:,:,de_ind); % get light vector of denominator image.
resample_img(:,:,de_ind) = []; % delete denominator image from resample images
Lo(:,:,de_ind) = []; % delete light vector of denominator image from the whole light vector

initial_norm = zeros(m,n,3);
% operate SVD to each pixel and find surface normal of all pixels.
for i = 1:h
    for j=1:w
        I1=squeeze(resample_img(i,j,:));
        I2=img_deno(i,j);
        A=I1*L_deno - I2*Lo;
        [~,~,v]=svd(A);
        % the last vector of v would be the solution according to using svd
        % optimally solve multi-unknown equations.
        initial_norm(i,j,:) = sign(v(3,3))*v(:,3); % ensure norm point to same direction (z>0) 
    end
end
