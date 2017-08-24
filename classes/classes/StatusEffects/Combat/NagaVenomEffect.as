package classes.StatusEffects.Combat {
import classes.PerkLib;
import classes.StatusEffectType;
import classes.StatusEffects.CombatStatusEffect;

public class NagaVenomEffect extends CombatStatusEffect {

	public static const TYPE:StatusEffectType = register("Naga Venom",NagaVenomEffect);
	public function NagaVenomEffect() {
		super(TYPE);
	}

	override public function onCombatEnd():void {
		host.modSpe(value1,false);
		super.onCombatEnd();
	}

	public function increase():void {
		// -3 speed first, -2 speed next, additiional damage if speed minimal
		var debuff:Number = host.modSpe(value1 == 0 ? -3 : -2);
		if (debuff == 0) host.takeDamage(5+rand(5));
		host.takeDamage(5+rand(5));
		value1 -= debuff;
	}


	override public function onCombatRound():void {
		//Chance to cleanse!
		if (host.hasPerk(PerkLib.Medicine) && rand(100) <= 14) {
			if (playerHost) outputText("You manage to cleanse the naga venom from your system with your knowledge of medicine!\n\n");
			remove();
			return;
		}
		var debuff:Number = host.modSpe(-2);
		if (debuff == 0) host.takeDamage(5);
		host.takeDamage(2);
		value1 -= debuff;
		if (playerHost) outputText("You wince in pain and try to collect yourself, the naga's venom still plaguing you.\n\n");
	}
}

}