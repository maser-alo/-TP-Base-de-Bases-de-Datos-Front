* Estaciones de Media Tensión — TP Modelado de Datos

Este proyecto fue desarrollado como trabajo práctico de Modelado de Datos y consiste en un sistema de monitoreo para estaciones de media tensión utilizando PHP, MySQL/MariaDB y Chart.js.
El objetivo principal es representar correctamente un modelo relacional de base de datos, almacenar mediciones eléctricas y visualizar la información mediante un dashboard web interactivo.
La aplicación permite gestionar estaciones eléctricas distribuidas en distintas localidades y provincias, relacionarlas con sensores específicos y registrar mediciones como tensión, corriente, potencia, frecuencia y coseno φ.

1) Descripción del sistema

La base de datos fue diseñada siguiendo un modelo entidad-relación normalizado.
Cada estación pertenece a una localidad, cada localidad pertenece a una provincia y cada provincia pertenece a un país.
Las estaciones pueden tener múltiples sensores asociados, y cada sensor trabaja con una unidad de medición determinada.
Por ejemplo:
- sensores de tensión
- sensores de corriente
- sensores de potencia
- sensores de frecuencia
Las mediciones registradas por estos sensores se almacenan en la tabla "medicion", junto con la fecha y hora correspondiente.
El sistema incluye datos de ejemplo para poder probar consultas, gráficos y filtros.

2) Funcionalidades principales

El dashboard web desarrollado en PHP permite visualizar la información de manera dinámica y moderna.
Entre las funcionalidades principales se incluyen:
- visualización de mediciones en tiempo real
- filtros por estación, unidad y fecha
- exportación de datos a CSV
- gráficos interactivos
- indicadores KPI
- interfaz responsive
- visualización ordenada de sensores y estaciones
El sistema también mantiene el estado de los filtros al navegar y evita que la página se “reinicie” visualmente al cambiar opciones.

3) Modelo de Base de Datos

El proyecto utiliza las siguientes entidades principales:
- pais
- provincia
- localidad
- estacion
- unidad
- sensor
- estacion_sensor
- medicion
La tabla "estacion_sensor" funciona como tabla intermedia para representar la relación muchos a muchos entre estaciones y sensores.
Por otro lado, la tabla "medicion" almacena los valores registrados por cada sensor junto con la fecha y hora de captura.

4) Consultas SQL desarrolladas

Dentro del proyecto se implementaron distintas consultas SQL para demostrar el uso del modelo relacional y las relaciones entre tablas.
Algunas de las consultas realizadas incluyen:
- listado de sensores ordenados alfabéticamente
- cantidad de sensores por estación
- búsqueda de sensores según coordenadas geográficas
- sensores pertenecientes a localidades específicas
- promedio de corriente diaria
- potencia máxima registrada
- tensión mínima mensual

Estas consultas utilizan:
- JOIN
- GROUP BY
- AVG
- MAX
- MIN
- filtros con WHERE
- ordenamiento con ORDER BY

5) Dashboard y visualización

El sistema web incluye gráficos desarrollados con Chart.js, permitiendo visualizar:
- sensores por estación
- evolución de corriente
- potencia diaria
- tensión mínima mensual

También se incorporaron tarjetas KPI con información resumida como:
- total de mediciones
- cantidad de estaciones
- cantidad de sensores
- última medición registrada
La interfaz fue diseñada con un estilo moderno utilizando CSS personalizado y una paleta de colores orientada a dashboards tecnológicos.

6) Tecnologías utilizadas

Para el desarrollo del proyecto se utilizaron las siguientes tecnologías:
- MySQL / MariaDB
- HeidiSQL
- HTML
- CSS
- JavaScript
- Chart.js

7) Instalación del proyecto
Para ejecutar el sistema localmente:
1. Clonar el repositorio de GitHub.
2. Importar el archivo SQL de la base de datos.
3. Configurar las credenciales de conexión en PHP.
4. Colocar el proyecto dentro de htdocs si se utiliza XAMPP.
5. Ejecutar Apache y MySQL.
6. Abrir el proyecto desde el navegador.

8) Contenido del repositorio

El repositorio incluye:
- archivo .sql completo de la base de datos
- consultas SQL
- dashboard desarrollado en PHP
- DER del modelo relacional
- documentación del proyecto


