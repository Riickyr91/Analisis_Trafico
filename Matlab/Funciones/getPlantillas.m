function [output] = getPlantillas(cam)
%% Obtiene las plantillas calculadas manualmente dada una camara
    myPath = strcat('D:\Imagenes_TFG\PLANTILLAS\',cam);
    allPlantillas = dir(fullfile(myPath,'*.mat'));
    fileNames={allPlantillas.name};
    [fm cm] = size(fileNames);
    
    r = string(strcat(myPath,'\',fileNames(1,1)));   
    load(r);
    
    [f c] = size(I_Plantilla);
    output = logical(zeros(f,c,cm));
    
    output(:,:,1) = I_Plantilla;
    
    for i = 2:cm
        r = string(strcat(myPath,'\',fileNames(1,i)));   
        load(r);
        output(:,:,i) = I_Plantilla;
        imshow(I_Plantilla);
        pause
    end

end

