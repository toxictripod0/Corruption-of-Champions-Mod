package classes.Scenes{
	import classes.DefaultDict;
	import classes.GlobalFlags.kFLAGS;
    import org.flexunit.asserts.*;
	import org.hamcrest.assertThat;
	import org.hamcrest.core.*;
	import org.hamcrest.number.*;
	import org.hamcrest.object.*;
	import org.hamcrest.text.*;
	
	import flash.display.Stage;
	
	import classes.CoC;
	import classes.helper.StageLocator;
	import classes.GlobalFlags.kGAMECLASS;
	import classes.Player;
	import classes.Scenes.Areas.Forest;
	import classes.StatusEffects;
	
	public class ForestTest {
		private static const FOREST_EXPLORE_COUNT:int = 42;
		
		private static const FOREST_EXPLORE_PROPERTY:String = "exploredCounter";
		private static const VERSION_PROPERTY:String = "serializationVersion";
		
		private var player:Player;
        private var cut:Forest;
		private var exploration:Exploration;
		private var serializedObject:*;
		
		[BeforeClass]
		public static function setUpClass():void {
			kGAMECLASS = new CoC(StageLocator.stage);
		}
		
        [Before]
        public function setUp():void {
			player = new Player();
			kGAMECLASS.player = player;
			kGAMECLASS.achievements = new DefaultDict();
			kGAMECLASS.flags = new DefaultDict();
			cut = new Forest();
			
			serializedObject = [];
        }
		
		[Test]
		public function discoverDeepwoods():void {
			cut.explorationCount = 30;
			
			cut.explore();
			
			assertThat(player.hasStatusEffect(StatusEffects.ExploredDeepwoods));
		}
		
		[Test]
		public function exploreForestIncrementsCounter():void {
			cut.explore();
			
			assertThat(cut.explorationCount, equalTo(1));
		}
		
		[Test]
		public function forestNotDiscovered():void {
			assertThat(cut.isDiscovered(), equalTo(false));
		}
		
		[Test]
		public function forestDiscovered():void {
			cut.discover();
			
			assertThat(cut.isDiscovered(), equalTo(true));
		}
		
		[Test(expected = "ArgumentError")]
		public function forestExplorationCountSetToNegative():void {
			cut.explorationCount = -1;
		}
		
		[Test]
		public function forestExplorationCountSetToPositive():void {
			cut.explorationCount = 2;
			
			assertThat(cut.explorationCount, equalTo(2));
		}
				
		[Test]
		public function serializeForestExplorationCounter():void {
			cut.explorationCount = FOREST_EXPLORE_COUNT
			
			cut.serialize(serializedObject);
			
			assertThat(serializedObject, hasProperties({exploredCounter: FOREST_EXPLORE_COUNT}));
		}
		
		[Test]
		public function serializeExplorationVersion():void {
			cut.serialize(serializedObject);
			
			assertThat(serializedObject, hasProperties({serializationVersion: 1}));
		}
		
		[Test]
		public function deserializeFromVersion1():void {
			serializedObject[VERSION_PROPERTY] = 1;
			serializedObject[FOREST_EXPLORE_PROPERTY] = FOREST_EXPLORE_COUNT;
			
			cut.deserialize(serializedObject);
			
			assertThat(cut.explorationCount, equalTo(FOREST_EXPLORE_COUNT));
		}
	}
}
