c_img = imread('bowling//view1_gray.png');
d_img = imread('bowling//disp1.png');
% c_img = imread('cones//im6.png');
% d_img = imread('cones//disp6.png');
c_img = im2double(c_img);
d_img = im2double(d_img);
% d_img(d_img>0.9) = 0;

% c_img = imresize(c_img,0.1);
% d_img = imresize(d_img,0.1);
% d_img(d_img<0.05) = 0;
tic;
f_img = depth_filling_LBP(c_img,d_img,10);
toc;
f_img(d_img~=0) = d_img(d_img~=0);
figure,imshow(c_img);
figure,imshow(d_img);
figure,imshow(f_img);