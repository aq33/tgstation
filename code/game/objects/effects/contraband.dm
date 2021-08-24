// This is synced up to the poster placing animation.
#define PLACE_SPEED 37

// The poster item

/obj/item/poster
	name = "poorly coded poster"
	desc = "You probably shouldn't be holding this."
	icon = 'icons/obj/contraband.dmi'
	force = 0
	resistance_flags = FLAMMABLE
	var/poster_type
	var/obj/structure/sign/poster/poster_structure

/obj/item/poster/Initialize(mapload, obj/structure/sign/poster/new_poster_structure)
	. = ..()
	poster_structure = new_poster_structure
	if(!new_poster_structure && poster_type)
		poster_structure = new poster_type(src)

	// posters store what name and description they would like their
	// rolled up form to take.
	if(poster_structure)
		name = poster_structure.poster_item_name
		desc = poster_structure.poster_item_desc
		icon_state = poster_structure.poster_item_icon_state

		name = "[name] - [poster_structure.original_name]"

/obj/item/poster/Destroy()
	poster_structure = null
	. = ..()

// These icon_states may be overridden, but are for mapper's convinence
/obj/item/poster/random_contraband
	name = "random contraband poster"
	poster_type = /obj/structure/sign/poster/contraband/random
	icon_state = "rolled_poster"

/obj/item/poster/random_official
	name = "random official poster"
	poster_type = /obj/structure/sign/poster/official/random
	icon_state = "rolled_legit"

// The poster sign/structure

/obj/structure/sign/poster
	name = "poster"
	var/original_name
	desc = "A large piece of space-resistant printed paper."
	icon = 'icons/obj/contraband.dmi'
	anchored = TRUE
	var/ruined = FALSE
	var/random_basetype
	var/never_random = FALSE // used for the 'random' subclasses.

	var/poster_item_name = "hypothetical poster"
	var/poster_item_desc = "This hypothetical poster item should not exist, let's be honest here."
	var/poster_item_icon_state = "rolled_poster"

/obj/structure/sign/poster/Initialize()
	. = ..()
	if(random_basetype)
		randomise(random_basetype)
	if(!ruined)
		original_name = name // can't use initial because of random posters
		name = "poster - [name]"
		desc = "A large piece of space-resistant printed paper. [desc]"

/obj/structure/sign/poster/proc/randomise(base_type)
	var/list/poster_types = subtypesof(base_type)
	var/list/approved_types = list()
	for(var/t in poster_types)
		var/obj/structure/sign/poster/T = t
		if(initial(T.icon_state) && !initial(T.never_random))
			approved_types |= T

	var/obj/structure/sign/poster/selected = pick(approved_types)

	name = initial(selected.name)
	desc = initial(selected.desc)
	icon_state = initial(selected.icon_state)
	poster_item_name = initial(selected.poster_item_name)
	poster_item_desc = initial(selected.poster_item_desc)
	poster_item_icon_state = initial(selected.poster_item_icon_state)
	ruined = initial(selected.ruined)


/obj/structure/sign/poster/attackby(obj/item/I, mob/user, params)
	if(I.tool_behaviour == TOOL_WIRECUTTER)
		I.play_tool_sound(src, 100)
		if(ruined)
			to_chat(user, "<span class='notice'>You remove the remnants of the poster.</span>")
			qdel(src)
		else
			to_chat(user, "<span class='notice'>You carefully remove the poster from the wall.</span>")
			roll_and_drop(user.loc)

/obj/structure/sign/poster/attack_hand(mob/user)
	. = ..()
	if(.)
		return
	if(ruined)
		return
	visible_message("[user] rips [src] in a single, decisive motion!" )
	playsound(src.loc, 'sound/items/poster_ripped.ogg', 100, 1)

	var/obj/structure/sign/poster/ripped/R = new(loc)
	R.pixel_y = pixel_y
	R.pixel_x = pixel_x
	R.add_fingerprint(user)
	qdel(src)

/obj/structure/sign/poster/proc/roll_and_drop(loc)
	pixel_x = 0
	pixel_y = 0
	var/obj/item/poster/P = new(loc, src)
	forceMove(P)
	return P

//separated to reduce code duplication. Moved here for ease of reference and to unclutter r_wall/attackby()
/turf/closed/wall/proc/place_poster(obj/item/poster/P, mob/user)
	if(!P.poster_structure)
		to_chat(user, "<span class='warning'>[P] has no poster... inside it? Inform a coder!</span>")
		return

	// Deny placing posters on currently-diagonal walls, although the wall may change in the future.
	if (smooth & SMOOTH_DIAGONAL)
		for (var/O in overlays)
			var/image/I = O
			if(copytext(I.icon_state, 1, 3) == "d-") //3 == length("d-") + 1
				return

	var/stuff_on_wall = 0
	for(var/obj/O in contents) //Let's see if it already has a poster on it or too much stuff
		if(istype(O, /obj/structure/sign/poster))
			to_chat(user, "<span class='warning'>The wall is far too cluttered to place a poster!</span>")
			return
		stuff_on_wall++
		if(stuff_on_wall == 3)
			to_chat(user, "<span class='warning'>The wall is far too cluttered to place a poster!</span>")
			return

	to_chat(user, "<span class='notice'>You start placing the poster on the wall...</span>"	)

	var/obj/structure/sign/poster/D = P.poster_structure

	var/temp_loc = get_turf(user)
	flick("poster_being_set",D)
	D.forceMove(src)
	qdel(P)	//delete it now to cut down on sanity checks afterwards. Agouri's code supports rerolling it anyway
	playsound(D.loc, 'sound/items/poster_being_created.ogg', 100, 1)

	if(do_after(user, PLACE_SPEED, target=src))
		if(!D || QDELETED(D))
			return

		if(iswallturf(src) && user && user.loc == temp_loc)	//Let's check if everything is still there
			to_chat(user, "<span class='notice'>You place the poster!</span>")
			return

	to_chat(user, "<span class='notice'>The poster falls down!</span>")
	D.roll_and_drop(temp_loc)

// Various possible posters follow

/obj/structure/sign/poster/ripped
	ruined = TRUE
	icon_state = "poster_ripped"
	name = "ripped poster"
	desc = "You can't make out anything from the poster's original print. It's ruined."

/obj/structure/sign/poster/random
	name = "random poster" // could even be ripped
	icon_state = "random_anything"
	never_random = TRUE
	random_basetype = /obj/structure/sign/poster

/obj/structure/sign/poster/contraband
	poster_item_name = "contraband poster"
	poster_item_desc = "This poster comes with its own automatic adhesive mechanism, for easy pinning to any vertical surface. Its vulgar themes have marked it as contraband aboard Nanotrasen space facilities."
	poster_item_icon_state = "rolled_poster"

/obj/structure/sign/poster/contraband/random
	name = "random contraband poster"
	icon_state = "random_contraband"
	never_random = TRUE
	random_basetype = /obj/structure/sign/poster/contraband

/obj/structure/sign/poster/contraband/free_tonto
	name = "Deus Ex Machina"
	desc = "Plakat promujący absurdalny pogląd, że żyjemy w symulacji. Cóż za kretyństwo..."
	icon_state = "poster1"

/obj/structure/sign/poster/contraband/atmosia_independence
	name = "Maciuś"
	desc = "Grafika przedstawiająca niegroźnego grzybka. Urocze!"
	icon_state = "poster2"

/obj/structure/sign/poster/contraband/fun_police
	name = "Fun Police"
	desc = "Plakat wymierzony przeciwko siłom ochrony na stacji."
	icon_state = "poster3"

/obj/structure/sign/poster/contraband/lusty_xenomorph
	name = "Elfy Userotha"
	desc = "Bluźnierczy plakat upamiętniający harem niejakiego Userotha."
	icon_state = "poster4"

/obj/structure/sign/poster/contraband/syndicate_recruitment
	name = "Syndykat Rekrutuje"
	desc = "Zwiedzaj galaktykę! Poznawaj nowych ludzi! Zastrzel ich!"
	icon_state = "poster5"

/obj/structure/sign/poster/contraband/clown
	name = "Klaun"
	desc = "Honk."
	icon_state = "poster6"

/obj/structure/sign/poster/contraband/smoke
	name = "Karm raka!"
	desc = "Plakat promujące niezdrowe metody radzenia sobie z kosmicznym stresem."
	icon_state = "poster7"

/obj/structure/sign/poster/contraband/grey_tide
	name = "Szara Fala"
	desc = "Buntowniczy plakat symbolizujący jedność asystentów."
	icon_state = "poster8"

/obj/structure/sign/poster/contraband/missing_gloves
	name = "Zaginęły: Rękawice"
	desc = "Plakat odnoszący się do cięć budżetowych korporacji prowadzących do ograniczenia dostępności rękawic izolujących."
	icon_state = "poster9"

/obj/structure/sign/poster/contraband/hacking_guide
	name = "Poradnik hakowania"
	desc = "Plakat opisujący zasadę działania oraz metody hakowania standardowej śluzy NanoTrasenu. Wygląda na to, że jest nieaktualny."
	icon_state = "poster10"

/obj/structure/sign/poster/contraband/rip_badger
	name = "Płak"
	desc = "Ten kotek jest taki smutny!"
	icon_state = "poster11"

/obj/structure/sign/poster/contraband/ambrosia_vulgaris
	name = "Ambrosia Vulgaris"
	desc = "Wow, ten plakat jest totalnie tubularny ziom."
	icon_state = "poster12"

/obj/structure/sign/poster/contraband/donut_corp
	name = "Papaj Corp."
	desc = "Plakat reklamujący wadowicki specjał znany w całej galaktyce."
	icon_state = "poster13"

/obj/structure/sign/poster/contraband/eat
	name = "ŻRYJ."
	desc = "JEDZ, TAK, NIE PRZESTAWAJ."
	icon_state = "poster14"

/obj/structure/sign/poster/contraband/tools
	name = "Narzędzia"
	desc = "Plakat reklamujący narzędzia. Faktycznie dobrze je mieć."
	icon_state = "poster15"

/obj/structure/sign/poster/contraband/power
	name = "Moc"
	desc = "Plakat przedstawiający osobliwość grawitacyjną. Wydgląda na to, że jest w niej klaun."
	icon_state = "poster16"

/obj/structure/sign/poster/contraband/space_cube
	name = "Kosmokostka"
	desc = "Bóg jest sześcianem i stworzył wszechświat na swój obraz i podobieństwo."
	icon_state = "poster17"

/obj/structure/sign/poster/contraband/communist_state
	name = "Góra lodowa"
	desc = "Grafika góry lodowej. Wygląda na to, że ma to być alegoria do jakichś 'głębokich' sekretów."
	icon_state = "poster18"

/obj/structure/sign/poster/contraband/lamarr
	name = "Lamarr"
	desc = "Plakat przedstawiający 'zwierzątko' Dyrektora Naukowego."
	icon_state = "poster19"

/obj/structure/sign/poster/contraband/borg_fancy_1
	name = "Borg Fancy"
	desc = "Being fancy can be for any borg, just need a suit."
	icon_state = "poster20"

/obj/structure/sign/poster/contraband/borg_fancy_2
	name = "Borg Fancy v2"
	desc = "Borg Fancy, Now only taking the most fancy."
	icon_state = "poster21"

/obj/structure/sign/poster/contraband/kss13
	name = "Papaj nie żyje"
	desc = "Przykre przypomnienie jednego z najczarniejszych momentów historii."
	icon_state = "poster22"

/obj/structure/sign/poster/contraband/rebels_unite
	name = "CCCP"
	desc = "Plakat przedstawiający najgorszy koszmar każdego kosmopolaka."
	icon_state = "poster23"

/obj/structure/sign/poster/contraband/c20r
	// have fun seeing this poster in "spawn 'c20r'", admins...
	name = "C-20r"
	desc = "Plakat promujący karabinek Scarborough Arms C-20r."
	icon_state = "poster24"

/obj/structure/sign/poster/contraband/have_a_puff
	name = "Jaraj blanta"
	desc = "Ziom, słuchaj, jestem, jakby... Słuchasz mnie?"
	icon_state = "poster25"

/obj/structure/sign/poster/contraband/revolver
	name = "Rewolwer"
	desc = "Wyrewolwerowany rewolwerowiec wyrewolwerował wyrewolwerowanego rewolwerowca."
	icon_state = "poster26"

/obj/structure/sign/poster/contraband/d_day_promo
	name = "D-Day Promo"
	desc = "Plakat promocyjny jakiegoś rapera."
	icon_state = "poster27"

/obj/structure/sign/poster/contraband/syndicate_pistol
	name = "Stenchkin"
	desc = "Plakat określający pistolet syndykatu jako 'broń z klasą'."
	icon_state = "poster28"

/obj/structure/sign/poster/contraband/energy_swords
	name = "E-Miecze"
	desc = "Wszystkie kolory brutalnego morderstwa."
	icon_state = "poster29"

/obj/structure/sign/poster/contraband/red_rum
	name = "PRAWuH"
	desc = "Plakat piętnujący problem alkoholizmu wśród sił ochrony."
	icon_state = "poster30"

/obj/structure/sign/poster/contraband/cc64k_ad
	name = "CC 64K Ad"
	desc = "Najnowszy komputer przenośny od Comrade Computing, z aż 64kB ramu!"
	icon_state = "poster31"

/obj/structure/sign/poster/contraband/punch_shit
	name = "Napierdalaj"
	desc = "Wszczynaj bójki bez powodu, jak prawdziwy polak patriota!"
	icon_state = "poster32"

/obj/structure/sign/poster/contraband/the_griffin
	name = "Człowiek-Gryf"
	desc = "Człowiek-Gryf rozkazuje Ci być najgorszym ścierwem. Zgodzisz się?"
	icon_state = "poster33"

/obj/structure/sign/poster/contraband/lizard
	name = "Bry"
	desc = "Ten sprośny plakat przedstawia jaszczura gotowego do ucieczki."
	icon_state = "poster34"

/obj/structure/sign/poster/contraband/free_drone
	name = "Syndron"
	desc = "Plakat przestrzegający przed dronami syndykatu kanibalizującymi inne drony."
	icon_state = "poster35"

/obj/structure/sign/poster/contraband/busty_backdoor_xeno_babes_6
	name = "Cycate Xenomorfy Z Sąsiedztwa 6"
	desc = "Same naturalne Xeno-Mamuśki!"
	icon_state = "poster36"

/obj/structure/sign/poster/contraband/robust_softdrinks
	name = "Robustne Napitki"
	desc = "Robustne Napitki: Bardziej robustne niż skrzynka narzędziowa w łeb!"
	icon_state = "poster37"

/obj/structure/sign/poster/contraband/shamblers_juice
	name = "OOC3"
	desc = "Plakat przedstawiający logo sekty znanej jako 'OOC3'."
	icon_state = "poster38"

/obj/structure/sign/poster/contraband/pwr_game
	name = "Pwr Game"
	desc = "MOC której pragną prawdziwi GRACZE! Program partnerski z Sałatką Vlada."
	icon_state = "poster39"

/obj/structure/sign/poster/contraband/sun_kist
	name = "Sun-kist"
	desc = "Napij się gwiazd!"
	icon_state = "poster40"

/obj/structure/sign/poster/contraband/space_cola
	name = "Kosmo-Cola"
	desc = "Zwyczajna Cola... W KOSMOSIE!"
	icon_state = "poster41"

/obj/structure/sign/poster/contraband/space_up
	name = "Space-Up!"
	desc = "Wyssany w próżnię intensywnością SMAKU!"
	icon_state = "poster42"

/obj/structure/sign/poster/contraband/kudzu
	name = "Kudzu"
	desc = "Plakat filmu o kosmicznych pnączach? Co za bzdura."
	icon_state = "poster43"

/obj/structure/sign/poster/contraband/masked_men
	name = "Dynamic"
	desc = "Plakat podpisany 'Dynamic' przedstawiający mężczyznę trzymającego w robotycznej dłoni papierosa, z wytatuowaną uśmiechniętą buźką na boku czaszki."
	icon_state = "poster44"

//annoyingly, poster45 is in another file.

/obj/structure/sign/poster/contraband/free_key
	name = "Darmowy klucz kodujący syndykatu"
	desc = "Plakat o agentach syndykatu, którym nigdy dość."
	icon_state = "poster46"

/obj/structure/sign/poster/contraband/bountyhunters
	name = "Łowcy Nagród"
	desc = "Plakat promujący usługi łowców nagród."
	icon_state = "poster47"

/obj/structure/sign/poster/contraband/omnissiah
	name = "Omnisjasz"
	desc = "Plakat promujący tostery firmy 'Omnisjasz'."
	icon_state = "poster50"

/obj/structure/sign/poster/official
	poster_item_name = "motivational poster"
	poster_item_desc = "An official Nanotrasen-issued poster to foster a compliant and obedient workforce. It comes with state-of-the-art adhesive backing, for easy pinning to any vertical surface."
	poster_item_icon_state = "rolled_legit"

/obj/structure/sign/poster/official/random
	name = "random official poster"
	random_basetype = /obj/structure/sign/poster/official
	icon_state = "random_official"
	never_random = TRUE

/obj/structure/sign/poster/official/here_for_your_safety
	name = "Oddaj głos!"
	desc = "Zdecyduj zanim zdecydują za Ciebie!"
	icon_state = "poster1_legit"

/obj/structure/sign/poster/official/nanotrasen_logo
	name = "\improper Logo NanoTrasenu"
	desc = "Plakat przedstawiający logo NanoTrasenu."
	icon_state = "poster2_legit"

/obj/structure/sign/poster/official/cleanliness
	name = "Pij mleko"
	desc = "Będziesz wielki."
	icon_state = "poster3_legit"

/obj/structure/sign/poster/official/help_others
	name = "500+"
	desc = "Plakat odwołujący się do programu premii dla pracowników wdrażających nowozatrudnionych do pracy."
	icon_state = "poster4_legit"

/obj/structure/sign/poster/official/build
	name = "BUDOWA"
	desc = "Plakat pochwalny dla zespołu inżynieryjnego."
	icon_state = "poster5_legit"

/obj/structure/sign/poster/official/bless_this_spess
	name = "Drontopia"
	desc = "Plakat promujący użycie dronów naprawczych."
	icon_state = "poster6_legit"

/obj/structure/sign/poster/official/science
	name = "WIARA"
	desc = "Nadzieja i naiwność."
	icon_state = "poster7_legit"

/obj/structure/sign/poster/official/ian
	name = "Ian"
	desc = "Woof."
	icon_state = "poster8_legit"

/obj/structure/sign/poster/official/obey
	name = "ZOMO!"
	desc = "Plakat subtelnie zachęcający do nieprzeszkadzania służbom ochrony w wykonywaniu ich obowiązków."
	icon_state = "poster9_legit"

/obj/structure/sign/poster/official/walk
	name = "Idź"
	desc = "Plakat zachęcający do chodzenia zamiast biegania."
	icon_state = "poster10_legit"

/obj/structure/sign/poster/official/state_laws
	name = "State Laws"
	desc = "A poster instructing cyborgs to state their laws."
	icon_state = "poster11_legit"

/obj/structure/sign/poster/official/love_ian
	name = "Tul"
	desc = "Ian jest przyjacielem, nie jedzeniem."
	icon_state = "poster12_legit"

/obj/structure/sign/poster/official/space_cops
	name = "Kosmo-pały"
	desc = "Plakat promujący kosmotelewizyjny serial pod tytułem 'Kosmo-Pały'."
	icon_state = "poster13_legit"

/obj/structure/sign/poster/official/ue_no
	name = "Ue No."
	desc = "Głupie chińskie kosmobajki."
	icon_state = "poster14_legit"

/obj/structure/sign/poster/official/get_your_legs
	name = "Miej DUPĘ"
	desc = "DUPA: Duma, Ułożenie, Patriotyzm oraz Autorytet."
	icon_state = "poster15_legit"

/obj/structure/sign/poster/official/do_not_question
	name = "Pijesz mleko?"
	desc = "Powinieneś. Robi dobrze na kości."
	icon_state = "poster16_legit"

/obj/structure/sign/poster/official/work_for_a_future
	name = "Płać lub płacz!"
	desc = "Drobnym druczkiem dopisana jest informacja o tym, że łzy nie są akceptowalną walutą."
	icon_state = "poster17_legit"

/obj/structure/sign/poster/official/soft_cap_pop_art
	name = "Chick Good Inc."
	desc = "Don't stop, get it, get it; Be proud your captains in it; Steady, watch me navigate; Ha HA ha HA"
	icon_state = "poster18_legit"

/obj/structure/sign/poster/official/safety_internals
	name = "Tlen: życie"
	desc = "Plakat instruktażowy dotyczący użycia masek w rzadkich przypadkach, gdy atmosfera na stacji jest niezdatna do życia."
	icon_state = "poster19_legit"

/obj/structure/sign/poster/official/safety_eye_protection
	name = "Chroń oczy!"
	desc = "Plakat przypominający o środkach ochrony oczu."
	icon_state = "poster20_legit"

/obj/structure/sign/poster/official/safety_report
	name = "Melduj"
	desc = "Donos jest najwyższą formą odpowiedzialności obywatelskiej."
	icon_state = "poster21_legit"

/obj/structure/sign/poster/official/report_crimes
	name = "Dzwoń pod 997"
	desc = "Przedawniony plakat zachęcający do informowania ochrony o wszelkich nieprawidłowościach."
	icon_state = "poster22_legit"

/obj/structure/sign/poster/official/ion_rifle
	name = "Działko jonowe"
	desc = "Plakat przedstawiający działko jonowe."
	icon_state = "poster23_legit"

/obj/structure/sign/poster/official/foam_force_ad
	name = "Reklama PiankoBroni"
	desc = "PiankoBroń! Piankuj albo zostań zpiankowany!!"
	icon_state = "poster24_legit"

/obj/structure/sign/poster/official/cohiba_robusto_ad
	name = "Reklama Cohiba Robusto"
	desc = "Cohiba Robusto - klasyczne cygaro dla klasycznych ludzi."
	icon_state = "poster25_legit"

/obj/structure/sign/poster/official/anniversary_vintage_reprint
	name = "NAUKA!"
	desc = "Plakat pochwalny dla zespołu naukowego."
	icon_state = "poster26_legit"

/obj/structure/sign/poster/official/fruit_bowl
	name = "Martwa Natura"
	desc = "Daje do myślenia."
	icon_state = "poster27_legit"

/obj/structure/sign/poster/official/pda_ad
	name = "Reklama PDA"
	desc = "Plakat reklamujący najnowsze PDA NanoTrasenu."
	icon_state = "poster28_legit"

/obj/structure/sign/poster/official/enlist
	name = "Chroń i służ." // but I thought deathsquad was never acknowledged
	desc = "Plakat przedstawiający elitarnego komandosa NanoTrasenu."
	icon_state = "poster29_legit"

/obj/structure/sign/poster/official/nanomichi_ad
	name = "Reklama Nanomichi"
	desc = " Reklama promująca kasety firmy Nanomichi."
	icon_state = "poster30_legit"

/obj/structure/sign/poster/official/twelve_gauge
	name = "Kaliber 12"
	desc = "Plakat promujący amunicję do strzelb."
	icon_state = "poster31_legit"

/obj/structure/sign/poster/official/high_class_martini
	name = "Martini"
	desc = "Wstrząśnięte, nie zmieszane."
	icon_state = "poster32_legit"

/obj/structure/sign/poster/official/the_owl
	name = "Człowiek-Sowa"
	desc = "Człowiek-Sowa zrobiłby wszystko co w jego mocy dla dobra stacji. A Ty?"
	icon_state = "poster33_legit"

/obj/structure/sign/poster/official/no_erp
	name = "Daj Seks Mi"
	desc = "Plakat drwiący z tych, którzy nie mogą powstrzymać się ciągotom ciała na stacji kosmicznej."
	icon_state = "poster34_legit"

/obj/structure/sign/poster/official/wtf_is_co2
	name = "OOC3 nie istnieje"
	desc = "Plakat mający rozwiać wątpliwości załogi na temat 'OOC3'."
	icon_state = "poster35_legit"

/obj/structure/sign/poster/official/PRAWO
	name = "PRAWO"
	desc = "Plakat przypominający załodze oraz służbom ochrony o ważności Kosmicznego Prawa."
	icon_state = "poster45_legit"

/obj/structure/sign/poster/official/HoPline
	name = "Hopline Miami"
	desc = "Plakat zachęcający asystentów do zgłoszenia się do Głowy Personelu o pracę."
	icon_state = "poster46_legit"

/obj/structure/sign/poster/official/Kredki
	name = "Kredki"
	desc = "Plakat promujące kolorowe kredki znajdujące się na stacjach NanoTrasenu dla zwiększenia morale. Nie zawierają toksycznych substancji!"
	icon_state = "poster47_legit"

/obj/structure/sign/poster/official/PRACA
	name = "PRACA PRACA"
	desc = "Coś trzeba zrobić?"
	icon_state = "poster48_legit"

/obj/structure/sign/poster/official/moth1
	name = "Safety Moth - Poisoning"
	desc = "This informational poster uses Safety Moth(TM) to tell the viewer not to poison the station donuts. It's signed by 'AspEv'."
	icon_state = "poster36_legit"

/obj/structure/sign/poster/official/moth2
	name = "Safety Moth - BoH"
	desc = "This informational poster uses Safety Moth(TM) to inform the viewer of the dangers of Bags of Holding. It's signed by 'AspEv'."
	icon_state = "poster37_legit"

/obj/structure/sign/poster/official/moth3
	name = "Safety Moth - Hardhats"
	desc = "This informational poster uses Safety Moth(TM) to tell the viewer to wear hardhats in cautious areas. It's like a lamp for your head! It's signed by 'AspEv'."
	icon_state = "poster38_legit"

/obj/structure/sign/poster/official/moth4
	name = "Safety Moth - Smokey?"
	desc = "This informational poster uses Safety Moth(TM) to promote safe handling of plasma, or promoting crew to combat plasmafires. We can't tell. It's signed by 'AspEv'."
	icon_state = "poster39_legit"

/obj/structure/sign/poster/official/moth5
	name = "Safety Moth - Piping"
	desc = "This informational poster uses Safety Moth(TM) to tell atmospheric technicians correct types of piping to be used. Proper pipe placement prevents poor preformance! It's signed by 'AspEv'."
	icon_state = "poster40_legit"

/obj/structure/sign/poster/official/moth6
	name = "Safety Moth - Supermatter"
	desc = "This informational poster uses Safety Moth(TM) to promote proper safety equipment when working near a Supermatter Crystal. It's signed by 'AspEv'."
	icon_state = "poster41_legit"

/obj/structure/sign/poster/official/moth7
	name = "Safety Moth - Methamphetamine"
	desc = "This informational poster uses Safety Moth(TM) to tell the viewer to seek CMO approval before cooking methamphetamine. You shouldn't even be making this. It's signed by 'AspEv'."
	icon_state = "poster42_legit"

/obj/structure/sign/poster/contraband/pill1
	name = "Safety Pill - Methamphetamine"
	desc = "A decommisioned poster that uses Safety Pill(TM?) to promote less-than-legal chemicals. This is one of the reasons we stopped outsourcing these posters. It's signed by 'AspEv'."
	icon_state = "poster48"

/obj/structure/sign/poster/official/moth8
	name = "Safety Moth - Epinephrine"
	desc = "This informational poster uses Safety Moth(TM) to inform the viewer to help injured/deceased crewmen with their epinephrine injectors. It's signed by 'AspEv'."
	icon_state = "poster43_legit"

/obj/structure/sign/poster/official/moth9
	name = "Safety Moth - Delamination Safety Precautions"
	desc = "This informational poster uses Safety Moth(TM) to tell the viewer to hide in lockers when the Supermatter Crystal has delaminated. Running away might be a better strategy. It's signed by 'AspEv'."
	icon_state = "poster44_legit"

/obj/structure/sign/poster/contraband/syndiemoth
	name = "Syndie Moth - Nuclear Operation"
	desc = "A Syndicate-commissioned poster that uses Syndie Moth(TM?) to tell the viewer to keep the nuclear authentication disk unsecured. No, we aren't doing that. It's signed by 'AspEv'."
	icon_state = "poster49"

#undef PLACE_SPEED
