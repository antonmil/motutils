function detectPeople(sceneInfo)
% run P. Dollar's pedestrian detector.
% sequence can either be a string (for one sequence only)
% or a cell array, for multiple sequences.
% If sequence is empty, run on all available data
%
% thr is the cutoff threshold (unused)
%
% @author: Anton Milan

% addpath(genpath('..')); % dollar toolbox
% addpath(genpath('../../../../scripts')) % tools

% datadir=getDataDir();



load('models/AcfInriaDetector.mat')

detScale=1;
% detScale=0.6;

blowUp=1;
fprintf('RESCALING DETECTOR: %f\n',detScale);
detector = acfModify(detector,'rescale',detScale);

imgFolder = sceneInfo.imgFolder;
imgExt = sceneInfo.imgExt;

imgMask=[imgFolder,'*',imgExt];
dirImages = dir(imgMask);


F=length(dirImages);
%         F=10;
filecells=cell(1,F);
for t=1:F
    filecells{t} = [imgFolder,dirImages(t).name];
end

fprintf('Detecting %s (%d frames)\n',sceneInfo.sequence,F);

% detection's folder and file
detFile = fullfile(sceneInfo.imgFolder,'det.txt');

delete(detFile);

% detect all images
%         detector.opts.pNms.type='none';
bbx = acfDetect(filecells,detector);

% write out
writeDets(bbx,detFile);

end
