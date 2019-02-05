package classes{
	import classes.Items.ArmorLib;
	import classes.Items.ConsumableLib;
	import classes.Items.WeaponLib;
	import classes.internals.SerializationUtils;
	import classes.lists.BreastCup;
	import org.flexunit.asserts.*;
	import org.hamcrest.assertThat;
	import org.hamcrest.core.*;
	import org.hamcrest.number.*;
	import org.hamcrest.object.*;
	import org.hamcrest.text.*;
	import org.hamcrest.collection.hasItem;
	import org.hamcrest.collection.emptyArray;
	
	import flash.display.Stage;
	import mx.utils.UIDUtil;
	
	import classes.CoC;
	import classes.Scenes.Inventory;
	import classes.Saves;
	import classes.helper.StageLocator;
	import classes.GlobalFlags.kGAMECLASS;
	import classes.GlobalFlags.kFLAGS;
	
	public class SavesTest {
		private static const TEST_VERSION:String = "test";
		private static const TEST_SAVE_GAME_PREFIX:String = "savesTest-";
		
		private static const CLIT_LENGTH:Number = 5;
		private static const VAGINA_RECOVERY_PROGRESS:int = 6;
		
		private static const NUMBER_OF_COCKS:int = 3;
		private static const TEST_SOCK:String = "testSock";
		private static const VIRIDIAN_SOCK:String = "viridian";
		
		private static const NUMBER_OF_BREAST_ROWS:int = 3;
		
		private static const TEST_PLAYER_A:String = "foo";
		private static const TEST_PLAYER_SHORT:String = "bar";
		
		private static const ASS_WETTNESS:int = 1;
		private static const ASS_LOOSENESS:int = 2;
		private static const ASS_FULLNESS:int = 3;
		
		private static const PLAYER_STR:int = 42;
		private static const PLAYER_TOU:int = 43;
		private static const PLAYER_SPE:int = 44;
		private static const PLAYER_INT:int = 45;
		private static const PLAYER_LIB:int = 46;
		private static const PLAYER_SENS:int = 47;
		private static const PLAYER_COR:int = 48;
		private static const PLAYER_FATIGUE:int = 49;
		
		private static const PLAYER_XP:int = 7;
		
		private static const oldHistoryType:PerkType = new PerkType("History: Whote", "", "");
		private static const oldLustyRegenType:PerkType = new PerkType("LustyRegeneration", "", "");

		private var player:Player;
		private var cut:SavesForTest;
		private static var consumables:ConsumableLib;
		
		private var weapons:WeaponLib = new WeaponLib;
		private var armor:ArmorLib = new ArmorLib();
		
		private var saveFile:*;
		private var serializedSave:* = [];
		private var TEST_SAVE_GAME:String;
		
		private var key1:KeyItem;
		private var key2:KeyItem;
		private var perks:*;
		
		[BeforeClass]
		public static function setUpClass():void {
			kGAMECLASS = new CoC(StageLocator.stage);
			consumables = new ConsumableLib();
		}
		
		[Before]
		public function setUp():void {
			TEST_SAVE_GAME = TEST_SAVE_GAME_PREFIX + UIDUtil.createUID();
			
			perks = [];
			player = new Player();
			player.short = TEST_PLAYER_SHORT;
			player.a = TEST_PLAYER_A;
		
			createPlayerCocks();
			createPlayerBreasts();
			createPlayerAss();
			setPlayerStats();
			createDummySerializedObject();
			
			kGAMECLASS.player = player;
			kGAMECLASS.ver = TEST_VERSION;
			kGAMECLASS.version = TEST_VERSION;
			
			cut = new SavesForTest(kGAMECLASS.gameStateDirectGet, kGAMECLASS.gameStateDirectSet);
			kGAMECLASS.inventory = new Inventory();
			
			player.itemSlot(0).setItemAndQty(consumables.CANINEP, 6);
			player.itemSlot(0).damage = 7;
			
			player.itemSlot(2).setItemAndQty(consumables.EQUINUM, 8);
			player.itemSlot(2).damage = 9;
			
			initInventory();
			initGearStorage();
			initKeyItems();
			initPerks();
			
			saveGame();

			kGAMECLASS.flags[kFLAGS.JOJO_STATUS] = 5;
			saveFile = [];
			saveFile.data = [];
			
			kGAMECLASS.inventory.clearStorage();
			kGAMECLASS.inventory.clearGearStorage();
			kGAMECLASS.player.keyItems.length = 0;
		}
		
		[After]
		public function tearDown():void
		{
			kGAMECLASS.flags[kFLAGS.TEMP_STORAGE_SAVE_DELETION] = TEST_SAVE_GAME;
			cut.purgeTheMutant();
			
			kGAMECLASS.flags[kFLAGS.TEMP_STORAGE_SAVE_DELETION] = TEST_SAVE_GAME + "_backup";
			cut.purgeTheMutant();
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
		
		private function createPlayerAss():void
		{
			player.ass.analWetness = ASS_WETTNESS;
			player.ass.analLooseness = ASS_LOOSENESS;
			player.ass.fullness = ASS_FULLNESS;
		}
		
		private function setPlayerStats():void
		{
			player.str = PLAYER_STR;
			player.tou = PLAYER_TOU;
			player.spe = PLAYER_SPE;
			player.inte = PLAYER_INT;
			player.lib = PLAYER_LIB;
			player.sens = PLAYER_SENS;
			player.cor = PLAYER_COR;
			player.fatigue = PLAYER_FATIGUE;
			
			player.XP = PLAYER_XP;
		}
		
		private function buildDummySaveForJojoTest():void
		{
			SerializationUtils.serialize(saveFile.data, new Player());
			saveFile.data.serializationVersion = undefined;
			saveFile.data.npcs = [];
			saveFile.data.npcs.jojo = [];
		}
		
		private function createDummySerializedObject():void
		{
			serializedSave["serializationVersion"] = 1;
			serializedSave.itemStorage = [];
			
			var slot1:ItemSlot = new ItemSlot();
			slot1.setItemAndQty(consumables.CANINEP, 2);
			
			var slot2:ItemSlot = new ItemSlot();
			slot2.setItemAndQty(consumables.EQUINUM, 3);
			
			
			serializedSave.itemStorage.push(slot1);
			serializedSave.itemStorage.push(slot2);
			
			serializedSave.gearStorage = [];
			
			var gear0:ItemSlot = new ItemSlot();
			var gear9:ItemSlot = new ItemSlot();
			var gear35:ItemSlot = new ItemSlot();
			
			gear0.setItemAndQty(weapons.B_SWORD, 1);
			gear9.setItemAndQty(armor.GOOARMR, 1);
			gear35.setItemAndQty(armor.B_DRESS, 1);
			
			serializedSave.gearStorage[0] = gear0;
			serializedSave.gearStorage[9] = gear9;
			serializedSave.gearStorage[35] = gear35;
		}
		
		private function initInventory():void
		{
			//TODO remove this once the saves serialization has been completed
			var items:Array = kGAMECLASS.inventory.itemStorageDirectGet();
			
			kGAMECLASS.inventory.createStorage();
			kGAMECLASS.inventory.createStorage();
			kGAMECLASS.inventory.createStorage();
			kGAMECLASS.inventory.createStorage();
			kGAMECLASS.inventory.createStorage();
			
			// this is completely safe, trust me!  /s
			(items[0] as ItemSlot).setItemAndQty(consumables.PURPDYE, 3);
			(items[1] as ItemSlot).setItemAndQty(consumables.PURHONY, 5);
			(items[2] as ItemSlot).setItemAndQty(ItemType.NOTHING, 0);
			(items[2] as ItemSlot).unlocked = false;
		}
		
		private function initGearStorage():void
		{
			var gear:Array = kGAMECLASS.inventory.gearStorageDirectGet();
			
			kGAMECLASS.inventory.initializeGearStorage();
			
			// don't try this at home kids!
			(gear[0] as ItemSlot).setItemAndQty(weapons.B_SWORD, 1);
			(gear[1] as ItemSlot).setItemAndQty(weapons.PIPE, 2);
			(gear[9] as ItemSlot).setItemAndQty(armor.GOOARMR, 3);
			(gear[35] as ItemSlot).setItemAndQty(armor.B_DRESS, 4);
		}
		
		private function initKeyItems():void
		{
			key1 = new KeyItem();
			key2 = new KeyItem();
		
			key1.keyName = "key1";
			key1.value1 = 1.0;
			key1.value2 = 2.0;
			key1.value3 = 3.0;
			key1.value4 = 4.0;
			
			key2.keyName = "key2";
			key2.value1 = 5.0;
			key2.value2 = 6.0;
			key2.value3 = 7.0;
			key2.value4 = 8.0;
			
			kGAMECLASS.player.keyItems.push(key1);
			kGAMECLASS.player.keyItems.push(key2);
		}
		
		private function initPerks():void
		{
			kGAMECLASS.player.removePerks();
			
			kGAMECLASS.player.createPerk(oldHistoryType);
			kGAMECLASS.player.createPerk(oldLustyRegenType);
			kGAMECLASS.player.createPerk(PerkLib.Agility, 1, 2, 3, 4);
			kGAMECLASS.player.createPerk(PerkLib.WizardsFocus, NaN, NaN, NaN, NaN);
			kGAMECLASS.player.perks.push(new Perk());
		}
		
		private function createUnversionedPerk(perkType:PerkType, value1:Number = 0, value2:Number = 0, value3:Number = 0, value4:Number = 0):Array
		{
			var perk:* = [];
			SerializationUtils.serialize(perk, new Perk(perkType, value1, value2, value3, value4));
			delete perk["serializationVersion"];
			
			return perk;
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
			player.removePerks();
			player.cocks[0].sock = VIRIDIAN_SOCK;
			
			cut.loadPerks([]);
			
			assertThat(player.hasPerk(PerkLib.LustyRegeneration), equalTo(true));
		}
		
		[Test]
		public function cockLoadNoLustyRegenerationPerkWithoutViridianSock():void {
			player.removePerks();
			player.cocks[0].sock = TEST_SOCK;
			
			cut.loadPerks([]);
			
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
		
		[Test]
		public function playerAssWetnessLoaded():void
		{
			cut.loadGame(TEST_SAVE_GAME);
			
			assertThat(kGAMECLASS.player.ass.analWetness, equalTo(ASS_WETTNESS));
		}
		
		[Test]
		public function playerAssLoosenessLoaded():void
		{
			cut.loadGame(TEST_SAVE_GAME);
			
			assertThat(kGAMECLASS.player.ass.analLooseness, equalTo(ASS_LOOSENESS));
		}
		
		[Test]
		public function playerAssFullnessLoaded():void
		{
			cut.loadGame(TEST_SAVE_GAME);
			
			assertThat(kGAMECLASS.player.ass.fullness, equalTo(ASS_FULLNESS));
		}
		
		[Test]
		public function playerStrStatLoaded():void
		{
			cut.loadGame(TEST_SAVE_GAME);
			
			assertThat(kGAMECLASS.player.str, equalTo(PLAYER_STR));
		}
		
		[Test]
		public function playerTouStatLoaded():void
		{
			cut.loadGame(TEST_SAVE_GAME);
			
			assertThat(kGAMECLASS.player.tou, equalTo(PLAYER_TOU));
		}
		
		[Test]
		public function playerSpeStatLoaded():void
		{
			cut.loadGame(TEST_SAVE_GAME);
			
			assertThat(kGAMECLASS.player.spe, equalTo(PLAYER_SPE));
		}
		
		[Test]
		public function playerIntStatLoaded():void
		{
			cut.loadGame(TEST_SAVE_GAME);
			
			assertThat(kGAMECLASS.player.inte, equalTo(PLAYER_INT));
		}
		
		[Test]
		public function playerLibStatLoaded():void
		{
			cut.loadGame(TEST_SAVE_GAME);
			
			assertThat(kGAMECLASS.player.lib, equalTo(PLAYER_LIB));
		}
		
		[Test]
		public function playerSensStatLoaded():void
		{
			cut.loadGame(TEST_SAVE_GAME);
			
			assertThat(kGAMECLASS.player.sens, equalTo(PLAYER_SENS));
		}
		
		[Test]
		public function playerCorStatLoaded():void
		{
			cut.loadGame(TEST_SAVE_GAME);
			
			assertThat(kGAMECLASS.player.cor, equalTo(PLAYER_COR));
		}
		
		[Test]
		public function playerFatigueStatLoaded():void
		{
			cut.loadGame(TEST_SAVE_GAME);
			
			assertThat(kGAMECLASS.player.fatigue, equalTo(PLAYER_FATIGUE));
		}
		
		[Test]
		public function playerXPLoaded():void
		{
			cut.loadGame(TEST_SAVE_GAME);
			
			assertThat(kGAMECLASS.player.XP, equalTo(PLAYER_XP));
		}
		
		[Test]
		public function undefinedGemsShouldBeZero():void
		{
			kGAMECLASS.player.gems = undefined;
			
			cut.saveGame(TEST_SAVE_GAME);
			cut.loadGame(TEST_SAVE_GAME);
			
			assertThat(kGAMECLASS.player.gems, equalTo(0));
		}
		
		[Test]
		public function negativeGemsShouldBeZero():void
		{
			kGAMECLASS.player.gems = -10;
			
			cut.saveGame(TEST_SAVE_GAME);
			cut.loadGame(TEST_SAVE_GAME);
			
			assertThat(kGAMECLASS.player.gems, equalTo(0));
		}
		
		[Test]
		public function loadPlayerNipplelengthUndefined():void
		{
			kGAMECLASS.player.nippleLength = undefined;
			
			cut.saveGame(TEST_SAVE_GAME);
			cut.loadGame(TEST_SAVE_GAME);
			
			assertThat(kGAMECLASS.player.nippleLength, equalTo(0.25));
		}
		
		[Test]
		public function loadItemSlot1Type():void
		{
			cut.loadGame(TEST_SAVE_GAME);
			
			assertThat(kGAMECLASS.player.itemSlot1.itype, equalTo(consumables.CANINEP));
		}
		
		[Test]
		public function loadItemSlot1Quantity():void
		{
			cut.loadGame(TEST_SAVE_GAME);
			
			assertThat(kGAMECLASS.player.itemSlot1.quantity, equalTo(6));
		}
		
		[Test]
		public function loadItemSlot1Unlocked():void
		{
			cut.loadGame(TEST_SAVE_GAME);
			
			assertThat(kGAMECLASS.player.itemSlot1.unlocked, equalTo(true));
		}
		
		public function loadItemSlot1Damage():void
		{
			cut.loadGame(TEST_SAVE_GAME);
			
			assertThat(kGAMECLASS.player.itemSlot1.damage, equalTo(7));
		}
		
		[Test]
		public function firstItemSlotUnlocked():void
		{
			cut.loadGame(TEST_SAVE_GAME);
			
			assertThat(kGAMECLASS.player.itemSlot(0).unlocked, equalTo(true));
		}
		
		[Test]
		public function secondItemSlotUnlocked():void
		{
			cut.loadGame(TEST_SAVE_GAME);
			
			assertThat(kGAMECLASS.player.itemSlot(1).unlocked, equalTo(true));
		}
		
		[Test]
		public function thirdItemSlotUnlocked():void
		{
			cut.loadGame(TEST_SAVE_GAME);
			
			assertThat(kGAMECLASS.player.itemSlot(2).unlocked, equalTo(true));
		}
		
		[Test]
		public function fourthItemSlotLocked():void
		{
			cut.loadGame(TEST_SAVE_GAME);
			
			assertThat(kGAMECLASS.player.itemSlot(3).unlocked, equalTo(false));
		}
		
		[Test]
		public function tenththItemSlotLocked():void
		{
			cut.loadGame(TEST_SAVE_GAME);
			
			assertThat(kGAMECLASS.player.itemSlot(9).unlocked, equalTo(false));
		}
		
		[Test(expected=RangeError)]
		public function accessOutOfBoundsItemSlot():void
		{
			assertThat(kGAMECLASS.player.itemSlot(10), nullValue());
		}
		
		[Test]
		public function itemSlotLoadOrder():void
		{
			cut.loadGame(TEST_SAVE_GAME);
			
			assertThat(kGAMECLASS.player.itemSlot1.itype, equalTo(consumables.CANINEP));
			assertThat(kGAMECLASS.player.itemSlot2.itype, equalTo(ItemType.NOTHING));
			assertThat(kGAMECLASS.player.itemSlot3.itype, equalTo(consumables.EQUINUM));
		}
		
		[Test]
		public function upgradeCreatesInventory():void
		{	
			cut.upgradeSerializationVersion(serializedSave, 1);
			
			assertThat(serializedSave, hasProperty("inventory"));
		}
		
		[Test]
		public function upgradeCreatesItemStorageInInventory():void
		{	
			cut.upgradeSerializationVersion(serializedSave, 1);
			
			assertThat(serializedSave.inventory, hasProperty("itemStorage"));
		}
		
		[Test]
		public function upgradeCopiesItemStorageData():void
		{	
			cut.upgradeSerializationVersion(serializedSave, 1);
			
			assertThat(serializedSave.inventory.itemStorage[0].itype.id, equalTo(consumables.CANINEP.id));
			assertThat(serializedSave.inventory.itemStorage[1].itype.id, equalTo(consumables.EQUINUM.id));
		}
		
		[Test]
		public function upgradeDeletesItemStorageFromSaveRoot():void
		{	
			cut.upgradeSerializationVersion(serializedSave, 1);
			
			assertThat(serializedSave, not(hasProperty("itemStorage")));
		}
		
		[Test]
		public function inventoryMustBeValid():void
		{
			assertThat(kGAMECLASS.inventory, notNullValue());
		}
		
		[Test(description="This is to test that the inventory is correctly serialized")]
		public function itemStorageLoaded():void
		{
			//TODO remove this once the saves serialization has been completed
			cut.loadGame(TEST_SAVE_GAME);
			
			assertThat("Item storage did not contain purple dye", kGAMECLASS.inventory.hasItemInStorage(consumables.PURPDYE), equalTo(true));
			assertThat("Item storage did not contain pure honey", kGAMECLASS.inventory.hasItemInStorage(consumables.PURHONY), equalTo(true));
		}
		
		[Test]
		public function upgradeCreatesGearStorageInInventory():void
		{
			cut.upgradeSerializationVersion(serializedSave, 1);
			
			assertThat(serializedSave.inventory, hasProperty("gearStorage"));
		}
		
		[Test]
		public function upgradeCopiesGearStorageData():void
		{	
			cut.upgradeSerializationVersion(serializedSave, 1);
			
			assertThat(serializedSave.inventory.gearStorage[0].itype.id, equalTo(weapons.B_SWORD.id));
			assertThat(serializedSave.inventory.gearStorage[9].itype.id, equalTo(armor.GOOARMR.id));
			assertThat(serializedSave.inventory.gearStorage[35].itype.id, equalTo(armor.B_DRESS.id));
		}
		
		[Test]
		public function upgradeDeletesGearStorageFromSaveRoot():void
		{	
			cut.upgradeSerializationVersion(serializedSave, 1);
			
			assertThat(serializedSave, not(hasProperty("gearStorage")));
		}

		[Test]
		public function upgradeCreatesMissingGearStorage():void
		{
			delete serializedSave["gearStorage"];
			// guard assert
			assertThat(serializedSave, not(hasProperty("gearStorage")));
			
			cut.upgradeSerializationVersion(serializedSave, 1);
			
			assertThat(serializedSave.inventory.gearStorage, notNullValue());
			assertThat(serializedSave.inventory.gearStorage.length, equalTo(45));
		}
		
		[Test]
		public function loadedKeyItemsCount():void
		{
			cut.loadGame(TEST_SAVE_GAME);
			
			assertThat(kGAMECLASS.player.keyItems.length, equalTo(2));
		}
		
		[Test]
		public function loadedKeyItemsHasKey1():void
		{
			cut.loadGame(TEST_SAVE_GAME);
			
			assertThat(kGAMECLASS.player.keyItems, hasItem(hasProperties({keyName: "key1", value1: 1, value2: 2, value3: 3, value4: 4})));
		}
		
		[Test]
		public function loadedKeyItemsHasKey2():void
		{
			cut.loadGame(TEST_SAVE_GAME);
			
			assertThat(kGAMECLASS.player.keyItems, hasItem(hasProperties({keyName: "key2", value1: 5, value2: 6, value3: 7, value4: 8})));
		}
		
		[Test]
		public function loadedKeyItemsOrder():void
		{
			cut.loadGame(TEST_SAVE_GAME);
			
			assertThat(kGAMECLASS.player.keyItems[0], hasProperty("keyName", "key1"));
			assertThat(kGAMECLASS.player.keyItems[1], hasProperty("keyName", "key2"));
		}
		
		[Test]
		public function missingKeyItemsCreated():void
		{
			var saveWithoutKeyItems:* = [];
			
			cut.upgradeSerializationVersion(saveWithoutKeyItems, 3)
			
			assertThat(saveWithoutKeyItems, hasProperty("keyItems", emptyArray()))
		}
		
		[Test]
		public function historyPerkFixed():void
		{
			perks.push(createUnversionedPerk(oldHistoryType));
			
			cut.loadPerks(perks);
			
			assertThat(kGAMECLASS.player.hasPerk(PerkLib.HistoryWhore), equalTo(true));
		}
		
		[Test]
		public function lustyRegenPerkFixed():void
		{
			perks.push(createUnversionedPerk(oldLustyRegenType));
			
			cut.loadPerks(perks);
			
			assertThat(kGAMECLASS.player.hasPerk(PerkLib.LustyRegeneration), equalTo(true));
		}
		
		[Test]
		public function perkIdLoaded():void
		{
			cut.loadGame(TEST_SAVE_GAME);
			
			assertThat(kGAMECLASS.player.hasPerk(PerkLib.Agility), equalTo(true));
		}
		
		[Test]
		public function perkValue1Loaded():void
		{
			cut.loadGame(TEST_SAVE_GAME);
			
			assertThat(kGAMECLASS.player.perkv1(PerkLib.Agility), equalTo(1));
		}
		
		[Test]
		public function perkValue2Loaded():void
		{
			cut.loadGame(TEST_SAVE_GAME);
			
			assertThat(kGAMECLASS.player.perkv2(PerkLib.Agility), equalTo(2));
		}
		
		[Test]
		public function perkValue3Loaded():void
		{
			cut.loadGame(TEST_SAVE_GAME);
			
			assertThat(kGAMECLASS.player.perkv3(PerkLib.Agility), equalTo(3));
		}
		
		[Test]
		public function perkValue4Loaded():void
		{
			cut.loadGame(TEST_SAVE_GAME);
			
			assertThat(kGAMECLASS.player.perkv4(PerkLib.Agility), equalTo(4));
		}
		
		[Test]
		public function wizardFocusFixOnLoad():void
		{
			
			perks.push(createUnversionedPerk(PerkLib.WizardsFocus));
			
			perks[0].value1 = NaN;
			
			cut.loadPerks(perks);
			
			var perkIndex:int = kGAMECLASS.player.findPerk(PerkLib.WizardsFocus);
			
			assertThat(perkIndex, greaterThanOrEqualTo(0));
			assertThat(player.perk(perkIndex).value1, equalTo(0.3));
		}
		
		[Test]
		public function wizardFocusFix2OnLoad():void
		{
			perks.push(createUnversionedPerk(PerkLib.WizardsFocus));
			
			perks[0].value1 = 0.05;
			
			cut.loadPerks(perks);
			
			var perkIndex:int = kGAMECLASS.player.findPerk(PerkLib.WizardsFocus);
			
			assertThat(perkIndex, greaterThanOrEqualTo(0));
			assertThat(kGAMECLASS.player.perk(perkIndex).value1, equalTo(0.5));
		}
		
		[Test]
		public function nanValue1SetTo0():void
		{
			player.removePerks();
			
			var perk:* = [];
			SerializationUtils.serialize(perk, new Perk(PerkLib.ArousingAura, NaN, NaN, NaN, NaN));
			delete perk["serializationVersion"];
			
			var perks:* = [];
			perks.push(perk);
			
			cut.loadPerks(perks);
			
			var perkIndex:int = kGAMECLASS.player.findPerk(PerkLib.ArousingAura);
			
			assertThat("Could not find perk" ,perkIndex, greaterThanOrEqualTo(0));
			assertThat(kGAMECLASS.player.perk(perkIndex).value1, equalTo(0));
		}
		
		[Test]
		public function nullPerkNotLoaded():void
		{
			perks.push(createUnversionedPerk(PerkLib.Agility));
			perks.push(createUnversionedPerk(null));
			perks.push(createUnversionedPerk(PerkLib.Archmage));
			perks.push(createUnversionedPerk(null));
			perks[3].id = null;
			perks.push(createUnversionedPerk(null));
			perks[4].id = undefined;
			
			cut.loadPerks(perks);
			var playerPerks:Vector.<Perk> = kGAMECLASS.player.perks;
			
			assertThat(kGAMECLASS.player.hasPerk(Perk.NOTHING), equalTo(false));
		}
		
		[Test]
		public function getDefaultHistoryPerkIfHistorySelected():void
		{
			kGAMECLASS.player.flags[kFLAGS.HISTORY_PERK_SELECTED] = 1;
			
			cut.loadPerks([]);
			
			assertThat(kGAMECLASS.player.hasPerk(PerkLib.HistoryWhore), equalTo(true));
		}
		
		[Test]
		public function upgradePerksWithPerkName():void
		{
			var perk:* = [];
			SerializationUtils.serialize(perk, new Perk(PerkLib.ArousingAura));
			perk.perkName = perk.id;
			delete perk["serializationVersion"];
			delete perk["id"];
			
			var perks:* = [];
			perks.push(perk);
			
			cut.loadPerks(perks);
			
			assertThat(kGAMECLASS.player.hasPerk(PerkLib.ArousingAura), equalTo(true));
		}
		
		[Test]
		public function loadsLustyRegenPerk():void
		{
			// for completeness, cover all code branches
			kGAMECLASS.player.removePerks();
			kGAMECLASS.player.createPerk(PerkLib.LustyRegeneration);
			
			cut.saveGame(TEST_SAVE_GAME);
			cut.loadGame(TEST_SAVE_GAME);
			
			assertThat(kGAMECLASS.player.hasPerk(PerkLib.LustyRegeneration), equalTo(true));
		}
		
		[Test(description="Check that the test does not time out")]
		public function emptyPerkRemoverAborts():void
		{
			for (var i:int = 0; i < 1010; i++ ) {
				perks.push(createUnversionedPerk(new PerkType(UIDUtil.createUID(),"","")));
			}
			
			cut.loadPerks(perks);
			
			assertThat(player.numPerks, greaterThanOrEqualTo(1000));
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
