package classes
{
	public class StatusEffectClass extends BaseContent
	{
		//constructor
		public function StatusEffectClass(stype:StatusEffectType)
		{
			this._stype = stype;
		}
		//data
		private var _stype:StatusEffectType;
		private var _host:Creature;
		public var value1:Number = 0;
		public var value2:Number = 0;
		public var value3:Number = 0;
		public var value4:Number = 0;
		//MEMBER FUNCTIONS
		public function get stype():StatusEffectType
		{
			return _stype;
		}
		public function get host():Creature
		{
			return _host;
		}
		/**
		 * Returns null if host is not a Player
		 */
		public function get playerHost():Player {
			return _host as Player;
		}

		public function toString():String
		{
			return "["+_stype+","+value1+","+value2+","+value3+","+value4+"]";
		}
		// ==============================
		// EVENTS - to be overridden in subclasses
		// ===============================

		/**
		 * Called when the effect is applied to the creature, after adding to its list of effects.
		 */
		public function onAttach():void {

		}
		/**
		 * Called when the effect is removed from the creature, after removing from its list of effects.
		 */
		public function onRemove():void {

		}
		public function onCombatEnd():void {

		}
		public function remove(fireEvent:Boolean = true):void {
			_host.removeStatusEffectInstance(this,fireEvent);
		}
		public function attach(host:Creature,fireEvent:Boolean = true):void {
			_host = host;
			host.addStatusEffect(this,fireEvent);
		}

		protected static function register(id:String,statusEffectClass:Class = null):StatusEffectType {
			return new StatusEffectType(id,statusEffectClass || StatusEffectClass);
		}
	}
}