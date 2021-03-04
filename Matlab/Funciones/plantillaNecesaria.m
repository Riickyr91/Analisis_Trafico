function [minimo] = plantillaNecesaria(P, pAnterior, cam)

    plantillas = getPlantillas(cam);
    
    rd = 0.4;
    
    [f c p] = size(plantillas);
    
    ocp = zeros(1,p);
    
    P = imresize(P,rd);
    pAnterior = imresize(pAnterior,rd);
    
    difAbsoluta = P - pAnterior;
    difG = rgb2gray(difAbsoluta);
    difBool = difG > 70;
    diffFiltrado = bwareaopen(difBool,5);
    
    [numF, numC] = size(diffFiltrado);
    
    for i=1:p
        dif = (diffFiltrado - imresize(plantillas(:,:,i),rd)) > 0;
        ocp(1,i) = (100 * sum(dif(:))) / (numF * numC);
    end
    minimo = min(ocp(:))
    
end

