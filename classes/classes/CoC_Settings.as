package classes 
{
	import classes.internals.LoggerFactory;
	import mx.logging.ILogger;
	/**
	 * ...
	 * @author Fake-Name
	 */
	public class CoC_Settings
	{
		private static const LOGGER:ILogger = LoggerFactory.getLogger(CoC_Settings);

		public static var debugBuild:Boolean = true;
		public static var charviewEnabled:Boolean = CONFIG::debug;

		// Horrible static abuse FTW
		public static var haltOnErrors:Boolean = false;
		public static var buttonEvents:Array = [];
		private static const bufferSize:int = 50;

		/**
		 * trace("ERROR "+description);
		 * If haltOnErrors=true, throws Error
		 */
		public static function error(description:String=""):void {
			LOGGER.error("ERROR "+description);
			if (haltOnErrors) throw Error(description);
		}

		/**
		 * trace("ERROR Abstract method call: "+clazz+"."+method+"(). "+description);
		 * If haltOnErrors=true, throws Error
		 */
		public static function errorAMC(clazz:String,method:String,description:String=""):void{
			error("Abstract method call: "+clazz+"."+method+"(). "+description);
		}
		
		public static function appendButtonEvent(inString:String):void
		{
			
			CoC_Settings.buttonEvents.unshift(inString);  // Push the new item onto the head of the array

			if (CoC_Settings.buttonEvents.length > CoC_Settings.bufferSize)  // if the array has become too long, pop the last item
			{
				CoC_Settings.buttonEvents.pop();
			}
		}
		public static function getButtonEvents():String
		{
			var retStr:String = "";
			for (var x:String in CoC_Settings.buttonEvents)
			{
				retStr += CoC_Settings.buttonEvents[x] + "\n";
				if (debugBuild) LOGGER.debug("x = ", x, "Array Val = ", CoC_Settings.buttonEvents[x]);
			}
			return retStr;
		}
		
		public function CoC_Settings()
		{

		}
		
	}

}