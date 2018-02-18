function result = RaindropEffect(r, x, y)

I1 = imread('PowerImage3.bmp');
I2 = rgb2hsv(I1);I3 = rgb2gray(I2);

level=graythresh(I3); I3_B=im2bw(I3,level+0.07); 
Mask_Area = im2double(I3_B); 
I_Standard = im2double(im2uint8(I3+Mask_Area)); 

%h=figure;
scrsz = get(0,'ScreenSize');
h=figure('Position',[650 scrsz(4)/3 scrsz(3)/3 scrsz(4)/3]); %,'OutterPosition',[100, 100 100 100]));
theta=0:pi/20:2*pi;
a=x+r*cos(theta)+normrnd(0,0.05,[1,41]);
b=y+r*sin(theta)+normrnd(0,0.05,[1,41]);
fill(a,b,'k');
axis off;
xlim([-12.5,12.5]); ylim([-12.5,12.5]);
saveas (h,'figure_temp.bmp');close;

I_RaindropSingle = imread('figure_temp.bmp');
B = imresize(I_RaindropSingle,size(I3),'bilinear');
Mask_RaindropsSingle = im2double(B);
I_FinalSingle = imadd(Mask_RaindropsSingle,I3);
I_ResultSingle = im2double(im2uint8(I_FinalSingle+Mask_Area));

result=sum(sum(1-I_ResultSingle))/sum(sum(1-I_Standard));
