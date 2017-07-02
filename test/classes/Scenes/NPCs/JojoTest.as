package classes.Scenes.NPCs
{
	import classes.GlobalFlags.kFLAGS;
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
	
	public class JojoTest
	{
		private static const JOJO_NAME:String = "Jojo";
		private static const JOY_NAME:String = "Joy";
		
		private var cut:Jojo;
		private var player:Player;
		
		[BeforeClass]
		public static function setUpClass():void
		{
			kGAMECLASS = new CoC(StageLocator.stage);
		}
		
		[Before]
		public function setUp():void
		{
			cut = new Jojo();
			player = new Player();
			kGAMECLASS.player = player;
			
			kGAMECLASS.flags[kFLAGS.JOJO_BIMBO_STATE] = 0;
		}
		
		private function setBimboJojo():void
		{
			kGAMECLASS.flags[kFLAGS.JOJO_BIMBO_STATE] = 3;
		}
		
		[Test]
		public function testNameNonBimbo():void
		{
			assertThat(Jojo.getNameJojoOrJoy(), equalTo(JOJO_NAME));
		}
		
		[Test]
		public function testNameBimbo():void
		{
			setBimboJojo();
			
			assertThat(Jojo.getNameJojoOrJoy(), equalTo(JOY_NAME));
		}
	}
}
