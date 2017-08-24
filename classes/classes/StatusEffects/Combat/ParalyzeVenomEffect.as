package classes.StatusEffects.Combat {
import classes.StatusEffectType;
import classes.StatusEffects.CombatStatusEffect;

public class ParalyzeVenomEffect extends CombatStatusEffect {

	public static const TYPE:StatusEffectType = register("paralyze venom",ParalyzeVenomEffect);
	public function ParalyzeVenomEffect() {
		super(TYPE);
	}

	override public function onCombatEnd():void {
		host.dynStats('str',value1,'spe',value2,'scale',false);
		if (playerHost && (value1!=0||value2!=0)) {
			outputText("<b>You feel quicker and stronger as the paralyzation venom in your veins wears off.</b>\n\n");
		}
		super.onCombatEnd();
	}

	public function increase():void {
		// -3, -3 first venom; -2, -2 if already poisoned
		var debuff:* = host.dynStats('str',value1?-2:-3,'spe',value2?-2:-3);
		value1 -= debuff.str;
		value2 -= debuff.spe;
	}

}

}