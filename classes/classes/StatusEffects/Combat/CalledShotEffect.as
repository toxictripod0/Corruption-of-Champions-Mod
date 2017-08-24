package classes.StatusEffects.Combat {
import classes.StatusEffectType;
import classes.StatusEffects.CombatStatusEffect;

public class CalledShotEffect extends CombatBuff {

	public static const TYPE:StatusEffectType = register("Called Shot",CalledShotEffect);
	public function CalledShotEffect() {
		super(TYPE,'spe');
	}


	override protected function apply(firstTime:Boolean):void {
		buffHost('spe', -20 - rand(5));
	}
}

}