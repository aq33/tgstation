/obj/item/mecha_ammo
	name = "generic ammo box"
	desc = "A box of ammo for an unknown weapon."
	w_class = WEIGHT_CLASS_BULKY
	icon = 'icons/mecha/mecha_ammo.dmi'
	icon_state = "empty"
	lefthand_file = 'icons/mob/inhands/equipment/medical_lefthand.dmi'
	righthand_file = 'icons/mob/inhands/equipment/medical_righthand.dmi'
	var/rounds = 0
	var/round_term = "round"
	var/direct_load //For weapons where we re-load the weapon itself rather than adding to the ammo storage.
	var/load_audio = "sound/weapons/gun_magazine_insert_empty_1.ogg"
	var/ammo_type

/obj/item/mecha_ammo/proc/update_name()
	if(!rounds)
		name = "empty ammo box"
		desc = "An exosuit ammuniton box that has since been emptied. Please recycle."
		icon_state = "empty"

/obj/item/mecha_ammo/attack_self(mob/user)
	..()
	if(rounds)
		to_chat(user, "<span class='warning'>You cannot flatten the ammo box until it's empty!</span>")
		return

	to_chat(user, "<span class='notice'>You fold [src] flat.</span>")
	var/I = new /obj/item/stack/sheet/iron(user.loc)
	qdel(src)
	user.put_in_hands(I)

/obj/item/mecha_ammo/examine(mob/user)
	. = ..()
	if(rounds)
		. += "There [rounds > 1?"are":"is"] [rounds] [round_term][rounds > 1?"s":""] left."

/obj/item/mecha_ammo/incendiary
	name = "incendiary ammo"
	desc = "A box of incendiary ammunition for use with exosuit weapons."
	icon_state = "incendiary"
	rounds = 20
	ammo_type = "incendiary"

/obj/item/mecha_ammo/scattershot
	name = "scattershot ammo"
	desc = "A box of scaled-up buckshot, for use in exosuit shotguns."
	icon_state = "scattershot"
	rounds = 25
	ammo_type = "scattershot"

/obj/item/mecha_ammo/lmg
	name = "machine gun ammo"
	desc = "A box of linked ammunition, designed for the Ultra AC 2 exosuit weapon."
	icon_state = "lmg"
	rounds = 50
	ammo_type = "lmg"

/obj/item/mecha_ammo/nl
	name = "non-lethal ammo"
	desc = "A box of non-lethal rubber bullets."
	icon_state = "nl"
	rounds = 100
	ammo_type = "nl"

/obj/item/mecha_ammo/missiles_he
	name = "anti-armor missiles"
	desc = "A box of large missiles, ready for loading into an HEML-3 exosuit missile rack."
	icon_state = "missile_he"
	rounds = 3
	round_term = "missile"
	direct_load = TRUE
	load_audio = "sound/weapons/bulletinsert.ogg"
	ammo_type = "missiles_he"

/obj/item/mecha_ammo/railgun
	name = "Railgun Rods"
	desc = "A box of dense metal rods suited for GER-X1 railgun"
	icon_state = "railgun"
	rounds = 10
	round_term = "rod"
	ammo_type = "railgun"

/obj/item/mecha_ammo/flashbang
	name = "launchable flashbangs"
	desc = "A box of smooth flashbangs, for use with a large exosuit launcher. Cannot be primed by hand."
	icon_state = "flashbang"
	rounds = 6
	round_term = "grenade"
	ammo_type = "flashbang"

/obj/item/mecha_ammo/clusterbang
	name = "launchable flashbang clusters"
	desc = "A box of clustered flashbangs, for use with a specialized exosuit cluster launcher. Cannot be primed by hand."
	icon_state = "clusterbang"
	rounds = 3
	round_term = "cluster"
	direct_load = TRUE
	ammo_type = "clusterbang"
