/datum/job/brig_phys
	title = "Brig Physician"
	flag = BRIG_PHYS
	department_head = list("Head of Security") //AQ EDIT
	department_flag = ENGSEC
	faction = "Station"
	total_positions = 1
	spawn_positions = 1
	supervisors = "Head of Security" //AQ EDIT
	selection_color = "#ffeeee"
	chat_color = "#b16789"
	minimal_player_age = 7
	exp_requirements = 120
	exp_type = EXP_TYPE_CREW
	exp_type_department = EXP_TYPE_SECURITY

	outfit = /datum/outfit/job/brig_phys
	mind_traits = list(TRAIT_LAW_ENFORCEMENT_METABOLISM)

	access = list(ACCESS_WEAPONS, ACCESS_MECH_SECURITY, ACCESS_BRIG, ACCESS_SECURITY, ACCESS_SEC_DOORS, ACCESS_COURT, ACCESS_MAINT_TUNNELS, ACCESS_MORGUE, ACCESS_MEDICAL, ACCESS_BRIGPHYS)
	minimal_access = list(ACCESS_WEAPONS, ACCESS_MECH_SECURITY, ACCESS_BRIG, ACCESS_SECURITY, ACCESS_SEC_DOORS, ACCESS_COURT, ACCESS_MAINT_TUNNELS, ACCESS_MORGUE, ACCESS_MEDICAL, ACCESS_BRIGPHYS)
	paycheck = PAYCHECK_MEDIUM
	paycheck_department = ACCOUNT_SEC

	display_order = JOB_DISPLAY_ORDER_BRIG_PHYS

/datum/outfit/job/brig_phys
	name = "Brig Physician"
	jobtype = /datum/job/brig_phys

	belt = /obj/item/storage/belt/security/deputy //AQ EDIT
	ears = /obj/item/radio/headset/headset_medsec
	uniform = /obj/item/clothing/under/rank/brig_phys
	shoes = /obj/item/clothing/shoes/jackboots //AQ EDIT
	glasses = /obj/item/clothing/glasses/hud/health/sunglasses
	suit = /obj/item/clothing/suit/hazardvest/brig_phys
	suit_store = /obj/item/flashlight/seclite
	l_hand = /obj/item/storage/firstaid/medical
	gloves = /obj/item/clothing/gloves/color/latex //AQ EDIT
	head = /obj/item/clothing/head/soft/sec/brig_phys
	l_pocket = /obj/item/pda/security //AQ EDIT
	implants = list(/obj/item/implant/mindshield, /obj/item/implant/securitydown) //AQ EDIT

	backpack = /obj/item/storage/backpack/medic
	satchel = /obj/item/storage/backpack/satchel/med
	duffelbag = /obj/item/storage/backpack/duffelbag/med
	box = /obj/item/storage/box/security

	chameleon_extras = /obj/item/gun/syringe
