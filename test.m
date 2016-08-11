img = imread('bowling//view1_gray.png');
d_img = imread('bowling//disp1.png');
img = double(img);
d_img = im2double(d_img);
scale = 0.5;
r_img = imresize(img,scale);
pSize = 5; nn = 10;
% visualizer(r_img, cnn, pSize);
h_img = img;
h_img(d_img==0) = 0;
rh_img = imresize(h_img,scale);
[h,w] = size(h_img);
figure,imshow(h_img/255);
cnn = patchmatch(r_img, rh_img, pSize, nn, 20, [], 1, [], [], [], 2);

visualizer(r_img, cnn, pSize);
for y = 1:h
    for x = 1:w
        if(h_img(y,x) == 0);
            [rx,ry] = map_coord(x,y,scale);
            for i = 1:nn
                n_c = cnn(ry,rx,:,i);
                if n_c(1) > 0 && n_c(2) > 0 && rh_img(n_c(2),n_c(1))>0
                        h_img(y,x) = rh_img(n_c(2),n_c(1));
                    break;
                end
            end
        end
    end
end


figure,imshow(h_img/255);

