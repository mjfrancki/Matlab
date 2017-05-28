%
%Least Squares Fitting of a Plane
%

% plane z = alpha x + beta y + gamma  

alph = 0.1;
beta = 0.2;
gamma = 0.3;

noise  = randn(3,500);
%noise = zeros(3,500);
points = noise;
%points = zeros(3,500);
%disp(points)

for n = 1:500
    
    x = rand;
    y = rand; 
    z = alph * x + beta * y + gamma ;
    
   points(1,n) =  points(1,n) + x;
   points(2,n) =  points(2,n) + y;
   points(3,n) =  points(3,n) + z;

   plot3(points(1,n),points(2,n),points(3,n),'marker','o'); hold on;

end

x = points(1,:);
y = points(2,:);
z = points(3,:);
 
N = 500;

sx = sum(x);
sy = sum(y);
sz = sum(z);
sxx = sum(x.^2);
sxy = sum(x .* y);
syy = sum(y.^2);
sxz = sum(x .* z);
syz = sum(y .* z);

mat = [sxx sxy sx; sxy syy sy; sx sy N];
ans = [sxz syz sz];

mat_1 = mat;
mat_1(:,1) = transpose(ans);
a = det(mat_1)/det(mat);

mat_1 = mat;
mat_1(:,2) = transpose(ans);
b = det(mat_1)/det(mat);

mat_1 = mat;
mat_1(:,3) = transpose(ans);
c = det(mat_1)/det(mat);


fprintf('The true Alpha is %f \n ', alph);
fprintf('The estimate for Alph is %f \n ', a);
fprintf('The Absolute error is %f \n ', abs(alph - a) );

fprintf('The true Beta is %f \n ', beta);
fprintf('The estimate for beta is %f \n ', b);
fprintf('The Absolute error is %f \n ', abs(beta - b));

fprintf('The true Gamma is %f \n ', gamma);
fprintf('The estimate for Alph is %f \n ', c);
fprintf('The Absolute error is %f \n ', abs(gamma - c));


x=-4:.1:4;
[X,Y] = meshgrid(x);

Z = a * X + b * Y + c  ;
surf(X,Y,Z)
shading flat




