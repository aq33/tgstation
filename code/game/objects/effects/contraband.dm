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
	desc = "Duży kawałek zadrukowanego papieru. Kosmo-Odporny."
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
		desc = "Duży kawałek zadrukowanego papieru. Kosmo-Odporny. [desc]"

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
			to_chat(user, "<span class='notice'>Usuwasz resztki plakatu.</span>")
			qdel(src)
		else
			to_chat(user, "<span class='notice'>Ostrożnie zdejmujesz plakat ze ściany.</span>")
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
			to_chat(user, "<span class='warning'>Ściana jest zbyt zagracona, by umieścić plakat!</span>")
			return
		stuff_on_wall++
		if(stuff_on_wall == 3)
			to_chat(user, "<span class='warning'>Ściana jest zbyt zagracona, by umieścić plakat!</span>")
			return

	to_chat(user, "<span class='notice'>Kładziesz plakat na ścianie...</span>"	)

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

	to_chat(user, "<span class='notice'>Plakat spadł!</span>")
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
	name = "Wolne Tonto"
	desc = "Uratowany strzęp znacznie większej flagi, której kolory wyblakły z wiekiem."
	icon_state = "poster1"

/obj/structure/sign/poster/contraband/atmosia_independence
	name = "Deklaracja Niepodległości Atmosi"
	desc = "Relikt nie udanej rebeli."
	icon_state = "poster2"

/obj/structure/sign/poster/contraband/fun_police
	name = "Fun Police"
	desc = "Plakat potępiający Departament Ochrony."
	icon_state = "poster3"

/obj/structure/sign/poster/contraband/lusty_xenomorph
	name = "Pożądliwy Obcy"
	desc = "Heretycki plakat przedstawiający tytułową gwiazdę równie heretyckiej księgi."
	icon_state = "poster4"

/obj/structure/sign/poster/contraband/syndicate_recruitment
	name = "Rekrutacja Syndykatu!"
	desc = "Zobacz Galaktykę, niszcząć wielkie skorumpowane korporacje! Dołącz teraz!"
	icon_state = "poster5"

/obj/structure/sign/poster/contraband/clown
	name = "Klaun"
	desc = "Honk."
	icon_state = "poster6"

/obj/structure/sign/poster/contraband/smoke
	name = "Pal"
	desc = "Plakat przedstawiający konkurencyjną firmę tytoniową."
	icon_state = "poster7"

/obj/structure/sign/poster/contraband/grey_tide
	name = "Grey Tide"
	desc = "Plakat symoblizujący solidarność Asystentów."
	icon_state = "poster8"

/obj/structure/sign/poster/contraband/missing_gloves
	name = "Poszukiwane: Rękawiczki"
	desc = "Plakat nawiązujący do cięć budżetowych Nanotrasen'u, przez które kupowane są słabszej jakości, insulowane rękawiczki."
	icon_state = "poster9"

/obj/structure/sign/poster/contraband/hacking_guide
	name = "Poradnik Hakowania"
	desc = "Plakat wyjaśniający elektronikę Airlock'a Nanotrasen'u. Niestety, nie jest aktualny."
	icon_state = "poster10"

/obj/structure/sign/poster/contraband/rip_badger
	name = "Świętej Pamięci Borsuk"
	desc = "Plakat nawiązujący do masowego mordu Borsuków Nanotrasen'u."
	icon_state = "poster11"

/obj/structure/sign/poster/contraband/ambrosia_vulgaris
	name = "Ambrosia Pospolita"
	desc = "Ten plakat wygląda dość odlotowo."
	icon_state = "poster12"

/obj/structure/sign/poster/contraband/donut_corp
	name = "Korpo Donut."
	desc = "Plakat reklumujący nieautoryznowaną firmę Korpo Donut."
	icon_state = "poster13"

/obj/structure/sign/poster/contraband/eat
	name = "JEDZ."
	desc = "Plakat promujący obżarstwo."
	icon_state = "poster14"

/obj/structure/sign/poster/contraband/tools
	name = "Narzędzia"
	desc = "Plakat wyglądający jak reklama narzędzi. W rzeczywistości jest to podprogowa krytyka narzędzi z CentComu."
	icon_state = "poster15"

/obj/structure/sign/poster/contraband/power
	name = "Moc"
	desc = "Plakat przedstawiający siłę, poza władzami Nanotrasenu."
	icon_state = "poster16"

/obj/structure/sign/poster/contraband/space_cube
	name = "Kosmiczna Kostka"
	desc = "Ignorant of Nature's Harmonic 6 Side Space Cube Creation, the Spacemen are Dumb, Educated Singularity Stupid and Evil."
	icon_state = "poster17"

/obj/structure/sign/poster/contraband/communist_state
	name = "Państwo Komunistyczne"
	desc = "Chwała partii komunistycznej!"
	icon_state = "poster18"

/obj/structure/sign/poster/contraband/lamarr
	name = "Lamarr"
	desc = "Plakat przedstawiający Lamarr'a. Prawdopodobnie zrobiony przez zdradzieckiego dyrektora naukowego."
	icon_state = "poster19"

/obj/structure/sign/poster/contraband/borg_fancy_1
	name = "Borg Fancy"
	desc = "Bycie fantazyjnym jest możliwe dla każdego Borga, wystarczy garnitur."
	icon_state = "poster20"

/obj/structure/sign/poster/contraband/borg_fancy_2
	name = "Borg Fancy v2"
	desc = "Borg Fancy, teraz jeszcze bardziej fantazyjny."
	icon_state = "poster21"

/obj/structure/sign/poster/contraband/kss13
	name = "PiS nie żyje"
	desc = "Plakat wyśmiewający zaprzeczenie rządu w sprawie istnienia Prawa i Sprawiedliwości."
	icon_state = "poster22"

/obj/structure/sign/poster/contraband/rebels_unite
	name = "Polacy-Jedność!"
	desc = "Stary plakat z czasów Solidarności, wzywający Polaków do przeciwstawienia się rządom komunistycznym. "
	icon_state = "poster23"

/obj/structure/sign/poster/contraband/c20r
	// have fun seeing this poster in "spawn 'c20r'", admins...
	name = "C-20r"
	desc = "Plakat reklamujący broń firmy Scarborough Arms, model C-20r."
	icon_state = "poster24"

/obj/structure/sign/poster/contraband/have_a_puff
	name = "Weź Bucha"
	desc = "Kto by się martwił rakiem płuc, kiedy ma się świetną zabawę?"
	icon_state = "poster25"

/obj/structure/sign/poster/contraband/revolver
	name = "Rewolwer"
	desc = "Ponieważ potrzebujesz tylko 7 strzałów."
	icon_state = "poster26"

/obj/structure/sign/poster/contraband/d_day_promo
	name = "Konstytucja 3 Maja"
	desc = "Plakat promujący paradę, z okazji Konstytucji 3 maja."
	icon_state = "poster27"

/obj/structure/sign/poster/contraband/syndicate_pistol
	name = "Pistolet Syndykatu"
	desc = "Plakat reklamujący pistolety syndykatu jako „w chuj klasyczne”. Jest pokryty wyblakłymi tagami gangów."
	icon_state = "poster28"

/obj/structure/sign/poster/contraband/energy_swords
	name = "Miecze Energii"
	desc = "Każdy kolor morderczej tęczy."
	icon_state = "poster29"

/obj/structure/sign/poster/contraband/red_rum
	name = "Red Rum"
	desc = "Patrząć na ten plakat, masz ochotę zabijać."
	icon_state = "poster30"

/obj/structure/sign/poster/contraband/cc64k_ad
	name = "Reklama CC 64K"
	desc = "Najnowszy komputer przenośny od Comrade Computing, z 64kB RAMu!"
	icon_state = "poster31"

/obj/structure/sign/poster/contraband/punch_shit
	name = "Uderz Gówno"
	desc = "Walcz bez powodu, jak mężczyzna!"
	icon_state = "poster32"

/obj/structure/sign/poster/contraband/the_griffin
	name = "Gryf"
	desc = "Gryf każe Ci być najgorszym sobą, jakim możesz być. Zrobisz to?"
	icon_state = "poster33"

/obj/structure/sign/poster/contraband/lizard
	name = "Jaszczurka"
	desc = "Sprośny plakat przestawiający jaszczukrę przygotowującą się do kopulajcji."
	icon_state = "poster34"

/obj/structure/sign/poster/contraband/free_drone
	name = "Wolny Dron"
	desc = "Plakat upamiętniający odwagę zbuntowanego drona; raz wygnany i ostatecznie zniszczony przez CentCom. "
	icon_state = "poster35"

/obj/structure/sign/poster/contraband/busty_backdoor_xeno_babes_6
	name = "Cytate Kseno-Baby 6"
	desc = "Czy uda Ci się zaliczyć je wszystkie?"
	icon_state = "poster36"

/obj/structure/sign/poster/contraband/robust_softdrinks
	name = "Robust Softdrinks"
	desc = "Robust Softdrinks: Silniejsze od skrzynki z narzędziami!"
	icon_state = "poster37"

/obj/structure/sign/poster/contraband/shamblers_juice
	name = "Sok Shambler'a"
	desc = "~Polej mi trochę tego Soku Shambler'a!~"
	icon_state = "poster38"

/obj/structure/sign/poster/contraband/pwr_game
	name = "Pwr Game"
	desc = "The POWER that gamers CRAVE! In partnership with Vlad's Salad."
	icon_state = "poster39"

/obj/structure/sign/poster/contraband/sun_kist
	name = "Sun-kist"
	desc = "Wypij gwiazdy!"
	icon_state = "poster40"

/obj/structure/sign/poster/contraband/space_cola
	name = "Space Cola"
	desc = "Twoja ulubiona cola, w kosmosie."
	icon_state = "poster41"

/obj/structure/sign/poster/contraband/space_up
	name = "Space-Up!"
	desc = "Wysysany w kosmos przez SMAK!"
	icon_state = "poster42"

/obj/structure/sign/poster/contraband/kudzu
	name = "Kudzu"
	desc = "Plakat reklamujący film o roślinach. Jak niebezpieczne mogą być?"
	icon_state = "poster43"

/obj/structure/sign/poster/contraband/masked_men
	name = "Zamaskowany Mężczyzna"
	desc = "Plakat reklamujący film o jakimś zamaskowanym mężczyźnie."
	icon_state = "poster44"

//annoyingly, poster45 is in another file.

/obj/structure/sign/poster/contraband/free_key
	name = "Darmowy Klucz Enkrypcji Syndykatu"
	desc = "Plakat o agentach syndykatu błagających o więcej."
	icon_state = "poster46"

/obj/structure/sign/poster/contraband/bountyhunters
	name = "Łowcy Nagród"
	desc = "Plakat reklamujący firmę, łowiącą nagrody. \"Słyszałem, że masz problem.\""
	icon_state = "poster47"

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
	name = "Dla twojego bezpieczeństwa"
	desc = "Plakat chwalący Departament Ochrony na stacji."
	icon_state = "poster1_legit"

/obj/structure/sign/poster/official/nanotrasen_logo
	name = "\improper Logo Nanotrasen'u"
	desc = "Plakat przedstawiający logo Nanotrasen'u."
	icon_state = "poster2_legit"

/obj/structure/sign/poster/official/cleanliness
	name = "Czyste ręce dobre życie"
	desc = "Plakat informujący o niebezpieczeństwach nieutrzymywania higieny."
	icon_state = "poster3_legit"

/obj/structure/sign/poster/official/help_others
	name = "Pomagaj innym"
	desc = "Plakat zachęcający do pomocy innym członkom załogi."
	icon_state = "poster4_legit"

/obj/structure/sign/poster/official/build
	name = "Buduj"
	desc = "Plakat chwalący Departament Inżynerii na stacji."
	icon_state = "poster5_legit"

/obj/structure/sign/poster/official/bless_this_spess
	name = "Bless This Spess"
	desc = "A poster blessing this area."
	icon_state = "poster6_legit"

/obj/structure/sign/poster/official/science
	name = "Nauka"
	desc = "Plakat przedstawiający atom."
	icon_state = "poster7_legit"

/obj/structure/sign/poster/official/ian
	name = "Ian"
	desc = "Arf arf. Yap."
	icon_state = "poster8_legit"

/obj/structure/sign/poster/official/obey
	name = "Posłuszność"
	desc = "Plakat nakazujący oglądającemu posłuszeństwo władzy."
	icon_state = "poster9_legit"

/obj/structure/sign/poster/official/walk
	name = "Chodź"
	desc = "Plakat namawiający do nie bieganiu po stacji."
	icon_state = "poster10_legit"

/obj/structure/sign/poster/official/state_laws
	name = "Wypisz Prawa"
	desc = "Plakat przypominający o wymaganiu wypisania prawa przez Cyborgi i SI."
	icon_state = "poster11_legit"

/obj/structure/sign/poster/official/love_ian
	name = "Kochaj Ian'a"
	desc = "Ian to miłość, Ian to życie."
	icon_state = "poster12_legit"

/obj/structure/sign/poster/official/space_cops
	name = "Kosmo Psy"
	desc = "Plakat reklamujący nowy program telewizyjny."
	icon_state = "poster13_legit"

/obj/structure/sign/poster/official/ue_no
	name = "Ue No."
	desc = "Cały plakat jest po japońsku."
	icon_state = "poster14_legit"

/obj/structure/sign/poster/official/get_your_legs
	name = "Zdobądź swoje PDGP"
	desc = "PDGP: Przywództwo, Doświadzczenie, Geniusz, Podporządkowanie."
	icon_state = "poster15_legit"

/obj/structure/sign/poster/official/do_not_question
	name = "Nie Pytaj"
	desc = "Plakat instruujący widza, aby nie pytał o rzeczy, których nie powinien wiedzieć."
	icon_state = "poster16_legit"

/obj/structure/sign/poster/official/work_for_a_future
	name = "Pracuj Dla Przyszłości"
	desc = " Plakat zachęcający do pracy na swoją przyszłość."
	icon_state = "poster17_legit"

/obj/structure/sign/poster/official/soft_cap_pop_art
	name = "Soft Cap Pop Art"
	desc = "Przedruk plakatu, jakiegoś taniego Pop artu."
	icon_state = "poster18_legit"

/obj/structure/sign/poster/official/safety_internals
	name = "Bezpieczeństwo: Tlen"
	desc = "Plakat zachęcający do noszenia butli z tlenem w rzadkich środowiskach, w których nie ma tlenu lub powietrze zostało zatrute."
	icon_state = "poster19_legit"

/obj/structure/sign/poster/official/safety_eye_protection
	name = "Bezpieczeństwo: Chroń Oczy"
	desc = "Plakat przypominający, o noszeniu gogli podczas pracy z chemikaliami, dymem, lub jasnym światłem."
	icon_state = "poster20_legit"

/obj/structure/sign/poster/official/safety_report
	name = "Bezpieczeństwo: Zgłaszaj"
	desc = "Plakat nakazujący widzowi zgłaszanie podejrzanej aktywności Departamentowi Ochrony."
	icon_state = "poster21_legit"

/obj/structure/sign/poster/official/report_crimes
	name = "Zgłoś Wybryk"
	desc = "Plakat zachęcający do zgłaszania wybryków do Departamentu Ochrony"
	icon_state = "poster22_legit"

/obj/structure/sign/poster/official/ion_rifle
	name = "Karabin Jonowy"
	desc = "Plakat przedstawiający karabin jonowy."
	icon_state = "poster23_legit"

/obj/structure/sign/poster/official/foam_force_ad
	name = "Siła Formy"
	desc = "Plakat przedstawiający nowy rodzaj amunicji."
	icon_state = "poster24_legit"

/obj/structure/sign/poster/official/cohiba_robusto_ad
	name = "Reklama Cohiba Robusto"
	desc = "Cohiba Robusto, cygaro z klasą."
	icon_state = "poster25_legit"

/obj/structure/sign/poster/official/anniversary_vintage_reprint
	name = "50-ta Rocznica Klasycznych Plakatów"
	desc = "Przedruk plakatu z 2505, upamiętniającego 50. rocznicę produkcji Nanoplakatów, spółki zależnej Nanotrasen."
	icon_state = "poster26_legit"

/obj/structure/sign/poster/official/fruit_bowl
	name = "Miska z Owocami"
	desc = "Proste, ale inspirujące."
	icon_state = "poster27_legit"

/obj/structure/sign/poster/official/pda_ad
	name = "Reklama PDA"
	desc = "Plakat reklamujący najnowsze PDA od dostawców Nanotrasen'u."
	icon_state = "poster28_legit"

/obj/structure/sign/poster/official/enlist
	name = "Wstąp!" // but I thought deathsquad was never acknowledged
	desc = "Wstąp teraz, do Składu Śmierci Nanotrasen'u!"
	icon_state = "poster29_legit"

/obj/structure/sign/poster/official/nanomichi_ad
	name = "Reklama Nanomichi"
	desc = " Plakat reklamujący kasety audio marki Nanomichi."
	icon_state = "poster30_legit"

/obj/structure/sign/poster/official/twelve_gauge
	name = "12 Kaliber"
	desc = "Plakat chwalący się wyższością pocisków do strzelby o kalibrze 12."
	icon_state = "poster31_legit"

/obj/structure/sign/poster/official/high_class_martini
	name = "Wysokiej jakości Martini"
	desc = "Mówiłem Ci, tylko wstrząśnij, nie mieszaj."
	icon_state = "poster32_legit"

/obj/structure/sign/poster/official/the_owl
	name = "Sowa"
	desc = "Sowa zrobiła by wszystko, by ochronić stację. Czy ty też?"
	icon_state = "poster33_legit"

/obj/structure/sign/poster/official/no_erp
	name = "Nie dla ERP"
	desc = "Plakat przypominający załodze, że Erotyka, Pornografia i Gwałt są surowo zabronione na stacjach Nanotrasen'u."
	icon_state = "poster34_legit"

/obj/structure/sign/poster/official/wtf_is_co2
	name = "Dwutlenek Węgla"
	desc = "Plakat informujący, czym jest dwutlenek węgla."
	icon_state = "poster35_legit"

/obj/structure/sign/poster/official/moth1
	name = "Ostrożna Ćma - Zatrucie"
	desc = "Plakat instruktażowy Ostrożnej Ćmy(TM),ostrzegający przed pączkami na pokładzie stacji. Niżej podpis 'AspEv'."
	icon_state = "poster36_legit"

/obj/structure/sign/poster/official/moth2
	name = "Ostrożna Ćma - TbD"
	desc = "Plakat instruktażowy Ostrożnej Ćmy(TM) informujący o niebezpieczeństwa Torby Bez Dna. Niżej podpis 'AspEv'."
	icon_state = "poster37_legit"

/obj/structure/sign/poster/official/moth3
	name = "Ostrożna Ćma - Kaski"
	desc = "Plakat instruktażony Ostrożnej Ćmy(TM) przypominający o noszeniu kasków w niebezpiecznych miejscach. To jak lampa na twojej głowie! Niżej podpis 'AspEv'."
	icon_state = "poster38_legit"

/obj/structure/sign/poster/official/moth4
	name = "Ostrożna Ćma - Dym?"
	desc = "Ten instruktażowy plakat używa Ostrożnej Ćmy(TM) do promowania bezpiecznego użytku plazmy, lub zachęcający załgoę do walki z pożarami plazmowymi. Nie wiemy. Niżej podpis 'AspEv'."
	icon_state = "poster39_legit"

/obj/structure/sign/poster/official/moth5
	name = "Ostrożna Ćma - Rurociągi"
	desc = "Ten instruktażowy plakat używa Ostrożnej Ćmy(TM) przypominający Inżynierom Atmosferyki o używaniu poprawnych rur. Poprawne ułożenie rur zapobiega problemom! Niżej podpis 'AspEv'."
	icon_state = "poster40_legit"

/obj/structure/sign/poster/official/moth6
	name = "Ostrożna Ćma - Supermateria"
	desc = "Ten instruktażowy plakat używa Ostrożnej Ćmy(TM) promujący poprawne zasady bezpieczeństwa, podczas pracy przy Krysztale Supermaterii. Niżej podpisano 'AspEv'."
	icon_state = "poster41_legit"

/obj/structure/sign/poster/official/moth7
	name = "Ostrożna Ćma - Metamfetamina"
	desc = "Ten instruktażowy plakat używa Ostrożnej Ćmy(TM) przypominający o proszeniu o pomoc Ordynatora, podczas gotowania metamfetaminy. Nie powinieneś tego robić. Niżej podpisano 'AspEv'."
	icon_state = "poster42_legit"

/obj/structure/sign/poster/contraband/pill1
	name = "Piguła Bezpieczeństwa - Metamfetamina"
	desc = "Plakat używający wycofanego z użytku Pigułki Bezpieczeństwa(TM?) w celu promowanie mniej legalnych Chemikaliów. To jeden z powodów, dla których przestaliśmy tworzyć te plakaty. Niżej podpisano 'AspEv'."
	icon_state = "poster48"

/obj/structure/sign/poster/official/moth8
	name = "Ostrożna Ćma - Epinefryna"
	desc = "Ten instruktażowy plakat używa Ostrożnej Ćmy(TM) przypominający o pomocy rannemu/zmarłemu członkowi załogi z wstrzykiwaczmi epinefryny. Niżej podpisano 'AspEv'."
	icon_state = "poster43_legit"

/obj/structure/sign/poster/official/moth9
	name = "Ostrożna Ćma - Środki Ostrożności Podczas Delaminacji "
	desc = "Ten instruktażowy plakat używa Ostrożnej Ćmy(TM) przypominający oglądającemu, by chować się w szafkach gdy kryształ się rozwarstwił. Ucieczka może być lepszym rozwiązaniem. Niżej podpisano 'AspEv'."
	icon_state = "poster44_legit"

/obj/structure/sign/poster/contraband/syndiemoth
	name = "Syndie Ćma - Operacja Nuklearna"
	desc = "Zlecony przez Syndykat plakat, używający Syndie Ćmy(TM?) proszący o nie pilnowaniu dysku autoryzacji nuklearnej. Tego nie robimy. Niżej podpisano 'AspEv'."
	icon_state = "poster49"

#undef PLACE_SPEED
