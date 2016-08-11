function [rx,ry] = map_coord(x,y,r)
ry = floor(y*r);
rx = floor(x*r);
if ry == 0
    ry = 1;
end
if rx == 0;
    rx = 1;
end