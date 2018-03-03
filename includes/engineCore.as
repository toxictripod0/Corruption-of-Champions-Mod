import classes.*;
import flash.text.TextFormat;

import coc.view.CoCButton;

// at least one import or other usage of *class* so it won't be marked unused.
import classes.internals.Profiling;
import classes.internals.profiling.Begin;
import classes.internals.profiling.End;


////////////	GUI CODE	////////////
public static const MAX_BUTTON_INDEX:int = 14;

/**
 * Clears all button and adds a 'Next' button.
 * @param	event The event function to call if the button is pressed.
 */
public function doNext(event:Function):void { //Now typesafe
	//Prevent new events in combat from automatically overwriting a game over. 
	if (mainView.getButtonText(0).indexOf("Game Over") != -1) {
		//trace("Do next setup cancelled by game over");
		return;
	}
	output.menu();
	output.addButton(0, "Next", event);
}

public function invertGo():void{ 
	mainView.invert();
}

/**
 * Used to update the display of statistics
 */
public function statScreenRefresh():void {
	mainView.statsView.show(); // show() method refreshes.
	mainViewManager.refreshStats();
}
/**
 * Show the stats pane. (Name, stats and attributes)
 */
public function showStats():void {
	mainView.statsView.show();
	mainViewManager.refreshStats();
	mainViewManager.tweenInStats();
}
/**
 * Hide the stats pane. (Name, stats and attributes)
 */
public function hideStats():void {
	if (!mainViewManager.buttonsTweened) mainView.statsView.hide();
	mainViewManager.tweenOutStats();
}

/**
 * Hide the top buttons.
 */
public function hideMenus():void {
	mainView.hideAllMenuButtons();
}

/**
 * Hides the up/down arrow on stats pane.
 */
public function hideUpDown():void {
	mainView.statsView.hideUpDown();
	//Clear storage values so up/down arrows can be properly displayed
	oldStats.oldStr = 0;
	oldStats.oldTou = 0;
	oldStats.oldSpe = 0;
	oldStats.oldInte = 0;
	oldStats.oldLib = 0;
	oldStats.oldSens = 0;
	oldStats.oldCor = 0;  
	oldStats.oldHP = 0;
	oldStats.oldLust = 0;
	oldStats.oldFatigue = 0;
	oldStats.oldHunger = 0;
}

////////////	GUI CODE	////////////


public function silly():Boolean {
	return flags[kFLAGS.SILLY_MODE_ENABLE_FLAG] == 1;
}

public function clone(source:Object):* {
	var copier:ByteArray = new ByteArray();
	copier.writeObject(source);
	copier.position = 0;
	return(copier.readObject());
}

// Hah, finally a place where a dictionary is actually required!
import flash.utils.Dictionary;
private var funcLookups:Dictionary = null;

private function buildFuncLookupDict(object:*=null,prefix:String=""):void
{
	import flash.utils.*;
	//trace("Building function <-> function name mapping table for "+((object==null)?"CoC.":prefix));
	// get all methods contained
	if (object == null) object = this;
	var typeDesc:XML = describeType(object);
	//trace("TypeDesc - ", typeDesc)

	for each (var node:XML in typeDesc..method) 
	{
		// return the method name if the thisObject of f (t) 
		// has a property by that name 
		// that is not null (null = doesn't exist) and 
		// is strictly equal to the function we search the name of
		//trace("this[node.@name] = ", this[node.@name], " node.@name = ", node.@name)
		if (object[node.@name] != null)
			this.funcLookups[object[node.@name]] = prefix+node.@name;
	}
	for each (node in typeDesc..variable)
	{
		if (node.@type.toString().indexOf("classes.Scenes.") == 0 ||
				node.metadata.@name.contains("Scene")){
			if (object[node.@name]!=null){
				buildFuncLookupDict(object[node.@name],node.@name+".");
			}
		}
	}
}

public function getFunctionName(f:Function):String
{
	// trace("Getting function name")
	// get the object that contains the function (this of f)
	//var t:Object = flash.sampler.getSavedThis(f); 
	if (this.funcLookups == null)
	{
		//trace("Rebuilding lookup object");
		this.funcLookups = new Dictionary();
		this.buildFuncLookupDict();
	}


	if (f in this.funcLookups)
		return(this.funcLookups[f]);
	
	// if we arrive here, we haven't found anything... 
	// maybe the function is declared in the private namespace?
	return null;
}


private function logFunctionInfo(func:Function, arg:* = null, arg2:* = null, arg3:* = null):void
{
	var logStr:String = "";
	if (arg is Function)
	{
		logStr += "Calling = " + getFunctionName(func) + " Param = " +  getFunctionName(arg);
	}
	else
	{
		logStr += "Calling = " + getFunctionName(func) + " Param = " +  arg;
	}
	//CoC_Settings.appendButtonEvent(logStr);
	//trace(logStr); 9999
}


// returns a function that takes no arguments, and executes function `func` with argument `arg`
public function createCallBackFunction(func:Function, arg:*, arg2:* = null, arg3:* = null):Function
{
	if (func == null) {
		CoC_Settings.error("createCallBackFunction(null," + arg + ")");
	}
	if ( arg == -9000 || arg == null )
	{
/*		if (func == eventParser){
			CoC_Settings.error("createCallBackFunction(eventParser,"+arg+")");
		} */
		return function ():*
		{ 
			if (CoC_Settings.haltOnErrors) 
				logFunctionInfo(func, arg);
			return func(); 
		};
	}
	else
	{
		if (arg2 == -9000 || arg2 == null)
		{
			return function ():*
			{ 
				if (CoC_Settings.haltOnErrors) 
					logFunctionInfo(func, arg);
				return func( arg ); 
			};
		}
		else 
		{
			if (arg3 == -9000 || arg3 == null)
			{
				return function ():*
				{ 
					if (CoC_Settings.haltOnErrors) 
						logFunctionInfo(func, arg, arg2);
					return func(arg, arg2); 
				};
			}
			else 
			{
				return function ():*
				{ 
					if (CoC_Settings.haltOnErrors) 
						logFunctionInfo(func, arg, arg2, arg3);
					return func(arg, arg2, arg3); 
				};
			}
		}
	}
}

public function openURL(url:String):void
{
    navigateToURL(new URLRequest(url), "_blank");
}

/**
 * Awards the achievement. Will display a blue text if achievement hasn't been earned.
 * @param	title The name of the achievement.
 * @param	achievement The achievement to be awarded.
 * @param	display Determines if achievement earned should be displayed.
 * @param	nl Inserts a new line before the achievement text.
 * @param	nl2 Inserts a new line after the achievement text.
 */
public function awardAchievement(title:String, achievement:int, display:Boolean = true, nl:Boolean = false, nl2:Boolean = true):void {
	if (achievements[achievement] != null) {
		if (achievements[achievement] <= 0) {
			achievements[achievement] = 1;
			if (nl && display) outputText("\n");
			if (display) outputText("<font color=\"#000080\"><b>Achievement unlocked: " + title + "</b></font>");
			if (nl2 && display) outputText("\n");
			kGAMECLASS.saves.savePermObject(false); //Only save if the achievement hasn't been previously awarded.
		}
	}
	else outputText("\n<b>ERROR: Invalid achievement!</b>");
}


public function testDynStatsEvent():void {
	clearOutput();
	outputText("Old: "+player.str+" "+player.tou+" "+player.spe+" "+player.inte+" "+player.lib+" "+player.sens+" "+player.lust+"\n");
	player.dynStats("tou", 1, "spe+", 2, "int-", 3, "lib*", 2, "sen=", 25,"lust/",2);
	outputText("Mod: 0 1 +2 -3 *2 =25 /2\n");
	outputText("New: "+player.str+" "+player.tou+" "+player.spe+" "+player.inte+" "+player.lib+" "+player.sens+" "+player.lust+"\n");
	doNext(playerMenu);
}

/**
 * Modify stats.
 *
 * Arguments should come in pairs nameOp:String, value:Number/Boolean <br/>
 * where nameOp is ( stat_name + [operator] ) and value is operator argument<br/>
 * valid operators are "=" (set), "+", "-", "*", "/", add is default.<br/>
 * valid stat_names are "str", "tou", "spe", "int", "lib", "sen", "lus", "cor" or their full names;
 * also "scaled"/"sca" (default true: apply resistances, perks; false - force values)
 *
 * @return Object of (newStat-oldStat) with keys str, tou, spe, int, lib, sen, lus, cor
 * */
public function dynStats(... args):Object {
	return player.dynStats.apply(player,args);
}

/**
 * Returns true if you're on SFW mode.
 */
public function doSFWloss():Boolean {
	clearOutput();
	if (flags[kFLAGS.SFW_MODE] > 0) {
		if (player.HP <= 0) outputText("You collapse from your injuries.");
		else outputText("You collapse from your overwhelming desires.");
		if (combat.inCombat) combat.cleanupAfterCombat();
		else doNext(camp.returnToCampUseOneHour)
		return true;
	}
	else return false;
}

public function isPeaceful():Boolean {
	return flags[kFLAGS.EASY_MODE_ENABLE_FLAG] <= -2;
}

public function doNothing():void {
	//This literally does nothing.
}
