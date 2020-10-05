// menu2Delegate.mc
// This code is from Class: Toybox::WatchUi::Menu2InputDelegate API reference
using Toybox.WatchUi;
using Toybox.System;
using Toybox.Application;

class AbsTimerMenuDelegate extends WatchUi.Menu2InputDelegate {
    function initialize() {
        Menu2InputDelegate.initialize();
        
    }

    function onSelect(item) {
        //System.println(item.getId());
        Application.getApp().setProperty("abs", item.getId().toNumber());
        //System.println(Application.getApp().getProperty("abs"));
        onBack();
    }
    
    function onMenuItem(item) {
    	System.println(item);
    	//Application.getApp().setProperty("abs", item.getId().toNumber());
    }
    
}