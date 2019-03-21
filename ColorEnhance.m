function IHSV = ColorEnhance(RGB)
%%input:  original RGB image
%%output: uint8 RGB image
%RGB = imread('yy2\im_388.jpg');

HSV = rgb2hsv(RGB);
HSV1 = HSV;
HSV1(:,:,3)=imadjust(HSV(:,:,3) ,[0.2,0.8],[],0.6);
HSVrgb = hsv2rgb(HSV1);
%subplot(3,2,5);imshow(HSVrgb,[]);title('imadjust');
IHSV = uint8(HSVrgb*255);
end

%skin_HSV = skindetect2(IHSV);
%subplot(3,2,6);imshow(skin_HSV,[]);title('detect--imadjust');% HSV = rgb2hsv(RGB);

% figure;
% subplot(221);imshow(RGB,[]); title('RGB');
% HSV1=HSV;
% HSV1(:,:,3)=adapthisteq(HSV(:,:,3));
% subplot(222);imshow(hsv2rgb(HSV1),[]); title('adapthisteq');
% HSV1(:,:,3)=histeq(HSV(:,:,3));
% subplot(223);imshow(hsv2rgb(HSV1),[]);title('histeq');
% HSV1(:,:,3)=imadjust(HSV(:,:,3) ,[0.2,0.8],[],0.6);
% subplot(224);imshow(hsv2rgb(HSV1),[]);title('imadjust');

% LAB = applycform(RGB,makecform('srgb2lab'));
% figure;
% subplot(221);imshow(RGB,[]); title('RGB');
% LAB1=LAB;
% LAB1(:,:,1)=adapthisteq(LAB(:,:,1));
% subplot(222);imshow(applycform(LAB1,makecform('lab2srgb')),[]); title('adapthisteq');
% LAB1(:,:,1)=histeq(LAB(:,:,1));
% subplot(223);imshow(applycform(LAB1,makecform('lab2srgb')),[]); title('histeq');
% LAB1(:,:,1)=imadjust(LAB(:,:,1) ,[0.2,0.8],[],0.6);
% subplot(224);imshow(applycform(LAB1,makecform('lab2srgb')),[]); title('imadjust');
