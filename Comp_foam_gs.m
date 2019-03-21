function [s,bw] = Comp_foam_gs(box,bwt)

    box_ic = illumination_correct(box);
     I = rgb2gray(box_ic);
     bw = im2bw(I,bwt);
     [r,c] = size(bw);
     s = length(find(bw==1))/(r*c);
end