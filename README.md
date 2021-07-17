# Analisis_Trafico

Poco a poco, podemos ir viendo como la circulación con vehículos convencionales ( coches, autobuses, etc ... ) en las ciudades  va empeorando debido a la mayor cantidad de vehículos y que las vías no están preparadas para este aumento de vehículos y como consecuencia se producen atascos, por lo que los trayectos cada vez son más largos. Según estudios realizados, Sevilla es la tercera gran capital con más atascos después de Barcelona y Madrid.

La finalidad de este proyecto es analizar la circulación de la ciudad de Sevilla a través de las imágenes para ver la situación actual de la ciudad y poder ver cómo afectan este tipo de situaciones. 
        
Todo proyecto de análisis de datos consta de 5 pasos esenciales. A continuación, vamos a explicar las acciones realizadas en cada paso:

## Extracción de datos
Los datos necesarios para poder realizar este proyecto son imágenes. Estas imágenes son extraídas desde la web del Ayuntamiento de Sevilla la cual es pública y cualquiera puede acceder. 
            
En esta sección explicaremos el script creado para extraer las imágenes de manera automatizada de todas las cámaras de la web. Además este script no sólo descarga las imágenes actual de cada cámara, sino que también elimina las imágenes innecesarias, es decir, en cada cámara sólo se necesitan 10 imágenes para el cálculo de la ocupación de una imagen actual. Estas imágenes son la imagen a analizar y 9 imágenes más para calcular el fondo. De manera que cada vez que se realiza la extracción de una imagen, que será la imagen de estudio, borrará la imagen más antigua, con lo que tenemos las 9 imágenes más recientes para calcular este fondo.

## Procesamiento y selección de características

Una vez que se tiene las 10 imágenes de cada cámara, el primer paso a realizar será calcular el fondo.
            
Para extraer el fondo de la imagen a estudiar, se utilizará el cálculo resultante de la mediana del mismo píxel de las 9 imágenes anteriores a esta, es decir, tenemos el valor de todos los píxeles situados en la misma posición de cada imagen y con este vector calculamos la mediana. Este resultado devuelve el valor situado en la posición central en el vector de valores ordenados.

Inmediatamente después, realizando una resta entre la imagen de estudio y la imagen de fondo, devolverá una imagen donde resaltará los píxeles que han sufrido modificaciones, en nuestro caso, los píxeles de carretera que están ocupados. Pero, en esta imagen también aparecerá cierto ruido procedente de las aceras, arboles, edificios, etc.

Para eliminar este ruido, se han generado unas plantillas que identifican qué zona de la imagen es carretera y qué zona de la imagen no lo es.

Superponiendo esta plantilla con la imagen resultante de la diferencia, se podrá tapar todo el ruido que esté fuera de esta carretera, quedando así sólo los píxeles dentro de ella que es nuestro objetivo.

Todo este proceso explicado tanto en el primer punto como en este, se automatizará en un servidor de manera que se esté ejecutando automáticamente y vaya guardando los resultados en una base de datos para su posterior estudio.

Pero, si se observa bien, ahora mismo los datos que estamos guardando son píxeles ocupados. Este número de píxeles ocupados de una cámara no es comparable con el de otras cámaras, ya que las resoluciones son distintas y con ello la cantidad de píxeles en cada imagen varía. Para solucionar este problema, se ha normalizado los valores, tomando los máximos y mínimos obtenidos por cada cámara, teniendo así una medida comparable entre cada cámara.

## Aplicación de algoritmos
        
Llegados a este punto, ya se tienen los datos filtrados para su estudio. 

Primero se realizará un análisis exploratorio de todas las variables ( cámaras ) para ver los valores con los que se va a trabajar ( rango, tipo, histograma, porcentaje de valores nulos o missing values , etc ).

A continuación, aplicaremos el algoritmo Kmenas para ver la similitud entre cada cámara, y se representará en un mapa todas las cámaras marcadas con un color en función de la clasificación obtenida este algoritmo. 

Para finalizar este punto, se realizará un diagrama de Voronoi para observar el radio de influencia de cada cámara sobre un mapa de la ciudad de Sevilla, y con ello poder estudiar la necesidad de implementar más cámaras en qué zonas o quitar cámaras debido a que existan demasiadas en una misma zona.

## Visualización de datos

En esta sección, se representará los valores filtrados de cada cámara, y con ellos podremos observar gráficamente cómo evoluciona a lo largo del día la ocupación en una cámara, comportamiento de cada día de la semana, etc.

Después se representará en un mapa todas las cámaras, pero en este caso el color de ellas indicará la ocupación actual en la carretera.

Para finalizar, realizaremos un estudio de estas calidad de estas cámaras, debido a que hay veces que las cámaras no están disponibles como consecuencia de fallos en ellas. Esto produce pérdidas de datos. Estos fallos son casi imprevisibles, pero lo que si se puede mejorar es el tiempo de reacción en el momento falla una cámara o se detecta que va a fallar. Por lo que se ha realizado un estudio de las cámaras que más tiempo se han llevado en no disponible.

## Conclusiones

Por último, en este apartado se realizará unas conclusiones del proyecto. Se hablará de la veracidad de los datos obtenidos cómo de posibles mejoras de este sistema.

Por último, se ha de comentar que debido a la complejidad del propio problema, haremos más énfasis en el análisis de las imágenes dentro de este proyecto, es decir, en los dos primeros puntos.

También, comentar que este proyecto puede servir como punto de inicio para otros proyectos que encuentren alguna mejora a las partes de este o que realicen un estudio en el que se haga más hincapié en mejoras de la circulación o puntos críticos de ésta.

## Contenido del repositorio

En la carpeta Matlab podremos encontrar:
-   CalculaPlantilla: Calcula la plantilla de manera automatizada dado un CONJUNTO de imágenes
-   RecortaPlantilla: Recorta la plantilla de manera manual de un CONJUNTO de imágenes
-   RecortaPlantillaImagen: Recorta la plantilla de manera manual de una SOLA imagen

En la carpeta de Python, nos encontraremos dos subcarpetas:
-   ExtraerDatos, en la cual nos encontraremos:
    -   Una carpeta llamada Datos, con una muestra de 10 imágenes de cada cámara-
    -   En la carpeta No_Disponible podremos tener la imagen tipo para cuando la cámara no esté disponible
    -   En la carpeta plantillas, cómo en su propio nombre indica, tendremos las plantillas de cada cámara
    -   El notebook ExtraeImagenes, en el cual se descarga la última imagen de cada cámara y la guarda en la carpeta Datos.
    -   El notebbok CalculaOcupación, el cual genera un archivo .csv con los datos de las imágenes más reciente de cada cámara.
-   En la carpeta Análisis_Datos, entontraremos lo siguiente:
    -   Un fichero .csv de dato anómalos.
    -   Un fichero .csv de datos normalizados para su estudio.
    -   Dos análisis exploratorios de los dos ficheros .csv.
    -   El notebook Análisis, el cual gracias a los ficheros anteriormente mencionados podemos realizar todas las pruebas que queramos.

En la carpeta Otros nos encontraremos un PDF con la comparación de todas las plantillas creadas manualmente y automáticamente de cada cámara.
