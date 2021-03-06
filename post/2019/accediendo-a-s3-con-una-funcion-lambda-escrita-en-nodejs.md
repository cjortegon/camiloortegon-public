<meta name="date" content="2019-1-31" />
<meta name="image" content="https://github.com/cjortegon/camiloortegon-public/raw/master/seo/lambda_js.png" />
<meta name="language" content="es" />
<meta name="tags" content="s3,nodejs,aws" />

# Accediendo a S3 con una función Lambda escrita en Node.js

En este tutorial veremos como es de fácil acceder a otros servicios de AWS desde Lambda, como por ejemplo S3. Si tenemos procesos complejos, lo mejor sería no sobrecargar nuestra instancia de EC2, sino que podemos llamar una función de Lamda para ejecutarlo de forma asíncrona.

A continuación solo vamos a mover una imagen de un bucket privado a un bucket público de S3 (previamente creados), pero si se requiere se podría comprimir la imagen y crear varias versiones de esta, o procesarla mediante un algoritmo de inteligencia artificial para detectar cosas prohibidas como desnudos.

>   
    const AWS = require('aws-sdk')
    const S3 = new AWS.S3({
        signatureVersion: 'v4',
    })
>   
    exports.handler = function(event, context, callback) {
        const {originalKey, newKey} = event
        copyImageToPublicBucket(originalKey, newKey, callback)
    }
>   
    function copyImageToPublicBucket(originalKey, newKey, callback) {
        S3.getObject({
            Bucket: PRIVATE_BUCKET,
            Key: originalKey
        }).promise()
        .then(data => {
            return S3.putObject({
                Body: data.Body,
                Bucket: PUBLIC_BUCKET,
                ContentType: 'image/jpeg',
                Key: newKey,
            }).promise()
            .then(() => {
                callback(null, {
                    newKey
                })
            })
        .catch(err => callback(err))
        }).catch(err => callback(err))
    }
