// menu2Delegate.mc
// This code is from Class: Toybox::WatchUi::Menu2InputDelegate API reference
using Toybox.WatchUi;
using Toybox.System;
using Toybox.Application;

class AbsTimerPausedMenuDelegate extends WatchUi.MenuInputDelegate {
	hidden var _callback;
    
    function initialize(callback) {
		MenuInputDelegate.initialize();
		_callback = callback;
	}

    function onSelect(item) {
        onBack();
    }
    
    function onMenuItem(item) {
    	var result = 0;
    	if (item == :p_save) {
    		result = 1;
    	} else if (item == :p_discard) {
    		result = 2;
    	}
    	_callback.invoke(result);
		return true;
    	//System.println(item);
    	//app.setProperty("abs", item.getId().toNumber());
    }
    
}