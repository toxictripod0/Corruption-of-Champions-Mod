package classes.Scenes{
	import classes.DefaultDict;
	import classes.GlobalFlags.kACHIEVEMENTS;
	import classes.GlobalFlags.kFLAGS;
	import classes.Player;
	import classes.Scenes.Areas.Forest;
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
		private var forest:Forest;
		
		private var doCamp:Function;
		private function campInitialize(passDoCamp:Function):void { doCamp = passDoCamp; }
		
		[BeforeClass]
		public static function setUpClass():void {
			kGAMECLASS = new CoC(StageLocator.stage);
		}
		
        [Before]
        public function setUp():void {
			player = new Player();
			forest = new Forest();
			
			kGAMECLASS.player = player;
			kGAMECLASS.forest = forest;
			
			player.flags[kFLAGS.HISTORY_PERK_SELECTED] = 2
			player.flags[kFLAGS.MOD_SAVE_VERSION] = kGAMECLASS.modSaveVersion;
			kGAMECLASS.achievements = new DefaultDict();
			
			cut = new Camp(campInitialize, new MockExploration());
        }  
     
        [Test] 
        public function explorerAchievmentAwarded():void {
			doCamp();
			
			assertThat(kGAMECLASS.achievements[kACHIEVEMENTS.ZONE_EXPLORER], equalTo(1));
        }
		
		[Test] 
        public function rangerAchievmentAwarded():void {
			forest.explorationCount = 100;
			
			doCamp();
			
			assertThat(kGAMECLASS.achievements[kACHIEVEMENTS.ZONE_FOREST_RANGER], equalTo(1));
        }
		
		[Test] 
        public function rangerAchievmentNotAwarded():void {
			forest.explorationCount = 2;
			
			doCamp();
			
			assertThat(kGAMECLASS.achievements[kACHIEVEMENTS.ZONE_FOREST_RANGER], equalTo(0));
        }
    }
}

import classes.Scenes.Exploration;

class MockExploration extends Exploration {
	public function MockExploration() 
	{
		super(null);
	}
	
	override public function hasExploredAllZones():Boolean {
		return true;
	}
}
