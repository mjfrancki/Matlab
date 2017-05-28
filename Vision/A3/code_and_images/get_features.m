close all
clear
run('C:/dev/vlfeat-0.9.20/toolbox/vl_setup');

pos_imageDir = 'training_images\pos';
pos_imageList = dir(sprintf('%s/*.jpg',pos_imageDir));
pos_nImages = length(pos_imageList);

neg_imageDir = 'training_images\neg';
neg_imageList = dir(sprintf('%s/*.jpg',neg_imageDir));
neg_nImages = length(neg_imageList);

cellSize = 6;
featSize = 31*cellSize^2;

pos_train_feats = zeros(pos_nImages,featSize);
for i=1:pos_nImages
    im = im2single(imread(sprintf('%s/%s',pos_imageDir,pos_imageList(i).name)));
    feat = vl_hog(im,cellSize);
    pos_train_feats(i,:) = feat(:);
    fprintf('got feat for pos image %d/%d\n',i,pos_nImages);
%     imhog = vl_hog('render', feat);
%     subplot(1,2,1);
%     imshow(im);
%     subplot(1,2,2);
%     imshow(imhog)
%     pause;
end

neg_train_feats = zeros(neg_nImages,featSize);
for i=1:neg_nImages
    im = im2single(imread(sprintf('%s/%s',neg_imageDir,neg_imageList(i).name)));
    feat = vl_hog(im,cellSize);
    neg_train_feats(i,:) = feat(:);
    fprintf('got feat for neg image %d/%d\n',i,neg_nImages);
%     imhog = vl_hog('render', feat);
%     subplot(1,2,1);
%     imshow(im);
%     subplot(1,2,2);
%     imshow(imhog)
%     pause;
end

save('training_feats.mat','pos_train_feats','neg_train_feats','pos_nImages','neg_nImages')