function [hl,hand] = Comp_soap_new(IM,x,y)

x_point = x(1);
y_point = y(1);
width =  y(2)-y(1);
height = x(2)-x(1);

    box = imcrop(IM,[y_point,x_point,width,height]);
%     box = imresize(box,0.3);
    hand = skindetect2(box);
    hl = length(find(hand==1))/(size(hand,1)*size(hand,2));                     %high light ratio in ROI
    
end

