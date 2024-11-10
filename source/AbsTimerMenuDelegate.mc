// menu2Delegate.mc
// This code is from Class: Toybox::WatchUi::Menu2InputDelegate API reference
using Toybox.WatchUi;
using Toybox.System;
using Toybox.Application;
using Toybox.Application.Storage;

class AbsTimerMenuDelegate extends WatchUi.Menu2InputDelegate {
    function initialize() {
        Menu2InputDelegate.initialize();
    }

    function onSelect(item) {
        //System.println(item.getId());
        Storage.setValue("abs", item.getId());
        //System.println(Storage.getValue("abs"));
        onBack();
    }
    
    function onMenuItem(item) {
    	System.println(item);
    	//Storage.setValue("abs", item.getId().toNumber());
    }
    
}