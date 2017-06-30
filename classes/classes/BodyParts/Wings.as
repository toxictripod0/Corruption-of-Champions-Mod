package classes.BodyParts 
{
	/**
	 * Container class for the players wings
	 * @since May 01, 2017
	 * @author Stadler76
	 */
	public class Wings
	{
		include "../../../includes/appearanceDefs.as";

		public var type:Number  = WING_TYPE_NONE;
		public var color:String = "no";

		public function Wings() {}

		public function restore():void
		{
			type  = WING_TYPE_NONE;
			color = "no";
		}

		public function setProps(p:Object):void
		{
			if (p.hasOwnProperty('type'))  type  = p.type;
			if (p.hasOwnProperty('color')) color = p.color;
		}

		public function setAllProps(p:Object):void
		{
			restore();
			setProps(p);
		}

		public function canDye():Boolean
		{
			return [WING_TYPE_HARPY, WING_TYPE_FEATHERED_LARGE].indexOf(type) != -1;
		}
	}
}
