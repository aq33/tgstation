/obj/item/ammo_box/magazine/m10mm/rifle
	name = "rifle magazine (10mm)"
	desc = "A well-worn magazine fitted for the surplus rifle."
	icon_state = "75"
	ammo_type = /obj/item/ammo_casing/c10mm
	caliber = "10mm"
	max_ammo = 10

/obj/item/ammo_box/magazine/m10mm/update_icon()
	..()
	if(ammo_count())
		icon_state = "[initial(icon_state)]-1"
	else
		icon_state = "[initial(icon_state)]-0"
/obj/item/ammo_box/magazine/m556
	name = "toploader magazine (5.56mm)"
	icon_state = "5.56m"
	ammo_type = /obj/item/ammo_casing/a556
	caliber = "a556"
	max_ammo = 30
	multiple_sprites = 2

/obj/item/ammo_box/magazine/a762/mag
	name = "riot rifle magazine (7.62mm)"
	desc = "Standard rifle magazine for 7.62mm rounds."
	ammo_type = /obj/item/ammo_casing/a762
	icon_state = "762mmmag"
	caliber = "a762"
	max_ammo = 10

/obj/item/ammo_box/magazine/a762/mag/dry
	start_empty = TRUE

/obj/item/ammo_box/magazine/a762/mag/nl
	name = "rifle magazine NL (7.62mm)"
	desc = "Standard rifle magazine for 7.62mm rounds. Pre-loaded with non-lethal rubber shells."
	ammo_type = /obj/item/ammo_casing/a762/nl
	icon_state = "762mmmagnl"

/obj/item/ammo_box/magazine/a762/mag/sabot
	name = "rifle magazine (7.62mm)"
	desc = "Standard rifle magazine for 7.62mm rounds. Pre-loaded with high-velocity sabot shells."
	ammo_type = /obj/item/ammo_casing/a762/sabot

/obj/item/ammo_box/magazine/a762/mag/update_icon()
	..()
	if(ammo_count())
		icon_state = "[initial(icon_state)]-1"
	else
		icon_state = "[initial(icon_state)]-0"

// pulse raifu mags //

/obj/item/ammo_box/magazine/peacekeeper/lethal
	name = "M2A45 pulse rifle magazine"
	icon_state = "peacekeeper"
	ammo_type = /obj/item/ammo_casing/peacekeeper/lethal
	caliber = "6mm"
	max_ammo = 30

/obj/item/ammo_box/magazine/peacekeeper/update_icon()
	..()
	if(ammo_count() > 0)
		icon_state = "[initial(icon_state)]-30"
	else
		icon_state = "[initial(icon_state)]-0"
