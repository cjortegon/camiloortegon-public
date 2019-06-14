<meta name="date" content="2019-6-16" />
<meta name="image" content="https://github.com/cjortegon/camiloortegon-public/raw/master/seo/swift_ui_presentation.png" />
<meta name="language" content="es" />
<meta name="tags" content="apple,swiftui,apps,react,redux,snapkit,rxcocoa" />

# SwiftUI: Apple entra por fin a la era de UI modernas

Siguiendo los pasos de React Native y Flutter en la creación de vistas, y más recientemente de [Jetpack Compose](https://developer.android.com/jetpack/compose), Apple deció unirse al club de la programación declarativa de interfaces. Esto pone tregua la larga discusión que llevamos los desarrolladores para productos Apple sobre si es mejor usar el Storyboard o la creación de vistas programáticas.

Resulta difícil decidir si el Storyboard es suficientemente mantenible o si la creación de vistas a partir de código es realmente escalable. Con SwiftUI tenemos certeza de algo y es que ambos bandos tendrémos un espacio común para que crear vistas ya que el nuevo Xcode 11 permite tener a un lado el código, mientras vemos en vivo cómo se va viendo al otro lado de la pantalla, o a la inversa. Esto no sería innovador si tuviera 2 ingredientes fundamentales de la receta SwfitUI: Programación declarativa y Hot reload.

![;;](https://github.com/cjortegon/camiloortegon-public/raw/master/post/2019/media/swiftui-presentation-wwdc19.png)

En esa búsqueda de formas de escribir vistas más fáciles de mantener surgieron librerías como [SnapKit](https://github.com/SnapKit/SnapKit) o [RxCocoa](https://github.com/ReactiveX/RxSwift). Sin embargo quienes nos manteníamos motivados por el desarrollo de iOS nativo, veíamos con decepción como era significativamente más rápido escribir interfaces en otras plataformas. Desde la popularización de React conocimos el potencial que significaba "declarar" nuestra interfaz.

No es un secreto que con las exigencias de hoy en día, las vistas se han convertido en una de las partes más complejas de desarrollar en cualquier aplicación: componentes reactivos, animaciones, localización e interacciones para nativos digitales, por mencionar algunos retos. Con el paradigma imperativo con que contabamos antes sería prácticamente imposible controlar una de estas vistas modernas. Antes de contar con vistas declarativas respondíamos a eventos de forma separada, con un alto riesgo de perder el control.

En contraste el paradigma declarativo nos permite "declarar" como debe verse la vista respondiendo a un estado centralizado. Como resultado contamos con una reducción de complejidad, menos líneas de código y desarrolladores más eficientes. No es sorpresa que Apple haya decidido sumarse a esta tendencia.

El segundo ingrediente que considero interesante en la ecuación de SwiftUI es que la interfaz que vemos a un lado de nuestro código que mencioné anteriormente, no es una representación aproximada de lo que estamos escribiendo, sino que se trata de nuestro código corriendo en tiempo real y en teoría completamente funcional. Esto es algo que tanto Flutter como React Native y hasta Xamarin habían implementado años atras. Son horas valiosas al mes de no esperar hasta que se compile el código para ver el resultado de ese pequeño cambio que hicimos.

Finalmente y para decir que no todo es color rosa, la mala noticia es que SwiftUI viene como un Framework, por lo que solo estará [disponible a partir de iOS 13](https://developer.apple.com/documentation/swiftui/), por lo que tendrémos que esperar un par de años antes de poder decir que los desarrolladores nativos de iOS estamos montados en la construcción de vistas declarativas bajo esta tecnología. Sin embargo no es razón para no ir aprendiendo de los muy bien elaborados [tutoriales]((https://developer.apple.com/tutorials/swiftui)) ofrecidos por Apple.