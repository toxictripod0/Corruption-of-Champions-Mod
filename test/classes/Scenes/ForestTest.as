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
			player.flags[kFLAGS.TIMES_EXPLORED_FOREST] = 30;
			
			cut.exploreForest();
			
			assertThat(player.hasStatusEffect(StatusEffects.ExploredDeepwoods));
		}
		
		[Test]
		public function exploreForestIncrementsCounter():void {
			cut.exploreForest();
			
			assertThat(player.flags[kFLAGS.TIMES_EXPLORED_FOREST], equalTo(1));
		}
    }
}
