package classes.Scenes.Places.Farm{
	import classes.ItemType;
	import classes.Items.ConsumableLib;
	import classes.Scenes.Inventory;
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
     
    public class KellyTest {
		private static const ONLY_MILK_REQUIRED_MILK_COUNT:int = 15;
		private static const MILK_AND_EGG_REQUIRED_MILK_COUNT:int = 10;
		
		private static var consumable:ConsumableLib;
		
		private var player:Player;
		private var inventroy:Inventory;
		private var cut:KellyForTest;
		
		[BeforeClass]
		public static function setUpClass():void {
			kGAMECLASS = new CoC(StageLocator.stage);
			
			consumable = kGAMECLASS.consumables;
		}
         
        [Before]
        public function setUp():void {  
			kGAMECLASS.player = new Player();
			player = kGAMECLASS.player;
			
			kGAMECLASS.inventory = new Inventory(kGAMECLASS.saves);
			inventroy = kGAMECLASS.inventory;
			
			cut = new KellyForTest();
        }
		
		private function addItemAmount(item:ItemType, count:int = 1, slot:int = 0) : void {
			// direct itemslot access because the inventory class has GUI code mixed with inventory code, making it a PITA to use for testing.
			// DO NOT access the inventory this way for actual game content!
			player.itemSlot(slot).setItemAndQty(item, count);
		}
		
		[Test] 
        public function testDoesNotHaveEnoughSucubiMilk():void {
			addItemAmount(consumable.SUCMILK, MILK_AND_EGG_REQUIRED_MILK_COUNT);
			
			assertThat(cut.hasRequiredItems(), equalTo(false));
		}
				
		[Test] 
        public function testHasEnoughSucubiMilk():void {
			addItemAmount(consumable.SUCMILK, ONLY_MILK_REQUIRED_MILK_COUNT);
			
			assertThat(cut.hasRequiredItems(), equalTo(true));
		}
		
		[Test] 
        public function testHasEnoughPureSucubiMilk():void {
			addItemAmount(consumable.P_S_MLK, ONLY_MILK_REQUIRED_MILK_COUNT);
			
			assertThat(cut.hasRequiredItems(), equalTo(true));
		}
		
		[Test] 
        public function testPinkEggAndSucubiMilk():void {
			addItemAmount(consumable.SUCMILK, MILK_AND_EGG_REQUIRED_MILK_COUNT);
			addItemAmount(consumable.PINKEGG, 1, 1);
			
			assertThat(cut.hasRequiredItems(), equalTo(true));
		}
		
		[Test] 
        public function testPinkEggAndPureSucubiMilk():void {
			addItemAmount(consumable.P_S_MLK, MILK_AND_EGG_REQUIRED_MILK_COUNT);
			addItemAmount(consumable.PINKEGG, 1, 1);
			
			assertThat(cut.hasRequiredItems(), equalTo(true));
		}
		
		[Test] 
        public function testPinkEggAndNotEnoughMilk():void {
			addItemAmount(consumable.SUCMILK, MILK_AND_EGG_REQUIRED_MILK_COUNT / 2);
			addItemAmount(consumable.PINKEGG, 1, 1);
			
			assertThat(cut.hasRequiredItems(), equalTo(false));
		}
    }
}

import classes.Scenes.Places.Farm.Kelly;

class KellyForTest extends Kelly {
	public var collectedOutput:Vector.<String> = new Vector.<String>(); 
	
	public function hasRequiredItems() :Boolean {
		return super.hasRequiredItemsToBreakKelt();
	}
}
