<meta name="date" content="Sep 12, 2019" />

# Convierte videos por consola al tamaño y peso que necesites

AVISO importante: Este post no es técnico, pero tampoco está escrito para usuarios ofimáticos, requiere tocar esa pantalla oscura y desconocida llamada "Consola".

Cuando tenemos un blog personal, una página más grande o así solo vendamos por Whatsapp, el video es el medio que más atrae atención de nuestro público. Nuestro cerebro evolucionó un ambiente de escasez y es por eso que preferimos siempre lo que menos esfuerzo represente. Hoy por hoy no escasea la energía, per si los datos, y por eso debemos ser conscientes al distribuir contenido por Internet.

![60;;c](https://raw.githubusercontent.com/cjortegon/camiloortegon-public/master/post/2019/media/video_compression.jpeg)

Existe una variedad de programas online y de escritorio que pueden convertir los videos a formatos más livianos, con o sin marca de agua, sin embargo, podemos decir que es la forma amateur, ya que el nivel de conversión no es tan bueno y algunas veces sacrificamos calidad en favor de un buen peso o viceversa.

El secreto está en que cada video es diferente, por el nivel de detalle (más colores y formas agregan complejidad al video) y el tamaño al que se distingue el contenido que estamos compartiendo. Por eso una herramienta donde se puedan ajustar estos parámetros es ideal cuando para que nuestro contenido además de oportuno, útil y viral, sea fácilmente distribuido o visualizado.

La herramienta que les quiero presentar hoy se llama [FFmpeg](https://ffmpeg.org/download.html) y es en muchos casos el algoritmo detrás de estas aplicaciones, o incluso de algunas redes sociales donde subimos nuestros videos y sin saber cómo, reproducimos luego en el transporte público.

### Instalación

Una alternativa es seguir los pasos que se describen en la página (para Linux, Windows y Mac). Sin embargo, me gustaría aquí dar una ayuda a los usuarios de Mac con el comando más completo que encontré para descargar la base juento con todos los formatos de compresión. Para ejecutarlo requerimos tener [Homebrew](https://brew.sh/) instalado:

>   
brew install ffmpeg --with-fdk-aac --with-ffplay --with-freetype --with-frei0r --with-libass --with-libvo-aacenc --with-libvorbis --with-libvpx --with-opencore-amr --with-openjpeg --with-opus --with-rtmpdump --with-schroedinger --with-speex --with-theora --with-tools

### Ejemplos de uso básico

Una vez instalado tendremos disponible en la consola el comando **ffmpeg**, aquí va un ejemplo básico:

>   
ffmpeg -i input.mp4 -r 22 -s 640x360 -c:v h264 -b:v 300k -b:a 0 -ac 0 -ar 0 output.mp4

Estamos tomando un video fuente mediante **-i** llamado __input.mp4__ (que puede estar en cualquier formato, incluso el generado por cualquier celular). Con **-r** le decimos la tasa de muestreo, con **-s** el tamaño del cuadro. Para **-c:v** recomiendo usar el formato [H264](https://en.wikipedia.org/wiki/Advanced_Video_Coding), que es bastante óptimo.

Con **-b:v** cambiamos la compresión del video (este es con el que más pueden jugar para ver los diferentes resultados). Y en este caso **-b:a** y **-ac** están en cero porque es un video sin audio. Al final ponemos el nombre del archivo donde lo queremos exportar (recomiendo mp4).

### Trucos

Algunas formas de optimizar nuestra conversión:

* No incluir el audio si no es necesario.
* El muestreo (**-r**) puede ser bajo si nuestro video no tiene movimientos rápidos.
* El tamaño del cuadro (**-s**) depende de la pantalla donde van a ver nuestro video, normalmente 640x360 es suficiente para la pantalla de un celular. Aquí debemos tener en cuenta también la relación a la que fue exportado o filmado el video, en este caso sería 16:9.
* La compresión (**-b:v**) es la que más margen en el resultado obtenido nos va a dar, pero también la que más puede comprometer la calidad. En este caso debemos tener en cuenta el nivel de detalle del video. Por ejemplo, una animación usualmente requiere un número más bajito que un video filmado, y este a su vez requiere un número más alto si hay muchos componentes en el cuadro (por ejemplo, en exteriores con mucha vegetación).

### Parámetros para comprimir

A continuación, por si el lector quiere explorar más, estas son algunas de las banderas más populares que podemos agregar a nuestro comando de compresión:

* -i → Input
* -r → Frames por segundo
* -s → Resolución
* -c:v → Formato de compresión. Para mp4 h264 es el mejor.
* -b:v → Compresión del video
* -b:a → Compresión del audio
* -an → No incluir audio
* -ar → Canales de audio
* -filter:v "crop=width:height:startX:startY" → Recortar el video

### Bonus

Uno de los parámetros más complejos de usar es **-filter:v** que sirve para varias cosas, pero una muy útil es recortar el encuadre de nuestro video (lo mismo que hacemos con las fotos, pero en video). Para esto es muy importante tener en cuenta la resolución inicial de nuestro video fuente. Por ejemplo, si nuestro video originalmente es de 1280x720 (ancho por alto), debemos asegurarnos que nuestro nuevo encuadre esté dentro de estas medias, para evitar tener zonas en negro dentro del video. Este parámetro no se cruza con **-s**, ya que la resolución final tiene efecto solo después de hacer el recorte.

(Las comillas si van)
>   -filter:v "crop=405:720:437:0"

Esta bandera cambiaría un video con un ratio de 16:9 por uno con un ratio de 9:16, recortando los bordes laterales en igual medida hasta hacer que el video sea vertical.

Si este post te fue útil te invito a compartirlo con más personas para que ellos también puedan distribuir videos de forma óptima y de buena calidad al mismo tiempo.
