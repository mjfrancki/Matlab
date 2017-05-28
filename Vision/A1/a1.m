%Assignment 1
%1 convolution 

fprintf('Part 1.1\n')

fprintf(['0  0  0  0  0  0  0  0  0  0\n' ...
         '0  0  0  0  0  0  0  0  0  0\n' ... 
         '0  0  2  1 -1  2 -1 -3  0  0\n' ...
         '0  0  1  1  0  0 -1 -1  0  0\n' ...       
         '0  0  3  1 -2  4 -1 -5  0  0\n' ...
         '0  0  1  1  0  0 -1 -1  0  0\n' ...
         '0  0  1  1  0  0 -1 -1  0  0\n' ...
         '0  0  0  0  0  0  0  0  0  0\n' ... 
         '0  0  0  0  0  0  0  0  0  0\n'])
     
fprintf('Part 1.2\n')

fprintf('Gradient Magnituge:\n')
fprintf('[2,3] = 1.41421356237\n')
fprintf('[4,3] = 1\n')
fprintf('[4,6] = 1\n')

fprintf('Part 1.3\n')

img = imread('img3.tiff');
img = im2double(img);

%img = ones(10,10,1);


imgPart1 = [0,  0,  0,  0,  0,  0,  0,  0,  0,  0;
         0,  0,  0,  0,  0,  0,  0,  0,  0,  0;
         0,  0,  0,  2,  1,  1,  3,  0,  0,  0;
         0,  0,  0,  1,  1,  1,  1,  0,  0,  0;     
         0,  0,  0,  3,  1,  1,  5,  0,  0,  0;
         0,  0,  0,  1,  1,  1,  1,  0,  0,  0;
         0,  0,  0,  1,  1,  1,  1,  0,  0,  0;
         0,  0,  0,  0,  0,  0,  0,  0,  0,  0; 
         0,  0,  0,  0,  0,  0,  0,  0,  0,  0];



%assumption square matrix with odd length 
x =  [0,0,0 ; 
     1,0,-1 ; 
     0,0,0];


 myConvTest = MyConv(imgPart1,x);

 myConvTest
 
fprintf('Part 1.4\n')


filter = fspecial('gaussian',13,2);


preBuilt = imfilter(img, filter); 
meBuilt = MyConv(img, filter);
%figure('Name','Built in','NumberTitle','off'), imshow(preBuilt,[])

preBuilt = imsubtract(preBuilt,img);

meBuilt = imsubtract(meBuilt,img);

%preBuilt

%meBuilt
   

figure('Name','Built in','NumberTitle','off'), imshow(preBuilt,[])
figure('Name','Built by me','NumberTitle','off'), imshow(meBuilt,[])


fprintf('The prebuilt imfilter() and MyConv() give the same results\n')


fprintf('Part 1.5\n')


testImg = ones(640,480,3);
filter = fspecial('gaussian',13,3);

filterX = fspecial('gaussian',[1, 13],3);
filterY = fspecial('gaussian',[13, 1],3);

fprintf('2D Conv:\n')

tic 
twoDconv = imfilter(testImg,filter,'conv');
toc

fprintf('two 1D Conv:\n')

tic
oneDconv = imfilter(imfilter(testImg,filterX),filterY);
toc

function y = MyConv(image, kernel)

%flip kernal
kernel = flipud( fliplr(kernel) );


[kerHieght,kerWidth] = size(kernel); 
[imgHieght,imgWidth,z] = size(image); 

padWidth = imgWidth + (2*kerWidth);
padHieght = imgHieght + (2*kerHieght);

%disp(padWidth)
%disp(padHieght)

 kernalsize = kerWidth;
 kernalCenter = ceil(kerWidth / 2);
 kernalAdj = floor(kerWidth / 2);
 
%create image with padding 

imgPadded = zeros(padHieght, padWidth, size(image,3) );

for i = kerHieght+1 : imgHieght + kerHieght

  for j = kerWidth+1 : imgWidth + kerWidth
     
      
      temp = image(i-kerHieght, j-kerWidth, :);
      imgPadded(i,j,:) =  temp;
      
      
   
  end 

end

%fill in new image 

newImage = zeros(imgHieght, imgWidth, size(image,3)) ;


for i =  kerHieght+1 : imgHieght + kerHieght

  for j = kerWidth+1 : imgWidth + kerWidth
     
          sum = 0; 
          for k = 0 : kernalsize - 1
               for m = 0 : kernalsize -1
                  sum = sum + ( imgPadded(i - kernalAdj + k , j - kernalAdj + m ,:) )*(kernel(k+1,m+1));
               end
          end
      
         % fprintf('%d   ',sum)
      %temp = image(i-kerHieght, j-kerWidth, :);
      newImage(i-kerHieght,j-kerWidth,:) =  sum;
      
      
   
  end 
  % fprintf('\n')
end


%imshow(imgPadded,[]);

%[imgHieghtPad,imgWidthPad,z] = size(imgPadded); 

%disp(imgWidthPad)
%disp(imgHieghtPad)

%figure('Name','Rolled by me','NumberTitle','off'), imshow(newImage,[])


%imgPadded
y = newImage;
end







