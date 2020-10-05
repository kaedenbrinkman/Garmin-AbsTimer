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
var running = false;



var numThings = 7;

var names = new [numThings];
var times = new [numThings];
var settingsValid = true;

class AbsTimerView extends WatchUi.View {

    function initialize(valid) {
    	settingsValid = valid;
        WatchUi.View.initialize();
        if (settingsValid) {
	        for (var i = 0; i < numThings; i++) {
	        	names[i] = Application.getApp().getProperty("names_" + (i + 1));
	        	times[i] = Application.getApp().getProperty("times_" + (i + 1));
	        }
        }

    }
    
    function callback1() {
    	if (settingsValid) {
    		count1 += 1;
    		//if one second away, wake screen. Mainly for venu, as "no backlight" = screen is off.
    		if (Attention has :backlight && Application.getApp().getProperty("display_wake_enabled") && (exercize >= times[absType].size() || count1 == (times[absType][exercize].toNumber() - 1))) {
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
        //timer1.start(method(:callback1), 1000, true);
        //running = true;
        absType = 0;
        exercize = 0;
        done = false;
        
    }
    
    function start() {
    	timer1.start(method(:callback1), 1000, true);
    	running = true;
    	playTone(0);
		vibrate(50, 500); // On for half a second
    }
    
    function pause() {
    	timer1.stop();
    	running = false;
    	playTone(1);
		vibrate(50, 500); // On for half a second
    }
    
    function skip() {
    	if(running) {
	    	exercize += 1;
	    	count1 = 0;
	    	playTone(2);
			vibrate(50, 500); // On for half a second
		}
    }
    
    function reset() {
    	timer1.stop();
    	running = false;
    	exercize = 0;
    	count1 = 0;
    }

    // Called when this View is brought to the foreground. Restore
    // the state of this View and prepare it to be shown. This includes
    // loading resources into memory.
    function onShow() {

    }

    // Update the view
    function onUpdate(dc) {
    if (exercize >= times[absType].size()) {
    	reset();
    }
    if (settingsValid) {
    	if (absType != null && Application.getApp().getProperty("abs") != null && absType != Application.getApp().getProperty("abs") && Application.getApp().getProperty("abs") >= 0 && Application.getApp().getProperty("abs") < names.size()) {
    		absType = Application.getApp().getProperty("abs");	//Storage.getValue("abs");
    		restart();
    		System.println("NEW ABTYPE DETECTED: " + absType);
    	}
    	
    	var numSecs = (times[absType][exercize]).toNumber();
    	//System.println(numSecs);
    	if (exercize >= times[absType].size() || exercize >= names[absType].size()) {
    		done = true;
    		//System.println("Finished!");
    		reset();
    	} else if (count1 >= numSecs) {
    		exercize += 1;
    		count1 = 0;
    		playTone(2);
			vibrate(50, 500); // On for half a second
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
    
    function startOrStopTimer() {
	    if(running) {
	    	pause();
	    } else {
	    	start();
	    }
    }
    
    function vibrate(one, two) {
    	if (Attention has :vibrate && Application.getApp().getProperty("vibrate_enabled")) {
    		var vibeData =
   				[
        			new Attention.VibeProfile(one, two),
    			];
    		Attention.vibrate(vibeData);
		}
    }
    
    function playTone(tone) {
    	if (Attention has :playTone && Application.getApp().getProperty("beep_tone_enabled")) {
	    	if (tone == 0) {
	    		Attention.playTone(Attention.TONE_START);
	    	} else if (tone == 1) {
	    		Attention.playTone(Attention.TONE_STOP);
	    	}  else if (tone == 2) {
	    		Attention.playTone(Attention.TONE_LAP);
	    	} else {
	    		System.println("Invalid tone string: " + tone);
	    	}
		}
	}
	
	function toArray(string, splitter, len) {
		var array = new [len]; //Use maximum expected length
		var index = 0;
		var location;
		do
		{
			location = string.find(splitter);
			if (location != null) {
				array[index] = string.substring(0, location);
				string = string.substring(location + 1, string.length());
				index++;
			}
		}
		while (location != null);
			array[index] = string;
			
			var result = new [index];
			for (var i = 0; i < index; i++) {
			result= array;
		}
		return result;
	}

}