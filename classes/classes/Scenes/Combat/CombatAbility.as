package classes.Scenes.Combat 
{
	import classes.Creature;
	import classes.*;
	import classes.Scenes.Combat.CombatAbilities;
	import classes.GlobalFlags.*;
	import classes.Scenes.Areas.GlacialRift.FrostGiant;
	public class CombatAbility extends BaseContent
	{
		///The main function of the ability, where all the magic happens.
		public var abilityFunc:Function;
		///The ability's tooltip in the ability menu.
		public var _tooltip:*;
		///When the ability shows up on the menu at all, like, for example, a player having a certain body part.
		public var _availableWhen:*;
		///When the ability's button is disabled. This is for more "exotic" conditions, like tail venom, a status effect given by the ability and the like. Being sealed, lust, and fatigue based conditions are covered automatically based on the type of the ability.
		public var _disabledWhen:*;
		///What tooltip appears when the ability is disabled. Keep in mind that lust and fatigue based tooltips are automatically covered, so you don't have to consider those.
		public var _disabledTooltip:*;
		///0 = White Magic, 1 = Black Magic, 2 = Physical, 3 = Magical
		public var abilityType:int;
		///Whether or not the ability is a heal. This means it will not be affected by blood magic.
		public var isHeal:Boolean;
		///Whether or not this ability is cast on self.
		public var isSelf:Boolean;
		///Whether or not this ability can only be used once per fight.
		public var oneUse:Boolean;
		public var used:Boolean = false;
		///hit chance. In percentage.
		public var hitChance:Number;
		public static const WHITE_MAGIC:int = 0;
		public static const BLACK_MAGIC:int = 1;
		public static const PHYSICAL:int = 2;
		public static const MAGICAL:int = 3;
		private var fatigueType:int = 0;
		private static const typeArray:Array = [1, 1, 2, 1];
		///The cost of the ability. Keep in mind that white magic, black magic and magical abilities are affected by blood mage.
		public var _cost:Number;
		///what shows up in the header of the button.
		public var spellName:String;
		///what shows up in the button.
		public var spellShort:String;
		///cooldown of the ability. 
		public var cooldown:int;
		public var currCooldown:int;
		
		public function CombatAbility(def:*) 
		{
			abilityFunc = def.abilityFunc;
			_tooltip = def.tooltip;
			_availableWhen = def.availableWhen;
			_disabledWhen = def.disabledWhen || false;
			_disabledTooltip = def.disabledTooltip || "";
			_cost = def.cost || 0;
			spellName = def.spellName || "";
			spellShort = def.spellShort || "";
			abilityType = def.abilityType || 0;
			hitChance = def.hitChance || 0;
			isHeal = def.isHeal || false;
			isSelf = def.isSelf || false;
			oneUse = def.oneUse || false;
			fatigueType = isHeal ? 2 : typeArray[abilityType];
			cooldown = def.cooldown != null ? def.cooldown : 0;
			currCooldown = cooldown;
		}
		public function get cost():Number{
			if (abilityType == 2) return player.physicalCost(_cost);
			else return player.spellCost(_cost);
		}
		public function get tooltip():String {
			var retv:String = _tooltip is Function ? _tooltip() : _tooltip;
			if (cost > 0) retv += "\n\nFatigue Cost: " + (abilityType == 2 ? player.physicalCost(_cost) : player.spellCost(_cost)) + "";
			return retv;
		}
		
		public function get availableWhen():Boolean {
			return _availableWhen is Function ? _availableWhen() : _availableWhen;
		}
		
		public function execAbility():void{
			currCooldown = 0;
			clearOutput();
			used = true;
			if (cost > 0) player.changeFatigue(cost, fatigueType);
			if (abilityType != 2){
				flags[kFLAGS.SPELLS_CAST]++;
				combat.combatAbilities.spellPerkUnlock();
			}
			if (monster.hasStatusEffect(StatusEffects.Shell) && !isSelf && abilityType != 2) {
				outputText("As soon as your magic touches the multicolored shell around " + monster.a + monster.short + ", it sizzles and fades to nothing.  Whatever that thing is, it completely blocks your magic!\n\n");		
				monster.doAI();
				statScreenRefresh();
				return;
			}
			if (monster.hasStatusEffect(StatusEffects.Concentration) && !isSelf && abilityType == 2) {
				outputText(monster.capitalA + monster.short + " easily glides around your attack thanks to " + monster.pronoun3 +  "'s complete concentration on your movements.\n\n");
				monster.doAI();
				return;
			}
			if (monster is FrostGiant && player.hasStatusEffect(StatusEffects.GiantBoulder) && abilityType != 2) {
				(monster as FrostGiant).giantBoulderHit(2);
				monster.doAI();
				statScreenRefresh();
				return;
			}
			abilityFunc();
			statScreenRefresh();
			//combat.monsterAI();
			//doNext(combat.combatMenu);
		}
		
		public function get disabledWhen():Boolean {
			return _disabledWhen is Function ? _disabledWhen() : _disabledWhen;
		}
		public function get disabledTooltip():String {
			return _disabledTooltip is Function ? _disabledTooltip() : _disabledTooltip;
		}
		
		public function createButton(index:int):int{
				if (availableWhen){
					if (player.lust >= kGAMECLASS.combat.combatAbilities.getWhiteMagicLustCap() && abilityType == WHITE_MAGIC){
						addButtonDisabled(index++, spellShort,"You are far too aroused to focus on white magic.", spellName);
					}
					else if (player.lust < 50 && abilityType == BLACK_MAGIC){
						addButtonDisabled(index++, spellShort,"You aren't turned on enough to use any black magics.", spellName);
					}
					else if (!player.hasPerk(PerkLib.BloodMage) && player.fatigue + cost > player.maxFatigue() && !isHeal){
						addButtonDisabled(index++, spellShort,"You are too tired to use this ability.", spellName);
					}
					else if (used && oneUse) addButtonDisabled(index++, spellShort, "You've already used this ability in this fight.", spellName);
					else if (currCooldown < cooldown && cooldown != 0) addButtonDisabled(index++, spellShort, "Ability is in cooldown. Available in " + (cooldown - currCooldown) + " turns.",spellName);
					else if (disabledWhen){
						addButtonDisabled(index++, spellShort,disabledTooltip, spellName);
					}else{
						addButton(index++, spellShort, execAbility).hint(tooltip, spellName);
					}
				}	
			return index;
		}
	}
	}