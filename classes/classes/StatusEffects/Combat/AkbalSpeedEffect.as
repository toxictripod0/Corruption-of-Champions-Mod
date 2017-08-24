/**
 * Coded by aimozg on 22.08.2017.
 */
package classes.StatusEffects.Combat {
import classes.StatusEffectType;

public class AkbalSpeedEffect extends CombatBuff {
	public static const TYPE:StatusEffectType = register("Akbal Speed",AkbalSpeedEffect);
	public function AkbalSpeedEffect() {
		super(TYPE,'spe');
	}


	override protected function apply(firstTime:Boolean):void {
		buffHost('spe', -host.spe / 5 * -1);
	}
}

}
