//Mech zrobiony ze smieci. Inspirowany locker mechem z Yogstation oraz Hippiestation. Autor pieknych spritow: Toddout (pipi popo #6667 na dc)
/obj/mecha/working/lockermech
	desc = "A locker with stolen wires, struts, electronics and airlock servos crudely assembled into something that resembles the functions of a exosuit."
	name = "\improper GR-3YT1.DE Locker Exosuit"
	icon_state = "lockermech"
	step_in = 4 //Predkosc Ripleya
	max_integrity = 100 //Zrobiony ze zlomu
	deflect_chance = 0
	lights_power = 5
	armor = list("melee" = 20, "bullet" = 10, "laser" = 10, "energy" = 0, "bomb" = 10, "bio" = 0, "rad" = 0, "fire" = 70, "acid" = 60)
	max_equip = 2
	wreckage = null //Mech doslownie ledwo sie trzyma, po zniszczeniu rozpada sie na kawalki
	internals_req_access = null //Smieciowa elektronika nie posiada zabezpieczeń
	enter_delay = 60 //Zrobiony ze zlomu, nie posiada wygodnego wejscia/wyjscia
	exit_delay = 30 //Wchodzi/wychodzi sie z niego 50% dluzej 
	cargo_capacity = 5 //Szafka jest malo pojemna
	stepsound = 'sound/mecha/scrapstep.ogg'

//Kod ukradziony z Ripleya. Odpowiada za obsluge cargo i clampow
/obj/mecha/working/lockermech/Exit(atom/movable/O)
	if(O in cargo)
		return 0
	return ..()

/obj/mecha/working/lockermech/Topic(href, href_list)
	..()
	if(href_list["drop_from_cargo"])
		var/obj/O = locate(href_list["drop_from_cargo"]) in cargo
		if(O)
			occupant_message("<span class='notice'>You unload [O].</span>")
			O.forceMove(drop_location())
			cargo -= O
			log_message("Unloaded [O]. Cargo compartment capacity: [cargo_capacity - src.cargo.len]", LOG_MECHA)
	return

/obj/mecha/working/lockermech/contents_explosion(severity, target)
	for(var/X in cargo)
		var/obj/O = X
		if(prob(30/severity))
			cargo -= O
			O.forceMove(drop_location())
	. = ..()

/obj/mecha/working/lockermech/get_stats_part()
	var/output = ..()
	output += "<b>Cargo Compartment Contents:</b><div style=\"margin-left: 15px;\">"
	if(cargo.len)
		for(var/obj/O in cargo)
			output += "<a href='?src=[REF(src)];drop_from_cargo=[REF(O)]'>Unload</a> : [O]<br>"
	else
		output += "Nothing"
	output += "</div>"
	return output

/obj/mecha/working/lockermech/relay_container_resist(mob/living/user, obj/O)
	to_chat(user, "<span class='notice'>You lean on the back of [O] and start pushing so it falls out of [src].</span>")
	if(do_after(user, 300, target = O))
		if(!user || user.stat != CONSCIOUS || user.loc != src || O.loc != src )
			return
		to_chat(user, "<span class='notice'>You successfully pushed [O] out of [src]!</span>")
		O.forceMove(drop_location())
		cargo -= O
	else
		if(user.loc == src) //so we don't get the message if we resisted multiple times and succeeded.
			to_chat(user, "<span class='warning'>You fail to push [O] out of [src]!</span>")
//Nie spodziewalem sie ze to zadziala -b4cku

//Narzedzia szafkomecha
//-smieciowe wiertło
//-smieciowy podnosnik
//-smieciowa laserowa bron
/obj/item/mecha_parts/mecha_equipment/drill/makeshift
	name = "makeshift exosuit drill"
	desc = "Cobbled together from likely stolen parts, this drill is nowhere near as effective as the real deal."
	icon_state = "scrap_drill"
	equip_cooldown = 45 //W chuj powolne
	force = 10 //I stosunkowo slabe
	toolspeed = 1.2 //Oraz mniej precyzyjne
	drill_delay = 15

/obj/item/mecha_parts/mecha_equipment/drill/makeshift/can_attach(obj/mecha/M as obj)
	if(istype(M, /obj/mecha/working/lockermech))
		return TRUE
	return FALSE

/obj/item/mecha_parts/mecha_equipment/hydraulic_clamp/makeshift
	name = "makeshift hydraulic clamp"
	desc = "Loose arrangement of cobbled together bits resembling a clamp."
	icon_state = "scrap_clamp"
	equip_cooldown = 25
	toolspeed = 1.2
	dam_force = 10

/obj/item/mecha_parts/mecha_equipment/hydraulic_clamp/makeshift/can_attach(obj/mecha/M as obj)
	if(istype(M, /obj/mecha/working/lockermech))
		return TRUE
	return FALSE

/obj/item/mecha_parts/mecha_equipment/weapon/energy/makeshift
	name = "makeshift exosuit laser rifle"
	desc = "Makeshift laser rifle attached to a makeshift exosuit equipment mount. Lacks factory precision, so the damage may be inconsistent."
	icon_state = "scrap_laser"
	equip_cooldown = 15
	energy_drain = 45
	projectile = /obj/item/projectile/beam/laser/makeshiftlasrifle
	fire_sound = 'sound/weapons/laser.ogg'
	harmful = TRUE

/obj/item/mecha_parts/mecha_equipment/weapon/energy/makeshift/can_attach(obj/mecha/M as obj)
	if(istype(M, /obj/mecha/working/lockermech))
		return TRUE
	return FALSE
