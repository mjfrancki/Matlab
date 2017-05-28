%Preprocessing
%read in images
imgLeft = imread('pl.jpg');

imgLeft = imresize(imgLeft,0.2);

imgLeft = im2double(imgLeft);

Lred = imgLeft(:,:,1);
Lgreen = imgLeft(:,:,2);
Lblue = imgLeft(:,:,3);


imgRight = imread('pr.jpg');

imgRight = imresize(imgRight,0.2);

imgRight = im2double(imgRight);

Rred = imgRight(:,:,1);
Rgreen = imgRight(:,:,2);
Rblue = imgRight(:,:,3);

imgSize = size(imgLeft);
imgSizeR  = size(imgRight);
%convert to gray scale 
imgLeft = rgb2gray(imgLeft);
imgRight = rgb2gray(imgRight);

%convert to sigle 
imgLeft = single(imgLeft);
imgRight = single(imgRight);
%imgLeft  = imcrop(imgLeft,[0,0,2266,2400]); 
%img = cat(2,imgLeft,imgRight);


%Detect keypoints and extract descriptors
[fl,dl] = vl_sift(imgLeft) ;
[fr,dr] = vl_sift(imgRight) ;

%Match features

matches = zeros( 2, (size(dl,2)) );
scores = zeros( 1, (size(dl,2)) );


 
smallest = inf;
smallL = 0 ;
smallR = 0 ;

 
 tempL =  dl(:,3)' ;
 tempR =   dr(:,1)' ;
 tempL = single(tempL);
 tempR = single(tempR);
 % temp = dist2( dl(:,1)' , dr(:,1)' );   
   temp = dist2(tempL,tempR);
   
for i = 1 : size(dl,2)
   smallest = inf;
    for j = 1 : size(dr,2)
   
     tempL =  dl(:,i)' ;
 tempR =   dr(:,j)' ;
 tempL = single(tempL);
 tempR = single(tempR);
        temp = dist2( tempL , tempR );    
    
      if temp < smallest
      smallest = temp;
      smallL = i;
      smallR = j;
      end   
        
    end
    
  scores(i) = smallest;
  matches(1,i) =  smallL;  
  matches(2,i) =  smallR;  
end

% Prune features
% 
  indices = find(abs(scores)>150);
  scores(indices) = [];
  matches(:,indices) = [];
  


[matchesT, scoresT] = vl_ubcmatch(dl, dr) ;

% implement RANSAC
rndpnts = 2;
iterations = 10000;
matchThreshold = 11;
PointsMatched = 100;

bestinCount = 0;
bestP1 = 0 ;
bestP2 = 0 ;
 for n = 1:iterations
     
 inCount = 0;
 
     
 rndIndc = randsample(size(matches,2), rndpnts );

 P1 =matches(:, rndIndc(1) )';
 P2 =matches(:, rndIndc(2) )';
 
 
 
 for i = 1 : size(matches,2)

     d = abs( det([matches(:,i)'-P1;P2 - P1])) / norm(P2-P1); 

     if d < matchThreshold
        inCount = inCount +1 ; 
     end
     
 end
 
 if inCount > bestinCount 
     bestinCount = inCount;
     bestP1 = P1' ;
     bestP2 = P2' ;
 end 

 end
  
 inlinerlist = zeros (2, bestinCount);
 

   
     P1 = bestP1';
     P2 = bestP2';
     count = 0;
     
  for i = 1 : bestinCount

     d = abs( det([matches(:,i)'-P1;P2 - P1])) / norm(P2-P1); 

     if d < matchThreshold
       count = count + 1 ;
         inlinerlist(1,count) = matches(1,i) ; 
         inlinerlist(2,count) = matches(2,i) ;
     end
     
  end
 
 
 %get location of features from frame 
  
 imgLfeatureLocation = zeros(2,bestinCount); 
 imgRfeatureLocation = zeros(2,bestinCount);
 
 
 for i = 1 : bestinCount
     
     if inlinerlist(1,i) > 0 && inlinerlist(2,i) > 0
     
     imgLfeatureLocation(1, i) = fl(1, inlinerlist(1,i)  );
     imgLfeatureLocation(2, i) = fl(2, inlinerlist(1,i)  );
     
     imgRfeatureLocation(1, i) = fr(1, inlinerlist(2,i) );
     imgRfeatureLocation(2, i) = fr(2, inlinerlist(2,i) );
  
     
     end
 end
     
 
  %indices = find(abs(imgLfeatureLocation) < 0);
  %imgLfeatureLocation(:,indices) = [];
  %imgRfeatureLocation(:,indices) = [];

 %get affline transformation 
 

 A = [imgLfeatureLocation' ones(size(imgLfeatureLocation'))];
 t = A\imgRfeatureLocation';
 
 affline = zeros(3,3);
 
     affline(1,1) = t(1,1);
     affline(2,1) = t(2,1);
     affline(3,1) = t(3,1)*-1;
     
     affline(1,2) = t(1,2);
     affline(2,2) = t(2,2);
     affline(3,2) = t(3,2)*-1;
     
      affline(3,3) = 1;
     
      
     %tform = estimateGeometricTransform(imgRfeatureLocation',imgLfeatureLocation',...
    %'affine');
   
      tform = affine2d(affline);
      idtform = affine2d([[1 0 0];[0 1 0];[0 0 1]]);
      imgLeftTrans = imwarp(imgLeft,tform);
      



%[LTheight, LTwidth] = size(imgLeftTrans);
 [Rheight, Rwidth] = size(imgRight);
[Lheight, Lwidth] = size(imgLeft);

PanoView = imref2d([Rheight+Lheight,Rwidth+Lwidth,3]);

 warpedImageL = imwarp(imgLeft, idtform, 'OutputView', PanoView);
 warpedImageR = imwarp(imgRight, tform, 'OutputView', PanoView);
 
 
%**************color**************
RwarpedImageL = imwarp(Lred, idtform, 'OutputView', PanoView);
RwarpedImageR = imwarp(Rred, tform, 'OutputView', PanoView);
 
GwarpedImageL = imwarp(Lgreen, idtform, 'OutputView', PanoView);
GwarpedImageR = imwarp(Rgreen, tform, 'OutputView', PanoView);
 
BwarpedImageL = imwarp(Lblue, idtform, 'OutputView', PanoView);
BwarpedImageR = imwarp(Rblue, tform, 'OutputView', PanoView);
 
 
RGBwarpedImageL = cat(3,RwarpedImageL,GwarpedImageL,BwarpedImageL);
RGBwarpedImageR = cat(3,RwarpedImageR,GwarpedImageR,BwarpedImageR);

figure('Name','Left','NumberTitle','off'),imshow( RGBwarpedImageL  ) 
figure('Name','Right','NumberTitle','off'),imshow( RGBwarpedImageR  )

Panorama = RGBwarpedImageL ;

 %   imshow( panorama ) 

%Panorama = gt(warpedImageL,warpedImageR)

 
%  for i = 1 : Rheight+Lheight
%      
%      for j = 1 : Rwidth+Lwidth
%      
%          if ( warpedImageL(i,j) > warpedImageR(i,j) )
%             Panorama(i,j,:) = RGBwarpedImageL(i,j,:);
%          else
%              Panorama(i,j,:) = RGBwarpedImageR(i,j,:);
%          end
%          
%      end
%  
%  end


for i = 1 : Rheight+Lheight
     
     for j = 1 : Rwidth+Lwidth
     
         if  Panorama(i,j,1) == 0 
            Panorama(i,j,:) = RGBwarpedImageR(i,j,:);
        
         end
         
     end
 
 end
 figure('Name','Pano','NumberTitle','off'),imshow( Panorama,[] )
 
 
   [LTheight, LTwidth] = size(imgLeftTrans);
   [Rheight, Rwidth] = size(imgRight);
 

 %  montage = imfuse(imgLeftTrans,imgRight,'montage');
 %  figure('Name','Images','NumberTitle','off'), imshow(montage)
 
   
 
   function n2 = dist2(x, c)


%	Description
%	D = DIST2(X, C) takes two matrices of vectors and calculates the
%	squared Euclidean distance between them.  Both matrices must be of
%	the same column dimension.  If X has M rows and N columns, and C has
%	L rows and N columns, then the result has M rows and L columns.  The
%	I, Jth entry is the  squared distance from the Ith row of X to the
%	Jth row of C.


[ndata, dimx] = size(x);
[ncentres, dimc] = size(c);
if dimx ~= dimc
	error('Data dimension does not match dimension of centres')
end

n2 = (ones(ncentres, 1) * sum((x.^2)', 1))' + ...
  ones(ndata, 1) * sum((c.^2)',1) - ...
  2.*(x*(c'));

% Rounding errors occasionally cause negative entries in n2
if any(any(n2<0))
  n2(n2<0) = 0;
end

end
