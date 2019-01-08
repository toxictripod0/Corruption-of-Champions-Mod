package classes
{
	/**
	 * Stores a key item the player has acquired.
	 * Has 4 value properties to store additional data.
	 */
	public class KeyItem extends Object
	{
		/**
		 * Identifies the key item.
		 */
		public var keyName:String = "";
		
		//v1-v4 for storing extra stuff.
		public var value1:Number = 0;
		public var value2:Number = 0;
		public var value3:Number = 0;
		public var value4:Number = 0;
	}
}
