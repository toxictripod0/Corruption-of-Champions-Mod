/**
 * Created by aimozg on 26.01.14.
 */
package classes
{
import classes.GlobalFlags.kFLAGS;
import classes.GlobalFlags.kGAMECLASS;

import flash.utils.Dictionary;

	public class PerkType extends BaseContent
	{
		private static var PERK_LIBRARY:Dictionary = new Dictionary();

		public static function lookupPerk(id:String):PerkType{
			return PERK_LIBRARY[id];
		}

		public static function getPerkLibrary():Dictionary
		{
			return PERK_LIBRARY;
		}

		private var _id:String;
		private var _name:String;
		private var _desc:String;
		private var _longDesc:String;
		private var _keepOnAscension:Boolean;
		public var defaultValue1:Number = 0;
		public var defaultValue2:Number = 0;
		public var defaultValue3:Number = 0;
		public var defaultValue4:Number = 0;

		/**
		 * Unique perk id, should be kept in future game versions
		 */
		public function get id():String
		{
			return _id;
		}

		/**
		 * Perk short name, could be changed in future game versions
		 */
		public function get name():String
		{
			return _name;
		}

		/**
		 * Short description used in perk listing
		 */
		public function desc(params:Perk=null):String
		{
			return _desc;
		}

		/**
		 * Long description used when offering perk at levelup
		 */
		public function get longDesc():String
		{
			return _longDesc;
		}

		public function keepOnAscension(respec:Boolean = false):Boolean
		{
			if (_keepOnAscension)
				return true;

			return _longDesc != _desc && !respec; // dirty condition
		}

		public function PerkType(id:String,name:String,desc:String,longDesc:String = null,keepOnAscension:Boolean = false)
		{
			this._id = id;
			this._name = name;
			this._desc = desc;
			this._longDesc = longDesc || _desc;
			this._keepOnAscension = keepOnAscension;
			if (PERK_LIBRARY[id] != null) {
				CoC_Settings.error("Duplicate perk id "+id+", old perk is "+(PERK_LIBRARY[id] as PerkType)._name);
			}
			PERK_LIBRARY[id] = this;
		}


		public function toString():String
		{
			return "\""+_id+"\"";
		}

		/**
		 * Array of:
		 * {
		 *   fn: (Player)=>Boolean,
		 *   text: String,
		 *   type: String
		 *   // additional depending on type
		 * }
		 */
		public var requirements:Array = [];

		/**
		 * @return "requirement1, requirement2, ..."
		 */
		public function allRequirementDesc():String {
			var s:Array = [];
			for each (var c:Object in requirements) {
				if (c.text) s.push(c.text);
			}
			return s.join(", ");
		}
		public function available(player:Player):Boolean {
			for each (var c: Object in requirements) {
				if (!c.fn(player)) return false;
			}
			return true;
		}

		public function requireCustomFunction(playerToBoolean:Function, requirementText:String, internalType:String = "custom"):PerkType {
			requirements.push({
				fn  : playerToBoolean,
				text: requirementText,
				type: internalType
			});
			return this;
		}

		public function requireLevel(value:int):PerkType {
			requirements.push({
				fn  : fnRequireAttr("level", value),
				text: "Level " + value,
				type: "level",
				value: value
			});
			return this;
		}
		public function requireStr(value:int):PerkType {
			requirements.push({
				fn  : fnRequireAttr("str", value),
				text: "Strength " + value,
				type: "attr",
				attr: "str",
				value: value
			});
			return this;
		}
		public function requireTou(value:int):PerkType {
			requirements.push({
				fn  : fnRequireAttr("tou", value),
				text: "Toughness " + value,
				type: "attr",
				attr: "tou",
				value: value
			});
			return this;
		}
		public function requireSpe(value:int):PerkType {
			requirements.push({
				fn  : fnRequireAttr("spe", value),
				text: "Speed " + value,
				type: "attr",
				attr: "spe",
				value: value
			});
			return this;
		}
		public function requireInt(value:int):PerkType {
			requirements.push({
				fn  : fnRequireAttr("inte", value),
				text: "Intellect " + value,
				type: "attr",
				attr: "inte",
				value: value
			});
			return this;
		}
		public function requireWis(value:int):PerkType {
			requirements.push({
				fn  : fnRequireAttr("wis", value),
				text: "Wisdom " + value,
				type: "attr",
				attr: "wis",
				value: value
			});
			return this;
		}
		public function requireLib(value:int):PerkType {
			requirements.push({
				fn  : fnRequireAttr("lib", value),
				text: "Libido " + value,
				type: "attr",
				attr: "lib",
				value: value
			});
			return this;
		}
		public function requireCor(value:int):PerkType {
			requirements.push({
				fn  : function(player:Player):Boolean {
					return player.isCorruptEnough(value);
				},
				text: "Corruption &gt; " + value,
				type: "attr-gt",
				attr: "cor",
				value: value
			});
			return this;
		}
		public function requireLibLessThan(value:int):PerkType {
			requirements.push({
				fn  : function(player:Player):Boolean {
					return player.lib < value;
				},
				text: "Libido &lt; " + value,
				type: "attr-lt",
				attr: "lib",
				value: value
			});
			return this;
		}
		public function requireNGPlus(value:int):PerkType {
			requirements.push({
				fn  : function(player:Player):Boolean {
					return player.newGamePlusMod() >= value;
				},
				text: "New Game+ " + value,
				type: "ng+",
				value: value
			});
			return this;
		}
		/* [INTREMOD: xianxia]
		public function requirePrestigeJobSlot():PerkType {
			requirements.push({
				fn  : function(player:Player):Boolean {
					return player.maxPrestigeJobs() > 0;
				},
				text: "Free Prestige Job Slot",
				type: "prestige"
			});
			return this;
		}
		*/
		public function requireHungerEnabled():PerkType {
			requirements.push({
				fn  : function(player:Player):Boolean {
					return kGAMECLASS.flags[kFLAGS.HUNGER_ENABLED] > 0;
				},
				text: "Hunger enabled",
				type: "hungerflag"
			});
			return this;
		}
		public function requireMinLust(value:int):PerkType {
			requirements.push({
				fn  : function(player:Player):Boolean {
					return player.minLust() >= value;
				},
				text: "Min. Lust "+value,
				type: "minlust",
				value: value
			});
			return this;
		}
		/* [INTERMOD: xianxia]
		public function requireMaxSoulforce(value:int):PerkType {
			requirements.push({
				fn  : function(player:Player):Boolean {
					return player.maxSoulforce() >= value;
				},
				text: "Max. Soulforce "+value,
				type: "soulforce",
				value: value
			});
			return this;
		}
		*/
		private function fnRequireAttr(attrname:String,value:int):Function {
			return function(player:Player):Boolean {
				return player[attrname] >= value;
			};
		}
		public function requireStatusEffect(effect:StatusEffectType, text:String):PerkType {
			requirements.push({
				fn  : function (player:Player):Boolean {
					return player.hasStatusEffect(effect);
				},
				text: text,
				type: "effect",
				effect: effect
			});
			return this;
		}
		public function requirePerk(perk:PerkType):PerkType {
			requirements.push({
				fn  : function (player:Player):Boolean {
					return player.findPerk(perk) >= 0;
				},
				text: perk.name,
				type: "perk",
				perk: perk
			});
			return this;
		}
		public function requireAnyPerk(...perks:Array):PerkType {
			if (perks.length == 0) throw ("Incorrect call of requireAnyPerk() - should NOT be empty");
			var text:Array = [];
			for each (var perk:PerkType in perks) {
				text.push(perk.allRequirementDesc());
			}
			requirements.push({
				fn  : function (player:Player):Boolean {
					for each (var perk:PerkType in perks) {
						if (player.findPerk(perk) >= 0) return true;
					}
					return false;
				},
				text: text.join(" or "),
				type: "anyperk",
				perks: perks
			});
			return this;
		}
	}
}
