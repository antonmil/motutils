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