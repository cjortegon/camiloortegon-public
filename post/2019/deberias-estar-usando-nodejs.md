<meta name="date" content="Apr 7, 2019" />
<meta name="image" content="https://github.com/cjortegon/camiloortegon-public/raw/master/seo/lambda_js.png" />
<meta name="language" content="es" />

# Deberías estar usando Node.js

Hablar sobre Node.js es hablar de Javascript, ese lenguaje que sostiene a React y Angular, las 2 librerías de frontend más populares de acuerdo al Developer Survey de 2018 de [Stackoverflow](https://insights.stackoverflow.com/survey/2018). Este artículo, aunque habla de dearrallar en back, no va principalmente enfocado a quienes se dedican a ello, sino más bien a quienes desarrollan front o mobile.

Sin importar que lo nuestro sea o no el desarrollo de servicios (eso es para otros), aprender Javascript podría pensarse como la navaja suiza de todo desarrollador.

Aprender solo front o solo back ya no es una opción, ser _full-stack_ es algo que necesitas si quieres formar parte o iniciar una de las Startups que están transformando la forma en que vivimos. Incluso si somos más de mobile (como yo), no es excusa para no aprender algo de back y bases de datos también, las apps ya no son ecosistemas cerrados.

> Tener tiempo limitado hace que nos enfoquemos en aprender las tecnologías con el mayor retorno a la inversión posible.

Y es que a diferencia de la web, donde la batalla se libra principalmente entre los 3 _.JS_ (React, Angular y Vue), el mundo del back es más diverso, así que para decidir toca explorar más alternativas. Pero ahí es donde sacamos nuestra navaja suiza y con un par de prácticas con las principales librerías de Node.js, ya estamos montados en el backend. Más temprano que tarde tendrémos que vernos frente a frente con Javascript, así que es muy inteligente usar en backend la misma tecnología soportada por todos los navegadores.

![;;](https://github.com/cjortegon/camiloortegon-public/raw/master/post/2019/media/js_environment.png)

Node.js es Javascript + V8 (el interpretador desarrollado por Google para correr Javascript fuera del navegador). Y estas son mis razones para dejar de lado a PHP o Java y empezar a escribir servicios en Node.js:

* Node.js funciona muy bien en aplicaciones que usen datos en tiempo real, ya que librerías como [Socket.IO](https://socket.io) convierten un chat en cosa de niños.
* _JSON_, el estandar más usado para comunicarse con el backend es nativo para Javascript.
* Aprendes Javascript para hacer front y ya sabes Node.js, y volverte un experto se hace más fácil porque siempre estás enfocado en el mismo lenguaje.
* Lo mismo sucede cuando aprendes alguna tecnología móvil como [ReactNative](https://facebook.github.io/react-native/), [Ionic](https://ionicframework.com/) o [NativeScript](https://www.nativescript.org/vue).
* El sistema de único hilo orientado a eventos de Node.js es muy rápido para atender miles de solicitudes concurrentes.
* [NPM](https://www.npmjs.com/) es una colección de código creada por la comunidad que con la mayor seguridad tendrá ese módulo en el que te ibas a gastar 1 día construyendo desde cero. Y si no es justo lo que buscabas, siempre puedes hacer fork del código que la mayoría de veces está en Github.
* Construír microservicios en API modernas como AWS Lambda es ampliamente soportado.

En conclusión: Aprende Javascript que construir un backend de forma rápida siempre es algo que potencializará tus habilidades como desarrollador y agente de cambio para un mundo más tecnológico. Y si aún no te he convencido, este [tutorial para construir backends serverless usando Lambda](/blog/2019/no-necesitas-un-servidor-usa-lambda) si lo hará.