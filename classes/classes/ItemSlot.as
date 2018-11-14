package classes
{
	import classes.internals.Serializable;
	
	public class ItemSlot extends Object implements Serializable
	{
		private static const SERIALIZATION_VERSION:int = 1;
		
		private static const LEGACY_SHORTNAME_GROPLUS:String = "Gro+";
		private static const LEGACY_SHORTNAME_SPECIAL_HONEY:String = "Sp Honey";
		
		private var _quantity:int = 0;
		private var _itype:ItemType = ItemType.NOTHING;
		private var _unlocked:Boolean = false;
		private var _damage:int = 0; //Used for durability
		
		public function setItemAndQty(itype:ItemType, quant:int):void
		{
			if (itype == null) itype = ItemType.NOTHING;
			if (quant == 0 && itype == ItemType.NOTHING) {
				emptySlot();
				return;
			}
			if (quant<0 || quant == 0 && itype != ItemType.NOTHING || quant>0 && itype == ItemType.NOTHING){
				CoC_Settings.error("Inconsistent setItemAndQty call: "+quant+" "+itype);
				quant = 0;
				itype = ItemType.NOTHING;
			}
			this._quantity = quant;
			this._itype = itype;
		}
		

		public function emptySlot():void
		{
			this._quantity = 0;
			this._itype = ItemType.NOTHING;
		}

		public function removeOneItem():void
		{
			if (this._quantity == 0)
				CoC_Settings.error("Tried to remove item from empty slot!");
			if (this._quantity > 0)
				this._quantity -= 1;

			if (this._quantity == 0)
				this._itype = ItemType.NOTHING;
		}

		public function get quantity():int {
			return _quantity;
		}
		public function set quantity(value:int):void {
			if (value > 0 && _itype == null) CoC_Settings.error("ItemSlot.quantity set with no item; use setItemAndQty instead!");
			if (value == 0) _itype = ItemType.NOTHING;
			_quantity = value;
		}

		public function get itype():ItemType {
			return _itype;
		}

		public function get unlocked():Boolean {
			return _unlocked;
		}
		public function set unlocked(value:Boolean):void {
			if (_unlocked != value){
				emptySlot();
			}
			_unlocked = value;
		}
		
		public function isEmpty():Boolean
		{
			return _quantity<=0;
		}
		
		public function serialize(relativeRootObject:*):void 
		{
			relativeRootObject.quantity = this._quantity;
			relativeRootObject.id = this.itype.id;
			relativeRootObject.unlocked = this._unlocked;
			relativeRootObject.damage = this._damage;
		}
		
		public function deserialize(relativeRootObject:*):void 
		{
			this._quantity = relativeRootObject.quantity;
			this._itype = ItemType.lookupItem(relativeRootObject.id);
			this._unlocked = relativeRootObject.unlocked;
			this._damage = relativeRootObject.damage;
		}
		
		public function upgradeSerializationVersion(relativeRootObject:*, serializedDataVersion:int):void 
		{
			switch (serializedDataVersion) {
				case 0:
					convertLegacyShortNameToId(relativeRootObject);
					
				default:
					/*
					 * The default block is left empty intentionally,
					 * this switch case operates by using fall through behavior.
					 */
			}
		}
		
		private function convertLegacyShortNameToId(relativeRootObject:*):void
		{
			if (!relativeRootObject.shortName) {
				return;
			}
			
			if (relativeRootObject.shortName.indexOf("Gro+") != -1) {
				relativeRootObject.id = "GroPlus";
			} else if (relativeRootObject.shortName.indexOf("Sp Honey") != -1) {
				relativeRootObject.id = "SpHoney";
			} else {
				relativeRootObject.id = ItemType.lookupItemByShort(relativeRootObject.shortName).id;
			}
		}
		
		public function currentSerializationVerison():int 
		{
			return SERIALIZATION_VERSION;
		}
		
		public function set damage(value:int):void {
			this._damage = value;
		}
		public function get damage():int {
			return this._damage;
		}
	}
}
