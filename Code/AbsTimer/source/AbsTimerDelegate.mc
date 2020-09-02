using Toybox.WatchUi;

class AbsTimerDelegate extends WatchUi.BehaviorDelegate {

    function initialize() {
        BehaviorDelegate.initialize();
    }

    function onMenu() {
        WatchUi.pushView(new Rez.Menus.MainMenu(), new AbsTimerMenuDelegate(), WatchUi.SLIDE_UP);
        return true;
    }

}