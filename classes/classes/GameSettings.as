package classes
{
	import classes.GlobalFlags.*;
	import classes.display.SettingPane;
	import coc.view.MainView;
	import coc.view.StatsView;
	import flash.display.StageQuality;
	import flash.text.TextField;
	import flash.text.TextFormat;
	/**
	 * ...
	 * @author ...
	 */
	public class GameSettings extends BaseContent
	{
		private var lastDisplayedPane:SettingPane;
		private var initializedPanes:Boolean = false;
		
		private var fetishSettingPane:SettingPane;
		private var gameplaySettingPane:SettingPane;
		private var interfaceSettingPane:SettingPane;
		private static const PANE_NAME_FETISH:String = "settingPaneFetish";
		private static const PANE_NAME_GAMEPLAY:String = "settingPaneGameplay";
		private static const PANE_NAME_INTERFACE:String = "settingPaneInterface";
		
		public function GameSettings() {}

		public function configurePanes():void {
			var pane:SettingPane;
			//Gameplay Settings
			pane = new SettingPane(getGame().mainView.mainText.x, getGame().mainView.mainText.y, getGame().mainView.mainText.width + 16, getGame().mainView.mainText.height);
			pane.name = PANE_NAME_GAMEPLAY;
			var hlg:TextField = pane.addHelpLabel();
			hlg.htmlText = kGAMECLASS.formatHeader("Gameplay Settings");
			hlg.htmlText += "You can adjust gameplay experience such as game difficulty and NPC standards.\n\n";
			pane.addToggleSettings("Game Difficulty", [
				["Choose", difficultySelectionMenu, "", false]
			]);
			pane.addToggleSettings("Debug Mode", [
				["ON", createCallBackFunction(toggleDebug, true), "Items will not be consumed by use, fleeing always succeeds, and bad-ends can be ignored.", debug == true],
				["OFF", createCallBackFunction(toggleDebug, false), "Items consumption will occur as normal.", debug == false]
			]);
			pane.addToggleSettings("Silly Mode", [
				["ON", createCallBackFunction(toggleSetting, kFLAGS.SILLY_MODE_ENABLE_FLAG, true), "Crazy, nonsensical, and possibly hilarious things may occur.", flags[kFLAGS.SILLY_MODE_ENABLE_FLAG] == true],
				["OFF", createCallBackFunction(toggleSetting, kFLAGS.SILLY_MODE_ENABLE_FLAG, false), "You're an incorrigible stick-in-the-mud with no sense of humor.", flags[kFLAGS.SILLY_MODE_ENABLE_FLAG] == false]
			]);
			pane.addToggleSettings("Low Standards", [
				["ON", createCallBackFunction(toggleSetting, kFLAGS.SILLY_MODE_ENABLE_FLAG, true), "NPCs ignore body type preferences. (Not gender preferences though. You still need the right hole.)", flags[kFLAGS.LOW_STANDARDS_FOR_ALL] == true],
				["OFF", createCallBackFunction(toggleSetting, kFLAGS.SILLY_MODE_ENABLE_FLAG, false), "NPCs have body-type preferences.", flags[kFLAGS.LOW_STANDARDS_FOR_ALL] == false]
			]);
			pane.addToggleSettings("Hyper Happy", [
				["ON", createCallBackFunction(toggleSetting, kFLAGS.HYPER_HAPPY, true), "Only reducto and humus shrink endowments. Incubus draft doesn't affect breasts, and succubi milk doesn't affect cocks.", flags[kFLAGS.HYPER_HAPPY] == true],
				["OFF", createCallBackFunction(toggleSetting, kFLAGS.HYPER_HAPPY, false), "Male enhancement potions shrink female endowments, and vice versa.", flags[kFLAGS.HYPER_HAPPY] == false]
			]);
			pane.addToggleSettings("Automatic Leveling", [
				["ON", createCallBackFunction(toggleSetting, kFLAGS.AUTO_LEVEL, true), "Leveling up is done automatically once you accumulate enough experience.", flags[kFLAGS.AUTO_LEVEL] == true],
				["OFF", createCallBackFunction(toggleSetting, kFLAGS.AUTO_LEVEL, false), "Leveling up is done manually by pressing 'Level Up' button.", flags[kFLAGS.AUTO_LEVEL] == false]
			]);
			pane.addToggleSettings("SFW Mode", [
				["ON", createCallBackFunction(toggleSetting, kFLAGS.SFW_MODE, true), "SFW mode is enabled. You won't see sex scenes. (Though some explicit scenes might slip by, this will slowly be resolved.)", flags[kFLAGS.SFW_MODE] == true],
				["OFF", createCallBackFunction(toggleSetting, kFLAGS.SFW_MODE, false), "SFW mode is disabled. You'll see sex scenes.", flags[kFLAGS.SFW_MODE] == false]
			]);
			pane.addToggleSettings("Prison", [
				["ON", createCallBackFunction(toggleSetting, kFLAGS.PRISON_ENABLED, true), "The prison can be accessed. WARNING: The prison is very buggy and may break your game. Enter it at your own risk!", flags[kFLAGS.PRISON_ENABLED] == true],
				["OFF", createCallBackFunction(toggleSetting, kFLAGS.PRISON_ENABLED, false), "The prison cannot be accessed.", flags[kFLAGS.PRISON_ENABLED]]
			]);
			pane.addToggleSettings("Enable Survival", [
				["Enable", enableSurvivalPrompt, "Survival mode is already enabled.", flags[kFLAGS.HUNGER_ENABLED] >= 0.5]
			]);
			pane.addToggleSettings("Enable Realistic", [
				["Enable", enableRealisticPrompt, "Realistic mode is already enabled.", flags[kFLAGS.HUNGER_ENABLED] >= 1]
			]);
			gameplaySettingPane = pane;
			//Interface Settings
			pane = new SettingPane(getGame().mainView.mainText.x, getGame().mainView.mainText.y, getGame().mainView.mainText.width + 16, getGame().mainView.mainText.height);
			pane.name = PANE_NAME_INTERFACE;
			var hli:TextField = pane.addHelpLabel();
			hli.htmlText = kGAMECLASS.formatHeader("Interface Settings");
			hli.htmlText += "You can customize some aspects of the interface to your liking.\n\n";
			pane.addToggleSettings("Main Background", [
				["Choose", menuMainBackground, "", false]
			]);
			pane.addToggleSettings("Text Background", [
				["Choose", menuTextBackground, "", false]
			]);
			pane.addToggleSettings("Sidebar Font", [
				["New", createCallBackFunction(toggleSetting, kFLAGS.USE_OLD_FONT, false), "Palatino Linotype will be used. This is the current font.", flags[kFLAGS.USE_OLD_FONT] == false],
				["Old", createCallBackFunction(toggleSetting, kFLAGS.USE_OLD_FONT, true), "Lucida Sans Typewriter will be used. This is the old font.", flags[kFLAGS.USE_OLD_FONT] == true]
			]);
			pane.addToggleSettings("Sprites", [
				["Off", createCallBackFunction(toggleSetting, kFLAGS.SHOW_SPRITES_FLAG, 0), "There are only words. Nothing else.", flags[kFLAGS.SHOW_SPRITES_FLAG] == 0],
				["Old", createCallBackFunction(toggleSetting, kFLAGS.SHOW_SPRITES_FLAG, 1), "You like to look at pretty pictures. Old, 8-bit sprites will be shown.", flags[kFLAGS.SHOW_SPRITES_FLAG] == 1],
				["New", createCallBackFunction(toggleSetting, kFLAGS.SHOW_SPRITES_FLAG, 2), "You like to look at pretty pictures. New, 16-bit sprites will be shown.", flags[kFLAGS.SHOW_SPRITES_FLAG] == 2]
			]);
			pane.addToggleSettings("Image Pack", [
				["ON", createCallBackFunction(toggleSetting, kFLAGS.IMAGEPACK_ENABLED, true), "Image pack is currently enabled.", kFLAGS.IMAGEPACK_ENABLED == true],
				["OFF", createCallBackFunction(toggleSetting, kFLAGS.IMAGEPACK_ENABLED, false), "Images from image pack won't be shown.", kFLAGS.IMAGEPACK_ENABLED == false]
			]);
			pane.addToggleSettings("Time Format", [
				["12-hour", createCallBackFunction(toggleSetting, kFLAGS.USE_12_HOURS, true), "Time will be shown in 12-hour format. (AM/PM)", kFLAGS.USE_12_HOURS == true],
				["24-hour", createCallBackFunction(toggleSetting, kFLAGS.USE_12_HOURS, false), "Time will be shown in 24-hour format.", kFLAGS.USE_12_HOURS == false]
			]);
			pane.addToggleSettings("Measurements", [
				["Metric", createCallBackFunction(toggleSetting, kFLAGS.USE_METRICS, true), "Various measurements will be shown in metrics. (Centimeters, meters)", kFLAGS.USE_METRICS == true],
				["Imperial", createCallBackFunction(toggleSetting, kFLAGS.USE_METRICS, false), "Various measurements will be shown in imperial units. (Inches, feet)", kFLAGS.USE_METRICS == false]
			]);
			pane.addToggleSettings("Quicksave Confirmation", [
				["ON", createCallBackFunction(toggleSetting, kFLAGS.DISABLE_QUICKSAVE_CONFIRM, false), "Quicksave confirmation dialog is enabled.", flags[kFLAGS.DISABLE_QUICKSAVE_CONFIRM] == false],
				["OFF", createCallBackFunction(toggleSetting, kFLAGS.DISABLE_QUICKSAVE_CONFIRM, true), "Quicksave confirmation dialog is disabled.", flags[kFLAGS.DISABLE_QUICKSAVE_CONFIRM] == true]
			]);
			pane.addToggleSettings("Quickload Confirmation", [
				["ON", createCallBackFunction(toggleSetting, kFLAGS.DISABLE_QUICKLOAD_CONFIRM, false), "Quickload confirmation dialog is enabled.", flags[kFLAGS.DISABLE_QUICKLOAD_CONFIRM] == false],
				["OFF", createCallBackFunction(toggleSetting, kFLAGS.DISABLE_QUICKLOAD_CONFIRM, true), "Quickload confirmation dialog is disabled.", flags[kFLAGS.DISABLE_QUICKLOAD_CONFIRM] == true]
			]);
			interfaceSettingPane = pane;
			//Fetish Settings
			pane = new SettingPane(getGame().mainView.mainText.x, getGame().mainView.mainText.y, getGame().mainView.mainText.width + 16, getGame().mainView.mainText.height);
			pane.name = PANE_NAME_FETISH;
			var hlf:TextField = pane.addHelpLabel();
			hlf.htmlText = kGAMECLASS.formatHeader("Fetish Settings");
			hlf.htmlText += "You can turn on or off weird and extreme fetishes.\n\n";
			pane.addToggleSettings("Watersports (Urine)", [
				["ON", createCallBackFunction(toggleSetting, kFLAGS.WATERSPORTS_ENABLED, true), "Watersports are enabled. You kinky person.", flags[kFLAGS.WATERSPORTS_ENABLED] == true],
				["OFF", createCallBackFunction(toggleSetting, kFLAGS.WATERSPORTS_ENABLED, false), "You won't see watersports scenes.", flags[kFLAGS.WATERSPORTS_ENABLED] == false]
			]);
			pane.addToggleSettings("Worms", [
				["ON", createCallBackFunction(setWorms, true, false), "You have chosen to encounter worms as you find the mountains.", player.hasStatusEffect(StatusEffects.WormsOn) && !player.hasStatusEffect(StatusEffects.WormsHalf)],
				["ON (Half)", createCallBackFunction(setWorms, true, true), "You have chosen to encounter worms as you find the mountains, albeit at reduced rate.", player.hasStatusEffect(StatusEffects.WormsHalf)],
				["OFF", createCallBackFunction(setWorms, false, false), "You have chosen not to encounter worms.", player.hasStatusEffect(StatusEffects.WormsOff)],
				
			]);
			fetishSettingPane = pane;
			//All done!
			initializedPanes = true;
		}
		private function updatePanes():void {
			gameplaySettingPane.updateToggleSettings().update();
			interfaceSettingPane.updateToggleSettings().update();
			fetishSettingPane.updateToggleSettings().update();
		}
		
		public function enterSettings():void {
			kGAMECLASS.saves.savePermObject(false);
			mainView.showMenuButton(MainView.MENU_NEW_MAIN);
			mainView.showMenuButton(MainView.MENU_DATA);
			if (!initializedPanes) configurePanes();
			clearOutput();
			disableHardcoreCheatSettings();
			displaySettingPane(gameplaySettingPane);
			setButtons();
		}
		public function exitSettings():void {
			hideSettingPane();
			getGame().mainMenu.mainMenu();
		}
		
		private function setButtons():void {
			menu();
			addButton(0, "Gameplay", displaySettingPane, gameplaySettingPane);
			addButton(1, "Interface", displaySettingPane, interfaceSettingPane);
			addButton(2, "Fetishes", displaySettingPane, fetishSettingPane);
			addButton(3, "Font Size", fontSettingsMenu);
			addButton(4, "Controls", displayControls);
			addButton(14, "Back", exitSettings);
		}
		
		private function displaySettingPane(pane:SettingPane):void {
			hideSettingPane();
			lastDisplayedPane = pane;
			mainView.mainText.visible = false;
			mainView.addChild(pane);
			pane.update();
			setButtons();
		}
		private function hideSettingPane():void {
			mainView.mainText.visible = true;
			if (mainView.getChildByName(PANE_NAME_GAMEPLAY) || mainView.getChildByName(PANE_NAME_INTERFACE) || mainView.getChildByName(PANE_NAME_FETISH) ) {
				mainView.removeChild(lastDisplayedPane);
			}
		}
		
		//------------
		// GAMEPLAY
		//------------
		private function getDifficultyText():String {
			var text:String
			switch(flags[kFLAGS.GAME_DIFFICULTY]) {
				case 0:
					if (flags[kFLAGS.EASY_MODE_ENABLE_FLAG]) text = "Difficulty: <font color=\"#008000\"><b>Easy</b></font>\n Combat is easier and bad-ends can be ignored.";
					else text = "Difficulty: <font color=\"#808000\"><b>Normal</b></font>\n No opponent stats modifiers. You can resume from bad-ends with penalties.";
					break;
				case 1:
					text = "Difficulty: <b><font color=\"#800000\">Hard</font></b>\n Opponent has 25% more HP and does 15% more damage. Bad-ends can ruin your game.";
					break;
				case 2:
					text = "Difficulty: <b><font color=\"#C00000\">Nightmare</font></b>\n Opponent has 50% more HP and does 30% more damage.";
					break;
				case 3:
					text = "Difficulty: <b><font color=\"#FF0000\">Extreme</font></b>\n Opponent has 100% more HP and does more 50% damage.";
					break;
			}
			return text;
		}
		public function disableHardcoreCheatSettings():void {
			if (flags[kFLAGS.HARDCORE_MODE] > 0) {
				outputText("<font color=\"#ff0000\">Hardcore mode is enabled. Cheats are disabled.</font>\n\n");
				/*addButtonDisabled(0, "Debug", "You cannot enable debug in Hardcore Mode. No cheating!");
				addButtonDisabled(1, "Difficulty", "You cannot change difficulty in Hardcore Mode.");
				addButtonDisabled(3, "Low Standards", "You cannot enable Low Standards in Hardcore Mode.");
				addButtonDisabled(4, "Hyper Happy", "You cannot enable Hyper Happy in Hardcore Mode.");*/
				debug = false;
				flags[kFLAGS.EASY_MODE_ENABLE_FLAG] = 0;
				flags[kFLAGS.HYPER_HAPPY] = 0;
				flags[kFLAGS.LOW_STANDARDS_FOR_ALL] = 0;
			}
			if (flags[kFLAGS.GRIMDARK_MODE] > 0) {
				//addButtonDisabled(0, "Debug", "Nuh-uh. No cheating in Grimdark Mode!");
				//addButtonDisabled(1, "Difficulty", "You cannot change difficulty in Grimdark Mode. It's meant to be the hardest game mode ever.");
				debug = false;
				flags[kFLAGS.EASY_MODE_ENABLE_FLAG] = 0;
				flags[kFLAGS.GAME_DIFFICULTY] = 3;
			}
		}

		private function difficultySelectionMenu():void {
			clearOutput();
			outputText("You can choose a difficulty to set how hard battles will be.\n");
			//outputText("\n<b>Peaceful:</b> Same as Easy but encounters can be avoided or skipped.");
			outputText("\n<b>Easy:</b> -50% damage, can ignore bad-ends.");
			outputText("\n<b>Normal:</b> No stats changes.");
			outputText("\n<b>Hard:</b> +25% HP, +15% damage.");
			outputText("\n<b>Nightmare:</b> +50% HP, +30% damage.");
			outputText("\n<b>Extreme:</b> +100% HP, +50% damage.");
			menu();
			//addButton(0, "Peaceful", chooseDifficulty, -2);
			addButton(0, "Easy", chooseDifficulty, -1);
			addButton(1, "Normal", chooseDifficulty, 0);
			addButton(2, "Hard", chooseDifficulty, 1);
			addButton(3, "Nightmare", chooseDifficulty, 2);
			addButton(4, "EXTREME", chooseDifficulty, 3);
			addButton(14, "Back", displaySettingPane, lastDisplayedPane);
		}
		private function chooseDifficulty(difficulty:int = 0):void {
			if (difficulty <= -1) {
				flags[kFLAGS.EASY_MODE_ENABLE_FLAG] = -difficulty;
				flags[kFLAGS.GAME_DIFFICULTY] = 0;
			}
			else {
				flags[kFLAGS.EASY_MODE_ENABLE_FLAG] = 0;
				flags[kFLAGS.GAME_DIFFICULTY] = difficulty;
			}
			updatePanes();
			displaySettingPane(lastDisplayedPane);
		}

		private function setWorms(enabled:Boolean, half:Boolean):void {
			//Clear status effects
			if (player.hasStatusEffect(StatusEffects.WormsOn)) player.removeStatusEffect(StatusEffects.WormsOn);
			if (player.hasStatusEffect(StatusEffects.WormsHalf)) player.removeStatusEffect(StatusEffects.WormsHalf);
			if (player.hasStatusEffect(StatusEffects.WormsOff)) player.removeStatusEffect(StatusEffects.WormsOff);
			//Set status effects
			if (enabled) {
				player.createStatusEffect(StatusEffects.WormsOn, 0, 0, 0, 0);
				if (half) player.createStatusEffect(StatusEffects.WormsHalf, 0, 0, 0, 0);
			}
			else {
				player.createStatusEffect(StatusEffects.WormsOff, 0, 0, 0, 0);
			}
			updatePanes();
		}

		//Survival Mode
		public function enableSurvivalPrompt():void {
			clearOutput();
			outputText("Are you sure you want to enable Survival Mode?\n\n");
			outputText("You will NOT be able to turn it off! (Unless you reload immediately.)");
			doYesNo(enableSurvivalForReal, createCallBackFunction(displaySettingPane, lastDisplayedPane));
		}
		public function enableSurvivalForReal():void {
			clearOutput();
			outputText("Survival mode is now enabled.");
			player.hunger = 80;
			flags[kFLAGS.HUNGER_ENABLED] = 0.5;
			doNext(createCallBackFunction(displaySettingPane, lastDisplayedPane));
		}

		//Realistic Mode
		public function enableRealisticPrompt():void {
			clearOutput();
			outputText("Are you sure you want to enable Realistic Mode?\n\n");
			outputText("You will NOT be able to turn it off! (Unless you reload immediately.)");
			doYesNo(enableRealisticForReal, createCallBackFunction(displaySettingPane, lastDisplayedPane));
		}
		public function enableRealisticForReal():void {
			clearOutput();
			outputText("Realistic mode is now enabled.")
			flags[kFLAGS.HUNGER_ENABLED] = 1;
			doNext(createCallBackFunction(displaySettingPane, lastDisplayedPane));
		}

		//------------
		// INTERFACE
		//------------
		public function menuMainBackground():void {
			menu();
			addButton(0, "Map (Default)", setMainBackground, 0);
			addButton(1, "Parchment", setMainBackground, 1);
			addButton(2, "Marble", setMainBackground, 2);
			addButton(3, "Obsidian", setMainBackground, 3);
			addButton(4, "Night Mode", setMainBackground, 4, null, null, "Good if you're playing at night to make the game easier on your eyes.");
			if (flags[kFLAGS.GRIMDARK_BACKGROUND_UNLOCKED] > 0) addButton(5, "Grimdark", setMainBackground, 9);
			else addButtonDisabled(5, "Grimdark", "Defeat Lethice once in Grimdark mode to unlock this background!");
			addButton(14, "Back", displaySettingPane, lastDisplayedPane);
		}
		public function setMainBackground(type:int):void {
			flags[kFLAGS.BACKGROUND_STYLE]           = type;
			mainView.background.bitmapClass          = MainView.Backgrounds[flags[kFLAGS.BACKGROUND_STYLE]];
			mainView.statsView.setBackground(StatsView.SidebarBackgrounds[flags[kFLAGS.BACKGROUND_STYLE]]);
			displaySettingPane(lastDisplayedPane);
		}
		
		public function menuTextBackground():void {
			menu();
			addButton(0, "Normal", setTextBackground, 0);
			addButton(1, "White", setTextBackground, 1);
			addButton(2, "Tan", setTextBackground, 2);
			addButton(4, "Back", displaySettingPane, lastDisplayedPane);
		}
		public function setTextBackground(type:int):void {
			mainView.textBGWhite.visible = false;
			mainView.textBGTan.visible = false;
			if (type == 1) mainView.textBGWhite.visible = true;
			if (type == 2) mainView.textBGTan.visible = true;
		}
		//Needed for keys
		public function cycleBackground():void {
			if (!mainView.textBGWhite.visible) { 
				mainView.textBGWhite.visible = true; 
			}
			else if (!mainView.textBGTan.visible) { 
				mainView.textBGTan.visible = true; 
			}
			else {
				mainView.textBGWhite.visible = false;
				mainView.textBGTan.visible = false;
			}
		}
		
		public function cycleQuality():void {
			if (mainView.stage.quality == StageQuality.LOW) mainView.stage.quality = StageQuality.MEDIUM;
			else if (mainView.stage.quality == StageQuality.MEDIUM) mainView.stage.quality = StageQuality.HIGH;
			else if (mainView.stage.quality == StageQuality.HIGH) mainView.stage.quality = StageQuality.LOW;
		}

		public function toggleDebug(selection:Boolean):void { 
			debug = selection;
			updatePanes();
		}
		
		public function toggleSetting(flag:int, selection:int):void { 
			flags[flag] = selection; 
			updatePanes();
		}

		//------------
		// FONT SIZE
		//------------
		public function fontSettingsMenu():void {
			hideSettingPane();
			menu();
			addButton(0, "Smaller Font", adjustFontSize, -1);
			addButton(1, "Larger Font", adjustFontSize, 1);
			addButton(2, "Reset Size", resetFontSize);
			addButton(4, "Back", displaySettingPane, lastDisplayedPane);
		}
		public function adjustFontSize(change:int):void {
			var fmt:TextFormat = mainView.mainText.getTextFormat();
			if (fmt.size == null) fmt.size = 20;
			fmt.size = (fmt.size as Number) + change;
			if ((fmt.size as Number) < 14) fmt.size = 14;
			if ((fmt.size as Number) > 32) fmt.size = 32;
			mainView.mainText.setTextFormat(fmt);
			flags[kFLAGS.CUSTOM_FONT_SIZE] = fmt.size;
		}
		public function resetFontSize():void {
			var fmt:TextFormat = mainView.mainText.getTextFormat();
			if (fmt.size == null) fmt.size = 20;
			fmt.size = 20;
			mainView.mainText.setTextFormat(fmt);
			flags[kFLAGS.CUSTOM_FONT_SIZE] = 0;
		}

		//------------
		// CONTROLS
		//------------
		public function displayControls():void {
			hideSettingPane();
			mainView.hideAllMenuButtons();
			getGame().inputManager.DisplayBindingPane();
			menu();
			addButton(0, "Reset Ctrls", resetControls);
			addButton(1, "Clear Ctrls", clearControls);
			addButton(4, "Back", hideControls);
		}
		public function hideControls():void {
			getGame().inputManager.HideBindingPane();
			displaySettingPane(lastDisplayedPane);
		}

		public function resetControls():void {
			getGame().inputManager.HideBindingPane();
			clearOutput();
			outputText("Are you sure you want to reset all of the currently bound controls to their defaults?");
			doYesNo(resetControlsYes, displayControls);
		}
		public function resetControlsYes():void {
			getGame().inputManager.ResetToDefaults();
			clearOutput();
			outputText("Controls have been reset to defaults!\n\n");
			doNext(displayControls);
		}

		public function clearControls():void {
			getGame().inputManager.HideBindingPane();
			clearOutput();
			outputText("Are you sure you want to clear all of the currently bound controls?");
			doYesNo(clearControlsYes, displayControls);
		}
		public function clearControlsYes():void {
			getGame().inputManager.ClearAllBinds();
			clearOutput();
			outputText("Controls have been cleared!");
			doNext(displayControls);
		}
	}
}
