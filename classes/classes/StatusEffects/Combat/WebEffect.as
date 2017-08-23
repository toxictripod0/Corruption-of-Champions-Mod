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
		host.spe += value1;
		if (playerHost) showStatUp('spe');
		super.onCombatEnd(); // or remove();
	}
	public function increase():void {
		//Only apply as much speed slow as necessary.
		var amount:Number = host.dynStats('spe',-25).spe;
		value1 += amount;
	}
}
}
