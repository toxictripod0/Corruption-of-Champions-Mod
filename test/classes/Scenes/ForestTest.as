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
			exploration = new Exploration();
			cut = new Forest(exploration);
        }
		
		[Test]
		public function discoverDeepwoods():void {
			exploration.exploreForest(30);
			
			cut.exploreForest();
			
			assertThat(player.hasStatusEffect(StatusEffects.ExploredDeepwoods));
		}
		
		[Test]
		public function exploreForestIncrementsCounter():void {
			cut.exploreForest();
			
			assertThat(exploration.exploredForestCount(), equalTo(1));
		}
    }
}
