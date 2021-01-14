function [output] = getPlantillasb(cam)

    myPath = strcat('D:\Imagenes_TFG\PLANTILLASB\',cam);
    allPlantillas = dir(fullfile(myPath,'*.mat'));
    fileNames={allPlantillas.name};
    [fm cm] = size(fileNames);
    
    r = string(strcat(myPath,'\',fileNames(1,1)));   
    load(r);
    
    output = I_Plantilla;

end

