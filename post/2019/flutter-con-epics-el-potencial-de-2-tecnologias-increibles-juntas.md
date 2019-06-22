<meta name="date" content="2019-6-23" />
<meta name="language" content="es" />
<meta name="tags" content="flutter,redux-observable,redux" />

# Flutter con Epics, el potencial de 2 tecnologías increíbles juntas

Flutter, uno de los frameworks más emocionantes con los que he trabajado este año, me sorprende cada día por lo efectivo que resulta para crear Apps con un alto desempeño y que con poco tiempo ya está haciendo un frente importante a tecnologías multiplataforma como ReactNative y Ionic.

Desde que empecé a moverme entre las 3 carpetas principales (lib/android/ios) que contiene un proyecto de Flutter, me planteé que antes de adentrarme en los complejos retos con este tipo de frameworks como lo son conectarse con componentes nativos de cada plataforma, necesitaba estructurar mis aplicaciones con una de las arquitecturas más populares últimamente. Estoy hablando de Redux y Redux-observable, la forma en la que se están construyendo los productos más innovadores desde hace un tiempo.

Hoy quiero mostrarles lo sencillo que resulta implementar [redux_epics](https://pub.dev/packages/redux_epics) (Redux-observable), que todavía se encuentra en su etapa Beta. Si no sabe lo que es un Epic, le recomiendo leer primero este [artículo](/blog/2019/mejorando-nuestro-codigo-con-flujos-continuos-y-sin-callbacks) que escribí al respecto.

Lo primero es agregar en el **pubspec.yaml** estas 3 librerías (validar el número de versión):
>   
    redux: "^3.0.0"
    flutter_redux: "^0.5.3"
    redux_epics: "^0.10.6"

Un Epic se vería así:

>gist:https://raw.githubusercontent.com/cjortegon/camiloortegon-public/master/snippets/2019/redux-observable-in-flutter/StartAppEpic.dart

Como veremos más adelante, nuestro **AppState** tiene un **context**, que corresponde al que se está usando en la pantalla actual. Mediante este podemos navegar usando el **Navigator**. También podemos ver también un **StoreProvider**, que se encarga de construir la vista pasando el **Store**, del cual extraerá lo necesario del estado y despachará nuevas acciones.

Ahora modificamos nuestro **main.dart** para crear el estado con un reducer y nuestros Epics:

>gist:https://raw.githubusercontent.com/cjortegon/camiloortegon-public/master/snippets/2019/redux-observable-in-flutter/main.dart

Por si queda alguna duda, el **build()** aquí no es modificado y lo he dejado con una vista de Launcher que posteriormente será reemplazada ya que se está haciendo un dispatch de la acción **AppAction.startapp**.

>   
    @override
    Widget build(BuildContext context) {
        return Container(
            child: LauncherView(),
        );
    }

Finalmente, las vistas se adaptan a la arquitectura:

>gist:https://raw.githubusercontent.com/cjortegon/camiloortegon-public/master/snippets/2019/redux-observable-in-flutter/HomeView.dart

Editamos el **build(context)** usando un **StoreConnector**, que nos permitirá recibir las propiedades enviadas por el **StoreProvider**.

El **HomeViewModel** que vemos como segundo parámetro es un ViewModel que podemos usar para pasar todo lo necesario del store a nuestra vista. En este caso lo estoy construyendo con una función para hacer **dispatch()** de nuevas acciones y así comunicarme con nuevos Epics (flujos).

Es muy importante que en el **converter()** hagamos una reasignación del **context** que tenemos guardado, para permitirle a otros Epics hacer la navegación correctamente.

Ya para cerrar nuestro **StoreConnector** tiene un **builder()** donde podemos construir la vista y hacer uso de todo lo que hayamos puesto en el ViewModel, que pueden ser incluso propiedades del estado, las cuales pueden hacer reaccionar a la vista si son modificadas por un reducer.

Si le gustó este artículo le recomiendo compartirlo y preguntarme cualquier cosa por [Twitter](https://twitter.com/cjortegon) sobre Flutter o Redux. Más adelante haré un tutorial para implementar [flutter_redux](https://pub.dev/packages/flutter_redux) en una sola vista.