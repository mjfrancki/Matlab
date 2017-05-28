
img = imread('img3.tiff');
fruit = imread('bowl-of-fruit.jpg');
img = rgb2gray(im2double(img));
fruit = rgb2gray(im2double(fruit));
%imshow(edge(fruit));
%canny(img, 3, 0.25);

canny(fruit, 3, 0.024);

function y = canny(img, sigma, tau)
    
    filterX = fspecial('gaussian',[1, 13], sigma);
    filterY = fspecial('gaussian',[13, 1], sigma);
    img_dx = imsubtract(img, imfilter(img,filterX,'conv'));
    img_dy = imsubtract(img, imfilter(img,filterY,'conv'));
    img_grad_mag = sqrt(img_dx.^2 + img_dy.^2);
    img_grad_or = atan2(img_dy, img_dx);
    img_thresh = img_grad_mag > tau;
    
    thinImg = bwmorph(img_thresh,'thin',Inf);
   % imshow(thinImg);
   %imshow(img_thresh);
end 