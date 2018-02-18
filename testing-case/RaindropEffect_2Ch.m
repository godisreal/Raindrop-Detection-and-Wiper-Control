function [Ch_A, Ch_B] = RaindropEffect_2Ch(r, x, y)

I1_A = imread('PowerImage3_A.bmp');
I2_A = rgb2hsv(I1_A);I3_A = rgb2gray(I2_A);

level_A=graythresh(I3_A); I3B_A=im2bw(I3_A,level_A+0.07); 
Mask_Area_A = im2double(I3B_A); 
I_Standard_A = im2double(im2uint8(I3_A+Mask_Area_A));

I1_B = imread('PowerImage3_B.bmp');
I2_B = rgb2hsv(I1_B);I3_B = rgb2gray(I2_B);

level_B=graythresh(I3_B); I3B_B=im2bw(I3_B,level_B+0.07); 
Mask_Area_B = im2double(I3B_B); 
I_Standard_B = im2double(im2uint8(I3_B+Mask_Area_B));

%h=figure;
scrsz = get(0,'ScreenSize');
h=figure('Position',[810 scrsz(4)/3 scrsz(3)/3 scrsz(4)/3]); %,'OutterPosition',[100, 100 100 100]));
theta=0:pi/20:2*pi;
a=x+r*cos(theta)+normrnd(0,0.05,[1,41]);
b=y+r*sin(theta)+normrnd(0,0.05,[1,41]);
fill(a,b,'k');
axis off;
xlim([-12.5,12.5]); ylim([-12.5,12.5]);
saveas (h,'figure_temp.bmp');close;

I_RaindropSingle = imread('figure_temp.bmp');
B = imresize(I_RaindropSingle,size(I3_A),'bilinear');
Mask_RaindropsSingle = im2double(B);

I_FinalSingle_A = imadd(Mask_RaindropsSingle,I3_A);
I_ResultSingle_A = im2double(im2uint8(I_FinalSingle_A+Mask_Area_A));
Ch_A=sum(sum(1-I_ResultSingle_A))/sum(sum(1-I_Standard_A));

I_FinalSingle_B = imadd(Mask_RaindropsSingle,I3_B);
I_ResultSingle_B = im2double(im2uint8(I_FinalSingle_B+Mask_Area_B));
Ch_B=sum(sum(1-I_ResultSingle_B))/sum(sum(1-I_Standard_B));


