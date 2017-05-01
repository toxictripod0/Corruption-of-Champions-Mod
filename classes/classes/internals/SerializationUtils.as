package classes.internals 
{
	import classes.Items.Armors.Nothing;
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
		 * Deserializes a Array into a Vector of Serializable
		 * @param	serializedVector an Array containing the serialized vector
		 * @param	type of the serialized Vector
		 * @return a deserialized Vector
		 */
		public static function deserializeVector(serializedVector:Array, type:Class):Vector.<Serializable> {
			// 'is' will only work on an instance
			if (!(new type() is Serializable)) {
				throw new ArgumentError("Type must implement Serializable");
			}
			
			var deserialized:Vector.<Serializable> = new Vector.<Serializable>();
			
			for each(var element:Object in serializedVector) {
				var instance:Serializable = new type();
				instance.deserialize(element)
				deserialized.push(instance);
			}
			
			return deserialized;
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
