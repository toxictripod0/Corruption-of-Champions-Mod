package classes
{
	import classes.internals.Serializable;
	/**
	 * Stores a key item the player has acquired.
	 * Has 4 value properties to store additional data.
	 */
	public class KeyItem extends Object implements Serializable
	{
		private static const SERIALIZATION_VERSION:int = 1;
		
		/**
		 * Identifies the key item.
		 */
		public var keyName:String = "";
		
		//v1-v4 for storing extra stuff.
		public var value1:Number = 0;
		public var value2:Number = 0;
		public var value3:Number = 0;
		public var value4:Number = 0;
		
		public function serialize(relativeRootObject:*):void 
		{
			relativeRootObject.keyName = this.keyName;
			
			relativeRootObject.value1 = this.value1; 
			relativeRootObject.value2 = this.value2; 
			relativeRootObject.value3 = this.value3; 
			relativeRootObject.value4 = this.value4; 
		}
		
		public function deserialize(relativeRootObject:*):void 
		{
			this.keyName = relativeRootObject.keyName;
			
			this.value1 = relativeRootObject.value1;
			this.value2 = relativeRootObject.value2;
			this.value3 = relativeRootObject.value3;
			this.value4 = relativeRootObject.value4;
		}
		
		public function upgradeSerializationVersion(relativeRootObject:*, serializedDataVersion:int):void 
		{
			
		}
		
		public function currentSerializationVerison():int 
		{
			return SERIALIZATION_VERSION;
		}
	}
}
