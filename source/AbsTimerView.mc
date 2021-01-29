using Toybox.WatchUi;
using Toybox.Graphics;
using Toybox.Timer;
using Toybox.Attention;
using Toybox.Application.Storage;
using Toybox.Application.Properties;
using Toybox.ActivityRecording;
// Storage.getValue("abs")

var timer1;
var count1 = 0;

var absType;

var done;

var exercize;
var running = false;


var names = [];
var times = [];
var settingsValid = true;
var session = null;

class AbsTimerView extends WatchUi.View {

    function initialize(valid) {
    	absType = 0;
    	settingsValid = valid;
        WatchUi.View.initialize();
        System.println(Application.getApp().getProperty("abs"));
        names = getArrFromStr1D(Application.getApp().getProperty("names_" + (absType + 1)));
	    times = getArrFromStr1D(Application.getApp().getProperty("times_" + (absType + 1)));
	    
    }
    
    function callback1() {
    	if (settingsValid) {
    		count1 += 1;
    		//if one second away, wake screen. Mainly for venu, as "no backlight" = screen is off.
    		if (Attention has :backlight && Application.getApp().getProperty("display_wake_enabled") && (exercize >= times.size() || count1 == (times[exercize].toNumber() - 1))) {
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
    if (exercize >= times.size()) {
    	reset();
    	save();
    }
    if (settingsValid) {
    	if (absType != null && Application.getApp().getProperty("abs") != null && absType != Application.getApp().getProperty("abs") && Application.getApp().getProperty("abs") >= 0 && Application.getApp().getProperty("abs") < names.size()) {
    		absType = Application.getApp().getProperty("abs");	//Storage.getValue("abs");
    		restart();
    		System.println("NEW ABTYPE DETECTED: " + absType);
    		names = getArrFromStr1D(Application.getApp().getProperty("names_" + (absType + 1)));
	        times = getArrFromStr1D(Application.getApp().getProperty("times_" + (absType + 1)));
    	}
    	
    	var numSecs = (times[exercize]).toNumber();
    	//System.println(numSecs);
    	if (exercize >= times.size() || exercize >= names.size()) {
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
        if (exercize < times.size() && exercize < names.size()) {
        	string = "" + names[exercize] + "\n" + (numSecs - count1);
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
    
    function getArrFromStr1D(str) {
    	str = str.toCharArray();
    	var toReturn = [];
        var temp = "";
        for (var i = 0; i < str.size(); i++) {
	        if (str[i] != ',') {
	        	temp += str[i];
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
    if (Toybox has :ActivityRecording && Application.getApp().getProperty("activity_recording_enabled")) {                          // check device for activity recording
    var label = Application.getApp().getProperty("label_" + (absType + 1));
    var activityType = Application.getApp().getProperty("type_" + (absType + 1));
    if (label == null) {
    	label = "Abs";
    }
    if (activityType == 0) {
    	activityType = ActivityRecording.SUB_SPORT_STRENGTH_TRAINING;
    } else {
        activityType = ActivityRecording.SUB_SPORT_FLEXIBILITY_TRAINING;
    }
       if ((session == null)) {
           session = ActivityRecording.createSession({          // set up recording session
                 :name=>label,                              // set session name
                 :sport=>ActivityRecording.SPORT_TRAINING,       // set sport type
                 :subSport=>activityType // set sub sport type
           });
           session.start();                                     // call start session
       } else if (session.isRecording() == false) {
       session.start();  
       }
       else if ((session != null) && session.isRecording()) {
           session.stop();                                      // stop the session
           //session.save();                                      // save the session
           //session = null;                                      // set session control variable to null
       }
   }
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
    
    function save() {
    	if (Toybox has :ActivityRecording && (session != null) && session.isRecording()) {                          // check device for activity recording
           session.stop();                                      // stop the session
           session.save();                                      // save the session
           session = null;                                      // set session control variable to null
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