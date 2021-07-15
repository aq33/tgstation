/obj/item/implant/securitydown
	name = "security officer down implant"
	activated = 0

/obj/item/implant/securitydown/get_data()
	var/dat = {"<b>Implant Specifications:</b><BR>
				<b>Name:</b> Localized Officer Death Notification Emission System. <BR>
				Emits an audible noise on cessation of life functions of the user.<BR>
				<b>Life:</b> Activates upon death.<BR>
				"}
	return dat

/obj/item/implant/securitydown/trigger(emote, mob/source)
	if(emote == "deathgasp")
		playsound(loc, 'modular_aquila/modules/implants/sounds/securitydown.ogg', 30, 0)


/obj/item/implanter/securitydown
	name = "implanter (security officer down)"
	imp_type = /obj/item/implant/securitydown

/obj/item/implantcase/securitydown
	name = "implant case - 'security officer down'"
	desc = "A glass case containing a security officer down implant. Emits a loud burst of static if the implanted person dies."
	imp_type = /obj/item/implant/securitydown