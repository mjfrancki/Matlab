run('C:/dev/vlfeat-0.9.20/toolbox/vl_setup');
load ('svm.mat');

imageDir = 'test_images_temp';
imageList = dir(sprintf('%s/*.jpg',imageDir));
nImages = length(imageList);

bboxes = zeros(0,4);
confidences = zeros(0,1);
image_names = cell(0,1);

cellSize = 6;
dim = 36;
for i=1:nImages
    % load and show the image
     im = im2single(imread(sprintf('%s/%s',imageDir,imageList(i).name)));
    
    t = true;
    best_conf = -100; 
    temp_im = im; 
    scale = 1;
    while t == true
        
      % generate a grid of features across the entire image. you may want to 
      % try generating features more densely (i.e., not in a grid)
      feats = vl_hog(temp_im,cellSize); 
      %imhog = vl_hog('render', feats);
      %imshow(imhog);
    
      % concatenate the features into 6x6 bins, and classify them (as if they
      % represent 36x36-pixel faces)
      [rows,cols,~] = size(feats);    
      confs = zeros(rows,cols);
      for r=1:rows-5 
        for c=1:cols-5
            
        % create feature vector for the current window and classify it using the SVM model, 
        feature_window = feats(r:r+5,c:c+5,:);
        feature_window = reshape(feature_window,1,1116);
        % take dot product between feature vector and w and add b,
        confidence = [feature_window]*w + b;

	    % store the result in the matrix of confidence scores confs(r,c)
        confs(r,c) = confidence;

        end
      end
       
      conf_score = sum(confs(:)) / (((size(confs,1)-5) * (size(confs,2)-5)));
      if conf_score > best_conf
        best_conf = conf_score;
        disp(scale);
        scale = scale - 0.05;
        temp_im = imresize(temp_im, scale); 
      else
         t = false; 
      end    
    
    end
    
    fprintf("scale is %d", scale);
    imshow(im);  
    hold on;
    
    [~,inds] = sort(confs(:),'descend');
    %CHANGE 2 FROM CONSTANT VALUE TO PRODUCT OF ROWS/COL
    inds = inds(1:15); % (use a bigger number for better recall)
    
%     %non maximum supression------------------------------------------------
%     
%     %UPGRADE TO
%     %overlap = area(box1 union box2)/        > threshold
%     %          area(box1 intersection box2)
%     %and take highest score of both
%     
%     j = numel(inds) -1;
%     c = cellSize;
%     rem = [];
%     for n=1:j        
%         [row_1,col_1] = ind2sub([size(feats,1) size(feats,2)],inds(n));
%         %check if the subsequent array items are within cellSize bounds,
%         %and remove them if they are
%         for m=n:numel(inds)
%           if m ~= n 
%               
%            [row_2,col_2] = ind2sub([size(feats,1) size(feats,2)],inds(m));    
%          
%            %check if bounding box is within parents bounding box 
%            if ((row_1+c-1)*c < row_2 * c) || (row_1 * c > (row_2+c-1)*c) ||((col_1+c-1)*c < col_2 * c) || (col_1 * c > (col_2+c-1)*c)
%             %boxes dont overlap
%            else
%             rem = [rem;m];    
%            end
%           end
%             
%         end 
%         
%     end    
%     rem = unique(rem);
%     inds(rem) = [];
%     
%     %----------------------------------------------------------------------
    
    for n=1:numel(inds)        
        [row,col] = ind2sub([size(feats,1) size(feats,2)],inds(n));  
        
        bbox = [ col*cellSize ...
                 row*cellSize ...
                (col+cellSize-1)*cellSize ...
                (row+cellSize-1)*cellSize];
        conf = confs(row,col);
        image_name = {imageList(i).name};
        
        % plot
        plot_rectangle = [bbox(1), bbox(2); ...
            bbox(1), bbox(4); ...
            bbox(3), bbox(4); ...
            bbox(3), bbox(2); ...
            bbox(1), bbox(2)];
        plot(plot_rectangle(:,1), plot_rectangle(:,2), 'g-');
        
        % save         
        bboxes = [bboxes; bbox];
        confidences = [confidences; conf];
        image_names = [image_names; image_name];
    end
    pause;
    fprintf('got preds for image %d/%d\n', i,nImages);
end

%evaluate
label_path = 'test_images_gt.txt';
[gt_ids, gt_bboxes, gt_isclaimed, tp, fp, duplicate_detections] = ...
    evaluate_detections_on_test(bboxes, confidences, image_names, label_path);
