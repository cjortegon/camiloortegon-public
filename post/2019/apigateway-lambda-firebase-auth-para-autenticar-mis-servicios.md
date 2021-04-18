<meta name="date" content="2019-1-24" />
<meta name="image" content="https://github.com/cjortegon/camiloortegon-public/raw/master/seo/aws_api.png" />
<meta name="language" content="es" />
<meta name="tags" content="aws,apigateway,lambda,firebase,security" />

# API Gateway + Lambda + Firebase Auth para autenticar mis servicios

En este tutorial vamos a aprender a hacer servicios autenticados en API Gateway. Para esto nos vamos a valer de una función Lambda, que operará como middleware conectándose con nuestro sistema de validación de Tokens preferido, yo en este caso voy a usar Firebase Auth, ya que es muy fácil de implementar.

### ¿Qué tecnologías usaremos?

* Node.js
* API Gateway + Lambda + IAM
* Firebase Auth (web + server)

### Configurando Firebase

1. Crea un nuevo proyecto de Firebase
2. Activa la autenticación por correo.

![;;](https://static.platzi.com/media/user_upload/Screen%20Shot%202019-02-06%20at%2011.52.09%20PM-a43705bb-cb78-46c5-941a-8f8f06db75ab.jpg)

3. Crea un servicio para registrar los usuarios (server):

>   
    const firebase = require('firebase-admin')
    const serviceAccount = require('./firebase.json')
    firebase.initializeApp({
        credential: firebase.credential.cert(serviceAccount),
        databaseURL: 'https://******.firebaseio.com'
    })

El archivo **firebase.json** es un _Service Account Key_ que se puede descargar desde [console.cloud.google.com](console.cloud.google.com). Asegurate de tener seleccionado el proyecto correcto.

![;;](https://static.platzi.com/media/user_upload/create-service-account-key-9b3a017b-8b4b-4da8-be7a-49fc8ea7d6ce.jpg)

Asigna un nombre para el service account, no hace falta poner nada en los pasos 2 y 3.

![;;](https://github.com/cjortegon/camiloortegon-public/raw/master/post/2019/media/create-new-service-account-firebase.png)

Y finalmente abre el service account que creaste para descargar el Json que usaremos en la autenticación desde Nodejs.

![;;](https://github.com/cjortegon/camiloortegon-public/raw/master/post/2019/media/download-json-service-account-firebase.png)

>   
    firebase.auth().createUser({
        email,
        emailVerified: false,
        password,
        displayName: name,
        disabled: false
    })
    .then(firebaseResult => {
        uid = firebaseResult.uid
        saveUserInDatabase(uid, email, name)
        // Handle response
    })
    .catch(error => {
        // Handle response
    })

4. Integra el script de Firebase en tu página:

>   
    <script src="https://www.gstatic.com/firebasejs/5.8.2/firebase.js"></script>
    <script>
    // Initialize Firebase
    var config = {
        apiKey: "******",
        authDomain: "*****.firebaseapp.com",
        databaseURL: "https://*****.firebaseio.com",
        projectId: "*****",
        storageBucket: "*****.appspot.com",
        messagingSenderId: "*****"
    };
    firebase.initializeApp(config);
    </script>

Login:

>   
    login = (email, password) => {
        return new Promise((resolve, reject) => {
            firebase.auth().setPersistence(firebase.auth.Auth.Persistence.LOCAL)
            .then(() => {
                return firebase.auth().signInWithEmailAndPassword(email, password)
            })
            .then(login => {
                let {user} = login
                user = JSON.parse(JSON.stringify(user))
                console.log('Logged!', user)
                const {accessToken} = user
                saveAccessToken(accessToken)
                resolve(user)
            }).catch(error => {
                reject(error)
            })
        })
    }

Middleware con Lambda para validar los usuarios

>   
    function handler(event, context, callback) {
        const {authorizationToken: token} = event
        firebase.auth().verifyIdToken(token).then((decodedIdTokens) => {
            const {uid} = decodedIdTokens
            getUser(uid)
            .then(user => {
                callback(null, allowAccess(user)
            })
            .catch(error => {
                callback(null, denyAccess())
            })
        })
        .catch(error => {
            callback(null, denyAccess())
        })
    }

**allowAccess(user)** y **denyAccess()** son 2 funciones que retornan policies de IAM (Con esto API Gateway sabrá si el usuario está autenticado):

**Allow access**

>   
    {
        principalId: JSON.stringify(user),
        "policyDocument": {
            "Version": "2012-10-17",
            "Statement": [
                {
                    "Action": "execute-api:Invoke",
                    "Effect": "Allow",
                    "Resource": "*"
                }
            ]
        },
        "context": {
            "stringKey": "value",
            "numberKey": "1",
            "booleanKey": "true"
        },
        "usageIdentifierKey": "abc"
    }

**Deny access**

>   
    {
        principalId: null,
        "policyDocument": {
            "Version": "2012-10-17",
            "Statement": [
                {
                    "Action": "execute-api:Invoke",
                    "Effect": "Deny",
                    "Resource": "*"
                }
            ]
        },
        "context": {
            "stringKey": "value",
            "numberKey": "1",
            "booleanKey": "true"
        },
        "usageIdentifierKey": "abc"
    }

### Ahora si, a configurar API Gateway

1. Lo primero es crear un rol para que API Gateway pueda ejecutar Lambda.
No voy a entrar en detalle en esta parte, pero digamos que le pusimos apigategay_invoke_lambda
2. También entenderé que ya hemos creado un endpoint con API Gateway. Vamos a la sección de Authorizers y le damos crear uno nuevo.
3. Configuramos el authorizer apuntando a la función que acabamos de crear en Lambda y con el rol de ejecución:

![;;](https://static.platzi.com/media/user_upload/set-up-authorizer-c0be7b08-5f23-4e4d-a6d0-493d92cae324.jpg)

El catching es opcional, pero es recomendado para mejorar el rendimiento de nuestro middleware.

Al configurar un recurso que requiera autenticación en Method Request asegurarse de seleccionar el Authorizer que acabamos de crear. Y en Integration Request leer el principalId en el Mapping template (Este es el que enviamos desde el middleware en la función de _allowAccess(user)_):

![;;](https://static.platzi.com/media/user_upload/authenticated-resource-708e098a-98bf-4086-8f28-1204ab9274d1.jpg)

De esta forma ya no solo puedes crear endpoints con la alta disponibilidad de API Gateway + Lambda, sino que además los servicios pueden ir autenticados.

Cualquier inquietud no dudes en [comentar en mi post de Platzi](https://platzi.com/tutoriales/1419-networking-content/3552-api-gateway-lambda-firebase-auth-para-autenticar-mis-servicios/), sé que algunas cosas requieren de mayor profundidad si no se tiene mucha experiencia con la nube de AWS.
