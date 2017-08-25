package classes.StatusEffects.Combat {
import classes.StatusEffectType;

public class BasiliskSlowEffect extends CombatBuff {
	public static const TYPE:StatusEffectType = register("BasiliskSlow",BasiliskSlowEffect);
	public function BasiliskSlowEffect() {
		super(TYPE,'spe');
	}

	public function applyEffect(amount:Number):void {
		buffHost('spe',-amount);
	}
}

}
