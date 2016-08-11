function [vList,dataCost] = gen_vList_patchmatch(c_img,d_img)
[h,w,c] = size(d_img);
label = 8;
vList = zeros(h*w,label);
dataCost = zeros(h*w,label);

scale = 1;
r_img = imresize(c_img,scale);
pSize = 7; nn = 20;
h_img = c_img;
h_img(d_img==0) = 0;
rh_img = imresize(h_img,scale);
tic;
% color_img = imread('cones//im6.png');
% color_img = double(color_img);
% d_img_3 = zeros(h,w,3);
% d_img_3(:,:,1) = d_img;
% d_img_3(:,:,2) = d_img;
% d_img_3(:,:,3) = d_img;
% color_img_hole = color_img;
% color_img_hole(d_img_3==0) = 0;
% cnn = patchmatch(color_img, color_img_hole, pSize, nn, 250, [], 10, [], [], [], 2);
cnn = patchmatch(r_img, rh_img, pSize, nn, 200, [], 10, [], [], [], 2);
visualizer(rh_img*255, cnn, pSize);
toc;
global p;
p = pSize+1;
p_cimg = padarray(c_img,[p,p],'replicate');
p_dimg = padarray(d_img,[p,p],'replicate');
for y = 1:h
    if (mod(h,10) == 0) fprintf('.');end
    for x = 1:w
        index = (x-1)*h+y;
        if(d_img(y,x) == 0)
            [rx,ry] = map_coord(x,y,scale);
            nL = 1; 
            for i = 1:nn
                n_c = cnn(ry,rx,:,i);
                nx = n_c(1)*floor(1/scale);
                ny = n_c(2)*floor(1/scale);
                val = get_label_value(d_img,nx,ny);
                
                if val > 0.0001
                    vList(index,nL) = val;
                    c_cost = get_color_distance(p_cimg,x,y,nx,ny,pSize);
                    d_cost = get_depth_distance(p_dimg,x,y,nx,ny,pSize);
                    dataCost(index,nL) = c_cost + 0*d_cost;
                    nL = nL+1;
                    if nL>label
                        break
                    end;
                end
            end
        else
            vList(index,1) = d_img(y,x);
            dataCost(index,1) = 0;
            for i = 2:label
                vList(index,i) = d_img(y,x);
                dataCost(index,i) = 100;
            end
        end
    end
end
dataCost(vList==0) = 100;
t_img = vList(:,1);
t_img = reshape(t_img,[h,w]);
figure,imshow(t_img);
end     % gen_vList_patchmatch() end here

function [val] = get_label_value(d_img,nx,ny)
[h,w] = size(d_img);
val = 0;
if nx > 1 && ny > 1 && nx < w && ny <h
    patch = d_img(ny-1:ny+1,nx-1:nx+1);
    patch(patch == 0) = [];
    val = sum(patch(:))/(numel(patch)+0.0001);
    
    if val>0.9
        stop = 1;
    end
end
end

function [cost] = get_color_distance(img, x, y, nx, ny, r)
global p;
sub_a = img(y+p-r:y+p+r,x+p-r:x+p+r);
sub_b = img(ny+p-r:ny+p+r,nx+p-r:nx+p+r);
diff = sub_a - sub_b;
diff = diff.*diff;
cost = sum(diff(:))/((2*r+1)*(2*r+1));
cost = sqrt(cost);
end

function [cost] = get_depth_distance(img, x, y, nx, ny, r)
global p;
sub_a = img(y+p-r:y+p+r,x+p-r:x+p+r);
sub_b = img(ny+p-r:ny+p+r,nx+p-r:nx+p+r);
sub_a(sub_a ==0) = [];
sub_b(sub_b ==0) = [];
d_a = sum(sub_a(:))/(numel(sub_a)+0.0001);
d_b = sum(sub_b(:))/(numel(sub_b)+0.0001);
cost = abs(d_a-d_b);
end



