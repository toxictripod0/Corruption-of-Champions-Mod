package classes.Scenes
{

	import classes.DefaultDict;
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
	import classes.GlobalFlags.kFLAGS;
	import classes.PregnancyStore;
	import classes.StatusEffects;
	
	public class PregnancyProgressionTest 
	{
		private static const COTTON_225_MESSAGE:String = "You stroke the orb and wonder with a half-grin if you'll have a daughter who takes after her 'daddy'.";
		private static const FROG_ANAL_8_MESSAGE:String = "Your gut churns, and with a squelching noise,";
		private static const HEAT_END:String = "It seems your heat has ended.";
		private static const IMP_BIRTH_MESSAGE:String = "The pain begins to subside as your delivery continues...";
		private static const MOUSE_BIRTH_MESSAGE:String = "Two emerge, then four, eight... you lose track.";
		
		private var cut:PregProgForTest;
		private var player:Player;
		
		
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
		
		[Test]
		public function cancelHeatOutput():void {
			player.goIntoHeat(false);
			player.knockUpForce(PregnancyStore.PREGNANCY_COTTON, 225);
			
			cut.updatePregnancy();
			
			assertThat(cut.collectedOutput, hasItem(containsString(HEAT_END)));
		}
		
		[Test]
		public function cancelHeatDisplayChange():void {
			player.goIntoHeat(false);
			player.knockUpForce(PregnancyStore.PREGNANCY_COTTON, 225);
			
			assertThat(cut.updatePregnancy(), equalTo(true));
		}
		
		[Test]
		public function updateFrogAnalPregnancyOutput():void {
			player.buttKnockUpForce(PregnancyStore.PREGNANCY_FROG_GIRL, 8);
			
			cut.updatePregnancy();
			
			assertThat(cut.collectedOutput, hasItem(containsString(FROG_ANAL_8_MESSAGE)));
		}
		
		[Test]
		public function updateFrogAnalPregnancyDisplayChange():void {
			player.buttKnockUpForce(PregnancyStore.PREGNANCY_FROG_GIRL, 8);
			
			assertThat(cut.updatePregnancy(), equalTo(true));
		}
		
		[Test]
		public function updateImpBirthOutput():void {
			player.knockUpForce(PregnancyStore.PREGNANCY_IMP, 1);
			
			cut.updatePregnancy();
			
			assertThat(cut.collectedOutput, hasItem(containsString(IMP_BIRTH_MESSAGE)));
		}
		
		[Test]
		public function updateImpBirthDisplayChange():void {
			player.knockUpForce(PregnancyStore.PREGNANCY_IMP, 1);
			
			assertThat(cut.updatePregnancy(), equalTo(true));
		}
		
		[Test]
		public function amilyFailsafeCorruption():void {
			player.knockUpForce(PregnancyStore.PREGNANCY_AMILY, 1);
			kGAMECLASS.flags[kFLAGS.AMILY_FOLLOWER] = 2;
			
			cut.updatePregnancy();
			
			assertThat(cut.collectedOutput, hasItem(containsString(MOUSE_BIRTH_MESSAGE)));
		}
		
		[Test]
		public function amilyFailsafeUrtha():void {
			player.knockUpForce(PregnancyStore.PREGNANCY_AMILY, 1);
			kGAMECLASS.flags[kFLAGS.AMILY_VISITING_URTA] = 2;
			
			cut.updatePregnancy();
			
			assertThat(cut.collectedOutput, hasItem(containsString(MOUSE_BIRTH_MESSAGE)));
		}
		
		[Test]
		public function amilyFailsafePrison():void {
			player.knockUpForce(PregnancyStore.PREGNANCY_AMILY, 1);
			kGAMECLASS.flags[kFLAGS.IN_PRISON] = 1;
			
			cut.updatePregnancy();
			
			assertThat(cut.collectedOutput, hasItem(containsString(MOUSE_BIRTH_MESSAGE)));
		}
		
		[Test]
		public function amilyBirth():void {
			player.knockUpForce(PregnancyStore.PREGNANCY_AMILY, 1);
			
			cut.updatePregnancy();
			
			assertThat(kGAMECLASS.flags[kFLAGS.PC_TIMES_BIRTHED_AMILYKIDS], equalTo(1));
		}
		
		[Test]
		public function benoitTimeBasedResetIncubation():void {
			player.knockUpForce(PregnancyStore.PREGNANCY_BENOIT, 1);
			
			cut.updatePregnancy();
			
			assertThat(kGAMECLASS.player.pregnancyIncubation, equalTo(3));
		}
		
		[Test]
		public function benoitTimeBasedResetIncubationTwo():void {
			player.knockUpForce(PregnancyStore.PREGNANCY_BENOIT, 2);
			
			cut.updatePregnancy();
			
			assertThat(kGAMECLASS.player.pregnancyIncubation, equalTo(3));
		}
		
		[Test]
		public function benoitTimeBasedNoDisplayOutput():void {
			player.knockUpForce(PregnancyStore.PREGNANCY_BENOIT, 1);
			
			assertThat(cut.updatePregnancy(), equalTo(false));
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
