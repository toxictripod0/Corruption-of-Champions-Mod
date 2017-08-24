package classes.StatusEffects {
import classes.StatusEffectClass;
import classes.StatusEffectType;

/**
 * Common superclass for stat debuffs with complete recovery after time.
 *
 * Implementation details:
 * 1. Subclass. Pass affected stat names (dynStat keys like 'str','spe','tou','int','lib','sen') as superclass
 *    constructor args.
 * 2. Override apply() with a call to debuffHost to debuff host and remember effect
 * 3. To apply debuff, add it to host; call increase() on already existing debuff to increase it effect
 *
 * Using host.dynStats instead of debuffHost makes the effect permanent
 */
public class DebuffEffect extends StatusEffectClass{
	private var stat1:String;
	private var stat2:String;
	private var stat3:String;
	private var stat4:String;
	public function DebuffEffect(stype:StatusEffectType,stat1:String,stat2:String='',stat3:String='',stat4:String='') {
		super(stype);
		this.stat1 = stat1;
		this.stat2 = stat2;
		this.stat3 = stat3;
		this.stat4 = stat4;
	}
	/**
	 * This function does a host.dynStats(...args) and stores the debuff in status effect values
	 */
	protected function debuffHost(...args):* {
		var debuff:* = host.dynStats.apply(host,args);
		return debuff;
	}
	protected function restore():void {
		var dsargs:Array = []
	}
	protected function apply(firstTime:Boolean):void {
		// debuffHost('str',-1);
	}
	override public function onAttach():void {
		super.onAttach();
		apply(true);
	}
	public function increase():void {
		apply(false);
	}
	override public function onRemove():void {
		super.onRemove();
		restore();
	}
}
}
