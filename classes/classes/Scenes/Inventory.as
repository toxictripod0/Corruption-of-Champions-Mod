/**
 * Created by aimozg on 12.01.14.
 */
package classes.Scenes
{
	import classes.*;
	import classes.GlobalFlags.kFLAGS;
	import classes.GlobalFlags.kGAMECLASS;
	import classes.GlobalFlags.kACHIEVEMENTS;
	import classes.Items.Armor;
	import classes.Items.Useable;
	import classes.Items.Weapon;
	import classes.Items.Jewelry;
	import classes.Items.Shield;
	import classes.Items.Undergarment;
	import classes.Items.ArmorLib;
	import classes.Items.WeaponLib;
	import classes.Items.JewelryLib;
	import classes.Items.ShieldLib;
	import classes.Items.UndergarmentLib;
	import classes.Scenes.Dungeons.DungeonCore;
	import flash.events.KeyboardEvent;
	import flash.ui.Keyboard;
	import classes.internals.LoggerFactory;
	import mx.logging.ILogger;
	import classes.display.SpriteDb;
	import classes.internals.*;

	use namespace kGAMECLASS;

	public class Inventory extends BaseContent implements Serializable {
		private static const SERIALIZATION_VERSION:int = 1;
		private static const SERIALIZATION_UUID:String = "230d7e43-bbc6-4c25-bd76-1f1175a0c58e";
		
		private static const LOGGER:ILogger = LoggerFactory.getLogger(Inventory);
		
		private static const inventorySlotName:Array = ["first", "second", "third", "fourth", "fifth", "sixth", "seventh", "eighth", "ninth", "tenth"];
		
		//TODO refactor storage into own type?
		public static const STORAGE_JEWELRY_BOX:String = "Equipment Storage - Jewelry Box";
		
		/**
		 * Stores items that are not gear, using chests?
		 */
		private var itemStorage:Array;
		/**
		 * Stores various gear, such as armor, weapons, shields, etc. Used with different types of racks.
		 */
		private var gearStorage:Array;
		/**
		 * Stores items when in prison?
		 */
		private var prisonStorage:Array;
		/**
		 * These are used so that we know what has to happen once the player finishes with an item
		 */
		private var callNext:Function;
		/**
		 * They simplify dealing with items that have a sub menu. Set in inventoryMenu and in takeItem
		 */
		private var callOnAbandon:Function;
		/**
		 * The slot previously occupied by the current item - only needed for stashes and items with a sub menu.
		 */
		private var currentItemSlot:ItemSlot;
		
		public function Inventory(saveSystem:Saves) {
			itemStorage = [];
			gearStorage = [];
			prisonStorage = [];
			saveSystem.linkToInventory(gearStorageDirectGet);
		}
		
		public function showStash():Boolean {
			return player.hasKeyItem("Equipment Rack - Weapons") >= 0 || player.hasKeyItem("Equipment Rack - Armor") >= 0 || itemStorage.length > 0 || flags[kFLAGS.ANEMONE_KID] > 0 || player.hasKeyItem(Inventory.STORAGE_JEWELRY_BOX) >= 0 || flags[kFLAGS.CAMP_CABIN_FURNITURE_DRESSER] > 0;
		}
		
		public function itemStorageDirectGet():Array { return itemStorage; }
		
		public function gearStorageDirectGet():Array { return gearStorage; }
		
		public function prisonStorageDirectGet():Array { return prisonStorage; }
		
//		public function currentCallNext():Function { return callNext; }
		
		public function itemGoNext():void { if (callNext != null) doNext(callNext); }
		
		public function inventoryMenu():void {
			var x:int;
			var foundItem:Boolean = false;
			if (getGame().inCombat) {
				callNext = inventoryCombatHandler; //Player will return to combat after item use
			}
			else {
				spriteSelect(null);
				callNext = inventoryMenu; //In camp or in a dungeon player will return to inventory menu after item use
			}
			hideMenus();
			hideUpDown();
			clearOutput();
			kGAMECLASS.displayHeader("Inventory");
			outputText("<b><u>Equipment:</u></b>\n");
			outputText("<b>Weapon:</b> " + player.weapon.name + " (Attack: " + player.weaponAttack + (player.weapon.isDegradable() ? ", Durability: " + (player.weapon.durability - flags[kFLAGS.WEAPON_DURABILITY_DAMAGE]) + "/" + player.weapon.durability : "") + ")\n");
			outputText("<b>Shield:</b> " + player.shield.name + " (Block Rating: " + player.shieldBlock + ")\n");
			outputText("<b>Armour:</b> " + player.armor.name + " (Defense: " + player.armorDef + ")\n");
			outputText("<b>Upper underwear:</b> " + player.upperGarment.name + "\n");
			outputText("<b>Lower underwear:</b> " + player.lowerGarment.name + "\n");
			outputText("<b>Accessory:</b> " + player.jewelryName + "\n");
			if (player.keyItems.length > 0) outputText("<b><u>\nKey Items:</u></b>\n");
			for (x = 0; x < player.keyItems.length; x++) outputText(player.keyItems[x].keyName + "\n");
			menu();
			for (x = 0; x < 10; x++) {
				if (player.itemSlots[x].unlocked && player.itemSlots[x].quantity > 0) {
					addButton(x, (player.itemSlots[x].itype.shortName + " x" + player.itemSlots[x].quantity), useItemInInventory, x).hint(generateInventoryTooltip(player.itemSlots[x]), capitalizeFirstLetter(player.itemSlots[x].itype.longName));
					foundItem = true;
				}
			}
			if (!getGame().inCombat) {
				addButton(10, "Unequip", manageEquipment);
			}
			
			if (!getGame().inCombat && flags[kFLAGS.DELETE_ITEMS] == 1) {
				addButton(11, "Del Item: One", deleteItems).hint("Trash your items, one by one.\n\nClick to trash all in a stack.\nClick twice to stop.", "Delete Items (Single)");
			} else if (!getGame().inCombat && flags[kFLAGS.DELETE_ITEMS] == 2) {
				addButton(11, "Del Item: All", deleteItems).hint("Trash all of your items in a stack.\n\nClick to stop.\nClick twice to trash your items one by one.", "Delete Items (Stack)");
			} else if (!getGame().inCombat && flags[kFLAGS.DELETE_ITEMS] == 0) {
				addButton(11, "Del Item: OFF", deleteItems).hint("Start throwing away your items.\n\nClick to trash your items one by one.\nClick twice to trash all in a stack.", "Delete Items (Off)");
			}
			
			
			if (!getGame().inCombat && inDungeon == false && inRoomedDungeon == false && flags[kFLAGS.IN_PRISON] == 0 && flags[kFLAGS.IN_INGNAM] == 0 && checkKeyItems(true)) {
				addButton(12, "Key Items", checkKeyItems);
				foundItem = true;
			}
			if (!getGame().inCombat && player.armor == armors.BIMBOSK) {
				addButton(13, (flags[kFLAGS.BIMBO_MINISKIRT_PROGRESS_DISABLED] == 0 ? "Disable Bimbo" : "Enable Bimbo"), getGame().bimboProgress.toggleProgress, null, null, null, (flags[kFLAGS.BIMBO_MINISKIRT_PROGRESS_DISABLED] == 0 ? "Disable bimbo progression from Bimbo Miniskirt." : "Enable bimbo progression from Bimbo Miniskirt."));
			}
			if (!foundItem) {
				outputText("\nYou have no usable items.");
				doNext(playerMenu);
				if (!getGame().inCombat) {
					addButton(10, "Unequip", manageEquipment);
				}
				return;
			}
			if (getGame().inCombat && player.hasStatusEffect(StatusEffects.Sealed) && player.statusEffectv1(StatusEffects.Sealed) == 3) {
				outputText("\nYou reach for your items, but you just can't get your pouches open.  <b>Your ability to use items was sealed, and now you've wasted a chance to attack!</b>\n\n");
				monster.doAI();
				return;
			}
			if (flags[kFLAGS.DELETE_ITEMS] > 0) outputText("\nWhich item will you discard?");
			else outputText("\nWhich item will you use?");
			outputText("\n<b>Capacity:</b> " + getOccupiedSlots() + " / " + getMaxSlots());
			addButton(14, "Back", exitInventory);
		}
		
		private function exitInventory():void {
			flags[kFLAGS.DELETE_ITEMS] = 0;
			if (getGame().inCombat)
				combat.combatMenu(false); //Player returns to the combat menu on cancel
			else
				playerMenu();
		}
		
		public function stash():void {
			hideMenus();
			clearOutput();
			spriteSelect(null);
			menu();
			if (flags[kFLAGS.ANEMONE_KID] > 0) {
				kGAMECLASS.anemoneScene.anemoneBarrelDescription();
				if (getGame().time.hours >= 6) addButton(4, "Anemone", kGAMECLASS.anemoneScene.approachAnemoneBarrel);
			}
			if (player.hasKeyItem("Camp - Chest") >= 0 || player.hasKeyItem("Camp - Murky Chest") >= 0 || player.hasKeyItem("Camp - Ornate Chest") >= 0) {
				var chestArray:Array = [];
				if (player.hasKeyItem("Camp - Chest") >= 0) chestArray.push("a large wood and iron chest");
				if (player.hasKeyItem("Camp - Murky Chest") >= 0) chestArray.push("a medium damp chest");
				if (player.hasKeyItem("Camp - Ornate Chest") >= 0) chestArray.push("a medium gilded chest");
				outputText("You have " + formatStringArray(chestArray) + " to help store excess items located ");
				if (camp.homeDesc() == "cabin") outputText("inside your cabin");
				else outputText("near the portal entrance");
				outputText(".\n\n");
				addButton(0, "Chest Store", pickItemToPlaceInCampStorage);
				if (hasItemsInStorage()) addButton(1, "Chest Take", pickItemToTakeFromCampStorage);
			}
			//Weapon Rack
			if (player.hasKeyItem("Equipment Rack - Weapons") >= 0) {
				outputText("There's a weapon rack set up here, set up to hold up to nine various weapons.");
				addButton(2, "W.Rack Put", pickItemToPlaceInWeaponRack);
				if (weaponRackDescription()) addButton(3, "W.Rack Take", pickItemToTakeFromWeaponRack);
				outputText("\n\n");
			}
			//Armor Rack
			if (player.hasKeyItem("Equipment Rack - Armor") >= 0) {
				outputText("Your camp has an armor rack set up to hold your various sets of gear.  It appears to be able to hold nine different types of armor.");
				addButton(5, "A.Rack Put", pickItemToPlaceInArmorRack);
				if (armorRackDescription()) addButton(6, "A.Rack Take", pickItemToTakeFromArmorRack);
				outputText("\n\n");
			}
			//Shield Rack
			if (player.hasKeyItem("Equipment Rack - Shields") >= 0) {
				outputText("There's a shield rack set up here, set up to hold up to nine various shields.");
				addButton(7, "S.Rack Put", pickItemToPlaceInShieldRack);
				if (shieldRackDescription()) addButton(8, "S.Rack Take", pickItemToTakeFromShieldRack);
				outputText("\n\n");
			}
			//Jewelry box
			if (player.hasKeyItem(Inventory.STORAGE_JEWELRY_BOX) >= 0) {
				outputText("Your jewelry box is located ");
				if (flags[kFLAGS.CAMP_BUILT_CABIN] > 0 && flags[kFLAGS.CAMP_CABIN_FURNITURE_BED])
				{
					if (flags[kFLAGS.CAMP_CABIN_FURNITURE_DRESSER]) outputText("on your dresser inside your cabin.");
					else
					{
						if (flags[kFLAGS.CAMP_CABIN_FURNITURE_NIGHTSTAND]) outputText("on your nightstand inside your cabin.");
						else  outputText("under your bed inside your cabin.");
					}
				}
				else outputText("next to your bedroll.");	
				addButton(10, "J.Box Put", inventory.pickItemToPlaceInJewelryBox);
				if (inventory.jewelryBoxDescription()) addButton(11, "J.Box Take", inventory.pickItemToTakeFromJewelryBox);
				outputText("\n\n");
			}
			//Dresser
			if (flags[kFLAGS.CAMP_CABIN_FURNITURE_DRESSER] > 0) {
				outputText("You have a dresser inside your cabin to store nine different types of undergarments.");
				addButton(12, "Dresser Put", inventory.pickItemToPlaceInDresser);
				if (inventory.dresserDescription()) addButton(13, "Dresser Take", inventory.pickItemToTakeFromDresser);
				outputText("\n\n");
			}
			addButton(14, "Back", playerMenu);
			//Achievement time!
			var isAchievementEligible:Boolean = true;
			var i:int = 0;
			if (getMaxSlots() < 10) isAchievementEligible = false;
			if (getOccupiedSlots() < 10) isAchievementEligible = false;
			if (itemStorage.length < 14) isAchievementEligible = false; //Need to have all the chests!
			for (i = 0; i < itemStorage.length; i++) {
				if (itemStorage[i].quantity <= 0) isAchievementEligible = false;
			}
			if (gearStorage.length < 45) isAchievementEligible = false; //Need to have all the storage!
			for (i = 0; i < gearStorage.length; i++) {
				if (gearStorage[i].quantity <= 0) isAchievementEligible = false;
			}
			if (isAchievementEligible) awardAchievement("Item Vault", kACHIEVEMENTS.WEALTH_ITEM_VAULT, true);
		}
			
		public function takeItem(itype:ItemType, nextAction:Function, overrideAbandon:Function = null, source:ItemSlot = null):void {
			if (itype == null) {
				CoC_Settings.error("takeItem(null)");
				return;
			}
			if (itype == ItemType.NOTHING) return;
			if (nextAction != null)
				callNext = nextAction;
			else callNext = playerMenu;
			//Check for an existing stack with room in the inventory and return the value for it.
			var temp:int = player.roomInExistingStack(itype);
			if (temp >= 0) { //First slot go!
				player.itemSlots[temp].quantity++;
				outputText("You place " + itype.longName + " in your " + inventorySlotName[temp] + " pouch, giving you " + player.itemSlots[temp].quantity + " of them.");
				itemGoNext();
				return;
			}
			//If not done, then put it in an empty spot!
			//Throw in slot 1 if there is room
			temp = player.emptySlot();
			if (temp >= 0) {
				player.itemSlots[temp].setItemAndQty(itype, 1);
				if (source != null) player.itemSlots[temp].damage = source.damage;
				else player.itemSlots[temp].damage = 0;
				outputText("You place " + itype.longName + " in your " + inventorySlotName[temp] + " pouch.");
				itemGoNext();
				return;
			}
			if (overrideAbandon != null) //callOnAbandon only becomes important if the inventory is full
				callOnAbandon = overrideAbandon;
			else callOnAbandon = callNext;
			//OH NOES! No room! Call replacer functions!
			takeItemFull(itype, true, source);
		}
		
		public function returnItemToInventory(item:Useable, showNext:Boolean = true):void { //Used only by items that have a sub menu if the player cancels
			if (!debug) {
				if (currentItemSlot == null) {
					takeItem(item, callNext, callNext, null); //Give player another chance to put item in inventory
				}
				else if (currentItemSlot.quantity > 0) { //Add it back to the existing stack
					currentItemSlot.quantity++;
				}
				else { //Put it back in the slot it came from
					currentItemSlot.setItemAndQty(item, 1);
				}
			}
			if (getGame().inCombat) {
				monster.doAI();
				return;
			}
			if (showNext)
				doNext(callNext); //Items with sub menus should return to the inventory screen if the player decides not to use them
			else callNext(); //When putting items back in your stash we should skip to the take from stash menu
		}
		
		//Check to see if anything is stored
		public function hasItemsInStorage():Boolean { return itemAnyInStorage(itemStorage, 0, itemStorage.length); }
		
		public function hasItemInStorage(itype:ItemType):Boolean { return itemTypeInStorage(itemStorage, 0, itemStorage.length, itype); }
		
		public function consumeItemInStorage(itype:ItemType):Boolean {
			temp = itemStorage.length;
			while(temp > 0) {
				temp--;
				if (itemStorage[temp].itype == itype && itemStorage[temp].quantity > 0) {
					itemStorage[temp].quantity--;
					return true;
				}
			}
			return false;
		}
		
		public function giveHumanizer():void {
			if (flags[kFLAGS.TIMES_CHEATED_COUNTER] > 0) {
				clearOutput();
				outputText("<b>I was a cheater until I took an arrow to the knee...</b>");
				getGame().gameOver();
				return;
			}
			clearOutput();
			outputText("I AM NOT A CROOK.  BUT YOU ARE!  <b>CHEATER</b>!\n\n");
			inventory.takeItem(consumables.HUMMUS_, playerMenu);
			flags[kFLAGS.TIMES_CHEATED_COUNTER]++;
		}
		
		public function getMaxSlots():int {
			var slots:int = 3;
			if (player.findPerk(PerkLib.StrongBack) >= 0) slots++;
			if (player.findPerk(PerkLib.StrongBack2) >= 0) slots++;
			slots += player.keyItemv1("Backpack");
			//Constrain slots to between 3 and 10.
			if (slots < 3) slots = 3;
			if (slots > 10) slots = 10;
			return slots;
		}
		public function getOccupiedSlots():int {
			var occupiedSlots:int = 0;
		    for (var i:int = 0; i < player.itemSlots.length; i++) {
				if (!player.itemSlot(i).isEmpty() && player.itemSlot(i).unlocked) occupiedSlots++;
			}
			return occupiedSlots;
		}
		
		//Create a storage slot
		public function createStorage():Boolean {
			if (itemStorage.length >= 16) return false;
			var newSlot:ItemSlot = new ItemSlot();
			itemStorage.push(newSlot);
			return true;
		}
		
		//Clear storage slots
		public function clearStorage():void {
			//Various Errors preventing action
			if (itemStorage == null){
				LOGGER.error("Cannot clear storage because it does not exist.");
			}
			else {
				LOGGER.debug("Attempted to remove {0} storage slots.", itemStorage.length);
				itemStorage.splice(0, itemStorage.length);
			}
		}
		
		public function clearGearStorage():void {
			//Various Errors preventing action
			if (gearStorage == null) {
				LOGGER.error("Cannot clear gear storage because it does not exist.");
			}
			else {
				LOGGER.debug("Attempted to remove {0} gear storage slots.", gearStorage.length);
				gearStorage.splice(0, gearStorage.length);
			}
		}
		
		public function initializeGearStorage():void {
			//Completely empty storage array
			if (gearStorage == null) {
				//TODO refactor this to use clearGearStorage()
				LOGGER.error("Cannot clear gearStorage because storage does not exist.");
			}
			else {
				LOGGER.debug("Attempted to remove {0} gear storage slots.", gearStorage.length);
				gearStorage.splice(0, gearStorage.length);
			}
			//Rebuild a new one!
			var newSlot:ItemSlot;
			while (gearStorage.length < 45) {
				newSlot = new ItemSlot();
				gearStorage.push(newSlot);
			}
		}
		
		private function useItemInInventory(slotNum:int):void {
			clearOutput();
			if (player.itemSlots[slotNum].itype is Useable) {
				var item:Useable = player.itemSlots[slotNum].itype as Useable;
				if (flags[kFLAGS.DELETE_ITEMS] == 1) {
					deleteItemPrompt(item, slotNum);
					return;
				} else if (flags[kFLAGS.DELETE_ITEMS] == 2) {
					deleteItemsPrompt(item, slotNum);
					return;
				}
				if (item.canUse()) { //If an item cannot be used then canUse should provide a description of why the item cannot be used
					if (!debug) player.itemSlots[slotNum].removeOneItem();
					useItem(item, player.itemSlots[slotNum]);
					return;
				}
			}
			else {
				outputText("You cannot use " + player.itemSlots[slotNum].itype.longName + "!\n\n");
			}
			itemGoNext();
		}
		
		private function inventoryCombatHandler():void {
			if (!combat.combatRoundOver()) { //Check if the battle is over.
				outputText("\n\n");
				monster.doAI();
			}
		}
		
		private function deleteItems():void {
			if (flags[kFLAGS.DELETE_ITEMS] == 0) {
				flags[kFLAGS.DELETE_ITEMS]++;
			} else if (flags[kFLAGS.DELETE_ITEMS] == 1) {
				flags[kFLAGS.DELETE_ITEMS]++;
			} else if (flags[kFLAGS.DELETE_ITEMS] == 2) {
				flags[kFLAGS.DELETE_ITEMS] = 0;
			}
			inventoryMenu();
		}
		
		private function deleteItemPrompt(item:Useable, slotNum:int):void {
			clearOutput();
			outputText("Are you sure you want to destroy 1 " + item.shortName + "?  You won't be able to retrieve it!");
			menu();
			addButton(0, "Yes", delete1Item, item, slotNum);
			addButton(1, "No", inventoryMenu);
		}
		
		private function deleteItemsPrompt(item:Useable, slotNum:int):void {
			clearOutput();
			outputText("Are you sure you want to destroy " + player.itemSlots[slotNum].quantity + "x " + item.shortName + "?  You won't be able to retrieve " + (player.itemSlots[slotNum].quantity == 1 ? "it": "them") + "!");
			menu();
			addButton(0, "Yes", deleteItem, item, slotNum);
			addButton(1, "No", inventoryMenu);
		}
		
		public function delete1Item(item:Useable, slotNum:int):void {
			clearOutput();
			outputText("1 " + item.shortName + " has been destroyed.");
			player.destroyItems(item, 1);
			doNext(inventoryMenu);
		}
		
		private function deleteItem(item:Useable, slotNum:int):void {
			clearOutput();
			outputText(player.itemSlots[slotNum].quantity + "x " + item.shortName + " " + (player.itemSlots[slotNum].quantity == 1 ? "has": "have") + " been destroyed.");
			player.destroyItems(item, player.itemSlots[slotNum].quantity);
			doNext(inventoryMenu);
		}
		
		private function useItem(item:Useable, fromSlot:ItemSlot):void {
			item.useText();
			if (item is Armor) {
				player.armor.removeText();
				item = player.setArmor(item as Armor); //Item is now the player's old armor
				if (item == null)
					itemGoNext();
				else takeItem(item, callNext);
			}
			else if (item is Weapon) {
				player.weapon.removeText();
				var temp:ItemSlot = new ItemSlot();
				temp.quantity = - 1;
				temp.damage = flags[kFLAGS.WEAPON_DURABILITY_DAMAGE];
				item = player.setWeapon(item as Weapon); //Item is now the player's old weapon
				flags[kFLAGS.WEAPON_DURABILITY_DAMAGE] = fromSlot != null ? fromSlot.damage : 0; //Set condition accordingly
				if (item == null)
					itemGoNext();
				else takeItem(item, callNext, null, temp);
			}
			else if (item is Jewelry) {
				player.jewelry.removeText();
				item = player.setJewelry(item as Jewelry); //Item is now the player's old jewelry
				if (item == null)
					itemGoNext();
				else takeItem(item, callNext);
			}
			else if (item is Shield) {
				player.shield.removeText();
				item = player.setShield(item as Shield); //Item is now the player's old shield
				if (item == null)
					itemGoNext();
				else takeItem(item, callNext);
			}
			else if (item is Undergarment) {
				if (item["type"] == 0) player.upperGarment.removeText();
				else player.lowerGarment.removeText();
				item = player.setUndergarment(item as Undergarment, item["type"]); //Item is now the player's old shield
				if (item == null)
					itemGoNext();
				else takeItem(item, callNext);
			}
			else {
				currentItemSlot = fromSlot;
				if (!item.useItem()) itemGoNext(); //Items should return true if they have provided some form of sub-menu.
					//This is used for Reducto and GroPlus (which always present the player with a sub-menu)
					//and for the Kitsune Gift (which may show a sub-menu if the player has a full inventory)
//				if (!item.hasSubMenu()) itemGoNext(); //Don't call itemGoNext if there's a sub menu, otherwise it would never be displayed
			}
		}
		
		private function takeItemFull(itype:ItemType, showUseNow:Boolean, source:ItemSlot):void {
			outputText("There is no room for " + itype.longName + " in your inventory.  You may replace the contents of a pouch with " + itype.longName + " or abandon it.");
			menu();
			for (var x:int = 0; x < 10; x++) {
				if (player.itemSlots[x].unlocked)
					addButton(x, (player.itemSlots[x].itype.shortName + " x" + player.itemSlots[x].quantity), replaceItem, itype, x, source);
			}
			if (source != null && source.quantity >= 0) {
				currentItemSlot = source;
				addButton(12, "Put Back", returnItemToInventory, itype, false);
			}
			if (showUseNow && itype is Useable) addButton(13, "Use Now", useItemNow, itype as Useable, source);
			addButton(14, "Abandon", callOnAbandon); //Does not doNext - immediately executes the callOnAbandon function
		}
		
		private function useItemNow(item:Useable, source:ItemSlot = null):void {
			clearOutput();
			if (item.canUse()) { //If an item cannot be used then canUse should provide a description of why the item cannot be used
				useItem(item, source);
			}
			else {
				takeItemFull(item, false, source); //Give the player another chance to take this item
			}
		}
		
		private function replaceItem(itype:ItemType, slotNum:int, source:ItemSlot = null):void {
			clearOutput();
			if (player.itemSlots[slotNum].itype == itype) //If it is the same as what's in the slot...just throw away the new item
				outputText("You discard " + itype.longName + " from the stack to make room for the new one.");
			else { //If they are different...
				if (player.itemSlots[slotNum].quantity == 1) outputText("You throw away " + player.itemSlots[slotNum].itype.longName + " and replace it with " + itype.longName + ".");
				else outputText("You throw away " + player.itemSlots[slotNum].itype.longName + "(x" + player.itemSlots[slotNum].quantity + ") and replace it with " + itype.longName + ".");
				player.itemSlots[slotNum].setItemAndQty(itype, 1);
				if (source != null) player.itemSlots[slotNum].damage = source.damage;
			}
			itemGoNext();
		}
		
		public function armorRackDescription():Boolean {
			if (itemAnyInStorage(gearStorage, 9, 18)) {
				var itemList:Array = [];
				for (var x:int = 9; x < 18; x++)
					if (gearStorage[x].quantity > 0) itemList[itemList.length] = gearStorage[x].itype.longName;
				outputText("  It currently holds " + formatStringArray(itemList) + ".");
				return true;
			}
			return false;
		}
		
		public function weaponRackDescription():Boolean {
			if (itemAnyInStorage(gearStorage, 0, 9)) {
				var itemList:Array = [];
				for (var x:int = 0; x < 9; x++)
					if (gearStorage[x].quantity > 0) itemList[itemList.length] = gearStorage[x].itype.longName;
				outputText("  It currently holds " + formatStringArray(itemList) + ".");
				return true;
			}
			return false;
		}
		
		public function shieldRackDescription():Boolean {
			if (itemAnyInStorage(gearStorage, 36, 45)) {
				var itemList:Array = [];
				for (var x:int = 36; x < 45; x++)
					if (gearStorage[x].quantity > 0) itemList[itemList.length] = gearStorage[x].itype.longName;
				outputText("  It currently holds " + formatStringArray(itemList) + ".");
				return true;
			}
			return false;
		}
		
		public function jewelryBoxDescription():Boolean {
			if (itemAnyInStorage(gearStorage, 18, 27)) {
				var itemList:Array = [];
				for (var x:int = 18; x < 27; x++)
					if (gearStorage[x].quantity > 0) itemList[itemList.length] = gearStorage[x].itype.longName;
				outputText("  It currently holds " + formatStringArray(itemList) + ".");
				return true;
			}
			return false;
		}
		
		public function dresserDescription():Boolean {
			if (itemAnyInStorage(gearStorage, 27, 36)) {
				var itemList:Array = [];
				for (var x:int = 27; x < 36; x++)
					if (gearStorage[x].quantity > 0) itemList[itemList.length] = gearStorage[x].itype.longName;
				outputText("  It currently holds " + formatStringArray(itemList) + ".");
				return true;
			}
			return false;
		}
		
		private function itemAnyInStorage(storage:Array, startSlot:int, endSlot:int):Boolean {
			for (var x:int = startSlot; x < endSlot; x++) {
				if (storage[x] != undefined) if (storage[x].quantity > 0) return true;
			}
			return false;
		}
		
		private function itemTypeInStorage(storage:Array, startSlot:int, endSlot:int, itype:ItemType):Boolean {
			for (var x:int = startSlot; x < endSlot; x++) {
				if (storage[x] != undefined) if (storage[x].quantity > 0 && storage[x].itype == itype) return true;
			}
			return false;
		}
		
		public function removeItemFromStorage(storage:Array, itype:ItemType):void {
			for (var x:int = 0; x < storage.length; x++) {
				if (storage[x] != undefined) {
					if (storage[x].quantity > 0 && storage[x].itype == itype) {
						storage[x].quantity--;
						return;
					}
				}
			}
		}
		
		private function pickItemToTakeFromCampStorage():void {
			callNext = pickItemToTakeFromCampStorage;
			pickItemToTakeFromStorage(itemStorage, 0, itemStorage.length, "storage");
		}
		
		public function manageEquipment():void {
			clearOutput();
			outputText("Which would you like to unequip?\n\n");
			menu();
			if (player.weapon != WeaponLib.FISTS)
				addButton(0, "Weapon", unequipWeapon).hint(player.weapon.description, capitalizeFirstLetter(player.weapon.name));
			else 
				addButtonDisabled(0, "Weapon");
				
			if (player.shield != ShieldLib.NOTHING)
				addButton(1, "Shield", unequipShield).hint(player.shield.description, capitalizeFirstLetter(player.shield.name));
			else
				addButtonDisabled(1, "Shield");
				
			if (player.jewelry != JewelryLib.NOTHING)
				addButton(2, "Accessory", unequipJewel).hint(player.jewelry.description, capitalizeFirstLetter(player.jewelry.name));
			else 
				addButtonDisabled(2, "Accessory");
				
			if (player.armor != ArmorLib.NOTHING)
				addButton(5, "Armour", unequipArmor).hint(player.armor.description, capitalizeFirstLetter(player.armor.name));
			else 
				addButtonDisabled(5, "Armour");
				
			if (player.upperGarment != UndergarmentLib.NOTHING)
				addButton(6, "Upperwear", unequipUpperwear).hint(player.upperGarment.description, capitalizeFirstLetter(player.upperGarment.name));
			else 
				addButtonDisabled(6, "Upperwear");
				
			if (player.lowerGarment != UndergarmentLib.NOTHING)
				addButton(7, "Lowerwear", unequipLowerwear).hint(player.lowerGarment.description, capitalizeFirstLetter(player.lowerGarment.name));
			else 
				addButtonDisabled(7, "Lowerwear");
				
			addButton(14, "Back", inventoryMenu);
		}
		//Unequip!
		private function unequipWeapon():void {
			var temp:ItemSlot = new ItemSlot();
			temp.damage = flags[kFLAGS.WEAPON_DURABILITY_DAMAGE];
			temp.quantity = -1;
			takeItem(player.setWeapon(WeaponLib.FISTS), inventoryMenu, null, temp);
			flags[kFLAGS.WEAPON_DURABILITY_DAMAGE] = 0;
		}
		public function unequipArmor():void {
			if (player.armorName != "goo armor") takeItem(player.setArmor(ArmorLib.NOTHING), inventoryMenu); 
			else { //Valeria belongs in the camp, not in your inventory!
				player.armor.removeText();
				player.setArmor(ArmorLib.NOTHING);
				doNext(manageEquipment);
			}
		}
		public function unequipUpperwear():void {
			takeItem(player.setUndergarment(UndergarmentLib.NOTHING, UndergarmentLib.TYPE_UPPERWEAR), inventoryMenu);
		}
		public function unequipLowerwear():void {
			takeItem(player.setUndergarment(UndergarmentLib.NOTHING, UndergarmentLib.TYPE_LOWERWEAR), inventoryMenu);
		}
		public function unequipJewel():void {
			takeItem(player.setJewelry(JewelryLib.NOTHING), inventoryMenu);
		}
		public function unequipShield():void {
			takeItem(player.setShield(ShieldLib.NOTHING), inventoryMenu);
		}
		
		public function checkKeyItems(countOnly:Boolean = false):Boolean {
			var foundItem:Boolean = false
			var button:int = 0;
			if (!countOnly) menu();
			if (getGame().xmas.xmasMisc.nieveHoliday() && flags[kFLAGS.NIEVE_STAGE] > 0 && flags[kFLAGS.NIEVE_STAGE] < 5) {
				if (!countOnly) {
					if (flags[kFLAGS.NIEVE_STAGE] == 1)
						outputText("\nThere's some odd snow here that you could do something with...\n");
					else
						outputText("\nYou have a snow" + getGame().xmas.xmasMisc.nieveMF("man", "woman") + " here that seems like it could use a little something...\n");
					addButton(button++, "Snow", getGame().xmas.xmasMisc.nieveBuilding);
				}
				foundItem = true;
			}
			if (flags[kFLAGS.FUCK_FLOWER_KILLED] == 0 && flags[kFLAGS.FUCK_FLOWER_LEVEL] >= 1) {
				if (!countOnly) {
					if (flags[kFLAGS.FUCK_FLOWER_LEVEL] == 4) outputText("\nHolli is in her tree at the edges of your camp.  You could go visit her if you want.\n");
					addButton(button++, (flags[kFLAGS.FUCK_FLOWER_LEVEL] >= 3 ? "Tree" : "Plant"), getGame().holliScene.treeMenu);
				}
				foundItem = true;
			}
			if (player.hasKeyItem("Dragon Egg") >= 0) {
				if (!countOnly) {
					getGame().emberScene.emberCampDesc();
					addButton(button++, "Egg", getGame().emberScene.emberEggInteraction);
				}
				foundItem = true;
			}
			if (player.hasKeyItem("Tamani's Satchel") >= 0) {
				if (!countOnly) {
					addButton(button++, "Satchel", getGame().forest.tamaniScene.openTamanisSatchel);
				}
				foundItem = true;
			}
			if (player.hasKeyItem("Feathery hair-pin") >= 0) {
				if (!countOnly) {
					var benoitPinDesc:String;
					benoitPinDesc = "The feathery hair-pin " + getGame().bazaar.benoit.benoitMF("Benoit", "Benoite") + " gave to you as a present.";
					addButton(button++, "F. Hairpin", getGame().bazaar.benoit.equipUnequipHairPin).hint(benoitPinDesc, "Feathery Hair-pin");
				}
				foundItem = true;
			}
			if (!countOnly) addButton(14, "Back", inventoryMenu);
			return foundItem;
		}
		
		//Pick item to take from storage
		private function pickItemToTakeFromShieldRack():void {
			callNext = pickItemToTakeFromShieldRack;
			pickItemToTakeFromStorage(gearStorage, 36, 45, "rack");
		}
		
		private function pickItemToTakeFromArmorRack():void {
			callNext = pickItemToTakeFromArmorRack;
			pickItemToTakeFromStorage(gearStorage, 9, 18, "rack");
		}
		
		private function pickItemToTakeFromWeaponRack():void {
			callNext = pickItemToTakeFromWeaponRack;
			pickItemToTakeFromStorage(gearStorage, 0, 9, "rack");
		}
		
		public function pickItemToTakeFromJewelryBox():void {
			callNext = pickItemToTakeFromJewelryBox;
			pickItemToTakeFromStorage(gearStorage, 18, 27, "box");
		}
		
		public function pickItemToTakeFromDresser():void {
			callNext = pickItemToTakeFromDresser;
			pickItemToTakeFromStorage(gearStorage, 27, 36, "dresser");
		}
		
		private function pickItemToTakeFromStorage(storage:Array, startSlot:int, endSlot:int, text:String):void {
			clearOutput(); //Selects an item from a gear slot. Rewritten so that it no longer needs to use numbered events
			hideUpDown();
			if (!itemAnyInStorage(storage, startSlot, endSlot)) { //If no items are left then return to the camp menu. Can only happen if the player removes the last item.
				playerMenu();
				return;
			}
			outputText("What " + text + " slot do you wish to take an item from?");
			var button:int = 0;
			menu();
			for (var x:int = startSlot; x < endSlot; x++, button++) {
				if (storage[x].quantity > 0) addButton(button, (storage[x].itype.shortName + " x" + storage[x].quantity), pickFrom, storage, x);
			}
			addButton(14, "Back", stash);
		}
		
		private function pickFrom(storage:Array, slotNum:int):void {
			clearOutput();
			var itype:ItemType = storage[slotNum].itype;
			storage[slotNum].quantity--;
			inventory.takeItem(itype, callNext, callNext, storage[slotNum]);
		}
		
		//Pick items to place in storage
		private function pickItemToPlaceInCampStorage():void { pickItemToPlaceInStorage(placeInCampStorage, allAcceptable, "storage containers", false); }
		
		private function pickItemToPlaceInArmorRack():void { pickItemToPlaceInStorage(placeInArmorRack, armorAcceptable, "armor rack", true); }
		
		private function pickItemToPlaceInWeaponRack():void { pickItemToPlaceInStorage(placeInWeaponRack, weaponAcceptable, "weapon rack", true); }

		private function pickItemToPlaceInShieldRack():void { pickItemToPlaceInStorage(placeInShieldRack, shieldAcceptable, "shield rack", true); }
		
		public function pickItemToPlaceInJewelryBox():void { pickItemToPlaceInStorage(placeInJewelryBox, jewelryAcceptable, "jewelry box", true); }
		
		public function pickItemToPlaceInDresser():void { pickItemToPlaceInStorage(placeInDresser, undergarmentAcceptable, "dresser", true); }
		
		//Acceptable type of items
		private function allAcceptable(itype:ItemType):Boolean { return true; }
		
		private function armorAcceptable(itype:ItemType):Boolean { return itype is Armor; }
		
		private function weaponAcceptable(itype:ItemType):Boolean { return itype is Weapon; }

		private function shieldAcceptable(itype:ItemType):Boolean { return itype is Shield; }
		
		private function jewelryAcceptable(itype:ItemType):Boolean { return itype is Jewelry; }
		
		private function undergarmentAcceptable(itype:ItemType):Boolean { return itype is Undergarment; }
		
		//Place in storage functions
		private function pickItemToPlaceInStorage(placeInStorageFunction:Function, typeAcceptableFunction:Function, text:String, showEmptyWarning:Boolean):void {
			clearOutput(); //Selects an item to place in a gear slot. Rewritten so that it no longer needs to use numbered events
			hideUpDown();
			outputText("What item slot do you wish to empty into your " + text + "?");
			menu();
			var foundItem:Boolean = false;
			for (var x:int = 0; x < 10; x++) {
				if (player.itemSlots[x].unlocked && player.itemSlots[x].quantity > 0 && typeAcceptableFunction(player.itemSlots[x].itype)) {
					addButton(x, (player.itemSlots[x].itype.shortName + " x" + player.itemSlots[x].quantity), placeInStorageFunction, x);
					foundItem = true;
				}
			}
			if (showEmptyWarning && !foundItem) outputText("\n<b>You have no appropriate items to put in this " + text + ".</b>");
			addButton(14, "Back", stash);
		}
		
		private function placeInCampStorage(slotNum:int):void {
			placeIn(itemStorage, 0, itemStorage.length, slotNum);
			doNext(pickItemToPlaceInCampStorage);
		}
		
		private function placeInArmorRack(slotNum:int):void {
			placeIn(gearStorage, 9, 18, slotNum);
			doNext(pickItemToPlaceInArmorRack);
		}
		
		private function placeInWeaponRack(slotNum:int):void {
			placeIn(gearStorage, 0, 9, slotNum);
			doNext(pickItemToPlaceInWeaponRack);
		}
		
		private function placeInShieldRack(slotNum:int):void {
			placeIn(gearStorage, 36, 45, slotNum);
			doNext(pickItemToPlaceInShieldRack);
		}
		
		private function placeInJewelryBox(slotNum:int):void {
			placeIn(gearStorage, 18, 27, slotNum);
			doNext(pickItemToPlaceInJewelryBox);
		}
		
		private function placeInDresser(slotNum:int):void {
			placeIn(gearStorage, 27, 36, slotNum);
			doNext(pickItemToPlaceInDresser);
		}
		
		private function placeIn(storage:Array, startSlot:int, endSlot:int, slotNum:int):void {
			clearOutput();
			var x:int;
			var temp:int;
			var itype:ItemType = player.itemSlots[slotNum].itype;
			var qty:int = player.itemSlots[slotNum].quantity;
			var orig:int = qty;
			player.itemSlots[slotNum].emptySlot();
			for (x = startSlot; x < endSlot && qty > 0; x++) { //Find any slots which already hold the item that is being stored
				if (storage[x].itype == itype && storage[x].quantity < itype.getMaxStackSize()) {
					temp = itype.getMaxStackSize() - storage[x].quantity;
					if (qty < temp) temp = qty;
					outputText("You add " + temp + "x " + itype.shortName + " into storage slot " + num2Text(x + 1 - startSlot) + ".\n");
					storage[x].quantity += temp;
					qty -= temp;
					if (qty == 0) return;
				}
			}
			for (x = startSlot; x < endSlot && qty > 0; x++) { //Find any empty slots and put the item(s) there
				if (storage[x].quantity == 0) {
					storage[x].setItemAndQty(itype, qty);
					outputText("You place " + qty + "x " + itype.shortName + " into storage slot " + num2Text(x + 1 - startSlot) + ".\n");
					qty = 0;
					return;
				}
			}
			outputText("There is no room for " + (orig == qty ? "" : "the remaining ") + qty + "x " + itype.shortName + ".  You leave " + (qty > 1 ? "them" : "it") + " in your inventory.\n");
			player.itemSlots[slotNum].setItemAndQty(itype, qty);
		}
		
		public function generateInventoryTooltip(slot:ItemSlot):String {
			var tt:String = slot.itype.description;
			if (slot.itype.isDegradable()) {
				tt += "\nDurability: " + (slot.itype.durability - slot.damage) + "/" + slot.itype.durability;
			}
			return tt;
		}
		
		public function serialize(relativeRootObject:*):void 
		{
			relativeRootObject.itemStorage = [];
			serializeItemStorage(relativeRootObject.itemStorage);
		}
		
		private function serializeItemStorage(saveFileItemStorage:*):void
		{
			LOGGER.debug("Serializing {0} slots in itemStorage...", itemStorage.length);
			for (var i:int = 0; i < itemStorage.length; i++)
			{
				if (itemStorage[i].itype == null) {
					saveFileItemStorage.push(null);
				} else {
					saveFileItemStorage.push([]);
					SerializationUtils.serialize(saveFileItemStorage[i], itemStorage[i]);
				}
			}
		}
		
		public function deserialize(relativeRootObject:*):void 
		{
			deserializeItemStorage(relativeRootObject.itemStorage);
		}
		
		private function deserializeItemStorage(saveFileItemStorage:*):void
		{
			LOGGER.debug("Deserializing {0} slots from itemStorage...", saveFileItemStorage.length);
			for (var i:int = 0; i < saveFileItemStorage.length; i++)
			{
				createStorage();
				var storage:ItemSlot = this.itemStorage[i];
				var savedIS:* = saveFileItemStorage[i];
				
				if (savedIS.quantity>0) {
					SerializationUtils.deserialize(savedIS, storage);
				} else {
					storage.emptySlot();
				}
			}
		}
		
		public function upgradeSerializationVersion(relativeRootObject:*, serializedDataVersion:int):void 
		{
			switch (serializedDataVersion) {
				case 0:
					upgradeLegacyItemStorage(relativeRootObject);
				
				default:
					/*
					 * The default block is left empty intentionally,
					 * this switch case operates by using fall through behavior.
					 */
			}
		}
		
		private function upgradeLegacyItemStorage(relativeRootObject:*):void
		{
			LOGGER.info("Upgrading legacy item storage");
			
			if (relativeRootObject.itemStorage === undefined) {
				relativeRootObject.itemStorage  = [];
			}
		}
		
		public function currentSerializationVerison():int 
		{
			return SERIALIZATION_VERSION;
		}
		
		public function serializationUUID():String 
		{
			return SERIALIZATION_UUID;
		}
	}
}
