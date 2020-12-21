// .45 (M1911 & C20r)

/obj/item/projectile/bullet/c45
	name = ".45 bullet"
	damage = 30

// 4.6x30mm (Autorifles)

/obj/item/projectile/bullet/c46x30mm
	name = "4.6x30mm bullet"
	damage = 20
	armour_penetration = -10
	icon_state = "bulletlc"
	range = 30

/obj/item/projectile/bullet/c46x30mm_ap
	name = "4.6x30mm armor-piercing bullet"
	damage = 15
	armour_penetration = 40
	icon_state = "bulletlc"
	range = 30
/obj/item/projectile/bullet/incendiary/c46x30mm
	name = "4.6x30mm incendiary bullet"
	damage = 10
	fire_stacks = 1
	icon_state = "bulletlc"

/obj/item/projectile/bullet/c46x30mm_nl
	name = "4.6x30mm rubber bullet"
	stamina = 25
	damage = 3
	armour_penetration = -10
	icon_state = "bulletnllc"
	range = 30
	hitsound = 'sound/weapons/rubberhit.ogg'
