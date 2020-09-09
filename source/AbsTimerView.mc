using Toybox.WatchUi;
using Toybox.Graphics;
using Toybox.Timer;
using Toybox.Attention;
using Toybox.Application.Storage;
using Toybox.Application.Properties;
// Storage.getValue("abs")

var timer1;
var count1 = 0;

var absType;

var done;

var exercize;




var names = [];
var times = [];
var settingsValid = true;

class AbsTimerView extends WatchUi.View {

    function initialize(valid) {
    	settingsValid = valid;
        WatchUi.View.initialize();
        if (settingsValid) {
        var namesStr = Application.getApp().getProperty("routine_names");
        var labelsStr = Application.getApp().getProperty("routine_labels");
        var timesStr = Application.getApp().getProperty("routine_times");
        
        //Get an array from the string
        names = getArrFromStr2D(namesStr, "str");
        var labelsArr = getArrFromStr1D(labelsStr, "str");
        times = getArrFromStr2D(timesStr, "int");
        //System.println(namesArr);
        //System.println(labelsArr);
        //System.println(timesArr);
        }

    }
    
    function callback1() {
    	if (settingsValid) {
    		count1 += 1;
    		//if one second away, wake screen.
    		if (Attention has :backlight && count1 == (times[absType][exercize].toNumber() - 1)) {
    			Attention.backlight(true);
			}
		}
    	WatchUi.requestUpdate();
    }
    
    function restart() {  	
    	count1 = 0;
    	exercize = 0;
    	done = false;
    }

    // Load your resources here
    function onLayout(dc) {
        timer1 = new Timer.Timer();
        timer1.start(method(:callback1), 1000, true);
        absType = 0;
        exercize = 0;
        done = false;
        
    }

    // Called when this View is brought to the foreground. Restore
    // the state of this View and prepare it to be shown. This includes
    // loading resources into memory.
    function onShow() {
    }

    // Update the view
    function onUpdate(dc) {
    if (settingsValid) {
    	if (absType != null && Application.getApp().getProperty("abs") != null && absType != Application.getApp().getProperty("abs") && Application.getApp().getProperty("abs") >= 0 && Application.getApp().getProperty("abs") < names.size()) {
    		absType = Application.getApp().getProperty("abs");	//Storage.getValue("abs");
    		restart();
    		//System.println("NEW ABTYPE DETECTED: " + absType);
    	}
    	
    	var numSecs = (times[absType][exercize]).toNumber();
    	//System.println(numSecs);
    	if (exercize >= times[absType].size() || exercize >= names[absType].size()) {
    		done = true;
    		//System.println("Finished!");
    		timer1.stop();
    		exercize = 0;
    		count1 = 0;
    	} else if (count1 >= numSecs) {
    		exercize += 1;
    		count1 = 0;
    		if (Attention has :playTone) {
   				Attention.playTone(Attention.TONE_LAP);
			}
			if (Attention has :vibrate) {
    			var vibeData =
   				 [
        			new Attention.VibeProfile(50, 500), // On for half a second
    			];
    			Attention.vibrate(vibeData);
			}
    	}
    	var string;
    	
        dc.setColor(Graphics.COLOR_BLACK, Graphics.COLOR_BLACK);
        dc.clear();
        dc.setColor(Graphics.COLOR_WHITE, Graphics.COLOR_TRANSPARENT);
        if (exercize < times[absType].size() && exercize < names[absType].size()) {
        	string = "" + names[absType][exercize] + "\n" + (numSecs - count1);
        } else {
        	string = "Complete!";
        }
        dc.drawText(dc.getWidth() / 2, (dc.getHeight() / 2) - 30, Graphics.FONT_MEDIUM, string, Graphics.TEXT_JUSTIFY_CENTER);
        } else {
        	dc.setColor(Graphics.COLOR_BLACK, Graphics.COLOR_BLACK);
        	dc.clear();
        	dc.setColor(Graphics.COLOR_WHITE, Graphics.COLOR_TRANSPARENT);
        	var string = "Config. Error\nCheck settings in app";
        	dc.drawText(dc.getWidth() / 2, (dc.getHeight() / 2) - 30, Graphics.FONT_SMALL, string, Graphics.TEXT_JUSTIFY_CENTER);
        }
    }

    // Called when this View is removed from the screen. Save the
    // state of this View here. This includes freeing resources from
    // memory.
    function onHide() {
    }
    
    function getArrFromStr1D(str, type) {
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
		//System.println(toReturn);
		return toReturn;
    }
function getArrFromStr2D(str, type) {
    str = str.toCharArray();
    var toReturn = [];
        var temp = "";
        for (var i = 0; i < str.size(); i++) {
        if (str[i] != '[' && str[i] != ']') {
        	temp += str[i];
        }
        if (str[i] == ']' || i == (str.size() - 1)) {
        toReturn.add(getArrFromStr1D(temp, type));
        temp = "";
        }
        
        }
		//System.println(toReturn);
		return toReturn;
    }

}
