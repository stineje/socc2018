clc; clear;

clock = imread('clock.tiff'); %Read the sample image

% Add Errors equal to failure-rate value to the image
A11= imnoise(clock,'salt & pepper', 0.00001); % e.g. failure-rate1 = 0.00001
A12= imnoise(clock,'salt & pepper', 0.99); % e.g. failure-rate2 = 0.99

% Create file to write the degraded images 
vec1 = fopen('vector1.txt', 'wt'); 
vec2 = fopen('vector2.txt', 'wt');
vec3 = fopen('vector3.txt', 'wt'); 

for i=1:size(A11,1)
   for j=1:size(A11,2)
       
       % Read the pixels of degraded images
       str1= (num2str(dec2bin(A11(i,j), 8)));
       str2= (num2str(dec2bin(A12(i,j), 8)));
       
       % Write the pixels of degraded image into new files
       fprintf(vec3, '%d ', bin2dec(num2str(str1)));
      
       % Concatenate bits of pixels of degraded images. e.g. first bit of
       % str1 (A11) and seven bits of str2 (A12) form the pixel of degraded
       % image
       
       CON = strcat(str1(1), str2(2:8));
       
       % Write the concatenated pixels of degraded image into new files
       fprintf(vec1, '%d ', bin2dec(num2str(CON)));
       fprintf(vec2, '%s ', num2str(CON));
   end
   fprintf(vec1, '\n');
   fprintf(vec2, '\n');
   fprintf(vec3, '\n');
end
fclose(vec1);
fclose(vec2);
fclose(vec3);

% Read back the concatenated pixels of degraded image to show image and
% calculate PSNR
A1= importdata('vector3.txt'); 
figure; imshow(uint8(A1));
PeakSNR1 = psnr (uint8(A1), clock); 
fprintf('\n The PSNR1_1 value is %f', PeakSNR1);

A2= importdata('vector1.txt'); 
figure; imshow(uint8(A2));

PeakSNR2 = psnr (uint8(A2), clock);  
fprintf('\n The PSNR2 value is %f', PeakSNR2);



