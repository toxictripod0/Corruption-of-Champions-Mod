package classes.BodyParts 
{
	/**
	 * Container class for the players wings
	 * @since May 01, 2017
	 * @author Stadler76
	 */
	public class Wings extends BaseBodyPart
	{
		public static const TYPE_NONE:int            =   0;
		public static const TYPE_BEE_LIKE_SMALL:int  =   1;
		public static const TYPE_BEE_LIKE_LARGE:int  =   2;
		public static const TYPE_HARPY:int           =   4;
		public static const TYPE_IMP:int             =   5;
		public static const TYPE_BAT_LIKE_TINY:int   =   6;
		public static const TYPE_BAT_LIKE_LARGE:int  =   7;
		public static const TYPE_SHARK_FIN:int       =   8; // Deprecated, moved to the rearBody slot.
		public static const TYPE_FEATHERED_LARGE:int =   9;
		public static const TYPE_DRACONIC_SMALL:int  =  10;
		public static const TYPE_DRACONIC_LARGE:int  =  11;
		public static const TYPE_GIANT_DRAGONFLY:int =  12;
		public static const TYPE_IMP_LARGE:int       =  13;

		public var type:Number  = TYPE_NONE;
		public var color:String = "no";

		public function Wings() {}

		public function restore():void
		{
			type  = TYPE_NONE;
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

		override public function canDye():Boolean
		{
			return [TYPE_HARPY, TYPE_FEATHERED_LARGE].indexOf(type) != -1;
		}

		override public function hasDyeColor(_color:String):Boolean
		{
			return color == _color;
		}

		override public function applyDye(_color:String):void
		{
			color = _color;
		}
	}
}
