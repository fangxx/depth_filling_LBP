function t_map = depth_filling_LBP(c_img,d_img,it_num)
if size(c_img,3) == 3
    c_img = rgb2gray(c_img);
end
c_img = im2double(c_img);
d_img = im2double(d_img);

[h,w] = size(d_img);
nDir = 4;
nLabel = 8;
nData = nDir+1;

nList = gen_nList_four(d_img);
% [vList,dataCost] = gen_vList_four(c_img,d_img);
tic;
[vList,dataCost] = gen_vList_patchmatch(c_img,d_img);
toc;
msg = zeros(h*w,nData,nLabel);
msg(:,nData,:) = dataCost(:,:); %initial data cost

best = ones(h*w,1);

for it = 1:it_num
    fprintf('Iteration: %d\n',it);
    for di = 1:nDir
%         fprintf('direction: %d\n',di);
        %% msg = BP(msg,di);
        new_msg = zeros(h*w,nLabel);
        for i = 1:nLabel
            min_val = zeros(h*w,1);
            min_val(:) = 10000;
            for j = 1:nLabel
                p = zeros(h*w,1);
                p = p + smoothCost(i,j);
                p = p + msg(:,nData,j);
                for k = 1:nDir
                    if k ~= di
                        p = p + msg(:,k,j);
                    end
                end
                min_val = min(min_val,p);
            end
            new_msg(:,i) = min_val(:);
        end
        
        xList = nList(:,di);
        xList(nList(:,di)==0) = [];
        for i = 1:nLabel
            yList = new_msg(:,i);
            yList(nList(:,di)==0) = [];
            switch di
                case 1 %left
                    msg(xList,2,i) = yList;
                case 2 %right
                    msg(xList,1,i) = yList;
                case 3 %up
                    msg(xList,4,i) = yList;
                case 4 %down
                    msg(xList,3,i) = yList;
            end
        end
    end
    %% msg = MAP(msg);
    min_cost = zeros(h*w,1);
    min_cost = min_cost + 10000;
    for i = 1:nLabel
        t_cost = zeros(h*w,1);
        for j = 1:nData
            t_cost = t_cost + msg(:,j,i);
        end
        index = (t_cost < min_cost);
        min_cost(index) = t_cost(index);
        best(index) = i;
    end
    t_map = zeros(h*w,1);
    for i = 1:h*w
        t_map(i) = vList(i,best(i));
    end
    t_map = reshape(t_map,[h,w]);
    
    %% update vList (candidate)
%     [vList,dataCost] = gen_vList_four(c_img,t_map);
%     msg(:,nData,:) = dataCost(:,:); %initial data cost
    
    if(it == 1) figure(1),imshow(t_map); end
end
end


function cost = smoothCost(i,j)
    cost = 5*abs(i-j);
end


