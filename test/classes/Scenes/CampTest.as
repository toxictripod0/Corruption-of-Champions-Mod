package classes.Scenes{
	import classes.DefaultDict;
	import classes.GlobalFlags.kACHIEVEMENTS;
	import classes.GlobalFlags.kFLAGS;
	import classes.Player;
	import classes.StatusEffects;
    import org.flexunit.asserts.*;
	import org.hamcrest.assertThat;
	import org.hamcrest.core.*;
	import org.hamcrest.number.*;
	import org.hamcrest.object.*;
	import org.hamcrest.text.*;
	
	import flash.display.Stage;
	
	import classes.CoC;
	import classes.Scenes.Inventory;
	import classes.Saves;
	import classes.helper.StageLocator;
	import classes.GlobalFlags.kGAMECLASS;
	
    public class CampTest {
		private var player:Player;
        private var cut:Camp;
		private var exploration:Exploration;
		
		private var doCamp:Function;
		private function campInitialize(passDoCamp:Function):void { doCamp = passDoCamp; }
		
		[BeforeClass]
		public static function setUpClass():void {
			kGAMECLASS = new CoC(StageLocator.stage);
		}
		
        [Before]
        public function setUp():void {
			player = new Player();
			kGAMECLASS.player = player;
			player.flags[kFLAGS.HISTORY_PERK_SELECTED] = 2
			player.flags[kFLAGS.MOD_SAVE_VERSION] = kGAMECLASS.modSaveVersion;
			kGAMECLASS.achievements = new DefaultDict();
			
			exploration = new Exploration();
			cut = new Camp(campInitialize, exploration);
        }  
     
        [Test] 
        public function explorerAchievmentAwarded():void {
			exploration.exploreForest();
			player.flags[kFLAGS.TIMES_EXPLORED_LAKE] = 1;
			player.flags[kFLAGS.TIMES_EXPLORED_DESERT] = 1;
			player.flags[kFLAGS.TIMES_EXPLORED_MOUNTAIN] = 1;
			player.flags[kFLAGS.TIMES_EXPLORED_PLAINS] = 1;
			player.flags[kFLAGS.TIMES_EXPLORED_SWAMP] = 1;
			player.createStatusEffect(StatusEffects.ExploredDeepwoods, 1, 0, 0, 0);
			player.flags[kFLAGS.DISCOVERED_HIGH_MOUNTAIN] = 1;
			player.flags[kFLAGS.BOG_EXPLORED] = 1;
			player.flags[kFLAGS.DISCOVERED_GLACIAL_RIFT] = 1;
			
			doCamp();
			
			assertThat(kGAMECLASS.achievements[kACHIEVEMENTS.ZONE_EXPLORER], equalTo(1));
        }
		
		[Test] 
        public function rangerAchievmentAwarded():void {
			exploration.exploreForest(100);
			
			doCamp();
			
			assertThat(kGAMECLASS.achievements[kACHIEVEMENTS.ZONE_FOREST_RANGER], equalTo(1));
        }
		
		[Test] 
        public function rangerAchievmentNotAwarded():void {
			exploration.exploreForest(2);
			
			doCamp();
			
			assertThat(kGAMECLASS.achievements[kACHIEVEMENTS.ZONE_FOREST_RANGER], equalTo(0));
        }
    }
}