// 5.56mm (M-90gl Carbine)

/obj/item/projectile/bullet/a556
	name = "5.56mm bullet"
	damage = 35

// 7.62 (Nagant Rifle)

/obj/item/projectile/bullet/a762
	name = "7.62mm bullet"
	speed = 0.75
	damage = 35
	armour_penetration = 5

/obj/item/projectile/bullet/a762/nl
	name = "7.62mm rubber bullet"
	stamina = 40
	damage = 5
	armour_penetration = 0
	icon_state = "bulletnl"
	hitsound = 'sound/weapons/rubberhit.ogg'

/obj/item/projectile/bullet/a762/sabot
	name = "7.62mm sabot shell"
	speed = 0.5
	damage = 20
	armour_penetration = 15
	icon_state = "bulletfastlc"

/obj/item/projectile/bullet/a762_enchanted
	name = "enchanted 7.62 bullet"
	damage = 20
	stamina = 80

//pulse raifu projectile //

/obj/item/projectile/bullet/peacekeeper
	name = "6mm tungsten round"
	damage = 15
	armour_penetration = 60
