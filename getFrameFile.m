function filename=getFrameFile(sceneInfo,t)
% get the file name for one specific frame

filename=fullfile(sceneInfo.imgFolder,sprintf(sceneInfo.imgFileFormat,sceneInfo.frameNums(t)));

end