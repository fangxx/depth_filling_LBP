function [vList,dataCost] = gen_vList_four(c_img,d_img)
[h,w,c] = size(d_img);
label = 4;
vList = zeros(h*w,label);
dataCost = zeros(h*w,label);
radius = 100;
for y = 1:h
    for x = 1:w
        index = (x-1)*h+y;
        if d_img(y,x)<=0 || 1
            for i = 1:radius
                t = x-i;
                if t>0 && d_img(y,t)>0
                    vList(index,1) = d_img(y,t);
                    dataCost(index,1) = abs(c_img(y,x) - c_img(y,t));
                    break;
                end
            end
            
            
            for i = 1:radius  
                t = x+i;
                if t<=w && d_img(y,t)>0
                    vList(index,2) = d_img(y,t);
                    dataCost(index,2) = abs(c_img(y,x) - c_img(y,t));
                    break;
                end
            end
            
            
            for i = 1:radius  
                t = y-i;
                if t>0 && d_img(t,x)>0
                    vList(index,3) = d_img(t,x);
                    dataCost(index,3) = abs(c_img(y,x) - c_img(t,x));
                    break;
                end
            end
            
            
            for i = 1:radius  
                t = y+i;
                if t<=h && d_img(t,x)>0
                    vList(index,4) = d_img(t,x);
                    dataCost(index,4) = abs(c_img(y,x) - c_img(t,x));
                    break;
                end
            end
        else
            vList(index,1) = d_img(y,x);
            dataCost(index,1) = 0;
            for i = 2:label
                vList(index,i) = d_img(y,x);
            end
        end
    end
end
costMax = 10000;
dataCost(vList == 0) = costMax;
end

