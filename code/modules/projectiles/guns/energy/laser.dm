/obj/item/gun/energy/laser
	name = "laser gun"
	desc = "A basic energy-based laser gun that fires concentrated beams of light which pass through glass and thin metal."
	icon_state = "lasergun2"
	item_state = "lasergun2"
	block_upgrade_walk = 1
	w_class = WEIGHT_CLASS_NORMAL
	materials = list(/datum/material/iron=2000)
	ammo_type = list(/obj/item/ammo_casing/energy/lasergun)
	ammo_x_offset = 1
	shaded_charge = 1

/obj/item/gun/energy/laser/laserrifle
	name = "laser rifle."
	desc = "Laser gun's bigger brother, military grade beam based weapon that sacrafices stopping power for suppresing fire. Its quite bulky."
	icon_state = "laser-rifle"
	item_state = "laser-rifle"
	ammo_type = list(/obj/item/ammo_casing/energy/lasergun/laserrifle)
	weapon_weight = WEAPON_HEAVY
	slot_flags = null
	w_class = WEIGHT_CLASS_BULKY
	automatic = 1
	fire_delay = 0.5

/obj/item/gun/energy/laser/lgun
	icon_state = "lasergun2"
	item_state = "lasergun2"
	pin = null

/obj/item/gun/energy/laser/fo13
	icon_state = "laser"
	item_state = "laser"

/obj/item/gun/energy/laser/pistol
	name = "laser pistol"
	desc = "Though sometimes mocked for the relatively weak firepower of their energy weapons, the logistic miracle of rechargeable ammunition has given Nanotrasen a decisive edge over many a foe."
	icon_state = "laser-pistol2"
	item_state = "laser-pistol2"
	ammo_type = list (/obj/item/ammo_casing/energy/lasergun/pistol)
	pin = null

/obj/item/gun/energy/laser/pistol/fo13
	icon_state = "AEP7"
	item_state = "laser-pistol"

/obj/item/gun/energy/laser/pistol/secpeestol
	name = "security laser pistol"
	desc = "Standard-issue high-power laser pointer to fight off dangerous pests such like rats, space carp and moths. Still better than nothing."
	pin = /obj/item/firing_pin

/obj/item/gun/energy/laser/tribeam
	name = "tri-beam laser gun"
	desc = "Modified laser gun that fires concentrated beams of light that split into three beams which can pass through glass and thin metal."
	icon_state = "lasertri2"
	item_state = "lasertri2"
	ammo_type = list(/obj/item/ammo_casing/energy/lasergun/tri)
	pin = null

/obj/item/gun/energy/laser/tribeam/fo13
	icon_state = "lasertri"
	item_state = "lasertri"

/obj/item/gun/energy/laser/practice
	name = "practice laser gun"
	desc = "A modified version of the basic laser gun, this one fires less concentrated energy bolts designed for target practice."
	ammo_type = list(/obj/item/ammo_casing/energy/laser/practice)
	clumsy_check = 0
	item_flags = NONE

/obj/item/gun/energy/laser/retro
	name ="retro laser gun"
	icon_state = "retro"
	desc = "An older model of the basic lasergun, no longer used by Nanotrasen's private security or military forces. Nevertheless, it is still quite deadly and easy to maintain, making it a favorite amongst pirates and other outlaws."
	ammo_x_offset = 3

/obj/item/gun/energy/laser/retro/old
	name ="laser gun"
	icon_state = "retro"
	desc = "First generation lasergun, developed by Nanotrasen. Suffers from ammo issues but its unique ability to recharge its ammo without the need of a magazine helps compensate. You really hope someone has developed a better lasergun while you were in cryo."
	ammo_type = list(/obj/item/ammo_casing/energy/lasergun/old)
	ammo_x_offset = 3

/obj/item/gun/energy/laser/captain
	name = "antique laser gun"
	icon_state = "caplaser"
	item_state = "caplaser"
	desc = "This is an antique laser gun. All craftsmanship is of the highest quality. It is decorated with assistant leather and chrome. The object menaces with spikes of energy. On the item is an image of Space Station 13. The station is exploding."
	force = 10
	ammo_x_offset = 3
	selfcharge = 1
	internal_cell = TRUE // uses a self-recharging cell which shouldn't be used in other places
	cell_type = /obj/item/stock_parts/cell/gun/self_recharging
	resistance_flags = INDESTRUCTIBLE | LAVA_PROOF | FIRE_PROOF | ACID_PROOF
	weapon_weight = WEAPON_LIGHT

/obj/item/gun/energy/laser/captain/scattershot
	name = "scatter shot laser rifle"
	icon_state = "lasercannon"
	item_state = "laser"
	desc = "An industrial-grade heavy-duty laser rifle with a modified laser lens to scatter its shot into multiple smaller lasers. The inner-core can self-charge for theoretically infinite use."
	ammo_type = list(/obj/item/ammo_casing/energy/laser/scatter, /obj/item/ammo_casing/energy/laser)

/obj/item/gun/energy/laser/cyborg
	can_charge = FALSE
	desc = "An energy-based laser gun that draws power from the cyborg's internal energy cell directly. So this is what freedom looks like?"
	use_cyborg_cell = TRUE

/obj/item/gun/energy/laser/cyborg/emp_act()
	return

/obj/item/gun/energy/laser/scatter
	name = "scatter laser gun"
	desc = "A laser gun equipped with a refraction kit that spreads bolts."
	ammo_type = list(/obj/item/ammo_casing/energy/laser/scatter, /obj/item/ammo_casing/energy/laser)

/obj/item/gun/energy/laser/scatter/shotty
	name = "energy shotgun"
	icon = 'icons/obj/guns/projectile.dmi'
	icon_state = "cshotgun"
	item_state = "shotgun"
	desc = "A combat shotgun gutted and refitted with an internal laser system. Can switch between taser and scattered disabler shots."
	shaded_charge = 0
	pin = /obj/item/firing_pin/implant/mindshield
	ammo_type = list(/obj/item/ammo_casing/energy/laser/scatter/disabler, /obj/item/ammo_casing/energy/electrode)

///Laser Cannon

/obj/item/gun/energy/lasercannon
	name = "accelerator laser cannon"
	desc = "An advanced laser cannon that does more damage the farther away the target is."
	icon_state = "lasercannon"
	item_state = "lasercannon"
	w_class = WEIGHT_CLASS_BULKY
	force = 10
	flags_1 =  CONDUCT_1
	slot_flags = ITEM_SLOT_BACK
	ammo_type = list(/obj/item/ammo_casing/energy/laser/accelerator)
	pin = null
	ammo_x_offset = 1
	weapon_weight = WEAPON_HEAVY

/obj/item/ammo_casing/energy/laser/accelerator
	projectile_type = /obj/item/projectile/beam/laser/accelerator
	select_name = "accelerator"
	fire_sound = 'sound/weapons/lasercannonfire.ogg'

/obj/item/projectile/beam/laser/accelerator
	name = "accelerator laser"
	icon_state = "scatterlaser"
	range = 255
	damage = 6

/obj/item/projectile/beam/laser/accelerator/Range()
	..()
	damage += 7
	transform *= 1 + ((damage/7) * 0.2)//20% larger per tile

/obj/item/gun/energy/xray
	name = "\improper X-ray laser gun"
	desc = "A high-power laser gun capable of expelling concentrated X-ray blasts that pass through multiple soft targets and heavier materials."
	icon_state = "xray"
	item_state = null
	ammo_type = list(/obj/item/ammo_casing/energy/xray)
	pin = null
	ammo_x_offset = 3

/obj/item/gun/energy/laser/makeshiftlasrifle
	name = "makeshift laser rifle"
	desc = "A makeshift rifle that shoots lasers. Lacks factory precision, so the damage may be inconsistent."
	icon_state = "makeshiftlas"
	item_state = "makeshiftlas"
	w_class = WEIGHT_CLASS_NORMAL
	ammo_type = list(/obj/item/ammo_casing/energy/laser/makeshiftlasrifle)
	internal_cell = TRUE

////////Laser Tag////////////////////

/obj/item/gun/energy/laser/bluetag
	name = "laser tag gun"
	icon_state = "bluetag"
	desc = "A retro laser gun modified to fire harmless blue beams of light. Sound effects included!"
	ammo_type = list(/obj/item/ammo_casing/energy/laser/bluetag)
	item_flags = NONE
	clumsy_check = FALSE
	pin = /obj/item/firing_pin/tag/blue
	ammo_x_offset = 2
	selfcharge = TRUE

/obj/item/gun/energy/laser/bluetag/hitscan
	ammo_type = list(/obj/item/ammo_casing/energy/laser/bluetag/hitscan)

/obj/item/gun/energy/laser/redtag
	name = "laser tag gun"
	icon_state = "redtag"
	desc = "A retro laser gun modified to fire harmless beams red of light. Sound effects included!"
	ammo_type = list(/obj/item/ammo_casing/energy/laser/redtag)
	item_flags = NONE
	clumsy_check = FALSE
	pin = /obj/item/firing_pin/tag/red
	ammo_x_offset = 2
	selfcharge = TRUE

/obj/item/gun/energy/laser/redtag/hitscan
	ammo_type = list(/obj/item/ammo_casing/energy/laser/redtag/hitscan)

/////////////PLASMA GUNS///////////

/obj/item/gun/energy/plasma
	block_upgrade_walk = 1
	w_class = WEIGHT_CLASS_NORMAL
	materials = list(/datum/material/iron=2000)
	ammo_x_offset = 1
	shaded_charge = 1
	pin = null

/obj/item/gun/energy/plasma/pistol
	name = "plasma pistol"
	icon_state = "plasma-pistol2"
	item_state = "plasma-pistol2"
	desc = "Highly advanced energy weapon that fires hot plasma, in a form of a pistol."
	ammo_type = list(/obj/item/ammo_casing/energy/plasma/gun/pistol)

/obj/item/gun/energy/plasma/pistol/fo13
	icon_state = "plasma-pistol"
	item_state = "plasma-pistol"
	pin = /obj/item/firing_pin

/obj/item/gun/energy/plasma/rifle
	name = "plasma rifle"
	icon_state = "plasma2"
	item_state = "plasma2"
	desc = "Highly advanced energy weapon that fires hot plasma."
	ammo_type = list(/obj/item/ammo_casing/energy/plasma/gun)

/obj/item/gun/energy/plasma/rifle/fo13
	icon_state = "plasma"
	item_state = "plasma"
	pin = /obj/item/firing_pin

/obj/item/gun/energy/plasma/multiplas
	name = "multiplas gun"
	icon_state = "multiplas2"
	item_state = "multiplas2"
	desc = "Highly advanced energy weapon that fires very hot plasma, modified version of the rifle, splits plasma into 3 separate projectiles."
	ammo_type = list(/obj/item/ammo_casing/energy/plasma/gun/scatter)

/obj/item/gun/energy/plasma/multiplas/fo13
	icon_state = "multiplas"
	item_state = "multiplas"
	pin = /obj/item/firing_pin
