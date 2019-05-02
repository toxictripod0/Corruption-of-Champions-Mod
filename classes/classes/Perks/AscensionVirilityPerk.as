package classes.Perks 
{
	import classes.Perk;
	import classes.PerkType;
	import classes.GlobalFlags.kGAMECLASS;
	import classes.CharCreation;
	
	public class AscensionVirilityPerk extends PerkType
	{
		
		override public function desc(params:Perk = null):String
		{
			return "(Rank: " + params.value1 + "/" + CharCreation.MAX_VIRILITY_LEVEL + ") Increases base virility rating by " + params.value1 * 5 + ".";
		}
		
		public function AscensionVirilityPerk() 
		{
			super("Ascension: Virility", "Ascension: Virility", "", "Increases base virility rating by 5 per level.");
		}
		
		override public function keepOnAscension(respec:Boolean = false):Boolean 
		{
			return true;
		}		
	}

}
