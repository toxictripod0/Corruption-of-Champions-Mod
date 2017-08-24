package classes.StatusEffects.Combat {
import classes.StatusEffectType;
import classes.StatusEffects.CombatStatusEffect;

public class CalledShotEffect extends CombatStatusEffect {

	public static const TYPE:StatusEffectType = register("Called Shot",CalledShotEffect);
	public function CalledShotEffect() {
		super(TYPE);
	}

	override public function onCombatEnd():void {
		host.modSpe(value1,false);
		super.onCombatEnd();
	}

	public function increase():void {
		value1 -= host.modSpe( -20-rand(5));
	}

}

}