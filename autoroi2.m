 function [hand_roi,x,y,w,h] = autoroi2(bwimage)
% auto enture the ROI region of hands
 
[row,col] = find(bwimage==1);
y_roi = min(col);
x_roi = min(row);
width_roi = max(col)-min(col);
height_roi = max(row)-min(row);
   
    if isempty(row)==1
        x = 0;
        y = 0;
        w = 0;
        h = 0;
        hand_roi = bwimage;
%         w = size(bwimage,2);
%         h = size(bwimage,1);
    else
        hand_roi = imcrop(bwimage,[y_roi,x_roi,width_roi,height_roi]); % 以左上角点的横纵坐标，宽，高；来裁剪图片
        w = width_roi;
        h = height_roi;
        x = x_roi;
        y = y_roi;
    end
 end