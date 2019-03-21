function [s,bw,box_small] = Comp_foam(IM,bwt,x,y)


x_point = x(1);
y_point = y(1);
width =  y(2)-y(1); 
height = x(2)-x(1);

    box = imcrop(IM,[y_point,x_point,width,height]);
    box_small = imresize(box,0.3);
%     box_c = illumination_correct(box_small);
     I = rgb2gray(box_small);
     bw = im2bw(I,bwt);
     [r,c] = size(bw);
     s = length(find(bw==1))/(r*c);
end