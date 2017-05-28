

imageDir = 'cropped_training_images_faces';
imageList = dir(sprintf('%s/*.jpg',imageDir));
nImages = length(imageList);

new_Dir = 'validation_images_faces';
mkdir(new_Dir);
 

size = floor(nImages*0.20);

indexSample = randsample(nImages,size);


for n = 1 : size
    
    indx = indexSample(n);
    
    movefile( strcat('./cropped_training_images_faces/', imageList(indx).name) , strcat('./validation_images_faces/', imageList(indx).name) ) 
       
end