final epics = combineEpics<AppState>([
    startAppEpic,
    loginEpic,
]);

Store<AppState> store;

@override
@mustCallSuper
void initState() {
    this.store = new Store<AppState>(
        mainReducer,
        initialState: AppState(this.context),
        middleware: [
            loggingMiddleware,
            EpicMiddleware(epics),
        ],
    );
    this.store.dispatch(SetStore(store));
    Future.delayed(const Duration(milliseconds: 1000), () {
        this.store.dispatch(AppAction.startapp);
    });
}

AppState mainReducer(AppState state, action) {
    if(action is SetStore) {
        state.store = action.store;
    }
    return state;
}

loggingMiddleware(Store<AppState> store, action, NextDispatcher next) {
    print("[(main) Redux action]: $action");
    next(action);
}