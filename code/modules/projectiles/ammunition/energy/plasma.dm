/obj/item/ammo_casing/energy/plasma
	projectile_type = /obj/item/projectile/plasma
	select_name = "plasma burst"
	fire_sound = 'sound/weapons/plasma_cutter.ogg'
	delay = 15
	e_cost = 25

/obj/item/ammo_casing/energy/plasma/adv
	projectile_type = /obj/item/projectile/plasma/adv
	delay = 10
	e_cost = 10

/obj/item/ammo_casing/energy/plasma/gun
	projectile_type = /obj/item/projectile/energy/plasma/plasmagun
	icon_state = "plasma3"
	fire_sound = 'sound/weapons/blaster.ogg'
	delay = 5
	e_cost = 2000
	light_color = LIGHT_COLOR_GREEN

/obj/item/ammo_casing/energy/plasma/gun/scatter
	projectile_type = /obj/item/projectile/energy/plasma/scatter
	icon_state = "plasma1"
	pellets = 3
	variance = 30
	e_cost = 2500

/obj/item/ammo_casing/energy/plasma/gun/pistol
	projectile_type = /obj/item/projectile/energy/plasma/pistol
	e_cost = 1500
	icon_state = "plasma2"
