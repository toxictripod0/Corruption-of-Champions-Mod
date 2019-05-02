/**
 * Created by aimozg on 26.01.14.
 */
package classes
{
	import classes.Perks.*;
	import classes.GlobalFlags.*;

	public class PerkLib
	{

		// UNSORTED perks TODO these are mostly incorrect perks: tested but never created
		public static const Buttslut:PerkType = mk("Buttslut", "Buttslut",
				"");
		public static const Focused:PerkType = mk("Focused", "Focused",
				"");
/* Never used, removed because it used a numbered event. Could be re-implemented differently if some new monster actually uses it
		public static const LastStrike:PerkType = mk("Last Strike", "Last Strike",
				"");
		public static const AnalFertility:PerkType = mk("Anal Fertility", "Anal Fertility", //Not implemented
				"Unlocks the ability to get anally pregnant other than Satyrs.");
				
*/
		// Player creation perks
		public static const Fast:PerkType = mk("Fast", "Fast",
				"Gains speed 25% faster.", null, true);
		public static const Lusty:PerkType = mk("Lusty", "Lusty",
				"Gains lust 25% faster.", null, true);
		public static const Pervert:PerkType = mk("Pervert", "Pervert",
				"Gains corruption 25% faster. Reduces corruption requirement for high-corruption variant of scenes.", null, true);
		public static const Sensitive:PerkType = mk("Sensitive", "Sensitive",
				"Gains sensitivity 25% faster.", null, true);
		public static const Smart:PerkType = mk("Smart", "Smart",
				"Gains intelligence 25% faster.", null, true);
		public static const Strong:PerkType = mk("Strong", "Strong",
				"Gains strength 25% faster.", null, true);
		public static const Tough:PerkType = mk("Tough", "Tough",
				"Gains toughness 25% faster.", null, true);
		// Female creation perks
		public static const BigClit:PerkType = mk("Big Clit", "Big Clit",
				"Allows your clit to grow larger more easily and faster.", null, true);
		public static const BigTits:PerkType = mk("Big Tits", "Big Tits",
				"Makes your tits grow larger more easily.", null, true);
		public static const Fertile:PerkType = mk("Fertile", "Fertile",
				"Makes you 15% more likely to become pregnant.", null, true);
		public static const WetPussy:PerkType = mk("Wet Pussy", "Wet Pussy",
				"Keeps your pussy wet and provides a bonus to capacity.", null, true);
		// Male creation perks
		public static const BigCock:PerkType = mk("Big Cock", "Big Cock",
				"Gains cock size 25% faster and with less limitations.", null, true);
		public static const MessyOrgasms:PerkType = mk("Messy Orgasms", "Messy Orgasms",
				"Produces 50% more cum volume.", null, true);
				
		// Ascension perks
		public static const AscensionDesires:AscensionDesiresPerk = new AscensionDesiresPerk();
		public static const AscensionEndurance:AscensionEndurancePerk = new AscensionEndurancePerk();
		public static const AscensionFertility:AscensionFertilityPerk = new AscensionFertilityPerk();
		public static const AscensionFortune:AscensionFortunePerk = new AscensionFortunePerk();
		public static const AscensionMoralShifter:AscensionMoralShifterPerk = new AscensionMoralShifterPerk();
		public static const AscensionMysticality:AscensionMysticalityPerk = new AscensionMysticalityPerk();
		public static const AscensionTolerance:AscensionTolerancePerk = new AscensionTolerancePerk();
		public static const AscensionVirility:AscensionVirilityPerk = new AscensionVirilityPerk();
		public static const AscensionWisdom:AscensionWisdomPerk = new AscensionWisdomPerk();

		// History perks
		public static const HistoryAlchemist:PerkType = mk("History: Alchemist", "History: Alchemist",
				"Alchemical experience makes items more reactive to your body.", null, true);
		public static const HistoryFighter:PerkType = mk("History: Fighter", "History: Fighter",
				"A Past full of conflict increases physical damage dealt by 10%.", null, true);
		public static const HistoryFortune:PerkType = mk("History: Fortune", "History: Fortune",
				"Your luck and skills at gathering currency allows you to get 15% more gems from victories.", null, true);
		public static const HistoryHealer:PerkType = mk("History: Healer", "History: Healer",
				"Healing experience increases HP gains by 20%.", null, true);
		public static const HistoryReligious:PerkType = mk("History: Religious", "History: Religious",
				"Replaces masturbate with meditate when corruption less than or equal to 66. Reduces minimum libido slightly.", null, true);
		public static const HistoryScholar:PerkType = mk("History: Scholar", "History: Scholar",
				"Time spent focusing your mind makes spellcasting 20% less fatiguing.", null, true);
		public static const HistorySlacker:PerkType = mk("History: Slacker", "History: Slacker",
				"Regenerate fatigue 20% faster.", null, true);
		public static const HistorySlut:PerkType = mk("History: Slut", "History: Slut",
				"Sexual experience has made you more able to handle large insertions and more resistant to stretching.", null, true);
		public static const HistorySmith:PerkType = mk("History: Smith", "History: Smith",
				"Knowledge of armor and fitting increases armor effectiveness by roughly 10%.", null, true);
		public static const HistoryWhore:PerkType = mk("History: Whore", "History: Whore",
				"Seductive experience causes your tease attacks to be 15% more effective.", null, true);

		// Ordinary (levelup) perks
		public static const Acclimation:PerkType = mk("Acclimation", "Acclimation",
				"Reduces lust gain by 15%.",
				"You choose the 'Acclimation' perk, making your body 15% more resistant to lust, up to a maximum of 75%.");
		public static const Agility:PerkType = mk("Agility", "Agility",
				"Boosts armor points by a portion of your speed on light/medium armors.",
				"You choose the 'Agility' perk, increasing the effectiveness of Light/Medium armors by a portion of your speed.");
		public static const Archmage:PerkType = mk("Archmage", "Archmage",
				"[if (player.inte>=75)" +
						"Increases base spell strength by 50%." +
						"|" +
						"<b>You are too dumb to gain benefit from this perk.</b>" +
						"]",
				"You choose the 'Archmage' perk, increasing base spell strength by 50%.");
		public static const ArousingAura:PerkType = mk("Arousing Aura", "Arousing Aura",
				"Exude a lust-inducing aura (Req's corruption of 70 or more)",
				"You choose the 'Arousing Aura' perk, causing you to radiate an aura of lust when your corruption is over 70.");
		public static const Battlemage:PerkType = mk("Battlemage", "Battlemage",
				"Start every battle with Might enabled, if you meet Black Magic requirements before it starts.",
				"You choose the 'Battlemage' perk. You start every battle with Might effect, as long as your Lust is sufficient to cast it before battle.");
		public static const Berzerker:PerkType = mk("Berzerker", "Berserker",
				"[if (player.str>=75)" +
						"Grants 'Berserk' ability." +
						"|" +
						"<b>You aren't strong enough to benefit from this anymore.</b>" +
						"]",
				"You choose the 'Berserker' perk, which unlocks the 'Berserk' magical ability.  Berserking increases attack and lust resistance but reduces physical defenses.");
		public static const Blademaster:PerkType = mk("Blademaster", "Blademaster",
				"Gain +5% to critical strike chance when wielding a sword and not using a shield.",
				"You choose the 'Blademaster' perk.  Your chance of critical hit is increased by 5% as long as you're wielding a sword and not using a shield.");
		public static const Brawler:PerkType = mk("Brawler", "Brawler",
				"Brawling experience allows you to make two unarmed attacks in a turn.",
				"You choose the 'Brawler' perk, allowing you to make two unarmed attacks in a turn!");
		public static const BrutalBlows:PerkType = mk("Brutal Blows", "Brutal Blows",
				"[if (player.str>=75)" +
						"Reduces enemy armor with each hit." +
						"|" +
						"<b>You aren't strong enough to benefit from this anymore.</b>" +
						"]",
				"You choose the 'Brutal Blows' perk, which reduces enemy armor with each hit.");
		public static const Channeling:PerkType = mk("Channeling", "Channeling",
				"Increases base spell strength by 50%.",
				"You choose the 'Channeling' perk, boosting the strength of your spellcasting!");
		public static const ColdBlooded:PerkType = mk("Cold Blooded", "Cold Blooded",
				"Reduces minimum lust by up to 20, down to min of 20. Caps min lust at 80.",
				"You choose the 'Cold Blooded' perk.  Thanks to increased control over your desires, your minimum lust is reduced! (Caps minimum lust at 80. Won't reduce minimum lust below 20 though.)");
		public static const ColdFury:PerkType = mk("Cold Fury", "Cold Fury",
				"Berserking halves your defense instead of reducing to zero.",
				"You choose the 'Cold Fury' perk, causing Berserking to only reduce your armor by half instead of completely reducing to zero.");
		public static const CorruptedLibido:PerkType = mk("Corrupted Libido", "Corrupted Libido",
				"Reduces lust gain by 10%.",
				"You choose the 'Corrupted Libido' perk.  As a result of your body's corruption, you've become a bit harder to turn on. (Lust gain reduced by 10%!)");
		public static const DoubleAttack:PerkType = mk("Double Attack", "Double Attack",
				"[if (player.spe<50)" +
						"<b>You're too slow to double attack!</b>" +
						"|[if (player.str<61)" +
						"Allows you to perform two melee attacks per round." +
						"|" +
						"<b>You are stronger than double attack allows.  To choose between reduced strength double-attacks and a single strong attack, access \"Dbl Options\" in the perks menu.</b>" +
						"]]",
				"You choose the 'Double Attack' perk.  This allows you to make two attacks so long as your strength is at 60 or below.  By default your effective strength will be reduced to 60 if it is too high when double attacking.  <b>You can enter the perks menu at any time to toggle options as to how you will use this perk.</b>");
		public static const Evade:PerkType = mk("Evade", "Evade",
				"Increases chances of evading enemy attacks.",
				"You choose the 'Evade' perk, allowing you to avoid enemy attacks more often!");
		public static const FertilityMinus:PerkType = mk("Fertility-", "Fertility-",
				"Decreases fertility rating by 15 and cum volume by up to 30%. (Req's libido of less than 25.)",
				"You choose the 'Fertility-' perk, making it harder to get pregnant.  It also decreases your cum volume by up to 30% (if appropriate)!");
		public static const FertilityPlus:PerkType = mk("Fertility+", "Fertility+",
				"Increases fertility rating by 15 and cum volume by up to 50%.",
				"You choose the 'Fertility+' perk, making it easier to get pregnant.  It also increases your cum volume by up to 50% (if appropriate)!");
		public static const FocusedMind:PerkType = mk("Focused Mind", "Focused Mind",
				"Black Magic is less likely to backfire and White Magic threshold is increased.",
				"You choose the 'Focused Mind' perk. Black Magic is less likely to backfire and White Magic threshold is increased.");
		public static const HoldWithBothHands:PerkType = mk("Hold With Both Hands", "Hold With Both Hands",
				"Gain +20% strength modifier with melee weapons when not using a shield.",
				"You choose the 'Hold With Both Hands' perk.  As long as you're wielding a melee weapon and you're not using a shield, you gain 20% strength modifier to damage.");
		public static const HotBlooded:PerkType = mk("Hot Blooded", "Hot Blooded",
				"Raises minimum lust by up to 20.",
				"You choose the 'Hot Blooded' perk.  As a result of your enhanced libido, your lust no longer drops below 20! (If you already have some minimum lust, it will be increased by 10)");
		public static const ImmovableObject:PerkType = mk("Immovable Object", "Immovable Object",
				"[if (player.tou>=75)" +
						"Grants 10% physical damage reduction.</b>" +
						"|" +
						"<b>You aren't tough enough to benefit from this anymore.</b>" +
						"]",
				"You choose the 'Immovable Object' perk, granting 10% physical damage reduction.</b>");
		public static const ImprovedEndurance:PerkType = mk("Improved Endurance", "Improved Endurance",
				"Increases maximum fatigue by 20.",
				"You choose the 'Improved Endurance' perk. Thanks to your physical conditioning, your maximum fatigue has been increased by 20!</b>");
		public static const ImprovedEndurance2:PerkType = mk("Improved Endurance 2", "Improved Endurance 2",
				"Increases maximum fatigue by further 10.",
				"You choose the 'Improved Endurance 2' perk. Thanks to your improved physical conditioning, your maximum fatigue has been increased by further 10!</b>");
		public static const ImprovedEndurance3:PerkType = mk("Improved Endurance 3", "Improved Endurance 3",
				"Increases maximum fatigue by further 10.",
				"You choose the 'Improved Endurance 2' perk. Thanks to your superior physical conditioning, your maximum fatigue has been increased by further 10!</b>");
		public static const ImprovedSelfControl:PerkType = mk("Improved Self-Control", "Improved Self-Control",
				"Increases maximum lust by 20.",
				"You choose the 'Improved Self-Control' perk. Thanks to your mental conditioning, your maximum lust has been increased by 20!</b>");
		public static const ImprovedSelfControl2:PerkType = mk("Improved Self-Control 2", "Improved Self-Control 2",
				"Increases maximum lust by further 10.",
				"You choose the 'Improved Self-Control 2' perk. Thanks to your improved mental conditioning, your maximum lust has been increased by further 10!</b>");
		public static const ImprovedSelfControl3:PerkType = mk("Improved Self-Control 3", "Improved Self-Control 3",
				"Increases maximum lust by further 10.",
				"You choose the 'Improved Self-Control 2' perk. Thanks to your superior mental conditioning, your maximum lust has been increased by further 10!</b>");
		public static const ImprovedVision:PerkType = mk("Improved Vision", "Improved Vision",
				"Improves your vision allowing you to see openings most wouldn't (+3% Crit)",
				"You've chosen the 'Improved Vision' perk, which raises your critical strike chance by 3%.");
		public static const ImprovedVision2:PerkType = mk("Improved Vision 2", "Improved Vision 2",
				"Improves your vision allowing you to see openings most wouldn't (+7% Crit)",
				"You've chosen the 'Improved Vision 2' perk, which raises your critical strike chance by 7%.");
		public static const ImprovedVision3:PerkType = mk("Improved Vision 3", "Improved Vision 3",
				"Improves your vision allowing you to see openings most wouldn't (+10% Crit)",
				"You've chosen the 'Improved Vision 3' perk, which raises your critical strike chance by 10%.");
		public static const Indefatigable:PerkType = mk("Indefatigable", "Indefatigable",
				"Can no longer lose by lust. Can still submit manually at maximum lust via Fantasize.",
				"You choose the 'Indefatigable' perk. Thanks to your sheer willpower, you can no longer lose when your lust reaches maximum. (Choosing Fantasize at maximum lust still allows you to submit.)")
		public static const IronFists:PerkType = mk("Iron Fists", "Iron Fists",
				"Hardens your fists to increase attack rating by 5.",
				"You choose the 'Iron Fists' perk, hardening your fists. This increases attack power of unarmed attacks by 5 and gauntlets by 2.");
		public static const IronFists2:PerkType = mk("Iron Fists 2", "Iron Fists 2",
				"Further hardens your fists to increase attack rating by another 3.",
				"You choose the 'Iron Fists 2' perk, further hardening your fists. This increases attack power of unarmed attacks by another 3 and gauntlets by 1.");
		public static const IronFists3:PerkType = mk("Iron Fists 3", "Iron Fists 3",
				"Even more hardens your fists to increase attack rating again by 3.",
				"You choose the 'Iron Fists 3' perk, even further hardening your fists. This increases attack power of unarmed attacks again by another 3 and gauntlets by 1.");				
		public static const IronMan:PerkType = mk("Iron Man", "Iron Man",
				"Reduces the fatigue cost of physical specials by 50%.",
				"You choose the 'Iron Man' perk, reducing the fatigue cost of physical special attacks by 50%");
		public static const Juggernaut:PerkType = mk("Juggernaut", "Juggernaut",
				"When wearing heavy armor, you have extra 10 armor points and are immune to damage from being constricted/squeezed.",
				"You choose the 'Juggernaut' perk, granting extra 10 armor points when wearing heavy armor and immunity to damage from been constricted/squeezed.");
		public static const LightningStrikes:PerkType = mk("Lightning Strikes", "Lightning Strikes",
				"[if (player.spe>=60)" +
						"Increases the attack damage for non-heavy weapons.</b>" +
						"|" +
						"<b>You are too slow to benefit from this perk.</b>" +
						"]",
				"You choose the 'Lightning Strikes' perk, increasing the attack damage for non-heavy weapons.</b>");
		public static const LungingAttacks:PerkType = mk("Lunging Attacks", "Lunging Attacks",
				"[if (player.spe>=75)" +
						"Grants 50% armor penetration for standard attacks." +
						"|" +
						"<b>You are too slow to benefit from this perk.</b>" +
						"]",
				"You choose the 'Lunging Attacks' perk, granting 50% armor penetration for standard attacks.");
		public static const Mage:PerkType = mk("Mage", "Mage",
				"Increases base spell strength by 50%.",
				"You choose the 'Mage' perk.  You are able to focus your magical abilities even more keenly, boosting your base spell effects by 50%.");
		public static const Masochist:PerkType = mk("Masochist", "Masochist",
				"Take 20% less physical damage but gain lust when you take damage.",
				"You choose the 'Masochist' perk, reducing the damage you take but raising your lust each time!  This perk only functions while your libido is at or above 60!");
		public static const Medicine:PerkType = mk("Medicine", "Medicine",
				"Grants 15% chance per round of cleansing poisons/drugs from your body. Increases HP restoration on rest.",
				"You choose the 'Medicine' perk, giving you a chance to remove debilitating poisons automatically! Also, increases HP restoration on rest.");
		public static const Nymphomania:PerkType = mk("Nymphomania", "Nymphomania",
				"Raises minimum lust by up to 30.",
				"You've chosen the 'Nymphomania' perk.  Due to the incredible amount of corruption you've been exposed to, you've begun to live in a state of minor constant arousal.  Your minimum lust will be increased by as much as 30 (If you already have minimum lust, the increase is 10-15).");
		public static const Parry:PerkType = mk("Parry", "Parry",
				"[if (player.spe>=50)" +
						"Increases deflect chance by up to 10% while wielding a weapon. (Speed-based)." +
						"|" +
						"<b>You are not durable enough to gain benefit from this perk.</b>" +
						"]",
				"You choose the 'Parry' perk, giving you a chance to deflect blow with your weapon. (Speed-based).");
		public static const Precision:PerkType = mk("Precision", "Precision",
				"Reduces enemy armor by 10. (Req's 25+ Intelligence)",
				"You've chosen the 'Precision' perk.  Thanks to your intelligence, you're now more adept at finding and striking an enemy's weak points, reducing their damage resistance from armor by 10.  If your intelligence ever drops below 25 you'll no longer be smart enough to benefit from this perk.");
		public static const RagingInferno:PerkType = mk("Raging Inferno", "Raging Inferno",
				"Cumulative 20% damage increase for every subsequent fire spell without interruption.",
				"You choose the 'Raging Inferno' perk. Cumulative 20% damage increase for every subsequent fire spell without interruption.");
		public static const Regeneration:RegenerationPerk = new RegenerationPerk();
		public static const Regeneration2:Regeneration2Perk = new Regeneration2Perk();
		public static const Resistance:PerkType = mk("Resistance", "Resistance",
				"Reduces lust gain by 10%.",
				"You choose the 'Resistance' perk, reducing the rate at which your lust increases by 10%.");
		public static const Resolute:PerkType = mk("Resolute", "Resolute",
				"[if (player.tou>=75)" +
						"Grants immunity to stuns and some statuses.</b>" +
						"|" +
						"<b>You aren't tough enough to benefit from this anymore.</b>" +
						"]",
				"You choose the 'Resolute' perk, granting immunity to stuns and some statuses.</b>");
		public static const Runner:PerkType = mk("Runner", "Runner",
				"Increases chances of escaping combat.",
				"You choose the 'Runner' perk, increasing your chances to escape from your foes when fleeing!");
		public static const Sadist:PerkType = mk("Sadist", "Sadist",
				"Deal 20% more damage, but gain lust at the same time.",
				"You choose the 'Sadist' perk, increasing damage by 20 percent but causing you to gain lust from dealing damage.");
		public static const Seduction:PerkType = mk("Seduction", "Seduction",
				"Upgrades your tease attack, making it more effective.",
				"You choose the 'Seduction' perk, upgrading the 'tease' attack with a more powerful damage and a higher chance of success.");
		public static const ShieldMastery:PerkType = mk("Shield Mastery", "Shield Mastery",
				"[if (player.tou>=50)" +
						"Increases block chance by up to 10% while using a shield (Toughness-based)." +
						"|" +
						"<b>You are not durable enough to gain benefit from this perk.</b>" +
						"]",
				"You choose the 'Shield Mastery' perk, increasing block chance by up to 10% as long as you're wielding a shield (Toughness-based).");
		public static const ShieldSlam:PerkType = mk("Shield Slam", "Shield Slam",
				"Reduces shield bash diminishing returns by 50% and increases bash damage by 20%.",
				"You choose the 'Shield Slam' perk.  Stun diminishing returns is reduced by 50% and shield bash damage is increased by 20%.");
		public static const SpeedyRecovery:PerkType = mk("Speedy Recovery", "Speedy Recovery",
				"Regain fatigue 50% faster.",
				"You choose the 'Speedy Recovery' perk, boosting your fatigue recovery rate!");
		public static const Spellpower:PerkType = mk("Spellpower", "Spellpower",
				"Increases base spell strength by 50%.",
				"You choose the 'Spellpower' perk.  Thanks to your sizeable intellect and willpower, you are able to more effectively use magic, boosting base spell effects by 50%.");
		public static const Spellsword:PerkType = mk("Spellsword", "Spellsword",
				"Start every battle with Charge Weapon enabled, if you meet White Magic requirements before it starts.",
				"You choose the 'Spellsword' perk. You start every battle with Charge Weapon effect, as long as your Lust is not preventing you from casting it before battle.");
		public static const Survivalist:PerkType = mk("Survivalist", "Survivalist",
				"Slows hunger rate by 20%.",
				"You choose the 'Survivalist' perk.  With this perk, your hunger rate is reduced by 20%.");
		public static const Survivalist2:PerkType = mk("Survivalist 2", "Survivalist 2",
				"Slows hunger rate by further 20%.",
				"You choose the 'Survivalist 2' perk.  With this perk, your hunger rate is reduced by another 20%.");
		public static const StaffChanneling:PerkType = mk("Staff Channeling", "Staff Channeling",
				"Basic attack with wizard's staff is replaced with ranged magic bolt.",
				"You choose the 'Staff Channeling' perk. Basic attack with wizard's staff is replaced with ranged magic bolt.");
		public static const StrongBack:PerkType = mk("Strong Back", "Strong Back",
				"Enables fourth item slot.",
				"You choose the 'Strong Back' perk, enabling a fourth item slot.");
		public static const StrongBack2:PerkType = mk("Strong Back 2: Strong Harder", "Strong Back 2: Strong Harder",
				"Enables fifth item slot.",
				"You choose the 'Strong Back 2: Strong Harder' perk, enabling a fifth item slot.");
		public static const Tactician:PerkType = mk("Tactician", "Tactician",
				"[if (player.inte>=50)" +
						"Increases critical hit chance by 1% per 5 points intelligence above 50." +
						"|" +
						"<b>You are too dumb to gain benefit from this perk.</b>" +
						"]",
				"You choose the 'Tactician' perk, increasing critical hit chance by 1% per 5 points intelligence above 50.");
		public static const Tank:PerkType = mk("Tank", "Tank",
				"Raises max HP by 50.",
				"You choose the 'Tank' perk, giving you an additional 50 HP!");
		public static const Tank2:PerkType = mk("Tank 2", "Tank 2",
				"+1 extra HP per point of toughness.",
				"You choose the 'Tank 2' perk, granting an extra maximum HP for each point of toughness.");
		public static const Tank3:PerkType = mk("Tank 3", "Tank 3",
				"+5 extra HP per character level.",
				"You choose the 'Tank 3' perk, granting 5 extra maximum HP for each level.");
		public static const TitanGrip:PerkType = mk("Titan Grip", "Titan Grip",
				"Allows you to wield large weapons in one hand, granting shield usage.",
				"You choose the 'Titan Grip' perk. Thanks to your incredible strength, you can now wield large weapons with one hand!");
		public static const ThunderousStrikes:PerkType = mk("Thunderous Strikes", "Thunderous Strikes",
				"+20% 'Attack' damage while strength is at or above 80.",
				"You choose the 'Thunderous Strikes' perk, increasing normal damage by 20% while your strength is over 80.");
		public static const Unhindered:PerkType = mk("Unhindered", "Unhindered",
				"Increases chances of evading enemy attacks when you are naked. (Undergarments won't disable this perk.)",
				"You choose the 'Unhindered' perk, granting chance to evade when you are naked.");
		public static const WeaponMastery:PerkType = mk("Weapon Mastery", "Weapon Mastery",
				"[if (player.str>60)" +
						"Doubles damage bonus of weapons classified as 'Large'." +
						"|" +
						"<b>You aren't strong enough to benefit from this anymore.</b>" +
						"]",
				"You choose the 'Weapon Mastery' perk, doubling the effectiveness of large weapons.");
		public static const WellAdjusted:PerkType = mk("Well Adjusted", "Well Adjusted",
				"You gain half as much lust as time passes in Mareth.",
				"You choose the 'Well Adjusted' perk, reducing the amount of lust you naturally gain over time while in this strange land!");

		// Needlework perks
		public static const ChiReflowAttack:PerkType = mk("Chi Reflow - Attack", "Chi Reflow - Attack",
				"Regular attacks boosted, but damage resistance decreased.");
		public static const ChiReflowDefense:PerkType = mk("Chi Reflow - Defense", "Chi Reflow - Defense",
				"Passive damage resistance, but caps speed");
		public static const ChiReflowLust:PerkType = mk("Chi Reflow - Lust", "Chi Reflow - Lust",
				"Lust resistance and Tease are enhanced, but Libido and Sensitivity gains increased.");
		public static const ChiReflowMagic:PerkType = mk("Chi Reflow - Magic", "Chi Reflow - Magic",
				"Magic attacks boosted, but regular attacks are weaker.");
		public static const ChiReflowSpeed:PerkType = mk("Chi Reflow - Speed", "Chi Reflow - Speed",
				"Speed reductions are halved but caps strength");

		// Piercing perks
		public static const PiercedCrimstone:PiercedCrimstonePerk = new PiercedCrimstonePerk();
		public static const PiercedIcestone:PiercedIcestonePerk = new PiercedIcestonePerk();
		public static const PiercedFertite:PiercedFertitePerk = new PiercedFertitePerk();
		public static const PiercedFurrite:PerkType = mk("Pierced: Furrite", "Pierced: Furrite",
				"Increases chances of encountering 'furry' foes.");
		public static const PiercedLethite:PerkType = mk("Pierced: Lethite", "Pierced: Lethite",
				"Increases chances of encountering demonic foes.");

		// Cock sock perks
		public static const LustyRegeneration:PerkType = mk("Lusty Regeneration", "Lusty Regeneration",
				"Regenerates 1% of HP per round in combat and 2% of HP per hour.");
		public static const MidasCock:PerkType = mk("Midas Cock", "Midas Cock",
				"Increases the gems awarded from victory in battle.");
		public static const PentUp:PentUpPerk = new PentUpPerk();
		public static const PhallicPotential:PerkType = mk("Phallic Potential", "Phallic Potential",
				"Increases the effects of penis-enlarging transformations. This only affects cocks covered by scarlet cock-socks.");
		public static const PhallicRestraint:PerkType = mk("Phallic Restraint", "Phallic Restraint",
				"Reduces the effects of penis-enlarging transformations. This only affects cocks covered by cobalt cock-socks.");

		// Armor perks
		public static const BloodMage:PerkType = mk("Blood Mage", "Blood Mage",
				"Spellcasting now consumes health instead of fatigue!",null,true);
		public static const SluttySeduction:SluttySeductionPerk = new SluttySeductionPerk();
		public static const WizardsEndurance:WizardsEndurancePerk = new WizardsEndurancePerk();
		public static const WellspringOfLust:PerkType = mk("Wellspring of Lust", "Wellspring of Lust",
				"At the beginning of combat, lust raises to black magic threshold if lust is below black magic threshold.");

		// Weapon perks
		public static const WizardsFocus:WizardsFocusPerk = new WizardsFocusPerk();

		// Achievement perks
		public static const BroodMother:PerkType = mk("Brood Mother", "Brood Mother",
				"Pregnancy moves twice as fast as a normal woman's.");
		public static const SpellcastingAffinity:SpellcastingAffinityPerk = new SpellcastingAffinityPerk();

		// Mutation perks
		public static const Androgyny:PerkType = mk("Androgyny", "Androgyny",
				"No gender limits on facial masculinity or femininity.");
		public static const BasiliskWomb:PerkType = mk("Basilisk Womb", "Basilisk Womb",
				"Enables your eggs to be properly fertilized into basilisks of both genders!");
		public static const BeeOvipositor:PerkType = mk("Bee Ovipositor", "Bee Ovipositor",
				"Allows you to lay eggs through a special organ on your insect abdomen, though you need at least 10 eggs to lay.");
		public static const BimboBody:PerkType = mk("Bimbo Body", "Bimbo Body",
				"Gives the body of a bimbo.  Tits will never stay below a 'DD' cup, libido is raised, lust resistance is raised, and upgrades tease.");
		public static const BimboBrains:PerkType = mk("Bimbo Brains", "Bimbo Brains",
				"Now that you've drank bimbo liquer, you'll never, like, have the attention span and intelligence you once did!  But it's okay, 'cause you get to be so horny an' stuff!");
		public static const BroBody:PerkType = mk("Bro Body", "Bro Body",
				"Grants an ubermasculine body that's sure to impress.");
		public static const BroBrains:PerkType = mk("Bro Brains", "Bro Brains",
				"Makes thou... thin... fuck, that shit's for nerds.");
		public static const BunnyEggs:PerkType = mk("Bunny Eggs", "Bunny Eggs",
				"Laying eggs has become a normal part of your bunny-body's routine.");
		public static const CorruptedNinetails:PerkType = mk("Corrupted Nine-tails", "Corrupted Nine-tails",
				"The mystical energy of the nine-tails surges through you, filling you with phenomenal cosmic power!  Your boundless magic allows you to recover quickly after casting spells, but your method of attaining it has corrupted the transformation, preventing you from achieving true enlightenment.",null,true);
		public static const Diapause:PerkType = mk("Diapause", "Diapause",
				"Pregnancy does not advance normally, but develops quickly after taking in fluids.");
		public static const Dragonfire:PerkType = mk("Dragonfire", "Dragonfire",
				"Allows access to a dragon breath attack.");
		public static const EnlightenedNinetails:PerkType = mk("Enlightened Nine-tails", "Enlightened Nine-tails",
				"The mystical energy of the nine-tails surges through you, filling you with phenomenal cosmic power!  Your boundless magic allows you to recover quickly after casting spells.",null,true);
		public static const Feeder:PerkType = mk("Feeder", "Feeder",
				"Lactation does not decrease and gives a compulsion to breastfeed others.");
		public static const Flexibility:PerkType = mk("Flexibility", "Flexibility",
				"Grants cat-like flexibility.  Useful for dodging and 'fun'.");
		public static const FutaFaculties:PerkType = mk("Futa Faculties", "Futa Faculties",
				"It's super hard to think about stuff that like, isn't working out or fucking!");
		public static const FutaForm:PerkType = mk("Futa Form", "Futa Form",
				"Ensures that your body fits the Futa look (Tits DD+, Dick 8\"+, & Pussy).  Also keeps your lusts burning bright and improves the tease skill.");
		public static const HarpyWomb:PerkType = mk("Harpy Womb", "Harpy Womb",
				"Increases all laid eggs to large size so long as you have harpy legs and a harpy tail.");
		public static const Incorporeality:PerkType = mk("Incorporeality", "Incorporeality",
				"Allows you to fade into a ghost-like state and temporarily possess others.");
		public static const Lustzerker:PerkType = mk("Lustserker", "Lustserker",
				"Grants 'Lustserk' ability.");
		public static const MilkMaid:MilkMaidPerk = new MilkMaidPerk();
		public static const MinotaurCumAddict:PerkType = mk("Minotaur Cum Addict", "Minotaur Cum Addict",
				"Causes you to crave minotaur cum frequently.  You cannot shake this addiction.");
		public static const MinotaurCumResistance:PerkType = mk("Minotaur Cum Resistance", "Minotaur Cum Resistance",
				"You can never become a Minotaur Cum Addict. Grants immunity to Minotaur Cum addiction.");
		public static const Oviposition:PerkType = mk("Oviposition", "Oviposition",
				"Causes you to regularly lay eggs when not otherwise pregnant.");
		public static const PurityBlessing:PerkType = mk("Purity Blessing", "Purity Blessing",
				"Reduces the rate at which your corruption, libido, and lust increase. Reduces minimum libido slightly.");
		public static const RapierTraining:PerkType = mk("Rapier Training", "Rapier Training",
				"After finishing of your training, increase attack power of any rapier you're using.");
		public static const SatyrSexuality:PerkType = mk("Satyr Sexuality", "Satyr Sexuality",
				"Thanks to your satyr biology, you now have the ability to impregnate both vaginas and asses. Also increases your virility rating. (Anal impregnation not implemented yet)");
		public static const SlimeCore:PerkType = mk("Slime Core", "Slime Core",
				"Grants more control over your slimy body, allowing you to go twice as long without fluids.");
		public static const SpiderOvipositor:PerkType = mk("Spider Ovipositor", "Spider Ovipositor",
				"Allows you to lay eggs through a special organ on your arachnid abdomen, though you need at least 10 eggs to lay.");
		public static const ThickSkin:PerkType = mk("Thick Skin", "Thick Skin",
				"Toughens your dermis to provide 2 points of armor.");
		public static const TransformationResistance:PerkType = mk("Transformation Resistance", "Transformation Resistance",
				"Reduces the likelihood of undergoing a transformation. Disables Bad Ends from transformative items.");
				
		// Quest, Event & NPC perks
		public static const AChristmasCarol:PerkType = mk("A Christmas Carol", "A Christmas Carol",
				"Grants year-round access to Christmas event. Note that some events are only accessible once per year.", null, true);
		public static const BasiliskResistance:PerkType = mk("Basilisk Resistance", "Basilisk Resistance",
				"Grants immunity to Basilisk's paralyzing gaze. Disables Basilisk Bad End.");
		public static const BulgeArmor:PerkType = mk("Bulge Armor", "Bulge Armor",
				"Grants a 5 point damage bonus to dick-based tease attacks.");
		public static const Cornucopia:PerkType = mk("Cornucopia", "Cornucopia",
				"Vaginal and Anal capacities increased by 30.", null, true);
		public static const ElvenBounty:ElvenBountyPerk = new ElvenBountyPerk();
		public static const FerasBoonAlpha:PerkType = mk("Fera's Boon - Alpha", "Fera's Boon - Alpha",
				"Increases the rate your cum builds up and cum production in general.", null, true);
		public static const FerasBoonBreedingBitch:PerkType = mk("Fera's Boon - Breeding Bitch", "Fera's Boon - Breeding Bitch",
				"Increases fertility and reduces the time it takes to birth young.", null, true);
		public static const FerasBoonMilkingTwat:PerkType = mk("Fera's Boon - Milking Twat", "Fera's Boon - Milking Twat",
				"Keeps your pussy from ever getting too loose and increases pregnancy speed.");
		public static const FerasBoonSeeder:PerkType = mk("Fera's Boon - Seeder", "Fera's Boon - Seeder",
				"Increases cum output by 1,000 mLs.", null, true);
		public static const FerasBoonWideOpen:PerkType = mk("Fera's Boon - Wide Open", "Fera's Boon - Wide Open",
				"Keeps your pussy permanently gaped and increases pregnancy speed.");
		public static const FireLord:PerkType = mk("Fire Lord", "Fire Lord",
				"Akbal's blessings grant the ability to breathe burning green flames.");
		public static const Hellfire:PerkType = mk("Hellfire", "Hellfire",
				"Grants a corrupted fire breath attack, like the hellhounds in the mountains.");
		public static const LuststickAdapted:PerkType = mk("Luststick Adapted", "Luststick Adapted",
				"Grants immunity to the lust-increasing effects of lust-stick and allows its use.");
		public static const MagicalFertility:PerkType = mk("Magical Fertility", "Magical Fertility",
				"10% higher chance of pregnancy and increased pregnancy speed.");
		public static const MagicalVirility:PerkType = mk("Magical Virility", "Magical Virility",
				"200 mLs more cum per orgasm and enhanced virility.");
		public static const MaraesGiftButtslut:PerkType = mk("Marae's Gift - Buttslut", "Marae's Gift - Buttslut",
				"Makes your anus provide lubrication when aroused.");
		public static const MaraesGiftFertility:PerkType = mk("Marae's Gift - Fertility", "Marae's Gift - Fertility",
				"Greatly increases fertility and halves base pregnancy speed.");
		public static const MaraesGiftProfractory:PerkType = mk("Marae's Gift - Profractory", "Marae's Gift - Profractory",
				"Causes your cum to build up at 3x the normal rate.");
		public static const MaraesGiftStud:PerkType = mk("Marae's Gift - Stud", "Marae's Gift - Stud",
				"Increases your cum production and potency greatly.");
		public static const MarbleResistant:PerkType = mk("Marble Resistant", "Marble Resistant",
				"Provides resistance to the addictive effects of bottled LaBova milk.");
		public static const MarblesMilk:PerkType = mk("Marble's Milk", "Marble's Milk",
				"Requires you to drink LaBova milk frequently or eventually die.  You cannot shake this addiction.");
		public static const Misdirection:PerkType = mk("Misdirection", "Misdirection",
				"Grants additional evasion chances while wearing Raphael's red bodysuit.");
		public static const OmnibusGift:PerkType = mk("Omnibus' Gift", "Omnibus' Gift",
				"Increases minimum lust but provides some lust resistance.");
		public static const OneTrackMind:PerkType = mk("One Track Mind", "One Track Mind",
				"Your constant desire for sex causes your sexual organs to be able to take larger insertions and disgorge greater amounts of fluid.", null, true);
		public static const PilgrimsBounty:PerkType = mk("Pilgrim's Bounty", "Pilgrim's Bounty",
				"Causes you to always cum as hard as if you had max lust.", null, true);
		public static const PureAndLoving:PerkType = mk("Pure and Loving", "Pure and Loving",
				"Your caring attitude towards love and romance makes you slightly more resistant to lust and corruption.", null, true);
		public static const SensualLover:PerkType = mk("Sensual Lover", "Sensual Lover",
				"Your sensual attitude towards love and romance makes your tease ability slightly more effective.", null, true);
		public static const WarDance:PerkType = mk("War Dance", "War Dance",
				"+15% Damage against enemies in hand to hand combat and -20% Evasion change for the enemy.");
		public static const Whispered:PerkType = mk("Whispered", "Whispered",
				"Akbal's blessings grant limited telepathy that can induce fear.");
				
		public static const ControlledBreath:ControlledBreathPerk = new ControlledBreathPerk();
		public static const CleansingPalm:CleansingPalmPerk = new CleansingPalmPerk();
		public static const Enlightened:EnlightenedPerk = new EnlightenedPerk();
		

		// Monster perks
		public static const Acid:PerkType = mk("Acid", "Acid", "");

		private static function mk(id:String, name:String, desc:String, longDesc:String = null, keepOnAscension:Boolean = false):PerkType
		{
			return new PerkType(id, name, desc, longDesc, keepOnAscension);
		}
		private static function initRequirements():void {
			//------------
			// STRENGTH
			//------------
			StrongBack.requireStr(25);
			StrongBack2.requireStr(25)
					   .requirePerk(StrongBack);
			//Tier 1 Strength Perks
			//Thunderous Strikes - +20% basic attack damage while str > 80.
			ThunderousStrikes.requireStr(80)
							 .requireLevel(6);
			//Weapon Mastery - Doubles weapon damage bonus of 'large' type weapons. (Minotaur Axe, M. Hammer, etc)
			WeaponMastery.requireStr(60)
						 .requireLevel(6);
			BrutalBlows.requireStr(75)
					   .requireLevel(6);
			IronFists.requireStr(50)
					 .requireLevel(6);
			IronFists2.requireStr(65)
					  .requireLevel(6)
					  .requirePerk(IronFists);
			Parry.requireStr(50)
				 .requireSpe(50)
				 .requireLevel(6);
			//Tier 2 Strength Perks
			Berzerker.requireStr(75)
					 .requireLevel(12);
			HoldWithBothHands.requireStr(80)
							 .requireLevel(12);
			ShieldSlam.requireStr(80)
					  .requireTou(60)
					  .requireLevel(12);
			IronFists3.requireStr(80)
					  .requireLevel(12)
					  .requireNGPlus(1)
					  .requirePerk(IronFists2);
			//Tier 3 Strength Perks
			ColdFury.requireStr(75)
					.requireLevel(18)
					.requirePerk(Berzerker)
					.requirePerk(ImprovedSelfControl);
			TitanGrip.requireStr(90)
					.requireLevel(18)
					.requirePerk(StrongBack);
			//------------
			// TOUGHNESS
			//------------
			//slot 2 - toughness perk 1
			Tank.requireTou(25);
			//slot 2 - regeneration perk
			Regeneration.requireTou(50)
						.requirePerk(Tank);
			ImprovedEndurance.requireStr(50)
							 .requireTou(50);
			//Tier 1 Toughness Perks
			Tank2.requireTou(60)
				 .requireLevel(6)
				 .requirePerk(Tank);
			Regeneration2.requireTou(70)
						 .requireLevel(6)
						 .requirePerk(Regeneration);
			ImmovableObject.requireTou(75)
						   .requireLevel(6);
			ShieldMastery.requireTou(50)
						 .requireLevel(6);
			ImprovedEndurance2.requireLevel(6)
							  .requireStr(60)
							  .requireTou(60)
							  .requirePerk(ImprovedEndurance);
			//Tier 2 Toughness Perks
			Tank3.requireTou(80)
				 .requireLevel(12)
				 .requireNGPlus(1)
				 .requirePerk(Tank2);
			Resolute.requireTou(75)
					.requireLevel(12);
			Juggernaut.requireTou(75)
					  .requireLevel(12);
			IronMan.requireTou(60)
				   .requireLevel(12);
			ImprovedEndurance3.requireLevel(12)
							  .requireStr(70)
							  .requireTou(70)
							  .requireNGPlus(1)
							  .requirePerk(ImprovedEndurance2);
			//------------
			// SPEED
			//------------
			//slot 3 - speed perk
			Evade.requireSpe(25);
			//slot 3 - run perk
			Runner.requireSpe(25);
			//slot 3 - Double Attack perk
			DoubleAttack.requireSpe(50)
						.requirePerk(Evade)
						.requirePerk(Runner);

			//Tier 1 Speed Perks
			//Speedy Recovery - Regain Fatigue 50% faster speed.
			SpeedyRecovery.requireSpe(60)
						  .requireLevel(6)
						  .requirePerk(Evade);
			//Agility - A small portion of your speed is applied to your defense rating when wearing light armors.
			Agility.requireSpe(75)
				   .requireLevel(6)
				   .requirePerk(Runner);
			Unhindered.requireSpe(75)
					  .requireLevel(6)
					  .requirePerk(Evade)
					  .requirePerk(Agility);
			LightningStrikes.requireSpe(60)
							.requireLevel(6);
			/*
			 Brawler.requireStr(60).requireSpe(60);
			 */ //Would it be fitting to have Urta teach you?
			//Tier 2 Speed Perks
			LungingAttacks.requireSpe(75)
						  .requireLevel(12);
			Blademaster.requireStr(60)
					   .requireSpe(80)
					   .requireLevel(12);
			//------------
			// INTELLIGENCE
			//------------
			//Slot 4 - precision - -10 enemy toughness for damage calc
			Precision.requireInt(25);
			//Spellpower - boosts spell power
			Spellpower.requireInt(50);
			Mage.requireInt(50)
				.requirePerk(Spellpower);
			//Tier 1 Intelligence Perks
			Tactician.requireInt(50)
					 .requireLevel(6);
			Channeling.requireInt(60)
					  .requireLevel(6)
					  .requirePerk(Spellpower)
					  .requirePerk(Mage)
					  .requireCustomFunction(function (player:Player):Boolean {
						  return player.spellCount() > 0;
					  }, "Any Spell");
			Medicine.requireInt(60)
					.requireLevel(6);
			StaffChanneling.requireInt(60)
						   .requireLevel(6)
						   .requirePerk(Channeling);
			//Tier 2 Intelligence perks
			Archmage.requireInt(75)
					.requireLevel(12)
					.requirePerk(Mage);
			FocusedMind.requireInt(75)
					   .requireLevel(12)
					   .requirePerk(Mage);

			RagingInferno.requireInt(75)
						 .requireLevel(12)
						 .requirePerk(Archmage)
						 .requirePerk(Channeling)
						 .requireCustomFunction(function (player:Player):Boolean {
							 return player.hasStatusEffect(StatusEffects.KnowsWhitefire)
									 || player.hasStatusEffect(StatusEffects.KnowsBlackfire)
									 || player.hasPerk(FireLord)
									 || player.hasPerk(Hellfire)
									 || player.hasPerk(EnlightenedNinetails)
									 || player.hasPerk(CorruptedNinetails);
						 }, "Any Fire Spell");
			//Tier 3 Intelligence perks
			Indefatigable.requireInt(90)
						 .requireLevel(18)
						 .requirePerk(ImprovedSelfControl3)
						 .requireNGPlus(1);
			// Spell-boosting perks
			// Battlemage: auto-use Might
			Battlemage.requireInt(80)
					  .requireLevel(12)
					  .requirePerk(Channeling)
					  .requireStatusEffect(StatusEffects.KnowsMight, "Might Spell");
			// Spellsword: auto-use Charge Weapon
			Spellsword.requireInt(80)
					  .requireLevel(12)
					  .requirePerk(Channeling)
					  .requireStatusEffect(StatusEffects.KnowsCharge, "Charge Weapon Spell");

			//------------
			// LIBIDO
			//------------
			//slot 5 - libido perks

			//Slot 5 - Fertile+ increases cum production and fertility (+15%)
			FertilityPlus.requireLib(25);
			FertilityPlus.defaultValue1 = 15;
			FertilityPlus.defaultValue2 = 1.75;
			ImprovedSelfControl.requireInt(50).requireLib(25);
			//Slot 5 - minimum libido
			ColdBlooded.requireMinLust(20);
			ColdBlooded.defaultValue1 = 20;
			HotBlooded.requireLib(50);
			HotBlooded.defaultValue1 = 20;
			//Tier 1 Libido Perks
			//Slot 5 - minimum libido
			//Slot 5 - Fertility- decreases cum production and fertility.
			FertilityMinus.requireLevel(6)
						  .requireLibLessThan(25);
			FertilityMinus.defaultValue1 = 15;
			FertilityMinus.defaultValue2 = 0.7;
			WellAdjusted.requireLevel(6).requireLib(60);
			ImprovedSelfControl2.requireLevel(6)
			                    .requireInt(60)
								.requireLib(50)
								.requirePerk(ImprovedSelfControl);
			//Slot 5 - minimum libido
			Masochist.requireLevel(6).requireLib(60).requireCor(50);
			//Tier 2 Libido Perks
			ImprovedSelfControl3.requireLevel(12)
			                    .requireInt(70)
								.requireLib(75)
								.requireNGPlus(1)
								.requirePerk(ImprovedSelfControl2);
			//------------
			// SENSITIVITY
			//------------
			//Nope.avi
			//------------
			// CORRUPTION
			//------------
			//Slot 7 - Corrupted Libido - lust raises 10% slower.
			CorruptedLibido.requireCor(25);
			CorruptedLibido.defaultValue1 = 20;
			//Slot 7 - Seduction (Must have seduced Jojo
			Seduction.requireCor(50);
			//Slot 7 - Nymphomania
			Nymphomania.requirePerk(CorruptedLibido)
					   .requireCor(75);
			//Slot 7 - UNFINISHED :3
			Acclimation.requirePerk(CorruptedLibido)
					   .requireMinLust(20)
					   .requireCor(50);
			//Tier 1 Corruption Perks - acclimation over-rides
			Sadist.requireLevel(6)
				  .requirePerk(CorruptedLibido)
				  .requireCor(60);
			ArousingAura.requireLevel(6)
						.requirePerk(CorruptedLibido)
						.requireCor(70);
			//Tier 1 Misc Perks
			Resistance.requireLevel(6);
			Survivalist.requireLevel(6)
					   .requireHungerEnabled();
			//Tier 2 Misc Perks
			Survivalist2.requireLevel(12)
						.requirePerk(Survivalist)
						.requireHungerEnabled();
			//Other Misc Perks
			ImprovedVision.requireLevel(30)
			          .requirePerk(Tactician);
			ImprovedVision2.requireLevel(60)
			          .requirePerk(ImprovedVision);
			ImprovedVision3.requireLevel(90)
			          .requirePerk(ImprovedVision2);
		}
		{
			initRequirements();
		}
	}
}
