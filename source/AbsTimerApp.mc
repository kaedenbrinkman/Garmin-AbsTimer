using Toybox.Application;
using Toybox.WatchUi;

class AbsTimerApp extends Application.AppBase {

	var settingsValid = true;
	var view = null;
    function initialize() {
        AppBase.initialize();
        Storage.setValue("settingsValid", true);
        checkSettings();
        view = new AbsTimerView(settingsValid);
    }

    // onStart() is called on application start up
    function onStart(state) {
    }

    // onStop() is called when your application is exiting
    function onStop(state) {
    }

    // Return the initial view of your application here
    function getInitialView() {
        return [ view, new AbsTimerDelegate(settingsValid, view) ];
    }
    
    function onSettingsChanged() {
            checkSettings();
            WatchUi.requestUpdate();
    }
    
    function checkSettings() {
    	settingsValid = true;
    	
    	//Check settings here
    	
        System.println(settingsValid);
        Storage.setValue("settingsValid", settingsValid);
    }

}