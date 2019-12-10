close all;clear all
path = 'Z:\m_trunk\test images\';

multipleRecord = {};
record_index = 1;

% D = dir;
% dFlags = [D.isdir] & ~strcmp({D.name},'.') & ~strcmp({DS.name},'..');
% now = D(dirFlags);

% search through all folders
files = dir('Z:\m_trunk\test images\c14');
dirFlags = [files.isdir] & ~strcmp({files.name},'.') & ~strcmp({files.name},'..');
subFolders = files(dirFlags);

for k = 1 : length(subFolders)
  fprintf('Sub folder #%d = %s\n', k, subFolders(k).name);
  folderName = subFolders(k).name;
  secondPath = strcat('Z:\m_trunk\test images\c14\', folderName);
  secondPath = strcat(secondPath, '\');
  cd(secondPath);
  
    % inside each subfolder...
    imgNames = dir([secondPath,'*.JPG']);  
%     multipleRecord = {};

    for i=1:length(imgNames)
        name = imgNames(i).name;
        I=imread([secondPath,name]);
        im=I(:,:,1);
        im=im(25:end,25:end);
        Dot_valid = dots_process(im,1);
        pause(1);

        % Ark
        % write output to result file
        Dot_size=[];
        Dot_intensity=[];
        for j=1:length(Dot_valid)
            Dot_size = [Dot_size,Dot_valid(j).size];
            Dot_intensity=[Dot_intensity,Dot_valid(j).intensity];
        end

        % write each record to file
        entry = int2str(record_index);
        imgName = name;

        imgID = 'imgID';
        imgNumber = int2str(length(Dot_valid));
        imgIntensity = int2str(median(Dot_intensity));
        imgAboveThres = int2str(10);
        imgSize = int2str(median(Dot_size));

        singleRecordStr = [entry ',' folderName ',' imgName ',' imgNumber ',' imgIntensity ',' imgSize];
        multipleRecord = [multipleRecord, singleRecordStr];
        record_index = record_index+1;
    end 
    
    cd ..
  
end


% imgNames = dir([path,'*.JPG']);

% multipleRecord = {};
% 
% for i=1:length(imgNames)
%     name = imgNames(i).name;
%     I=imread([path,name]);
%     im=I(:,:,1);
%     im=im(25:end,25:end);
%     Dot_valid = dots_process(im,1);
%     pause(1);
%     
%     % Ark
%     % write output to result file
%     Dot_size=[];
%     Dot_intensity=[];
%     for j=1:length(Dot_valid)
%         Dot_size = [Dot_size,Dot_valid(j).size];
%         Dot_intensity=[Dot_intensity,Dot_valid(j).intensity];
%     end
%     
%     % write each record to file
%     entry = int2str(i);
%     imgName = name;
%     
%     imgID = 'imgID';
%     imgNumber = int2str(length(Dot_valid));
%     imgIntensity = int2str(median(Dot_intensity));
%     imgAboveThres = int2str(10);
%     imgSize = int2str(median(Dot_size));
%     
%     singleRecordStr = [entry ',' imgName ',' imgNumber ',' imgIntensity ',' imgSize];
%     multipleRecord = [multipleRecord, singleRecordStr];
% end

fileID = fopen('data.csv', 'a');
fprintf(fileID, 'Entry,Folder,Name,Number,Intensity,Size\n');
for i=1:length(multipleRecord)
    fprintf(fileID,'%s\n',multipleRecord{i});
end

fclose(fileID);
disp('Finished writing.');



% Dot_size=[];
% Dot_intensity=[];
% for i=1:length(Dot_valid)
%     Dot_size = [Dot_size,Dot_valid(i).size];
%     Dot_intensity=[Dot_intensity,Dot_valid(i).intensity];
% end
    
% figure,subplot(1,2,1);hist(Dot_size,10);title('dots size histogram');xlabel('size pixels');ylabel('dot numbers')
% subplot(1,2,2);hist(Dot_intensity,10);title('dots intensity histogram');xlabel('intensity');ylabel('dot numbers');



        



