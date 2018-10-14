package classes{
	import classes.lists.BreastCup;
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
	import classes.GlobalFlags.kFLAGS;
	
	public class SavesTest {
		private static const TEST_VERSION:String = "test";
		private static const TEST_SAVE_GAME:String = "test";
		
		private static const CLIT_LENGTH:Number = 5;
		private static const VAGINA_RECOVERY_PROGRESS:int = 6;
		
		private static const NUMBER_OF_COCKS:int = 3;
		private static const TEST_SOCK:String = "testSock";
		private static const VIRIDIAN_SOCK:String = "viridian";
		
		private static const NUMBER_OF_BREAST_ROWS:int = 3;
		
		private static const TEST_PLAYER_A:String = "foo";
		private static const TEST_PLAYER_SHORT:String = "bar";

		
		private var player:Player;
		private var cut:SavesForTest;

		private var saveFile:*;
		
		[BeforeClass]
		public static function setUpClass():void {
			kGAMECLASS = new CoC(StageLocator.stage);
		}
		
		[Before]
		public function setUp():void {
			player = new Player();
			player.short = TEST_PLAYER_SHORT;
			player.a = TEST_PLAYER_A;
		
			createPlayerCocks();
			createPlayerBreasts();
			
			kGAMECLASS.player = player;
			kGAMECLASS.ver = TEST_VERSION;
			kGAMECLASS.version = TEST_VERSION;
			
			cut = new SavesForTest(kGAMECLASS.gameStateDirectGet, kGAMECLASS.gameStateDirectSet);
			kGAMECLASS.inventory = new Inventory(cut);
			
			saveGame();

			kGAMECLASS.flags[kFLAGS.JOJO_STATUS] = 5;
			saveFile = [];
			saveFile.data = [];
		}
		
		private function saveGame():void {
			cut.saveGame(TEST_SAVE_GAME, false);
		}
		
		private function loadGame():void {
			kGAMECLASS.player = new Player();
			
			cut.loadGame(TEST_SAVE_GAME);
			
			this.player = kGAMECLASS.player;
		}
		
		private function createPlayerCocks():void {
			player.removeCock(0, int.MAX_VALUE);
			
			player.createCock(1, 1, CockTypesEnum.CAT);
			player.createCock(2, 2, CockTypesEnum.DOG);
			player.createCock(3, 3, CockTypesEnum.HORSE);
		}
		
		private function createPlayerBreasts():void {
			player.removeBreastRow(0, int.MAX_VALUE);
			
			player.createBreastRow(BreastCup.A);
			player.createBreastRow(BreastCup.B);
			player.createBreastRow(BreastCup.C);
		}
		
		private function buildDummySaveForJojoTest():void
		{
			saveFile.data.npcs = [];
			saveFile.data.npcs.jojo = [];
			saveFile.data.cocks = [];
			saveFile.data.vaginas = [];
			saveFile.data.breastRows = [];
		}
		
		[Test]
		public function testClitLengthSaved():void {
			player.createVagina();
			player.setClitLength(CLIT_LENGTH);
			cut.saveGame(TEST_SAVE_GAME, false);
			player.setClitLength(0);
			
			cut.loadGame(TEST_SAVE_GAME);
			
			assertThat(kGAMECLASS.player.getClitLength(), equalTo(CLIT_LENGTH));
		}
		
		[Test] 
		public function testRecoveryProgressSaved():void {
			player.createVagina();
			player.vaginas[0].recoveryProgress = VAGINA_RECOVERY_PROGRESS;
			cut.saveGame(TEST_SAVE_GAME, false);
			player.vaginas[0].resetRecoveryProgress();
			
			cut.loadGame(TEST_SAVE_GAME);
			
			assertThat(kGAMECLASS.player.vaginas[0].recoveryProgress, equalTo(VAGINA_RECOVERY_PROGRESS));
		}
		
		[Test]
		public function playerHasThreeCocks():void {
			assertThat(player.cocks.length, equalTo(NUMBER_OF_COCKS));
		}
		
		[Test]
		public function cocksAreStored():void {
			player.removeCock(0, 3);
			assertThat(player.cocks.length, equalTo(0));
			
			cut.loadGame(TEST_SAVE_GAME);
			
			assertThat(kGAMECLASS.player.cocks.length, equalTo(NUMBER_OF_COCKS));
		}

		[Test]
		public function cocksLoadOrder():void {
			player.removeCock(0, 3);
			assertThat(player.cocks.length, equalTo(0));
			
			cut.loadGame(TEST_SAVE_GAME);
			
			assertThat(kGAMECLASS.player.cocks[0].cockType, equalTo(CockTypesEnum.CAT));
			assertThat(kGAMECLASS.player.cocks[2].cockType, equalTo(CockTypesEnum.HORSE));
		}
		
		[Test]
		public function cockLoadViridianSockGrantsLustyRegenerationPerk():void {
			player.cocks[0].sock = VIRIDIAN_SOCK;
			
			saveGame();
			loadGame();
			
			assertThat(player.hasPerk(PerkLib.LustyRegeneration), equalTo(true));
		}
		
		[Test]
		public function cockLoadNoLustyRegenerationPerkWithoutViridianSock():void {
			player.cocks[0].sock = TEST_SOCK;
			
			saveGame();
			loadGame();
			
			assertThat(player.hasPerk(PerkLib.LustyRegeneration), equalTo(false));
		}

		[Test]
		public function jojoLegacyStatusLoadJojoIsSlave():void {
			buildDummySaveForJojoTest();
			
			cut.loadNPCstest(saveFile);

			assertThat(kGAMECLASS.flags[kFLAGS.JOJO_STATUS], equalTo(6));
		}

		[Test]
		public function jojoLegacyStatusLoadJojoEncountersInProgress():void {
			buildDummySaveForJojoTest();
			
			var jojoStatus:int = 3;
			kGAMECLASS.flags[kFLAGS.JOJO_STATUS] = jojoStatus;
			
			cut.loadNPCstest(saveFile);

			assertThat(kGAMECLASS.flags[kFLAGS.JOJO_STATUS], equalTo(jojoStatus));
		}

		[Test]
		public function jojoNewStatusLoadUpdateSlaveStatus():void {
			buildDummySaveForJojoTest();
			saveFile.data.npcs.jojo.serializationVersion = 1;

			cut.loadNPCstest(saveFile);

			assertThat(kGAMECLASS.flags[kFLAGS.JOJO_STATUS], equalTo(5));
		}

		[Test]
		public function loadWithMissingNpcs():void {
			buildDummySaveForJojoTest();
			saveFile.data.npcs = undefined;

			cut.loadNPCstest(saveFile);

			assertThat(kGAMECLASS.flags[kFLAGS.JOJO_STATUS], equalTo(6));
		}

		[Test]
		public function loadWithMissingJojoNpc():void {
			buildDummySaveForJojoTest();
			saveFile.data.npcs = [];

			cut.loadNPCstest(saveFile);

			assertThat(kGAMECLASS.flags[kFLAGS.JOJO_STATUS], equalTo(6));
		}
		
		[Test]
		public function breastRowsAreStored():void
		{
			player.breastRows.length = 0;
			assertThat(player.breastRows.length, equalTo(0));
			
			cut.loadGame(TEST_SAVE_GAME);
			
			assertThat(kGAMECLASS.player.breastRows.length, equalTo(NUMBER_OF_BREAST_ROWS));
		}
		
		[Test]
		public function breastRowLoadOrder():void {
			player.breastRows.length = 0;
			assertThat(player.breastRows.length, equalTo(0));
			
			cut.loadGame(TEST_SAVE_GAME);
			
			assertThat(kGAMECLASS.player.breastRows[0].breastRating, equalTo(BreastCup.A));
			assertThat(kGAMECLASS.player.breastRows[2].breastRating, equalTo(BreastCup.C));
		}
		
		[Test]
		public function vaginaTypeReset():void {
			player.createVagina(true, 1, 0);
			player.vaginas[0].type = Vagina.EQUINE;
			
			cut.saveGame(TEST_SAVE_GAME);
			cut.loadGame(TEST_SAVE_GAME);

			assertThat(kGAMECLASS.player.vaginas[0].type, equalTo(Vagina.HUMAN));
		}
		
		[Test]
		public function humanVaginaIsOK():void {
			player.createVagina(true, 1, 0);
			player.vaginas[0].type = Vagina.HUMAN;
			
			cut.saveGame(TEST_SAVE_GAME);
			cut.loadGame(TEST_SAVE_GAME);

			assertThat(kGAMECLASS.player.vaginas[0].type, equalTo(Vagina.HUMAN));
		}
		
		[Test]
		public function sandTrapVaginaIsOK():void {
			player.createVagina(true, 1, 0);
			player.vaginas[0].type = Vagina.BLACK_SAND_TRAP;
			
			cut.saveGame(TEST_SAVE_GAME);
			cut.loadGame(TEST_SAVE_GAME);

			assertThat(kGAMECLASS.player.vaginas[0].type, equalTo(Vagina.BLACK_SAND_TRAP));
		}
		
		[Test]
		public function playerForceOneBreastRow():void {
			player.breastRows.length = 0;
			assertThat(player.breastRows.length, equalTo(0));
			
			cut.saveGame(TEST_SAVE_GAME);
			cut.loadGame(TEST_SAVE_GAME);
			
			assertThat(kGAMECLASS.player.breastRows.length, equalTo(1));
		}
		
		[Test]
		public function serializePlayerShortName():void {
			kGAMECLASS.player.short = "";
			
			cut.loadGame(TEST_SAVE_GAME);
			
			assertThat(kGAMECLASS.player.short, equalTo(TEST_PLAYER_SHORT));
		}
		
		[Test]
		public function serializePlayerA():void {
			kGAMECLASS.player.a = "";
			
			cut.loadGame(TEST_SAVE_GAME);
			
			assertThat(kGAMECLASS.player.a, equalTo(TEST_PLAYER_A));
		}
	}
}

import classes.Saves
import classes.internals.SerializationUtils;

class SavesForTest extends Saves {
	public function SavesForTest(gameStateDirectGet:Function, gameStateDirectSet:Function) {
		super(gameStateDirectGet, gameStateDirectSet);
	}

	public function saveNPCstest(saveFile:*):void {
		SerializationUtils.serialize(saveFile.data, this);
	}

	public function loadNPCstest(saveFile:*):void {
		SerializationUtils.deserialize(saveFile.data, this);
	}
}
