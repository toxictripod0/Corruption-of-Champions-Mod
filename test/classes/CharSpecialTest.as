package classes{
    import org.flexunit.asserts.*;
	import org.hamcrest.assertThat;
	import org.hamcrest.core.*;
	import org.hamcrest.number.*;
	import org.hamcrest.object.*;
	import org.hamcrest.text.*;
	
	import classes.CharSpecial;
	import classes.CoC;
	import classes.Player;
	import classes.GlobalFlags.kGAMECLASS;
	import classes.helper.StageLocator;
	
    public class CharSpecialTest {
        private var cut:CharSpecial;
		
		private function findCharFunction(name:String):Function {
			for (var t:Number = 0; t < cut.customs.length; t++) {
				if(cut.customs[t][0] == name) {
					return cut.customs[t][1];
				}
			}
			
			fail("No special character found with the name: "+ name)
			return null;
		}
		
		[BeforeClass]
		public static function runOnceForTestClass():void { 
			kGAMECLASS = new CoC(StageLocator.stage);
		}
		
        [Before]
        public function setUp():void {
			cut = new CharSpecial();
			kGAMECLASS.player = new Player();
			
			// guard asserts
			assertThat(kGAMECLASS.player.isFemaleOrHerm(), equalTo(false))
			assertThat(kGAMECLASS.player.isMaleOrHerm(), equalTo(false))
        }
     
		[Test] 
        public function testEtisNonVirgin():void {
			var func:Function = findCharFunction("Etis");
			
			func();
			
			assertThat(kGAMECLASS.player.isFemaleOrHerm(), equalTo(true))
			assertThat(kGAMECLASS.player.hasVirginVagina(), equalTo(false))
        }
		
		[Test] 
        public function testChimeraNonVirgin():void {
			var func:Function = findCharFunction("Chimera");
			
			func();
			
			assertThat(kGAMECLASS.player.isFemaleOrHerm(), equalTo(true))
			assertThat(kGAMECLASS.player.hasVirginVagina(), equalTo(false))
        }
		
		[Test] 
        public function testMirvanna():void {
			var func:Function = findCharFunction(CharSpecial.MIRVANNA_NAME);
			
			func();
			
			assertThat(kGAMECLASS.player.isFemaleOrHerm(), equalTo(true))
			assertThat(kGAMECLASS.player.hasVirginVagina(), equalTo(false))
        }
    }
}
