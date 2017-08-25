package classes.StatusEffects.Combat {
import classes.StatusEffectType;

public class AnemoneVenomEffect extends CombatBuff {
	public static const TYPE:StatusEffectType = register("Anemone Venom",AnemoneVenomEffect);
	public function AnemoneVenomEffect() {
		super(TYPE,'str','spe');
	}

	public function applyEffect(str:Number):void {
		host.takeLustDamage((2 * str), true);
		buffHost('str', -str,'spe',-str);
	}
}

}
