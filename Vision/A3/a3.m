close all
clear
run('C:/dev/vlfeat-0.9.20/toolbox/vl_setup');

pos_imageDir = 'validation_images';
pos_imageList = dir(sprintf('%s/*.jpg',pos_imageDir));
val_nImages = length(pos_imageList);

cellSize = 6;
featSize = 31*cellSize^2;

val_feats = zeros(val_nImages,featSize);
for i=1:val_nImages
    im = im2single(imread(sprintf('%s/%s',pos_imageDir,pos_imageList(i).name)));
    feat = vl_hog(im,cellSize);
    val_feats(i,:) = feat(:);
    fprintf('got feat for pos image %d/%d\n',i,val_nImages);
%     imhog = vl_hog('render', feat);
%     subplot(1,2,1);
%     imshow(im);
%     subplot(1,2,2);
%     imshow(imhog)
%     pause;
end


save('validation_feats.mat','val_feats','val_nImages')