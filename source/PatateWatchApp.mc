import Toybox.Application;
import Toybox.Lang;
import Toybox.WatchUi;

// Useful tutorial: https://medium.com/@ericbt/design-your-own-garmin-watch-face-21d004d38f99
// Toybox from official documentation: https://developer.garmin.com/connect-iq/api-docs/index.html

class PatateWatchApp extends Application.AppBase {

    function initialize() {
        AppBase.initialize();
    }

    // onStart() is called on application start up
    function onStart(state as Dictionary?) as Void {
    }

    // onStop() is called when your application is exiting
    function onStop(state as Dictionary?) as Void {
    }

    // Return the initial view of your application here
    function getInitialView() as [Views] or [Views, InputDelegates] {
        return [ new PatateWatchView() ];
    }

    // New app settings have been received so trigger a UI update
    function onSettingsChanged() as Void {
        WatchUi.requestUpdate();
    }

}

function getApp() as PatateWatchApp {
    return Application.getApp() as PatateWatchApp;
}