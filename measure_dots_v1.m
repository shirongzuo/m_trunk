close all;clear all
% path='G:\Projects\NDCode\side_camera\dots property measurement\Reader image intensity\';
path='\\Mac\Home\Desktop\matlab code\test images\';
imgNames = dir([path,'*.JPG']);
for i=1:length(imgNames)
    name = imgNames(i).name;
    I=imread([path,name]);
    im=I(:,:,1);
    im=im(25:end,25:end);
    Dot_valid = dots_process(im,1);
    pause(1);
end

Dot_size=[];
Dot_intensity=[];
for i=1:length(Dot_valid)
    Dot_size = [Dot_size,Dot_valid(i).size];
    Dot_intensity=[Dot_intensity,Dot_valid(i).intensity];
end
    
figure,subplot(1,2,1);hist(Dot_size,10);title('dots size histogram');xlabel('size pixels');ylabel('dot numbers')
subplot(1,2,2);hist(Dot_intensity,10);title('dots intensity histogram');xlabel('intensity');ylabel('dot numbers');



        



