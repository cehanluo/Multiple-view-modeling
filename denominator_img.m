function [de_ind]=denominator_img(images)
% images is 3 dimensional matrix, images(:,:,i) is a gray image, i is the
% unique number of one image
% h: height; w: width; num: number of images saved in this matrix 
[h, w, num] = size(images);

% set the lower boundary and higher boundary for pixel intensity ranking
% maximum number of pixels with rank > L=70% in each image
% and mean rank among the pixels that satisfy above consition<H=90%

L = 0.7 * num;
H = 0.9 * num;

% initialized a matrix for pixel ranking
rank_pixels=zeros(h, w, num); 

% rank each pixel (x,y), and save the result to rank_pixel(i,j,:)
for i = 1:h
    for j = 1:w
        pixels = images(i, j, :);
        [~, I] = sort(pixels);
        rank_pixels(i, j, I) = 1:num; %reverse sort, make the sequence from small to large
    end
end

% thresholding on image pixels for getting denominator image
count=0;
de_ind=0;
for i=1:num
    rank=rank_pixels(:,:,i);
    rank=rank(rank>L);
    if mean(rank)<H && size(rank,1)>count
        count=length(rank);       
        de_ind=i;
    end
end
