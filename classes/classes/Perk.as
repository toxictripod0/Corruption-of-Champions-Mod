package classes
{
	/**
	 * Stores a perk type and additional values for a perk.
	 */
	public class Perk
	{
		/**
		 * Create a new Perk with the initial values given in the constructor.
		 * 
		 * @param	perk identifies what perk this is
		 * @param	value1 additional data for this perk, depends on the perk type
		 * @param	value2 additional data for this perk, depends on the perk type
		 * @param	value3 additional data for this perk, depends on the perk type
		 * @param	value4 additional data for this perk, depends on the perk type
		 */
		public function Perk(perk:PerkType,value1:Number=0,value2:Number=0,value3:Number=0,value4:Number=0)
		{
			_ptype = perk;
			this.value1 = value1;
			this.value2 = value2;
			this.value3 = value3;
			this.value4 = value4;
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
