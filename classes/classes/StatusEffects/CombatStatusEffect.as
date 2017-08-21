/**
 * Created by aimozg on 31.01.14.
 */
package classes.StatusEffects
{
import classes.Creature;
import classes.StatusEffectClass;
import classes.StatusEffectType;

public class CombatStatusEffect extends StatusEffectClass
{

	public function CombatStatusEffect(stype:StatusEffectType,host:Creature)
	{
		super(stype,host);
	}
}
}
