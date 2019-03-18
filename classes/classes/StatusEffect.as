package classes
{
import classes.GlobalFlags.kGAMECLASS;
import classes.internals.LoggerFactory;
import classes.internals.Serializable;
import classes.internals.Utils;
import mx.logging.ILogger;

	public class StatusEffect extends Utils implements Serializable
	{
		private static const LOGGER:ILogger = LoggerFactory.getLogger(StatusEffect);
		private static const SERIALIZATION_VERSION:int = 1;
		
		/**
		 * Create a new StatusEffect. The type for a no-arg constructor is null,
		 * this is so serialization code can create instances.
		 * Note that the type cannot be changed after the instance is created (with the exception of
		 * serialization code).
		 * @param	stype the type of the StatusEffect
		 */
		public function StatusEffect(stype:StatusEffectType = null)
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
		public var dataStore:Object = null;
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
			// do nothing
		}
		/**
		 * Called when the effect is removed from the creature, after removing from its list of effects.
		 */
		public function onRemove():void {
			// do nothing
		}
		/**
		 * Called after combat in player.clearStatuses()
		 */
		public function onCombatEnd():void {
			// do nothing
		}
		/**
		 * Called during combat in combatStatusesUpdate() for player, then for monster
		 */
		public function onCombatRound():void {
			// do nothing
		}
		public function remove(/*fireEvent:Boolean = true*/):void {
			if (_host == null) return;
			_host.removeStatusEffectInstance(this/*,fireEvent*/);
			_host = null;
		}
		public function removedFromHostList(fireEvent:Boolean):void {
			if (fireEvent) onRemove();
			_host = null;
		}
		/**
		 * Called when a status effect is added to a Creature. Fires the onAttach event if enabled.
		 * @param	host the Creature the status effect is applied to
		 * @param	fireEvent if true, the onAttach event will be fired when the effect is added
		 */
		public function addedToHostList(host:Creature,fireEvent:Boolean):void {
			_host = host;
			if (fireEvent) onAttach();
		}
		public function attach(host:Creature/*,fireEvent:Boolean = true*/):void {
			if (_host == host) return;
			if (_host != null) remove();
			_host = host;
			host.addStatusEffect(this/*,fireEvent*/);
		}
		
		public function serialize(relativeRootObject:*):void 
		{
			relativeRootObject.statusAffectName = _stype.id;
			
			relativeRootObject.value1 = value1;
			relativeRootObject.value2 = value2;
			relativeRootObject.value3 = value3;
			relativeRootObject.value4 = value4;
			
			if (dataStore !== null) {
				relativeRootObject.dataStore = dataStore;
			}
		}
		
		public function deserialize(relativeRootObject:*):void 
		{
			_stype = StatusEffectType.lookupStatusEffect(relativeRootObject.statusAffectName);
			
			value1 = relativeRootObject.value1;
			value2 = relativeRootObject.value2;
			value3 = relativeRootObject.value3;
			value4 = relativeRootObject.value4;
			
			if (relativeRootObject.dataStore !== undefined) {
				dataStore = relativeRootObject.dataStore;
			}
		}
		
		public function upgradeSerializationVersion(relativeRootObject:*, serializedDataVersion:int):void 
		{
			
		}
		
		public function currentSerializationVerison():int 
		{
			return SERIALIZATION_VERSION;
		}

		protected static function register(id:String,statusEffectClass:Class,arity:int=0):StatusEffectType {
			return new StatusEffectType(id,statusEffectClass || StatusEffect,arity);
		}
		protected static function get game():CoC {
			return kGAMECLASS;
		}
	}
}
