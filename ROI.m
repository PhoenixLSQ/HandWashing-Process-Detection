clear;clc
path = pwd;
vidObj = VideoReader('Video\yy2.mp4');                                   % path of video
I = read(vidObj,420);
figure;imshow(I);
[y,x] = getpts(1);

x_et = x(1:2);                                                           % x of effluent
y_et = y(1:2);                                                           % y of effluent
x_ws = x(3:4);                                                           % x of wash
y_ws = y(3:4);                                                           % y of wash
x_sp = x(5:6);                                                           % x of soap 
y_sp = y(5:6);                                                           % y of soap
x_fm = x(7:8);                                                           % x of foam
y_fm = y(7:8);                                                           % y of foam

save([path,'\ROI_yy2_test.mat'],'x_et','y_et','x_ws','y_ws','x_sp','y_sp','x_fm','y_fm')
