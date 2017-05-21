/**
 * Created by aimozg on 03.01.14.
 */
package classes.Scenes.Areas.HighMountains
{
	import classes.*;
	import classes.Items.ArmorLib;
	import classes.GlobalFlags.kFLAGS;
	import classes.GlobalFlags.kGAMECLASS;

	public class CockatriceScene extends BaseContent
	{
		public function CockatriceScene() {}

		//Intros and Fight Texts. 
		public function greeting():void
		{
			var cockatrice:Cockatrice = new Cockatrice();
			//spriteSelect(75);
			clearOutput();
			//First encounter: 
			if (flags[kFLAGS.TIMES_ENCOUNTERED_COCKATRICES] == 0) {
				outputText("As you follow the trails in the high mountains, the rocky terrain becomes less stable, the path devolving into a series"
				          +" of loose crags with gravel like sediment surrounding large boulders and rough stepping stone-like structures. As you"
				          +" cling to the rock face trying to step from one rock to another you see something in the distance. A figure, perched on"
				          +" one of the outcroppings with surprising ease.\n\n");
				outputText("Though you can’t pick out many details from this distance, the vibrant coloring of this individual makes you think of the"
				          +" harpies that rule the skies here. This is their domain, and you should probably tread carefully."
				          +" [if (hasCock) As you notice your precarious position up here, you hope to all the deities you know that it's not a"
				          +" harpy. Their enthusiasm for your [cock] is something you could really do without, [if (canFly) even though you could use"
				          +" your [wings] to ensure your safety. | especially at such dizzying heights. ]]"
				          +" A scuffle this high up is the last thing you could want.\n\n");
				outputText("Proceeding carefully, you approach the figure, gripping the rock tight as you pull yourself flat against the rough,"
				          +" cool surface. As you sneak closer, the creature’s feathers puff out, causing you to freeze. Holding your breath,"
				          +" you wait, hoping it hasn’t yet noticed your presence. After a few tense moments pass the creature simply leans forward"
				          +" and begins to preen itself, attention focused purely on itself. With a small sigh of relief you work your way across the"
				          +" ridge you had been clinging to, eventually managing to come across a small plateau, a godsend in this uneven terrain"
				          +" which allows you to observe the creature in relative safety.\n\n");
				outputText("The creature before you is easily 6 feet tall, covered in a layer of vibrant midnight blue feathers with"
				          +" turquoise accents.  It appears to be relatively avian in appearance, more so than the harpies you’ve seen flying around."
				          +" It has a beaked face with large feathered ears, reminiscent of those of an owl. A ruff of thicker and fluffier turquoise"
				          +" plumage sits puffed out around its neck, currently the target of its preening. You get a peek at its tight, lithe"
				          +" stomach and flat chest as it stretches, the smooth cream scales of its underbelly framed by its deep blue plumage.\n\n");
				outputText("Its arms are coated in feathers down to the forearm, though around the elbows there also seems to be vestigial wing"
				          +" feathers. While they aren’t huge, they look capable of assisting landings in acrobatic maneuvers and long jumps."
				          +" The visible portion of creature's hands and forearms are a contrast to its bright avian form, being oddly reptilian,"
				          +" coated in black scales and tipped with sharp claws.\n\n");
				outputText("As the creature shifts its stance, evidently done with its grooming, you see that it's definitely some kind of"
				          +" avian/lizard hybrid. It’s long thick tail swings above its tight rear, gradually tapering down into a point."
				          +" It has to be close to half its body length, with a mane of feathers stopping in a v-shape about 4 inches down its length"
				          +" as it transitions from its feathered body into midnight blue scales.\n\n");
				outputText("From its slightly wide hips, powerful feathered haunches transition in reptilian legs at the knee, black scales coating"
				          +" its digitigrade legs.Its three long toes terminate in wicked looking talons, while a smaller emerges at the heel. You"
				          +" don’t want to get on the wrong side of those. You realise as you appraise its vaguely familiar features,"
				          +" that this must be some kind of harpy basilisk hybrid, a Cockatrice!"
				          +" Boy, [benoit name] was right, they are weird looking!\n\n");
				outputText("As it turns to leave, it notices you and its electric blue eyes light up with excitement."
				          +" It jumps from rock to rock with ease, quickly closing in on you with a squawking shout."
				          +" You ready your [weapon] as the creature shows no sign of slowing."
				          +" Looks like you have a fight on your hands!");
				//(spd loss)
				Basilisk.speedReduce(player, 5);
				cockatrice.wingify();
			}
			//Standard encounter:
			else {
				outputText("As you once again climb high in the mountains, you spend some time catching your breath on a rocky plateau to avoid the"
				          +" loose gravelly ground. You see a brightly coloured creature in the distance, hopping from stone to stone with ease and"
				          +" what seems to be enjoyment. As you let out a sigh and move to leave the creature notices you, speedily moving from rock"
				          +" to rock with flaps of its feathers. It approaches squawking with excitement, not slowing in the slightest as it reaches"
				          +" the plateau. You now see it clearly, it's a cockatrice, and you know it won’t or can’t halt in such an excitable state."
				          +" Looks like you’ll have to fight!");
				if (rand(100) < 40) // 40% chance of wings
					cockatrice.wingify();
			}
			if (flags[kFLAGS.CODEX_ENTRY_COCKATRICES] <= 0) {
				flags[kFLAGS.CODEX_ENTRY_COCKATRICES] = 1;
				outputText("\n\n<b>New codex entry unlocked: Cockatrices!</b>")
			}
			startCombat(cockatrice);
			flags[kFLAGS.TIMES_ENCOUNTERED_COCKATRICES]++;
		}
		

		
		//wins
		public function defeatCockatrice():void {
			//spriteSelect(75);
			clearOutput();
	
			if (flags[kFLAGS.SFW_MODE] > 0) {
				clearOutput();
				outputText("You smile in satisfaction as the " + monster.short + " collapses, unable to continue fighting.");
				combat.cleanupAfterCombat();
				return;
			}
			outputText("The Cockatrice falls to his knees panting as he looks over at you.  ");
			//Player HP victory: 
			if (monster.HP < 1)
				outputText("He looks thoroughly beaten, feathers ruffled and face dirtied from debris that rose during the battle."
				          +" The defiant look in his eyes is all that's left of his previous manic energy.  ");
			//Player Lust victory: 
			else
				outputText("He lazily strokes his purple length as he looks up at you with a come-hither gaze. His ruffled feathers,"
				          +" dirtied scales and leisurely pumps manage to make him look quite dashing, even in defeat.  ");
			menu();
			addDisabledButton(0, "Ride Him Vag", "This scene requires you to have a vag and sufficient arousal");
			addDisabledButton(1, "Ride Him Anal", "This scene requires you to have sufficient arousal.");
			addDisabledButton(2, "Buttfuck", "This scene requires you to have a fitting cock and sufficient arousal.");
			addDisabledButton(3, "Oral (Cock)", "This scene requires you to have a cock and sufficient arousal.");
			addDisabledButton(4, "Oral (Vag)", "This scene requires you to have a vag and sufficient arousal.");
			addDisabledButton(5, "Taur sex", "This scene requires you to be a taur or drider, having a cock and/or a vagina and sufficient arousal.");
			//addDisabledButton(6, "Lay Eggs", "This scene requires you to have ovipositor and enough eggs. Bee oviposition requires genitals as well.");
			
			if (player.lust >= 33) {
				outputText("What do you do with him?");
				if (player.hasVagina()) {
					addButton(0, "Ride Him Vag", cockatriceRideHimVag, null, null, null, "Let him fuck your pussy.");
				}
				addButton(1, "Ride Him Anal", cockatriceRideHimAnal, null, null, null, "Let him fuck your butt.");
				if (player.cockThatFits(monster.analCapacity()) >= 0) {
					addButton(2, "Buttfuck", cockatriceButtfuck, null, null, null, "Fuck the cockatrices's ass!");
				}
				if (player.hasCock()) {
					addButton(3, "Oral (Cock)", cockatriceOralCock, null, null, null, "Get a blowjob!");
				}
				if (player.hasVagina()) {
					addButton(4, "Oral (Vag)", cockatriceOralVag, null, null, null, "Get a vaginal blowjob!");
				}
				if (player.isTaur() && (player.hasVagina() || player.hasCock())) {
					addButton(5, "Taur sex", cockatriceTaurButtFuck, null, null, null, "Let him fuck your tauric butt!");
				}
				if (player.isDrider() && (player.hasVagina() || player.hasCock())) {
					addButton(5, "Drider sex", cockatriceDriderButtFuck, null, null, null, "Let him fuck your drider butt!");
				}
			}

			addButton(14, "Leave", combat.cleanupAfterCombat);
		}

		//Player Victory sex:

		//Cockatrice fucks PCs vag
		private function cockatriceRideHimVag():void
		{
			//spriteSelect(75);
			clearOutput();
			rideCockatriceForeplay();
			outputText("\n\nHis cute begging face and the way he keeps his tongue working your [if (hasCock)turgid cock|hungry cunt] regardless of"
			          +" your actions speeds up your decision, making you push him back by his firm but downy shoulders. You slowly make your way to"
			          +" your knees, letting him get a good look at your body as you do so. His breath is coming out in short pants now, devouring"
			          +" you with his raking gaze[if (isLactating) and licking his lips as he gets an eyeful of your milky nipples]."
			          +" Slipping your hand around his curved reptilian length you align him with your hungry cunt, the tip now only centimetres"
			          +" away from your heated flesh. His low groan and feeble attempt to buck his hips show how much he wants this too,"
			          +" but with a slight squeeze you easily halt him.");
			outputText("\n\n\"P…please…\" he hisses, a somewhat melodic nature to his husky voice. If it weren’t for how much you wanted this too,"
			          +" you’d happily continue to tease him so you could have his hypnotic melody caress your senses further. With a small nod you"
			          +" push yourself down on him, smirking as he watches inch after inch disappear into you. He whimpers and shudders under you,"
			          +" squirts of pre coating your insides as his tail thrashes.");
			outputText("\n\nThe combination of his tapered length and it’s bumpy texture causes you to sigh as you reach the bottom of his length,"
			          +" your hot cunt pressing against his cool scales. With a slight squawk, pupils dilated into large circles, he pulls you"
			          +" forward into a heavy open mouthed kiss.  Your [tongue] and his slide across one another, his head tilted to the side to give"
			          +" you better access to his beak as his hand [if (hairLength > 0)threads into your [hair]|cups the back of your head].");
			outputText("\n\nYou begin to rise up his length, the bumps rubbing firmly against your clit with each inch that leaves you. As you reach"
			          +" the tip you slam your hips back down, relishing the feeling of his length rapidly stretching you as the tip pokes your womb."
			          +" You keep this pace as you break the kiss, the regular ascent and rapid descent making lewd");
			if (player.vaginas[0].vaginalWetness >= VAGINA_WETNESS_WET)
				outputText(" squelching");
			else
				outputText(" slapping");
			outputText(" noises as you get closer to your peak. As you ride him the cockatrice suddenly lunges his forward, trapping one of you"
			          +" [nipples] in his mouth. He sucks hungrily as he feels your walls tightening around him, eager to bring you to a climax."
			          +" His hand goes to");
			if (player.breastRows.length > 1)
				outputText(" one of your other nipples");
			else
				outputText(" your other nipple");
			outputText(" as he sucks, pinching your nipple, causing a symphony of gentle suckling, eager fucking and pleasurable pain to encapsulate"
			          +" you. This tips you over the edge as the pair of you thrust together, burying his member deep in your fluttering passage."
			          +" You cry out as you cum [if (cumQuantity > 150)soaking your thighs and his member], your slick channel trying to wring out"
			          +" his seed.");
			if (player.hasCock()) {
				outputText(" Your");
				if (player.balls > 0)
					outputText(" balls churn and tighten, roiling seed begging to be released and your");
				outputText(" [cock] lets loose");
				if (player.cumQ() <= 150)
					outputText(" a few squirts of pearlescent cum, coating your bellies.");
				else if (player.cumQ() <= 350)
					outputText(" squirt after squirt of pearlescent cum, coating your bellies.");
				else if (player.cumQ() <= 1000)
					outputText(" several thick ropes of pearlescent cum, coating your chests and bellies with a thick layer of spooge.");
				else
					outputText(" several thick ropes of pearlescent cum, dousing you both like a perverse fountain.");
			}
			outputText("\n\nUnder you, the cockatrice groans, his cock twitching as his seed begins to surge up it, bloating his member a little as"
			          +" it jets out in thick ropes, determined to thoroughly coat your womb. The pair of you lay there panting for a while, him"
			          +" running a hand through your hair as he chirps softly. When you finally climb off him,"
			          +" [if (cumQuantity > 350)your body slick with your release, with] his seed dripping down your thighs as you");
			outputText(player.armor != ArmorLib.NOTHING ? " get dressed," : " grab your gear,");
			outputText(" you can’t help but smile at him. Already standing again he shakes himself, trying to get himself presentable, but his"
			          +" feathers are puffed out in random directions. The goofball has sex-hair! With a slight laugh, you give him a kiss on the tip"
			          +" of his beak before telling him you had fun.");
			outputText("\n\n\"So did I. Let’s do this again sometime.\" he says with a smile before giving himself one last smooth over before"
			          +" [if (monster.canFly)spreading his wings and taking off|running off deeper into the mountains with a bouncy stride].");
			player.orgasm('Vaginal');
			player.cuntChange(monster.cockArea(0), true);
			dynStats("lib-", 1);
			combat.cleanupAfterCombat();
		}

		//Cockatrice fucks PCs butt
		private function cockatriceRideHimAnal():void
		{
			//spriteSelect(75);
			clearOutput();
			rideCockatriceForeplay();
			outputText("\n\nHis large rounded pupils give him a cute, almost puppy dog look, as he stares up at you. If it werent for his flushed"
			          +" face and lolling tongue adding such a lewd edge, you’d sweep him up into a big hug and pet him. But you have a better idea,"
			          +" one that will make this face seem absolutely innocent by the time you’re done with him. You push him down to the ground by"
			          +" his shoulders, his warm downy feathers caressing your hands as you then kneel down to the same level.");
			outputText("\n\nFor such a lithe creature he has surprisingly good muscle definition, his athletic shoulders supporting your weight with"
			          +" ease. You position yourself so his cock is sandwiched between your [butt], gently grinding his length back and forth."
			          +" Between his copious amount of precum slathering your pucker and the variety of nubs that decorate his length you can’t help"
			          +" but let out a small groan. As you drag his tip across your [asshole], delighting in every spark of pleasure you get as his"
			          +" nubs run over your sensitive flesh, you feel his hands slide to your hips. His eyes are closed as he pants lustily, his"
			          +" lower body tense as he tries to resist thrusting into you and destroying this teasing rhythm you’ve built up. Each twitch of"
			          +" his cock results in another spurt of precum lubing up your cheeks, letting his length glide smoothly between them.");
			outputText("\n\nYou smirk as you suddenly raise your hips, just enough to let his tip rest against your clenched ring, but not enough to"
			          +" let him enter. He lets out a hiss, claws digging into your [butt].");
			outputText("\n\"P…please…\" he hisses, a somewhat melodic nature to his husky voice as you feel his thick cock pressing against your"
			          +" entrance with a little more pressure. While you know you’d love to tease him longer, you want his thick reptile cock in you"
			          +" more. You rock your hips a couple more times, spreading his pre over your entrance before pushing down.");
			outputText("\n\nAs his thick tip slides into your pucker");
			if (player.ass.analLooseness <= ANAL_LOOSENESS_TIGHT)
				outputText(" stretching your tight passage open");
			outputText(" you can’t help but moan. The nubs along his shaft each rub against your sensitive pucker as you slowly take his whole"
			          +" length, and you can’t help but");
			if (player.ass.analLooseness <= ANAL_LOOSENESS_TIGHT)
				outputText(" feel full.");
			else
				outputText(" enjoy his size in your practised asshole.");
			outputText(" His hands come to rest on your ass, squeezing your cheeks lightly as he leans forward and draws you into an open mouthed"
			          +" kiss. He gently rocks his hips, making sure he’s snuggly inside you before he urges you to move with a gentle lift.");
			outputText("\n\nYou begin your ascent, reveling in the way his nubby shaft drags across your insides as his tongue intertwines with your"
			          +" own. You feel a spurt of pre cum splash against your insides, pasting them with slick warmth as you slide back down him. You"
			          +" increase your pace, beginning to bounce on his cock as he lets out a slight squawk in surprise before settling into your"
			          +" rhythm and thrusting with you. You can feel his cock twitch as you ride him, your ass slapping against his thighs with each"
			          +" thrust and your tunnel clenching around him rhythmically, trying to squeeze his release from him as his nubby purple shaft"
			          +" rakes down your sensitive walls.");
			outputText("\n\nHe whines as his claws rake into your cheeks, hips bucking in short, jerky bursts. You can feel his length pulse and"
			          +" twitch inside you as he looks you in the eye pleadingly. With a single rise and fall of your hips and a tight squeeze,"
			          +" you hilt him in your twitching passage. You gasp as his thick hot cum shoots into you, coating your insides with a layer of"
			          +" his masculine slime [if (hasCock)and hitting your prostate with surprising force]. You feel a ripple of pleasure rip through"
			          +" you as you cum");
			if (player.hasCock() || player.hasVagina()) {
				if (player.hasVagina())
					outputText(" your pussy soaking your thighs");
				if (player.hasCock() && player.hasVagina())
					outputText(" and");
				if (player.hasCock()) {
					outputText(" your cock spurting onto his scaled belly, as your testicles shudder as they dispense your");
					if (player.cumQ() < 150)
						outputText(" small load.");
					else if (player.cumQ() < 350)
						outputText(" medium load.");
					else if (player.cumQ() < 1000)
						outputText(" large load.");
					else
						outputText(" colossal load.");
				}
			} else
				outputText(" your asshole twitching and hungrily wringing him dry.");
			outputText("\n\nYou both sit there for a while, enjoying the afterglow and the warmth of each others bodies. You spend a little time"
			          +" enjoying the softness of his feathers on your skin before you remove yourself from him with a wet ‘shlorp’.");
			if (player.armor != ArmorLib.NOTHING)
				outputText(" As you get dressed you give him another glance over.");
			else
				outputText(" As you grab your gear you give him another glance over.");
			outputText(" Already standing again he shakes himself, trying to get himself presentable, but it does nothing as his feathers are puffed"
			          +" out in random directions. The goofball has sex-hair! With a slight laugh, you give him a kiss on the tip of his beak before"
			          +" telling him you had fun.");
			outputText("\n\n\"So did I. Let’s do this again sometime.\" he says with a smile before giving himself one last smooth over before"
			          +" [if (monster.canFly)spreading his wings and taking off|running off deeper into the mountains with a bouncy stride].");
			player.orgasm('Anal');
			dynStats("lib-", 1);
			combat.cleanupAfterCombat();
		}

		//PC fucks Cockatrices butt
		private function cockatriceButtfuck():void
		{
			//spriteSelect(75);
			clearOutput();
			outputText("You make your way over to him, [if (hasArmor) stripping yourself of your [armor] piece by piece, putting on quite the show,]"
			          +" a sensuous sway in your [hips]. He looks up at you from the ground, confusion and lust in his eyes as you bare yourself to"
			          +" him. Throughout the fight you couldn't keep your eyes off his firm, downy rump and now you're gonna claim it for yourself.");
			outputText("\n\nYou order him onto his knees, gently nudging his side as he slowly positions himself, tail drooped over his back end."
			          +" The movement is slow and fluid, his lithe form rippling under his feathers as he rolls onto his hands and knees before"
			          +" looking at you for further instructions. As you appraise his form, you can't help but circle him, taking in every detail of"
			          +" his lithe, fit frame before setting your gaze on your intended target. Reaching down you firmly grope his behind, getting a"
			          +" good feel of those firm cheeks and their soft feathers. He squawks in surprise, jolting forward and thrashing his tail.");
			outputText("\n\nNow, you can't be having that, such a naughty tail getting in your way. You tell him to raise his tail as you get down on"
			          +" [if (isNaga)your coils|[if (isGoo)the ground|your knees]] behind him, cooing about what what a good boy he is as you cup his"
			          +" cheeks affectionately, your thumbs pressing in lightly. Once his tail is moved to the side you can get get a good look at"
			          +" him, the raised base making his cheeks spread a little.");
			outputText("\n\nAs you follow his slightly wide hips with your finger tips and trace over his fluffy rear, you gently tease his cheeks"
			          +" apart so you can see what you have to work with. Between his small, muscular cheeks rests a tight pucker,"
			          +" twitching slightly as you run a finger over it. While he definitely doesn't do it often,"
			          +" he evidently is no stranger to some butt loving on occasion.");
			outputText("\n\nYou suck your fingers a little as you stroke his lower back, coating them with saliva before beginning to tease his ass."
			          +" You gently push your finger in up to the first knuckle, feeling his warm insides cling to you, resulting in a breathy"
			          +" whimper from the cockatrice. With some slow wiggling and turning you begin to lube his entrance, squeezing and massaging"
			          +" his butt and the base of his tail with your free hand.");
			outputText("\n\nBefore long you manage to slip your finger into him entirely, crooking it now and then to drag against his sensitive"
			          +" insides. Each movement brings a shiver to his frame and a slight jerk to his hips, his breath hitching now and then as you"
			          +" slowly begin to withdraw.");
			outputText("\n\nHis purple member strains out from its slit, pre beading at the tip as you knead his behind. Running your free hand up"
			          +" and over his length you use his slick pre to further lube your fingers before introducing a second, this time at as much"
			          +" faster pace. He groans by the time your fingers are at their furthest, his cock twitching towards his belly as his walls"
			          +" stretch around your fingers.");
			outputText("\n\nThrusting them in and out, you try to stretch him slowly while you make sure his tight tunnel is sufficiently slick."
			          +" Once your fingers are moving smoothly back and forth you stroke your [cock] to full hardness. You line yourself up before"
			          +" pulling out your fingers entirely and pushing your [cockhead] into him with a slow constant pressure, relishing in the tight"
			          +" heat that now engulfs you along with the panting whine you draw out from his chest.");
			if (player.longestCockLength() <= 12) {
				outputText(" You slowly feed more of your [cock] into him, reveling in the hot, twitching walls that cling to you, trying to wring"
				          +" you dry with each inch you see disappear.");
				if (player.balls > 0) {
					outputText(" Your [balls] " + (player.balls == 1 ? "presses" : "press") + " firmly against his fluffy cheeks,"
					          +" caressed by his downy plumage in a delightful way.");
				}
			} else {
				outputText(" You slowly try to feed more of your [cock] into his tight cavity, but soon the crushing tightness becomes too much"
				          +" to handle. You sigh a little as you withdraw to a more comfortable position, disappointed you’re too big to give him a"
				          +" proper reaming.");
			}
			outputText(" Each movement you make causes him to shudder, his cock steadily leaking pre as he moans at first in pain"
			          +" and soon in pleasure.");
			outputText("\n\nYou soon begin to thrust, first slowly, gently making sure he’s good and stretched for you, but soon speed up as his now"
			          +" relaxed tunnel lets you bury yourself deep and clings to you hungrily. You can feel the head of your cock push against his"
			          +" prostate with each thrust, causing him to moan out his appreciation as his cock jerks and spurts jets of cum onto the ground"
			          +" and his belly. As he begins to enjoy himself, joining your thrusts as best he can, you surprise him with a sharp spank to"
			          +" one of those tight cheeks, grabbing a handful as you do so. His tail thrashes and his ring tightens, and you can feel"
			          +" yourself swell from the crushing hold he has on you.");
			outputText("\n\nWith a groan you spank him again, this time the other cheek just as you hilt yourself. It feels so good in his pucker,"
			          +" his walls spasming around you while his ring clenches tight around your base. You continue to thrust into him, humping away"
			          +" at him as he shivers and moans under you begging for more.");
			if (player.balls > 0)
				outputText(" You feel your [balls] churning, heavy with thick seed that you can’t wait to pour into him.");
			else
				outputText(" You feel heat welling up in your middle, your cock swelling in preparation of the filling you’re going to give him.");
			outputText(" With one last thrust you ready yourself for release, smacking those firm cheeks one more time, only to let out a strangled"
			          +" groan as your cock pulses within him with no effect,");
			if (player.balls > 0)
				outputText(" your balls tightening and clenching as " + (player.balls == 1 ? "it gets" : "they get") + " hotter and hotter");
			else
				outputText("while the heat in your belly blazes into an inferno");
			outputText("[if (player.hasKnot) and your knot swells, further plugging you inside him].");
			if (player.cocks.length > 1) {
				outputText(" Your other " + (player.cocks.length > 2 ? "cocks only manage" : "cock only manages")
				          +" to spurt white tinged pre that dribbles down your lengths.");
			}
			outputText(" His tight ring stopped you from cumming like some sort of buttslut cock ring!");
			outputText("\n\nThe cockatrice however cums explosively, his bumpy purple length spurting thick reptile cream along the ground and up his"
			          +" chest, some even reaching the underside of his beak before trailing off. He quivers under you, spent and panting, while you"
			          +" try to thrust your way to completion as his sphincter loosens its grip and he relaxes in post orgasmic haze."
			          +" You cum with a whimper[if (cumNormal) spurts of cum coating his insides|[if (cumMedium) as ropes of cum coat his insides,"
			          +" filling him to the brim with heat|[if (cumHigh) as thick jets of cum coat his insides, filling him entirely and spurting"
			          +" out around your [cock]| as you flood his ass, cum coating his insides and backwashing the pair of you into a sticky mess]]],"
			          +" while the heat [if (player.balls > 0)and tightness in your [balls]|in your belly] finally begins to subside.");
			if (player.cocks.length > 1) {
				outputText(" Your other " + (player.cocks.length > 2 ? "cocks coat" : "cock coats") + " his behind further, leaving his ruffled"
				          +" feathers and the underside of his tail a sticky mess, a satisfying sight making his ass look thoroughly claimed.");
			}
			outputText("\n\nYou slip out of him with a wet slurp [if (player.hasKnot)although your knot makes it a little difficult] and you let"
			          +" yourself fall back onto the ground, marveling at how you’ve fucked his tight ass into a hungry dripping hole. You rest for a"
			          +" while before cleaning yourself up[if (hasArmor) and redressing], fully satisfied by this encounter. You leave him there"
			          +" resting and wonder if you’ll get to do this again next time.");
			player.orgasm('Anal');
			player.buttChange(80, true);
			dynStats("lib-", 1);
			combat.cleanupAfterCombat();
		}

		//Cockatrice gives the PC a blowjob
		private function cockatriceOralCock():void
		{
			//spriteSelect(75);
			clearOutput();
			outputText("You casually approach him [if (hasArmor)stripping your [armor] and tossing it aside confidently]");
			outputText(", admiring his prone form. The cockatrice lays on his back, tail lazily resting between his legs as he runs a clawed finger"
			          +" over his pecs. His sapphire eyes are fixed firmly on you, drinking in your naked form. His eyes linger on your"
			          +" [if (hasBreasts)[breasts]|chest] for a while, making your nipples pebble before trailing down to your [cock], your erect"
			          +" shaft[if (cocks > 1)s] making him lick his lips.");
			outputText("\n\nHe definitely know what you expect of him, which makes this a lot easier.");
			outputText("\n\"Time for a little fun.\" you smile as you stand over him and cup his fluffy cheek, guiding him towards your shaft."
			          +" He willingly opens his beak, forked tongue snaking out to drag along the [cockhead] in a torturously slow lick. The forked"
			          +" tips tease your urethra as he withdraws, making you shudder. He seems pleased with this, licking you again, his flexible"
			          +" tongue curling around your length as he tastes you base to tip. His movements become bolder as you encourage him with"
			          +" affectionate rubs of the cheek, and before long he’s actively slurping along your length, swirling around the tip as it"
			          +" begins to bead precum.[if (player.balls > 0) He gently laps at your [balls] every now and then, ensuring they get as through"
			          +" a tongue bath as your shaft[if (hasVagina) and even lifts them up to give your feminine half a good taste too.]"
			          +"|[if (hasVagina) Occasionally his tongue slips further down, seeking out your heated slit, refusing to leave your feminine"
			          +" half untouched.]]");
			outputText("\n\nOnce you’re covered in a shiny layer of saliva, he takes [if (player.longestCockLength > 12) as much as he can manage of]"
			          +" your length into his mouth. His beak is surprisingly soft, more like a firm rubber, and wonderfully warm and wet inside."
			          +" You guide his movements as you sigh in pleasure, helping him establish a steady rhythm as he gently sucks. His tongue pushes"
			          +" up against you with each withdrawal, making sure you get all the stimulation he can offer to the tip. He strokes himself as"
			          +" he sucks, hungrily devouring your length like a worm in response to your moans. You can feel yourself beginning to twitch"
			          +" and pulse in his mouth, your hips starting to jerk with each of his movements and you lace your hands into his feathers,"
			          +" cupping the back of his head.");
			outputText("\n\nWith a moaning whisper of encouragement you thrust your hips harder, burying"
			          +" [if (player.longestCockLength <= 12)your cock in his throat|as much of your cock in his throat as you can],"
			          +" reveling in the tight space and sudden spasms that almost crush your length. His eyes water as he tries to keep up, pretty"
			          +" much humping his hand, while his free hand comes up to"
			          +" [if (player.balls > 0 cup your [balls][if (hasVagina) and thumb your slit|[if (hasVagina)thumb your slit|cup your behind]]]."
			          +" You feel [if (player.balls > 0)your balls clench up as they flood with heat|heat pool in your belly] as your cock jerks,"
			          +" before you explosively release into his belly."
			          +" [if (cumNormal) A few ropes of cum fill his belly, with the last spurt painting his tongue as you withdraw."
			          +"|[if (cumMedium) A few thick ropes of cum fill his belly, with the last spurt filling his mouth as you withdraw."
			          +"|[if (cumHigh) Thick ropes of cum flow into his belly, with you flooding his mouth as you withdraw. His cheeks bulge but he"
			          +" manages to contain most of it, with only a little dribbling down his chin."
			          +"| Thick streams of cum flood into his belly actively bloating him into having a little paunch.You withdraw from him slowly,"
			          +" flooding his mouth just as much. His cheeks bulge before he gags, your virility just too much for him to handle as cum"
			          +" spills from his beak and down his chest. The final jets you release into the open, giving him a facial that makes his"
			          +" feathered features turn blue to white.]]]");
			outputText("\n\nYou let yourself fall to [if (isNaga)your coils|[if (isGoo)the ground|your knees]], panting"
			          +" [if (hasVagina)while your pussy gushes] and heavily as you enjoy the post orgasmic glow in your now spent"
			          +" organ[if (cocks > 1)s]. Once you get your strength back you [if (hasArmor)redress and] look over at the Cockatrice."
			          +" He’s laid on the ground with a content and sleepy gaze [if (cumQuantity > 1000) under those layers of thick cum],"
			          +" hands on his belly and spent member. He gives you a smile, blushing as he lets out a small belch. Seems he enjoyed himself"
			          +" as much as you did. Waving goodbye you turn to return to camp.");
			player.orgasm('Dick');
			dynStats("lib-", 1);
			combat.cleanupAfterCombat();
		}

		//Cockatrice gives the PC a blowjob
		private function cockatriceOralVag():void
		{
			//spriteSelect(75);
			clearOutput();
			outputText("You casually approach him[if (hasArmor) stripping your [armor] and tossing it aside confidently], admiring his prone form."
			          +" The cockatrice lays on his back, tail lazily resting between his legs as he runs a clawed finger over his pecs. His sapphire"
			          +" eyes are fixed firmly on you, drinking in your naked form. His eyes linger on your [if (hasBreasts)[breasts]|chest] for a"
			          +" while, making your nipples pebble before trailing down to your [pussy], your [pussy] making him lick his lips.");
			outputText("\n\nHe definitely know what you expect of him, which makes this a lot easier.");
			outputText("\n\"Time for a little fun.\" you smile as you stand over him and cup his fluffy cheek, guiding him towards your slit"
			          +"[if (player.balls > 0) as you move your balls out of the way]. His forked tongue slips out as he opens his beak, gently"
			          +" running over your mound as his hot breath tickles your [if (vaginalWetness <= 2)slick|slopping] lips. You whine a little,"
			          +" wanting him to lick with more force, before pushing into his beak a little harder. Your clit rubs against the curve of his"
			          +" beak, the firmness against your [clit] exquisite. His tongue delves into your slit, suddenly startling you as it curls up"
			          +" into you before stroking through your puffy wet lips. The flick against your clit as he moves his head back coupled with the"
			          +" drag of his firm beak make your knees jerk and your tunnel clench.");
			outputText("\n\nHe slips his scaled hands around your backside, cupping your cheeks with his thumb claws scratching you lightly. With a"
			          +" slow and deliberate movement he pulls you close and begins to lick you with firm and confident strokes, eager to drink your"
			          +" feminine nectar. His cock stands[if (hasCock) like your own,] painfully erect, pre beading at the tip and slowly sliding"
			          +" down the shaft like wax from a candle. Grinding his face into your needy [cunt], his tongue delves into your tunnel,"
			          +" writhing along your inner walls, seeking out that deep, spongy spot. A warmth builds within your belly, a coiling tightness"
			          +" causing you to seek out a matching rhythm to his tongue.");
			outputText("\n\nWith a melodic hum that travels through his beak and up into your eager bitch-button, his tongue thrusts up against that"
			          +" elusive spot, causing your knees to lock, trapping his face between your thighs. Your [cunt] spasms, trying to milk the"
			          +" intruder as though it were a cock as you thoroughly juice yourself. As you ride out your orgasm"
			          +"[if (hasCock) your cock weakly shooting into the air,] the cockatrice tries to drink up as much of your juices as he can, the"
			          +" rest dripping down his chin and chest. Panting as you blissfully let the fuzzy post orgasmic haze engulf you, you step back,"
			          +" admiring the way he glistens with your honey, his feathers matted.");
			outputText("\n\nOnce you get full control of your [if (isNaga)coils|[if (isGoo)mound|legs]] back, you [if (hasArmor)redress and] thank"
			          +" him for his efforts, kissing him on the tip of his beak and tasting yourself on him. You then turn to leave, listening to"
			          +" the lazy ‘fap’ of him working his purple shaft as he lick himself clean.");
			player.orgasm('Vagina');
			dynStats("lib-", 1);
			combat.cleanupAfterCombat();
		}

		//Cockatrice buttfuck (Taur version)
		private function cockatriceTaurButtFuck():void
		{
			//spriteSelect(75);
			clearOutput();
			outputText("As you decide what to do with the cockatrice, your loins heated with arousal, you realise a you’ll have a hard time managing"
			          +" anything, what with your tauric form being less than compatible with what many folk are packing. Looking around briefly,"
			          +" you notice an alcove on the mountainside which spawns a brilliant idea. You could use the rock to pin him at the right"
			          +" height to fuck your ass with that nubby reptile cock of his. Talk about between a rock and a hard place!");
			outputText("\n\nGrabbing his arm you lead him to the gap, turning before pinning him eagerly with your rump, grinding your tauric rear"
			          +" against him enthusiastically. His surprised squawk quickly devolves into a moan like cooing as his hard cock is engulfed in"
			          +" the embrace of your [hips]. His fluffy plumage tickles your thighs, while his scaled belly glides across your flesh."
			          +" Each bounce of your rear rubs his thighs against your"
			          +" [if (player.balls > 0)ball[if (player.balls > 1)s]|[if (hasVagina)cunt|butt]]"
			          +" while his member prods at your backdoor, slowly lubing you up with his slick pre. His clawed fingers grip your flanks"
			          +" tightly as he tries to push into you, but your grinding ensures he can’t get the angle right. At one point you purposefully"
			          +" push against him hard, feeling his cock crushed between your bodies as he whines with need.");
			outputText("\n\n\"P-please…\" he hisses as his claws dig into your flesh, his round pupils making his begging cute but pitiful."
			          +" You contemplate playing with him longer, idly toying with the idea of rubbing him to release a few times, only to pin him"
			          +" again and get him wonderfully backed up.");
			outputText("\n\"Show me how much you want it.\" you say with a smirk, looking over your shoulder at him. With a grunt of effort and"
			          +" purple flushed cheeks he nods, stilling himself suddenly. Confusion is evident on your face before your expression melts"
			          +" into a shocked ‘o’. Something has squirmed up against your"
			          +" [if (hasVagina)pussy|[if (player.balls > 0)ball[if (player.balls > 1)s]|cock]], something thick and scaly, rubbing itself"
			          +" over you like a perverse fleshy dildo, seeking out your genitals with surprising accuracy."
			          +" [if (hasVagina == false)It coils around your cock, squeezing you in tight pulses[if (player.balls > 0) as closer to the"
			          +" base gently rubs back and forth against your [balls]], hugging you in a warm and soft sheath that flexes with each movement."
			          +" That’s one impressive tail!|It prods the entrance to your pussy, the tapered tip slowly working its way in and stretching"
			          +" you as more of it follows. Slow thrusts cause the scaly appendage to rub your clit each time it stretches you wide, making"
			          +" you feel full as you clench around the intruder. That’s one talented tail!] All the while his cock remains pressed against"
			          +" your back door, twitching and oozing as his tail works your sex.");
			outputText("\n\nWith a quick shift of your hips and a dip of your forelegs, you manage to slip his length into your"
			          +" [if (analLooseness <= 1)tight|practised] passageway, reveling in the dual stimulation you are receiving. His nubby length"
			          +" drags along your walls with each backwards thrust you make, while those delightful bumps tease your"
			          +" [if (analLooseness > 1)stretched|eager] ring on each exit. His tail’s ministrations lessen as you fuck yourself on his cock,"
			          +" his hips bucking to meet you each time you thrust instead. [if (hasVagina == false) The looser grip on your cock lets you"
			          +" glide through his coiled tail with ease, giving you a smooth tailjob, with his tail tensing each time you clench on his"
			          +" purple prick. | Though his tails thrusts are weaker now, your movements make up for it, fucking you on both his cock and his"
			          +" tail, the two tapered lengths rubbing against other another through the thin wall separating them.] His cock twitches as his"
			          +" claws dig into your rear, his hips pumping into you hard as he pulls you against him as best he can. With a forceful thrust"
			          +" he blows his load in your ass, seed coating your innards while his tail"
			          +" [if (hasCock)ripples around your cock|thrusts deep into your cunt]. Your"
			          +"[if (hasCock) cock twitches and bloats as he wrings your length,"
			          +" shooting your load onto the ground[if (cumQuantity > 350) forming a sizable puddle beneath you]."
			          +"| cunt spasms as he hits your cervix, coating his tail with femcum as you shudder"
			          +"[if (issquirter), liberally soaking your crotch and his thighs before tapering off].] You both remain there panting for a"
			          +" while, your legs struggling to hold both of you up while you enjoy the warmth in your gut. You slowly separate and help one"
			          +" another to a more comfy spot where you can recover.");
			outputText("\n\nOnce you feel your strength return to your legs you bid him farewell, noting you may have actually tired him out as he"
			          +" curls up for a nap, feathers puffed out at random angles from your rough treatment.");
			player.orgasm('Anal');
			player.buttChange(80, true);
			dynStats("lib-", 1);
			combat.cleanupAfterCombat();
		}

		//Cockatrice buttfuck (Drider version)
		private function cockatriceDriderButtFuck():void
		{
			const CHOICE_PUSSY:int = 1;
			const CHOICE_COCK:int  = 2;
			var choice:int;
			if (player.hasCock() && player.hasVagina()) // 50/50 chance for herms
				choice = rand(2) == 0 ? CHOICE_PUSSY : CHOICE_COCK;
			else
				choice = player.hasVagina() ? CHOICE_PUSSY : CHOICE_COCK;
			//spriteSelect(75);
			clearOutput();
			outputText("As you decide what to do with the cockatrice, your loins heated with arousal, you realise a you’ll have a hard time managing"
			          +" anything, what with your spider like form being less than compatible with what many folk are packing. Looking around"
			          +" briefly, you notice an alcove on the mountainside which spawns a brilliant idea. You could tie him up in there and get him"
			          +" to use that nubby reptile cock to fuck your ass!");
			outputText("\n\nTaking him by the hand, you lead him to the alcove before using some of your spider silk to tie him up by his arms,"
			          +" holding him in between the two walls. He struggles a little before you shush him and turn around.");
			outputText("\n\"I’m gonna fuck you nice and hard.\" you smile as you back up, positioning your abdomen below him so his thighs rest"
			          +" either side of it, like some kind of parody of him riding you. As he slides towards where your human and spider halves meet,"
			          +" you feel his length pressing between your [if (buttRating <= 4)tight|plush] cheeks"
			          +" while his feathered thighs hug your hips.");
			outputText("\n\nYou gently rock back and forth, making his length grind [if (buttRating <= 4)against|between] your cheeks as he swings"
			          +" slightly. As you use your behind to tease his girthy cock you run your hands over your chest"
			          +" [if (hasbreasts)cupping your [breasts]|trailing over your pecs] as you pinch your [nipples]. You feel wetness trail down"
			          +" your crack, the cockatrice breathing heavily as he enjoys the show and his cock slides against your pucker easier. The nubby"
			          +" texture of his cock makes you shudder, your asshole quivering as your [if (hasCock)[cock] hardens|[cunt] moistens].");

			if (choice == CHOICE_PUSSY) {
				outputText("\n\nYou chuckle as you slip two fingers into your [pussy], exaggerating each thrust and moan as you continue to rock"
				          +" against his freely leaking cock. You look at the cockatrice over your shoulder with a lusty gaze as you pick up speed,"
				          +" starting to schlick yourself with earnest, your clit poking out and begging for your touch."
				          +" [if (player.balls > 0) You cup your [balls] with your free hand, rolling them between your fingers as they begin to roil"
				          +" with seed][if (player.balls > 0 && hasCock), while][if (hasCock) your [cock] smears pre on your belly in a steady"
				          +" bubbling stream, wanting to be buried in a warm, snug hole.] Before long your pussy is leaking nectar as you flick your"
				          +" [clit] while you dip your fingers into your hot and sticky passage, coating them liberally before you wave them under"
				          +" his nose teasingly. His nostrils flare and he moans, shaking his hips to hump at you as best he can, your lusty scent"
				          +" speaking to his pleasure drunk mind. You slip your fingers into his mouth and he greedily sucks them clean with closed"
				          +" eyes, jumping out of this submissive bliss as you spear yourself on his cock.");
			} else {
				outputText("\n\nYou chuckle as you stroke your [cock], exaggerating each stroke and moan as you continue to rock against his freely"
				          +" leaking cock. You look at the cockatrice over your shoulder with a lusty gaze as you pick up speed, starting to jack"
				          +" yourself as pre beads at the tip. [if (player.balls > 0 || hasVagina) You [if (player.balls > 0)cup your [balls],"
				          +" rolling them between your fingers as they begin to roil with seed] [if (player.balls > 0 && hasVagina) and you]"
				          +" [if (hasVagina) feel your pussy slowly leak juices, coating your thighs in sticky girl juices while ignored].]"
				          +" Before long a steady stream of pre leaks from your [cock] and you run a fingertip through it before waving them under"
				          +" his nose teasingly. His nostrils flare and he moans, shaking his hips to hump at you as best he can, your lusty scent"
				          +" speaking to his pleasure drunk mind. You slip your fingers into his mouth and he greedily sucks them clean with closed"
				          +" eyes, jumping out of this submissive bliss as you spear yourself on his cock.");
			}

			outputText("\n\nThe pair of you spend a moment enjoying the sensation of you finally being joined before you buck your hips, starting to"
			          +" use the swaying silk ropes to make him fuck your [if (analLooseness <= 1)tight|spread] butthole. As his length pulls out,"
			          +" the nubs slowly drag and catch on your inner walls, rubbing on your entrance as each one pops out before rapidly spearing"
			          +" you again as he buries his length in you, spreading you open[if (hasCock) as the pointed tip prods your prostate]."
			          +" Each thrust fills the silence with moans and the slap of flesh on flesh, your behind slowly become a little rosy from the"
			          +" force of fucking. You continue to pleasure yourself as you rhythmically clench your tunnel, eager on making him fill you"
			          +" before you cum. The cockatrice’s cock twitches in your ass as he grips your hips with his thighs, humping at your behind"
			          +" desperately as he tried to hold back. With a pulsing shudder, his cock swells and lets loose rope after rope of hot cum deep"
			          +" into your ass. He nips your shoulder as he empties himself into you, triggering you to lose your cool. You cum hard,"
			          +" [if (hasCock) your [cock] spurting pearly white cum against the wall"
			          +" [if (cumQuantity > 350) painting it white by the time it stops]][if (hasCock == true && hasVagina == true) and]"
			          +" [if (hasVagina) your [pussy] soaking your thighs as your walls flutter]"
			          +"[if (player.balls > 0), heat spreading through your clenched [balls] as"
			          +" [if (player.balls > 1)they slowly relax|it slowly relaxes]].");
			outputText("\n\nYou slowly move away and blush as your pucker feels cold, no doubt from the absence of his girthy member."
			          +" Turning as you try to retain your composure while seed slowly drips down your cheeks, you untie the cockatrice and help him"
			          +" to the ground, rubbing his shoulders for a while as you both enjoy the afterglow in each others company. Once you feel ready"
			          +" you bid him goodbye, teasingly saying you’ll have to come back again tomorrow, laughing as his eyes widen and his cock"
			          +" twitches slightly.");
			player.orgasm('Anal');
			player.buttChange(80, true);
			dynStats("lib-", 1);
			combat.cleanupAfterCombat();
		}

		private function rideCockatriceForeplay():void
		{
			const FOREPLAY_NEUTRAL:int = 0;
			const FOREPLAY_BLOWJOB:int = 1;
			const FOREPLAY_VAGINAL:int = 2;
			var chooser:Number = FOREPLAY_NEUTRAL;

			// Intro text 
			outputText("You slowly make your way over to the cockatrice,");
			player.biggestTitSize();
			if (player.armor != ArmorLib.NOTHING) 
				outputText(" stripping out of your [armor] as you approach,");
			outputText(" standing over him as you give him a good look over. Now he isn’t rushing you, you can see he has quite the charming face,"
			          +" a dashing mix of mischievous and kind. As you present yourself to him, he looks up at you,");
			if (player.biggestTitSize() >= BREAST_CUP_H)
				outputText(" or at least tries to, his view of your face obstructed by your bountiful breast flesh.");
			else {
				outputText(" as if asking for permission with his gaze. While he may be head level with your groin which would suggest your intent,"
				          +" he hasn’t moved to touch you once.");
			}
			outputText(" The moment you tell him to start he smiles, scaled hands slowly sliding up the back of your"
			          +" [if (isNaga)serpentine lower body|calves]. Surprisingly smooth and warm, his powerful grip massages up your"
			          +" [if (isNaga)tail|legs], palms coming to rest on your [butt] as he leans forward. The heat of his breath on your"
			          +" [if (hasCock)[cocks]|[if (hasVagina)[vagina]|crotch]] makes you shudder.");

			if (player.hasVagina() && player.hasCock())
				chooser = rand(2) == 0 ? FOREPLAY_VAGINAL : FOREPLAY_BLOWJOB;
			else if (player.hasVagina())
				chooser = FOREPLAY_VAGINAL;
			else if (player.hasCock())
				chooser = FOREPLAY_BLOWJOB;
			else
				chooser = FOREPLAY_NEUTRAL;

			switch (chooser) {
				case FOREPLAY_VAGINAL:
					outputText("\n\nWith a slowness that seems unnatural for a creature that was moments ago bouncing around like a ferret hopped up"
					          +" on sugar, he licks at your folds, his forked tongue dragging over your clit as he nuzzles you affectionately."
					          +" He slowly increases his pace, his tongue dipping into your [vagina] with each lick. He nuzzles your clit as he"
					          +" drives his tongue deeper, fucking you with his tongue with each leisurely flick. His clawed fingers grip your [butt]"
					          +" a little tighter as he looks up at you beggingly. His purple member is slick with pre, his hips gently pumping with"
					          +" the desire to sheathe himself in your slick cunt."
					          +"[if (hasCock) Your neglected [cock] leaks in arousal, pre beading at the tip as you contemplate how you want this.]");
					break;

				case FOREPLAY_BLOWJOB:
					var cockLength:Number = player.longestCockLength();
					outputText("\n\nWith a slowness that seems unnatural for a creature that was moments ago bouncing around like a ferret hopped up"
					          +" on sugar, he licks tentatively at your hardening [cock], his forked tongue slowly flicking across the tip."
					          +" [if (hasVagina) Your pussies walls shudders in sympathetic pleasure, disappointment of not being filled ignored as"
					          +" your bodies shared pleasure helps temporarily sate your dual sexes.] Opening his beak he slowly engulfs the head,"
					          +" his tongue curling around it as he sucks. You’re surprised by how soft his beak is, the edge not hard and sharp as"
					          +" you had expected, but more like a layer of firm rubber. You groan and slide your hands into his feathers, gently"
					          +" rubbing behind his feathered ears as encouragement. He eagerly shoves more of your cock into his mouth with a slight"
					          +" purr, his forked tongue flicking over the tip as he rubs and kneeds your buttcheeks.");

					if (cockLength <= 5) {
						outputText(" As the wet heat of his mouth and the gentle suction tease your [cock] you can’t help but force your length deeper"
						          +" into his mouth, your hips pumping gently. He takes your length with ease, his beak brushing against your crotch"
						          +" [if (hasVagina) your slit dripping | as your [balls] hit his chin] with each thrust.");
					} else if (cockLength <= 12) {
						outputText(" As the wet heat of his mouth and the gentle suction tease your [cock] you can’t help but force your length deeper"
						          +" into his mouth, your hips pumping gently. With some difficulty he manages to take your length, your [cock]"
						          +" entering his throat with each stroke. His beak brushes against your crotch"
						          +" [if (hasVagina) your slit dripping | as your [balls] hit his chin] with each thrust.");
					} else if (cockLength <= 18) {
						outputText(" As the wet heat of his mouth and the gentle suction tease your  [cock] you can’t help but force your length"
						          +" deeper into his mouth, your hips pumping gently. He barely manages to take your length, his throat bulging"
						          +" obscenely as you thrust.");
						if (player.hasVagina() || player.balls > 0) {
							if (player.hasVagina())
								outputText(" Your slit drips");
							if (player.balls > 0)
								outputText(" [if (hasVagina)and your|Your] [balls] swing[if (player.balls == 1)s] roughly");
							outputText(" with each cock sheathing thrust.");
						}
					} else /* if (cockLength > 18) */ {
						outputText(" As the wet heat of his mouth and the gentle suction tease your [cock] you can’t help but force your length deeper"
						          +" into his mouth, your hips pumping gently. Unfortunately your sheer size halts you making much progress, much of"
						          +" your length still simply exposed to the open air, rather than buried deep in his clenching throat.");
						if (player.hasVagina() || player.balls > 0) {
							if (player.hasVagina())
								outputText(" Your slit drips");
							if (player.balls > 0)
								outputText(" [if (hasVagina)and your|Your] [balls] swing[if (player.balls == 1)s] roughly");
							outputText(" with each incomplete thrust.");
						}
						outputText(" You notice his purple member is slick with pre, straining out of his genital slit."
						          +" You contemplate how you you could best use this as you drag your length out of his throat.");
					}
					break;

				case FOREPLAY_NEUTRAL:
				default:
					outputText("\n\nWith a slowness that seems unnatural for a creature that was moments ago bouncing around like a ferret hopped up"
					          +" on sugar, he examines you with a curious look. Your lack of genitals seems to have stumped him. After a moment of"
					          +" silence you sigh, removing yourself from his grip and drag him over to a nearby rock. The flat slab is perfect for"
					          +" you to bend over, presenting your [ass] to him with a slight wiggle. Your [breasts] rub gently against the cool"
					          +" surface as you tell him to get you nice and slick.");
					outputText("\n\nYour [nipples] [if (hasNippleCunts == true || isLactating == true)moisten|harden] as you feel the heat of his"
					          +" breath against your cheeks, his clawed fingers gently digging"
					          +" in as they spread your cheeks so that your [butthole] is exposed. You shiver as his moist breath ghosts over your"
					          +" fluttering tunnel, gasping as something thick and wet begins to probe your depths. His tongue pushes past your ring"
					          +" of muscle with ease, its reptilian forks tickling your sensitive inner walls. As his tongue retreats his hands slide"
					          +" up your sides, gripping your [hips] as he then gives your crack a long, hard lick. As his tongue flicks against your"
					          +" cheeks, you grind your [chest] across the rock, a painful pleasure delighting your senses.");
					outputText("His next rough lick is in a circular motion, punctuated by affectionate nips to your [butt] before jabbing his"
					          +" tongue back inside you. You know that at this point he’s slipped at least an inch of tongue into you, and he doesn't"
					          +" seem inclined to stop until he’s tasted as much of you as he can. As he works his tongue deeper you hear him"
					          +" whimper. With a smirk you turn your gaze to his thick purple member, his throbbing length straining against his"
					          +" belly, a slick trail of pre painting his scales.You decide he’s done a good job on getting you warmed up with that"
					          +" tongue of his, now its time to see if he’s just as good with that thick cock of his.");
			}
		}


		//Player Defeated:
		public function loseToCockatrice():void {
			spriteSelect(75);
			clearOutput();
			//Speed 0 loss: 
			if (player.spe <= 1) {
				outputText("Moving has become intensely difficult. You cannot explain why something that came naturally to you ten minutes ago is now like wading neck deep through quicksand, but that is what moving your limbs now feels like. With a huge, straining amount of effort, you desperately raise your arms and crane your neck away from the basilisk as he approaches you, but with a pathetic amount of ease the creature slides through your guard, grabs you by the chin and looks directly into your eyes. Your reactions are so slow your mind's screaming order for your eyelids to close takes several seconds for your nerves to compute, by which time it is far too late.\n\n", false);
			}
			//HP loss: 
			else if (player.HP < 1) outputText("You fall to your hands and knees, battered and broken. You can't summon the strength or willpower to struggle as the basilisk strides towards you, roughly pulls you to your feet, grabs your chin and forces you to look directly into his face. With one last show of defiance you close your eyes, to which the basilisk responds by backhanding you with increasing force. It is a lost battle and, afraid that it will start using his claws instead, you meekly open your eyes to stare into depthless, watery grey.\n\n", false);
			//Lust loss: 
			else outputText("You can't help yourself. Something about the powerlessness the basilisk instills in you turns you on beyond belief. You don't struggle as the basilisk strides towards you, roughly pulls you to your feet, grabs your chin and forces you to look directly into his face. You want to thank the creature for the privilege of staring into the spellbinding infinity of his grey eyes again. The words freeze on your lips.\n\n", false);
		
			outputText("You stare deep into the creature's eyes. There really is an infinity in there, a grey fractal abyss which spirals upwards and downwards forever. You want nothing more than to spend the rest of your life following him... when the basilisk's pupils dilate, and you feel his hypnotic compulsion press upon your mind, it is as if the universe itself is speaking to you, and you can no sooner resist it than a tadpole can an endless, grey waterfall.\n\n", false);
		
			outputText("It takes several moments for you to realize it when the basilisk steps away from you. You are free of his spell! Except... you can't move. You are standing there, gazing into nothing, and you can't move. You can feel your arms and legs and the breeze on your skin, but the ability to do anything with them is simply not there; it's as if the nerve connections have been severed, leaving you utterly paralyzed. The most you can manage is a raspy half-moan through your still throat. You can't even follow the basilisk with your eyes; although you can feel it; it gives you cause to moan again.\n\n", false);
			//Undo slow to determine if bad end time
			if (player.hasStatusEffect(StatusEffects.BasiliskSlow)) {
				player.spe += player.statusEffectv1(StatusEffects.BasiliskSlow);
				mainView.statsView.showStatUp( 'spe' );
				// speUp.visible = true;
				// speDown.visible = false;
				player.removeStatusEffect(StatusEffects.BasiliskSlow);
			}
			dynStats("spe", player.findPerk(PerkLib.BasiliskResistance) < 0 ? 3 : 1, "lus", 399);
			//Bad end
			if (player.spe < 5 && player.findPerk(PerkLib.BasiliskResistance) < 0 && !player.canUseStare()) {
				basiliskBadEnd();
				return;
			}
			//choose between loss rapes
			if (player.hasVagina() && (player.inHeat || player.findPerk(PerkLib.Oviposition) >= 0 || player.findPerk(PerkLib.BasiliskWomb) >= 0 || player.pregnancyType == PregnancyStore.PREGNANCY_OVIELIXIR_EGGS))
				basiliskHasVagEggStuff();
			else defaultBasiliskRape();
		}
		//Loss, vag rape conditions not met:
		private function defaultBasiliskRape():void {
			outputText("Working briskly, the basilisk tears off your " + player.armorName + " until you are entirely naked. He then rummages through your pockets; it carelessly discards everything it finds without apparent interest. He grabs a handful of gems from your purse and then prowls back to you.\n\n", false);
		
			//Male/Herm: 
			if (player.hasCock()) {
				outputText("With surprising gentleness and deftness, the basilisk rubs your " + player.cockDescript(0) + " with one palm", false);
				if (player.hasVagina()) outputText(" and sticks some of the smaller fingers of his other hand in your " + player.vaginaDescript(0), false);
				outputText(", thankfully angling his sickle claw away. You can't do anything against it, and some of his mental compulsion remains; a backwash of erotic images from your past fill your head, and you can't even grit your teeth as the gentle, insistent pressure brushing your prick makes you rock hard. He stops when you are erect and then, with the very faintest of smiles playing over his cruel mouth, leaves. You're naked, your " + player.cockDescript(0) + " is begging for release; you're utterly helpless... you can only hope that the spell will wear off, and before anything else in the mountain finds you.\n\n", false);
			}
			//Female: 
			else if (player.hasVagina()) {
				outputText("With surprising gentleness and deftness, the basilisk slips the smaller fingers of one hand into your " + player.vaginaDescript(0) + ", and carefully flicks at your " + player.clitDescript() + " with the other, thankfully holding his sickle claws away from you. You can't do anything against it, and some of his mental compulsion remains; a backwash of erotic images from your past fill your head, and you can't even grit your teeth as the gentle, insistent caresses make you wet. He stops when you are beading moisture involuntarily onto his hand and then, with the very faintest of smiles playing over his cruel mouth, leaves. You're naked, your " + player.vaginaDescript(0) + " begs to be filled; you're utterly helpless. You can only hope that his spell will wear off, and before anything else in the mountain finds you...\n\n", false);
			}
			//Genderless: 
			else outputText("Staring into your eyes, the basilisk moves his smaller fingers onto your groin... and then stops. He looks downwards, and then back into your face. You aren't very good at reading lizard facial expressions, but the creature looks distinctly baffled. Finally with a slight shake of his head, it slowly turns and leaves. He has left you paralyzed and naked to the open air, your skin prickling from the exposure. You can only hope that his spell will wear off, and before anything else in the mountain finds you...\n\n", false);
		
			//More to go here?
			var scene:Number = rand(5);
			if (scene == 0) basiliskAdvantageNobody();
			else if (scene == 1) basiliskAdvantageHarpy();
			else if (scene == 2) basiliskAdvantageImp();
			else if (scene == 3) basiliskAdvantageGoblin();
			else basiliskAdvantageMinotaur();
			//INSERT OPTIONAL OTHER MONSTER FINDINGS!
			player.orgasm('Generic');
			dynStats("sen", 1);
			combat.cleanupAfterCombat();
		}
		//basilisk vag rape
		//Requires: Player has vag and is in heat, currently has egg pregnancy, or has oviposition perk
		private function basiliskHasVagEggStuff():void {
			spriteSelect(75);
			player.slimeFeed();
			outputText("The basilisk is breathing heavily as he tears your " + player.armorName + " from your body, his warm exhalations rolling over your naked flesh. He seems to be having difficulty controlling himself; from your frozen gaze you can see it constantly shifting his dreadful slit eyes back to your frame as he searches through your pockets with claws that tremble. Eventually it throws down your attire and stares back into your eyes. There is something else in there now; a pulsing lust, hints of red at the edges of that great, grey sea, a rapacious tide gathering. You wish you could look away but there is more chance of you moving mountains.", false);
			//(Heat: 
			if (player.inHeat) outputText(" You are more aware than ever of an invisible scent simmering off you, of your wet vagina clenching and wetting itself in anticipation, your body begging this male creature to fulfil his genetic objective upon you. Your eyes have betrayed you, your body is betraying you, and whatever else you are is a tiny, ignored voice screaming in between.", false);
			outputText(" The basilisk suddenly breaks away and kneels down in front of you. Out of sight of your petrified eyes you cannot see what it is doing; however a moment later, you can feel, as a warm, sticky sensation slavers over your abdomen.", false);
			//(egg preg:
			if (player.pregnancyIncubation > 1 && player.pregnancyType == PregnancyStore.PREGNANCY_OVIELIXIR_EGGS) outputText(" The basilisk licks your bulging belly hungrily, pushing against and testing for the eggs you are carrying. Your sensitive cargo shifts around under his hungry attention; you'd squirm, but that is, of course, impossible.", false);
			//(heat or perk:
			if (player.inHeat || player.findPerk(PerkLib.Oviposition) >= 0 || player.findPerk(PerkLib.BasiliskWomb) >= 0) outputText(" The basilisk licks your belly hungrily, his sticky tongue crawling like a warm tentacle across your sensitive underside. You'd squirm, but that is impossible. The creature is making you feel everything it is forcing upon you.", false);
			outputText("\n\n", false);
			
			outputText("The basilisk gets up and again stares back into your eyes and you feel his will press indomitably against your pliable mind. At the very edge of your vision, underneath the creature you can see a hint of shiny purple; the creature's cock has slid out of his genital slit. How long it is and what it looks like you cannot see, but as with another raspy moan you finally accept what is about to happen, there is no doubt you are going to get to know about it very personally.\n\n", false);
			
			outputText("The creature suddenly raps something out in his strange, dry tongue, and you feel something - something deep and red - flinch in your mind. Suddenly, you are wet, wetter than you've ever been, your pussy slavering so badly you can hear the pitter-patter of your juices hitting the ground beneath you. The basilisk says something else, more softly this time as he slides in close, his long claws reaching around to clutch your " + player.buttDescript() + ". With a kind of horror you feel your limbs move involuntarily, your arms reaching around the thing's thin, muscled back, your bottom half slackening until you are supported entirely by the wiry strength of the lizard. You expose your crotch in complete submission as the basilisk walks forward, and you feel the head of his cock teasingly touch your dripping, treasonous cunt. As soon as your limbs are where it wants them to be, they lock in position again; you heave at them desperately, but once again your ability to do anything with your own body is simply not there. You are less of a statue and more of a fuck toy, an extension of the basilisk's lust-maddened will. Your jailer keeps walking until you feel the rough surface of a boulder against your back, and using this support the basilisk pushes itself straight into your " + player.vaginaDescript(0) + ".", false);
			player.cuntChange(monster.cockArea(0),true,true,false);
			outputText("\n\n", false);
			
			outputText("Once it has you pinioned, the uncontrollable rut your body has instilled in the basilisk really takes hold and it begins thrusting against you with abandon, his long, thin reptilian cock sliding in and out of your eager, slavering cunt, his hot breath pushing against your face and shoulders. ", false);
			//<(Tight: 
			if (player.looseness() < 4) outputText("Though it is not girthy, it is a perfect fit for your tight hole, and his long length coupled with your drawn up position has you panting as he touches your deepest, most sensitive depths.", false);
			//(Loose: 
			else outputText("At first the sensation is not great, his thin penis quickly lost in your vast, accommodating twat, but then, in between breaths, the basilisk barks out more harsh words. Once again you feel that helpless, red flex in your mind, and suddenly your vagina tightens around it, beginning to eagerly milk the reptile. You desperately wish it didn't and at the same time are hopelessly glad it did; the sensation of your walls pushing and pulling the long, smooth prick in loving synchronisation is unbearably pleasurable.", false);
			outputText(" The rock wall the basilisk is fucking you against grates your back and ass and, lost in his daze the creature's claws dig into your flesh, but these discomforts only serve to heighten the pleasure the creature is forcing you to feel. Its hard stomach beats a steady rhythm against your own as you slather his thighs and crotch with girl cum with the first of many involuntary orgasms, your " + player.clitDescript() + " twitching eagerly for more.\n\n", false);
		
			outputText("The basilisk's rut means it cannot last as long as your hormones crave; although it must have been having his way with you for at least half an hour, it seems all too soon to your supine body when the creature tenses against you, throws his snub head back and with a harsh, dry call begins to fuck you for all it is worth, slamming your paralyzed frame again and again into the rock wall until you feel bruised and dizzy, before it tenses and pours itself into you. You feel warmth spread through you as basilisk jizz floods through your cervix and womb, and you reaching a final bone-tingling plateau of pleasure, made all the more intense by the fact you cannot writhe or cry out; everything is locked up inside of you.\n\n", false); 
		
			outputText("The basilisk collects itself against you while his penis drools its last, sliding his abdomen up and down your body, apparently enjoying the feeling of your soft skin against his own leathery hide- or maybe just enjoying the fact you can't do anything about it. Eventually however he withdraws from your womanhood, trailing your mingled fluids as he goes. He steps languidly back, looks into your eyes with dopey, post-coital satisfaction, and then licks your face with long, tender strokes with his sticky tongue. Again, whether it does this through affection or simply because it can, you can't fathom; you suppose, as you mutely accept the wet, ticklish saliva being lavished all over your face, it doesn't make much difference from where you're standing.\n\n", false); 
		
			outputText("Finally, it whispers something dryly. You were very much hoping that it would let you go once it had taken his pleasure, but that is evidently not the case. It makes you stand still, as you were before; you feel his seed trickle down your leg as your body is guided to attention. He hisses one final afterthought to you, and then leaves, a certain swagger in his stalking gait. Once again, you are petrified, naked, utterly helpless. A backwash of erotic images from your past involuntarily rise up and assault your senses...\n\n", false);
		
			outputText("After about an hour of being forced to stand still and savor your own shameful memories, you find with great relief you can begin to move your toe again. Hard part's over, now. Eventually with some effort you manage to work power into each corner of your body and finally shake free of the basilisk's curse; quickly, you rub the remnants of sticky saliva off your face and redress before anything else finds you, before groggily picking your way back to camp. The cum still oozing from your quim and the occasional twinging memory mean that you aren't going to be able to shake free of the experience as easily as you'd like.", false);
			//(preg check, or change preg to basilisk if egg)
			player.knockUp(PregnancyStore.PREGNANCY_BASILISK, PregnancyStore.INCUBATION_BASILISK);
			//Egg change - 100% chance
			if (player.pregnancyType == PregnancyStore.PREGNANCY_OVIELIXIR_EGGS) {
				outputText("\n\nYour womb gurgles and you instinctively put a hand on your belly. It seems larger than it usually is, and you feel oddly more tender and motherly than normal. You shake your head at the thought. Damn hormones.", false);
				player.knockUpForce(PregnancyStore.PREGNANCY_BASILISK, PregnancyStore.INCUBATION_BASILISK - 150); //Convert Ovi Elixir eggs to Basilisk eggs
			}
			//Eggs fertilised (Ovi Potion/Oviposition only. Eggs take a few days 
			//longer to be laid than usual): 
			player.orgasm('Vaginal');
			dynStats("sen", 1);
			combat.cleanupAfterCombat();
		}
		
		public function basiliskBirth():void {
			spriteSelect(75);
			outputText("\n");
			if (player.vaginas.length == 0) {
				outputText("You feel a terrible pressure in your groin... then an incredible pain accompanied by the rending of flesh. <b>You look down and behold a new vagina</b>.\n\n", false);
				player.createVagina();
			}
			if (player.findPerk(PerkLib.BasiliskWomb) >= 0) {
				outputText("\nA sudden pressure in your belly wakes you, making you moan softly in pain as you feel your womb rippling and squeezing, the walls contracting around the ripe eggs inside you. You drag yourself from your bedding, divesting yourself of your lower clothes and staggering out into the middle of the camp. Squatting upright, you inhale deeply and start to concentrate.");
				outputText("\n\nA thick, green slime begins to flow from your stretched netherlips, splatting wetly onto the ground below you and quickly soaking into the dry earth. You settle easily into the rhythm of oushing with your contractions and breathing deeply when they ebb. The eggs inside you move quickly, lubricated by the strange slime that cushioned them in your womb, sized and shaped just right the pressure of their passage stretches you in the most delightful way, your [clit] growing erect");
				if (player.hasCock()) outputText(" and [eachCock] starting to leak pre-cum");
				outputText(" as you find yourself being moved to climax by the birthing. You see no point in resisting and reach down to begin fiddling with yourself, moaning in pain-spiked pleasure as the stimulus overwhelms you. With an orgasmic cry, you release your eggs into the world amidst a gush of femcum");
				if (player.hasCock()) outputText(" and a downpour of hermcum");
				outputText(".");
				
				outputText("\n\nWhen you find yourself able to stand, you examine what it is you have birthed; ");
				//(eggNumber) 
				outputText(num2Text(Math.floor(player.totalFertility() / 10)));
				outputText(" large, jade-colored eggs, the unmistakable shape of reptile eggs. You pick up one and hold it gently against your ear; inside, you can hear a little heart, beating strong and quick. You put it down carefully with his fellows and stare at your clutch, a queasy tangle of emotions tugging at you.");
		
				//First time:
				if (flags[kFLAGS.BENOIT_EGGS] + flags[kFLAGS.BENOIT_GENERIC_EGGS] == 0) {
					//[Have not laid generic basilisk eggs before, have not laid Benoit's eggs: 
					outputText("\n\nThe seconds drag by and the eggs remain still- the vague hope you harbor that they will immediately hatch, mature and get out of your life slowly vanishes. What are you going to do with them? The only thing you can think of is to take them to Benoit. Although you feel a slight tingle of shame for approaching him like this, you can't think of anyone else who would know what to do with these odd, unborn children of yours.");
				}
				//[Have laid Benoit's eggs: 
				else {
					outputText("The seconds drag by and the eggs remain still. Although you don't like to admit it, you had entertained the soft illusion that the eggs you sired with Benoit were special somehow; the cold fact of the ones in front of you tell you that that is not the case, that the ones forced upon your transformed womb by the mountain basilisks are functionally the same as the ones you have with him. The thought sends a tight shiver up your spine, and you deliberately turn away from it to think of Benoit. You suppose you'll have to take these to him, too. Although you feel a slight tingle of shame for approaching him like this, you can't think of anyone else who would know what to do with these odd, unborn children of yours.");
					outputText("\n\nYou place the egg back down and gather them all up, moving them closer to the campfire to stay warm while you recover from your exertions.");
				}
				
				outputText("\n\nThere is nothing else to be done: you will have to take this batch to Benoit");
				if (flags[kFLAGS.BENOIT_EGGS] > 0) outputText(" as well");
				outputText(". You place the egg back down and gather them all up, moving them closer to the campfire to stay warm while you recover from your exertions.");
				outputText("\n\nWhen the light of day breaks, you gather your newly laid clutch and set off for Benoit's shop. The blind basilisk is asleep when you arrive, forcing you to bang loudly on his door to wake him up.");
				outputText("\n\n\"<i>What is it?!</i>\" He snarls, displaying his fangs when he pops his head irritably out of the door. He stops and inhales through his nose, blushing faintly when he recognizes your scent. \"<i>Oops! [name], I am zo sorry, I did not think it would be you. But why are you here at such an early hour?</i>\"");
				//First Time:  
				if (flags[kFLAGS.BENOIT_GENERIC_EGGS] == 0) {
					outputText("\n\nApprehensively, you explain the situation - you were caught unawares by a basilisk in the mountains, and then... you put an egg into his hand to feel. Benoit is silent for a time, his claws rubbing pensively over the smooth surface.");
					outputText("\n\n“I see,” he says heavily. \"<i>No, you were right to bring zem ere. Zey will be safe with me and 'ell knows I will need all ze eggs I can get if I am to make zis work.</i>\" You breathe an inward sigh of relief and follow him into his shop.");
					if (flags[kFLAGS.BENOIT_EGGS] + flags[kFLAGS.BENOIT_GENERIC_EGGS] == 0) {
						outputText("\n\nHe feels around the clutter of his store room until he finds what he's looking for: A battered old basket stuffed with a soft pillow. You raise an eyebrow at the liberal amounts of dog hair the pillow is covered with and Benoit coughs apologetically.");
						outputText("\n\n“E isn't 'appy about me taking is bed, but to 'ell wizzim; e always gets is 'air on everysing anyway.” You spend some time arranging the eggs where they will be safe and warm. Although you know they can't be, Benoit's blind eyes seem to be fixed upon the brood when you have finished.");
						outputText("\n\n“And zese eggs are different?” he says hesitantly. “Zere will be...little girls?” You shrug and say even if they aren't female, at least he'll have some sons he can keep away from the mountain. He sets his jaw and nods.");
					}
					//[Not first time: 
					else {
						outputText("\n\nBenoit places the eggs into a blanket-swaddled basket with the same painstaking care he did with the others, before turning back to you.");
						outputText("\n\nThe blind basilisk reaches out, finds your hand, and then squeezes it. \"<i>[name], you must be more careful in ze future,</i>\" he says. \"<i>Please understand I am not saying zis because I am jealous or angry or anysing so zilly. You 'ave done a great sing to change your body to 'elp my people, but if you keep getting attacked by my bruzzers and zey find out... if zey work out what you are... I do not like to sink about it.</i>\" You tell him you'll be more on guard in the future and he seems to accept this. He gestures to the corner where he has put together a serviceable stove from scrap.");
						outputText("\n\n“<i>'Ungry?</i>”");
						outputText("\n\nYou linger long enough to share breakfast with him, and then return to camp.");
					}
				}
				//Subsequent: Sheepishly, you give him an egg to feel.  Benoit shakes his head in exasperation, but lets you in.
				else outputText("\n\nHe puts your latest batch with the others and then shares breakfast with you. You leave with his final words lingering in your ears: “More eggs is always good [name], but for ze Gods sake: Be. More. Careful.”");
				outputText("\n");
				flags[kFLAGS.BENOIT_GENERIC_EGGS] += Math.floor(player.totalFertility() / 10);
			}
			else {
				outputText("A sudden shift in the weight of your pregnant belly staggers you, dropping you to your knees. You realize something is about to be birthed, and you shed your " + player.armorName + " before it can be ruined by what's coming. A contraction pushes violently through your midsection, stretching your " + player.vaginaDescript() + " painfully, the lips opening wide as something begins sliding down your passage. A burst of green slime soaks the ground below as the birthing begins in earnest, and the rounded surface of a strangely colored egg peaks between your lips. You push hard and the large egg pops free at last, making you sigh with relief as it drops into the pool of slime.", false);
				player.cuntChange(20,true,true,false);
				outputText(" The experience definitely turns you on, and you feel your clit growing free of its hood as another big egg starts working its way down your birth canal, rubbing your sensitive vaginal walls pleasurably. You pant and moan as the contractions stretch you tightly around the next, slowly forcing it out between your nether-lips. The sound of a gasp startles you as it pops free, until you realize it was your own voice responding to the sudden pressure and pleasure. Aroused beyond reasonable measure, you begin to masturbate your clit, stroking it up and down between your slime-lubed thumb and fore-finger. It twitches and pulses with your heartbeats, the incredible sensitivity of it overloading your fragile mind with waves of pleasure. You cum hard, the big eggs each making your cunt gape wide just before popping free. You slump down, nervous and barely conscious from the force of the orgasm.\n\n", false);
				player.orgasm('Vaginal');
				dynStats("sen", 2);
			
				outputText("You slowly drag yourself into a sitting position, mind still simmering with bliss, and take in the clutch that you have laid. They seem taller and more oblong than other eggs you've seen and they are a strange color: a mottled grey-green. Where have you seen that shade of green before...? A memory rises unbidden to you and you put your hand to your mouth. At the same moment as realization takes hold, a thin papercut line appears in the largest of your eggs. You hunch yourself up and watch in wonder as the cracks spread until, with a final, insistent push, a tiny reptilian face pops out of the shell. It blinks albumen from its rheumy eyes and then, with an infant's awkward industriousness, begins to peel and push its way out of its shell. It trails slime as it crawls forward like a salamander, blinking its big, wide eyes uncertainly, attempting to take in the very large world it has found itself in. Behind it a small cacophony of cracking and wet splintering fills the air as your other children begin to tentatively push their way into existence.\n\n", false);
			
				outputText("In front of you finally are a dozen newly hatched basilisks, crawling around on all fours, the wetness of their eggs slowly drying on their scales, licking each other, flicking their long tails around and blinking at their surroundings with eyes huge in their tiny heads as interest in the wider world takes hold. You can't say whether you find the sight insanely cute or utterly disgusting, and you don't know whether the reason you can't look away is because you are fascinated by the creatures you have brought into this world, or because of the effect of twenty four baby basilisk eyes on you. You suspect in either case the answer is a bit of both.\n\n", false);
			
				outputText("They seem to quickly adapt to where they have found themselves, running around each other with increasing confidence, and you can see even in the short time you have been watching they have grown, their tender scales hardening as the sun and air beats down on them. One of them suddenly scuttles like the lizard it is for cover, and you lose it from view underneath a rock. They are quickly all at it, one after the other dashing and slipping from view. The last to go is the largest, the first to hatch: it fixes you with its stare before slowly turning and following suit. You could swear it gives you the smallest of smiles, a child's eager grin, before it goes. The only evidence you have left of what just happened is a slimy pile of discarded egg shells.\n\n", false);
			
				if (player.cor < 33) outputText("You find yourself shaken by the experience, and deeply disquieted by the thought of the clutch of monsters you have unleashed on this world. You pick yourself up, rub yourself down and leave, promising yourself fervently you'll be more careful around basilisks in the future.\n\n", false);
				else if (player.cor < 66) outputText("You pick yourself up, rub yourself down and leave. You feel conflicted about what just happened; on the one hand you feel disquieted about the dozen monsters you just unleashed on this world, on the other you cannot help feel oddly proud of them and yourself.\n\n", false);
				else outputText("With a soft smile, you get up and leave, enjoying the sensation of green slime trickling down your legs. You cannot wait to get pregnant again, for your stomach to bulge with eggs, to release more delightful creatures into this world which can grow up to fuck you and everyone else in turn, so everyone can enjoy life as much as you do.", false);
			}
			outputText("\n", false);
		}
		
		//basilisk Bad End
		//Requires: Lose to basilisk when Speed is less than 5 (changed from 15 to prevent level 1 gameover -Z)
		private function basiliskBadEnd():void {
			spriteSelect(75);
			clearOutput();
			outputText("Moving has become intensely difficult. You cannot explain why something that came naturally to you ten minutes ago is now like wading neck deep through quicksand, but that is what moving your limbs now feels like. With a huge, straining amount of effort, you desperately raise your arms and crane your neck away from the basilisk as he now approaches you, but with a pathetic amount of ease the creature slides through your guard, grabs you by the chin and looks directly into your eyes. Your reactions are so slow your mind's screaming order for your eyelids to close takes several seconds for your nerves to compute, by which time it is far too late.\n\n", false);
		
			outputText("You stare deep into the creature's eyes. There really is an infinity in there, a grey fractal abyss which spirals upwards and downwards forever. You want nothing more than to spend the rest of your life following it... you fall into that endless abyss for what seems like years, decades, uncharted aeons. You lose all sense of yourself, your situation, your purpose; you do not feel the tips of your fingers slowly turning cold and grey, rivulets of the texture advancing slowly up your hand, any more than you notice the turn of a planet a thousand light years away. There is only the wet grey, and you, an infinitesimally tiny speck lost in a universe, a universe that knows, sees, and controls. When the basilisk's pupils dilate, and you feel its hypnotic compulsion press upon your mind, you can no sooner resist him than a tadpole can an endless, grey waterfall. When he demands that you be horny, you cannot disobey him any more than you can disobey gravity. You are submerged in a sea of sex.", false);
			if (player.gender == 3) outputText(" You moan through your still throat as you feel blood rushing to your groin, your " + player.multiCockDescriptLight() + " stiffening and your " + player.vaginaDescript(0) + " beginning to drip.", false);
			if (player.gender == 1) outputText(" You moan through your still throat as you feel blood rushing to your groin, your " + player.multiCockDescriptLight() + " stiffening.", false);
			if (player.gender == 2) outputText(" You moan through your still throat as you feel blood rushing to your groin, your " + player.vaginaDescript(0) + " beginning to drip.", false);
			outputText(" Every erotic thing that has ever happened to you crowds your head, a dozen sexual sensations are forced upon your senses, and you feel yourself helplessly pushed, fucked, inundated towards an incredible, glorious orgasm...\n\n", false);
		
			outputText("It suddenly stops. The basilisk steps away from you, and you can think again. Except... oh Gods... you still feel incredibly, unbearably horny. You must come! You try to manually push yourself over the edge... you can't. You can't move, you are perched on the brink of a world-shaking orgasm, and... you stare out at the world in mute horror as realization sinks in. In front of you, the basilisk moves its head this way and that, taking you in, admiring its handiwork with an artist's eye before stroking a claw down your arm. You can't feel it, because it, along with the rest of your body, has turned to stone. The creature has petrified you. You can still see, hear, and think- but the only thing you can feel is what is inside you, and what is inside is your body hovering over the very point of sexual release. You can't stand it. You can't stand it for a second longer, and surely the basilisk won't... a smirk appears on his cold, regal face and it bows mockingly, before departing with a flick of his tail. You watch it go with stone eyes, frozen in incredible torment. You really, really wish you could scream.\n\n", false);
		
			outputText("Hours go by. Night begins to fall. You get very used to what you can see in your direct line of vision. You wish you could say you get just as used to the sensation of being trapped on the edge of orgasm, but you don't. Every particle of your body screams for release, the overwhelming sensation drowns any thought you have, and you realize if this lasts much longer you will go insane. By the time the stars start to come out you are bargaining with every deity who might be listening- <i>get me out of this fix, and I will do anything, anything, for whoever saves me. I will be a demon's slave, I will stop drinking so much, I will actually concentrate on saving the world... anything.</i> It is as you are beseeching the heavens in this way for the tenth time that you hear footsteps behind you. Somebody has come for you! It has to be someone who can help you, somebody who cares about you, it HAS to be.\n\n", false);
		
			outputText("A pale blue finger traces the line of your frozen chin before a leering, female face swallows up your line of vision. \"<i>Well, well, well. Look at what we have here,</i>\" purrs the succubus into your cold, marble ear. Other shapes prowl into view, stalking reptile shapes, as the demon runs her hands sensually over your form, testing every smooth surface, protuberance and cranny that she can reach. You cannot feel a thing, except an overwhelming sense of dread. \"<i>Played with the lizards a bit too much did we, friend? I hope you learnt your lesson. It's a real shame, when you think about it.</i>\" The succubus actually sounds almost upset as she looks you over. \"<i>You would have made a fine slave. The things we would have done to you... ah well. Que sera sera. Remove this!</i>\" she straightens up smartly and claps her hands. \"<i>Take this statue to Lethice's castle. I am sure it will look excellent in her front hall, and I know she will appreciate the present.</i>\" The basilisks snake up to you and then heave you into their arms. As they haul you into the night, the succubus's voice reaches you. \"<i>Did you know that marble is a metamorphic rock, statue? It takes tens of thousands of years to wear down. Meta-MORPH-ic, get it? Hahahahahaha!</i>\"\n\n", false);
		
			outputText("You have no voice, and you must scream.", false);
			getGame().gameOver();
		}
		//Defeated, Taken Advantage of: nobody
		private function basiliskAdvantageNobody():void {
			spriteSelect(75);
			outputText("Time stretches by at an agonizingly slow pace as you stand there, a bizarre, motionless flesh statue. You have no way of measuring how much time is passing; the sun is not in your direct line of vision.  You try to move any and every part of yourself in turn, but it is hopeless. Your body is a cage, and you begin to hate the basilisk less because it paralyzed you and more because it left your mind entirely aware of it. Every so often another unbidden backwash of erotic memories overwhelms your senses, keeping you helplessly aroused and reminded of who did this to you. Coupled with the unscratchable itches and the aching in your limbs the experience is one of sensational hell.\n\n", false);
		
			outputText("Eventually, and with gushing, overwhelming joy, you find you can with effort move one of your little fingers again. Concentrating hard, you move backwards from there until you can move your hand, your other fingers, your arm, and then, with a creaking finality, you break entirely free of the paralyzing spell. You spend the next few minutes scratching and touching yourself all over with cries of deepest relief, before putting your garments back on and staggering slowly towards camp. You suppose you should count yourself lucky that nothing found you whilst you were in your incredibly vulnerable state, but you struggle to think of yourself as lucky as you reflect soberly on the last couple of hours.", false);
		}
		//Defeated, Taken Advantage of: Imp
		private function basiliskAdvantageImp():void {
			outputText("Time stretches by at an agonizingly slow pace as you stand there, a bizarre, motionless flesh statue. You have no way of measuring how much time is passing; the sun is not in your direct line of vision.  You try to move any and every part of yourself in turn, but it is hopeless. Your body is a cage, and you begin to hate the basilisk less because it paralyzed you and more because it left your mind entirely aware of it. Every so often another unbidden backwash of erotic memories overwhelms your senses, keeping you helplessly aroused and reminded of who did this to you.\n\n", false);
			
			outputText("You hear a whirring of small wings behind you and something lands on your shoulder. You feel a weary despondency as you guess what it is, right before a reedy, sneering voice speaks into your ear. \"<i>Well, well, well... ain't I the luckiest imp in Mareth?</i>\"\n\n", false);
		
			outputText("The evil little creature wastes no time. Crawling around your motionless face until he is braced against your shoulders and clutching tightly onto your " + player.hairDescript() + ", the imp begins to rub his cock against your cheeks and lips, smearing you with his pre-cum and filling your nose with the smell of it. You will every piece of your strength into moving your arm and batting the creature away, but your body refuses to comply; frozen as you are, you are merely a sex doll to the imp's twisted desires. His cock swiftly grows as he rubs it against your flesh, until it is almost as big as the imp himself, and then with a grunt he pushes against your slightly open mouth.\n\n", false);
		
			outputText("As you suffer this indignity you cling to the hope that your paralysis will prevent the imp from pushing into your mouth, but it quickly becomes apparent that won't be the case. Upon being touched by another creature's forceful desire, of its own will your mouth opens and engulfs the imp's hot, pulsing length. The demon slowly feeds himself in until he is touching the back of your throat, and then begins to thrust himself against you lustily, pulling painfully against your " + player.hairDescript() + " as he does so. You wish you weren't getting turned on about this situation, but you are. You feel another unbidden mental bubble rise up through your mind, old sin and flesh flooding your memory, which coupled with the imp's scent sends blood rushing towards your ignored, stricken groin.\n\n", false);
		
			outputText("You can't pleasure the imp in any way but he doesn't seem to mind; he rubs against your still tongue and cheeks as he pushes into your throat, picking up the pace, his balls slapping against your chin. Eventually with a satisfied, guttural sound he reaches his peak. The giant cock filling your mouth swells and explodes, pushing jet after jet of demonic seed down your gullet. When the imp finally pulls himself out, rivulets of cum dribbles out of your mouth; you feel the tainted substance slowly dripping down your face and onto your front, incapable of doing anything about it. The imp takes the time to fly out in front of you to admire his handiwork, then with an evil grin departs, looking very pleased with himself. You are left to helplessly savor the flavor he has left in your mouth.\n\n", false);
		
			outputText("After what seems like many hours later, you find with a sense of overwhelming relief you can move one of your little fingers again. Concentrating hard, you move backwards from there until you can move your hand, your other fingers, your arm, and then, with a creaking finality, you break entirely free of the paralyzing spell. The first thing you do is wipe the cum off your face and body and urgently wash your mouth out with a nearby spring; but you can feel the creature's warm jizz sloshing deep within you and you know the damage is done. You woozily put your clothes back on and stagger back towards camp.", false);
			//(standard imp cum corruption gain, set lust to 100)
			dynStats("cor", 1);
			player.slimeFeed();
		}
		//Defeated, Taken Advantage of: harpy
		private function basiliskAdvantageHarpy():void {
			spriteSelect(75);
			outputText("Time stretches by at an agonizingly slow pace as you stand there, a bizarre, motionless flesh statue. You have no way of measuring how much time is passing; the sun is not in your direct line of vision.  You try to move any and every part of yourself in turn, but it is hopeless. Your body is a cage, and you begin to hate the basilisk less because it paralyzed you and more because it left your mind entirely aware of it. Every so often another unbidden backwash of erotic memories overwhelms your senses, keeping you helplessly aroused and reminded of who did this to you. Coupled with the unscratchable itches and the aching in your limbs the experience is one of sensational hell.\n\n", false);
			outputText("You hear a shrill cry from above you, half eagle scream and half mocking, female laughter. With a fluttering flap of feathers, a harpy lands at your side before proceeding to stalk around you, taking in your helpless, frozen form with stiff, jerky movements. You reflect bitterly that if the big bottomed bird woman had turned up fifteen minutes ago she would probably have scared the basilisk off. As it is, you are going to have to take whatever she can throw at you... with a stiff upper lip, as it were.\n\n", false);
				
			//Male/Herm: 
			if (player.hasCock()) {
				outputText("The harpy's eyes zero in on your erect cock greedily. Stepping back from you she raises her head and lets out a screech which echoes around the mountains; as answering calls roll back to her she closes in, threads her arms around your neck and scalp and kisses you roughly. She pushes her golden lips against yours and squeezes her rough bird tongue into your mouth. You feel your lips tingle and you raggedly moan against the savage frenching, her hot breath pushing down your throat as she circles your still tongue with her own, before exploring further down towards your tonsils. By the time she has finished with you your whole body feels like it is glowing red from the effect of her lipstick, " + player.sMultiCockDesc() + " straining.\n\n", false);
		
				outputText("You wonder vaguely how she and her no-doubt-soon-to-arrive sisters are going to take advantage of you as you are; you find out a moment later when with no preamble whatsoever the harpy shoves you roughly in the chest. ", false);
				if (player.isBiped()) outputText("You teeter horribly on your frozen heels for a moment and then fall onto your back like a collapsing statue. ", false);
				else outputText("You feel yourself slowly and horribly lose your balance before flopping onto your side like a collapsing statue. ", false);
				outputText("Unable to brace yourself, you bang your head painfully; as you are lying there dazed, you feel something build at the back of your mind. Involuntary sensations prickle your skin and groin as, once again, the intermittent mental backwash that the basilisk's hypnosis has forced upon your mind hits you. Memory after memory of sexually-charged encounters, daydreams or fantasies crowd your consciousness. It is made worse, much worse by the pheromones the harpy has pushed into your mouth; your body rides the chemical glow at the same time as imaginings of soft skin, tight muscle and musk overload your senses. You groan raggedly as " + player.sMultiCockDesc() + " bulges and leaks pre-cum, almost screaming for attention. When you finally, woozily come to your senses, you find that all vision has been blotted out by a big, wobbly harpy bum, her moistening lips rubbing impatiently against your mouth.\n\n", false);
		
				outputText("The bang on the head you took, the harpy lipsticks trilling in your bloodstream and the involuntary tide of erotic memories which ebbs and flows over you mean the next couple of hours goes by for you in a haze of forceful sex. You can't control your cock", false);
				if (player.cockTotal() > 1) outputText("s", false);
				outputText(", your sex drive or what you are thinking about; you are a prisoner of lust and you quickly subside under the sexual concussion, hoping eventually the harpies and your own body will stop fucking you. It does sink in around your second involuntary orgasm, your aching " + player.cockDescript(0) + " spurting ribbon after ribbon of jizz into a harpy's clenching warmth, that the two arriving harpies are not happy with the first one; with your mouth and hands frozen you can't pleasure them with anything but your manhood, which leaves two of them fighting each other for time with your groin whilst a third grinds frustratedly at your face, mainly using your nose to rub at her inner walls and clit, forcing her juices down your nostrils and making you cough raggedly, struggling to breathe.\n\n", false);
		
				//Single cock: 
				if (player.cockTotal() == 1) outputText("Their inability to properly satisfy themselves on your frame raises their tempers and frustration to the point where the three of them are physically fighting each other, treading all over you as they scream, bite and tear, their feathers flying all over the place. Eventually the biggest of the trio drives the other two off, flapping and screeching into the mountains, before throwing herself onto her scratched and battered prize, her eyes lit up and wild. She fucks you with a gusto born of bloodlust, her petit breasts bouncing up and down as she slams her powerful thighs into your " + player.hipDescript() + ", picking up the pace. She quickly forces you to another achingly pleasurable peak, your " + player.cockDescript(0) + " spurting more of your seed deep into her, and then just keeps on working you. Your cock seems incapable of going soft. You feel the involuntary erotic backwash build in your skull again...\n\n", false);
				//Multicock: 
				else {
					outputText("The three of them do eventually work out a compromise however, once they discover you have more than one manpole to your name. One pulls your " + player.cockDescript(0) + " forwards painfully until it is almost pointing towards your face before squatting over it, whilst another clutches at your " + player.cockDescript(1) + " as she spreads her legs and works her way inwards until she is spearing herself on you. You can't see them - you can't see anything except pink wobbly flesh and lavender feathers - but you can hear them shift impatiently around each other as they find a position which is comfortable to them both, their inner walls rubbing you from every direction as they move. The third continues to thrust her needy sex into your face as best she can", false);
					if (player.cockTotal() >= 3) outputText(", crowded out by the bodies of the others despite her transparent desire for the unoccupied man meat flopping against them,", false);
					outputText(" as the other two begin to push and pull your cocks into them, their overcharged libidos taking hold. Your first cock feels like it is being pulled off your body at the same time as its end is being pumped; the sensation of being doubly and brutally fucked like this is unbearably pleasurable and with a series of ragged gasps you tumble helplessly over a sweat-beading peak, your two cocks spurting jizz deep into the two harpies. The third harpy coos as she feels your hot breath on her gaping vagina, and she begins to buck her frustrated sex against your face faster. Trapped in the harpies' clenching holes and incapable of going soft, your cocks continue to get worked as if nothing happened. You feel the involuntary erotic backwash build in your skull again and with a lost moan you fall comatose, incapable of even computing how fucked you are anymore.\n\n", false);
				}
		
				outputText("Eventually you notice that your dick is no longer trapped in sucking wet, and coming out of your daze you find yourself without harpy companions, leaving your petrified form in a mingled pool of harpy juices and your own jizz. After another ten or twenty minutes of being forced to lie there and marinate in your own shameful memories, you find with great relief you can begin to move your fingers again. Eventually with some effort you manage to work power into each corner of your body and finally shake free of the basilisk's curse; quickly, you pick yourself up and redress before anything else finds you and woozily begin to make your way back down the mountain. The whole experience feels like it may have been a lucid sex nightmare to your sluggish mind and you could almost believe it- if you didn't reek of sticky harpy sex and your own musk.", false);
				
				//(add harpy lipstick effect, add 20 fatigue and lose 100 lust if M/H, or add 100 lust if F/U)
				player.changeFatigue(20);
				kGAMECLASS.sophieScene.luststickApplication(20);
				player.orgasm('Dick');
			}
			//Female: 
			else if (player.hasVagina()) {
				spriteSelect(75);
				outputText("The harpy comes to a halt behind you and begins to eagerly run her cold but soft hands over your bottom half, stroking your thighs and squeezing your " + player.buttDescript() + " as if appraising a piece of meat. Whilst caressing your neck she runs her hands between your legs and grabs around your moistened delta impatiently, searching for something that isn't there. She lets loose a squawk of pure frustration and wheels around you to glare in your eyes angrily. The sex-crazed harridan is clearly deeply pissed off with you for lacking a cock she can abuse. She shifts her eyes to your mouth, but quickly arrives at the same conclusion you've already come to: unable to move your mouth, you can't even be forced to give oral pleasure. You feel a bizarre sense of triumph over the creature; you stare into space smugly as the harpy paces in front of you, glaring, thwarted but unwilling to give up her prize. Perhaps eventually she will leave you alone...?\n\n", false);
		
				outputText("The harpy suddenly closes in, threads her arms around your neck and scalp and kisses you roughly. She pushes her golden lips against yours and squeezes her rough bird tongue into your mouth. You feel your lips tingle and you raggedly moan against the savage frenching, her hot breath pushing down your throat as she circles your still tongue with her own, before exploring further down towards your tonsils. By the time she has finished with you your whole body feels like it is glowing red from the effect of her lipstick, and your " + player.vaginaDescript(0) + " is leaking moisture down your thigh. Maddeningly, the harpy ignores your needy sex and continues to stalk around you, a vengeful smirk changing to a thoughtful frown on her ferociously beautiful face. You wish you could thrust your vagina towards her, make her heed the plight of your lust-racked body; hell, you are even beginning to wish you could give her head so she would at least consider rewarding you...\n\n", false);
				
				outputText("You feel something build at the back of your mind. Involuntary sensations prickle your skin and inner walls as, once again, the intermittent mental backwash that the basilisk's hypnosis has forced upon your mind hits you. Memory after memory of sexually-charged encounters, daydreams or fantasies crowd your consciousness. It is made worse, much worse by the pheromones the harpy has pushed into your mouth; your body rides the chemical glow at the same time as imaginings of soft skin, tight muscle and musk overload your senses. Your " + player.vaginaDescript(0) + " flexes and drools fluid as your " + player.clitDescript() + " bulges with need, almost screaming for attention that it isn't going to get. The denial the petrification has forced upon you is unbearable.\n\n", false);
		
				outputText("It takes a long time for your mind and body to calm down enough for you to take in what's happening outside of your frozen form. There is an odd, wet, rubbery sensation on your hand, still raised in its futile attempt to ward the basilisk, and you feel pressure upon your shoulder. A harpy foot pushes into your face and you hear grunts of frustration mixed with the odd croon of satisfaction from somewhere slightly above you. You can't see exactly what she's doing but it doesn't take a genius to make an educated guess: braced against your upper body and using her wings to keep herself aloft, the harpy is using the only part of your body she can to take some measure of satisfaction from you. You feel your petrified fingers sliding up, down and around her large, egg-laying snatch as she manipulates her body as best she can, feet pushing into you impatiently. One finger hooks into her hole at the same time as another digit rubs against a soft nodule which can only be her clit; she coos at this sudden success and you feel her juices drip down your arm. She begins to pick up the pace, flapping her well padded behind against your hand eagerly, taking in more of your crooked fingers into her warm, accommodating cunt. Your own juices begin to build afresh as, with a sensation of deep apprehension, you feel the erotic backwash build again...\n\n", false);
		
				outputText("The harpy manages to cum twice on your hand, gobbling with excitement as she spatters your arm with her juices. During this time you are forced to ride the potent cocktail of hypnotic sexual compulsion and the pheromone lipstick again and again, until you feel you would have collapsed in a pool of steaming sex long ago if your knees allowed it. Once she is finished with you the harpy clambers down, taking care to wipe her leaking twat on your naked front as she does so, before flapping off with a winsome smirk, entirely ignoring your own achingly deprived sex.\n\n", false); 
		
				outputText("After another ten or twenty minutes of being forced to stand still and savor your own shameful memories, you find with great relief you can begin to move your fingers again. Eventually with some effort you manage to work power into each corner of your body and finally shake free of the basilisk's curse; quickly, you redress before anything else finds you and, still reeking of harpy sex, you begin to make your way back down the mountain. You think woozily that maybe you should consider yourself lucky that nothing actually fucked you whilst you were in your helpless state, but your body thinks the exact opposite, and you really, really need to get back to camp and sort yourself out.", false);
				dynStats("lus=", player.maxLust());
			}
			//Genderless: 
			else {
				outputText("The harpy comes to a halt behind you and begins to eagerly run her cold but soft hands over your bottom half, stroking your thighs and squeezing your " + player.buttDescript() + ", as if appraising a piece of meat. Whilst caressing your neck she runs her hands between your legs and grabs around your groin, searching for something that isn't there. She lets loose a squawk of pure frustration and wheels around you to glare in your eyes angrily. The sex-crazed harridan is clearly deeply irritated about finding such a helpless victim only to further discover they lack a cock which she can abuse. She shifts her eyes to your mouth, but quickly arrives at the same conclusion you've already come to: unable to move your mouth, you can't even be forced to give oral pleasure. You feel a bizarre sense of triumph over the creature; you stare into space smugly as the harpy paces in front of you, glaring, thwarted but unwilling to give up her prize. Perhaps eventually she will leave you alone...?\n\n", false);
		
				outputText("The harpy suddenly closes in, threads her arms around your neck and scalp and kisses you roughly. She pushes her golden lips against yours and squeezes her rough bird tongue into your mouth. You feel your lips tingle and you raggedly moan against the savage frenching, her hot breath pushing down your throat as she circles your still tongue with her own, before exploring further down towards your tonsils. By the time she has finished with you your whole body feels like it is glowing red from the effect of her lipstick. The harpy goes back to stalking around you, a vengeful smirk changing to a thoughtful frown on her ferociously beautiful face. Your body feels like it is pushing for a way to release the lust building up in you and finding no way out- you almost wish you did have a cock so the harpy would at least consider rewarding you...\n\n", false);
		
				outputText("You feel something build at the back of your mind. Involuntary sensations prickle your skin as, once again, the intermittent mental backwash that the basilisk's hypnosis has forced upon your mind hits you. Memory after memory of sexually-charged encounters, daydreams or fantasies crowd your consciousness. It is made worse, much worse by the pheromones the harpy has pushed into your mouth; your body rides the chemical glow at the same time as imaginings of soft skin, tight muscle and musk overload your senses. The denial the petrification has forced upon you is becoming unbearable.\n\n", false);
		
				outputText("It takes a long time for your mind and body to calm down enough for you to take in what's happening outside of your frozen form. There is an odd, wet, rubbery sensation on your hand, still raised in its futile attempt to ward the basilisk, and you feel pressure upon your shoulder. A harpy foot pushes into your face and you hear grunts of frustration mixed with the odd croon of satisfaction from somewhere slightly above you. You can't see exactly what she's doing but it doesn't take a genius to make an educated guess; braced against your upper body and using her wings to keep herself aloft, the harpy is using the only part of your body she can to take some measure of satisfaction from you. You feel your petrified fingers sliding up, down and around her large, egg-laying snatch as she manipulates her body as best she can, feet pushing into you impatiently. One finger hooks into her hole at the same time as another digit rubs against a soft nodule which can only be her clit; she screeches at this sudden success and you feel her juices drip down your arm. She begins to pick up the pace, flapping her well padded behind against your hand eagerly, taking in more of your crooked fingers into her warm, accommodating cunt. You groan as you feel the erotic backwash build again...\n\n", false);
		
				outputText("The harpy manages to cum twice on your hand, gobbling with excitement as she spatters your arm with her juices. During this time you are forced to ride the potent cocktail of hypnotic sexual compulsion and the harpy's golden lipstick again and again, until you feel you would have collapsed in a pool of steaming sex long ago if your knees would only allow it. Once she is finished with you the harpy clambers down, taking care to wipe her leaking twat on your naked front as she does so, before flapping off with a winsome smirk, entirely ignoring your own plight.\n\n", false);
		
				outputText("After another ten or twenty minutes of being forced to stand still and savor your own shameful memories, you find with great relief you can begin to move your fingers again. Eventually with some effort you manage to work power into each corner of your body and finally shake free of the basilisk's curse; quickly, you redress before anything else finds you and, still reeking of harpy sex, you begin to make your way back down the mountain. You think woozily that maybe you should consider yourself lucky that nothing actually fucked you whilst you were in your helpless state, but your body thinks the exact opposite, and you really, really need to get back to camp and sort yourself out.", false);
				dynStats("lus=", player.maxLust());
			}
		}
		//Defeated, Taken Advantage of: goblin
		private function basiliskAdvantageGoblin():void {
			spriteSelect(75);
			outputText("Time stretches by at an agonizingly slow pace as you stand there, a bizarre, motionless flesh statue. You have no way of measuring how much time is passing; the sun is not in your direct line of vision.  You try to move any and every part of yourself in turn, but it is hopeless. Your body is a cage, and you begin to hate the basilisk less because it paralyzed you and more because it left your mind entirely aware of it. Every so often another unbidden backwash of erotic memories overwhelms your senses, keeping you helplessly aroused and reminded of who did this to you.\n\n", false);
		
			//Male/Herm: 
			if (player.hasCock()) {
				outputText("At the corner of your vision, you see a small, familiar green shape hover into view. The goblin is so busy sorting through her inventory of drugs that you actually manage to see her before she sees you. When she does lift her head up and notices the petrified, naked individual in front of her, she is so surprised she drops her satchel.\n\n", false);
		
				outputText("\"<i>A " + player.race() + "!</i>\" she yelps. Then, after shifting her startled attention downwards, \"<i>A cock!</i>\" Hesitantly at first, then with increasing confidence as how vulnerable you are sinks in, she does a round circuit of you, taking in every angle of your frozen, helpless flesh.\n\n", false); 
				
				outputText("\"<i>Get caught with our pants down by a basilisk, did we, stud?</i>\" she purrs. \"<i>Well, not to worry. I'll take good care of you.</i>\" You somehow doubt her good intentions, and your suspicions are confirmed when, after completing her sauntering circumference of you, she shoves your bottom half as hard as she can. You fall slowly like a wooden board; being unable to brace yourself, the sensation of dropping is horrible, and, once your skull connects with the ground, painful. Before you can clear your swimming vision you feel the goblin's soft, dense weight on your chest, and then her eager lips upon yours, sucking and lavishing every inch of your frozen mouth that her tongue can reach. A tingling sensation spreads from your mouth downwards as her drug-laced lipstick takes effect. By the time she has finished with your mouth and worked her way downwards, your " + player.cockDescript(0) + " is bulging with need and springs readily into her warm hands like a loyal pet.\n\n", false);
		
				outputText("The goblin is in no hurry- it's not as if you can stop her- and spends time teasing your cock, working her fingers up and down your length and trailing her tongue around your head, slowly lapping up the pre-cum you inevitably ooze. You don't want to give the miniature rapist the slightest bit of satisfaction but her drugged lips have made your cock incredibly sensitive and needy, and soon you are gasping and panting through your still mouth with each soft, masterful touch. You try and peak as quickly as you can but the goblin knows exactly what she's doing- any time you get close she squeezes near the bottom of your shaft, agonizingly prolonging your arousal. You try and channel your lust into moving your limbs or even just into your abdomen to shake her off, but the basilisk's spell holds; you are a fallen flesh statue, or as far as the goblin is concerned, a giant dildo with some fun extras attached. You force air through your throat to groan wordlessly, trying to plead the goblin to stop, in reply to which she giggles maliciously. \"<i>You like that do you, " + player.mf("stud","bitch") + "? I guess you're ready.</i>\"\n\n", false);
		
				outputText("You feel her pick herself up and then begin to work her sopping vagina down onto your head. ", false);
				var x:Number = player.cockThatFits(60);
				if (x < 0) x = 0;
				//(more than goblin vag capacity: 
				if (player.cockArea(x) >= 60) outputText("\"<i>Ooh, you tease,</i>\" she coos as her wet warmth nuzzles the tip of your member. \"<i>Not just a stud ready and waiting for me to ride, but one with a cock so big I can't even use it! I'm half tempted to leave and come back with something to shrink this down!</i>\" Even a goblin's elastic twat can't take this much of you, and she rocks atop your straining, sensitized dick. She begins to slide herself around the crown, moaning shamelessly as she reaches her limit each time.", false);
				//less than goblin vag capacity: 
				else outputText("Her wet warmth swallows more and more of your member until, with a satisfied sigh, her plump thighs bump into your crotch. With your sensitised cock you can feel every inch of her, and when she starts to slide up and down the sucking, kneading sensation is unbearable.", false);
				outputText(" You cannot last long in the rut the goblin has chemically induced in you and against her thrusting and milking twat you quickly ejaculate, endless hot fluid spurting out of your cock into her welcoming sex. Unable to move a muscle except for your eager, flexing penis, you feel like your body is being pressed to the ground by an invisible wall, with your cock trapped by a mercilessly loving, milking hole, a prisoner of sex. The goblin continues to thrust away even as your seed dribbles out of her snatch and onto your body, and you groan as it sinks in that your hypersensitive throbbing cock is still rock hard.\n\n", false);
		
				outputText("\"<i>That was good for a first effort, stud,</i>\" the goblin's giggling voice reaches your ears. \"<i>But you've got lots more man sauce locked up inside of you, don't you? Yes you do. And you're going to give me it all.</i>\" As the insatiable little green monster picks up the pace, her juices mingling with yours as they trickle onto the ground beneath you, you feel the erotic mental backwash build again, and you go comatose under the overwhelming, uncontrolled rush of sexual sensation...\n\n", false);
		
				outputText("Eventually, after what seems like hours of forcible ejaculation, you notice that your dick is no longer trapped in sucking wet. You come out of your daze you find that the goblin has left, leaving your petrified form in a mingled pool of her juices and your own jizz. After another ten or twenty minutes of being forced to lie there and marinate in your own shameful memories, you find with great relief you can begin to move your fingers again. Eventually with some effort you manage to work power into each corner of your body and finally shake free of the basilisk's curse; quickly, you pick yourself up and redress before anything else finds you and woozily begin to make your way back down the mountain. The smell of horny goblin on you is a lingering reminder of what just happened to you.", false);
				player.orgasm('Dick');
			}
			//Unsexed: 
			else if (!player.hasVagina()) {
				outputText("At the corner of your vision, you see a small, familiar green shape hover into view. The goblin is so busy sorting through her inventory of drugs that you actually manage to see her before she sees you. When she does lift her head up and notices the petrified, naked individual in front of her, she is so surprised she drops her satchel.\n\n", false);
		
				outputText("\"<i>A " + player.race() + "!</i>\" she yelps. Hesitantly at first, then with increasing confidence as how vulnerable you are sinks in, she does a round circuit of you, taking in every angle of your frozen, helpless flesh.\n\n", false);
		
				outputText("\"<i>Get caught with our pants down by a basilisk, did we?</i>\" the goblin purrs. \"<i>Well, not to worry. I'll take good c- hey, what gives?!</i>\" From behind you, you feel her hands thread their way around your " + player.legs() + " before feeling and slapping all around your featureless groin. \"<i>This is fucking bullshit!</i>\" she howls. \"<i>I get a toy that can't stop me all to my lonesome, and it's some colossal jerkoff who thinks it's funny to have no sex!</i>\" She stomps around to your front and glares at you, simmering with rage. \"<i>I bet you think you're a real smartass, you bastard... you bitch... you... whatever! Ooh, I'll fix you!</i>\" With a look of complete disgust she storms off. Having faced down this bizarre rant, you allow yourself to feel a tiny bit of relief. You were worried for a moment there she'd go for your ass... a short distance away, you hear the goblin calling to someone.\n\n", false);
		
				outputText("\"<i>Hey you! Yeah you, shit-for-brains! Wanna free assfuck? Come and get it then, you ugly, dumb muscle-bound moron!</i>\" A moment later you feel a slap on your calf as the goblin runs past you, giggling. \"<i>Have fun, smartass!</i>\" A huge, angry bellow vibrates the air around you and the earth shakes as something big approaches you from behind. You strain with every sinew of your being to escape, but you are, as ever, glued in place. You manage a raspy moan as the enraged minotaur grasps you roughly by both arms, his animal musk filling your nostrils. <i>Fucking goblins.</i>\n\n", false);
		
				outputText("The huge bull-man is not one to look a gift fuck in the mouth. Without bothering to take you in, bar a long wet sniff of your " + player.hairDescript() + ", he sticks his cock between your ass cheeks. He grunts as he forces his head past your sphincter, squirting pre-cum into your passage as he does so. Your body is incapable of clenching instinctively against the invasion, but there is no escaping how huge the dong feels as he impatiently forces your ass open.", false);
				player.buttChange(60,true,true,false);
				if (player.analCapacity() < 60) outputText(" The giant cock stretches you out painfully, and everything else blots out as your body attempts to accommodate the beast. As he begins to thrust more of his length up you, he grunts and beads more of his drugged pre-cum, lubricating your anus. This thankfully makes his cock easier to take, but also increases the pace of his thrusting as your hole becomes more receptive to it.", false);
				//V loose/Buttslut: 
				else outputText(" Your well-worn ass is a perfect fit for the giant cock and accepts it eagerly, every bit as welcoming as a moist vagina. As the minotaur rubs against your tender inner walls he grunts and beads more of his drugged pre-cum, turning your hole into a helplessly wet, clenching ass cunt.", false);
				outputText(" You begin to pant from exertion and the overpowering sensation of the fuck as you feel first one ring and then a second push past your sphincter, then out again, then in and out as the minotaur picks up the pace. As rut takes hold of him, he picks you up by your arms and uses his strength to force you up and down his dick, using you as a cocksleeve to sate his animalistic desires. Your ass is slick with his pre-cum by now however, and the drugged slime has bumped you upwards into a hazy high; only the height of his downward thrust when his dick is almost completely buried in your bowels brings you out of it, the painful intensity of it dragging you down of your cloud with a gasp.\n\n", false);
		
				outputText("Eventually the minotaur's balls swell against your " + player.buttDescript() + " and with a long, satisfied moo, he reaches his peak, holding you down so his cum jets forth deep inside you. The sensual high it has already instilled in you amplifies by tenfold as the warm, oozing fluid finds its mark and you moan as you spontaneously orgasm, your anus helplessly milking the creature for all it can get.\n\n", false);
		
				outputText("The minotaur holds onto you until he has finished spurting his last into you, before abruptly setting you back down on your frozen feet, pulling his slimy, receding member out of your abused anus and with a satisfied snort, takes his leave. You feel his cum drooling out of you and down your " + player.hipDescript() + ", but in your hazy, druggy state the feeling is almost sensual.", false);
				//(Addict: 
				if (flags[kFLAGS.MINOTAUR_CUM_ADDICTION_STATE] > 0 || player.findPerk(PerkLib.MinotaurCumAddict) >= 0) outputText(" You're incredibly frustrated that you can't clench yourself and hold the magical substance deep inside you, so you can savor the wonderful, soft elation it blossoms inside of you for as long as you can.", false);
				outputText("\n\n", false);
				
				outputText("Eventually, after another thirty or so minutes of being forced to stand there and savor the cum trickling down your legs, you find with great relief you can begin to move your fingers again. With some effort you manage to work power into each corner of your body and finally shake free of the basilisk's curse; quickly, you shake the aching out of your " + player.legs() + " and re-dress before anything else finds you and woozily begin to make your way back down the mountain, trying to ignore the feeling of ooze dripping out of you.", false);
				player.orgasm('Anal');
				player.slimeFeed();
			}
			//Female: 
			else {
				outputText("At the corner of your vision, you see a small, familiar green shape hover into view. The goblin is so busy sorting through her inventory of drugs that you actually manage to see her before she sees you. When she does lift her head up and notices the petrified, naked individual in front of her, she is so surprised she drops her satchel.\n\n", false);
		
				outputText("\"<i>A " + player.race() + "!</i>\" she yelps. Hesitantly at first, then with increasing confidence as how vulnerable you are sinks in, she does a round circuit of you, taking in every angle of your frozen, helpless flesh.\n\n", false);
		
				outputText("\"<i>Get caught with our pants down by a basilisk, did we slut?</i>\" she purrs. \"<i>Well, not to worry. I'll take good care of you.</i>\" You somehow doubt her good intentions, and your suspicions are confirmed when, after completing her sauntering circumference of you, she shoves your bottom half as hard as she can. You fall slowly like a wooden board; being unable to brace yourself, the sensation of dropping is horrible, and, once your skull connects with the ground, painful. Before you can clear your swimming vision you feel the goblin's soft, dense weight on your chest, and then her eager lips upon yours, sucking and tonguing every inch of your frozen mouth that she can reach. A tingling sensation spreads from your mouth downwards as her pheromone-laced lipstick takes effect. By the time she has finished with your mouth and worked her way downwards, your paralyzed body feels warm and receptive, and your " + player.vaginaDescript(0) + " is wet with need. You feel small fingers caressing your mons before slipping their way inside, circling your " + player.clitDescript() + " before testing your depths. You wish you could cringe away or even thrust yourself forward to try and make the goblin better address your growing need, but that is impossible; you stare in front of you, petrified, as the fingers continue their lazy tour of your sex until your juices are running like a river in spring.\n\n", false); 
		
				outputText("\"<i>You are well up for this, aren't you hun?</i>\" coos the goblin as she begins to flick your sopping clit, sounding delighted with the involuntary heat she has stoked within you. \"<i>It's such a shame that I don't have the big cock you obviously want and need. Don't worry though; I've got the next best thing!</i>\" You hear her rummage around in her satchel, which is followed by the sounds of her wetly sucking on something with obvious enthusiasm. You shrink inwardly as you make a strong guess as to what she's holding and what she intends to do with it. Sure enough, a moment later you feel a dildo pushing unceremoniously into your " + player.vaginaDescript(0) + ".", false);
				player.cuntChange(30,true,true,false);
				//[(tight)
				if (player.vaginalCapacity() < 30) outputText(" You didn't get the wet end, and you groan as you feel the thing begin to puff up as it reacts with your eager juices until it is pushing almost painfully against your inner walls.", false);
				else outputText(" You didn't get the wet end, and you groan as you feel the thing begin to puff up as it reacts with your eager juices until it fills your well-used passage almost perfectly.", false);
				outputText(" You feel the goblin crawl on top of you, pulling the dildo upwards so it rubs against your " + player.clitDescript() + " and then with a squealing giggle impales herself on the other end. Her lustful movements translate through the artificial cock buried in your dripping sex, sending tremors and waves of pleasure to your very core. A gush of female fluid splatters over your own sex as the goblin works herself right down the shaft connecting you until she is squelching against you wetly. The goblin twists, grinding and scissoring her thighs, the hard bud of her clit rubbing back and forth over your own. By now your passage feels as stuffed as it ever has been, crammed totally full of the squishy expanded double-dong. Every motion the tiny slut makes is amplified directly into the fuck-stick plugging your " + player.vaginaDescript(0) + ". Judging by how wonderful it feels rubbing and twisting against your sensitive walls, the aphrodisiac it is leaking into you is definitely having an effect. You whine at the goblin twists herself and her dildo around, rubbing and riding you so effectively, the involuntary tide of erotic memories building again...\n\n", false);
		
				outputText("After cumming over and over again in tandem with the dominant little slut she eventually takes mercy upon you, leaving you lying in a pool of mingled girl cum, dazed by the hypnotic backwash and the drugs which have left you so hazy and sensitive. After another ten or twenty minutes of being forced to lie there and marinate in your own shameful memories, you find with great relief you can begin to move your fingers again. Eventually with some effort you manage to work power into each corner of your body and finally shake free of the basilisk's curse; quickly, you pick yourself up and redress before anything else finds you and woozily begin to make your way back down the mountain. The smell of horny goblin on you is a lingering reminder of what just happened to you.\n\n", false);
		
				//(lose 100 lust, stretch vagina according to d.dildo rules if F, stretch anus according to minotaur and increment addiction if U)
				player.orgasm('Vaginal');
			}
		}
		//Defeated, Taken Advantage of: minotaur
		private function basiliskAdvantageMinotaur():void {
			spriteSelect(75);
			outputText("Time stretches by at an agonizingly slow pace as you stand there, a bizarre, motionless flesh statue. You have no way of measuring how much time is passing; the sun is not in your direct line of vision.  You try to move any and every part of yourself in turn, but it is hopeless. Your body is a cage, and you begin to hate the basilisk less because it paralyzed you and more because it left your mind entirely aware of it. Every so often another unbidden backwash of erotic memories overwhelms your senses, keeping you helplessly aroused and reminded of who did this to you.\n\n", false);
		
			outputText("You hear a deep, rumbling, snuffling sound from behind you, and the earth shakes as something big approaches you from behind. <i>Please not a minotaur,</i> you think. <i>Anything but a minotaur. Please not a minotaur...</i> Hands roughly grab your sides and a brutally powerful musk fills your nostrils as you groan in despair.\n\n", false);
		
			outputText("The huge bull-man is not one to look a gift fuck in the mouth. Without bothering to take you in, bar a long wet sniff of your " + player.hairDescript() + ", he sticks his cock between your ass cheeks. He grunts as he forces his head past your sphincter, squirting pre-cum into your passage as he does so. Your body is incapable of clenching instinctively against the invasion, but there is no escaping how huge the dong feels as he impatiently forces your ass open.", false);
			player.buttChange(60,true,true,false);
			//(Tight: 
			if (player.analCapacity() < 60) outputText(" The giant cock stretches you out painfully, and everything else blots out as your body attempts to accommodate the beast. As he begins to thrust more of his length up you, he grunts and beads more of his drugged pre-cum, lubricating your anus. This thankfully makes his cock easier to take, but also increases the pace of his thrusting as your hole becomes more receptive to it.", false);
			//V loose/Buttslut: 
			else outputText(" Your well-worn ass is a perfect fit for the giant cock and accepts it eagerly, every bit as welcoming as a moist vagina. As the minotaur rubs against your tender inner walls he grunts and beads more of his drugged pre-cum, turning your hole into a helplessly wet, clenching ass cunt.", false);
			outputText(" You begin to pant from exertion and the overpowering sensation of the fuck as you feel first one ring and then a second push past your sphincter, then out again, then in and out as the minotaur picks up the pace. As rut takes hold of him, he picks you up by your arms and uses his strength to force you up and down his dick, using you as a cocksleeve to sate his animalistic desires. Your ass is slick with his pre-cum by now however, and the drugged slime has bumped you upwards into a hazy high; only the height of his downward thrust when his dick is almost completely buried in your bowels brings you out of it, the painful intensity of it dragging you down of your cloud with a gasp.\n\n", false);
		
			outputText("Eventually the minotaur's balls swell against your " + player.buttDescript() + " and with a long, satisfied moo, it reaches its peak, holding you down so its cum jets forth deep inside you. ", false);
			if (player.gender == 1) outputText("The sensual high it has already instilled in you amplifies by tenfold; the warm, oozing fluid finds its mark and you moan as you spontaneously ejaculate, ropes of your own cum spattering on the ground and your own nerveless " + player.feet() + ".", false);
			else if (player.gender == 2) outputText("The sensual high it has already instilled in you amplifies by tenfold; the warm, oozing fluid finds its mark and you moan as you spontaneously orgasm, your juices spattering your thighs and calves.", false);
			else if (player.gender == 3) outputText("The sensual high it has already instilled in you amplifies by tenfold; the warm, oozing fluid finds its mark and you moan as you spontaneously orgasm, ropes of your own jizz spattering on the ground and girl cum dripping down your thighs.", false);
			else outputText("The sensual high it has already instilled in you amplifies by tenfold as the warm, oozing fluid finds its mark and you moan as you spontaneously orgasm, your anus helplessly milking the creature for all it can get.", false);
			outputText("\n\n", false);	
		
			outputText("The minotaur holds onto you until he has finished spurting his last into you, before abruptly setting you back down on your frozen feet, pulling his slimy, receding member out of your abused anus and with a satisfied snort, takes his leave. You feel his cum drooling out of you and down your " + player.hipDescript() + ", but in your hazy, druggy state the feeling is almost sensual.", false);
			//(Addict: 
			if (flags[kFLAGS.MINOTAUR_CUM_ADDICTION_STATE] > 0 || player.findPerk(PerkLib.MinotaurCumAddict) >= 0) outputText(" You're incredibly frustrated that you can't clench yourself and hold the magical substance deep inside you, so you can savor the wonderful, soft elation it blossoms inside of you for as long as you can.", false);
			outputText("\n\n", false);
		
			outputText("Eventually, after another thirty or so minutes of being forced to stand there and savor the cum trickling down your legs, you find with great relief you can begin to move your fingers again. With some effort you manage to work power into each corner of your body and finally shake free of the basilisk's curse; quickly, you shake the aching out of your knees and redress before anything else finds you and woozily begin to make your way back down the mountain, trying to ignore the feeling of ooze dripping out of you.", false);
			//(lose 100 lust, stretch anus according to minotaur, increment mino addiction)*/
			player.orgasm('Anal');
			player.minoCumAddiction(10);
			player.slimeFeed();
		}
	}
}
