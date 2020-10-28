/obj/structure/closet/secure_closet/award
	name = "\proper award locker"
	req_one_access = list(ACCESS_CAPTAIN, ACCESS_HOP, ACCESS_QM, ACCESS_HOS, ACCESS_CE, ACCESS_CMO)
	icon_state = "award"

/obj/structure/closet/secure_closet/award/PopulateContents()
	..()
	new /obj/item/storage/lockbox/medal(src)
	new /obj/item/storage/lockbox/medal/service(src)
	new /obj/item/storage/lockbox/medal/cargo(src)
	new /obj/item/storage/lockbox/medal/sec(src)
	new /obj/item/storage/lockbox/medal/eng(src)
	new /obj/item/storage/lockbox/medal/sci(src)
	new /obj/item/storage/lockbox/medal/med(src)

