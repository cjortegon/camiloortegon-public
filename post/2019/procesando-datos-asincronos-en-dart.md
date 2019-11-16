
Mediante un Isolate:

>   
    import 'dart:isolate';

    class SpawnMessage {
        final SendPort sendPort;
        final dynamic message;
        SpawnMessage(this.sendPort, this.message);
    }

    Future<List<Place>> loadPlaces(String search) async {
        var receivePort = ReceivePort();
        var message = SpawnMessage(receivePort.sendPort, search);
        var isolate = await Isolate.spawn(SearchManager.getPlaces, message);
        final List<Place> places = await receivePort.first;

        receivePort.close();
        isolate.kill();
        this.places = places;
        return places;
    }

    static void getPlaces(SpawnMessage message) {
        final list = List<Place>();
        // Read list of places
        message.sendPort.send(list);
    }

Mediante la función compute:

>   
    Future<List<Place>> loadPlaces(String search) async {
        final List<Place> places = await compute(SearchManager.getPlaces, search);
        this.places = places;
        return places;
    }

    static List<Place> getPlaces(String search) {
        final list = List<Place>();
        // Read list of places
        return list
    }

## Datos ocultos de un Isolate

* Ocupa 2Mb tan solo crearlo.
* El iniciado de un Isolate (spawning) puede tomar entre 50 y 150 milisegundos.
* Los mensajes son copiados, ya que el Isolate creado y el Main Isolate no comparten memoria.

## Conclusión

El uso de Isolates es de muy bajo nivel, pero es actualmente la única forma de no bloquear el hilo principal con tareas pesadas en Dart. Sin embargo pocas veces llegaremos a usarlos, ya que usualmente las cosas que hacemos asíncronas son peticiones http o lectura de archivos que ya han sido diseñadas en Dart para no bloquear el hilo principal partiendo el tiempo de ejecución para que no interfiera con el refrescado de la pantalla.