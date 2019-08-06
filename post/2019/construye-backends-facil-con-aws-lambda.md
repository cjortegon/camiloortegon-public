<meta name="date" content="Aug 7, 2019" />

# Construye backends fácil con AWS Lambda

Hace un tiempo que conocí AWS Lambda, entendí que los servicios en la nube, al igual que otras cosas que compramos con tanta naturalidad, evolucionarían hasta convertirse en algo tan genérico como ir de compras. Bastaría con seleccionar una marca, un presentación básica (botella, caja, etc), y abriríamos el grifo para empezar a usarlo. Nadie se pregunta si saldría más barato tener un aljibe o si vale la pena producir tu propia tela, simplemente vas y la compras, y te cobran por lo que consumes, así es Lambda.

![;250;](https://github.com/cjortegon/camiloortegon-public/raw/master/post/2019/media/cloud-plants.jpg)

Pensar en términos de funciones cambia la forma en la que entendemos nuestro backend, porque algunas veces seguimos imaginando que estamos pagando por una caja física a la que toca además instalarle una larga lista de software antes de poder imprimir ese "Hola mundo". Pensar en funciones es la forma natural en la que abres inicias una llamada por tu móvil y no te preguntas por cómo pasó la señal de tu boca al oido de tu interlocutor.

Lambda trabaja bajo la forma más granular en la que puedes extraer la lógica de tu negocio. No importa si eres desarrollador móvil o frontend, con Lambda ya no hay excusa para depender de backends tipo SaaS rígidos como Firebase que no te permitan mucha flexibilidad para hacer productos super inter-conectados. Con Lambda debes aprender solo un lenguaje de back como Java, NodeJS o PHP y escribir las funciones sin preocuparse de cosas extras como la escalabilidad o seguridad de tu máquina, porque al final, no tienes una máquina, así como no tienes una antena de celular propia para comunicarte.

Ahora si, a lo que vinimos, el tutorial: