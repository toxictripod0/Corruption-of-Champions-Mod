/**
 * Coded by aimozg on 22.08.2017.
 */
package classes.StatusEffects.Combat {
import classes.StatusEffects;
import classes.StatusEffects.CombatStatusEffect;

public class AkbalSpeedEffect extends CombatStatusEffect {
	public function AkbalSpeedEffect() {
		super(StatusEffects.AkbalSpeed)
	}


	override public function onCombatEnd():void {
		if (playerHost) dynStats("spe", -value1);
		else host.spe -= value1;
		super.onCombatEnd();
	}

	public function increase():void {
		value1 = player.spe / 5 * -1;
		if (playerHost) dynStats("spe", value1);
		else host.spe += value1;
	}
}
}
