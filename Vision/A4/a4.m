%1.1
ksizes = [5 7 13 21 31 41 51 71];

%need a 2d-color image
im = rgb2gray(imread('image.jpg'));

s = 2;

for i = ksizes
    tic
        gauss = fspecial('gaussian', [i i],s);
        filter = conv2(double(gauss), double(im));
    toc
    %times(j) = toc;
    j = j+1;
end

%imshow(filter, []);

pause;
plot(ksizes, times); 
pause;

%1.2
 
ksizes = [5 7 13 21 31 41 51 71];
im = rgb2gray(imread('image.jpg'));
im = double(rgb2gray(im))/255;

%times = zeros(size(ksizes));
j = 1;
for i = ksizes
    tic
        f = fspecial('gaussian', [i i], s);
    
        im_dft = fft2(im, size(im,1), size(im,2));
        f_dft = fft2(f, size(im,1), size(im,2));
        
        im_f_dft = im_dft.* f_dft;
        im_f = ifft2(im_f_dft);
    toc
   % times(j) = toc;
     j = j+1;
end
plot(ksizes, times);
imshow(im_f, []);
%1.3:


%2.1:



