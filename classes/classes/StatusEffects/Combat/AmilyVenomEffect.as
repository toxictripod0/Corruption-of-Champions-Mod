/**
 * Coded by aimozg on 24.08.2017.
 */
package classes.StatusEffects.Combat {
import classes.StatusEffectType;
import classes.StatusEffects.CombatStatusEffect;

public class AmilyVenomEffect extends CombatStatusEffect {
	public static const TYPE:StatusEffectType = register("Amily Venom",AmilyVenomEffect);
	public function AmilyVenomEffect() {
		super(TYPE);
	}


	override public function onCombatEnd():void {
		host.dynStats("str", value1,"spe", value2, "scale", false);
		super.onCombatEnd();
	}

	public function increase():void {
		var poison:Number = 2 + rand(5);
		var deltas:* = host.dynStats("str",-poison,"spe",-poison);
		value1 = -deltas.str;
		value2 = -deltas.spe;
	}
}}
