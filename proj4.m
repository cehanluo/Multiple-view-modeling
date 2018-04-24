% give the datapath of given images
% examples of datapath: 'data/data02' 'data/data04' 'data/data06'
datapath='';

%% load given dataset and light vector of corresponding images from datapath
Li = load([datapath '/lightvec.txt']);
images_files = dir(fullfile(datapath, '*.bmp'));
num_images = length(images_files);
%images = cell(num_images,1);
[m,n,d]=size(imread(fullfile(datapath,image_files(1).name)));
images = zeros([m,n,d,num_images]);
for i = 1:num_images
    cur_img=imread(fullfile(datapath,image_files(i).name));
    cur_img=rgb2gray(cur_img);
    images(:,:,i)=cur_img;
end

%% uniform resample the given images
disp('Uniformly resampling');
[resample_img, Lo]=resampling(images, Li);

%% denominator image
disp('get denominator image');
[de_ind]=denominator_img(resample_img);

% figure('Name','denominator image'), imshow(images(:,:,:,de_ind)/255);
% imwrite(images(:,:,:,de_ind)/255,'Denominator image.bmp','bmp');

%% inital normal estimation
[initial_norm]=initial_norm(resample_img, Lo, de_ind);

%% refine normal from initial estimation
[refine_norm]=refinement(initial_norm);



