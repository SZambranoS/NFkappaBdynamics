function [LabelsMap] =track_just_nuclei(cellROIs, StackTrack, nFrames, TolArea)
%August 2018: does just the tracking part of  track_and_quantify_2channels_forNuctoCyto_classical

LabelsMap(1).data =labelmatrix(cellROIs(1)); %ROIs are specified as connected components

[M,N]=size(LabelsMap(1).data);

BaricenterPre = regionprops(LabelsMap(1).data,'Centroid');
Baricenter{1} = cell2mat((struct2cell(BaricenterPre))');
nCells = length(Baricenter{1}(:,1));




if nFrames==1

    BoundingBoxPre = regionprops(LabelsMap(1).data,'BoundingBox');
    BoundingBox{1}=cell2mat((struct2cell(BoundingBoxPre))'); 
    
else
    
    
    
    for j = 1:nFrames - 1;
        % Compute baricenter of cells at frame j + 1
        BaricenterPost = regionprops(cellROIs(j+1),'Centroid');
        BaricenterPost = cell2mat((struct2cell(BaricenterPost))');
        AreaPost=regionprops(cellROIs(j+1),'Area');
        AreaPost=cell2mat((struct2cell(AreaPost))');
        
        % Compute baricenter of cells at frame j
        BaricenterPre = regionprops(LabelsMap(j).data,'Centroid');
        Baricenter{j} = cell2mat((struct2cell(BaricenterPre))');
        AreaPre0=regionprops(LabelsMap(j).data,'Area');
        AreaPre0=cell2mat((struct2cell(AreaPre0))');
        
        
        %%%If in one frame, by some disaster, things are not working properly,
            %%%you copy last image's cells.
            
        
        if isempty(BaricenterPost)
            disp('WARNING, THERE WAS A WEIRD FRAME')
            LabelsMap(j+1).data = LabelsMap(j).data;
            Baricenter{j+1}=Baricenter{j};
            BoundingBox{j}=cell2mat((struct2cell(BoundingBoxPre))');
       
        elseif isempty(Baricenter{j})
            
            Baricenter{j}=NaN*ones(nCells,2); 
        
            for k=j:nFrames-1
                
                Baricenter{k+1}=NaN*ones(nCells,2);
                LabelsMap(k+1).data=zeros(M,N);
                
                
                
            end;
        
            
            break; 
            
        else
            
            
      
            if length(Baricenter{j}(:,1)) < nCells
                Baricenter{j}(end+1:nCells,:) =NaN;
            end
            BaricenterPre0=Baricenter{j};
            
            
            
            
            %Vector with areas of the previous frame.
            AreaPre=zeros(nCells,1);
            AreaPre(find(~isnan(Baricenter{j}(:,1))))=AreaPre0(find(AreaPre0));
            
            
            
            
            
            
            % Compute Bounding box of cells at frame j
            BoundingBoxPre = regionprops(LabelsMap(j).data,'BoundingBox');
            BoundingBox{j} = cell2mat((struct2cell(BoundingBoxPre))');
            
            
            
            % Nearest Neighbour search
            [indexPre,Distance] = knnsearch(Baricenter{j},BaricenterPost);
            
            % Initiate labels map
            LabelsMapTemp = zeros(size(LabelsMap(j).data));
            
            % Link cells from frame j to frame j + 1;
            
            
            for i = 1:max(indexPre);
                
                multInd = find(indexPre ==i);
                
                if length(multInd)> 1       % if the cell i at frame j is linked
                    indexPre(multInd) = 0;  % to more than one cell at frame j + 1
                    [~,idMin] = min(Distance(multInd)); % only keep the link
                    indexPre(multInd(idMin)) = i;           % that minimize the
                    % the distance
                end
                
                
                cellpre=i;
                cellpost=find(indexPre==i);
                
                %We check if the area changed a lot.
                if ~isempty(cellpost)
                    areapre=AreaPre(i);
                    areapost=AreaPost(cellpost);
                    
                    areamean=mean([areapre,areapost]);
                    
                    if (abs(areapre-areapost)/areamean)>TolArea
                        indexPre(cellpost)=0;
                       disp('Change area!!!!')%!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
                       % cellpre
                    end;
                    
                end;
                
                %We also check if the baricentres are too far appart
                
                if ~isempty(cellpost)
                    BariPre=BaricenterPre0(i,:);
                    BariPost=BaricenterPost(cellpost,:);
                    
                    if (norm(BariPre-BariPost))>50
                        indexPre(cellpost)=0;
                       disp('Change position!!!!')
                    end;
                    
                end;
                
                
                
            end
            
            % Generate Label map for frame j + 1.
            for i = 1:cellROIs(j+1).NumObjects
                LabelsMapTemp(cellROIs(j+1).PixelIdxList{i}) = indexPre(i);
            end
            LabelsMap(j+1).data = LabelsMapTemp;
            
        end;
        
        
        
        
    end
    
    % Calculate Baricenter and Bounding Box for last Frame
    
    BaricenterPre = regionprops(LabelsMap(j+1).data,'Centroid');
   
    
    
    
    if isempty(BaricenterPre)
       
    
        Baricenter{j+1}=NaN*ones(size(Baricenter{j}));
        
    else
 
    Baricenter{j+1} = cell2mat((struct2cell(BaricenterPre))');
    
    if length(Baricenter{j+1}(:,1)) < nCells
                Baricenter{j+1}(end+1:nCells,:) =NaN;
    end
    
    
    BoundingBoxPre = regionprops(LabelsMap(j+1).data,'BoundingBox');
    BoundingBox{j+1} = cell2mat((struct2cell(BoundingBoxPre))');
    
    end;
    
    
    % Rearrange Data cell-wise

    
   
 
end;


























