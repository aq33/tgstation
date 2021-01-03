/obj/item/ammo_box/a357
	name = "speed loader (.357)"
	desc = "Designed to quickly reload revolvers."
	icon_state = "357"
	ammo_type = /obj/item/ammo_casing/a357
	max_ammo = 7
	multiple_sprites = 1

/obj/item/ammo_box/c38
	name = "speed loader (.38)"
	desc = "Designed to quickly reload revolvers."
	icon_state = "38"
	ammo_type = /obj/item/ammo_casing/c38
	max_ammo = 6
	multiple_sprites = 1
	materials = list(/datum/material/iron = 20000)

/obj/item/ammo_box/c38/trac
	name = "speed loader (.38 TRAC)"
	desc = "Designed to quickly reload revolvers. TRAC bullets embed a tracking implant within the target's body."
	ammo_type = /obj/item/ammo_casing/c38/trac

/obj/item/ammo_box/c38/hotshot
	name = "speed loader (.38 Hot Shot)"
	desc = "Designed to quickly reload revolvers. Hot Shot bullets contain an incendiary payload."
	ammo_type = /obj/item/ammo_casing/c38/hotshot

/obj/item/ammo_box/c38/iceblox
	name = "speed loader (.38 Iceblox)"
	desc = "Designed to quickly reload revolvers. Iceblox bullets contain a cryogenic payload."
	ammo_type = /obj/item/ammo_casing/c38/iceblox

/obj/item/ammo_box/c38/mime
	name = "speed loader (.38 finger)"
	max_ammo = 6
	desc = "Designed to quickly reload your fingers with lethal rounds."
	item_flags = DROPDEL
	ammo_type = /obj/item/ammo_casing/caseless/mime/lethals

/obj/item/ammo_box/c9mm
	name = "ammo box (9mm)"
	icon_state = "9mmbox"
	ammo_type = /obj/item/ammo_casing/c9mm
	max_ammo = 20
	w_class = WEIGHT_CLASS_BULKY
	multiple_sprites = 2

/obj/item/ammo_box/c9mm/nl
	name = "rubber ammo box (9mm)"
	icon_state = "9mmnlbox"
	ammo_type = /obj/item/ammo_casing/c9mm/nl

/obj/item/ammo_box/c10mm
	name = "ammo box (10mm)"
	icon_state = "10mmbox"
	ammo_type = /obj/item/ammo_casing/c10mm
	max_ammo = 20

/obj/item/ammo_box/c45
	name = "ammo box (.45)"
	icon_state = "45box"
	ammo_type = /obj/item/ammo_casing/c45
	max_ammo = 20

/obj/item/ammo_box/c46x30mm
	name = "ammo box (4.6x30mm)"
	icon_state = "wtbox"
	ammo_type = /obj/item/ammo_casing/c46x30mm
	max_ammo = 40
	w_class = WEIGHT_CLASS_BULKY
	multiple_sprites = 2

/obj/item/ammo_box/c46x30mm/nl
	name = "rubber ammo box (4.6x30mm)"
	icon_state = "wtboxnl"
	ammo_type = /obj/item/ammo_casing/c46x30mm/nl

/obj/item/ammo_box/a40mm
	name = "ammo box (40mm grenades)"
	icon_state = "40mm"
	ammo_type = /obj/item/ammo_casing/a40mm
	max_ammo = 4
	multiple_sprites = 1

/obj/item/ammo_box/a762
	name = "stripper clip (7.62mm)"
	desc = "A stripper clip."
	icon_state = "762"
	ammo_type = /obj/item/ammo_casing/a762
	max_ammo = 5
	multiple_sprites = 1

/obj/item/ammo_box/a762/box
	name = "ammo box (7.62mm)"
	desc = "Big box of 7.62mm rounds."
	icon_state = "762box"
	ammo_type = /obj/item/ammo_casing/a762
	max_ammo = 20
	w_class = WEIGHT_CLASS_BULKY
	multiple_sprites = 2

/obj/item/ammo_box/a762/box/nl
	name = "rubber ammo box (7.62mm)"
	desc = "Big box of mostly non-lethal 7.62mm rounds."
	icon_state = "762nlbox"
	ammo_type = /obj/item/ammo_casing/a762/nl

/obj/item/ammo_box/n762
	name = "ammo box (7.62x38mmR)"
	icon_state = "10mmbox"
	ammo_type = /obj/item/ammo_casing/n762
	max_ammo = 14

/obj/item/ammo_box/foambox
	name = "granat na kulki"
	icon = 'icons/obj/guns/toy.dmi'
	icon_state = "foambox"
	ammo_type = /obj/item/ammo_casing/caseless/foam_dart
	max_ammo = 40
	multiple_sprites = 3
	materials = list(/datum/material/iron = 500)
	custom_price = 50

/obj/item/ammo_box/foambox/riot
	name = "granat na metalowe kulki"
	icon_state = "foambox_riot"
	ammo_type = /obj/item/ammo_casing/caseless/foam_dart/riot
	materials = list(/datum/material/iron = 50000)

// pulse raifu ammo boxes //

/obj/item/ammo_box/peacekeeper/lethal
	name = "M2A45 pulse rifle ammo box (lethal)"
	icon_state = "PDC"
	ammo_type = /obj/item/ammo_casing/peacekeeper/lethal
	caliber = "6mm"
	max_ammo = 60
