function P=findpeaks9(y,parmpeaks,kn2,debugline)
% Function to locate the positive peaks in a noisy dataset.  
% Returns list (P) containing peak number and
% position, height, and width of each peak. 
% parmpeaks has parameters as follows
ampthreshold=parmpeaks(1);   %peak amplitude threshold

%use smoothwidth as the gaussian sigma.  choose filter length to be
%  to reach roughly e^-3.
d_amp_factor=5;             %scale from peak amplitude to obs height in d
dampthreshold=d_amp_factor*ampthreshold;      %empirical observation
         
% kn2=4;                    %truncate the filter

nn=length(y);
% create internal array to hold results--temp--guess at size
rn=round(nn/kn2);
pin=zeros(rn,4);  peak=0;

s=zeros(nn,1);         %smoothed output
for i=nn-kn2+2:nn,s(i)=y(i);end         %copy these
for i=1:nn-kn2+1
    for j=1:kn2,s(i)=s(i)+y(i+j-1);end       %not centered
end

d=zeros(nn,1);             %differential               
i1=kn2+1; i2=nn-kn2;
for i=i1:i2,d(i)=s(i-4)-s(i+1);end    %think carefully about offsets here
if debugline==1
    plot (1:nn,y,1:nn,s);
    figure;
    plot (d);
end
%look for negatives followed by positive
for i=i1:i2-1
    if d(i)<0 && d(i+1)>=0
        %this might be a peak
        xp=d(i)/(d(i)-d(i+1));
        
        %analyze the structure in d further--find extrema
        seen=0; t=d(i); extrem=zeros(1,4);
        for j=i:-1:i1
            if d(j)<=t
                t=d(j);
                continue;
            else
                seen=1;          %the number has stopped decreasing
                extrem(1)=j+1;
                extrem(2)=d(j+1);
                break;
            end
        end
        t=d(i);
        for j=i:i2
            if d(j)>=t
                t=d(j);
                continue;
            else
                seen=seen+1;          %the number has stopped increasing
                extrem(3)=j-1;
                extrem(4)=d(j-1);
                break;
            end
        end
        if seen==2 && extrem(4)-extrem(2)>dampthreshold
            peak=peak+1;
            hh=(extrem(4)-extrem(2))/d_amp_factor;
            pin(peak,:)=[peak i+xp hh extrem(3)-extrem(1)];
        end
    end
end
if peak>0
    P=pin(1:peak,:);             %copy to output
else
    P=[];
end
return;

end

