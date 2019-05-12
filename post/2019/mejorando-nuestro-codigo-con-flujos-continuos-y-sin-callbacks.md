<meta name="date" content="2019-4-14" />
<meta name="image" content="https://github.com/cjortegon/camiloortegon-public/raw/master/seo/redux-observable-flow.png" />
<meta name="language" content="es" />
<meta name="tags" content="apps,react,redux,redux-observable" />

# Mejorando nuestro código con flujos continuos y sin callbacks

Recuerdo la primera vez que escribí un programa en el que combinaba todo lo aprendido en mi curso de algoritmos sobre clases, vistas, condicionales e hilos. Era un juego en 2D que simulaba un carrito al estílo de [Crazy Taxi](http://games144.com/game/36431n-crazy-taxi-facebook-game.php#play), un juego popular en Facebook por esos días.

![40;;](https://github.com/cjortegon/camiloortegon-public/raw/master/post/2019/media/first-cart-game.png)

Todo marchaba bien y me encantaba que preguntaran: ¿De verdad lo hiciste todo? Hasta que pasado un mes y medio de haberlo escrito quise volver al código para ajustar un par de cosas. Sorprendido quedé al encontrar un código que siendo mio me costaba comprender. Había descubierto el problema que muchos desarrolladores antes de mi habían enfrentado, el temido código espaguetti.

>   Pasamos más tiempo leyendo código que escribiendo, por eso vale la pena que sea fácil de leer.

Quise contar esta anéctota para dar una introducción a un problema más reciente que tuve que enfrentar. Se trata del manejo de flujos al interior de las aplicaciones.

Algunas de las más modernas apps hoy en día han tenido que buscar estrategias a 2 grandes retos: flujos que corten clicks con un alto nivel de UX y componentes reactivos, hablarémos hoy del primero. Nuestros usuarios presentan cada vez una más baja atención. Es por esto que con frecuencia implementamos Smooth Sign-up y reducimos el número de pantallas para llegar a un lugar, con el objetivo de reducir esa gran pérdida de usuarios, que en muchos casos llega a ser [mayor al 80% en los primeros 3 días de uso](https://www.linkedin.com/pulse/losing-80-mobile-users-normal-why-best-apps-do-better-andrew-chen/). Sin embargo a nivel de código, no siempre suele ser fácil de implementar.

En el proyecto más reciente que estuve trabajando pasamos por diferentes arquitecturas, una en particular llamada "Operaciones", que a pesar de modularizar en buena medida toda la base de código, me recordó ese anidado infinito de callbacks que alguna vez implementé en mi versión del Crazy Taxi. Justamente en eso quisiera hacer hincapié, para proyectar una mejor forma de manejar los flujos.

Recientemente empezamos a implementar el modelo [Redux-observable](https://redux-observable.js.org/) dentro de nuestras aplicaciones, que podemos ver como la extensión de Redux (gran aliado de React para el manejo de datos), para simplificar los flujos en las mismas estructuras de acciones y centralización de procesos. Si no estás familiarizado con el tema, lo más importante a saber de esta arquitectura es lo siguiente:

Todo son acciones:
>   
    Store.dispatch(AuthAction.showLoginRegisterFlow)

Todos flujo es un Epic:
>   
    pingEpic = action$ => action$.pipe(
        filter(action => action.type === 'PING'),
        mapTo({ type: 'PONG' })
    )

Pero, ¿qué pasa cuando un flujo depende de otro para continuar? Por ejemplo, digamos que siguiendo los lineamientos del "Smooth Sign Up", queremos que nuestros usuarios agreguen sus productos al carrito de compras antes de llegar a registrarse. Bajo el esquema de operaciones que mencioné antes, hacíamos lo siguiente:

>   
    LoginRegisterOperation()
    .execute( status => {
        if status == .ok {
            CheckoutOperation()
            .execute()
        } else {
            showAlertError()
        }
    }

En el código anterior tenemos 4 errores/problemas:
1. _LoginRegisterOperation()_ no es estríctamente la operación de "Login/Registro", sino una validación de la sesión del usuario, y en la que se pedirá ingresar cuando no se ha iniciado sesión.
2. Si el usuario decide no continuar, se le mostrará un mensaje de error, ya que el **status** no es **.ok**.
3. No es una estructura escalable debido a que si _CheckoutOperation_ depende de más operaciones, estas tendrán que ser anidadas.
4. Aunque las operaciones modularizan el código, la lógica del checkout está dispersa en varias operaciones.

Corrigiendo el código anterior:

>   
    CheckSesionAndStartAuthOperation()
    .execute( status => {
        if status == .ok {
            CheckAddressAndStartAddressOperation()
            .execute( status => {
                if status == .ok {
                    CheckoutOperation()
                    .execute()
                } else if status != .dismiss {
                    showAddressError()
                }
            })
        } else if status != .dismiss {
            showAuthenticationError()
        }
    }

Resolvimos lo de los nombres, lo del status y agregamos la operación de dirección que hacía falta, pero el 4to punto quedó sin resolver, ahora no sabemos donde está toda la lógica del checkout y el código empieza a verse como un terrible [callback hell](http://callbackhell.com/).

Es aquí donde decidimos que lo mejor sería convertir nuestras operaciones en Epics para desarrollar toda la lógica de la app con esta arquitectura. Pero los Epics tienen una restricción sana, que nos haría buscar una alternativa para borrar los callbacks y escribir código fluido.


![;;](https://github.com/cjortegon/camiloortegon-public/raw/master/post/2019/media/water-flow.png)

Vimos anteriormente que en Redux-observable todo eran acciones, así que _AuthAction.showLoginRegisterFlow_ sería la acción para abrir la pantalla Login/Registro de la app. Sin embargo lo que nuestra operación análoga decía antes era _CheckSesionAndStartAuthOperation_. ¿Cómo validar esto antes de abrir el módulo de autenticación? La respuesta estaba al frente de nuestras narises: La validación debe hacerla quien requiera que el usuario esté autenticado, es decir, la lógica del Checkout. Y así fue:

>   
    checkoutEpic = action$ => action$.pipe(
        filter(action => action.type === 'Checkout'),
        flatMap({
            if( user.isLogged() ) {
                startCheckout()
            } else {
                Store.dispatch(AuthAction.showLoginRegisterFlow)
            }
        })
    )

En el código de arriba hay 2 errores, ¿puedes verlos?
1. No hay un callback, lo que significa que al terminar de iniciar sesión el usuario no continuará al checkout y deberá volver a presionar el botón de "Comprar".
2. Faltan más flujos por ejecutar.

El problema es que estamos pensando en callbacks, y es justo eso lo que debemos cambiar, así que ¿cómo hacer un callback que no sea un callback? La respuesta fue: que el flujo sea continuo, nunca a modo de callback. ¿Cómo se hace? Aquí la corrección:

>   
    checkoutEpic = action$ => action$.pipe(
        filter(action => action.type === 'startCheckoutFlow'),
        flatMap({
            if( !user.isLogged() ) {
                Store.dispatch(AuthAction.showLoginRegisterFlow(
                    dispatchOnSuccess: CheckoutAction.startCheckoutFlow,
                    dispatchOnError: AlertAction.showMessage("...")
                ))
            } else if( !user.hasAddress() ) {
                Store.dispatch(AddressAction.createAddressFlow(
                    dispatchOnSuccess: CheckoutAction.startCheckoutFlow,
                    dispatchOnError: AlertAction.showMessage("...")
                ))
            } else {
                startCheckout()
            }
        })
    )

Con lo anterior podemos ver 2 cosas, lo primero es que el flujo siempre es continuo, no hay callbacks. Lo segundo es que toda nuestra lógica del checkout quedó siendo parte del **CheckoutEpic** y no de flujos externos.

¿Quieres saber más sobre la arquitectura de Redux-observable? [Escribeme un tweet](http://twitter.com/home?status=%40cjortegon%20escribe%20un%20tutorial%20sobre%20redux-observable.).
