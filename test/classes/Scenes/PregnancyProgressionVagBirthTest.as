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
	
	import classes.DefaultDict;
	import classes.CoC;
	import classes.Player;
	import classes.GlobalFlags.kGAMECLASS;
	import classes.GlobalFlags.kFLAGS;
	import classes.PregnancyStore;
	import classes.StatusEffects;
	
	import org.flexunit.runners.Parameterized;
	
	[RunWith("org.flexunit.runners.Parameterized")]
	public class PregnancyProgressionVagBirthTest 
	{
		private static const COTTON_225_MESSAGE:String = "You stroke the orb and wonder with a half-grin if you'll have a daughter who takes after her 'daddy'.";
		private static const FROG_ANAL_8_MESSAGE:String = "Your gut churns, and with a squelching noise,";
		private static const HEAT_END:String = "It seems your heat has ended.";
		private static const IMP_BIRTH_MESSAGE:String = "The pain begins to subside as your delivery continues...";
		private static const MOUSE_BIRTH_MESSAGE:String = "Two emerge, then four, eight... you lose track.";
		
		private var cut:PregProgForTest;
		private var player:Player;
		
		private var pregnancyType:int;
		private var childCounterFlagId:int;
		private var shouldDisplayText:Boolean;
		
		[BeforeClass]
		public static function setUpClass():void {
			kGAMECLASS = new CoC(StageLocator.stage);
		}
		
		[Before]
		public function setUp():void {
			player = new Player();
			player.createVagina();
			kGAMECLASS.player = player;
			
			kGAMECLASS.flags = new DefaultDict();
			kGAMECLASS.flags[kFLAGS.MARBLE_NURSERY_CONSTRUCTION] = 100;
			kGAMECLASS.time.hours = 5;
			
			cut = new PregProgForTest();
		}
		
		[Parameters]
		public static var testData:Array = [
			[PregnancyStore.PREGNANCY_FAERIE, kFLAGS.BIRTHS_FAERIE, true],
			//[PregnancyStore.INCUBATION_EMBER, kFLAGS.EMBER_CHILDREN_MALES, true],
			[PregnancyStore.PREGNANCY_URTA, kFLAGS.URTA_TIMES_PC_BIRTHED, true],
			//[PregnancyStore.PREGNANCY_SAND_WITCH, -1, true],
			//[PregnancyStore.PREGNANCY_IZMA, -1, true],
			//[PregnancyStore.PREGNANCY_SPIDER, -1, true],
			//[PregnancyStore.PREGNANCY_DRIDER_EGGS, -1, true],
			[PregnancyStore.PREGNANCY_GOO_GIRL, kFLAGS.GOOGIRL_BIRTHS, true],
			//[PregnancyStore.PREGNANCY_BASILISK, -1, true],
			//[PregnancyStore.PREGNANCY_COCKATRICE, -1, true],
			[PregnancyStore.PREGNANCY_SATYR, kFLAGS.SATYR_KIDS, true],
			//[PregnancyStore.PREGNANCY_FROG_GIRL, -1, true],
			//[PregnancyStore.PREGNANCY_BUNNY, -1, true],
			//[PregnancyStore.PREGNANCY_ANEMONE, -1, true],
			//[PregnancyStore.PREGNANCY_IMP, -1, true],
			[PregnancyStore.PREGNANCY_MARBLE, kFLAGS.MARBLE_KIDS, true],
			[PregnancyStore.PREGNANCY_MINOTAUR, kFLAGS.MINOTAUR_SONS_PENDING, true],
			[PregnancyStore.PREGNANCY_BENOIT, kFLAGS.BENOIT_EGGS, true],
			//[PregnancyStore.PREGNANCY_CENTAUR, -1, true],
			//[PregnancyStore.PREGNANCY_HELL_HOUND, -1, true],
			[PregnancyStore.PREGNANCY_MINERVA, kFLAGS.TIMES_BIRTHED_SHARPIES, false],
			[PregnancyStore.PREGNANCY_BEHEMOTH, kFLAGS.BEHEMOTH_CHILDREN, false],
			//[PregnancyStore.PREGNANCY_OVIELIXIR_EGGS, -1, true],
			[PregnancyStore.PREGNANCY_AMILY, kFLAGS.PC_TIMES_BIRTHED_AMILYKIDS, true]
			//[PregnancyStore.PREGNANCY_MOUSE, -1, true],
			];

		public function PregnancyProgressionVagBirthTest(pregnancyType:int, childCounterFlagId:int, shouldDisplayText:Boolean):void {
			this.pregnancyType = pregnancyType;
			this.childCounterFlagId = childCounterFlagId;
			this.shouldDisplayText = shouldDisplayText;
		}
		
		[Test]
		public function giveBirth():void {
			player.knockUpForce(pregnancyType, 1);
			
			cut.updatePregnancy();
			
			assertThat(kGAMECLASS.flags[childCounterFlagId], equalTo(1));
		}
		
		[Test]
		public function displayText():void {
			player.knockUpForce(pregnancyType, 1);
			
			assertThat(cut.updatePregnancy(), equalTo(shouldDisplayText));
		}
		
		[Test]
		public function pregnancyCleared():void {
			player.knockUpForce(pregnancyType, 1);
			
			cut.updatePregnancy();
			
			assertThat(player.isPregnant() , equalTo(false));
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
