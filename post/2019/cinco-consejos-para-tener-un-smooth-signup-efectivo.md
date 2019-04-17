<meta name="date" content="Apr 21, 2019" />
<meta name="image" content="https://github.com/cjortegon/camiloortegon-public/raw/master/seo/sign-up.png" />
<meta name="language" content="es" />

# 5 consejos para tener un Smooth Sign-up efectivo

Una de las estrategias más conocidas para mejorar el UX de nuestras aplicaciones ha sido la reducción de clicks o pasos necesarios para llegar a un objetivo. Actualmente se hace más necesario porque tenemos usuarios con tiempo y atención limitados, resultado de la cantidad de sobreinformación a la que están expuestos y a la alta exposición a diferentes productos diariamente.

![50;;](https://github.com/cjortegon/camiloortegon-public/raw/master/post/2019/media/sign-up-route.png)

La primera vez que entramos a una tienda lo menos que queremos encontrar es un agente que nos ofrezca sacar la tarjeta de fidelización de la cadena que estámos visitando. Así mismo y homólogamente llevado a todo tipo de establecimiento o app, tampoco queremos encontrar una pantalla pidiendo nuestros datos sin saber a qué estamos entrando. Ahora explicaré algunos consejos para implementar un Smooth Sign-up, es decir un registro en nuestros aplicativos progresivo y amigable.

### 1. Debe ser fluido

Antes de empezar con el diseño de un producto debemos contar con diagramas de flujo del usuario. Trabajar con dedicación esta herramienta nos ayudará a encontrar:
* Qué y cuando necesitamos información del usuario.
* Qué acciones son apropiadas.
* Establecer un orden para las acciones.
* Identificar puntos en los que el usuario necesitará ayuda.

¿Tiene lo necesario? Ahora si puede continuar al flujo normal de mockups, diseño, prototipado y pruebas.

Tenga en cuenta que para diagramar mejor el flujo del usuario es útil tener claro primero el User Persona (descripción de la personalidad y hábitos de un usuario ejemplo) y los múltiples puntos de entrada por los que pueden llegar usuarios a nuestro producto.

### 2. Kiss: Keeep it simple and short (simple y corto)

Preguntar solo lo necesario. Lo fundamental es nombre, email y password (o autenticación social). Datos como dirección, teléfono, género, ciudad, entre otros, pueden ser solicitados más adelante y no durante el registro.

### 3. Divide y vencerás

Preguntar en el momento oportuno: el cual es cuando sea imposible continuar sin cierta información. Dividir los momentos para solicitar información podría disminuir significativamente la fricción del usuario para entregarla.

### 4. Fácil y guiado

Dividir un formulario de registro en varios pasos nos da la oportunidad para explicar qué requerimos en cada paso y podremos implementar técnicas como "Inline Form Validation" sin que se vuelva algo abrumador para el usuario. Algunos preguntas que nos podemos hacer:
* ¿Este campo es requerido o es opcional?
* ¿Estoy siendo explícito con la razón por la que estoy pidiendo un dato?
* ¿Se siente seguro el usuario entregando esta información?

Si el proceso debe ser largo, es imprescindible mostrar cuántos pasos faltan y complementarlo con una barra de progreso.

![;;](https://github.com/cjortegon/camiloortegon-public/raw/master/post/2019/media/progress-bar-get2wear.png)

### 5. Enfocado a móviles

Responsive no es suficiente, podemos facilitar el ingreso de datos al usuario de varias formas:
* En lo posible las opciones deberían ser Dropdowns en lugar de espacios para ingresar texto.
* Menús acordeón: ayudan a que el usuario pueda visualizar mejor la información en pantallas pequeñas.
* Usar los inputs nativos de los teléfonos. En html podemos agregar un _inputMode_ para que dispositivo abra el teclado correspondiente. Por ejemplo _inputMode="tel"_ o _inputMode="url"_.
* Avanzar automáticamente. Si un campo ya se ha completado y es verificable el siguiente campo debería enfocarse.
* Combinar campos si es posible. Es menos frustrante escribir el nombre completo a escribir el nombre y apellido en celdas independientes.
* Mantener un mínimo de 44pt x 44pt para cualquier control tapeable de acuerdo al [Human Interface Guidelines de Apple](https://developer.apple.com/design/human-interface-guidelines/ios/visual-design/adaptivity-and-layout/).