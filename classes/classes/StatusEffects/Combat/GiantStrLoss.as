/**
 * Coded by aimozg on 01.09.2017.
 */
package classes.StatusEffects.Combat {
import classes.StatusEffectType;

public class GiantStrLoss extends CombatBuff {
	public static const TYPE:StatusEffectType = register("GiantStrLoss",GiantStrLoss);
	public function GiantStrLoss() {
		super(TYPE,'str');
	}

	public function applyEffect(magnitude:Number):void {
		buffHost('str', -magnitude);
	}
}

}
