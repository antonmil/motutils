function sceneInfo=readSceneOptions(inifile)
% parse sceneInfo

if ~exist(inifile,'file')
    fprintf('WARNING! Scene file %s does not exist! Using TUD Campus ...\n',inifile);
    inifile='scenes/scene2D.ini';
end


ini=IniConfig();
ini.ReadFile(inifile);

sceneInfo=[];

% Sequence Information
sceneInfo=fillInOpt(sceneInfo,ini,'Source');

% Additional Info
sceneInfo=fillInOpt(sceneInfo,ini,'Miscellaneous');

sceneInfo.scenario=0;

sceneInfo=checkScene(sceneInfo);

end


function sceneInfo = fillInOpt(sceneInfo, ini, sec)
% loop through all keys in section and
% append to struct

keys = ini.GetKeys(sec);
for k=1:length(keys)
    key=char(keys{k});
    val=ini.GetValues(sec,key);
    
    % parameters are numeric
    if isstr(val) && strcmpi(sec,'Parameters')
        val=str2double(val);
    end
    sceneInfo = setfield(sceneInfo,key,val);
end

end

function sceneInfo=checkScene(sceneInfo)
% check sceneInfo for correctness
%
% TODO: Insert on-the-fly detector

% mandatory fields
requiredFields={'imgFolder','frameRate','detfile'};

for f=requiredFields
    fchar=char(f);
    assert(isfield(sceneInfo,fchar), ...
        ['Field ' fchar ' is required']);
end

assert(exist(sceneInfo.imgFolder,'dir')>0, ...
    ['Image Folder ' sceneInfo.imgFolder ' does not exist.']);
assert(exist(sceneInfo.detfile,'file')>0, ...
    ['Detection ' sceneInfo.detfile ' does not exist.']);

% figure out frames, format, etc.
[sceneInfo.imgFileFormat, sceneInfo.imgExt, sceneInfo.frameNums] = ...
    getImgFormat(sceneInfo.imgFolder);

% append file extension
sceneInfo.imgFileFormat=[sceneInfo.imgFileFormat, sceneInfo.imgExt];

% image dimensions
[sceneInfo.imgHeight, sceneInfo.imgWidth, ~] = size(getFrame(sceneInfo,1));

% ground truth
sceneInfo.gtAvailable=0;
if isfield(sceneInfo,'gtFile')
    if exist(sceneInfo.gtFile,'file')
        sceneInfo.gtAvailable=1;
        
        global gtInfo
        gtInfo=convertTXTToStruct(sceneInfo.gtFile);
        gtInfo.X=gtInfo.Xi; gtInfo.Y=gtInfo.Yi;
    end
end

end