using Toybox.WatchUi;
using Toybox.System;
using Toybox.Application.Storage;
//Storage.setValue("abs", 2);

class AbsTimerMenuDelegate extends WatchUi.MenuInputDelegate {

    function initialize() {
        MenuInputDelegate.initialize();
    }

    function onMenuItem(item) {
        if (item == :item_1) {
            //Select FABS
            Application.getApp().setProperty("abs", 0);
        } else if (item == :item_2) {
            //Select TABS
            Application.getApp().setProperty("abs", 1);
        } else if (item == :item_3) {
            //Select PLABS
            Application.getApp().setProperty("abs", 2);
        }
    }

}