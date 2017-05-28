img1 = rgb2gray(imread('m.jpg'));
img2 = rgb2gray(imread('p.jpg'));
img2 = imcrop(img2,[0,0,150,150]);
[im1h, im1w] = size(img1);
[im2h, im2w] = size(img2);
%imshow(img2);

%img1f = fft2(img1);
%img1f(1,1) = 0;
%img1f = log(1+abs(img1f));

%img2f = fft2(img2);
%img2f(1,1) = 0;
%img2f = log(1+abs(img2f));




%imshow(img1f,[])

%lowpass
sigma = 3;
filter1 = fspecial('gaussian',2*sigma*3+1,sigma);
filter1 = padarray(filter1,[im1h, im1w]-(2*sigma*3+1),'post');
filter1 = circshift(filter1, -3*[sigma sigma]);

im1_dft = fft2(img1, size(img1,1),size(img1,2));
f_dft   = fft2(filter1, size(img1,1),size(img1,2));

im1_f_dft = im1_dft .* f_dft;
im1_f = ifft2(im1_f_dft);

%imshow(im1_f, [])



%highpass
sigma = 3;

filter2 = fspecial('gaussian',2*sigma*3+1,sigma);

%filter2 = hpfilter('gaussian',2*sigma*3+1);
filter2 = padarray(filter2,[im2h, im2w]-(2*sigma*3+1),'post');
filter2 = circshift(filter2, -3*[sigma sigma]);

im2_dft = fft2(img2, size(img2,1),size(img2,2));

f_dft2   = fft2(filter2, size(img2,1),size(img2,2));
im2_f_dft = im2_dft .* f_dft2;

sharp =  im2_dft - im2_f_dft; 

im2_f = ifft2(im2_f_dft);
im2_f = ifft2(sharp);

figure('Name','low','NumberTitle','off') ,imshow(im1_f, [])
figure('Name','high','NumberTitle','off') ,imshow(im2_f, [])


blend = ifft2(sharp + im1_f_dft); 

figure('Name','bled','NumberTitle','off'), imshow(blend, [])



