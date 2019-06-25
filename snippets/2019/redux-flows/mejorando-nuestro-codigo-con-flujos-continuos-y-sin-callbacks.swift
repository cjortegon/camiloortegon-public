Store.dispatch(AuthAction.showLoginRegisterFlow)

pingEpic = action$ => action$.pipe(
    filter(action => action.type === 'PING'),
    mapTo({ type: 'PONG' })
)

LoginRegisterOperation()
.execute( status => {
    if status == .ok {
        CheckoutOperation()
        .execute()
    } else {
        showAlertError()
    }
}

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
