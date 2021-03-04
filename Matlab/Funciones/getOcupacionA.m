function [M] = getOcupacionA(plantilla, ifondo, I);
% Dada una serie de plantillas, un fondo y la imagen, obtiene la plantilla
% que mas se adapta a la imagen actual y calcula la ocupación.
    [f c p] = size(plantilla);
    
    ocupacion = zeros(1,p);
    
    diff = encuadrarImagen(I, ifondo, 5);
    diffFiltrado = bwareaopen(diff,5);
    
    plantilla_Min = plantilla(5:f-5, 5:c-5, :);
   
    for i = 1 : p
        % Selecciono la plantilla
        I_Plantilla = plantilla_Min(:,:,i);
        
        % Recorto la imagen resultante de la resta
        I_Recortada = double(I_Plantilla & diffFiltrado);
        
        [fila, columnas] = size(I_Recortada);
        
        intervalo = round(fila/10);             
        
        I_Recortada(1:intervalo,:) = I_Recortada(1:intervalo,:) * 50;
        I_Recortada(intervalo + 1:2 * intervalo,:) = I_Recortada(intervalo + 1:2 * intervalo,:) * 40;
        I_Recortada(2 * intervalo + 1:3 * intervalo,:) = I_Recortada(2 * intervalo + 1:3 * intervalo,:) * 30;
        I_Recortada(3 * intervalo + 1:4 * intervalo,:) = I_Recortada(3 * intervalo + 1:4 * intervalo,:) * 25;
        I_Recortada(4 * intervalo + 1:5 * intervalo,:) = I_Recortada(4 * intervalo + 1:5 * intervalo,:) * 20;
        I_Recortada(5 * intervalo + 1:6 * intervalo,:) = I_Recortada(5 * intervalo + 1:6 * intervalo,:) * 15;
        I_Recortada(6 * intervalo + 1:7 * intervalo,:) = I_Recortada(6 * intervalo + 1:7 * intervalo,:) * 12;
        I_Recortada(7 * intervalo + 1:8 * intervalo,:) = I_Recortada(7 * intervalo + 1:8 * intervalo,:) * 9;
        I_Recortada(8 * intervalo + 1:9 * intervalo,:) = I_Recortada(8 * intervalo + 1:9 * intervalo,:) * 7;
        I_Recortada(9 * intervalo + 1:fila,:) = I_Recortada(9 * intervalo + 1:fila,:) * 5;
        
        ocp = sum(I_Recortada(:));
                
        ocupacion(1,i) = (ocp * 100) / sum(I_Plantilla(:));
        
    end
    
    M = max(ocupacion(:));
    
end

