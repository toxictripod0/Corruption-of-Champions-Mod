package classes.Scenes.NPCs 
{
    import classes.internals.Serializable;
    import mx.logging.ILogger;
    import classes.internals.LoggerFactory;
    import flash.utils.Dictionary;
    import classes.internals.SerializationUtils;

    /**
     * Stores all NPCs. Eventually.
     */
    public class NpcContainer implements Serializable {
        private static const LOGGER:ILogger = LoggerFactory.getLogger(NpcContainer);
        private static const SERIALIZATION_VERSION:int = 1;

		/**
		 * Setting instance to private until it is clear how persistent NPCs should be handled (HP reset after combat, new game, status effects).
		 * Not using constructor because a const cannot be assigned in the constructor.
		 */
		private const jojo:Jojo = new Jojo();

		public function serialize(relativeRootObject:*):void 
		{
			var npcs:Object = relativeRootObject.npcs;
			
			SerializationUtils.serialize(npcs.jojo, new Jojo());
		}
		
		public function deserialize(relativeRootObject:*):void 
		{
			var npcs:Object = relativeRootObject.npcs;

			SerializationUtils.deserialize(npcs.jojo, new Jojo());
		}
		
		public function upgradeSerializationVersion(relativeRootObject:*, serializedDataVersion:int):void 
		{
			switch(serializedDataVersion) {
				case 0:
					upgradeLegacyFormat(relativeRootObject);

				default:
					/*
					 * The default block is left empty intentionally,
					 * this switch case operates by using fall through behavior.
					 */
			}
		}

		private function upgradeLegacyFormat(relativeRootObject:Object): void
		{
			LOGGER.debug("Converting npc storage from legacy save");
			
			if (relativeRootObject.npcs == undefined) {
				LOGGER.debug("NPC store is missing, creating a empty one...");
				relativeRootObject.npcs = [];
			}
				
			if (relativeRootObject.npcs.jojo === undefined) {
				LOGGER.debug("Jojo's NPC store is missing, creating...");
				relativeRootObject.npcs.jojo = [];
			}
		}
		
		public function currentSerializationVerison():int 
		{
			return SERIALIZATION_VERSION;
		}
    }
}
