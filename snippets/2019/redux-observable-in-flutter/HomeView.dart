import 'package:flutter_redux/flutter_redux.dart';

class _HomeView extends State<HomeView> {

    @override
    Widget build(BuildContext context) => StoreConnector<AppState, HomeViewModel>(
        converter: (store) {
            store.state.context = context;
            return HomeViewModel((action) => store.dispatch(action), store.state.oneProperty);
        },
        builder: (context, viewModel) {
            return buildComponent(context, viewModel.dispatch, viewModel.oneProperty);
        },
    );

    Widget buildComponent(BuildContext context, void Function(dynamic) dispatch, String oneProperty) {
        return Scaffold(
            appBar: AppBar(
                title: Text("Welcome to my Redux App $oneProperty"),
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
