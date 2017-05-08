package classes.Scenes{
    import org.flexunit.asserts.*;
	import org.hamcrest.assertThat;
	import org.hamcrest.core.*;
	import org.hamcrest.number.*;
	import org.hamcrest.object.*;
	import org.hamcrest.text.*;
	
	import flash.display.Stage;
	import classes.GlobalFlags.kACHIEVEMENTS;
	import classes.GlobalFlags.kFLAGS;
	import classes.Player;
	import classes.StatusEffects;
	import classes.CoC;
	import classes.helper.StageLocator;
	import classes.GlobalFlags.kGAMECLASS;
	
    public class ExplorationTest {
		private var player:Player;
		private var cut:Exploration;
		
		[BeforeClass]
		public static function setUpClass():void {
			kGAMECLASS = new CoC(StageLocator.stage);
		}
		
        [Before]
        public function setUp():void {
			player = new Player();
			kGAMECLASS.player = player;
			
			cut = new Exploration();
        }  
     
        [Test] 
        public function explorerAchievmentAwarded():void {
			player.flags[kFLAGS.TIMES_EXPLORED_FOREST] = 1;
			player.flags[kFLAGS.TIMES_EXPLORED_LAKE] = 1;
			player.flags[kFLAGS.TIMES_EXPLORED_DESERT] = 1;
			player.flags[kFLAGS.TIMES_EXPLORED_MOUNTAIN] = 1;
			player.flags[kFLAGS.TIMES_EXPLORED_PLAINS] = 1;
			player.flags[kFLAGS.TIMES_EXPLORED_SWAMP] = 1;
			player.createStatusEffect(StatusEffects.ExploredDeepwoods, 1, 0, 0, 0);
			player.flags[kFLAGS.DISCOVERED_HIGH_MOUNTAIN] = 1;
			player.flags[kFLAGS.BOG_EXPLORED] = 1;
			player.flags[kFLAGS.DISCOVERED_GLACIAL_RIFT] = 1;
			
			assertThat(cut.hasExploredAllZones(), equalTo(true));
        }
    }
}
