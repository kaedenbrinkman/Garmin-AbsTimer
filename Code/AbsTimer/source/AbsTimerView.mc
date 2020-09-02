using Toybox.WatchUi;
using Toybox.Graphics;
using Toybox.Timer;
using Toybox.Attention;
using Toybox.Application.Storage;
// Storage.getValue("abs")

var timer1;
var count1 = 0;

var absType;

var done;

var exercize;

var FABS_NAMES = ["Crunches", "Crossovers", "Crossovers #2", "Jackknives", "Penguins", "Jackknives #2", "Circles", "Circles #2", "Bicycles", "Plank"];
var FABS_TIMES = [30, 30, 30, 30, 30, 30, 30, 30, 30, 60];

var TABS_NAMES = ["Crossovers", "Crossovers #2", "Jackknives", "Side Crunches", "Jackknives #2", "Side Crunches #2", "Penguins", "Russian Twists", "Baby Pushers", "Circles", "Circles #2", "Butt Lifts", "Flutters", "Leg Lifts", "Bicycles", "Side Plank", "Side Plank #2", "Plank"];
var TABS_TIMES = [30, 30, 30, 30, 30, 30, 30, 30, 30, 30, 30, 30, 30, 30, 30, 30, 30, 60];

var PLABS_NAMES = ["Plank", "Side Plank", "Side Plank #2", "High Plank", "Shoulder Taps"];
var PLABS_TIMES = [60, 60, 60, 60, 60];

var names = [FABS_NAMES, TABS_NAMES, PLABS_NAMES];
var times = [FABS_TIMES, TABS_TIMES, PLABS_TIMES];

class AbsTimerView extends WatchUi.View {

    function initialize() {
        WatchUi.View.initialize();
    }
    
    function callback1() {
    	count1 += 1;
    	//if one second away, wake screen.
    	if (Attention has :backlight && count1 == (times[absType][exercize] - 1)) {
    		Attention.backlight(true);
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
    	if (absType != null && Application.getApp().getProperty("abs") != null && absType != Application.getApp().getProperty("abs") && Application.getApp().getProperty("abs") >= 0 && Application.getApp().getProperty("abs") < names.size()) {
    		absType = Application.getApp().getProperty("abs");	//Storage.getValue("abs");
    		restart();
    		//System.println("NEW ABTYPE DETECTED: " + absType);
    	}
    	if (exercize >= times[absType].size() || exercize >= names[absType].size()) {
    		done = true;
    		//System.println("Finished!");
    		timer1.stop();
    		exercize = 0;
    		count1 = 0;
    	} else if (count1 >= times[absType][exercize]) {
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
        	string = "" + names[absType][exercize] + "\n" + (times[absType][exercize] - count1);
        } else {
        	string = "Complete!";
        }
        dc.drawText(dc.getWidth() / 2, (dc.getHeight() / 2) - 30, Graphics.FONT_MEDIUM, string, Graphics.TEXT_JUSTIFY_CENTER);
    }

    // Called when this View is removed from the screen. Save the
    // state of this View here. This includes freeing resources from
    // memory.
    function onHide() {
    }

}
