package classes.internals 
{
	import classes.CoC;
	import classes.GlobalFlags.kGAMECLASS;
	import classes.helper.StageLocator;
	import flash.errors.IllegalOperationError;
	import mx.logging.ILogger;
	
	/**
	 * This class provides a CoC instance for tests.
	 */
	public class CocBuilder 
	{
		private static const LOGGER:ILogger = LoggerFactory.getLogger(CocBuilder);
		private static const PERM_OBJECT_FILENAME:String = "TestPermObject";
		
		private static var instance:CoC;
		
		public function CocBuilder()
		{
			throw IllegalOperationError("This class cannot be instantiated");
		}
		
		private static function createNewInstance():void
		{
			LOGGER.debug("Creating new CoC test instance...");
			instance = new CoC(StageLocator.stage);
			
			// so the achievments are not reset if you play the game on the developer machine
			instance.saves.setPermObjectFilename(PERM_OBJECT_FILENAME);
		}
		
		/**
		 * Create a new instance of the CoC test class.
		 */
		public static function resetInstance():void
		{
			LOGGER.debug("Resetting instance...");
			createNewInstance();
		}
		
		/**
		 * Create a CoC instance and set the game's perm object to a test filename.
		 * Assigns the instance to kGAMECLASS
		 * @return the created instance
		 */
		public static function getInstance(): CoC
		{
			if (instance === null) {
				createNewInstance();
			}
			
			return instance;
		}
	}
}
