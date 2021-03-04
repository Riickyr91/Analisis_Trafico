function [disponible] = camDisponible(I)
% Devuelve true si la imagen pasada es NoDisponible
    %Leo la imagen plantilla de no disponible
    IPredefinida = gpuArray(imread('D:\Imagenes_TFG\NO_DISPONIBLE\NO_DISPONIBLE.jpg'));
    
    [f c m] = size(IPredefinida);
    
    %La reescalo para poder realizar la resta entre ellas
    Im = imresize(I,[f c]);
    IGpu = gpuArray(Im);
    
    %Realizo la diferencia
    Idef = IPredefinida - IGpu;
    
    %Si la diferencia entre ambas es mucho esta disponible la camara.
    if(sum(Idef(:)) < 10)
        disponible = false;
    else
        disponible = true;
    end        

end

