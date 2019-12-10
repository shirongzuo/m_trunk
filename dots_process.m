function Dot_valid = dots_process(im,showImg)
h=fspecial('gaussian',5,1);
%im = imfilter(im,h,'same');

dot.x=0; dot.y=0;dot.size=0;dot.intensity=0;
Dots=[];
angle_range=-50:50;
% for i=1:length(angle_range)
%     angle_i = angle_range(i);
%     im1 = imrotate(im,angle_i,'bicubic');
%     project_i = double(sum(im1));
%     P=findpeaks9(project_i,20,4,0);
% end
R = radon(im, angle_range);
R_project = max(R);
[mx_value,mx_index] = max(R_project);
% rot_angle=max index + start angle - 1 (minus 1 is for counting 0 degree)
rot_angle = mx_index+angle_range(1)-1;
im_rot = imrotate(im,-rot_angle,'bicubic','crop');

%correct background
im_tophat = imtophat(im_rot,strel('disk',7));

im_project = double(sum(im_tophat));
main_project_peaks =findpeaks9(im_project,500,6,0);
if isempty(main_project_peaks)~=0
    Dot_valid=[];
    return;
end
N=size(main_project_peaks,1);
if showImg==1
    figure(1);imshow(im_rot,[])
%     figure(2);
end
Z=zeros(size(im_rot));
Gap=[];
for i=1:N
    col_i_index = round(main_project_peaks(i,2));
    col_i_line = double(im_rot(:,col_i_index));
    col_i_peaks = findpeaks9(col_i_line,8,6,0); 
    gaps = diff(col_i_peaks(:,2));
    Gap=[Gap;gaps];
    if isempty(col_i_peaks)==1
        continue;
    end
    bdx_width_radius = ceil(main_project_peaks(i,4)/2)+2;
    ctp_x = round(col_i_index);    
%     figure(2);plot(col_i_line);
    for j=1:size(col_i_peaks,1)   
        dot_i_profile = zeros(size(col_i_line));
        bdx_height_radius = ceil(col_i_peaks(j,4)/2)+3;
        ctp_y = round(col_i_peaks(j,2));
        dot.x=ctp_x; dot.y=ctp_y; 
        box_i_x = ctp_x-bdx_width_radius;
        box_i_y = ctp_y-bdx_height_radius;
        box_i_width = bdx_width_radius*2;
        box_i_height = bdx_height_radius*2;
        if showImg==1
            figure(1);hold on;rectangle('Position',[ctp_x-bdx_width_radius,ctp_y-bdx_height_radius,bdx_width_radius*2,bdx_height_radius*2],'EdgeColor','r');                
        end
        dot_i_box = im_rot(ctp_y-bdx_height_radius-2:ctp_y+bdx_height_radius+2,ctp_x-bdx_width_radius-2:ctp_x+bdx_width_radius+2);
        th_i = graythresh(dot_i_box(:))*255;
        
        % Ark
        % in every rectangle, get the median of all pixels above treshold
        % level_comparison = graythresh(dot_i_box);
        [cont,center]=hist(double(dot_i_box(:)),10);
        level = center(2);

        % display sub-image before and after applying treshold
%         BW = imbinarize(dot_i_box,level/255);
%         imshowpair(dot_i_box,BW,'montage')
        
        % mask = dot_i_box > th_i;
        mask = dot_i_box > level;
        theMedian = median(dot_i_box(mask));
        % disp(theMedian);

        theSize= 0;
        for m = 1 : size(mask,1)
            for n = 1 : size(mask,2) 
                if mask(m,n) == 1
                    theSize = theSize + 1;
                end 
            end
        end 
        % disp(theSize);   
        
        
        [cont,center]=hist(double(dot_i_box(:)),10);
        th_i_new = center(2);
        dot_i_bw = dot_i_box>th_i;   
        dot_i_profile(box_i_y:box_i_y+box_i_height) = col_i_line(box_i_y:box_i_y+box_i_height);
        effective_peak_index = find(dot_i_profile>=th_i_new);
%         dot.intensity = median(dot_i_profile(effective_peak_index));        
%         dot.size = length(effective_peak_index);

        % refined dot intensity and dot size
        dot.intensity = theMedian;
        dot.size = theSize;
        
        Dots = [Dots,dot];
%         figure(2);hold on;plot(effective_peak_index, dot_i_profile(effective_peak_index),'r');hold off;

        % what it's for?
        for m=1:size(dot_i_bw,1)
            for n=1:size(dot_i_bw,2)
                if dot_i_bw(m,n)>0
                    Z(ctp_y-bdx_height_radius+m,ctp_x-bdx_width_radius+n)=255;
                end
            end
        end

    end    
end

% remove unwanted dots
% make sure each dot is close enough to ndcode center
dot_num = size(Dots,2);
X = zeros(1,dot_num);
Y=zeros(1,dot_num);
for i=1:dot_num
    X(i) = Dots(i).x;
    Y(i) = Dots(i).y;
end
center_xy = [mean(X),mean(Y)];
valid_distance_threshold = 6*median(Gap);
Dot_valid = [];
for i=1:dot_num
    dot_xy = [Dots(i).x,Dots(i).y];
    dist2center = norm(center_xy-dot_xy);
    if dist2center<valid_distance_threshold
        Dot_valid = [Dot_valid,Dots(i)];
        hold on;plot(dot_xy(1),dot_xy(2),'g.');  
    end
end
tmp=0;

        





