function stInfo=convertTXTToStruct(txtFile,seqFolder)
% read CSV file and convert to Anton's struct format

%  inCTS=1
%  txtFile
%  exist(txtFile,'file')
%  gtdir='../../data/ADL-Rundle-1/'
%  exist(gtdir,'dir')
%  dir(gtdir)
%  gtdir='../../data/ADL-Rundle-1/gt/'
%  exist(gtdir,'dir')
%  dir(gtdir)
%  gtdir='../../data/ADL-Rundle-1/img1/'
%  exist(gtdir,'dir')
%  dir(gtdir)
allData = dlmread(txtFile);

numLines=size(allData,1)

minHeight=0;

for l=1:numLines
    lineData=allData(l,:);
    if lineData(6)<minHeight        
        continue;
    end
    
    fr = lineData(1);
    id = lineData(2);
    stInfo.W(fr,id) = lineData(5);
    stInfo.H(fr,id) = lineData(6);
    stInfo.Xi(fr,id) = lineData(3) + stInfo.W(fr,id)/2;
    stInfo.Yi(fr,id) = lineData(4) + stInfo.H(fr,id);
    
end

% append empty frames?
if nargin>1
    imgFolders = dir(fullfile(seqFolder,filesep,'img*'));
    imgFolder = [seqFolder,imgFolders(1).name,filesep];
    imgExt=getImgExt(seqFolder);

    imgMask=[imgFolder,'*' imgExt];
    dirImages = dir(imgMask);
    Fgt=length(dirImages);
    F=size(stInfo.W,1);
    % if stateInfo shorter, pad with zeros
    if F<Fgt
        missingFrames = F+1:Fgt;
        stInfo.Xi(missingFrames,:)=0;
        stInfo.Yi(missingFrames,:)=0;
        stInfo.W(missingFrames,:)=0;
        stInfo.H(missingFrames,:)=0;        
    end
    
    
end

F=size(stInfo.W,1);
stInfo.frameNums=1:F;
% stInfo.X=stInfo.Xi;
% stInfo.Y=stInfo.Yi;


% [~, ~, stInfo]=cleanState(stInfo.Xi, stInfo.Yi,stInfo);