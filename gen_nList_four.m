function nList = gen_nList_four(img)
[h,w,c] = size(img);
dir = 4;
nList = zeros(h*w,dir);
for y = 1:h
    for x = 1:w
        if x > 1
            nList((x-1)*h+y,1) = (x-2)*h+y;     %left
        end
        
        if x < w
            nList((x-1)*h+y,2) = (x)*h+y;       %right
        end
        
        if y >1
            nList((x-1)*h+y,3) = (x-1)*h+y-1;       %up
        end
        
        if y<h
            nList((x-1)*h+y,4) = (x-1)*h+y+1;       %down
        end
    end
end
