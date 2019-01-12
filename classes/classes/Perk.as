package classes
{
	import classes.Perks.Nothing;
	import classes.internals.Serializable;
	/**
	 * Stores a perk type and additional values for a perk.
	 */
	public class Perk implements Serializable
	{
		private static const SERIALIZATION_VERSION:int = 1;
		
		public static const NOTHING:PerkType = new Nothing();
		
		/**
		 * Create a new Perk with the initial values given in the constructor.
		 * 
		 * @param	perk identifies what perk this is
		 * @param	value1 additional data for this perk, depends on the perk type
		 * @param	value2 additional data for this perk, depends on the perk type
		 * @param	value3 additional data for this perk, depends on the perk type
		 * @param	value4 additional data for this perk, depends on the perk type
		 */
		public function Perk(perk:PerkType = null,value1:Number=0,value2:Number=0,value3:Number=0,value4:Number=0)
		{
			if (perk === null)
			{
				perk = NOTHING;
			}
			
			_ptype = perk;
			this.value1 = value1;
			this.value2 = value2;
			this.value3 = value3;
			this.value4 = value4;
		}
		
		public function serialize(relativeRootObject:*):void 
		{
			relativeRootObject.id = _ptype.id;
			
			relativeRootObject.value1 = value1;
			relativeRootObject.value2 = value2;
			relativeRootObject.value3 = value3;
			relativeRootObject.value4 = value4;
		}
		
		public function deserialize(relativeRootObject:*):void 
		{
			_ptype = PerkType.lookupPerk(relativeRootObject.id);
			
			value1 = relativeRootObject.value1;
			value2 = relativeRootObject.value2;
			value3 = relativeRootObject.value3;
			value4 = relativeRootObject.value4;
		}
		
		public function upgradeSerializationVersion(relativeRootObject:*, serializedDataVersion:int):void 
		{
			
		}
		
		public function currentSerializationVerison():int 
		{
			return SERIALIZATION_VERSION;
		}
		
		private var _ptype:PerkType;
		public var value1:Number;
		public var value2:Number;
		public var value3:Number;
		public var value4:Number;

		public function get ptype():PerkType
		{
			return _ptype;
		}

		public function get perkName():String
		{
			return _ptype.name;
		}

		public function get perkDesc():String
		{
			return _ptype.desc(this);
		}

		public function get perkLongDesc():String
		{
			return _ptype.longDesc;
		}
	}
}
