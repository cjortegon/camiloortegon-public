import 'package:flutter_redux/flutter_redux.dart';

class _HomeView extends State<HomeView> {

    @override
    Widget build(BuildContext context) => StoreConnector<AppState, AppStateDispatcher>(
        converter: (store) {
            store.state.context = context;
            return AppStateDispatcher((action) => store.dispatch(action));
        },
        builder: (context, viewModel) {
            return buildComponent(context, viewModel.dispatch);
        },
    );

    Widget buildComponent(BuildContext context, void Function(dynamic) dispatch) {
        return Scaffold(
            appBar: AppBar(
                title: Text("Welcome to my Redux App"),
            ),
            body: Container(
                margin: EdgeInsets.all(10),
                child: Column(
                    children: <Widget>[
                        Text("Este es el home", style: TextStyle(fontSize: 25),),
                    ],
                )
            ),
        );
    }

}