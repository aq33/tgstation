/obj/mecha/combat/alpha
	desc = "This experimental vehicle is built on a titanium, Fullerene NanoTube composite honeycomb chassis. Its revolutionary flywheel design assists in power and stealth. That allows it to move quickly and easily over uneven terrain either as a walker or hovercraft, transforming as needed."
	name = "\improper TAC X1 Alpha"
	icon_state = "alphastandard"
	step_in = 4
	dir_in = 1 //Facing North.
	max_integrity = 200
	deflect_chance = 5
	armor = list("melee" = 30, "bullet" = 20, "laser" = 25, "energy" = 20, "bomb" = 0, "bio" = 0, "rad" = 0, "fire" = 100, "acid" = 100)
	max_temperature = 25000
	force = 20
	wreckage = /obj/structure/mecha_wreckage/alpha
	internal_damage_threshold = 40
	max_equip = 3
	var/next_ram = 0
	turnsound = 'sound/mecha/mechmove01.ogg'

/obj/mecha/combat/alpha/Initialize()
	. = ..()
	var/obj/item/mecha_parts/mecha_equipment/ME = new /obj/item/mecha_parts/mecha_equipment/thrusters/ion/alpha(src)
	ME.attach(src)
	src.transform = src.transform.Scale(1.2, 1.2) //b i g boy

/obj/mecha/combat/alpha/GrantActions(mob/living/user, human_occupant = 0)
	..()
	transform_action.Grant(user, src)

/obj/mecha/combat/alpha/RemoveActions(mob/living/user, human_occupant = 0)
	..()
	transform_action.Remove(user)

/obj/mecha/combat/alpha/Bump(var/atom/obstacle)
	. = ..()
	if(!istype(obstacle, /obj/machinery/door) && src.chase_mode && src.next_ram < world.time) //nie chcemy sie rozbijać za kazdym razem gdy probujemy otworzyc drzwi
		src.take_damage(10, BRUTE, "melee", 1, get_dir(obstacle, src))
		visible_message("<span class='danger'>[src] rams into [obstacle]!</span>")
		src.next_ram = world.time + 10

//--TRANSFORMACJA - STATYSTYKI--
//w celu wyczyszczenia kodu, postanowilem przeniesc zmiany statystyk do jednej funkcji

/obj/mecha/combat/alpha/proc/stat_transform()
	chase_mode = !chase_mode
	if(chase_mode)
		step_in = step_in_chase
		icon_state = icon_chase
		armor = armor.modifyRating(melee = -30, bullet = -20, laser = -25, energy = -20)
		stepsound = 'sound/vehicles/jetpack.ogg'
		turnsound = 'sound/vehicles/jetpack.ogg'
	else
		step_in = initial(step_in)
		icon_state = initial(icon_state)
		armor = armor.modifyRating(melee = 30, bullet = 20, laser = 25, energy = 20)
		stepsound = initial(stepsound)
		turnsound = initial(turnsound)
	transform_action.button_icon_state = "mech_chase_[chase_mode ? "on" : "off"]"
	transform_action.UpdateButtonIcon()

//--WYJSCIE Z MECHA W TRYBIE CHASE--
//przy opuszczeniu moba, mech zmienia sie w tryb standard. zapisanie trybu wymagaloby fundamentalnego przerobienia wielu funkcji, wiec to jest bezpieczniejsze rozwiazanie
/obj/mecha/combat/alpha/go_out()
	. = ..()
	if(chase_mode)
		stat_transform()

/obj/mecha/combat/alpha/aimob_exit_mech(mob/living/simple_animal/hostile/syndicate/mecha_pilot/pilot_mob)
	. = ..()
	if(chase_mode)
		stat_transform()

/obj/mecha/combat/alpha/transfer_ai(interaction, mob/user, mob/living/silicon/ai/AI, obj/item/aicard/card)
	. = ..()
	if(interaction == AI_TRANS_TO_CARD)
		if(chase_mode)
			stat_transform()

//--ALPHA THRUSTER PACKAGE--
//unikatowe dopalacze alphy, zaden inny mech nie powinien ich posiadać, dlatego są tutaj, a nie w pliku z ekwipunkiem

/obj/item/mecha_parts/mecha_equipment/thrusters/ion/alpha
	name = "Alpha thruster package"
	desc = "A set of thrusters that allow for exosuit movement in zero-gravity enviroments. This one seems to be made especially for the Alpha exosuit."

/obj/item/mecha_parts/mecha_equipment/thrusters/ion/alpha/thrust(var/movement_dir)
	if(!chassis)
		return FALSE
	if(chassis.use_power(chassis.step_energy_drain) && chassis.chase_mode) //odpalane tylko gdy jestesmy w trybie chase
		generate_effect(movement_dir)
		return TRUE
	return FALSE
