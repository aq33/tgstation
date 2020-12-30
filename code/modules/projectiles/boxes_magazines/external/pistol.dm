/obj/item/ammo_box/magazine/m10mm
	name = "pistol magazine (10mm)"
	desc = "A gun magazine."
	icon_state = "9x19p"
	ammo_type = /obj/item/ammo_casing/c10mm
	caliber = "10mm"
	max_ammo = 8
	multiple_sprites = 2

/obj/item/ammo_box/magazine/m10mm/fire
	name = "pistol magazine (10mm incendiary)"
	icon_state = "9x19pI"
	desc = "A gun magazine. Loaded with rounds which ignite the target."
	ammo_type = /obj/item/ammo_casing/c10mm/fire

/obj/item/ammo_box/magazine/m10mm/hp
	name = "pistol magazine (10mm HP)"
	icon_state = "9x19pH"
	desc= "A gun magazine. Loaded with hollow-point rounds, extremely effective against unarmored targets, but nearly useless against protective clothing."
	ammo_type = /obj/item/ammo_casing/c10mm/hp

/obj/item/ammo_box/magazine/m10mm/ap
	name = "pistol magazine (10mm AP)"
	icon_state = "9x19pA"
	desc= "A gun magazine. Loaded with rounds which penetrate armour, but are less effective against normal targets."
	ammo_type = /obj/item/ammo_casing/c10mm/ap

/obj/item/ammo_box/magazine/m10mm/update_icon()
	..()
	icon_state = "9x19p-[ammo_count() ? "8" : "0"]"

/obj/item/ammo_box/magazine/m45
	name = "handgun magazine (.45)"
	icon_state = "45-8"
	ammo_type = /obj/item/ammo_casing/c45
	caliber = ".45"
	max_ammo = 8

/obj/item/ammo_box/magazine/m45/update_icon()
	..()
	if (ammo_count() >= 8)
		icon_state = "45-8"
	else
		icon_state = "45-[ammo_count()]"

/obj/item/ammo_box/magazine/pistolm9mm
	name = "pistol magazine (9mm)"
	icon_state = "9x19p-8"
	ammo_type = /obj/item/ammo_casing/c9mm
	caliber = "9mm"
	max_ammo = 15

/obj/item/ammo_box/magazine/pistolm9mm/update_icon()
	..()
	icon_state = "9x19p-[ammo_count() ? "8" : "0"]"

//Security Pistol

/obj/item/ammo_box/magazine/sec9mm
	name = "security pistol magazine (9mm)"
	icon_state = "sec9mmstd"
	ammo_type = /obj/item/ammo_casing/c9mm
	caliber = "9mm"
	max_ammo = 10

/obj/item/ammo_box/magazine/sec9mm/dry
	start_empty = TRUE

/obj/item/ammo_box/magazine/sec9mm/nl
	name = "security pistol magazine (9mm non-lethal)"
	icon_state = "sec9mmstdnl"
	ammo_type = /obj/item/ammo_casing/c9mm/nl
	caliber = "9mm"

/obj/item/ammo_box/magazine/sec9mm/ext
	name = "security pistol magazine (9mm extended)"
	icon_state = "sec9mmext"
	ammo_type = /obj/item/ammo_casing/c9mm
	caliber = "9mm"
	max_ammo = 18
	w_class = WEIGHT_CLASS_SMALL

/obj/item/ammo_box/magazine/sec9mm/ext/dry
	start_empty = TRUE

/obj/item/ammo_box/magazine/sec9mm/update_icon()
	icon_state = "[initial(icon_state)]-[ammo_count() ? "1" : "0"]"

/obj/item/ammo_box/magazine/m50
	name = "handgun magazine (.50ae)"
	icon_state = "50ae"
	ammo_type = /obj/item/ammo_casing/a50AE
	caliber = ".50"
	max_ammo = 7
	multiple_sprites = 1

/obj/item/ammo_box/magazine/m9mm_mkshft
	name = "makeshift pistol magazine (9mm)"
	icon_state = "9x19mks-6"
	desc= "A makeshift pistol mag, made out of spare parts. Doesn't look too reliable."
	ammo_type = /obj/item/ammo_casing/c9mm
	caliber = "9mm"
	max_ammo = 6
	start_empty = TRUE

/obj/item/ammo_box/magazine/m9mm_mkshft/update_icon()
	..()
	icon_state = "9x19mks-[ammo_count() ? "6" : "0"]"

/obj/item/ammo_box/magazine/m9mm_mkshft/TEC10
	name = "makeshift pistol magazine (9mm)"
	icon_state = "tec10"
	desc= "Modifed makeshift pistol mag, made out of spare parts, looks quite crude."
	ammo_type = /obj/item/ammo_casing/c9mm
	caliber = "9mm"
	max_ammo = 15
	start_empty = TRUE

/obj/item/ammo_box/magazine/m9mm_mkshft/TEC10/update_icon()
	..()
	icon_state = "tec10-[ammo_count() ? "15" : "0"]"
