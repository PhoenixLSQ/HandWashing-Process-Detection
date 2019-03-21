function [diff,box] = Comp_effluent_edge(IM,I_t,x,y)


x_point = x(1);
y_point = y(1);
width =  y(2)-y(1); 
height = x(2)-x(1);
I_t = rgb2gray(I_t);                                                        % graying
I_tc = imcrop(I_t,[y_point,x_point,width,height]);                          % crop the ROI

    box_rgb = imcrop(IM,[y_point,x_point,width,height]);
    box = rgb2gray(box_rgb);                                                    % RGBͼ��ת���ɻҶ�ͼ
    diff = uint8(abs(double(box)-double(I_tc)));                            % difference of template and image
%     bw = im2bw(diff,thresh);                                                % binarization writing
%     [r,c] = size(bw);                                                       % row and colmn of bw
%     score = length(find(bw==1))/(r*c);                                      % effluent ratio in the ROI
% edge(I,'canny',0.35);
end