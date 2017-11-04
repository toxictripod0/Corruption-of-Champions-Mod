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
		private var player:Player;
        private var cut:Forest;
		private var exploration:Exploration;
		
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
    }
}
