/**
 * Coded by aimozg on 22.08.2017.
 */
package classes.StatusEffects.Combat {
import classes.StatusEffectType;
import classes.StatusEffects;
import classes.StatusEffects.CombatStatusEffect;

public class AkbalSpeedEffect extends CombatStatusEffect {
	public static const TYPE:StatusEffectType = register("Akbal Speed",AkbalSpeedEffect);
	public function AkbalSpeedEffect() {
		super(TYPE);
	}


	override public function onCombatEnd():void {
		host.modSpe(-value1,false);
		super.onCombatEnd();
	}

	public function increase():void {
		value1 += host.modSpe(host.spe / 5 * -1);
	}
}

}
