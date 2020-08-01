/datum/job/explorer
	title = "Explorer"
	flag = MINER
	department_head = list("Head of Personnel")
	department_flag = CIVILIAN
	faction = "Station"
	total_positions = 3
	spawn_positions = 3
	supervisors = "the quartermaster and the head of personnel"
	selection_color = "#dcba97"
	chat_color = "#CE957E"

	outfit = /datum/outfit/job/explorer

	access = list(ACCESS_MAINT_TUNNELS, ACCESS_MAILSORTING, ACCESS_CARGO, ACCESS_QM, ACCESS_MINING, ACCESS_MECH_MINING, ACCESS_MINING_STATION, ACCESS_MINERAL_STOREROOM, ACCESS_GATEWAY, ACCESS_EVA)
	minimal_access = list(ACCESS_MINING, ACCESS_MECH_MINING, ACCESS_MINING_STATION, ACCESS_MAILSORTING, ACCESS_MINERAL_STOREROOM, ACCESS_GATEWAY, ACCESS_EVA, ACCESS_MAINT_TUNNELS)
	paycheck = PAYCHECK_HARD
	paycheck_department = ACCOUNT_CAR

	display_order = JOB_DISPLAY_ORDER_EXPLORER

/datum/outfit/job/explorer
	name = "Explorer"
	jobtype = /datum/job/explorer

	id = /obj/item/card/id/job/mining
	belt = /obj/item/pda/mining
	ears = /obj/item/radio/headset/headset_cargo/mining
	shoes = /obj/item/clothing/shoes/workboots/explorer
	gloves = /obj/item/clothing/gloves/color/black
	uniform = /obj/item/clothing/under/rank/civilian/curator/treasure_hunter(src)
	l_pocket = /obj/item/kitchen/knife/combat/survival=1
	r_pocket = /obj/item/survivalcapsule
	backpack_contents = list(
		/obj/item/flashlight/seclite=1,\
        /obj/item/extraction_pack = 1 \
		/obj/item/gun/energy/kinetic_accelerator = 1\
        /obj/item/gps/miner = 1)

	backpack = /obj/item/storage/backpack/explorer
	satchel = /obj/item/storage/backpack/satchel/explorer
	duffelbag = /obj/item/storage/backpack/duffelbag
	box = /obj/item/storage/box/survival_explorer

	chameleon_extras = /obj/item/gun/energy/kinetic_accelerator

/datum/outfit/job/explorer/equipped
	name = "Exploring (Equipment)"
	suit = /obj/item/clothing/suit/space/eva
	helmet = /obj/item/clothing/head/helmet/space/eva
	mask = /obj/item/clothing/mask/gas/explorer
	glasses = /obj/item/clothing/glasses/meson
	suit_store = /obj/item/tank/internals/oxygen
	internals_slot = SLOT_S_STORE
	backpack_contents = list(
		/obj/item/flashlight/seclite=1,\
		/obj/item/kitchen/knife/combat/survival=1,\
		/obj/item/gun/energy/kinetic_accelerator = 1\
		/obj/item/gps/miner = 1\
        /obj/item/extraction_pack = 1)
