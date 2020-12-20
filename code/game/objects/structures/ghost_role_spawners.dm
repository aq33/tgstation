//Objects that spawn ghosts in as a certain role when they click on it, i.e. away mission bartenders.

//Preserved terrarium/seed vault: Spawns in seed vault structures in lavaland. Ghosts become plantpeople and are advised to begin growing plants in the room near them.
/obj/effect/mob_spawn/human/seed_vault
	name = "preserved terrarium"
	desc = "Starożytna maszyna, która zdaje się być przeznaczona do przechowywania materii roślinnej. Szyba jest przysłonięta pnączami."
	mob_name = "a lifebringer"
	icon = 'icons/obj/lavaland/spawners.dmi'
	icon_state = "terrarium"
	density = TRUE
	roundstart = FALSE
	death = FALSE
	mob_species = /datum/species/pod
	short_desc = "Jesteś świadomym ekosystemem, przykładem zagadkowego cudu życia, który twoi twórcy poznali."
	flavour_text = "Twoi mistrzowie w swojej życzliwości stworzyli niezliczone krypty nasion i rozsiali je po całym \
	wszechświecie, na każdej znanej im planecie. Jesteś w jednej z tych krypt. \
	Twoim celem jest uprawa i rozsiewanie życia gdziekolwiek się da, w myśl wizji twórców. \
	Szacowany czas ostatniego kontaktu: 5 tysiącleci temu."
	assignedrole = "Siewca"

/obj/effect/mob_spawn/human/seed_vault/special(mob/living/new_spawn)
	var/plant_name = pick("Pomidor Patryk", "Ziemnior", "Brokuł Bartek", "Marchewka Marysia", "Truskaweczka Tosia", "Pieczarka Piotrek", "Gruszka Gosia", "Kudzu", "Bananuch", "Jabłko Antek", "Śliwka Sabina", "Kalafior Krzyś", "Rzodkiewka Żaneta", "Groszek Grześ", "Borówka Basia", "Czosnek Czesio", "Bakłażanek Błażejek")
	new_spawn.fully_replace_character_name(null,plant_name)
	if(ishuman(new_spawn))
		var/mob/living/carbon/human/H = new_spawn
		H.underwear = "Nude" //You're a plant, partner
		H.update_body()

/obj/effect/mob_spawn/human/seed_vault/Destroy()
	new/obj/structure/fluff/empty_terrarium(get_turf(src))
	return ..()

//Ash walker eggs: Spawns in ash walker dens in lavaland. Ghosts become unbreathing lizards that worship the Necropolis and are advised to retrieve corpses to create more ash walkers.

/obj/effect/mob_spawn/human/ash_walker
	name = "ash walker egg"
	desc = "Żółte jajo wielkości człowieka, zrodzone z niezbadanej istoty. Wewnątrz czai się humanoidalna sylwetka."
	mob_name = "an ash walker"
	icon = 'icons/mob/lavaland/lavaland_monsters.dmi'
	icon_state = "large_egg"
	mob_species = /datum/species/lizard/ashwalker
	outfit = /datum/outfit/ashwalker
	roundstart = FALSE
	death = FALSE
	anchored = FALSE
	move_resist = MOVE_FORCE_NORMAL
	density = FALSE
	short_desc = "Jesteś Popiołazem. Twoje plemie czci Necropolis."
	flavour_text = "Pustkowia są świętą ziemią, jej monstra błogosławioną nagrodą. \
	Widziałeś światło w oddali... zapowiada nadejście tych, którzy chcą rozerwać Necropolis i jego włości na strzępy. \
	Śweże ofiary dla twojego gniazda."
	assignedrole = "Ash Walker"
	var/datum/team/ashwalkers/team

/obj/effect/mob_spawn/human/ash_walker/special(mob/living/new_spawn)
	new_spawn.fully_replace_character_name(null,random_unique_lizard_name(gender))
	to_chat(new_spawn, "<b>Przeciągaj ciała ludzi i potworów do swojego gniazda. To je pochłonie i stworzy więcej takich jak ty. Nie pozostawiaj gniazda bez ochrony, broń go za cenę życia. Chwała Necropolis!</b>")

	new_spawn.mind.add_antag_datum(/datum/antagonist/ashwalker, team)

	if(ishuman(new_spawn))
		var/mob/living/carbon/human/H = new_spawn
		H.underwear = "Nude"
		H.update_body()

/obj/effect/mob_spawn/human/ash_walker/Initialize(mapload, datum/team/ashwalkers/ashteam)
	. = ..()
	var/area/A = get_area(src)
	team = ashteam
	if(A)
		notify_ghosts("Jajo jest gotowe do wyklucia  [A.name].", source = src, action=NOTIFY_ATTACK, flashwindow = FALSE, ignore_key = POLL_IGNORE_ASHWALKER)

/datum/outfit/ashwalker
	name ="Ashwalker"
	head = /obj/item/clothing/head/helmet/gladiator
	uniform = /obj/item/clothing/under/costume/gladiator/ash_walker


//Timeless prisons: Spawns in Wish Granter prisons in lavaland. Ghosts become age-old users of the Wish Granter and are advised to seek repentance for their past.
/obj/effect/mob_spawn/human/exile
	name = "timeless prison"
	desc = "Mimo że ta kapsuła wygląda na medyczną, zdaje się być zaprojektowana na tyle solidnie, by na długo utrzymać coś przy życiu."
	mob_name = "a penitent exile"
	icon = 'icons/obj/machines/sleeper.dmi'
	icon_state = "sleeper"
	roundstart = FALSE
	death = FALSE
	mob_species = /datum/species/shadow
	short_desc = "Jesteś przeklęty."
	flavour_text = "Lata temu poświęciłeś życia zaufanych przyjaciół, jak i swoje człowieczeństwo, by dotrzeć do Spełniacza Życzeń. Mimo że tego \
	dokonałeś, nie obyło się bez kosztów: twoje całe ciało odrzuca światło, skazując cie na wieczność w przemierzeniu tych pustkowi."
	assignedrole = "Exile"

/obj/effect/mob_spawn/human/exile/Destroy()
	new/obj/structure/fluff/empty_sleeper(get_turf(src))
	return ..()

/obj/effect/mob_spawn/human/exile/special(mob/living/new_spawn)
	new_spawn.fully_replace_character_name(null,"Ofiara Spełniacza Życzeń ([rand(1,999)])")
	var/wish = rand(1,4)
	switch(wish)
		if(1)
			to_chat(new_spawn, "<b>Zażyczyłeś sobie zabijać. I tak się stało. Straciłeś już rachubę ilu dokładnie, ale ta iskra podniecenia wygasła. Teraz czujesz tylko żal</b>")
		if(2)
			to_chat(new_spawn, "<b>Zażyczyłeś sobie wiecznego zdrowia, ale ta egzystencja nie była warta żadnych skarbów. Może dobroczynność cie odkupi?</b>")
		if(3)
			to_chat(new_spawn, "<b>Zażyczyłeś sobie mocy. Mało ci to dało. Jesteś [gender == MALE ? "królem" : "królową"] piekła bez poddanych. Czujesz tylko wyrzuty sumienia.</b>")
		if(4)
			to_chat(new_spawn, "<b>Zażyczyłeś sobie nieśmiertelności, pomimo tego, że twój przyjaciel leży za tobą i zwija się w agonii. Nieważne ile razy rzucisz się w lawę, budzisz się w tym pomieszczeniu po kilku dniach. Nie ma ucieczki.</b>")

//Golem shells: Spawns in Free Golem ships in lavaland. Ghosts become mineral golems and are advised to spread personal freedom.
/obj/effect/mob_spawn/human/golem
	name = "inert free golem shell"
	desc = "Humanoidalny kształt, pusty, bez życia i pełny potencjału."
	mob_name = "a free golem"
	icon = 'icons/obj/wizard.dmi'
	icon_state = "construct"
	mob_species = /datum/species/golem
	roundstart = FALSE
	death = FALSE
	anchored = FALSE
	move_resist = MOVE_FORCE_NORMAL
	density = FALSE
	var/has_owner = FALSE
	var/can_transfer = TRUE //if golems can switch bodies to this new shell
	var/mob/living/owner = null //golem's owner if it has one
	short_desc = "Jesteś Wolnym Golemem. Twoja rodzina czci Wyzwoliciela."
	flavour_text = "W swej nieskończonej i boskiej wiedzy uczynił twój klan wolnym by \
	przemierzać gwiazdy z tylko jednym przesłaniem: \"Ta, rób co chcesz.\" Mimo że jesteś związany ze swoim twórcą, zwyczajem w twojej społeczności stało się powtarzanie tych słów nowonarodzonym \
	golemom, żeby żaden już nigdy nie musiał nikomu służyć."

/obj/effect/mob_spawn/human/golem/Initialize(mapload, datum/species/golem/species = null, mob/creator = null)
	if(species) //spawners list uses object name to register so this goes before ..()
		name += " ([initial(species.prefix)])"
		mob_species = species
	. = ..()
	var/area/A = get_area(src)
	if(!mapload && A)
		notify_ghosts("\A [initial(species.prefix)] skorupa golema została ukończona w  [A.name].", source = src, action=NOTIFY_ATTACK, flashwindow = FALSE, ignore_key = POLL_IGNORE_GOLEM)
	if(has_owner && creator)
		short_desc = "Jesteś golemem."
		flavour_text = "Poruszasz się wolno, ale jesteś odporny na zimno, ciepło i fizyczne uszkodzenia. Nie jesteś w stanie nosić ubrań, ale dalej możesz używać większości narzędzi."
		important_info = "Służ [creator], i asytuj [creator.p_them()] w wykonywaniu celów [creator.p_their()] za wszelką cenę."
		owner = creator

/obj/effect/mob_spawn/human/golem/special(mob/living/new_spawn, name)
	var/datum/species/golem/X = mob_species
	to_chat(new_spawn, "[initial(X.info_text)]")
	if(!owner)
		to_chat(new_spawn, "Buduj skorupy golemów w autolathe i karm je przetworzonymi surowcami, by przywrócić je do życia!")
	else
		new_spawn.mind.store_memory("<b>Serve [owner.real_name], your creator.</b>")
		new_spawn.mind.enslave_mind_to_creator(owner)
		log_game("[key_name(new_spawn)] possessed a golem shell enslaved to [key_name(owner)].")
		log_admin("[key_name(new_spawn)] possessed a golem shell enslaved to [key_name(owner)].")
	if(ishuman(new_spawn))
		var/mob/living/carbon/human/H = new_spawn
		if(has_owner)
			var/datum/species/golem/G = H.dna.species
			G.owner = owner
		H.set_cloned_appearance()
		if(!name)
			if(has_owner)
				H.fully_replace_character_name(null, "[initial(X.prefix)] Golem ([rand(1,999)])")
			else
				H.fully_replace_character_name(null, H.dna.species.random_name())
		else
			H.fully_replace_character_name(null, name)
	if(has_owner)
		new_spawn.mind.assigned_role = "Servant Golem"
	else
		new_spawn.mind.assigned_role = "Free Golem"

/obj/effect/mob_spawn/human/golem/attack_hand(mob/user)
	. = ..()
	if(.)
		return
	if(isgolem(user) && can_transfer)
		var/transfer_choice = alert("Przenieść duszę do [src]? (Uwaga, twoje stare ciało umrze!)",,"Tak","Nie")
		if(transfer_choice != "Yes")
			return
		if(QDELETED(src) || uses <= 0)
			return
		log_game("[key_name(user)] golem-swapped into [src]")
		user.visible_message("<span class='notice'>Drobne światełko ulatuje [user], zmierzając do [src] i ożywiając to!</span>","<span class='notice'>Pozostawiasz dawne ciało za sobą i przenosisz się do [src]!</span>")
		show_flavour = FALSE
		create(ckey = user.ckey,name = user.real_name)
		user.death()
		return

/obj/effect/mob_spawn/human/golem/servant
	has_owner = TRUE
	name = "inert servant golem shell"
	mob_name = "a servant golem"


/obj/effect/mob_spawn/human/golem/adamantine
	name = "dust-caked free golem shell"
	desc = "Humanoidalny kształt, pusty, bez życia i pełny potencjału."
	mob_name = "a free golem"
	can_transfer = FALSE
	mob_species = /datum/species/golem/adamantine

//Malfunctioning cryostasis sleepers: Spawns in makeshift shelters in lavaland. Ghosts become hermits with knowledge of how they got to where they are now.
/obj/effect/mob_spawn/human/hermit
	name = "malfunctioning cryostasis sleeper"
	desc = "Brzęcząca kapsuła z sylwetką pasażera w środku. Jego funkcja stazy jest zepsuta i prawdopodobnie jest używana jako łóżko."
	mob_name = "a stranded hermit"
	icon = 'icons/obj/lavaland/spawners.dmi'
	icon_state = "cryostasis_sleeper"
	roundstart = FALSE
	death = FALSE
	random = TRUE
	mob_species = /datum/species/human
	short_desc = "Utknąłeś w tym bezbożnym więzieniu planety dłużej, niż możesz sobie przypomnieć."
	flavour_text = "Każdego dnia ledwo uchodzisz z życie, z jednej strony prowizoryczny schron ledwo się trzyma, \
	z drugiej próbują cię dorwać monstra i Smok Popiołów przeszywający niebo. Jedyne czego sobie życzysz, to znów poczuć trawę między palcami \
	i świeże powietrze Ziemi. Te myśli rozwiewane są przez kolejne wspomnienia jak się tu znalazłeś... "
	assignedrole = "Hermit"

/obj/effect/mob_spawn/human/hermit/Initialize(mapload)
	. = ..()
	var/arrpee = rand(1,4)
	switch(arrpee)
		if(1)
			flavour_text += "byłeś asystentem [pick("handlarza broni", "szkutnika", "szefa doków")] na małej stacji handlowej kilka sektorów stąd. Bandyci zaatakowali i była \
			i była tylko jedna kapsuła ratunkowa, kiedy dotarłeś do ewakuacji. Wziąłeś ją i wystrzeliłeś sam, patrząc na twarze przeżoneg tłumu tłoczącego się w śluzie i patrzącego jak silnika uruchumiają się \
			i wysyłają cię do tego piekła. Całe zdarenie na stałe wypala się w twojej pamięci..</b>"
			outfit.uniform = /obj/item/clothing/under/misc/assistantformal
		if(2)
			flavour_text += "Jesteś wyrzutkiem Tiger Cooperative. Ich technologiczny fanatyzm sprawił, że zacząłeś kwestionować wiarę w Exoliticów i wtedy właśnie zaczęli postrzegać cię \
			jako heretyka i poddali całym godzinom straszliwych tortur. Godziny dzieliły cię od egzekucji, kiedy twój wysoko postawiony przyjaciel w zarządzie zdołał zoorganizować ci kaspułę ratunkową, \
			wpisać współrzędne i wystrzelić ją. Obudziłeś się ze snu i od tamtego czasu starasz się (ledwo) przeżyć."
			outfit.uniform = /obj/item/clothing/under/rank/prisoner
			outfit.shoes = /obj/item/clothing/shoes/sneakers/orange
			outfit.back = /obj/item/storage/backpack
		if(3)
			flavour_text += "byłeś doktorem na jednej ze stacji Nanotrasenu, ale porzuciłeś tę cholerną korporacyjną tyranie i wszystko co za tym stało. Z metaforycznego piekła \
			do dosłownego i przez to brakuje ci odzyskanego powietrza i ciepłych podłóg, które porzuciłeś... mimo to dalej wolisz być tu, niż tam."
			outfit.uniform = /obj/item/clothing/under/rank/medical/doctor
			outfit.suit = /obj/item/clothing/suit/toggle/labcoat
			outfit.back = /obj/item/storage/backpack/medic
			outfit.shoes = /obj/item/clothing/shoes/sneakers/black
		if(4)
			flavour_text += "zawsze byłeś wyśmiewany przez przyjaciół za to, że\"coś nie do końca stykało w głowie\", jak to  <i>delikatnie</i> określali. I wychodzi na to, że mieli rację. Na jednej z wycieczek \
			po najnowocześniejszej stacji kosmicznej Nanotrasenu, byłeś w kapsule ratunkowej sam i zobaczyłeś wielki czerwony guzik. Był tak duży i świecący, że nie mogłeś oderwać wzroku. Nacisnąłeś \
			go i po przerażającej, szybkiej jeździe po kilku dniach wylądowałeś tutaj. Miałeś czas by zmądrzeć od tamtego czasu i jesteś przekonany, że twoi przyjaciele by się już nie śmiali."

/obj/effect/mob_spawn/human/hermit/Destroy()
	new/obj/structure/fluff/empty_cryostasis_sleeper(get_turf(src))
	return ..()

//Broken rejuvenation pod: Spawns in animal hospitals in lavaland. Ghosts become disoriented interns and are advised to search for help.
/obj/effect/mob_spawn/human/doctor/alive/lavaland
	name = "broken rejuvenation pod"
	desc = "Mała kapsuła, zwykle używana do natychmiastowego leczenia drobnych ran. Ta wydaje się zepsuta, a jej mieszkaniec jest w śpiączce."
	mob_name = "a translocated vet"
	flavour_text = "Co...? Gdzie jesteś? Co tu się dzieje? To wciąż placówka Orion. Byłeś tu stażystą przez tygodnie, ale jedyne \
	co robiłeś, to pryklejałeś rannym plastry. Dlaczego to miejsce jest pełne zaawansowanej technologii? I co to za krzyki na zewnątrz? Świat na zewnątrz jest opustoszały - dręczony ogniem i siarką. Ale złożyłeś przysięgę. \
	Musisz ratować tych ludzi! Może i nie masz tych fikuśnych maszyn do klonowania, co prawdziwe placówki, ale z pewnością musisz znaleźć sposób na ratowanie tych ludzi tym co masz. Prawda?"
	assignedrole = "Translocated Vet"

/obj/effect/mob_spawn/human/doctor/alive/lavaland/Destroy()
	var/obj/structure/fluff/empty_sleeper/S = new(drop_location())
	S.setDir(dir)
	return ..()

//Prisoner containment sleeper: Spawns in crashed prison ships in lavaland. Ghosts become escaped prisoners and are advised to find a way out of the mess they've gotten themselves into.
/obj/effect/mob_spawn/human/prisoner_transport
	name = "prisoner containment sleeper"
	desc = "Kapsuła zaprojektowana tak, by wprowadzała okupującego w głęboką śpiączkę, niezniszczalna dopóki nie zostanie opuszczona. W przypadku tej konkretnej szyba jest pęknięta i widzisz w środku bladą twarz śpiącego człowieka."
	mob_name = "an escaped prisoner"
	icon = 'icons/obj/machines/sleeper.dmi'
	icon_state = "sleeper_s"
	outfit = /datum/outfit/lavalandprisoner
	roundstart = FALSE
	death = FALSE
	short_desc = "Jesteś więźniem skazanym przez Nanotrasen na ciężkie roboty w obozie pracy, ale zdaje się że \
	los ma inne plany dla ciebie."
	flavour_text = "Dobrze. Wygląda na to, że twój statek się rozbił. Pamiętasz, że byłeś skazany za "
	assignedrole = "Escaped Prisoner"

/obj/effect/mob_spawn/human/prisoner_transport/special(mob/living/L)
	L.fully_replace_character_name(null,"NTP #LL-0[rand(111,999)]") //Nanotrasen Prisoner #Lavaland-(numbers)

/obj/effect/mob_spawn/human/prisoner_transport/Initialize(mapload)
	. = ..()
	var/list/crimes = list("morderstwo", "kradzież", "defraudacje", "uzwiązkowienie", "zaniedbanie obowiązków", "porwanie", "rażącą niekompetencje", "wielką kradzież", "współpracę z Syndykatem", \
	"wyznawanie zakazanych bóstwo", "stosunki międzygatunkowe", "bunt")
	flavour_text += "[pick(crimes)]. ,ale mimo to te zbrodnie nie mają teraz znaczenia. Nie wiesz gdzie jesteś, ale wiesz, że to miejsce chce cię zabić i nie masz zamiaru  \
	do tego dopuścić. Znajdź sposób by wydostać się z tego piekła i wróć, gdzie ci się należy - do twojego [pick("domu", "apartamentu", "statku kosmicznego", "miejsca na stacji")]."

/datum/outfit/lavalandprisoner
	name = "Lavaland Prisoner"
	uniform = /obj/item/clothing/under/rank/prisoner
	mask = /obj/item/clothing/mask/breath
	shoes = /obj/item/clothing/shoes/sneakers/orange
	r_pocket = /obj/item/tank/internals/emergency_oxygen


/obj/effect/mob_spawn/human/prisoner_transport/Destroy()
	new/obj/structure/fluff/empty_sleeper/syndicate(get_turf(src))
	return ..()

//Space Hotel Staff
/obj/effect/mob_spawn/human/hotel_staff //not free antag u little shits
	name = "staff sleeper"
	desc = "Kapsuła stworzona do długich wypoczynków między wizytami gości."
	mob_name = "hotel staff member"
	icon = 'icons/obj/machines/sleeper.dmi'
	icon_state = "sleeper_s"
	objectives = "Oczekuj aż w hotelu zjawią się goście, następnie zaoferuj im jak najlepszy pobyt i odpraw z powrotem na stację!"
	death = FALSE
	roundstart = FALSE
	random = TRUE
	outfit = /datum/outfit/hotelstaff
	short_desc = "Jesteś pracownikiem prestiżowego kosmicznego hotelu!"
	flavour_text = "To twój wielki dzień. Niech jedyny kosmiczny hotel na świecie znów znajdzie się na ustach wszystkich."
	important_info = "Pamiętaj o zapłacie i zadowoleniu gości"
	assignedrole = "Hotel Staff"

/datum/outfit/hotelstaff
	name = "Hotel Staff"
	uniform = /obj/item/clothing/under/misc/assistantformal
	shoes = /obj/item/clothing/shoes/laceup
	r_pocket = /obj/item/radio/off
	back = /obj/item/storage/backpack
	implants = list(/obj/item/implant/mindshield)

/obj/effect/mob_spawn/human/hotel_staff/security
	name = "hotel security sleeper"
	mob_name = "hotel security member"
	outfit = /datum/outfit/hotelstaff/security
	short_desc = "Jesteś ochroniarzem."
	flavour_text = "Kiedyś twoją rolą była ochrona tego luksusowego kosmicznego hotelu. Jednak jego lata świetności minęły. \
		Teraz twoim celem jest sprowadzenie tutaj gości, czy tego chcą, czy nie."
	important_info = "NIE ZABIJAJ nikogo. Narzędzia ci dane służą tylko jako środki ostateczne."
	objectives = "Ściągaj ludzi do  hotelu wszelkimi możliwymi środkami. Następnie utrzymaj ich jak najdłużej."

/datum/outfit/hotelstaff/security
	name = "Hotel Security"
	uniform = /obj/item/clothing/under/rank/security/officer/blueshirt
	shoes = /obj/item/clothing/shoes/jackboots
	suit = /obj/item/clothing/suit/armor/vest/blueshirt
	head = /obj/item/clothing/head/helmet/blueshirt
	back = /obj/item/storage/backpack/security
	belt = /obj/item/storage/belt/security/full

/obj/effect/mob_spawn/human/hotel_staff/Destroy()
	new/obj/structure/fluff/empty_sleeper/syndicate(get_turf(src))
	..()

/obj/effect/mob_spawn/human/demonic_friend
	name = "Essence of friendship"
	desc = "Rany julek, przyjaciel!"
	mob_name = "Demonic friend"
	icon = 'icons/obj/cardboard_cutout.dmi'
	icon_state = "cutout_basic"
	outfit = /datum/outfit/demonic_friend
	death = FALSE
	roundstart = FALSE
	random = TRUE
	id_job = "SuperFriend"
	id_access = "assistant"
	var/obj/effect/proc_holder/spell/targeted/summon_friend/spell
	var/datum/mind/owner
	assignedrole = "SuperFriend"

/obj/effect/mob_spawn/human/demonic_friend/Initialize(mapload, datum/mind/owner_mind, obj/effect/proc_holder/spell/targeted/summon_friend/summoning_spell)
	. = ..()
	owner = owner_mind
	flavour_text = "Dostałeś szansę wyrwać się z więcznej męki, by być przyjacielem [owner.name] dla[owner.p_their()] kruchej egzystencji."
	important_info = "Bądź świadom, że jeśli nie spełnisz oczekiwań [owner.name], może cię odesłać do piekła pstryknięciem palców. Śmierć [owner.name]również wrzuci cię z porwotem do piekła."
	var/area/A = get_area(src)
	if(!mapload && A)
		notify_ghosts("Więź przyjaźni została utworzona w [A.name].", source = src, action=NOTIFY_ATTACK, flashwindow = FALSE)
	objectives = "Bądź pryjacielem [owner.name]i utrzymaj [owner.name] przy życiu, żebyś nie musiał wracać do piekła."
	spell = summoning_spell


/obj/effect/mob_spawn/human/demonic_friend/special(mob/living/L)
	if(!QDELETED(owner.current) && owner.current.stat != DEAD)
		L.fully_replace_character_name(null,"[owner.name]'s best friend")
		soullink(/datum/soullink/oneway, owner.current, L)
		spell.friend = L
		spell.charge_counter = spell.charge_max
		L.mind.hasSoul = FALSE
		var/mob/living/carbon/human/H = L
		var/obj/item/worn = H.wear_id
		var/obj/item/card/id/id = worn.GetID()
		id.registered_name = L.real_name
		id.update_label()
	else
		to_chat(L, "<span class='userdanger'>Twój właściciel już jest martwy!  Wkrótce znikniesz.</span>")
		addtimer(CALLBACK(L, /mob.proc/dust, 150)) //Give em a few seconds as a mercy.

/datum/outfit/demonic_friend
	name = "Demonic Friend"
	uniform = /obj/item/clothing/under/misc/assistantformal
	shoes = /obj/item/clothing/shoes/laceup
	r_pocket = /obj/item/radio/off
	back = /obj/item/storage/backpack
	implants = list(/obj/item/implant/mindshield) //No revolutionaries, he's MY friend.
	id = /obj/item/card/id

/obj/effect/mob_spawn/human/syndicate
	name = "Syndicate Operative"
	roundstart = FALSE
	death = FALSE
	icon = 'icons/obj/machines/sleeper.dmi'
	icon_state = "sleeper_s"
	outfit = /datum/outfit/syndicate_empty
	assignedrole = "Space Syndicate"	//I know this is really dumb, but Syndicate operative is nuke ops

/datum/outfit/syndicate_empty
	name = "Syndicate Operative Empty"
	uniform = /obj/item/clothing/under/syndicate
	shoes = /obj/item/clothing/shoes/combat
	gloves = /obj/item/clothing/gloves/combat
	ears = /obj/item/radio/headset/syndicate/alt
	back = /obj/item/storage/backpack
	implants = list(/obj/item/implant/weapons_auth)
	id = /obj/item/card/id/syndicate

/datum/outfit/syndicate_empty/post_equip(mob/living/carbon/human/H)
	H.faction |= ROLE_SYNDICATE

/obj/effect/mob_spawn/human/syndicate/battlecruiser
	name = "Syndicate Battlecruiser Ship Operative"
	short_desc = "You are a crewmember aboard the syndicate flagship: the SBC Starfury."
	flavour_text = "Your job is to follow your captain's orders, maintain the ship, and keep the engine running. If you are not familiar with how the supermatter engine functions: do not attempt to start it."
	important_info = "The armory is not a candy store, and your role is not to assault the station directly, leave that work to the assault operatives."
	outfit = /datum/outfit/syndicate_empty/SBC

/datum/outfit/syndicate_empty/SBC
	name = "Syndicate Battlecruiser Ship Operative"
	l_pocket = /obj/item/gun/ballistic/automatic/pistol
	r_pocket = /obj/item/kitchen/knife/combat/survival
	belt = /obj/item/storage/belt/military/assault

/obj/effect/mob_spawn/human/syndicate/battlecruiser/assault
	name = "Syndicate Battlecruiser Assault Operative"
	short_desc = "You are an assault operative aboard the syndicate flagship: the SBC Starfury."
	flavour_text = "Your job is to follow your captain's orders, keep intruders out of the ship, and assault Space Station 13. There is an armory, multiple assault ships, and beam cannons to attack the station with."
	important_info = "Work as a team with your fellow operatives and work out a plan of attack. If you are overwhelmed, escape back to your ship!"
	outfit = /datum/outfit/syndicate_empty/SBC/assault

/datum/outfit/syndicate_empty/SBC/assault
	name = "Syndicate Battlecruiser Assault Operative"
	uniform = /obj/item/clothing/under/syndicate/combat
	l_pocket = /obj/item/ammo_box/magazine/m10mm
	r_pocket = /obj/item/kitchen/knife/combat/survival
	belt = /obj/item/storage/belt/military
	suit = /obj/item/clothing/suit/armor/vest
	suit_store = /obj/item/gun/ballistic/automatic/pistol
	back = /obj/item/storage/backpack/security
	mask = /obj/item/clothing/mask/gas/syndicate

/obj/effect/mob_spawn/human/syndicate/battlecruiser/captain
	name = "Syndicate Battlecruiser Captain"
	short_desc = "You are the captain aboard the syndicate flagship: the SBC Starfury."
	flavour_text = "Your job is to oversee your crew, defend the ship, and destroy Space Station 13. The ship has an armory, multiple ships, beam cannons, and multiple crewmembers to accomplish this goal."
	important_info = "As the captain, this whole operation falls on your shoulders. You do not need to nuke the station, causing sufficient damage and preventing your ship from being destroyed will be enough."
	outfit = /datum/outfit/syndicate_empty/SBC/assault/captain
	id_access_list = list(150,151)

/datum/outfit/syndicate_empty/SBC/assault/captain
	name = "Syndicate Battlecruiser Captain"
	l_pocket = /obj/item/melee/transforming/energy/sword/saber/red
	r_pocket = /obj/item/melee/classic_baton/police/telescopic
	suit = /obj/item/clothing/suit/armor/vest/capcarapace/syndicate
	suit_store = /obj/item/gun/ballistic/revolver/mateba
	back = /obj/item/storage/backpack/satchel/leather
	head = /obj/item/clothing/head/HoS/syndicate
	mask = /obj/item/clothing/mask/cigarette/cigar/havana
	glasses = /obj/item/clothing/glasses/thermal/eyepatch

//Ancient cryogenic sleepers. Players become NT crewmen from a hundred year old space station, now on the verge of collapse.
/obj/effect/mob_spawn/human/oldsec
	name = "old cryogenics pod"
	desc = "Brzęcząca komor kriogeniczna. Ledwo rozpoznajesz ubiór ochroniarza przez narośniety lód. Maszyna stara się obudzić użytkownika."
	mob_name = "a security officer"
	icon = 'icons/obj/machines/sleeper.dmi'
	icon_state = "sleeper"
	roundstart = FALSE
	death = FALSE
	random = TRUE
	mob_species = /datum/species/human
	flavour_text = "<span class='big bold'>Jesteś oficerem ochrony pracującym dla Nanotrasen,</span><b> stacjonujący na pokładzie najnowocześniejszej technologicznie stacji. Ledwo przypominasz sobie szaleńczy bieg do \
	kriogeniki przez nadciągającą burzę radiacyjną. Ostatnią rzecz jaką pamiętasz, to Sztuczną Inteligencję stacji mówiącą, że będziesz w stanie snu jedynie przez 8 godzin. Jak tylko otworzyłeś \
	oczy, wszystko wydało się nagle stare i zardzewiałe. Czyjesz coś niedobrego w kościach, wychodząc z kapsuły. \
	Pracuj jako drużyna z pozostałymi przy życiu załogantami, by przywrócić stacji świetność lub ondaleźć swojego pracodawcę. \
	Work as a team with your fellow survivors and do not abandon them.</b>"
	uniform = /obj/item/clothing/under/rank/security/officer
	shoes = /obj/item/clothing/shoes/jackboots
	id = /obj/item/card/id/away/old/sec
	r_pocket = /obj/item/restraints/handcuffs
	l_pocket = /obj/item/assembly/flash/handheld
	assignedrole = "Ancient Crew"

/obj/effect/mob_spawn/human/oldsec/Destroy()
	new/obj/structure/showcase/machinery/oldpod/used(drop_location())
	return ..()

/obj/effect/mob_spawn/human/oldeng
	name = "old cryogenics pod"
	desc = "Brzęcząca komor kriogeniczna. Ledwo rozpoznajesz ubiór inżyniera przez narośniety lód. Maszyna stara się obudzić użytkownika."
	mob_name = "an engineer"
	icon = 'icons/obj/machines/sleeper.dmi'
	icon_state = "sleeper"
	roundstart = FALSE
	death = FALSE
	random = TRUE
	mob_species = /datum/species/human
	flavour_text = "<span class='big bold'>Jesteś inżynierem pracującym dla Nanotrasen,</span><b> stacjonujący na pokładzie najnowocześniejszej technologicznie stacji. Ledwo przypominasz sobie szaleńczy bieg do \
	kriogeniki przez nadciągającą burzę radiacyjną. Ostatnią rzecz jaką pamiętasz, to Sztuczną Inteligencję stacji mówiącą, że będziesz w stanie snu jedynie przez 8 godzin. Jak tylko otworzyłeś \
	oczy, wszystko wydało się nagle stare i zardzewiałe. Czyjesz coś niedobrego w kościach, wychodząc z kapsuły. \
	Pracuj jako drużyna z pozostałymi przy życiu załogantami, by przywrócić stacji świetność lub ondaleźć swojego pracodawcę.</b>"
	uniform = /obj/item/clothing/under/rank/engineering/engineer
	shoes = /obj/item/clothing/shoes/workboots
	id = /obj/item/card/id/away/old/eng
	gloves = /obj/item/clothing/gloves/color/fyellow/old
	l_pocket = /obj/item/tank/internals/emergency_oxygen
	assignedrole = "Ancient Crew"

/obj/effect/mob_spawn/human/oldeng/Destroy()
	new/obj/structure/showcase/machinery/oldpod/used(drop_location())
	return ..()

/obj/effect/mob_spawn/human/oldsci
	name = "old cryogenics pod"
	desc = "Brzęcząca komor kriogeniczna. Ledwo rozpoznajesz ubiór naukowca przez narośniety lód. Maszyna stara się obudzić użytkownika."
	mob_name = "a scientist"
	icon = 'icons/obj/machines/sleeper.dmi'
	icon_state = "sleeper"
	roundstart = FALSE
	death = FALSE
	random = TRUE
	mob_species = /datum/species/human
	flavour_text = "<span class='big bold'>Jesteś naukowcem pracującym dla Nanotrasen,</span><b> stacjonujący na pokładzie najnowocześniejszej technologicznie stacji. Ledwo przypominasz sobie szaleńczy bieg do \
	kriogeniki przez nadciągającą burzę radiacyjną. Ostatnią rzecz jaką pamiętasz, to Sztuczną Inteligencję stacji mówiącą, że będziesz w stanie snu jedynie przez 8 godzin. Jak tylko otworzyłeś \
	oczy, wszystko wydało się nagle stare i zardzewiałe. Czyjesz coś niedobrego w kościach, wychodząc z kapsuły. \
	Pracuj jako drużyna z pozostałymi przy życiu załogantami, by przywrócić stacji świetność lub ondaleźć swojego pracodawcę.</b>"
	uniform = /obj/item/clothing/under/rank/rnd/scientist/hlsci
	shoes = /obj/item/clothing/shoes/laceup
	id = /obj/item/card/id/away/old/sci
	l_pocket = /obj/item/stack/medical/suture
	assignedrole = "Ancient Crew"

/obj/effect/mob_spawn/human/oldsci/Destroy()
	new/obj/structure/showcase/machinery/oldpod/used(drop_location())
	return ..()

/obj/effect/mob_spawn/human/pirate
	name = "space pirate sleeper"
	desc = "A cryo sleeper smelling faintly of rum."
	random = TRUE
	icon = 'icons/obj/machines/sleeper.dmi'
	icon_state = "sleeper"
	mob_name = "a space pirate"
	mob_species = /datum/species/skeleton
	outfit = /datum/outfit/pirate/space
	roundstart = FALSE
	death = FALSE
	anchored = TRUE
	density = FALSE
	show_flavour = FALSE //Flavour only exists for spawners menu
	short_desc = "Jesteś kosmicznym piratem."
	flavour_text = "Stacja odmówiła zapłaty w zamian za waszą ochronę. Broń statku, wysysaj kredyty ze stacji i najeżdzaj ją w poszukiwaniu jeszcze większego zarobku."
	assignedrole = "Kosmiczny pirat"
	var/rank = "Majtek"

/obj/effect/mob_spawn/human/pirate/special(mob/living/new_spawn)
	new_spawn.fully_replace_character_name(new_spawn.real_name,generate_pirate_name())
	new_spawn.mind.add_antag_datum(/datum/antagonist/pirate)

/obj/effect/mob_spawn/human/pirate/proc/generate_pirate_name()
	var/beggings = strings(PIRATE_NAMES_FILE, "beginnings")
	var/endings = strings(PIRATE_NAMES_FILE, "endings")
	return "[rank] [pick(beggings)][pick(endings)]"

/obj/effect/mob_spawn/human/pirate/Destroy()
	new/obj/structure/showcase/machinery/oldpod/used(drop_location())
	return ..()

/obj/effect/mob_spawn/human/pirate/captain
	rank = "Kapitan"
	outfit = /datum/outfit/pirate/space/captain

/obj/effect/mob_spawn/human/pirate/gunner
	rank = "Strzelec"

//Forgotten syndicate ship

/obj/effect/mob_spawn/human/syndicatespace
	name = "Syndicate Ship Crew Member"
	roundstart = FALSE
	death = FALSE
	icon = 'icons/obj/machines/sleeper.dmi'
	icon_state = "sleeper_s"
	short_desc = "Jesteś operatorem Syndykatu na starym statku, który utknął w niebezpiecznej przestrzeni."
	flavour_text = "Twój statek po dłuższym czasie dociera do wrogiego miejsca, zgłaszając awarię. Utknąłeś tutaj ze stacją Nanotrasenu w pobliżu. Napraw statek, przywróć mu zasilanie i słuchaj rozkazów kapitana."
	important_info = "Bądź posłuszny rozkazom kapitana. Jeśli nie ma żadnych rozkazów lub brakuje kapitana, pozostań na statku i oczekuj rozkazów z góry. Skorzystaj z czerwonego telefonu. NIE POZWÓL by statek wpadł w ręce wroga."
	outfit = /datum/outfit/syndicatespace/syndicrew
	assignedrole = "Cybersun Crewmember"

/datum/outfit/syndicatespace/syndicrew/post_equip(mob/living/carbon/human/H)
	H.faction |= ROLE_SYNDICATE

/obj/effect/mob_spawn/human/syndicatespace/special(mob/living/new_spawn)
	new_spawn.grant_language(/datum/language/codespeak)

/obj/effect/mob_spawn/human/syndicatespace/captain
	name = "Syndicate Ship Captain"
	roundstart = FALSE
	death = FALSE
	icon = 'icons/obj/machines/sleeper.dmi'
	icon_state = "sleeper_s"
	short_desc = "Jesteś kapitanem starego statku, który utknął w niebezpiecznej przestrzeni."
	flavour_text = "Twój statek po dłuższym czasie dociera do wrogiego miejsca, zgłaszając awarię. Utknąłeś tutaj ze stacją Nanotrasenu w pobliżu. Pokieruj swoją załogą z przywróć chwałę tej jednostce."
	important_info = "Chroń statku i tajnych dokumentów w twoim plecaku za wszelką cenę. NIE POZWÓL by statek wpadł w ręce wroga. OCZEKUJ peleceń z samej góry, zanim wdasz się w otwarty konflikt z załogą stacji. Skorzystaj z czerwonego telefonu na statku."
	outfit = /datum/outfit/syndicatespace/syndicaptain
	assignedrole = "Cybersun Captain"

/datum/outfit/syndicatespace/syndicaptain/post_equip(mob/living/carbon/human/H)
	H.faction |= ROLE_SYNDICATE

/obj/effect/mob_spawn/human/syndicatespace/captain/Destroy()
	new/obj/structure/fluff/empty_sleeper/syndicate/captain(get_turf(src))
	return ..()

/datum/outfit/syndicatespace/syndicrew
	name = "Załogant statku Syndykatu"
	uniform = /obj/item/clothing/under/syndicate/combat
	glasses = /obj/item/clothing/glasses/night
	mask = /obj/item/clothing/mask/gas/syndicate
	ears = /obj/item/radio/headset/syndicate/alt
	shoes = /obj/item/clothing/shoes/combat
	gloves = /obj/item/clothing/gloves/combat
	back = /obj/item/storage/backpack
	l_pocket = /obj/item/gun/ballistic/automatic/pistol
	r_pocket = /obj/item/kitchen/knife/combat/survival
	belt = /obj/item/storage/belt/military/assault
	id = /obj/item/card/id/syndicate_command/crew_id
	implants = list(/obj/item/implant/weapons_auth)

/datum/outfit/syndicatespace/syndicaptain
	name = "Kapitan statku Syndykatu"
	uniform = /obj/item/clothing/under/syndicate/combat
	suit = /obj/item/clothing/suit/armor/vest/capcarapace/syndicate
	glasses = /obj/item/clothing/glasses/night
	mask = /obj/item/clothing/mask/gas/syndicate
	head = /obj/item/clothing/head/HoS/beret/syndicate
	ears = /obj/item/radio/headset/syndicate/alt/leader
	shoes = /obj/item/clothing/shoes/combat
	gloves = /obj/item/clothing/gloves/combat
	back = /obj/item/storage/backpack
	l_pocket = /obj/item/gun/ballistic/automatic/pistol/APS
	r_pocket = /obj/item/kitchen/knife/combat/survival
	belt = /obj/item/storage/belt/military/assault
	id = /obj/item/card/id/syndicate_command/captain_id
	backpack_contents = list(/obj/item/documents/syndicate/red, /obj/item/paper/fluff/ruins/forgottenship/password)
	implants = list(/obj/item/implant/weapons_auth)
