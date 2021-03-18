# -*- coding: utf-8 -*-

import requests
from os.path import join
import os
import datetime


DATOS = join(".","datos")

def extraer_hora():
    x = datetime.datetime.now()
    ano = ("{0:02}{1:02}{2:02}".format(x.year,x.month,x.day))
    hora = ("{0:02}{1:02}".format(x.hour,x.minute))
    return ano + "_" + hora

def descarga_camara(numero):
    url = "http://trafico.sevilla.org/camaras/cam" + str(numero) + ".jpg"
    page = requests.get(url)
    if page.status_code == 200:

        os.makedirs(join(DATOS,'cam' + str(numero)), exist_ok=True)

        local = join(DATOS,"cam" + str(numero), extraer_hora() + "_cam" + str(numero) + ".jpg")
        imagen = page.content
        with open(local, 'wb') as handler:
            handler.write(imagen)
        return True
    else:
        return False

for i in range(100):
    d = descarga_camara(i)
    if not d:
        print("Descarga fallida en:",i)






