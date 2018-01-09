% % % %  Module : Advanced Image Analysis % % % % 
%% Author: Dousai Nayee Muddin Khan
%% Date: January 7th 2018

function final_img=multiwaveletreconstruction(coeff, h, levels)
    g = h.*power(-1*ones(1,length(h)),(0:length(h)-1)); % Highpass filter
    g = fliplr(g); %flip function
    Appr = coeff(1:size(coeff,1)/(2^levels),1:size(coeff,2)/(2^levels));
    Hori = coeff(1:size(coeff,1)/(2^levels),(size(coeff,2)/(2^levels))+1:(size(coeff,1)/(2^levels))*2);
    Ver = coeff((size(coeff,1)/(2^levels))+1:(size(coeff,1)/(2^levels))*2,1:size(coeff,2)/(2^levels));
    Diag = coeff((size(coeff,1)/(2^levels))+1:(size(coeff,1)/(2^levels))*2,(size(coeff,2)/(2^levels))+1:(size(coeff,1)/(2^levels))*2);
    
    while(levels ~= 0) % While count not equal to 0
        
        %Concatenate approximation and horizontal details into single matrix:
        AH = [Appr Hori];
        
        %Upsampling approximation and horizontal details by rows:
        AHup = zeros(2*size(AH,1),size(AH,2));
        AHup(1:2:length(AHup),:)=AH;
        
        %Flip ADhup
        AHup = flipud(AHup);
        
        %Lowpass filtering on columns:
        for i=1:size(AHup,2)
            AHup(:,i)=pconv(h,AHup(:,i)')';
        end
        
        %Concatenate Vertical and diagonal detilas into single matix:
        VD = [Ver Diag];
        
        %Upsampling Vertical and diagonal details on rows:
        VDup = zeros(2*size(VD,1),size(VD,2));
        VDup(1:2:length(VDup),:)=VD;
        
        %Flip VDup:
        VDup = flipud(VDup);
        
        %Highpass filtering on columns:
        for i=1:size(VDup,2)
            VDup(:,i)=pconv(g,VDup(:,i)')';
        end
        
                
        %Sum both lowpass and highpass results into another new matrix
        LH = AHup + VDup;
        
        %Flip LH:
        LH = flipud(LH);
        
        %Upsample cH on columns:
        cH = LH(:,size(LH,2)/2+1:end);
        cHup = zeros(size(cH,1),2*size(cH,2));
        cHup(:,1:2:length(cH))=cH;
        
        %Flip cHup:
        cHup = fliplr(cHup);
        
        %Highpass filtering on rows:
        for i=1:size(cHup,1)
            cHup(i,:)=pconv(g,cHup(i,:));
        end
        
        %Upsample cL on columns:
        cL = LH(:,1:size(LH,2)/2);
        cLup = zeros(size(cH,1),2*size(cH,2));
        cLup(:,1:2:length(cH))=cL;
        
        %Flip CLup:
        cLup = fliplr(cLup);
        
        %Lowpass filtering on rows:
        for i=1:size(cLup,1)
            cLup(i,:)=pconv(h,cLup(i,:));
        end
        
        
        %Sum up both lowpass and highpass results:
        
        final_img = cHup + cLup;
        
        %flip again
        final_img = fliplr(final_img);
        
        levels = levels - 1;
        
        %check the level should be greater than zero
        if levels>0
            %Extract next coefficients:
            Appr = final_img;
            Hori = coeff(1:size(coeff,1)/(2^levels),(size(coeff,2)/(2^levels))+1:(size(coeff,1)/(2^levels))*2);
            Ver = coeff((size(coeff,2)/(2^levels))+1:(size(coeff,1)/(2^levels))*2,1:size(coeff,1)/(2^levels));
            Diag = coeff((size(coeff,2)/(2^levels))+1:(size(coeff,1)/(2^levels))*2,(size(coeff,2)/(2^levels))+1:(size(coeff,1)/(2^levels))*2);
        end
        
    end

end