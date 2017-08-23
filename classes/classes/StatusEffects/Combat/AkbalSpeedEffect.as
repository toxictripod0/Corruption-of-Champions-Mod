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
		host.spe -= value1;
		super.onCombatEnd();
	}

	public function increase():void {
		value1 = host.spe / 5 * -1;
		value1 = host.dynStats("spe", value1).spe;
	}
}
}
