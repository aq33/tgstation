/obj/structure/closet/secure_closet/award
	name = "\proper award locker"
	req_one_access = list(ACCESS_CAPTAIN, ACCESS_HOP, ACCESS_QM, ACCESS_HOS, ACCESS_CE, ACCESS_RD, ACCESS_CMO)
	icon_state = "award"
	anchored = TRUE // those are placed on the departure shuttles, so they should be anchored by default

/obj/structure/closet/secure_closet/award/PopulateContents()
	..()
	new /obj/item/storage/lockbox/medal(src)
	new /obj/item/storage/lockbox/medal/service(src)
	new /obj/item/storage/lockbox/medal/cargo(src)
	new /obj/item/storage/lockbox/medal/sec(src)
	new /obj/item/storage/lockbox/medal/eng(src)
	new /obj/item/storage/lockbox/medal/sci(src)
	new /obj/item/storage/lockbox/medal/med(src)

