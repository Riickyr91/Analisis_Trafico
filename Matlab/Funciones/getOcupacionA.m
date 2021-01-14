function [M , pElegida] = getOcupacionA(plantilla, ifondo, I);

    [f c p] = size(plantilla);
    
    ocupacion = zeros(1,p);
    
    for i = 1 : p
        I_Plantilla = plantilla(:,:,i);
        
        R = uint8(I(:,:,1));
        G = uint8(I(:,:,2));
        B = uint8(I(:,:,3));
        
        Rf = uint8(ifondo(:,:,1));
        Gf = uint8(ifondo(:,:,2));
        Bf = uint8(ifondo(:,:,3));
        
        R(I_Plantilla == 0) = 0; 
        G(I_Plantilla == 0) = 0; 
        B(I_Plantilla == 0) = 0;
        
        Rf(I_Plantilla == 0) = 0; 
        Gf(I_Plantilla == 0) = 0; 
        Bf(I_Plantilla == 0) = 0;
        
        IRecortada = cat(3,R,G,B);
        FRecortado = cat(3,Rf,Gf,Bf);
        
        o = FRecortado - IRecortada;
        og = rgb2gray(o);
        ob = og > 70;
        
        ocp = 0;
        
        [fila, columnas] = size(ob);
        intervalo = round(fila/10);             
        
        for k=1:fila
            for j=1:columnas
                if(ob(k,j) == 1)
                    posicion = round(k/intervalo);
                    if(posicion == 0)
                        ocp = ocp + 40;
                    elseif(posicion == 1)
                        ocp = ocp + 35;
                    elseif(posicion == 2)    
                        ocp = ocp + 30;
                    elseif(posicion == 3)
                        ocp = ocp + 25;
                    elseif(posicion == 4)
                        ocp = ocp + 20;
                    elseif(posicion == 5)
                        ocp = ocp + 15;
                    elseif(posicion == 6)
                        ocp = ocp + 12;
                    elseif(posicion == 7)
                        ocp = ocp + 9;
                    elseif(posicion == 8)
                        ocp = ocp + 7;
                    elseif(posicion == 9)
                        ocp = ocp + 5;
                    else
                        ocp = ocp + 1;                        
                    end
                end
            end 
        end
        
        carretera = sum(I_Plantilla(:));
                
        ocupacion(1,i) = 100 * ocp / carretera;
        
    end
    
    M = max(ocupacion(:));
    pElegida = plantilla(:,:,M==ocupacion);
    
end

