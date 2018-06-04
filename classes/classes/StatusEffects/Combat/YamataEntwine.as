package classes.StatusEffects.Combat {
import classes.PerkLib;
import classes.StatusEffectType;

public class YamataEntwine extends CombatBuff {

	public static const TYPE:StatusEffectType = register("Aiko Lighting shot",YamataEntwine);
	public function YamataEntwine() {
		super(TYPE,'str');
	}
	
	override protected function onAttach():void {
		if (first)
		{
			player.dynStats("cor", 2);
			buffHost('str',-10);
			buffHost('spe',-10);
			player.takeDamage(40+25/(rand(3)+1), true);
		}
		else 
		{
			player.takeDamage(20+25/(rand(3)+1), true);
			player.dynStats("cor", 1);
		}
	}

	override public function onCombatRound():void {
		host.takeDamage(8);
		host.dynStats("lus", 7);
		if (playerHost)
		{
			game.outputText("Yamata's serpentine hair continues to pump their corrupted flames into you!\n\n");
			player.dynStats("cor", 1);
			game.flags[kFLAGS.YAMATA_MASOCHIST]++;
		}
	}
	
	override public function onRemove():void {
		if (playerHost)
			game.outputText("<b>You feel relief as Yamata's serpents finally release their hold, though you can still feel their corruption pulsing in your veins.</b>\n\n");
	}
}

}