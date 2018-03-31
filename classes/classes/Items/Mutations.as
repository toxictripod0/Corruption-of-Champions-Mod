package classes.Items
{
	import classes.*;
	import classes.BodyParts.*;
	import classes.GlobalFlags.kFLAGS;

	/**
	 * This class performs the various mutations on the player, transforming one or more
	 * aspects of their appearance.
	 */
	public final class Mutations extends MutationsHelper
	{
		private static var _instance:Mutations = new Mutations();

		public function Mutations()
		{
			if (_instance !== null)
			{
				throw new Error("Mutations can only be accessed through Mutations.init()");
			}
		}

		public static function init():Mutations { return _instance; }
	}
}
