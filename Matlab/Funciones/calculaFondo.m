function [ifondo] = calculaFondo(imagenStruct, numImagenes)
% Dada un struct de imagenes devuelve el fondo calculado con la mediana.
    
    r = [];
    
    for i = 1:numImagenes 
        r = [ r , imagenStruct(i)];
    end
    
    C = fieldnames(r);
    SZ = struct(); % scalar structure
    for k = 1:numel(C)
        F = C{k};
        SZ.(F) = median(cat(4,r.(F)),4);
    end

    ifondo = SZ.image;
    % imshow(ifondo)
end

