/obj/item/ammo_box/magazine/m10mm/rifle
	name = "rifle magazine (10mm)"
	desc = "A well-worn magazine fitted for the surplus rifle."
	icon_state = "75"
	ammo_type = /obj/item/ammo_casing/c10mm
	caliber = "10mm"
	max_ammo = 10

/obj/item/ammo_box/magazine/m556
	name = "toploader magazine (5.56mm)"
	icon_state = "5.56m"
	ammo_type = /obj/item/ammo_casing/a556
	caliber = "a556"
	max_ammo = 30
	multiple_sprites = 2

/obj/item/ammo_box/magazine/m10mm/box
	name = "rifle box (10mm)"
	desc = "Standard rifle magazine for 10mm rounds."
	icon_state = "10mmbox"
	max_ammo = 12

/obj/item/ammo_box/magazine/m10mm/update_icon()
	..()
	if(ammo_count())
		icon_state = "[icon_state]-1"
	else
		icon_state = "[icon_state]-0"

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
