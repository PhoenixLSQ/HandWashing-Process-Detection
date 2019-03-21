function [s,bw] = Comp_foam_gsni(box,bwt)

%     box_ic = illumination_correct(box);
     I = rgb2gray(box);
     bw = im2bw(I,bwt);
     [r,c] = size(bw);
     s = length(find(bw==1))/(r*c);
end