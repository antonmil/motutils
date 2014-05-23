function metricsKITTI=evalKITTI(resfile)
    % evaluate KITTI Training Set
    % requires a file with a allInfo 520x1 struct
    
    
    thiswd=pwd;
    load(resfile);
    
    pathToKittiDevkit='/home/amilan/storage/databases/KITTI/tracking/devkit_tracking/python';
    
    
    allscen=500:520;
    for scenario=allscen
        stateInfo=allInfo(scenario).stateInfo;
        cd(thiswd)
        tracklets=convertToKITTI(stateInfo);
        cd(pathToKittiDevkit)

        writeLabels(tracklets,'results/a/data',scenario-500);
    end
    
    
    !python evaluate_tracking.py a
    metricsKITTI=dlmread('results/a/stats_car.txt');
    
    cd(thiswd);
end