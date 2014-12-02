function metricsKITTI=evalKITTI(infos,cls)
    % evaluate KITTI Training Set
    % requires a struct array infos 1x21
    
    metricsKITTI=zeros(1,22);
    if length(infos)~=21
        fprintf('wrong data');
        return;
    end
    
    if nargin<2, cls='car'; end
    
    cls=lower(cls);
    
    thiswd=pwd;
    
    pathToKittiDevkit='../motutils/external/KITTI/devkit_tracking/python';
    
    
    allscen=1:21;
    for scenario=allscen
        stateInfo=infos(scenario).stateInfo;
        cd(thiswd)
        tracklets=convertToKITTI(stateInfo,cls);
        cd(pathToKittiDevkit)

        writeLabels(tracklets,'results/a/data',scenario-1);
    end
    
    
    !python evaluate_tracking.py a
    metricsKITTI=dlmread(sprintf('results/a/stats_%s.txt',cls));
    
    cd(thiswd);
end