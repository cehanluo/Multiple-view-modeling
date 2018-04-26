function norm_map(norm, L, datapath, filename)
[m,n,~] = size(norm);
intensity = zeros(m,n);
for i=1:m
    for j=1:n
        pixel_norm=squeeze(norm(i,j,:));
        intensity(i,j)=L*pixel_norm;
    end
end

figure('name',filename),
imshow(intensity);
save_path = [datapath filename '.jpg'];
imwrite(intensity, save_path);
        