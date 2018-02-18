
clear all; clc; close all;
Vcc=5;

WindShieldOn = 0; % Simulation includes the windshield
if WindShieldOn==1
    N = 30000; % Number of Raindrops to be Simulated
    lamda = 1; % Interval Time
else
    N = 17;
    lamda = 100; % Interval Time
end
tPoint=zeros(1,N); x=zeros(1,N); y=zeros(1,N); r=zeros(1,N); % Raindrops in the core area

if WindShieldOn==1
    t_WS=zeros(1,N); x_WS=zeros(1,N); y_WS=zeros(1,N); r_WS=zeros(1,N); % Raindrops in the windshield area
    for n=1:N;
        t_WS(n)= exprnd(lamda); 	
        x_WS(n)= unifrnd(-750,750);  
        y_WS(n)= unifrnd(-900,100);  
        r_WS(n)=abs(normrnd(1,0.3));
    end
    
    % Calculate the time of arrival
    tPoint_WS=zeros(1,N);
    for n=1:N
        if n==1
            tPoint_WS(n)=t_WS(n);
        else
            tPoint_WS(n)=tPoint_WS(n-1)+t_WS(n);
        end
    end
    
    i=0; % Calculate the number of raindrops fallen in the core area 
    for n=1:N
        if x_WS(n)>=-10 & x_WS(n)<=10 & y_WS(n)>=-10 & y_WS(n)<=10
            i=i+1;
            x(i)=x_WS(n); y(i)=y_WS(n); tpoint(i)=tPoint_WS(n); r(i)=r_WS(n);
        end
    end
    i % Show the number of raindrops fallen in the core area
else
    for n=1:N;
        t(n)= exprnd(lamda); 	x(n)= unifrnd(-10,10);  y(n)= unifrnd(-10,10);  r(n)=abs(normrnd(1,0.3));
    end
    
    for n=1:N
        if n==1	
            tPoint(n)=t(n);
        else		
            tPoint(n)=tPoint(n-1)+t(n);
        end
    end
end

% Process the power map of the rainsensor
I1 = imread('PowerImage3.bmp');
I2 = rgb2hsv(I1); I3 = rgb2gray(I2); 
figure, subplot(2,2,1), imshow(I1), subplot(2,2,2), imshow(I2); subplot(2,2,3), imshow(I3);
%figure; imshow(I1); figure; imshow(I3); 

level=graythresh(I3); I3_B=im2bw(I3,level+0.07); level, figure; subplot(2,2,1); imshow(I3_B);
I3_BW1 = edge(I3,'sobel'); subplot(2,2,2); imshow(I3_BW1); 
I3_BW2 = edge(I3,'canny'); subplot(2,2,3); imshow(I3_BW2); 
Mask_Area = im2double(I3_B); I_Standard = im2double(im2uint8(I3+Mask_Area)); subplot(2,2,4), imshow(I_Standard); 

h=figure;
for n=1:N;
    theta=0:pi/20:2*pi;%실똑[0,2*pi]
    for k=1:length(theta)
        a=x(n)+r(n)*cos(theta);
        b=y(n)+r(n)*sin(theta);
        fill(a,b,'k');hold on;
        axis off;
    end
end
xlim([-10,10]); ylim([-10,10]);

saveas (h,'figure.bmp');close;

I_RaindropsTotal = imread('figure.bmp');
B = imresize(I_RaindropsTotal,size(I3),'bilinear'); figure; imshow(B); Mask_RaindropsTotal = im2double(B); 
I_FinalTotal = Mask_RaindropsTotal + I3; figure, imshow(I_FinalTotal);
I_ResultTotal = I_FinalTotal + Mask_Area; figure, imshow(I_ResultTotal);

% sum(sum(I_Standard)), sum(sum(II))

percentageVDown=zeros(1,N);
for n=1:N;
    h=figure;
    theta=0:pi/20:2*pi;%실똑[0,2*pi]
    for k=1:length(theta)
        a=x(n)+r(n)*cos(theta);
        b=y(n)+r(n)*sin(theta);
        fill(a,b,'k');hold on;
        axis off;
    end
    xlim([-10,10]); ylim([-10,10]);
    
    saveas (h,'figure.bmp');close;
    
    I_RaindropSingle = imread('figure.bmp');
    B = imresize(I_RaindropSingle,size(I3),'bilinear'); %figure; imshow(B); 
    Mask_RaindropsSingle = im2double(B);
    I_FinalSingle = Mask_RaindropsSingle + I3; %figure, imshow(I_Final);
    I_ResultSingle = im2double(im2uint8(I_FinalSingle + Mask_Area)); %figure, imshow(II);
    
    %sum(sum(I_Standard));sum(sum(II));
    percentageVDown(n)=sum(sum(1-I_ResultSingle))/sum(sum(1-I_Standard));
end
