synth0 = imread('synth_0.png');
%img1 = rgb2gray(img1);
synth1 = imread('synth_1.png');
%img2 = rgb2gray(img2);

imgbt0 = imread('bt_0.png');
imgbt1 = imread('bt_1.png');


sphere0 =  rgb2gray( imread('sphere_0.png'));
sphere1 =  rgb2gray( imread('sphere_1.png'));

opticFlow = opticalFlowLK('NoiseThreshold',0.009);
flow = estimateFlow(opticFlow,imgbt0);
flow = estimateFlow(opticFlow,imgbt1);


myFlow(sphere0, sphere1, 20, 0.001);
%myFlow(imgbt0 , imgbt1 , 10, 0.1);
%myFlow(synth0 ,  synth1, 10, 0.1);


function y =  myFlow(img1, img2, window, threshold)

w = window;
t =threshold; 
img1 = double(img1)/double(max(img1(:)));
img2 = double(img2)/double(max(img2(:)));



filterSpatial_x = [-1 1; -1 1];
filterSpatial_y = [-1 -1; 1 1];
sigma = 1;
filterTemporal = fspecial('gaussian', [5 5], sigma);


img1 = imfilter(img1, filterTemporal); 
img2 = imfilter(img2, filterTemporal); 

imgDif = img2 - img1;


Ix_m = conv2(imgDif,filterSpatial_x);
Iy_m = conv2(imgDif,filterSpatial_y);
It_m = conv2(imgDif,filterTemporal);
u = zeros(size(imgDif));
v = zeros(size(imgDif));
valid = ones(size(imgDif));




for i = w+1:size(Ix_m,1)-w
   for j = w+1:size(Ix_m,2)-w
      Ix = Ix_m(i-w:i+w, j-w:j+w);
      Iy = Iy_m(i-w:i+w,j-w:j+w);
      It = It_m(i-w:i+w, j-w:j+w);
      Ix = Ix(:);
      Iy = Iy(:);
      b = -It(:); 
      A = [Ix Iy]; 
      nu = pinv(A)*b; 
      u(i,j)=nu(1);
      v(i,j)=nu(2);
      
      if  eig(It) < t
            valid(i,j) = 0; 
             u(i,j) = 0;
             v(i,j) = 0;
      end;
  
   end;
end;

%figure, imshow(img1, []);
%figure, imshow(img2, []);
figure, imshow(u,[]);
figure, imshow(v,[]);
figure, imshow(valid,[]);
% 
flow(:,:,1) = u;
flow(:,:,2) = v;
colorFlow = flowToColor(flow);
figure, imshow(colorFlow,[]);
y =  [u,v,valid];
%summmation:

end
