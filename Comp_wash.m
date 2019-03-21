function hand = Comp_wash(IM,x,y)

x_point = x(1);
y_point = y(1);
width =  y(2)-y(1);
height = x(2)-x(1);

box = imcrop(IM,[y_point,x_point,width,height]);
box = imresize(box,0.3);
% box = illumination_correct(box);
box = ColorEnhance(box);
hand = skindetect2(box);
end