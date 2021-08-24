#define BLOB_REROLL_CHOICES 6
#define BLOB_REROLL_RADIUS 60

/mob/camera/blob/proc/can_buy(cost = 15)
	if(blob_points < cost)
		to_chat(src, "<span class='warning'>Nie masz wystarczająco zasobów by to kupić, potrzebujesz co najmniej [cost]!</span>")
		return 0
	add_points(-cost)
	return 1

// Power verbs

/mob/camera/blob/proc/place_blob_core(placement_override, pop_override = FALSE)
	if(placed && placement_override != -1)
		return 1
	if(!placement_override)
		if(!pop_override)
			for(var/mob/living/M in range(7, src))
				if(ROLE_BLOB in M.faction)
					continue
				if(M.client)
					to_chat(src, "<span class='warning'>Ktoś jest za blisko by postawić tutaj twój rdzeń!</span>")
					return 0
			for(var/mob/living/M in hearers(13, src))
				if(ROLE_BLOB in M.faction)
					continue
				if(M.client)
					to_chat(src, "<span class='warning'>Ktoś mógłby zobaczyć tutaj twój rdzeń!</span>")
					return 0
		var/turf/T = get_turf(src)
		if(T.density)
			to_chat(src, "<span class='warning'>W tym miejscu jest zbyt gęsto by postawić tutaj twój rdzeń!</span>")
			return 0
		for(var/obj/O in T)
			if(istype(O, /obj/structure/blob))
				if(istype(O, /obj/structure/blob/normal))
					qdel(O)
				else
					to_chat(src, "<span class='warning'>Jest tu już blob!</span>")
					return 0
			else if(O.density)
				to_chat(src, "<span class='warning'>>W tym miejscu jest zbyt gęsto by postawić tutaj twój rdzeń!</span>")
				return 0
		if(!pop_override && world.time <= manualplace_min_time && world.time <= autoplace_max_time)
			to_chat(src, "<span class='warning'>Jest zbyt wcześnie by postawić twój rdzeń!</span>")
			return 0
	else if(placement_override == 1)
		var/turf/T = pick(GLOB.blobstart)
		forceMove(T) //got overrided? you're somewhere random, motherfucker
	if(placed && blob_core)
		blob_core.forceMove(loc)
	else
		var/obj/structure/blob/core/core = new(get_turf(src), src, 1)
		core.overmind = src
		blobs_legit += src
		blob_core = core
		core.update_icon()
	update_health_hud()
	placed = 1
	return 1

/mob/camera/blob/verb/transport_core()
	set category = "Blob"
	set name = "Skocz do Rdzenia"
	set desc = "Przenosi twój widok do rdzenia."
	if(blob_core)
		forceMove(blob_core.drop_location())

/mob/camera/blob/verb/jump_to_node()
	set category = "Blob"
	set name = "Skocz do Węzła"
	set desc = "Przenosi twój widok do wybranego węzła."
	if(GLOB.blob_nodes.len)
		var/list/nodes = list()
		for(var/i in 1 to GLOB.blob_nodes.len)
			var/obj/structure/blob/node/B = GLOB.blob_nodes[i]
			nodes["Blob Node #[i] ([B.overmind ? "[B.overmind.blobstrain.name]":"No Strain"])"] = B
		var/node_name = input(src, "Choose a node to jump to.", "Node Jump") in nodes
		var/obj/structure/blob/node/chosen_node = nodes[node_name]
		if(chosen_node)
			forceMove(chosen_node.loc)

/mob/camera/blob/proc/createSpecial(price, blobstrain, nearEquals, needsNode, turf/T)
	if(!T)
		T = get_turf(src)
	var/obj/structure/blob/B = (locate(/obj/structure/blob) in T)
	if(!B)
		to_chat(src, "<span class='warning'>Tutaj nie ma grzyba!</span>")
		return
	if(!istype(B, /obj/structure/blob/normal))
		to_chat(src, "<span class='warning'>Nie można użyć na tym typie grzyba, znajdź zwykłego grzyba.</span>")
		return
	if(needsNode && nodes_required)
		if(!(locate(/obj/structure/blob/node) in orange(3, T)) && !(locate(/obj/structure/blob/core) in orange(4, T)))
			to_chat(src, "<span class='warning'>Musisz być bliżej rdzenia lub węzła by postawić tego grzyba!</span>")
			return //handholdotron 2000
	if(nearEquals)
		for(var/obj/structure/blob/L in orange(nearEquals, T))
			if(L.type == blobstrain)
				to_chat(src, "<span class='warning'>Niedaleko jest podobny typ grzyba, oddal się o tyle kratek: [nearEquals]</span>")
				return
	if(!can_buy(price))
		return
	var/obj/structure/blob/N = B.change_to(blobstrain, src)
	return N

/mob/camera/blob/verb/toggle_node_req()
	set category = "Blob"
	set name = "Toggle Node Requirement"
	set desc = "Toggle requiring nodes to place resource and factory blobs."
	nodes_required = !nodes_required
	if(nodes_required)
		to_chat(src, "<span class='warning'>You now require a nearby node or core to place factory and resource blobs.</span>")
	else
		to_chat(src, "<span class='warning'>You no longer require a nearby node or core to place factory and resource blobs.</span>")

/mob/camera/blob/verb/create_shield_power()
	set category = "Blob"
	set name = "Stwórz gęstego grzyba (15)"
	set desc = "Tworzy Gęstego Grzyba, który blokuje ogień oraz jest trudniejszy w zabiciu. Użycie tej umiejętności na Gęstym Grzybie zamieni go w Grzyba Lustrzanego, który odbija większość pocisków za cenę otrzymywania podwójnych obrażeń fizycznych."
	create_shield()

/mob/camera/blob/proc/create_shield(turf/T)
	var/obj/structure/blob/shield/S = locate(/obj/structure/blob/shield) in T
	if(S)
		if(!can_buy(BLOB_REFLECTOR_COST))
			return
		if(S.obj_integrity < S.max_integrity * 0.5)
			add_points(BLOB_REFLECTOR_COST)
			to_chat(src, "<span class='warning'>Ten grzyb jest zbyt mocno uszkodzony by go ulepszyć!</span>")
			return
		to_chat(src, "<span class='warning'>Pokrywasz silnego grzyba specjalną wydzieliną, pozwalając mu odbijać pociski kosztem mniejszej wytrzymałości.</span>")
		S.change_to(/obj/structure/blob/shield/reflective, src)
	else
		createSpecial(15, /obj/structure/blob/shield, 0, 0, T)

/mob/camera/blob/verb/create_resource()
	set category = "Blob"
	set name = "Stwórz Owocnik (40)"
	set desc = "Tworzy Owocnik, który będzie generować dla ciebie zasoby."
	createSpecial(40, /obj/structure/blob/resource, 4, 1)

/mob/camera/blob/verb/create_node()
	set category = "Blob"
	set name = "Stwórz Węzeł (50)"
	set desc = "Stwórz węzeł, który zasili twoje owocniki oraz zarodnie."
	createSpecial(50, /obj/structure/blob/node, 5, 0)

/mob/camera/blob/verb/create_factory()
	set category = "Blob"
	set name = "Stwórz Zarodnię (60)"
	set desc = "Stwórz zardonię, która będzie wytwarzać zarodniki, by dokuczać twoim przeciwnikom."
	createSpecial(60, /obj/structure/blob/factory, 7, 1)

/mob/camera/blob/verb/create_blobbernaut()
	set category = "Blob"
	set name = "Stwórz Grzybonautę (40)"
	set desc = "Stwórz potężnego grzybonautę, który jest (zazwyczaj) inteligentny oraz atakuje przeciwników."
	var/turf/T = get_turf(src)
	var/obj/structure/blob/factory/B = locate(/obj/structure/blob/factory) in T
	if(!B)
		to_chat(src, "<span class='warning'>Musisz znajdować się na zarodni!</span>")
		return
	if(B.naut) //if it already made a blobbernaut, it can't do it again
		to_chat(src, "<span class='warning'>Ta zarodnia podtrzumuje już grzybonautę.</span>")
		return
	if(B.obj_integrity < B.max_integrity * 0.5)
		to_chat(src, "<span class='warning'>Ta zarodnia jest zbyt uszkodzona by podtrzymać grzybonautę.</span>")
		return
	if(!can_buy(40))
		return

	B.naut = TRUE	//temporary placeholder to prevent creation of more than one per factory.
	to_chat(src, "<span class='notice'>You attempt to produce a blobbernaut.</span>")
	var/list/mob/dead/observer/candidates = pollGhostCandidates("Czy chesz zagrać jako Grzybonauta odmiany [blobstrain.name]?", ROLE_BLOB, null, ROLE_BLOB, 50) //players must answer rapidly
	if(LAZYLEN(candidates)) //if we got at least one candidate, they're a blobbernaut now.
		B.max_integrity = initial(B.max_integrity) * 0.25 //factories that produced a blobbernaut have much lower health
		B.obj_integrity = min(B.obj_integrity, B.max_integrity)
		B.update_icon()
		B.visible_message("<span class='warning'><b>Zarodnia przekształca się w potężnego Grzybonautę, bez implikacji swojego zniknięcia!</b></span>")
		playsound(B.loc, 'sound/effects/splat.ogg', 50, 1)
		var/mob/living/simple_animal/hostile/blob/blobbernaut/blobber = new /mob/living/simple_animal/hostile/blob/blobbernaut(get_turf(B))
		flick("blobbernaut_produce", blobber)
		B.naut = blobber
		blobber.factory = B
		blobber.overmind = src
		blobber.update_icons()
		blobber.adjustHealth(blobber.maxHealth * 0.5)
		blob_mobs += blobber
		var/mob/dead/observer/C = pick(candidates)
		blobber.key = C.key
		SEND_SOUND(blobber, sound('sound/effects/blobattack.ogg'))
		SEND_SOUND(blobber, sound('sound/effects/attackblob.ogg'))
		to_chat(blobber, "<b>Jesteś Grzybonautą!</b>")
		to_chat(blobber, "Jesteś potężnym i trudnym w zabiciu wojownikiem. Powoli się regenerujesz, gdy jesteś w pobliżu rdzenia lub węzłów, <span class='cultlarge'>ale będziesz powoli tracić zdrowie, jeżeli nie jesteś w pobliżu grzyba</span> lub gdy twoja zarodnia zostanie zniszczona.")
		to_chat(blobber, "Możesz komunikować się z innymi grzybonautami oraz grzybem za pomocą <b>:b</b>")
		to_chat(blobber, "Odmiana twojego grzyba to: <b><font color=\"[blobstrain.color]\">[blobstrain.name]</b></font>!")
		to_chat(blobber, "Jako <b><font color=\"[blobstrain.color]\">[blobstrain.name]</b></font> [blobstrain.shortdesc ? "[blobstrain.shortdesc]" : "[blobstrain.description]"]")
	else
		to_chat(src, "<span class='warning'>Nie udało ci się przywołać świadomości dla twojego grzybonauty. Twoje zasoby zostały zwrócone.</span>")
		add_points(40)
		B.naut = null

/mob/camera/blob/verb/relocate_core()
	set category = "Blob"
	set name = "Przenieś Rdzeń (80)"
	set desc = "Zamienia miejscami twój rdzeń z wybranym węzłem."
	var/turf/T = get_turf(src)
	var/obj/structure/blob/node/B = locate(/obj/structure/blob/node) in T
	if(!B)
		to_chat(src, "<span class='warning'>Musisz znajować się na węźle by to zrobić!</span>")
		return
	if(!blob_core)
		to_chat(src, "<span class='userdanger'>Utraciłeś swój rdzeń i niedługo zgninesz! Spoczywaj w pokoju.</span>")
		return
	var/area/A = get_area(T)
	if(isspaceturf(T) || A && !A.blob_allowed)
		to_chat(src, "<span class='warning'>Nie możesz przenieść tutaj swojego rdzenia!</span>")
		return
	if(!can_buy(80))
		return
	var/turf/old_turf = get_turf(blob_core)
	var/olddir = blob_core.dir
	blob_core.forceMove(T)
	blob_core.setDir(B.dir)
	B.forceMove(old_turf)
	B.setDir(olddir)

/mob/camera/blob/verb/revert()
	set category = "Blob"
	set name = "Usuń Grzyba"
	set desc = "Usuwa grzyba, zwracając część zasobów."
	var/turf/T = get_turf(src)
	remove_blob(T)

/mob/camera/blob/proc/remove_blob(turf/T)
	var/obj/structure/blob/B = locate() in T
	if(!B)
		to_chat(src, "<span class='warning'>Nie ma tutaj grzyba!</span>")
		return
	if(B.point_return < 0)
		to_chat(src, "<span class='warning'>Nie udało się usunąć tego grzyba!</span>")
		return
	if(max_blob_points < B.point_return + blob_points)
		to_chat(src, "<span class='warning'>Posiadasz za dużo zasobów by usunąć tego grzyba!</span>")
		return
	if(B.point_return)
		add_points(B.point_return)
		to_chat(src, "<span class='notice'>Zyskałeś [B.point_return] zasobów za usunięcie tego grzyba.</span>")
	qdel(B)

/mob/camera/blob/verb/expand_blob_power()
	set category = "Blob"
	set name = "Rozrost/Atak ([BLOB_SPREAD_COST])"
	set desc = "Grzyb spróbuje rozrosnąć się w tym kierunku. Jeżeli kafelek jest zablokowany, zostanie zaatakowany, zadając obrażenia obiektom oraz przeciwników, zwracając [BLOB_ATTACK_REFUND] zasobów."
	var/turf/T = get_turf(src)
	expand_blob(T)

/mob/camera/blob/proc/expand_blob(turf/T)
	if(world.time < last_attack)
		return
	var/list/possibleblobs = list()
	for(var/obj/structure/blob/AB in range(1, T))
		possibleblobs += AB
	if(!possibleblobs.len)
		to_chat(src, "<span class='warning'>Na przylegającym kafelku musi być grzyb, by to zrobić!!</span>")
		return
	if(can_buy(BLOB_SPREAD_COST))
		var/attacksuccess = FALSE
		for(var/mob/living/L in T)
			if(ROLE_BLOB in L.faction) //no friendly/dead fire
				continue
			if(L.stat != DEAD)
				attacksuccess = TRUE
			blobstrain.attack_living(L)
		var/obj/structure/blob/B = locate() in T
		if(B)
			if(attacksuccess) //if we successfully attacked a turf with a blob on it, only give an attack refund
				B.blob_attack_animation(T, src)
				add_points(BLOB_ATTACK_REFUND)
			else
				to_chat(src, "<span class='warning'>Tutaj znajduje się już grzyb!</span>")
				add_points(BLOB_SPREAD_COST) //otherwise, refund all of the cost
		else
			var/list/cardinalblobs = list()
			var/list/diagonalblobs = list()
			for(var/I in possibleblobs)
				var/obj/structure/blob/IB = I
				if(get_dir(IB, T) in GLOB.cardinals)
					cardinalblobs += IB
				else
					diagonalblobs += IB
			var/obj/structure/blob/OB
			if(cardinalblobs.len)
				OB = pick(cardinalblobs)
				if(!OB.expand(T, src))
					add_points(BLOB_ATTACK_REFUND) //assume it's attacked SOMETHING, possibly a structure
			else
				OB = pick(diagonalblobs)
				if(attacksuccess)
					OB.blob_attack_animation(T, src)
					playsound(OB, 'sound/effects/splat.ogg', 50, 1)
					add_points(BLOB_ATTACK_REFUND)
				else
					add_points(BLOB_SPREAD_COST) //if we're attacking diagonally and didn't hit anything, refund
		if(attacksuccess)
			last_attack = world.time + CLICK_CD_MELEE
		else
			last_attack = world.time + CLICK_CD_RAPID

/mob/camera/blob/verb/rally_spores_power()
	set category = "Blob"
	set name = "Rally Spores"
	set desc = "Rally your spores to move to a target location."
	var/turf/T = get_turf(src)
	rally_spores(T)

/mob/camera/blob/proc/rally_spores(turf/T)
	to_chat(src, "Zbierasz swoje zarodniki.")
	var/list/surrounding_turfs = block(locate(T.x - 1, T.y - 1, T.z), locate(T.x + 1, T.y + 1, T.z))
	if(!surrounding_turfs.len)
		return
	for(var/mob/living/simple_animal/hostile/blob/blobspore/BS in blob_mobs)
		if(!BS.key && isturf(BS.loc) && get_dist(BS, T) <= 35)
			BS.LoseTarget()
			BS.Goto(pick(surrounding_turfs), BS.move_to_delay)

/mob/camera/blob/verb/blob_broadcast()
	set category = "Blob"
	set name = "Grzybowa Transmisja"
	set desc = "Powiedz coś ustami swoich zarodników oraz grzybonautów."
	var/speak_text = capped_input(src, "Co chciałbyś powiedzieć za pomocą swoich sługusów?", "Grzybowa Transmisja")
	if(!speak_text)
		return
	else
		to_chat(src, "Mówisz za pomocą swoich sług, <B>[speak_text]</B>")
	for(var/BLO in blob_mobs)
		var/mob/living/simple_animal/hostile/blob/BM = BLO
		if(BM.stat == CONSCIOUS)
			BM.say(speak_text)

/mob/camera/blob/verb/strain_reroll()
	set category = "Blob"
	set name = "Zmiana Odmiany (40)"
	set desc = "Zmienia twoją odmianę na inną, wybraną losowo."

	if (!free_strain_rerolls && blob_points < BLOB_REROLL_COST)
		to_chat(src, "<span class='warning'>Potrzebujesz przynajmniej [BLOB_REROLL_COST] zasobów by znów przelosować odmianę!</span>")
		return

	open_reroll_menu()

/// Open the menu to reroll strains
/mob/camera/blob/proc/open_reroll_menu()
	if (!strain_choices)
		strain_choices = list()

		var/list/new_strains = GLOB.valid_blobstrains.Copy()
		for (var/_ in 1 to BLOB_REROLL_CHOICES)
			var/datum/blobstrain/strain = pick_n_take(new_strains)

			var/image/strain_icon = image('icons/mob/blob.dmi', "blob_core")
			strain_icon.color = initial(strain.color)

			var/info_text = "<span class='boldnotice'>[initial(strain.name)]</span>"
			info_text += "<br><span class='notice'>[initial(strain.analyzerdescdamage)]</span>"
			if (!isnull(initial(strain.analyzerdesceffect)))
				info_text += "<br><span class='notice'>[initial(strain.analyzerdesceffect)]</span>"

			var/datum/radial_menu_choice/choice = new
			choice.image = strain_icon
			choice.info = info_text

			strain_choices[initial(strain.name)] = choice

	var/strain_result = show_radial_menu(src, src, strain_choices, radius = BLOB_REROLL_RADIUS, tooltips = TRUE)
	if (isnull(strain_result))
		return

	if (!free_strain_rerolls && !can_buy(BLOB_REROLL_COST))
		return

	for (var/_other_strain in GLOB.valid_blobstrains)
		var/datum/blobstrain/other_strain = _other_strain
		if (initial(other_strain.name) == strain_result)
			set_strain(other_strain)

			if (free_strain_rerolls)
				free_strain_rerolls -= 1

			last_reroll_time = world.time

			return

/mob/camera/blob/verb/blob_help()
	set category = "Blob"
	set name = "*Pomoc*"
	set desc = "Pomoc jak grać grzybem."
	to_chat(src, "<b>Jesteś Grzybogiem!</b>")
	to_chat(src, "Twoja odmiana to: <b><font color=\"[blobstrain.color]\">[blobstrain.name]</b></font>!")
	to_chat(src, "Jako <b><font color=\"[blobstrain.color]\">[blobstrain.name]</b></font> [blobstrain.description]")
	if(blobstrain.effectdesc)
		to_chat(src, "Co więcej, jako <b><font color=\"[blobstrain.color]\">[blobstrain.name]</b></font> [blobstrain.effectdesc]")
	to_chat(src, "<b>Rozrastasz się, klikając na kafelki. Jeżeli coś znajduje się na twojej drodze, zostanie zaatakowane, a jeżeli kafelek jest pusty, wyhodujesz Zwykłego Grzyba.</b>")
	to_chat(src, "<i>Zwykłe Grzyby</i> zwiększają zasięg twojej kolonii oraz mogą zostać ulepszone, by pełniły poszczególne funkcje.")
	to_chat(src, "<b>Możesz ulepszać zwykłe grzyby w następujące typy:</b>")
	to_chat(src, "<i>Gęste Grzyby</i> są silniejsze i mogą przyjąć większą ilość obrażeń. Dodatkowo są ognioodporne i blokują atmosferę, są bardzo pomocne przy pożarach. Ulepszenie Gęstego Grzyba jeszcze raz stworzy Grzyba Lustrzanego, którego umiejętnością jest obijanie większości pocisków kosztem niskiej wytrzymałości.")
	to_chat(src, "<i>Owocniki</i> są typem grzyba, które produkują dla ciebie zasoby. Postaraj się budować je w dużych ilościach, by zaspokoić twój zapas zasobów. Ten typ grzyba musi znajdować się w okolicy rdzenia lub węzła, by działać poprawnie.")
	to_chat(src, "<i>Zarodnie</i> są typem grzyba, które produkują zarodniki, które na bierząco atakują przeciwników w okolicy. Ten typ grzyba musi znajdować się w okolicy rdzenia lub węzła, by działać poprawnie.")
	to_chat(src, "<i>Grzybonauci</i> mogą zostać wyhodowani z zarodni kosztem zasobów. Są oni silni i trudni w zabiciu oraz umiarkowanie inteligentni. Zarodnia, która została wykorzystana do wytworzenia grzybonauty, zostanie osłabiona oraz przez jakiś czas nie będzie w stanie wytwarzać zarodników.")
	to_chat(src, "<i>Węzły</i> są typem grzyba, które automatycznie się rozrastają tak jak twój rdzeń. Również tak jak rdzeń, aktywują one twoje zarodnie oraz owocniki.")
	to_chat(src, "<b>Dodatkowo poza przyciskami na twoim HUD, istnieje kilka skrótów klawiszowych ułatwiających obronę oraz ekspansję..</b>")
	to_chat(src, "<b>Skróty Klawiszowe:</b> Kliknięcie = Rozrost <b>|</b> Kliknięcie Kółkiem Myszki = Zwołanie Zarodników <b>|</b> Ctrl Klik = Stworzenie Gęstego Grzyba <b>|</b> Alt Klik = Usunięcie Grzyba")
	to_chat(src, "Próba mówienia wyśle wiadomość do wszystkich grzybonautów oraz innych grzybów, pozwalając ci na koordynację z nimi.")
	if(!placed && autoplace_max_time <= world.time)
		to_chat(src, "<span class='big'><font color=\"#EE4000\">Twój rdzeń zostanie automatycznie postawiony za: [DisplayTimeText(autoplace_max_time - world.time)].</font></span>")
		to_chat(src, "<span class='big'><font color=\"#EE4000\">[manualplace_min_time ? "Będziesz mógł":"Możesz"] postawić swój rdzeń ręcznie, klikając ikonę 'Postaw Rdzeń' znajdującą się w prawym dolnym rogu ekranu.</font></span>")

#undef BLOB_REROLL_CHOICES
#undef BLOB_REROLL_RADIUS
