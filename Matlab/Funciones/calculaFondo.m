function [ifondo] = calculaFondo(imagenStruct, numImagenes)
% Dada un struct de imagenes devuelve el fondo calculado con la mediana.
    %% Calculo la mediana de todas las imagenes
    [f, c, m] = size(imagenStruct(1).image);

    r = uint8(zeros(1,numImagenes));
    g = uint8(zeros(1,numImagenes));
    b = uint8(zeros(1,numImagenes));
            
    ifr = uint8(zeros(f,c));
    ifg = uint8(zeros(f,c));
    ifb = uint8(zeros(f,c));

    for fila = 1:f
            for columna = 1:c
                for k = 1:numImagenes        
                    r(1,k) = imagenStruct(k).red(fila,columna);
                    g(1,k) = imagenStruct(k).green(fila,columna);
                    b(1,k) = imagenStruct(k).blue(fila,columna);        
                end      
                ifr(fila,columna) = median(r);
                ifg(fila,columna) = median(g);
                ifb(fila,columna) = median(b);   
            end
    end

    %% Creo la imagen de fondo
    ifondo = cat(3,ifr,ifg,ifb);
    % imshow(ifondo)
end

