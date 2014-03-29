function homedir=getHomeFolder()
% home directory

    homedir='/home/aanton';
    if ispc
        homedir='D:';
    end
    if exist('/gris/gris-f/home/aandriye','dir')
        homedir='/gris/gris-f/home/aandriye';
    end
end