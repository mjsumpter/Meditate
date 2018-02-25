using Toybox.WatchUi as Ui;
using Toybox.Graphics as Gfx;

class AddEditSessionMenuDelegate extends Ui.MenuInputDelegate {
    private var mOnChangeSession;
    private var mIntervalAlerts;
    
    function initialize(intervalAlerts, onChangeSession) {
        MenuInputDelegate.initialize();
        me.mIntervalAlerts = intervalAlerts;
        me.mOnChangeSession = onChangeSession;
    }
	
	private function createHmmTimeLayoutBuilder() {
		var digitsLayout = new DigitsLayoutBuilder(Gfx.FONT_TINY);
		digitsLayout.setOutputXOffset(85);
		digitsLayout.addInitialHint("Pick H:MM");
		digitsLayout.addDigit({:minValue=>0, :maxValue=>9});
		digitsLayout.addSeparator("h");
		digitsLayout.addDigit({:minValue=>0, :maxValue=>5});
		digitsLayout.addDigit({:minValue=>0, :maxValue=>9});
		digitsLayout.addSeparator("m");
		return digitsLayout;
	}	
			
    function onMenuItem(item) {
        if (item == :time) {
        	var durationPickerModel = new DurationPickerModel(3);
        	var hMmTimeLayoutBuilder = createHmmTimeLayoutBuilder();
    		Ui.pushView(new DurationPickerView(durationPickerModel, hMmTimeLayoutBuilder), new DurationPickerDelegate(durationPickerModel, method(:onHmmDigitsPicked)), Ui.SLIDE_LEFT);   	
        }
        else if (item == :color) {
	        var colors = [Gfx.COLOR_DK_BLUE, Gfx.COLOR_DK_RED, Gfx.COLOR_DK_GREEN, Gfx.COLOR_DK_GRAY, Gfx.COLOR_BLUE, Gfx.COLOR_RED, Gfx.COLOR_YELLOW, Gfx.COLOR_ORANGE, Gfx.COLOR_GREEN, Gfx.COLOR_LT_GRAY, Gfx.COLOR_PINK, Gfx.COLOR_PURPLE, Gfx.COLOR_WHITE];
	        
	        Ui.pushView(new ColorPickerView(colors[0]), new ColorPickerDelegate(colors, method(:onColorSelected)), Ui.SLIDE_LEFT);  
        }
        else if (item == :vibePattern) {
	    	var vibePatternMenuDelegate = new VibePatternMenuDelegate(method(:onVibePatternPicked));
        	Ui.pushView(new Rez.Menus.vibePatternMenu(), vibePatternMenuDelegate, Ui.SLIDE_LEFT);        	
        }
        else if (item == :intervalAlerts) {
        	var intervalAlertsMenuDelegate = new IntervalAlertsMenuDelegate(me.mIntervalAlerts, method(:onIntervalAlertsChanged));
        	var intervalAlertSettingsMenu = new Rez.Menus.intervalAlertSettingsMenu();
        	if (me.mIntervalAlerts.count() > 0) {
	        	var editName = Ui.loadResource(Rez.Strings.menuIntervalAlertSettings_edit);
	        	intervalAlertSettingsMenu.addItem(editName, :edit);
	        	var deleteAllName = Ui.loadResource(Rez.Strings.menuIntervalAlertSettings_deleteAll);
	        	intervalAlertSettingsMenu.addItem(deleteAllName, :deleteAll);
        	}
        	Ui.pushView(intervalAlertSettingsMenu, intervalAlertsMenuDelegate, Ui.SLIDE_LEFT);
        }
    }
    
    private function onIntervalAlertsChanged(intervalAlerts) {
    	var sessionModel = new SessionModel();
    	sessionModel.intervalAlerts = intervalAlerts;
		me.mOnChangeSession.invoke(sessionModel);	
    }
    
    private function onVibePatternPicked(vibePattern) {
    	var sessionModel = new SessionModel();
    	sessionModel.vibePattern = vibePattern;
		me.mOnChangeSession.invoke(sessionModel);	
		Vibe.vibrate(vibePattern);
    }
	    
    function onHmmDigitsPicked(digits) {    
		var sessionModel = new SessionModel();
		var durationMins = digits[0] * 60 + digits[1] * 10 + digits[2];
    	sessionModel.time = durationMins * 60;
    	me.mOnChangeSession.invoke(sessionModel);	
    }
    
    function onColorSelected(color) {
    	var sessionModel = new SessionModel();
    	sessionModel.color = color;
		me.mOnChangeSession.invoke(sessionModel);	
    }
}