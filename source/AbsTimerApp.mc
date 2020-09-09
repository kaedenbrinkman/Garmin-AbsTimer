using Toybox.Application;
using Toybox.WatchUi;

class AbsTimerApp extends Application.AppBase {

	var settingsValid = true;
	var numberOfRoutines = -1;
    function initialize() {
        AppBase.initialize();
        Application.getApp().setProperty("settingsValid", true);
        checkSettings();
    }

    // onStart() is called on application start up
    function onStart(state) {
    }

    // onStop() is called when your application is exiting
    function onStop(state) {
    }

    // Return the initial view of your application here
    function getInitialView() {
        return [ new AbsTimerView(settingsValid), new AbsTimerDelegate(settingsValid) ];
    }
    
    function onSettingsChanged() {
            checkSettings();
            WatchUi.requestUpdate();
    }
    
    function checkSettings() {
    	settingsValid = true;
    	var label_1 = Application.getApp().getProperty("label_1");
    	var label_2 = Application.getApp().getProperty("label_2");
    	var label_3 = Application.getApp().getProperty("label_3");
    	var names_1 = Application.getApp().getProperty("names_1");
    	var names_2 = Application.getApp().getProperty("names_2");
    	var names_3 = Application.getApp().getProperty("names_3");
    	var times_1 = Application.getApp().getProperty("times_1");
    	var times_2 = Application.getApp().getProperty("times_2");
    	var times_3 = Application.getApp().getProperty("times_3");
    	
    	var labelsStr = label_1 + "," + label_2 + "," + label_3;
    	var namesStr = "[" + names_1 + "][" + names_2 + "][" + names_3 + "]";
    	var timesStr = "[" + times_1 + "][" + times_2 + "][" + times_3 + "]";
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
    str = str.toCharArray();
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
        }
    }
function checkArrFromStr2D(str, type) {
    str = str.toCharArray();
    if (str[0] != '[') {
settingsValid = false;
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
        }
    }

}
