/obj/machinery/vending/donksofttoyvendor
	name = "\improper Donksoft Toy Vendor"
	desc = "Ages 8 and up approved vendor that dispenses toys."
	icon_state = "nt-donk"
	product_slogans = "Zdobądź swoje super zabawki dziś!;Rozpocznij validhunt już dzisiaj!;Zabawkowe bronie najlepszej jakości w niskiej cenie!;Daj je HoPowi za AA!;Daj je Szefowi Ochrony za bilet do permy!"
	product_ads = "Poczuj się robustny ze swoimi zabawkami!;Wyraź swoje wewnętrzne dziecko już dziś!;Zabawkowe bronie nie zabijają ludzi. Ale validhunterzy już tak!;Kto potrzebuje odpowiedzialności jeśli masz zabawkowe bronie?;Uczyń swoje następne morderstwo ZABAWNE!"
	vend_reply = "Wróć po więcej!"
	light_color = LIGHT_COLOR_RED
	circuit = /obj/item/circuitboard/machine/vending/donksofttoyvendor
	products = list(
		/obj/item/gun/ballistic/automatic/toy/unrestricted = 10,
		/obj/item/gun/ballistic/automatic/toy/pistol/unrestricted = 10,
		/obj/item/gun/ballistic/shotgun/toy/unrestricted = 10,
		/obj/item/toy/sword = 10,
		/obj/item/ammo_box/foambox = 20,
		/obj/item/clothing/head/ertcommanderfake = 1,
		/obj/item/clothing/head/ertsecurityfake = 1,
		/obj/item/clothing/head/ertmedicalfake = 1,
		/obj/item/clothing/head/ertengineerfake = 1,
		/obj/item/toy/foamblade = 10)
	premium = list(
		/obj/item/clothing/suit/ertcommanderfake = 1,
		/obj/item/clothing/suit/ertsecurityfake = 1,
		/obj/item/clothing/suit/ertmedicalfake = 1,
		/obj/item/clothing/suit/ertengineerfake = 1,
		/obj/item/mecha_parts/mecha_equipment/weapon/ballistic/BBchaingun = 2,
		/obj/item/mecha_ammo/donksoft = 4)
	contraband = list(
		/obj/item/toy/syndicateballoon = 10,
		/obj/item/clothing/suit/syndicatefake = 4,
		/obj/item/clothing/head/syndicatefake = 4,
		/obj/item/gun/ballistic/shotgun/toy/crossbow = 10,
		/obj/item/gun/ballistic/automatic/c20r/toy/unrestricted = 10,
		/obj/item/gun/ballistic/automatic/l6_saw/toy/unrestricted = 10,
		/obj/item/toy/katana = 10,
		/obj/item/twohanded/dualsaber/toy = 5,
		/obj/item/dakimakura = 5)

	armor = list("melee" = 100, "bullet" = 100, "laser" = 100, "energy" = 100, "bomb" = 0, "bio" = 0, "rad" = 0, "fire" = 100, "acid" = 50)
	resistance_flags = FIRE_PROOF
	refill_canister = /obj/item/vending_refill/donksoft
	default_price = 100
	extra_price = 300
	payment_department = ACCOUNT_SRV

/obj/item/vending_refill/donksoft
	machine_name = "Donksoft Toy Vendor"
	icon_state = "refill_donksoft"
