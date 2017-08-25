package classes.StatusEffects.Combat {
import classes.StatusEffectType;

public class GnollSpearEffect extends CombatBuff {
	public static const TYPE:StatusEffectType = register("Gnoll Spear",GnollSpearEffect);
	public function GnollSpearEffect() {
		super(TYPE,'spe');
	}


	override protected function apply(firstTime:Boolean):void {
		buffHost('spe', -15);
	}
}

}
