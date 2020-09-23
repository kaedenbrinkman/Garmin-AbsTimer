using Toybox.Application;
using Toybox.WatchUi;

class AbsTimerApp extends Application.AppBase {

	var settingsValid = true;
	var numberOfRoutines = -1;
	var view = null;
    function initialize() {
        AppBase.initialize();
        Application.getApp().setProperty("settingsValid", true);
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
    	//var view = new AbsTimerView(settingsValid);
    	//view.startOrStopTimer();
        return [ view, new AbsTimerDelegate(settingsValid, view) ];
    }
    
    function onSettingsChanged() {
            checkSettings();
            WatchUi.requestUpdate();
    }
    
    function checkSettings() {
    	settingsValid = true;
    	
    	var labelsStr = Application.getApp().getProperty("routine_labels");
    	var namesStr = Application.getApp().getProperty("routine_names");
    	var timesStr = Application.getApp().getProperty("routine_times");
                System.println(settingsValid);
        
        //Get an array from the string
        
        if(settingsValid) {
        checkArrFromStr1D(labelsStr, "str", true);
        }
                System.println(settingsValid);
        if(settingsValid) {
        checkArrFromStr2D(namesStr, "str");
        }
                System.println(settingsValid);
        
        if(settingsValid) {
        checkArrFromStr2D(timesStr, "int");
        }
        System.println(settingsValid);
        Application.getApp().setProperty("settingsValid", settingsValid);
    }
    
            function checkArrFromStr1D(str, type, isLabel) {
    /*str = str.toCharArray();
    var toReturn = [];
        var temp = "";
        for (var i = 0; i < str.size(); i++) {
        if (str[i] != ',') {
        if (type == "int") {
        	temp += str[i].toNumber();
        	} else {
        	temp += str[i];
        	}
        }
        if (str[i] == ',' || i == (str.size() - 1)) {
        toReturn.add(temp);
        temp = "";
        }
        
        }
        if (isLabel) {
        numberOfRoutines = toReturn.size();
        }*/
    }
	function checkArrFromStr2D(str, type) {/*
	    str = str.toCharArray();
	    if (str[0] != '[') {
			settingsValid = false;
			System.println("er2");
			return;
		}
	    var toReturn = [];
        var temp = "";
        for (var i = 0; i < str.size(); i++) {
	        if (str[i] != '[' && str[i] != ']') {
	        	temp += str[i];
	        }
	        if (str[i] == ']' || i == (str.size() - 1)) {
		        toReturn.add("test");
		        checkArrFromStr1D(temp, type, false);
		        temp = "";
	        }
	    }
	    if (numberOfRoutines != toReturn.size()) {
		    settingsValid = false;
		    System.println("er3: " + numberOfRoutines + ", " + toReturn.size());
	    }*/
    }
}