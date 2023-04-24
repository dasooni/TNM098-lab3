clear;
%Select current image, 1-12
currentImage = 1;

imds = imageDatastore("Lab3.1\*.jpg");
imgs = readall(imds);
%Normalize, for whatever reason
imgsNorm = cell(size(imgs,1),1);

for i = 1:length(imgs)
    imgsNorm{i,1} = im2double(imgs{i});  
end



%Resize images. Makes sense later.
%Get minimum size (mxn) from the folder of images.
min_size = zeros(size(imgs,1), 2);
for i = 1:length(imgs)
    min_size(i,1) = size(imgs{i},1);
    min_size(i,2) = size(imgs{i},2);
end
min_size = min(min_size);

%Resize all images acorrding to min_size.
for k = 1:length(imgs)
     imgsNorm{k} = imresize(imgsNorm{k},[min_size(1,1) min_size(1,2)]);
end

imgs_r = cell(size(imgsNorm,1),1);
imgs_g = cell(size(imgsNorm,1),1);
imgs_b = cell(size(imgsNorm,1),1);
imgs_a = cell(size(imgsNorm,1),1);

for i = 1:length(imgs)
    imgs_r{i} = imgsNorm{i}(:,:,1);
    imgs_g{i} = imgsNorm{i}(:,:,2);
    imgs_b{i} = imgsNorm{i}(:,:,3);
    imgs_a{i} = rgb2gray(imgsNorm{i});
end

%% Plot histogram
%Get each channel of THE selected image (currentImage).
img1_g = imgsNorm{currentImage}(:,:,2);
img1_b = imgsNorm{currentImage}(:,:,3);
img1_gray = rgb2gray(imgsNorm{currentImage});

subplot(2,2,1);
[yRed, ~] = imhist((imgs_r{currentImage}));
imhist(imgs_r{currentImage})
title("Subplot 1: Red channel histogram")
subplot(2,2,2); 
[yGreen, ~] = imhist((imgs_g{currentImage}));
imhist((imgs_g{currentImage}))
title("Subplot 2: Green channel histogram")
subplot(2,2,3);
[yBlue, x] = imhist((imgs_b{currentImage}));
imhist((imgs_b{currentImage}))
title("Subplot 3: Blue channel histogram")
subplot(2,2,4);
imhist((imgs_a{currentImage}))
title("Subplot 4: Gray channel histogram")

%% Histogram displays the distrubtion. This shows distrubition for each band.
plot(x, yRed, 'Red', x, yGreen, 'Green', x, yBlue, 'Blue');

%% Deltas

for j = 1:length(imgsNorm)
    deltaR{j,1} = abs(imgs_r{currentImage,1} - imgs_r{j,1});
    deltaG{j,1} = abs(imgs_g{currentImage,1} - imgs_g{j,1});
    deltaB{j,1} = abs(imgs_b{currentImage,1} - imgs_b{j,1});

    meanR{j,1} = mean2(deltaR{j,1}); 
    meanG{j,1} = mean2(deltaG{j,1}); 
    meanB{j,1} = mean2(deltaB{j,1});
end



%% SSIm
for n = 1:length(imgsNorm)
    [ssimvals{n,1}, ssimmaps{n,1}] = ssim(imgs_a{currentImage,1}, imgs_a{n,1});
end

ssimvals = cell2mat(ssimvals);
[BS,IS] = sort(ssimvals, 'descend');

montage({ssimmaps{currentImage}, ssimmaps{IS(2)}})

%% Cross correlation
% Rather slow. 
c = cell(size(imgsNorm,1),1);

for m = 1:length(imgsNorm)
    c{m} = xcorr2(imgs_a{currentImage},imgs_a{m});
    
end
for n = 1:length(imgsNorm)
    c_mean{n,1} = mean2(c{n});
    
end
%% IMMSE: Mean-Squared Error. 
% Much faster.
mse = cell(size(imgsNorm,1),1);
for i = 1:length(imgsNorm)
    mse{i,1} = immse(imgs_a{currentImage}, imgs_a{i});
end

mse = cell2mat(mse);
[B,I] = sort(mse);


%% Feature matching using Harris & SURF
points = cell(size(imgsNorm,1),1);
for j = 1:length(imgsNorm)
    points{j,1} = detectHarrisFeatures(imgs_a{j});
    points2{j,1} = detectSURFFeatures(imgs_a{j});
    [features{j,1}, val_points{j,1}] = extractFeatures(imgs_a{j,1}, points{j,1});
    [features2{j,1}, val_points2{j,1}] = extractFeatures(imgs_a{j,1}, points2{j,1});
    
    
end

indexPairs = matchFeatures(features{1,1}, features{9,1});
indexPairs2 = matchFeatures(features2{1,1}, features2{9,1});

matchedPoints1 = val_points{1,1}(indexPairs(:,1),:);
matchedPoints2 = val_points{2,1}(indexPairs(:,2),:);

matchedPointsSurf1 = val_points2{1,1}(indexPairs2(:,1));
matchedPointsSurf2 = val_points2{2,1}(indexPairs2(:,2));

showMatchedFeatures(imgs{1,1}, imgs{9,1}, matchedPointsSurf1,matchedPointsSurf1);

%%

