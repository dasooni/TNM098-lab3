imds = imageDatastore('Lab3.1\*.jpg');
images = readall(imds);

imshow(images{2})