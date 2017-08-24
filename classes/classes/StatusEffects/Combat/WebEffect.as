/**
 * Coded by aimozg on 22.08.2017.
 */
package classes.StatusEffects.Combat {
import classes.StatusEffectType;
import classes.StatusEffects.*;

public class WebEffect extends CombatStatusEffect{
	public static const TYPE:StatusEffectType = register("Web",WebEffect);
	public function WebEffect() {
		super(TYPE);
	}

	override public function onCombatEnd():void {
		host.modSpe(-value1,false);
		super.onCombatEnd();
	}

	public function increase():void {
		value1 += host.modSpe(-25);
	}
}
}
