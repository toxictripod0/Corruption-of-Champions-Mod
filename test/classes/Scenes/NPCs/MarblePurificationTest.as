package classes.Scenes.NPCs{
	import classes.GlobalFlags.kFLAGS;
	import classes.StatusEffects;
    import org.flexunit.asserts.*;
	import org.hamcrest.assertThat;
	import org.hamcrest.core.*;
	import org.hamcrest.number.*;
	import org.hamcrest.object.*;
	import org.hamcrest.text.*;
	import org.hamcrest.collection.*;
	
	import classes.helper.StageLocator;
	
	import classes.GlobalFlags.kGAMECLASS;
	import classes.Player;
	import classes.CoC;
     
    public class MarblePurificationTest {
		private static const JOJO_ENGAGE_TEXT : String = "Jojo says, rising off the ground and retrieving his staff.";
		
        private var cut:MarblePurificationForTest;
		private var player:Player;
		
		[BeforeClass]
		public static function setUpClass():void {
			kGAMECLASS = new CoC(StageLocator.stage);
		}
         
        [Before]
        public function setUp():void {  
			cut = new MarblePurificationForTest();
			player = new Player();
			kGAMECLASS.player = player;
			
			//need at least a camp population of 3
			kGAMECLASS.flags[kFLAGS.AMILY_FOLLOWER] = 1;
			kGAMECLASS.flags[kFLAGS.ISABELLA_FOLLOWER_ACCEPTED] = 1;
			kGAMECLASS.flags[kFLAGS.HEL_FOLLOWER_LEVEL] = 2;
        }
		
		[Test] 
        public function testCallClaraOutWithoutJoJo() :void {
			cut.highIntelligenceCallClaraOut();
			
			assertThat(cut.collectedOutput, not(hasItem(containsString(JOJO_ENGAGE_TEXT))));
		}
		
		[Test] 
        public function testCallClaraOutWithJoJo() :void {
			player.createStatusEffect(StatusEffects.PureCampJojo, 0, 0, 0, 0);
			
			cut.highIntelligenceCallClaraOut();
			
			assertThat(cut.collectedOutput, hasItem(containsString(JOJO_ENGAGE_TEXT)));
		}

    }
}

import classes.Scenes.NPCs.MarblePurification;

class MarblePurificationForTest extends MarblePurification {
	public var collectedOutput:Vector.<String> = new Vector.<String>(); 
	
	override protected function outputText(output:String):void {
		collectedOutput.push(output);
	}
}
