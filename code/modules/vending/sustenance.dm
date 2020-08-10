/obj/machinery/vending/sustenance
	name = "\improper Sustenance Vendor"
	desc = "A vending machine which vends food, as required by section 47-C of the NT's Prisoner Ethical Treatment Agreement."
	product_slogans = "Smacznego.;Wystraczająco kalorii by wesprzeć intensywną pracę."
	product_ads = "Wystarczjąco zdrowe.;Wydajnie wyprodukowane tofu!;Mmm! Jakie dobre!;Poczęstuj się. NIE DLA PSA!;Potrzebujesz jedzenia, by żyć!;Weź jeszcze trochę cukrowej kukurydzy!;Spróbuj naszych nowych mrożonych kubków!"
	icon_state = "sustenance"
	light_color = LIGHT_COLOR_BLUEGREEN
	products = list(/obj/item/reagent_containers/food/snacks/tofu/prison = 24,
					/obj/item/reagent_containers/food/drinks/ice/prison = 12,
					/obj/item/reagent_containers/food/snacks/candy_corn/prison = 6)
	contraband = list(/obj/item/kitchen/knife = 6,
					  /obj/item/reagent_containers/food/drinks/coffee = 12,
					  /obj/item/tank/internals/emergency_oxygen = 6,
					  /obj/item/clothing/mask/breath = 6)
	refill_canister = /obj/item/vending_refill/sustenance
	default_price = 0
	extra_price = 0
	payment_department = NO_FREEBIES

/obj/item/vending_refill/sustenance
	machine_name = "Sustenance Vendor"
	icon_state = "refill_snack"
