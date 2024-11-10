// menu2Delegate.mc
// This code is from Class: Toybox::WatchUi::Menu2InputDelegate API reference
using Toybox.WatchUi;
using Toybox.System;
using Toybox.Application;

class AbsTimerPausedMenuDelegate extends WatchUi.Menu2InputDelegate {
	hidden var _callback;
    
    function initialize(callback) {
		WatchUi.Menu2InputDelegate.initialize();
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
    }
    
}