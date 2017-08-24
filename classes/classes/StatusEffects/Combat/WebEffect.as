/**
 * Coded by aimozg on 22.08.2017.
 */
package classes.StatusEffects.Combat {
import classes.StatusEffectType;

public class WebEffect extends CombatBuff{
	public static const TYPE:StatusEffectType = register("Web",WebEffect);
	public function WebEffect() {
		super(TYPE, 'spe');
	}

	override protected function apply(firstTime:Boolean):void {
		buffHost('spe',-25);
	}
}
}
