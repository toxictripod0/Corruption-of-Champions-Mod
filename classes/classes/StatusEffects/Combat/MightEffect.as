/**
 * Coded by aimozg on 24.08.2017.
 */
package classes.StatusEffects.Combat {
import classes.StatusEffectType;

public class MightEffect extends CombatBuff {
	public static const TYPE:StatusEffectType = register("Might",MightEffect);
	public function MightEffect() {
		super(TYPE,'str','tou');
	}

	override protected function apply(firstTime:Boolean):void {
		var buff:Number = host.spellMod();
		if (buff > 100) buff = 100;
		buffHost('str',buff,'tou',buff,'scale',false);
	}

}
}
