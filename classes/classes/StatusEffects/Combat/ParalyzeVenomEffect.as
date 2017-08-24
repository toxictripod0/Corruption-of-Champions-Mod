package classes.StatusEffects.Combat {
import classes.StatusEffectType;

public class ParalyzeVenomEffect extends CombatBuff {

	public static const TYPE:StatusEffectType = register("paralyze venom",ParalyzeVenomEffect);
	public function ParalyzeVenomEffect() {
		super(TYPE,'str','spe');
	}


	override public function onRemove():void {
		if (playerHost) {
			outputText("<b>You feel quicker and stronger as the paralyzation venom in your veins wears off.</b>\n\n");
		}
	}

	override protected function apply(firstTime:Boolean):void {
		buffHost('str',firstTime?-2:-3,'spe',firstTime?-2:-3);
	}

}

}