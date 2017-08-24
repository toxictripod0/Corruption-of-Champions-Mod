/**
 * Coded by aimozg on 24.08.2017.
 */
package classes.StatusEffects.Combat {
import classes.StatusEffectType;

public class AmilyVenomEffect extends CombatBuff {
	public static const TYPE:StatusEffectType = register("Amily Venom",AmilyVenomEffect);
	public function AmilyVenomEffect() {
		super(TYPE,'str','spe');
	}

	override protected function apply(firstTime:Boolean):void {
		buffHost('str', -2 - rand(5),'spe', -2 - rand(5));
	}
}
}
