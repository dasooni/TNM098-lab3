imds = imageDatastore("Lab3.1\*.jpg");
imgs = readall(imds);


%Resize images. Makes sense later.
min_size = zeros(size(imgs,1), 2);
for i = 1:length(imgs)
    min_size(i,1) = size(imgs{i},1);
    min_size(i,2) = size(imgs{i},2);
end
min_size = min(min_size);

for k = 1:length(imgs)
     currentImage = imgs{k};
     imgs{k} = imresize(imgs{k},[min_size(1,1) min_size(1,2)]);
end

%Get each channel of an image
img1_r = imgs{1}(:,:,1);
img1_g = imgs{1}(:,:,2);
img1_b = imgs{1}(:,:,3);
img1_gray = rgb2gray(imgs{1});

%Plot histogram
subplot(2,2,1);
[yRed, ~] = imhist((img1_r));
imhist(img1_r)
title("Subplot 1: Red channel histogram")
subplot(2,2,2); 
[yGreen, ~] = imhist((img1_g));
imhist((img1_g))
title("Subplot 2: Green channel histogram")
subplot(2,2,3);
[yBlue, x] = imhist((img1_b));
imhist((img1_b))
title("Subplot 3: Blue channel histogram")
subplot(2,2,4);
imhist((img1_gray))
title("Subplot 4: Gray channel histogram")

%%
%Histogram displays the distrubtion. This shows distrubit-
%ion for each band.
plot(x, yRed, 'Red', x, yGreen, 'Green', x, yBlue, 'Blue');

%%

bw1 = edge(img1_gray, "canny");
imshow(bw1)
title('Canny filtered image')

%%
im2 = rgb2gray(imgs{2});

[ssimval, ssimmap] = ssim(img1_gray, im2);

