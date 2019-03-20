package classes{
	import classes.Items.ArmorLib;
	import classes.Items.ConsumableLib;
	import classes.Items.WeaponLib;
	import classes.internals.SerializationUtils;
	import classes.lists.BreastCup;
	import flash.net.SharedObject;
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
	import classes.StatusEffects.CombatStatusEffect;
	
	public class SavesStatusEffectTest {
		private static const TEST_VERSION:String = "test";
		private static const TEST_SAVE_GAME_PREFIX:String = "savesTest-";
		
		private static const TEST_PLAYER_A:String = "foo";
		private static const TEST_PLAYER_SHORT:String = "bar";
		
		private static const incorrectLactationEffect:StatusEffectType = new StatusEffectType("Lactation EnNumbere", CombatStatusEffect, 1);

		private var player:Player;
		private var cut:SavesForTest;
		
		private var saveFile:*;
		private var serializedSave:* = [];
		private var TEST_SAVE_GAME:String;
		
		[BeforeClass]
		public static function setUpClass():void {
			kGAMECLASS = new CoC(StageLocator.stage);
		}
		
		[Before]
		public function setUp():void {
			TEST_SAVE_GAME = TEST_SAVE_GAME_PREFIX + UIDUtil.createUID();
			
			player = new Player();
			player.short = TEST_PLAYER_SHORT;
			player.a = TEST_PLAYER_A;
		
			kGAMECLASS.player = player;
			kGAMECLASS.ver = TEST_VERSION;
			kGAMECLASS.version = TEST_VERSION;
			
			cut = new SavesForTest(kGAMECLASS.gameStateDirectGet, kGAMECLASS.gameStateDirectSet);
			kGAMECLASS.inventory = new Inventory();
			
			initStatuseffects();
			
			saveGame();
			
			var versionFixup:SharedObject = SharedObject.getLocal(TEST_SAVE_GAME,"/");

			versionFixup.data.statusAffects.forEach(
				function(item:*, index:int, source:Array):void{
					delete item["serializationVersion"];
				}
			);
			
			versionFixup.flush();
			
			saveFile = [];
			saveFile.data = [];
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
		
		private function initStatuseffects():void
		{
			player.createStatusEffect(StatusEffects.Blind, 2, 3, 4, 5,false);
			player.createStatusEffect(StatusEffects.Charged, 2, 3, 4, 5, false);
			player.createStatusEffect(incorrectLactationEffect, 42, 42, 42, 42, false);
			player.createStatusEffect(StatusEffects.Confusion, 2, 3, 4, 5, false);
			
			player.createStatusEffect(StatusEffects.KnockedBack, 2, 3, 4, 5, false);
			player.createStatusEffect(StatusEffects.KnockedBack, 2, 3, 4, 5, false);
			
			player.createStatusEffect(StatusEffects.Tentagrappled, 2, 3, 4, 5, false);
			player.createStatusEffect(StatusEffects.Tentagrappled, 2, 3, 4, 5, false);
			
			player.createStatusEffect(StatusEffects.SlimeCraving, 0, 42, 0, 1, false);
			
			var index :int = player.indexOfStatusEffect(StatusEffects.Charged)
			player.statusEffect(index).dataStore = {};
			player.statusEffect(index).dataStore["foo"] = "bar";
		}

		[Test]
		public function loadStatusEffectType():void
		{
			cut.loadGame(TEST_SAVE_GAME);
			
			assertThat(kGAMECLASS.player.hasStatusEffect(StatusEffects.Blind), equalTo(true));
		}
		
		[Test]
		public function loadStatusEffectValue1():void
		{
			cut.loadGame(TEST_SAVE_GAME);
			
			var statusEffectIndex:int = kGAMECLASS.player.indexOfStatusEffect(StatusEffects.Blind);
			
			assertThat(statusEffectIndex, greaterThanOrEqualTo(0));
			assertThat(kGAMECLASS.player.statusEffect(statusEffectIndex).value1, equalTo(2));
		}
		
		[Test]
		public function loadStatusEffectValue2():void
		{
			cut.loadGame(TEST_SAVE_GAME);
			
			var statusEffectIndex:int = kGAMECLASS.player.indexOfStatusEffect(StatusEffects.Blind);
			
			assertThat(statusEffectIndex, greaterThanOrEqualTo(0));
			assertThat(kGAMECLASS.player.statusEffect(statusEffectIndex).value2, equalTo(3));
		}
		
		[Test]
		public function loadStatusEffectValue3():void
		{
			cut.loadGame(TEST_SAVE_GAME);
			
			var statusEffectIndex:int = kGAMECLASS.player.indexOfStatusEffect(StatusEffects.Blind);
			
			assertThat(statusEffectIndex, greaterThanOrEqualTo(0));
			assertThat(kGAMECLASS.player.statusEffect(statusEffectIndex).value3, equalTo(4));
		}
		
		[Test]
		public function loadStatusEffectValue4():void
		{
			cut.loadGame(TEST_SAVE_GAME);
			
			var statusEffectIndex:int = kGAMECLASS.player.indexOfStatusEffect(StatusEffects.Blind);
			
			assertThat(statusEffectIndex, greaterThanOrEqualTo(0));
			assertThat(kGAMECLASS.player.statusEffect(statusEffectIndex).value4, equalTo(5));
		}
		
		[Test]
		public function loadStatusEffectDatastore():void
		{
			cut.loadGame(TEST_SAVE_GAME);
			
			var statusEffectIndex:int = kGAMECLASS.player.indexOfStatusEffect(StatusEffects.Charged);
			
			assertThat(statusEffectIndex, greaterThanOrEqualTo(0));
			assertThat(kGAMECLASS.player.statusEffect(statusEffectIndex).dataStore, notNullValue());
			assertThat(kGAMECLASS.player.statusEffect(statusEffectIndex).dataStore["foo"], equalTo("bar"));
		}
		
		[Test]
		public function statusEffectDatastoreNullIfNotLoaded():void
		{
			cut.loadGame(TEST_SAVE_GAME);
			
			var statusEffectIndex:int = kGAMECLASS.player.indexOfStatusEffect(StatusEffects.Blind);
			
			assertThat(statusEffectIndex, greaterThanOrEqualTo(0));
			assertThat(kGAMECLASS.player.statusEffect(statusEffectIndex).dataStore, nullValue());
		}
		
		[Test]
		public function incorrectLactationEffectRemoved():void
		{
			cut.loadGame(TEST_SAVE_GAME);
			
			assertThat(kGAMECLASS.player.hasStatusEffect(incorrectLactationEffect), equalTo(false));
		}
		
		[Test]
		public function unknownEffectRemoved():void
		{
			delete StatusEffectType.getStatusEffectLibrary()["Confusion"];
			
			cut.loadGame(TEST_SAVE_GAME);
			
			assertThat(kGAMECLASS.player.hasStatusEffect(StatusEffects.Confusion), equalTo(false));
		}
		
		[Test]
		public function knockBackEffectRemovedOnLoad():void
		{
			cut.loadGame(TEST_SAVE_GAME);
			
			assertThat(kGAMECLASS.player.hasStatusEffect(StatusEffects.KnockedBack), equalTo(false));
		}
		
		[Test]
		public function oneTentaGrappledEffectRemovedOnLoad():void
		{
			// the code only removed one entry for this status effect, check with author if this was intended
			cut.loadGame(TEST_SAVE_GAME);
			
			assertThat(kGAMECLASS.player.hasStatusEffect(StatusEffects.Tentagrappled), equalTo(true));
		}
		
		[Test]
		public function onlyOneTentagrarappledEffectAfterLoad():void
		{
			cut.loadGame(TEST_SAVE_GAME);
			player.removeStatusEffect(StatusEffects.Tentagrappled);
			
			assertThat(kGAMECLASS.player.hasStatusEffect(StatusEffects.Tentagrappled), equalTo(true));
		}
		
		[Test]
		public function fixSlimeCravingOnLoad():void
		{
			cut.loadGame(TEST_SAVE_GAME);
			
			var index:int = kGAMECLASS.player.indexOfStatusEffect(StatusEffects.SlimeCraving);
			
			assertThat(index, greaterThanOrEqualTo(0));
			var effect:StatusEffect = kGAMECLASS.player.statusEffect(index);

			assertThat(effect.value3, equalTo(42));
			assertThat(effect.value2, equalTo(42));
			assertThat(effect.value4, equalTo(1));
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
