using Toybox.WatchUi as Ui;
using Toybox.System as sys;
using Toybox.Application as App;

class AbsTimerDelegate extends Ui.BehaviorDelegate {
	var menu;
	var settingsValid = true;
    function initialize(valid) {
    	settingsValid = valid;
        BehaviorDelegate.initialize();
        updateMenu();
    }

    function onMenu() {
    	//updateMenu();
        Ui.pushView( menu, new AbsTimerMenuDelegate(), Ui.SLIDE_IMMEDIATE );
		//sys.println ("Menu pressed");
		return true;
    }
    function updateMenu() {
    	if (settingsValid) {
    	var labelsArr = getLabels();
        var n = labelsArr.size();
        menu = new Rez.Menus.MainMenu();
        menu.deleteItem(0);
        menu.deleteItem(0);
        menu.deleteItem(0);
        for (var i = 0; i < n; ++i) {
        var menuItem = new Ui.MenuItem(labelsArr[i], null, i, null);
        
			menu.addItem(menuItem);
			System.println("adding " + labelsArr[i]);
		}
		} else {
		menu = new Rez.Menus.MainMenu();
		menu.deleteItem(0);
        menu.deleteItem(0);
        menu.deleteItem(0);
        var menuItem = new Ui.MenuItem("Configuration Error", null, "0", null);
		menu.addItem(menuItem);
		}
	}
    
    function getLabels() {
    	var str = App.getApp().getProperty("label_1") + "," + App.getApp().getProperty("label_2") + "," + App.getApp().getProperty("label_3");
    	//var str = App.getApp().getProperty("routine_labels");
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
		System.println(toReturn);
		return toReturn;
    }

}