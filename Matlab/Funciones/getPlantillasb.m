function [output] = getPlantillasb(cam)
%% Obtiene las plantillas calculadas automaticamente dada una camara
    myPath = strcat('D:\Imagenes_TFG\PLANTILLASB\',cam);
    allPlantillas = dir(fullfile(myPath,'*.mat'));
    fileNames={allPlantillas.name};
    [fm cm] = size(fileNames);
    
    r = string(strcat(myPath,'\',fileNames(1,1)));   
    load(r);
    
    output = I_Plantilla;

end

