function [score,bw,diff] = Comp_effluent(IM,I_t,thresh,x,y)


x_point = x(1);
y_point = y(1);
width =  y(2)-y(1); 
height = x(2)-x(1);
I_t = rgb2gray(I_t);                                                        % graying
I_tc = imcrop(I_t,[y_point,x_point,width,height]);                          % crop the ROI

    box = imcrop(IM,[y_point,x_point,width,height]);
    box = rgb2gray(box);                                                    % RGBÍ¼Ïñ×ª»»³É»Ò¶ÈÍ¼
    diff = uint8(abs(double(box)-double(I_tc)));                            % difference of template and image
    bw = im2bw(diff,thresh);                                                % binarization writing
    [r,c] = size(bw);                                                       % row and colmn of bw
    score = length(find(bw==1))/(r*c);                                      % effluent ratio in the ROI
% edge(I,'canny',0.35);
end