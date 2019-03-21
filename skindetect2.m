function I = skindetect2(RGB)
% RGB=imread('yy\im_177.jpg');
% figure;imshow(RGB);
YCbCr=rgb2ycbcr(RGB);
Y=YCbCr(:,:,1);
Cb=YCbCr(:,:,2);
Cr=YCbCr(:,:,3);
%imshow(RGB);title('RGB');
%figure,imshow(YCbCr);title('YCbCr');
I=RGB;
rows=size(YCbCr,1);
columns=size(YCbCr,2);
k=(2.53/180)*pi;
m=sin(k);n=cos(k);
cx=109.38;cy=152.02;ecx=1.60;ecy=2.41;a=25.39;b=14.03;
for i=1:rows
    for j=1:columns
        if Y(i,j)<80
            I(i,j,:)=0;
        elseif (Y(i,j)<=230&&Y(i,j)>=80)
            x=(double(Cb(i,j))-cx)*n+(double(Cr(i,j))-cy)*m;
            y=(double(Cr(i,j))-cy)*n-(double(Cb(i,j))-cx)*m;
            if((x-ecx)^2/a^2+(y-ecy)^2/b^2)<=1
                I(i,j,:)=255;
            else I(i,j,:)=0;
            end
        elseif Y(i,j)>230
             x=(double(Cb(i,j))-cx)*n+(double(Cr(i,j))-cy)*m;
             y=(double(Cr(i,j))-cy)*n-(double(Cb(i,j))-cx)*m;
             if((x-ecx)^2/(1.1*a)^2+(y-ecy)^2/(1.1*b)^2)<=1
                 I(i,j,:)=255;
             else I(i,j,:)=0;
             end
        end
    end
end
I = im2bw(I);
%  figure,imshow(I);
                