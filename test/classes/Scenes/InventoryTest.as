package classes.Scenes 
{
	import classes.GlobalFlags.kGAMECLASS;
	import classes.ItemSlot;
	import classes.ItemType;
	import classes.Items.ArmorLib;
	import classes.Items.ConsumableLib;
	import classes.Items.WeaponLib;
	import classes.Saves;
	import classes.internals.SerializationUtils;
	import org.hamcrest.assertThat;
	import org.hamcrest.object.equalTo;
	import org.hamcrest.object.notNullValue;
	import org.hamcrest.object.nullValue;
	
	public class InventoryTest 
	{
		private var cut:Inventory;
		
		private var serializedClass:*;
		private var deserialized:Inventory;
		
		private static var consumables:ConsumableLib;
		private var weapons:WeaponLib = new WeaponLib;
		private var armor:ArmorLib = new ArmorLib();
		
		private var saveFile:*;
		
		[BeforeClass]
		public static function setUpClass():void {
			consumables = new ConsumableLib();
		}
		
		[Before]
		public function setUp():void
		{
			cut = new Inventory();
			
			serializedClass = [];
			deserialized = new Inventory();
			
			initInventory();
			initGearStorage();
			
			SerializationUtils.serialize(serializedClass, cut);
			SerializationUtils.deserialize(serializedClass, deserialized);
		}
		
		private function initInventory():void
		{
			var items:Array = cut.itemStorageDirectGet();
			
			cut.createStorage();
			cut.createStorage();
			cut.createStorage();
			cut.createStorage();
			cut.createStorage();
			
			// this is completely safe, trust me!  /s
			(items[0] as ItemSlot).setItemAndQty(consumables.PURPDYE, 3);
			(items[1] as ItemSlot).setItemAndQty(consumables.PURHONY, 5);
			(items[2] as ItemSlot).setItemAndQty(ItemType.NOTHING, 0);
			(items[2] as ItemSlot).unlocked = false;
		}
		
		private function initGearStorage():void
		{
			var gear:Array = cut.gearStorageDirectGet();
			
			cut.initializeGearStorage();
			
			// don't try this at home kids!
			(gear[0] as ItemSlot).setItemAndQty(weapons.B_SWORD, 1);
			(gear[1] as ItemSlot).setItemAndQty(weapons.PIPE, 2);
			(gear[9] as ItemSlot).setItemAndQty(armor.GOOARMR, 3);
			(gear[35] as ItemSlot).setItemAndQty(armor.B_DRESS, 4);
		}
		
		[Test]
		public function instanceIsCreated():void
		{
			assertThat(cut, notNullValue());
		}

		[Test]
		public function itemStorageLoaded():void
		{
			assertThat(deserialized.hasItemInStorage(consumables.PURPDYE), equalTo(true));
			assertThat(deserialized.hasItemInStorage(consumables.PURHONY), equalTo(true));
		}
		
		[Test]
		public function itemStorageQuantityLoaded():void
		{
			assertThat(deserialized.itemStorageDirectGet()[0].quantity, equalTo(3));
			assertThat(deserialized.itemStorageDirectGet()[1].quantity, equalTo(5));
		}
		
		[Test]
		public function emptyItemStorageSlotIsNull():void
		{
			assertThat(deserialized.itemStorageDirectGet()[5], nullValue());
		}
		
		[Test]
		public function itemStorageMustBeInitializedAfterLoad():void
		{
			assertThat(deserialized.itemStorageDirectGet(), notNullValue());
		}
		
		[Test]
		public function itemStorageSlotIsLocked():void
		{
			assertThat(deserialized.itemStorageDirectGet()[2].unlocked, equalTo(false));
		}
		
		[Test]
		public function upgradeMissingGearStorageSlots():void
		{
			serializedClass["serializationVersion"] = 1;
			var gear:Array = serializedClass["gearStorage"];
			gear.length = 43;
			
			// guard assert - the gear array must be too short
			assertThat(gear.length, equalTo(43));
			
			SerializationUtils.deserialize(serializedClass, deserialized);
			
			assertThat(deserialized.gearStorageDirectGet().length, equalTo(45));
		}
	}
}
