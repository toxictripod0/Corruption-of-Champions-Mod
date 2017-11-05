package classes.Scenes{
	import classes.DefaultDict;
	import classes.Scenes.Areas.Forest;
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
		private static const FOREST_EXPLORE_COUNT:int = 42;
		
		private static const FOREST_EXPLORE_PROPERTY:String = "forestExploredCounter";
		private static const VERSION_PROPERTY:String = "serializationVersion";
		
		private var player:Player;
		private var forest:Forest;
		private var cut:Exploration;
		private var serializedObject:*;
		
		
		[BeforeClass]
		public static function setUpClass():void {
			kGAMECLASS = new CoC(StageLocator.stage);
		}
		
        [Before]
        public function setUp():void {
			player = new Player();
			forest = new Forest();
			
			kGAMECLASS.player = player;
			kGAMECLASS.flags = new DefaultDict();
			kGAMECLASS.forest = forest;
			
			cut = new Exploration(forest);
			
			serializedObject = [];
        }
		
        [Test] 
        public function explorerAchievmentAwarded():void {
			kGAMECLASS.forest.discover();
			
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
		
		[Test]
		public function deserializeUndefined():void {
			serializedObject = undefined;
			
			cut.deserialize(serializedObject);
		}
    }
}
