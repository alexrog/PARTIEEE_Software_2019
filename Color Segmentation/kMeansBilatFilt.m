clear; clc; clf; close all;

im = imread('1.png');
im = imresize(im,[1080,1920]);
%im = im(500:560,1290:1330,:); %3.png
%im = im(650:770,1200:1335,:);%2.png
im = im(300:390,730:875,:);%1.png

% iterative bilateral filter
patch = im(1:20,1:20,:);
patchVar = std2(patch)^2;
DoS = patchVar;
spat_sigma = 8;
for j = 1:20
    im = imbilatfilt(im,DoS, spat_sigma);
end
image(im);


redOrig = reshape(im(:,:,1),size(im,1)*size(im,2),1); % Red channel
greenOrig = reshape(im(:,:,2),size(im,1)*size(im,2),1); % Green channel
blueOrig = reshape(im(:,:,3),size(im,1)*size(im,2),1); % Blue channel

rgbOrig = [double(redOrig) double(greenOrig) double(blueOrig)];   

K = 3; % number of clusters

[G,C] = kmeans(rgbOrig, K, 'distance', 'sqEuclidean', 'start', 'sample');

rgbC1 = C(1,:);
rgbC2 = C(2,:);
rgbC3 = C(3,:);

% plots the colors of the centroids
x = [0 1 1 0] ; y = [0 0 1 1] ;
figure
subplot(1,3,1);
fill(x,y,rgbC1/255)
subplot(1,3,2);
fill(x,y,rgbC2/255)
subplot(1,3,3);
fill(x,y,rgbC3/255);

% plots the kmeans scatter plot
clr = lines(K);
figure, hold on
scatter3(rgbOrig(:,1), rgbOrig(:,2), rgbOrig(:,3), 36, clr(G,:), 'Marker','.')
scatter3(C(:,1), C(:,2), C(:,3), 100, clr, 'Marker','o', 'LineWidth',3)
hold off
view(3), axis vis3d, box on, rotate3d on
xlabel('x'), ylabel('y'), zlabel('z')
