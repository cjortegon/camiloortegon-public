import 'package:flutter_redux/flutter_redux.dart';
import 'package:redux_epics/redux_epics.dart';

Stream<dynamic> startAppEpic(Stream<dynamic> actions, EpicStore<AppState> store) {
    return actions
        .where((action) => action is AppAction)
        .asyncMap((action) {
            if (action == AppAction.startapp) {
                Navigator.pushReplacement(store.state.context,
                    MaterialPageRoute(
                        builder: (context) => StoreProvider<AppState>(
                            store: store.state.store,
                            child: LoginView(),
                        ),
                    ),
                );
            }
        }
    );
}