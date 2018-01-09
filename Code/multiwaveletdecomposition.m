% % % %  Module : Advanced Image Analysis % % % % 
%% Author: Dousai Nayee Muddin Khan
%% Date: January 7th 2018

function coeff=multiwaveletdecomposition(img, h, levels)
g=h.*power(-1*ones(1,length(h)),(0:length(h)-1)); % Highpass filter
g = fliplr(g); %flip function
theimg = img;
sp = zeros(size(theimg));
 while(levels ~= 0) % While count not equal to 0
    
    %ROW-WISE FILTERING:
    rowsMatrix=zeros(size(theimg));
    m1=zeros(size(theimg));
    m2=zeros(size(theimg));
    %lowpass filtering:
    for i=1:size(theimg,1)
        m1(i,:)=pconv(h,theimg(i,:));
    end
    
    %highpass filtering
    for i=1:size(theimg,1)
        m2(i,:)=pconv(g,theimg(i,:));
    end
    
    %Downsampling of lowpass filter on columns:
    rowsMatrix(:,1:size(m1,2)/2)=m1(:,1:2:size(m1,2));
    
    %Downsampling of highpass filter on columns:
    rowsMatrix(:,(size(m2,2)/2)+1:end)=m2(:,1:2:size(m2,2));
    
    %COLUMN-WISE FILTERING:
    %lowpass filtering:
    for i=1:size(rowsMatrix,2)
        m1(:,i)=pconv(h,rowsMatrix(:,i)')';
    end
    
    % high pass filtering:
    for i=1:size(rowsMatrix,2)
        m2(:,i)=pconv(g,rowsMatrix(:,i)')';
    end
    
    %Downsampling of lowpass filter:
    sp(1:size(m1,2)/2,1:size(m1,2))=m1(1:2:size(m1,2),:);
    
    %Downsampling of highpass filter:
    sp((size(m2,2)/2)+1:size(m2,2),1:size(m2,2))=m2(1:2:size(m2,2),:);
    
     % Extract approximation image:
     theimg = sp(1:size(theimg,1)/2,1:size(theimg,2)/2);
     
     %Decrease level
     levels = levels - 1;
 end
 coeff = sp;
end