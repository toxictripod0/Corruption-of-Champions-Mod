package classes{
    import org.flexunit.asserts.*;
	import org.hamcrest.assertThat;
	import org.hamcrest.core.*;
	import org.hamcrest.collection.*;
	import org.hamcrest.number.*;
	import org.hamcrest.object.*;
	import org.hamcrest.text.*;
	
	import flash.display.Stage;
	
	import classes.CoC;
	import classes.helper.StageLocator;
	import classes.helper.FireButtonEvent;
	import classes.GlobalFlags.kGAMECLASS;
	import classes.Items.ArmorLib;
	
	public class CoCTest {
		private static const HP_OVER_HEAL:Number = 1000;
		private static const PLAYER_MAX_HP:Number = 250;
		
		private var cut:CoCForTest;
		private var fireButton:FireButtonEvent;
		private var player:DummyPlayer;
		
		[Before]
		public function runBeforeEveryTest():void {
			assertThat(StageLocator.stage, not(nullValue()));
			
			cut = new CoCForTest(StageLocator.stage);
			player = new DummyPlayer();
			cut.player = player;
			
			player.createVagina();
			player.HP = 1;
			player.tou = 100;
			
			// TODO clean up this fugly hack - exctract test into PlayerTest
			// don't try this at home kids!
			cut.calls = player.calls;
			cut.collectedOutput = player.collectedOutput;
			
			fireButton = new FireButtonEvent(kGAMECLASS.mainView, CoC.MAX_BUTTON_INDEX);
		}

		[Test] 
		public function injectStageForTest():void {
			var coc:CoC = new CoC(StageLocator.stage);
		}
		
		[Test(expected="TypeError")] 
		public function noInjectedStage():void {
			var coc:CoC = new CoC();
		}
		
		[Test]
		public function parserSmokeTest(): void {
			cut.doThatTestingThang();
		}
		
		[Test]
		public function eventTesterSmokeTest(): void {
			cut.eventTester();
			
			//Button presses are required to stop the test from hanging
			fireButton.fireButtonClick(0); //press 'proceed' button
			fireButton.fireButtonClick(4); //press 'exit' button
		}
		
		[Test]
		public function hpChangeZeroNoDelta(): void {
			assertThat(cut.HPChange(0, false), equalTo(0));
		}
		
		[Test]
		public function hpChangeHealerBoost(): void {
			player.createPerk(PerkLib.HistoryHealer, 0, 0, 0, 0);
			
			assertThat(cut.HPChange(100, false), equalTo(120));
		}
		
		[Test]
		public function hpChangeNurseOutfitBoost(): void {
			player.setArmor(new ArmorLib().NURSECL);
			
			assertThat(cut.HPChange(100, false), equalTo(110));
		}
		
		[Test]
		public function hpChangeOverHeal(): void {
			assertThat(cut.HPChange(HP_OVER_HEAL, false), equalTo(249));
		}
		
		[Test]
		public function hpChangeOverHealPlayerHp(): void {
			cut.HPChange(HP_OVER_HEAL, false);
			
			assertThat(player.HP, equalTo(PLAYER_MAX_HP));
		}
		
		[Test]
		public function hpChangeOverHealDisplayHpChange(): void {
			cut.HPChange(HP_OVER_HEAL, true);
			
			assertThat(cut.calls, arrayWithSize(1));
			assertThat(cut.calls, hasItem(equalTo(HP_OVER_HEAL)));
		}
		
		[Test]
		public function hpChangePlayerHpOverMaxDelta(): void {
			player.HP = HP_OVER_HEAL;
			
			assertThat(cut.HPChange(HP_OVER_HEAL, false), equalTo(0));
		}
		
		[Test]
		public function hpChangePlayerHpOverMaxPlayerHp(): void {
			player.HP = HP_OVER_HEAL;
			
			cut.HPChange(HP_OVER_HEAL, false);
			
			assertThat(player.HP, equalTo(1000));
		}
		
		[Test]
		public function hpChangePlayerHpOverMaxDisplayHpChange(): void {
			player.HP = HP_OVER_HEAL;
			
			cut.HPChange(HP_OVER_HEAL, true);
			
			assertThat(cut.calls, arrayWithSize(1));
			assertThat(cut.calls, hasItem(equalTo(HP_OVER_HEAL)));
		}
		
		[Test]
		public function hpChangeHealDisplayHpChange(): void {
			cut.HPChange(1, true);
			
			assertThat(cut.calls, arrayWithSize(1));
			assertThat(cut.calls, hasItem(equalTo(1)));
		}
		
		[Test]
		public function hpChangeHealPlayerHP(): void {
			cut.HPChange(1, true);
			
			assertThat(player.HP, equalTo(2));
		}
		
		[Test]
		public function hpChangeDamageDisplayHpChange(): void {
			player.HP = 50;
			
			cut.HPChange(-1, true);
			
			assertThat(cut.calls, arrayWithSize(1));
			assertThat(cut.calls, hasItem(equalTo(-1)));
		}
		
		[Test]
		public function hpChangeDamagePlayerHp(): void {
			player.HP = 50;
			
			cut.HPChange(-1, false);
			
			assertThat(player.HP, equalTo(49));
		}
		
		[Test]
		public function hpChangeDamageBelowZeroDisplayHpChange(): void {
			cut.HPChange(-HP_OVER_HEAL, true);
			
			assertThat(cut.calls, arrayWithSize(1));
			assertThat(cut.calls, hasItem(equalTo(-HP_OVER_HEAL)));
		}
		
		[Test]
		public function hpChangeDamageBelowZeroPlayerHp(): void {
			cut.HPChange(-HP_OVER_HEAL, false);
			
			assertThat(player.HP, equalTo(0));
		}
		
		[Test]
		public function hpChangeNotifyNoChange(): void {
			cut.HPChangeNotify(0);
			
			assertThat(cut.collectedOutput, emptyArray());
		}
		
		[Test]
		public function hpChangeNotifyNoChangeOverMaxHp(): void {
			player.HP = HP_OVER_HEAL;
			
			cut.HPChangeNotify(0);
			
			assertThat(cut.collectedOutput, hasItem(startsWith("You're as healthy as you can be.")));
		}
		
		[Test]
		public function hpChangeNotifyHeal(): void {
			cut.HPChangeNotify(1);
			
			assertThat(cut.collectedOutput, hasItem(startsWith("You gain")));
		}
		
		[Test]
		public function hpChangeNotifyHealOverMaxHp(): void {
			player.HP = HP_OVER_HEAL;
			
			cut.HPChangeNotify(1);
			
			assertThat(cut.collectedOutput, hasItem(startsWith("Your HP maxes out at")));
		}
		
		[Test]
		public function hpChangeNotifyDamage(): void {
			cut.HPChangeNotify(-1);
			
			assertThat(cut.collectedOutput, hasItem(containsString("damage.")));
		}
		
		[Test]
		public function hpChangeNotifyDamageHpBelowZero(): void {
			player.HP = -1;
			
			cut.HPChangeNotify(-1);
			
			assertThat(cut.collectedOutput, hasItem(containsString("damage, dropping your HP to 0.")));
		}
	}
}

import classes.CoC;
import flash.display.Stage;

class CoCForTest extends CoC {
	public var calls:Vector.<Number> = new Vector.<Number>();
	public var collectedOutput:Vector.<String> = new Vector.<String>();
	
	public function CoCForTest(injectedStage:Stage) 
	{
		super(injectedStage);
	}
	
	/**
	 * Intercept calls to HPChangeNotify so we can sense them in tests.
	 * 
	 * @param	changeNum the value of the HP change?
	 */
	override public function HPChangeNotify(changeNum:Number):void {
		calls.push(changeNum);
		super.HPChangeNotify(changeNum);
	}
	
	/**
	 * Redirect output to a vector instead of displaying it on the GUI.
	 * @param	text to store
	 */
	override public function outputText(text:String):void {
		collectedOutput.push(text);
	}
}

import classes.Player;

/**
 * Yes, i'm a lazy git.
 */
class DummyPlayer extends Player {
	public var calls:Vector.<Number> = new Vector.<Number>();
	public var collectedOutput:Vector.<String> = new Vector.<String>();

	/**
	 * Intercept calls to HPChangeNotify so we can sense them in tests.
	 * 
	 * @param	changeNum the value of the HP change?
	 */
	override public function HPChangeNotify(changeNum:Number):void {
		calls.push(changeNum);
		super.HPChangeNotify(changeNum);
	}
	
	/**
	 * Redirect output to a vector instead of displaying it on the GUI.
	 * @param	text to store
	 */
	override protected function outputText(text:String):void {
		collectedOutput.push(text);
	}
}
