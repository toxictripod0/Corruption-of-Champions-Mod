package classes.internals 
{
	
	/**
	 * Interface for serialization and de-serialization.
	 * This is used to store class state in an object, so it can be persisted either
	 * to a shared object or file.
	 * The interface also provides a function to reverse the process.
	 */
	public interface Serializable 
	{
		/**
		 * Serialize a class so it can be stored. Any state that is not serialized will be lost and replace with the
		 * default value on deserialization.
		 * The variables need to be stored manually. If you only have primitive public variables, use AMF directly and SerializeAMF for Vectors for simpler
		 * serialization.
		 * The class is responsible for initalizing its storage by creating an empty arrary.
		 * 
		 * e.g.:
		 * relativeRootObject.foo = intValue;
		 * relativeRootObject.bar = StringValue;
		 * this.complexObject.serialize(relativeRootObject.baz);
		 * 
		 * @param	relativeRootObject the object this class should write to 
		 */
		function serialize(relativeRootObject:*):void;
		
		/**
		 * Deserialize a class, restoring it's state. Deserialization requires some form of default constructor, this can be achieved
		 * with all parameters having a default value.
		 * Objects stored with AMF have to be restored in Saves.as.
		 * 
		 * @param	relativeRootObject the object this class should read from
		 */
		function deserialize(relativeRootObject:*):void;
	}
}
