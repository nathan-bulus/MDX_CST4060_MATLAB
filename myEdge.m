function myEdge()
% Input Image
input_image = imread('C:\Users\rocke\Downloads\Photos (1)\louvre.jpg');

% Convert image to grayscale
% im2gray works for both RGB and Gray images
im = im2gray(input_image);

% Apply Gaussian blur to the image
filtered_image = imgaussfilt(im);

% Custom filter mask
% Extended sobel mask 5x5
K1 = [1, 1, 0, -1, -1;  0, 0, 0, 0, 0; 2, 2, 0, -2, -2; 0, 0, 0, 0, 0; 1, 1, 0, -1, -1];
K2 = rot90(K1); %rotate K1 by 90 degrees

% Convert the image to double
filtered_image = double(filtered_image);

% Convolution using conv2 function
Gx = conv2(filtered_image, K1);
Gy = conv2(filtered_image, K2);

% magnitude of the gradient
output_image = sqrt(Gx.^2  + Gy.^2);
output_image = uint8(output_image);

% Display the filtered Image
figure, imshow(output_image);

% Calculate sum of all the gray level
% pixel's value of the GrayScale Image
[x, y, z] = size(filtered_image);
sum = 0;
for i=1:x
    for j=1:y
        sum = sum + filtered_image(i, j);
    end
end

% Define a threshold value
% calculate By dividing sum of pixels 
% total number of pixels = rows*columns (i.e x*y)  
threshold = sum/(x*y);
disp(threshold);
output_image = round(max(output_image, threshold));

% display Output Image
output_image = imbinarize(output_image);
figure, imshow(output_image);

    
