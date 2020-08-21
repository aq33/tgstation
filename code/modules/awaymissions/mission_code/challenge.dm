//Challenge Areas

/area/awaymission/challenge/start
	name = "Where Am I?"
	icon_state = "away"

/area/awaymission/challenge/main
	name = "Danger Room"
	icon_state = "away1"
	requires_power = FALSE

/area/awaymission/challenge/end
	name = "Administration"
	icon_state = "away2"
	requires_power = FALSE


/obj/machinery/power/emitter/energycannon
	name = "Energy Cannon"
	desc = "A heavy duty industrial laser."
	icon = 'icons/obj/singularity.dmi'
	icon_state = "emitter_+a"
	anchored = TRUE
	density = TRUE
	resistance_flags = INDESTRUCTIBLE | FIRE_PROOF | ACID_PROOF

	use_power = NO_POWER_USE
	idle_power_usage = 0
	active_power_usage = 0

	active = TRUE
	locked = TRUE
	state = 2

/obj/machinery/power/emitter/energycannon/RefreshParts()
	return

//challenge fluffs

/obj/item/paper/fluff/awaymissions/challenge/syndicatenote
	name = "Suspicious journal page"
	info = "Hello, reader. Whoever you may be, you must accept a couple of things before moving onward with my journal. I do not even know if someone will find this, but I am writing it only because I know for sure we are not coming back. First, the theories are true, the cult of Nar'sie exists, and so does the clown planet. We were flying through space to help raid the cargo transport, they were talking about some chucklefuck with a regular space suit and mining tools. Right- onto the point, we were on our way, when all of a sudden we heard our higher ups telling us to turn back, we were close enough to see their signal, and well prepared enough to continue towards there. Then we saw it. A massive amalgamation of rubble, dust, flesh and animals, right before us. We tried to turn back, but it turned out that we already were there, and that we travelled through a wormhole. We are about to board the clown ship, we have limited fuel and high hopes for finding somethin- IS THAT A GIANT DISPOSALS PIPE?"

/obj/item/paper/fluff/awaymissions/challenge/clownnote
	name = "Colourful journal page"
	info = "You are looking at a piece of paper covered in glitter and stickers, you can manage to find some text: Hello Jimbo! HONK! Get ready to hear the CUH- RAAAZY story of how we got here! So my clown friends and I were you know, CLOWNING around and travelling in our ship, when we see this BIIIIIIIIIG funny-looking opening in space, we decide to fly through it just for FUN! Some people are having a bad day I see, their ships crashed, HONK! Not as bad as mine, we found funny green rocks in space that allowed us to power our engines, but they turned the crew into FUNNY GUYS and the captain into an alcoholic, I am now hiding in the storage room, probably going to move to engines, these CLOWNS are dummies! I see a party wagon pulling over, hope they are gonna cure my friends, you know, laughter is the best medicine but ballistic weapons also do the job at times! Honk!"

/obj/item/paper/fluff/awaymissions/challenge/stainednote
	name = "Wet journal page"
	info = "This note seems to be covered in some sort of alcoholic substance, you can make out only so much of the odd speech on it This is a distress message. We were going back from a mission, stocked on booze and all. We celebrate, so we drink. Captain slightly go off course, we flying through weak space now, we sure it will ok, but no. We land, amalgamation clow, fused one another, people go crazy from cult presence and become simple-minded. They now defend this forbidden place, made arena. Some strange presence known as pipe god is here, he shift them to help him defend his fortress from gate people. They say they are worse than clown, and they free when help done. We were the ones forced to construct, pipe god give material and instruction. The being behind all of this is possibly similar to cult god, which they speak about without stopping. It is too late for my friends. Save yourself, tell the others when you leave, this place is a trial, not only for you, but it is a trial of sanity for me."

/obj/item/paper/fluff/awaymissions/challenge/bloodynote
	name = "Bloody journal page"
	info = "Glory to Nar'sie. As you might have noticed, there is a lot going around right now. Ships crashing, bluespace anomalies, people are melting together and objects too. I've seen the russians, they have bears covered in armor, not even sure if that melted on. So we were converting an area, you know, in a weak spot in space-time, just like the handbooks for summoning nar-nar told us to, and when we about to call her, we see A MASSIVE FUCKING AMALGAMATION OF PIPES, RUBBLE AND PEOPLE CRASHING INTO US. I thought I died. I went right through. We all want to get out of this forbidden place, these kinds of anomalies happen very rarely, a lot of people must go through during a bluespace wormhole storm or be in a weak spot of the universe in general. I have heard barking nearby, some went insane, they said the one and true god is the pipe god, he was later thrown into one of those pipes, never heard from him again. I think some shit with time got messed up too, like I saw tribal weapons made of human bones. Still thinking about it, might get constructified, I heard they don't have memory."

/obj/item/paper/fluff/awaymissions/challenge/colourfulnote
	name = "Birthday Card"
	info = "This is to my best friend, Jimmy, for being a cool dude and telling the other guys I am not in love with jessica, and because he took me to the movies and is a great guy! Enjoy your present Jimmy!!! Happy Birthday!!! :)"
