% % % %  Module : Advanced Image Analysis % % % % 
%% Author: Dousai Nayee Muddin Khan
%% Date: January 7th 2018

clc; clear all; close all;
lenaimg = double(imread('Lena256.bmp')); % to read lena image
% lenaimg = double(imread('Cam.png')); % to read camera image
%lenaimg = double(imread('fruit.bmp'))%to read fruit image
figure;
imshow(lenaimg,[]);
title(' Original image')

level = 2; %level to select the wavelet transform
h=[0.48296 0.83652 0.22414 -0.12941]; % Daubechies D4 filter for image
%Wavelet Transform Decomposition
imgdec = multiwaveletdecomposition(lenaimg, h, level);
figure;
imshow(imgdec,[]);
title('Decomposition of the image')

%Wavelet Transform Reconstruction
imgrec = multiwaveletreconstruction(imgdec, h, level);
figure;
imshow(imgrec,[]);
title('Reconstruction of the image')


%% WAVELET FOR IMAGE NOISE REDUCTION:
close all;
% Add white noise to the image:
mean = 0; % Mean
Variance = 15; %Sigma can vary from 2 to 20
%X noisy = Image + Gaussian white noise
lenanoise = double(lenaimg) + (mean + Variance * randn(size(lenaimg)));
figure;
imshow(lenanoise,[]);
title(' Noisy Image ')
%Wavelet transform:
level = 1; %Select the levels
wave_dec = multiwaveletdecomposition(lenanoise, h, level);

%Estimation of the noise level
noise_level=[wave_dec(129:256,1:128) wave_dec(129:256,129:256) wave_dec(1:128,129:256)];
Variance=median(abs(noise_level(:)))/0.6745

threshold=10*Variance;

%hard-thresholding:
hthres=wave_dec.*((abs(wave_dec)>threshold));

%soft-thresholding:
sthres=(sign(wave_dec).*(abs(wave_dec)-threshold)).*((abs(wave_dec)>threshold));

%reconstruction for hard thresholding
imrech = multiwaveletreconstruction(hthres, h, level);
figure;
imshow(imrech,[]);
title(' Hard Thresholding ')

%reconstruction for soft thresholding
imrecs = multiwaveletreconstruction(sthres, h, level);
figure;
imshow(imrecs,[]);
title(' Soft Thresholding')