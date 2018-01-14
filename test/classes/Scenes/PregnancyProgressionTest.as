package classes.Scenes
{

	import org.flexunit.asserts.*;
	import org.hamcrest.assertThat;
	import org.hamcrest.core.*;
	import org.hamcrest.number.*;
	import org.hamcrest.object.*;
	import org.hamcrest.text.*;
	import org.hamcrest.collection.*;
	
	import classes.helper.StageLocator;
	
	import classes.CoC;
	import classes.Player;
	import classes.GlobalFlags.kGAMECLASS;
	import classes.PregnancyStore;
	
	public class PregnancyProgressionTest 
	{
		private static const COTTON_225_MESSAGE:String = "You stroke the orb and wonder with a half-grin if you'll have a daughter who takes after her 'daddy'.";
		
		private var cut:PregProgForTest;
		private var player:Player;
		
		
		[BeforeClass]
		public static function setUpClass():void {
			kGAMECLASS = new CoC(StageLocator.stage);
		}
		
		[Before]
		public function setUp():void {
			player = new Player();
			kGAMECLASS.player = player;
			
			cut = new PregProgForTest();
		}
		
		[Test]
		public function updateCottonPregnancyOutput():void {
			player.knockUpForce(PregnancyStore.PREGNANCY_COTTON, 225);
			
			cut.updatePregnancy();
			
			assertThat(cut.collectedOutput, hasItem(containsString(COTTON_225_MESSAGE)));
		}
		
		[Test]
		public function updateCottonPregnancyDisplayChange():void {
			player.knockUpForce(PregnancyStore.PREGNANCY_COTTON, 225);
			
			assertThat(cut.updatePregnancy(), equalTo(true));
		}
	}
}

import classes.Scenes.PregnancyProgression;

class PregProgForTest extends PregnancyProgression {
	public var collectedOutput:Vector.<String> = new Vector.<String>(); 
	
	override protected function outputText(output:String):void {
		collectedOutput.push(output);
	}
	
	public function pregUpdate():Boolean {
		return updatePregnancy();
	}
}
