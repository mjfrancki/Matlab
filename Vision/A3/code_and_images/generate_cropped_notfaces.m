
% you might want to have as many negative examples as positive examples

n_have = 0;
n_want = numel(dir('cropped_training_images_faces/*.jpg'));


imageDir = 'images_notfaces';
imageList = dir(sprintf('%s/*.jpg',imageDir));
nImages = length(imageList);

new_imageDir = 'cropped_training_images_notfaces';
new_valDir = 'validation_images_notfaces';
mkdir(new_imageDir);
mkdir(new_valDir);
dim = 36;
I2 = zeros(100);
imwrite(I2,strcat('./validation_images_notfaces/', 'test') ,'jpg' );

while n_have < n_want
    
  for n=1:nImages
      
  if n_have > n_want
     break;
  end
  
  % generate random 36x36 crops from the non-face images
  name = imageList(n).name;
  I = rgb2gray(imread(fullfile(imageList(n).folder, name)));
  
  x = size(I,2);
  y = size(I,1);

  xmin=dim;
  xmax=x - dim;
  x2 = round(xmin+rand(1,1)*(xmax-xmin));
  ymin=dim;
  ymax=y - dim;
  y2 = round(ymin+rand(1,1)*(ymax-ymin));

  I2 = imcrop(I,[x2 y2 35 35]);
  
  new_x = size(I2,2);
  new_y = size(I2,1);
  
  if new_x == 36 & new_y == 36
   a=0;
   b = 99999999;
   n = round(a+rand(1,1)*(b-a));
  
   %but 20% in validation set
   if n_have/n_want > 0.20
    imwrite(I2,strcat('./cropped_training_images_notfaces/', num2str(n)),'jpg' );
  
   else
    imwrite(I2,strcat('./validation_images_notfaces/', num2str(n)),'jpg' );  
   end    
   
   n_have = n_have + 1;
   %fprintf("processed: %d/%d",n_have,n_want);
  end
  
  
  end  
   
end