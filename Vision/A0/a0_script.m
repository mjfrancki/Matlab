%1 input images

figure('Name','Image 1','NumberTitle','off'), imshow('img1.tiff')
figure('Name','Image 2','NumberTitle','off'), imshow('img2.tiff')


%2 Colour planes 
%a
img = imread('img1.tiff');
img = im2double(img);

img2 = imread('img2.tiff');
img2 = im2double(img2);

%b
redChannel = img(:,:,1);
greenChannel = img(:,:,2);
blueChannel = img(:,:,3);

redBlueSwap = cat(3,blueChannel,greenChannel,redChannel);

figure('Name','Red Blue Swap','NumberTitle','off'), imshow(redBlueSwap,[])

%c
img_g = greenChannel;
figure('Name','Green Channel','NumberTitle','off') , imshow(img_g,[])

%d
img_r = redChannel;
figure('Name','Red Channel','NumberTitle','off') , imshow(img_r,[])

%e
figure('Name','Gary Scale','NumberTitle','off') , imshow( rgb2gray(img),[] )  

%3 Replace of pixels

img1rows = size(img, 1);
img1columns = size(img, 2);

img2rows = size(img2, 1);
img2columns = size(img2, 2);


img1gray = rgb2gray(img);
img2gray = rgb2gray(img2);

img1subImage = imcrop(rgb2gray(img),[ (img1rows/2) - 50, (img1columns/2) - 50, 99, 99 ] );
img2subImage = imcrop(rgb2gray(img2),[ (img2rows/2) - 50, (img2columns/2) - 50, 99, 99 ] );




imgPixelReplace = img ;
imgPixelReplace2 = img2 ;
for i = 1 : 100 

  for j = 1 : 100
     
    imgPixelReplace(  (img1columns/2) - 50 + i , (img1rows/2) - 50 + j , :) =  img2subImage(i,j,:);
    imgPixelReplace2( 205 + i , 205 + j,:) =  img1subImage(i,j,:);
   
  end 

end



%figure('Name','Pixel Replace 1','NumberTitle','off'), imshow( rgb2gray(imgPixelReplace) )

figure('Name','Pixel Replace 2','NumberTitle','off'), imshow( rgb2gray(imgPixelReplace2) )




%4

%a min max mean stdDev
maxValue = max(max(img_g));
fprintf('max value is %d \n', maxValue)

minValue = min(min(img_g));
fprintf('min value is %d \n', minValue)

mean = mean2(img_g);
fprintf('The mean using matlabs mean2() function is %f \n ', mean)

standardDevation = std2(img_g);
fprintf('The Standard Devation using matlabs std2() function is %f \n ', standardDevation)


%b ((img - mean) / stdDev)*10 + mean

newImg = imadd(immultiply( imdivide(imsubtract(img_g,mean),standardDevation), 10),mean);
figure('Name','Threshold effect','NumberTitle','off'), imshow(newImg,[])




%c
Rout = imref2d(size(img_g));

 
A = [1 0 0; 
     0 1 0; 
     -2 0 1];

tform = affine2d(A);

[out,Rout] = imwarp(img_g,tform,'OutputView',Rout);

figure('Name','Left Shift','NumberTitle','off'), imshow(out,[])

%d

shiftSub = imsubtract(img_g,out);
figure('Name','Shift Sub','NumberTitle','off'), imshow(shiftSub,[])

%e
imgFlip =  flipud(img_g);
figure('Name','Flip','NumberTitle','off'), imshow(imgFlip,[])

%f
maxItensity = ones(512) * 255;
img_g = im2double(img_g);
imgIntensityFlip =  maxItensity - img_g;
figure('Name','Intensity Flip','NumberTitle','off'), imshow(imgIntensityFlip, [])

%5 Image Noise 
%img1 = im2double(img);

variance = 0.30;


redNoise = imnoise(img(:,:,1),'gaussian',0,variance);
blueNoise = imnoise(img(:,:,2),'gaussian',0,variance);
greenNoise = imnoise(img(:,:,3),'gaussian',0,variance);

imgNoise = cat (3,redNoise, blueNoise, greenNoise);

fprintf('Used variance of %f', variance)
figure('Name','G Noise','NumberTitle','off'), imshow(imgNoise,[])
