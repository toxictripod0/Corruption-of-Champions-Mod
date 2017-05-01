package classes.internals 
{
	import flash.errors.IllegalOperationError;
	/**
	 * A class providing utility methods to make serialization and deserialization easier.
	 */
	public class SerializationUtils 
	{
		public function SerializationUtils() 
		{
			throw new IllegalOperationError("This class cannot be instantiated");
		}
		
		/**
		 * Serializes a Vector into an array.
		 * @param	vector to serialize
		 * @return a array containing the serialized vector
		 */
		public static function serializeVector(vector:Vector.<Serializable>):Array {
			var serialized:* = [];
			
			for each(var element:Serializable in vector) {
				var obj:Object = new Object();
				serialized.push(obj);
				
				element.serialize(obj);
			}
			
			return serialized;
		}
		
		
		/**
		 * Serializes a Vector into an array using AMF.
		 * @param	vector to serialize
		 * @return a array containing the serialized vector
		 */
		public static function serializeVectorWithAMF(vector:Vector.<SerializableAMF>):Array {
			var serialized:* = [];
			
			for each(var element:SerializableAMF in vector) {
				serialized.push(element);
			}
			
			return serialized;
		}
	}
}
