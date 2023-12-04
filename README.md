# Análisis predictivo sobre el precio de componentes de ordenador


En este documento se presenta el resultado de un análisis predictivo de
los precios de diferentes componentes tecnológicos en varias tiendas
virtuales de Argentina. <br>
El objetivo de este análisis es analizar el comportamiento de los precios
de un mismo producto en distintas tiendas de hardware argentinas y
lograr hacer una predicción de a dónde se dirige el mercado tecnológico
a nivel nacional.
Para realizar este análisis se utilizó un servicio conocido como web
scraper, que permite extraer información de páginas web de forma
automática. Este servicio propio programado exclusivamente para su
aprovechamiento en este análisis, se encargó de buscar los nombres de
los artículos en venta, los nombres de las tiendas y los precios en las
páginas web indicadas, además de recuperar un historial diario, por
cada tienda individualmente, de la fluctuación del precio de su producto,
y guardarlos en una base de datos para después, aplicar técnicas
estadísticas además de gráficos para analizar y visualizar los datos
obtenidos.
Los resultados del análisis demuestran que hay una volatilidad
importante en los precios de los componentes tecnológicos en general
incluso haciendo el análisis sobre otra moneda diferente al peso
Argentino. Este documento explica en detalle el proceso y los hallazgos
del análisis.


## ¿Que contiene la Base de Datos?
El análisis que realice es sobre el cambio a corto plazo del precio de
diferentes componentes tecnológicos teniendo en cuenta entre 30 y 50
tiendas virtuales ubicadas en la Argentina dependiendo el producto y su
disponibilidad o stock. Cada elemento en la base de datos va a
representar un producto, el cual va a tener valores como el nombre del
producto, el nombre de la tienda en donde se está vendiendo, el precio
que tiene actualmente y un historial de la fluctuación del precio que fue
teniendo en los últimos 31 días.


## ¿Dónde consigo todos estos datos?
Aunque había bases de datos existentes sobre el tópico, estas estaban
restringidas a ventas en los Estados Unidos; no logré encontrar bases
de datos nacionales con registros de precios al consumidor final. Por lo
tanto, extraje mis propios datos a través de un servicio propio de web
scraping utilizando axios, cheerio, express y sequelize en JavaScript
para obtener un dataset apropiado, basándose en los registros de ~50
tiendas virtuales. [Haciendo clic aqui puede ver el repositorio del scrapper](https://github.com/valentinoarballo/WebScraperAxios)


## ¿Qué es un Web Scraper?
Un web scraper es una herramienta que extrae información de páginas
web de forma automática. Con un web scraper se puede obtener
información valiosa para hacer análisis, investigaciones o comparaciones.
Es una herramienta muy útil para obtener datos de fuentes públicas que no
ofrecen una forma fácil de descargarlos o consultarlos.
Sin embargo, un web scraper también debe respetar las normas éticas y
legales del uso de la información, y no debe violar los derechos de autor o
la privacidad de las fuentes.

## ¿y cómo funciona?
El programa sigue estos pasos:
1. Se le indica qué tiendas virtuales y qué información se quiere obtener.
2. Descarga las páginas web en un formato que la máquina entienda.
3. Busca y extrae la información deseada del código obtenido.
4. Llama a otro servicio que guarda la información en la base de datos.

![imagen del codigo]()

En resumen, se hace una solicitud a diferentes URL’s donde se obtiene
toda la información del sitio, para luego buscarla en la respuesta la
información que me interesa y agregarla a una base de datos, que luego
consumo desde R.
La mejor parte del web scraper es que formatea la información para que
siempre tenga la misma estructura, lo que me permite hacer el análisis
sobre en este caso los procesadores i5 de décima generación, o cambiar
unas cosas y que busque informacion sobre algun procesador ryzen, o
memorias ram, o placas de video.
Para facilitar su reuso, cree una funcionalidad adicional que actúa como
“buscador” donde le paso el nombre de lo que estoy interesado en analizar
cómo por ejemplo, en la situación analizada, donde busco; “intel core i5
10” que va a buscar todos los procesadores intel i5 de generación 10,
además le paso un rango de precios, ya que quiero que me vaya a buscar
productos que solo se encuentran en un rango de 100.000 a 700.000
pesos, esto elimina outliers de tiendas especuladoras que ponen
extremadamente caro el producto o lo publican a $0.


# Como se ven los datos en la actualidad
Para representar los datos decidí hacer un resumen diario, es decir, que
en lugar de hacer un análisis por cada tienda individual, trabajo con los
precios promedio diarios.

![imagen del grafico]()

Cada punto en el gráfico representa el promedio del precio de venta del
producto en cierto día.
El gráfico nos permite identificar a simple vista que el precio no dejo de
subir en el último mes y no parece que se vaya a bajar, de hecho ese es
el próximo punto.

## Como se ve el futuro
Para poder hacer una predicción, antes tenemos que ver si hay
correlación entre los datos analizados, es decir, ver si hay una variable
dependiendo de la otra.
Para esto existe un test conocido como test de Pearson, donde el
resultado puede variar entre 0 y 1, mientras más cerca de 1 mejor, así
que lo ideal sería al menos obtener más de 0.7 o 0.75

![imagen del test de pearson]()

Viendo los resultados nos damos cuenta que si hay correlación, además
considerablemente mejor de lo que esperaba, estos resultados nos
indican que los precios van a continuar subiendo con el paso del tiempo.
Sabiendo esto, podemos hacer una predicción con bastante seguridad
de que va a estar bastante acertada.
En mi caso, teniendo en cuenta que tenía los datos de los últimos 31
días decidí predecir los próximos 31 días, los resultados se ven
representados de la siguiente manera.

![imagen de la prediccion]()

¿Pero cómo podemos asegurarnos por completo de que realmente está
siendo preciso el modelo? Si no confiamos en el test de Pearson,
tenemos otra forma para probar el margen de error del modelo.


# La prueba del margen de error
Una forma muy útil de saber si el programa está haciendo una
predicción acertada sin tener que esperar una semana para corroborar
los datos, es simplemente borrar unos registros de los datos actuales e
intentar predecirlos, si tengo un registro diario que llega hasta el 25 de
octubre, borrar intencionalmente unos 5 días de mi base de datos y ver
cómo se desempeña el modelo de predicción comparando sus
predicciones con mis datos.
De esta forma obtuve que tenía un margen de error de ~30.000 sobre
un producto de 330.000, fallo por un 9.09%, un muy buen resultado
teniendo en cuenta la limitación temporal del modelo y la volatilidad de
la moneda en la que se analiza, lo que me lleva al siguiente punto.


# Como la volatilidad de la moneda afecta el análisis
Para este punto si quería hacer una conversión de los precios a una
moneda menos fluctuante, no me bastaba con buscar el tipo de cambio
y tenerlo como constante, ya que necesitaba la tasa de intercambio
histórica, un registro diario que me permitiera hacer el cálculo de
conversión de moneda diario por cada uno de los precios, esto se tenía
que poder solucionar con una API, debe estar lleno de servicios de
conversión de este tipo pensé, y si los hay, pero todos son de pago,
excepto uno que me dejaba acceder gratis a un historial de tasas, pero
solo para comparar el peso frente a al euro, no encontré ninguno que
me permitiera acceder a un historial en dólares y menos todavía a dólar
blue.

Lo que hice fue básicamente ir recorriendo lo datos que ya tenía,
enviandole la fecha al servicio API, lo que me devolvía la tasa de
cambio de ese dia, esto me permitió agarrar el precio promedio del día y
dividirlo por la tasa de conversión, entonces así pude obtener el precio
en euro oficial diario de cada producto.

![imagen del grafico en euros]()


Si bien el euro oficial no era la moneda que tenía en mente al decidir
hacer esta parte del proyecto, me trajo un cambio positivo al modelo, ya
que subió el nivel de correlación, un poco, pero mejoró, paso de
0.8919189 a 0.9003369 por lo que ahora debería hacer las predicciones
un poco más precisas, y si fuera en dólar blue será aún más precisa.
Así es como se ve la predicción pero con el cambio a euros como
moneda de análisis

![imagen del grafico de prediccion en euros]()


# Conclusión
En base a los resultados obtenidos de nuestro análisis, podemos
concluir que el precio de los componentes tecnológicos en Argentina
muestra una tendencia alcista correlacionada con el paso del tiempo y la
devaluación de la moneda. Este fenómeno se ha observado a través de
un proceso de recopilación de datos utilizando un servicio propio de web
scraping, que me dejo obtener esta información actualizada y precisa
de diferentes tiendas virtuales.
Hemos aplicado un modelo de predicción lineal para estimar el precio
futuro de los productos, validando su precisión con un margen de error
del 9.09%. Aunque este margen puede parecer significativo, es
importante destacar que la predicción de precios en un mercado tan
volátil y afectado por factores externos es una tarea compleja y tener un
margen de error menor al 10% es un muy buen resultado.
Además, hemos descubierto que el cambio a una moneda más estable,
como el euro, puede mejorar la precisión del modelo. Esto significa que
la estabilidad de la moneda en la que se haga el análisis puede tener un
impacto en la precisión de las predicciones de precios futuros.
Este análisis no sólo proporciona una visión valiosa para los
consumidores y los minoristas en Argentina, sino que también destaca
la importancia del análisis de datos para entender y predecir las
tendencias del mercado.

