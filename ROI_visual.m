%  clear all;clc;close all
path = pwd;
vidObj = VideoReader('Video\yy5.mp4');                                     % path of video
I = read(vidObj,59);
figure;imshow(I);

load('ROI_yy5.mat')
x_ws(1) = x_ws(1)+77;

x = [x_et;x_ws;x_sp;x_fm;x_gs;x_et2];
y = [y_et;y_ws;y_sp;y_fm;y_gs;y_et2];
 
for i = 1:2:length(x)
position{i,1} = [y(i),x(i),y(i+1)-y(i),x(i+1)-x(i)];   
rectangle('position',position{i},'edgecolor','r','linewidth',2);
end
