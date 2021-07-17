function [plantillaElegida] = encuadrarImagen(I,ifondo, numPixeles)
% Busca la mejor opción entre plantilla calculada automaticamente y la
% imagen pasada de fondo junto a la imagen a procesar. Desplazando la
% imagen para obtener el mejor resultado.

    [f c m] = size(ifondo);
    
    ifondo2 = ifondo(numPixeles:f-numPixeles, numPixeles:c-numPixeles,:);
    
    desplazamiento = numPixeles * 2;
    
    w = sum(ifondo2(:));
       
    for i=1:desplazamiento
        for j=1:desplazamiento
            Iprueba = I(i:(f-(desplazamiento-i)),j:(c-(desplazamiento-j)),:);
            
            res = Iprueba - ifondo2;
            res2 = rgb2gray(res);
            res3 = res2 > 70;
            
%             figure('WindowState','maximized');
%             subplot(1,3,1), imshow(ifondo2)
%             subplot(1,3,2), imshow(Iprueba)
%             subplot(1,3,3), imshow(res3)
%             title("Fila : " + i + " Columna " + j)
%             pause();
%             close
          
            if(sum(res3(:)) < w)
                plantillaElegida = res3;
                w = sum(res3(:));
            end

        end
    end
        
end

