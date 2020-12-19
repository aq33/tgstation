//////////////////////////////////
//dakimakuras
//////////////////////////////////

/obj/item/dakimakura
	name = "dakimakura"
	var/custom_name = null
	desc = "A large pillow depicting someone in a compromising position. Featuring as many dimensions as you."
	icon = 'icons/obj/dakis.dmi'
	icon_state = "daki_base"
	lefthand_file = 'icons/mob/inhands/items_lefthand.dmi'
	righthand_file = 'icons/mob/inhands/items_righthand.dmi'
	item_state = "daki"
	slot_flags = null
	w_class = WEIGHT_CLASS_BULKY

/obj/item/dakimakura/attack_self(mob/living/user)
	var/body_choice
	if(!custom_name)
		body_choice = input("Pick a body.") in list(

		"Aitler",
		"Callie",
		"Catgirl",
		"Casca",
		"Centorea",
		"Chaika",
		"Coder",
		"Drone",
		"Elisabeth",
		"Fillia",
		"Foxy Granpa",
		"Haruko",
		"Holo",
		"Hotsauce",
		"Ian",
		"Jolyne",
		"Killer Queen",
		"Kurisu",
		"Marie",
		"Mero",
		"Miia",
		"Mugi",
		"Nar'Sie",
		"Papi",
		"Patchouli",
		"Pearl",
		"Plutia",
		"Rei",
		"Reisen",
		"Naga",
		"Squid",
		"Squiggly",
		"Sue Bowchief",
		"Suu",
		"Tomoko",
		"Toriel",
		"Umaru",
		"Yaranaika",
		"Yoko",
		"Kane",
		"TEG")

		icon_state = "daki_[body_choice]"	//Wew
		custom_name = stripped_input(user, "What's her name?")
		if(!custom_name)
			return
		name = custom_name + " " + name
		desc = "A large pillow depicting [custom_name] in a compromising position. Featuring as many dimensions as you."
	else
		if(user.a_intent == "help")
			user.visible_message("<span class='notice'>[user] hugs the [name].</span>")
			playsound(src.loc, "rustle", 50, 1, -5)
		if(user.a_intent == "disarm")
			user.visible_message("<span class='notice'>[user] kisses the [name].</span>")
			playsound(src.loc, 'sound/misc/kiss.ogg', 50, 1, -5)
		if(user.a_intent == "grab")
			user.visible_message("<span class='warning'>[user] gropes the [name]!</span>")
			playsound(src.loc, 'sound/items/bikehorn.ogg', 50, 1)
		if(user.a_intent == "harm")
			user.visible_message("<span class='danger'>[user] violently humps the [name]!</span>")
			playsound(user.loc, 'sound/effects/shieldbash.ogg', 50, 1)
