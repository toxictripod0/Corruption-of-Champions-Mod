package classes.StatusEffects.Combat {
import classes.PerkLib;
import classes.StatusEffectType;

public class AikoLightningArrow extends CombatBuff {

	public static const TYPE:StatusEffectType = register("Aiko Lighting shot",AikoLightningArrow);
	public function AikoLightningArrow() {
		super(TYPE,'str');
	}
	
	override protected function onAttach():void {
		if (first)
		{
			buffHost('str',-10);
			buffHost('spe',-10);
			player.takeDamage(45+25/(rand(3)+1), true);
		}
		else 
			player.takeDamage(20+25/(rand(3)+1), true);
	}

	override public function onCombatRound():void {
		host.takeDamage(8, true);
		if (playerHost) game.outputText("You fall to one knee as Aiko's Lighting pulses through your limbs, Oh how this hurts...\n\n");
	}
	
	override public function onRemove():void {
		if (playerHost)
			game.outputText("<b>You feel stronger as Aiko's lightning finally fades, though the arrow is still lodged in your side.</b>\n\n");
	}
}

}