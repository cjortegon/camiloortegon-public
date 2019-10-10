<meta name="date" content="2019-8-7" />
<meta name="image" content="https://github.com/cjortegon/camiloortegon-public/raw/master/seo/power-of-lambda.png" />
<meta name="language" content="es" />
<meta name="tags" content="lambda,apigateway,aws" />

# Construye backends fácil con AWS Lambda

Hace un tiempo que conocí AWS Lambda, entendí que los servicios en la nube, al igual que otras cosas que compramos con tanta naturalidad, evolucionarían hasta convertirse en algo tan genérico como ir de compras. Bastaría con seleccionar una marca, una presentación (botella, caja, etc), o simplemente abrir el grifo para empezar a usarlos. Nadie del común se pregunta si saldría más barato tener un aljibe o si vale la pena producir tu propia tela, simplemente vas y la compras, y te cobran por lo que consumes, así es Lambda.

![;250;](https://github.com/cjortegon/camiloortegon-public/raw/master/post/2019/media/cloud-plants.jpg)

Pensar en términos de funciones cambia la forma en la que entendemos nuestro backend, porque algunas veces seguimos imaginando que estamos pagando por una caja metálica a la que toca además instalarle una larga lista de software antes de poder imprimir ese "Hola mundo". Pensar en funciones es la forma natural en la que abres inicias una llamada por tu móvil y no te preguntas cómo pasó la señal de tu boca al oído de tu interlocutor.

Lambda trabaja bajo la forma más granular en la que puedes extraer la lógica de tu negocio. No importa si eres desarrollador móvil o frontend, con Lambda ya no hay excusa para depender de backends tipo SaaS rígidos como Firebase que no te permitan mucha flexibilidad para hacer productos súper inter-conectados. Con Lambda debes aprender solo un lenguaje de back como Java, NodeJS o Python y escribir las funciones sin preocuparse de cosas extras como la escalabilidad o seguridad de tu máquina, porque al final, no tienes una máquina, así como no tienes una antena de celular propia para comunicarte.

Ahora si, a lo que vinimos, al código, en este punto asumo que ya tienes una cuenta de AWS creada.

Lo primero es crear una nueva función Lambda, escogiendo uno de los 6 lenguajes soportados actualmente (C#, Go, Java, Node, Python y Ruby). En los permisos Amazon usa IAM para definir los recursos a los que se desea acceder, así podemos por ejemplo dar acceso a un bucket de S3 o a enviar correos por Amazon SES.

Yo trabajaré con NodeJS. Una vez creada la función, dispondremos de un ejemplo con la siguiente estructura:

>   
    exports.handler = async (event) => {
        const {input} = event
        return {
            key: 'value is '+input
        }
    }

Aunque si es de nuestra preferencia, también podremos trabajar con una estructura del estilo:

>   
    exports.handler = (event, context, callback) => {
        const {input} = event
        setTimeout(() => {
            callback(null, {
                key: 'value is '+input
            })
        }, 50)
    }

En ese último estamos simulando que hacemos una petición a la base de datos que nos toma 50 milisegundos. Lambda solo detendrá su ejecución al recibir una respuesta mediante el **return** o mediante el **callback** (el primer parámetro es para errores, debe ir en null para no tener efecto). Pero una función no vive por siempre, así que si esta le toma más del tiempo definido en la configuración, será terminada antes de llegar a una respuesta.

![;300;l](https://github.com/cjortegon/camiloortegon-public/raw/master/post/2019/media/lambda-basic-settings.png)

En la sección de **Basic settings** encontraremos 2 campos parametrizados: Memoria asignada y Timeout. El máximo tiempo que puede una función ejecutarse es de 59 segundos. Y la máxima memoria que podemos asignar a una función es 3008Mb, sin embargo la capacidad de computo aumenta a la misma velocidad a la que se asigna memoria. El precio facturado se calcula en base de los recursos (memoria) asignados y al tiempo de ejecución, cada 100ms o fracción. Para mayor información consultar los [precios actualizados aquí](https://aws.amazon.com/lambda/pricing/). Sin embargo Lambda ofrece un FreeTier (el primer año de uso) de hasta 400.000 segundos de ejecución, una cantidad suficiente para casi cualquier emprendimiento.

Antes de llevar nuestra función a producción, podemos hacer pruebas desde la misma consola para verificar que el timeout y recursos asignados son suficientes.

![;250;l](https://github.com/cjortegon/camiloortegon-public/raw/master/post/2019/media/lambda-test-console.png)

Existen múltiples formas de hacer uso de las funciones lambda. La primera es mediante el uso del API de Amazon en cada lenguaje, la segunda es conectarla a ApiGateway para consumirlo como un servicio REST, y la tercera es creando triggers dentro de otros servicios de Amazon que consuman la función. Hoy nos centraremos en las 2 primeras.

### Accediento mediante el API de Lambda

>   
    var AWS = require('aws-sdk')
    AWS.config.region = 'us-east-1'
    AWS.config.update({
        accessKeyId: process.env.AWS_ACCESS_KEY_ID,
        secretAccessKey: process.env.AWS_SECRET_ACCESS_KEY
    })
>   
    var lambda = new AWS.Lambda()
    var params = {
        FunctionName: 'myLambdaFunction', /* required */
        Payload: JSON.stringify({
            key1: "value1",
            key2: "value2",
            key3: "value3",
        })
    }
    lambda.invoke(params, function(err, data) {
        if (err) console.log(err, err.stack)
        else     console.log(data)
    })

Si la función se invoca desde otra función no hace falta tener un accessKeyId y un secretAccessKey, ya que la función toma las credenciales de la función donde se está ejecutando (Las que configuramos cuando seleccionamos un rol al crear la función), por lo tanto solo hace falta inicializar Lambda así:

>   
    const lambda = new AWS.Lambda({
        signatureVersion: 'v4'
    })

Para conocer más acerca de los roles de las funciones Lambda, y para entender los secretKey usados para conectarse a los servicios de AWS mediante sus API, entre a este [tutorial](/blog/2019/entendiendo-los-roles-de-las-funciones-lambda).

### Accediento mediante ApiGateway

ApiGateway funciona como una puerta para exponer nuestras funciones Lambda mediante servicios REST. Servicios que además [podemos autenticar siguiendo este tutorial](/blog/2019/apigateway-lambda-firebase-auth-para-autenticar-mis-servicios).

Para esto es necesario ir a ApiGateway y crear un nuevo API. Aquí podremos crear nuestras propias rutas (i.e. /blog/search). Y luego creamos nuestros métodos (GET, POST, etc..). Luego asociamos el método a una función específica:

![;250;l](https://github.com/cjortegon/camiloortegon-public/raw/master/post/2019/media/api-gateway-steps.png)

Al crear nuestro método veremos esto:

![90;;](https://github.com/cjortegon/camiloortegon-public/raw/master/post/2019/media/api-gateway-new-method.png)

Así conectamos Lambda con el recurso que vamos a exponer. Y para terminar de exponerlo, debemos configurar estos 4 pasos:

![90;;](https://github.com/cjortegon/camiloortegon-public/raw/master/post/2019/media/api-gateway-4-sections.png)

1. En el __Method Request__ asignamos las variables y validaciones que necesitamos del servicio Rest. Para este caso que es un método GET, definimos 1 query string.

2. En el __Integration Request__ ponemos convertimos los parámetros recibidos a un JSON que nuestra función pueda interpretar de la siguiente forma:

Desde **Mapping templates** seleccionamos __When there are no templates defined (recommended)__ y creamos un Content-Type de tipo: application/json.

Si queremos convertir los query strings:

>   
    {
        "tag": "$input.params('tag')"
    }

Si queremos convertir el body recibido en un método tipo POST, hacemos lo siguiente:

>   
    {
        "body": $input.json('$')
    }

Si adicionalmente queremos mapear los headers que nos provee ApiGateway, podemos hacerlo de la siguiente forma:

>gist:https://raw.githubusercontent.com/cjortegon/camiloortegon-public/master/snippets/2019/construye-backends-facil-con-aws-lambda/snippet-7

Para entender mejor todas las posibilidades que tiene ApiGateway, hice un tutorial ([Aprendiendo a conectar ApiGateway con funciones Lambda](/blog/2019/aprendiendo-a-conectar-apigateway-con-lambda)) al respecto donde explico cada uno de los pasos con mayor detalle.

Los pasos 3 y 4, **Integration Reponse** y **Method Response** casi siempre se dejan de la misma forma como vienen configurados, pero en el tutorial mencionado anteriormente explico cómo podemos sacar provecho de estos.

Un último paso es ir a acciones y presionar "Enable CORS" para que este recurso esté disponible desde cualquier lugar. Y finalmente debemos ir en las acciones también a "Deploy" para hacer visibles todos nuestros cambios en un nuevo stage o uno existente desde una dirección del tipo:

>   
    https://[MY_API_ID].execute-api.us-east-1.amazonaws.com/[MY_STAGE]/path/to/my/resource

Comparte este turorial/artículo si te pareció interesante y si quieres que siga escribiendo no olvides enviarme un [tweet](https://twitter.com/cjortegon).