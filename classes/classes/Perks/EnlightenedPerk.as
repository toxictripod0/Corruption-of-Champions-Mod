package classes.Perks
{
	import classes.Perk;
	import classes.PerkType;
	import classes.GlobalFlags.kGAMECLASS;

	public class EnlightenedPerk extends PerkType
	{

		override public function desc(params:Perk = null):String
		{
			if (!player.isPureEnough(10)) return "<b>DISABLED</b> - Corruption too high!";
			else return super.desc(params);
		}

		public function EnlightenedPerk()
		{
			super("Enlightened", "Enlightened", "Jojo’s tutelage has given you a master’s focus and you can feel the universe in all its glory spread out before you. You’ve finally surpassed your teacher.");
		}
	}
}
