package classes.internals 
{
	import classes.CoC;
	import classes.GlobalFlags.kGAMECLASS;
	import classes.helper.StageLocator;
	import flash.errors.IllegalOperationError;
	
	/**
	 * This class provides a CoC instance for tests.
	 */
	public class CocBuilder 
	{
		private static const PERM_OBJECT_FILENAME:String = "TestPermObject";
		
		public function CocBuilder()
		{
			throw IllegalOperationError("This class cannot be instantiated");
		}
		
		/**
		 * Create a CoC instance and set the game's perm object to a test filename.
		 * Assigns the instance to kGAMECLASS
		 * @return the created instance
		 */
		public static function getInstance(): CoC
		{
			var instance:CoC = new CoC(StageLocator.stage);
			
			// so the achievments are not reset if you play the game on the developer machine
			instance.saves.setPermObjectFilename(PERM_OBJECT_FILENAME);
			
			return instance;
		}
	}
}
