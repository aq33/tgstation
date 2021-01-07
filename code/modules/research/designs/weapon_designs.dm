/////////////////////////////////////////
/////////////////Weapons/////////////////
/////////////////////////////////////////

/datum/design/c38/sec
	id = "sec_38"
	build_type = PROTOLATHE
	category = list("Ammo")
	departmental_flags = DEPARTMENTAL_FLAG_SECURITY

/datum/design/c38_trac
	name = "Speed Loader (.38 TRAC)"
	desc = "Designed to quickly reload revolvers. TRAC bullets embed a tracking implant within the target's body."
	id = "c38_trac"
	build_type = PROTOLATHE
	materials = list(/datum/material/iron = 20000, /datum/material/silver = 5000, /datum/material/gold = 1000)
	build_path = /obj/item/ammo_box/c38/trac
	category = list("Ammo")
	departmental_flags = DEPARTMENTAL_FLAG_SECURITY

/datum/design/c38_hotshot
	name = "Speed Loader (.38 Hot Shot)"
	desc = "Designed to quickly reload revolvers. Hot Shot bullets contain an incendiary payload."
	id = "c38_hotshot"
	build_type = PROTOLATHE
	materials = list(/datum/material/iron = 20000, /datum/material/plasma = 5000)
	build_path = /obj/item/ammo_box/c38/hotshot
	category = list("Ammo")
	departmental_flags = DEPARTMENTAL_FLAG_SECURITY

/datum/design/c38_iceblox
	name = "Speed Loader (.38 Iceblox)"
	desc = "Designed to quickly reload revolvers. Iceblox bullets contain a cryogenic payload."
	id = "c38_iceblox"
	build_type = PROTOLATHE
	materials = list(/datum/material/iron = 20000, /datum/material/plasma = 5000)
	build_path = /obj/item/ammo_box/c38/iceblox
	category = list("Ammo")
	departmental_flags = DEPARTMENTAL_FLAG_SECURITY

/datum/design/sleepy/sec
	name = "Soporific Shell"
	id = "sleepy"
	build_type = PROTOLATHE
	category = list("Ammo")
	materials = list(/datum/material/iron = 4000, /datum/material/silver = 1000, /datum/material/copper = 1000,  /datum/material/plastic = 1000)
	build_path = /obj/item/ammo_casing/shotgun/sleepytime
	departmental_flags = DEPARTMENTAL_FLAG_SECURITY

/datum/design/rubbershot/sec
	id = "sec_rshot"
	build_type = PROTOLATHE
	category = list("Ammo")
	departmental_flags = DEPARTMENTAL_FLAG_SECURITY

/datum/design/beanbag_slug/sec
	id = "sec_beanbag_slug"
	build_type = PROTOLATHE
	category = list("Ammo")
	departmental_flags = DEPARTMENTAL_FLAG_SECURITY

/datum/design/shotgun_slug/sec
	id = "sec_slug"
	build_type = PROTOLATHE
	category = list("Ammo")
	departmental_flags = DEPARTMENTAL_FLAG_SECURITY

/datum/design/buckshot_shell/sec
	id = "sec_bshot"
	build_type = PROTOLATHE
	category = list("Ammo")
	departmental_flags = DEPARTMENTAL_FLAG_SECURITY

/datum/design/shotgun_dart/sec
	id = "sec_dart"
	build_type = PROTOLATHE
	category = list("Ammo")
	departmental_flags = DEPARTMENTAL_FLAG_SECURITY

/datum/design/incendiary_slug/sec
	id = "sec_Islug"
	build_type = PROTOLATHE
	category = list("Ammo")
	departmental_flags = DEPARTMENTAL_FLAG_SECURITY

/datum/design/breaching_slug/sec
	name = "Breaching Slug"
	desc = "A 12 gauge anti-material slug. Great for breaching airlocks and windows with minimal shots."
	id = "sec_Brslug"
	build_type = PROTOLATHE
	materials = list(/datum/material/iron = 4000)
	build_path = /obj/item/ammo_casing/shotgun/breacher
	category = list("Ammo")
	departmental_flags = DEPARTMENTAL_FLAG_SECURITY

/datum/design/pin_testing
	name = "Test-Range Firing Pin"
	desc = "This safety firing pin allows firearms to be operated within proximity to a firing range."
	id = "pin_testing"
	build_type = PROTOLATHE
	materials = list(/datum/material/iron = 500, /datum/material/glass = 300)
	build_path = /obj/item/firing_pin/test_range
	category = list("Firing Pins")
	departmental_flags = DEPARTMENTAL_FLAG_SECURITY

/datum/design/pin_mindshield
	name = "Mindshield Firing Pin"
	desc = "This is a security firing pin which only authorizes users who are mindshield-implanted."
	id = "pin_loyalty"
	build_type = PROTOLATHE
	materials = list(/datum/material/silver = 600, /datum/material/diamond = 600, /datum/material/uranium = 200)
	build_path = /obj/item/firing_pin/implant/mindshield
	category = list("Firing Pins")
	departmental_flags = DEPARTMENTAL_FLAG_SECURITY

/datum/design/taser
	name = "Taser gun"
	desc = "A low-capacity, energy-based stun gun used by security teams to subdue targets at range."
	id = "taser"
	build_type = PROTOLATHE
	materials = list(/datum/material/iron = 10000, /datum/material/glass = 10000, /datum/material/silver = 10000)
	build_path = /obj/item/gun/energy/taser
	category = list("Weapons")
	departmental_flags = DEPARTMENTAL_FLAG_SECURITY

/datum/design/advtaser
	name = "Hybrid taser"
	desc = "A dual-mode taser designed to fire both short-range high-power electrodes and long-range disabler beams."
	id = "advtaser"
	build_type = PROTOLATHE
	materials = list(/datum/material/iron = 15000, /datum/material/glass = 15000, /datum/material/silver = 15000)
	build_path = /obj/item/gun/energy/e_gun/advtaser
	category = list("Weapons")
	departmental_flags = DEPARTMENTAL_FLAG_SECURITY

/datum/design/stunmine/sec/
	name = "Stun Mine"
	desc = "A basic nonlethal stunning mine. Does very heavy stamina damage to anyone who walks over it."
	id = "stunmine"
	build_type = PROTOLATHE
	materials = list(/datum/material/iron = 4000, /datum/material/glass = 1000, /datum/material/copper = 400)
	build_path = /obj/item/deployablemine/stun
	category = list("Ammo")
	departmental_flags = DEPARTMENTAL_FLAG_SECURITY

/datum/design/adv_stunmine/sec
	name = "Smart Stun Mine"
	desc = "A advanced nonlethal stunning mine. Uses advanced detection software to only trigger when activated by someone without a mindshield implant."
	id = "stunmine_adv"
	build_type = PROTOLATHE
	materials = list(/datum/material/iron = 8000, /datum/material/glass = 3000, /datum/material/copper = 1000, /datum/material/silver = 200)
	build_path = /obj/item/deployablemine/smartstun
	category = list("Ammo")
	departmental_flags = DEPARTMENTAL_FLAG_SECURITY

/datum/design/lm6_stunmine/sec
	name = "Rapid Deployment Smartmine"
	desc = "A advanced nonlethal stunning mine. Uses advanced detection software to only trigger when activated by someone without a mindshield implant. Can be rapidly placed and disarmed."
	id = "stunmine_rapid"
	build_type = PROTOLATHE
	materials = list(/datum/material/iron = 10000, /datum/material/glass = 4000, /datum/material/copper = 1000, /datum/material/silver = 500, /datum/material/uranium = 200)
	build_path = /obj/item/deployablemine/rapid
	category = list("Ammo")
	departmental_flags = DEPARTMENTAL_FLAG_SECURITY

/datum/design/lm12_stunmine/sec
	name = "Sledgehammer Smartmine"
	desc = "A advanced nonlethal stunning mine. Uses advanced detection software to only trigger when activated by someone without a mindshield implant. Very powerful and hard to disarm."
	id = "stunmine_heavy"
	build_type = PROTOLATHE
	materials = list(/datum/material/iron = 10000, /datum/material/glass = 4000, /datum/material/copper = 1000, /datum/material/silver = 500, /datum/material/uranium = 200)
	build_path = /obj/item/deployablemine/heavy
	category = list("Ammo")
	departmental_flags = DEPARTMENTAL_FLAG_SECURITY

/datum/design/honkmine
	name = "Honkblaster 1000"
	desc = "An advanced pressure activated pranking mine, honk!"
	id = "clown_mine"
	build_type = PROTOLATHE
	materials = list(/datum/material/iron = 4000, /datum/material/glass = 1000, /datum/material/bananium = 500)
	build_path = /obj/item/deployablemine/honk
	category = list("Ammo")
	departmental_flags = DEPARTMENTAL_FLAG_SERVICE

/datum/design/stunrevolver
	name = "Tesla Revolver"
	desc = "A high-tech revolver that fires internal, reusable shock cartridges in a revolving cylinder. The cartridges can be recharged using conventional rechargers."
	id = "stunrevolver"
	build_type = PROTOLATHE
	materials = list(/datum/material/iron = 10000, /datum/material/glass = 10000, /datum/material/silver = 10000)
	build_path = /obj/item/gun/energy/tesla_revolver
	category = list("Weapons")
	departmental_flags = DEPARTMENTAL_FLAG_SECURITY

/datum/design/nuclear_gun
	name = "Advanced Energy Gun"
	desc = "An energy gun with an experimental miniaturized reactor."
	id = "nuclear_gun"
	build_type = PROTOLATHE
	materials = list(/datum/material/iron = 10000, /datum/material/glass = 2000, /datum/material/uranium = 3000, /datum/material/titanium = 1000)
	build_path = /obj/item/gun/energy/e_gun/nuclear
	category = list("Weapons")
	departmental_flags = DEPARTMENTAL_FLAG_SECURITY

/datum/design/tele_shield
	name = "Telescopic Riot Shield"
	desc = "An advanced riot shield made of lightweight materials that collapses for easy storage."
	id = "tele_shield"
	build_type = PROTOLATHE
	materials = list(/datum/material/iron = 4000, /datum/material/glass = 4000, /datum/material/silver = 300, /datum/material/titanium = 200)
	build_path = /obj/item/shield/riot/tele
	category = list("Weapons")
	departmental_flags = DEPARTMENTAL_FLAG_SECURITY

/datum/design/beamrifle
	name = "Beam Marksman Rifle"
	desc = "A powerful long ranged anti-material rifle that fires charged particle beams to obliterate targets."
	id = "beamrifle"
	build_type = PROTOLATHE
	materials = list(/datum/material/iron = 10000, /datum/material/glass = 5000, /datum/material/diamond = 5000, /datum/material/uranium = 8000, /datum/material/silver = 4500, /datum/material/gold = 5000)
	build_path = /obj/item/gun/energy/beam_rifle
	category = list("Weapons")
	departmental_flags = DEPARTMENTAL_FLAG_SECURITY

/datum/design/decloner
	name = "Prototype Decloner"
	desc = "Your opponent will bubble into a messy pile of goop."
	id = "decloner"
	build_type = PROTOLATHE
	materials = list(/datum/material/iron = 5000,/datum/material/gold = 3000,/datum/material/uranium = 10000)
	build_path = /obj/item/gun/energy/decloner/weak
	category = list("Weapons")
	departmental_flags = DEPARTMENTAL_FLAG_SCIENCE

/datum/design/rapidsyringe
	name = "Rapid Syringe Gun"
	desc = "A gun that fires many syringes."
	id = "rapidsyringe"
	build_type = PROTOLATHE
	materials = list(/datum/material/iron = 5000, /datum/material/glass = 1000)
	build_path = /obj/item/gun/syringe/rapidsyringe
	category = list("Weapons")
	departmental_flags = DEPARTMENTAL_FLAG_MEDICAL		//uwu

/datum/design/temp_gun
	name = "Temperature Gun"
	desc = "A gun that shoots temperature bullet energythings to change temperature."//Change it if you want
	id = "temp_gun"
	build_type = PROTOLATHE
	materials = list(/datum/material/iron = 5000, /datum/material/glass = 500, /datum/material/silver = 3000)
	build_path = /obj/item/gun/energy/temperature
	category = list("Weapons")
	departmental_flags = DEPARTMENTAL_FLAG_SECURITY

/datum/design/flora_gun
	name = "Floral Somatoray"
	desc = "A tool that discharges controlled radiation which induces mutation in plant cells. Harmless to other organic life."
	id = "flora_gun"
	build_type = PROTOLATHE
	materials = list(/datum/material/iron = 2000, /datum/material/glass = 500)
	reagents_list = list(/datum/reagent/uranium/radium = 20)
	build_path = /obj/item/gun/energy/floragun
	category = list("Weapons")
	departmental_flags = DEPARTMENTAL_FLAG_SERVICE

/datum/design/grenade_launcher
	name = "Grenade Launcher"
	desc = "A device designed to rapidly deliver beeping presents around."
	id = "grenade_launcher"
	build_type = PROTOLATHE
	materials = list(/datum/material/iron = 10000, /datum/material/glass = 5000, /datum/material/gold = 2500, /datum/material/silver = 2500,)
	build_path = /obj/item/gun/grenadelauncher
	category = list("Weapons")
	departmental_flags = DEPARTMENTAL_FLAG_SECURITY

/datum/design/large_grenade
	name = "Large Grenade"
	desc = "A grenade that affects a larger area and use larger containers."
	id = "large_Grenade"
	build_type = PROTOLATHE
	materials = list(/datum/material/iron = 3000)
	build_path = /obj/item/grenade/chem_grenade/large
	category = list("Weapons")
	departmental_flags = DEPARTMENTAL_FLAG_SECURITY | DEPARTMENTAL_FLAG_MEDICAL

/datum/design/pyro_grenade
	name = "Pyro Grenade"
	desc = "An advanced grenade that is able to self ignite its mixture."
	id = "pyro_Grenade"
	build_type = PROTOLATHE
	materials = list(/datum/material/iron = 2000, /datum/material/plasma = 500)
	build_path = /obj/item/grenade/chem_grenade/pyro
	category = list("Weapons")
	departmental_flags = DEPARTMENTAL_FLAG_SECURITY | DEPARTMENTAL_FLAG_MEDICAL

/datum/design/cryo_grenade
	name = "Cryo Grenade"
	desc = "An advanced grenade that rapidly cools its contents upon detonation."
	id = "cryo_Grenade"
	build_type = PROTOLATHE
	materials = list(/datum/material/iron = 2000, /datum/material/silver = 500)
	build_path = /obj/item/grenade/chem_grenade/cryo
	category = list("Weapons")
	departmental_flags = DEPARTMENTAL_FLAG_SECURITY | DEPARTMENTAL_FLAG_MEDICAL

/datum/design/adv_grenade
	name = "Advanced Release Grenade"
	desc = "An advanced grenade that can be detonated several times, best used with a repeating igniter."
	id = "adv_Grenade"
	build_type = PROTOLATHE
	materials = list(/datum/material/iron = 3000, /datum/material/glass = 500)
	build_path = /obj/item/grenade/chem_grenade/adv_release
	category = list("Weapons")
	departmental_flags = DEPARTMENTAL_FLAG_SECURITY | DEPARTMENTAL_FLAG_MEDICAL

/datum/design/laserpistol
	name = "Laser Pistol"
	desc = "A laser pistol or more like glorified laser pointer."
	id = "laserpistol"
	build_type = PROTOLATHE
	materials = list(/datum/material/copper = 2500, /datum/material/glass = 2000, /datum/material/iron = 2500, /datum/material/plastic = 1000)
	build_path = /obj/item/gun/energy/laser/pistol
	category = list("Weapons")
	departmental_flags = DEPARTMENTAL_FLAG_SECURITY

/datum/design/laserrifle
	name = "Laser Carbine"
	desc = "An laser carbine that goes pew pew."
	id = "laserrifle"
	build_type = PROTOLATHE
	materials = list(/datum/material/gold = 5000, /datum/material/uranium = 4000, /datum/material/iron = 5000, /datum/material/titanium = 2000)
	build_path = /obj/item/gun/energy/laser/lgun
	category = list("Weapons")
	departmental_flags = DEPARTMENTAL_FLAG_SECURITY

/datum/design/laserrifletri
	name = "Tri-beam Laser Rifle"
	desc = "An laser shotgun but without the ompf."
	id = "laserrifletri"
	build_type = PROTOLATHE
	materials = list(/datum/material/gold = 4750, /datum/material/uranium = 4000, /datum/material/iron = 5000, /datum/material/titanium = 2250)
	build_path = /obj/item/gun/energy/laser/tribeam
	category = list("Weapons")
	departmental_flags = DEPARTMENTAL_FLAG_SECURITY

/datum/design/plasmapistol
	name = "Experimental Plasma Pistol"
	desc = "Plasma pistol."
	id = "plasmapistol"
	build_type = PROTOLATHE
	materials = list(/datum/material/gold = 4750, /datum/material/uranium = 6000, /datum/material/iron = 5000, /datum/material/titanium = 2250)
	build_path = /obj/item/gun/energy/plasma/pistol
	category = list("Weapons")
	departmental_flags = DEPARTMENTAL_FLAG_SECURITY

/datum/design/plasmagun
	name = "Experimental Plasma Gun"
	desc = "Plasma Gun."
	id = "plasmagun"
	build_type = PROTOLATHE
	materials = list(/datum/material/gold = 4750, /datum/material/uranium = 8000, /datum/material/iron = 5000, /datum/material/titanium = 2500)
	build_path = /obj/item/gun/energy/plasma/rifle
	category = list("Weapons")
	departmental_flags = DEPARTMENTAL_FLAG_SECURITY

/datum/design/multiplas
	name = "Experimental Scatter Plasma Gun"
	desc = "Multiplas Gun."
	id = "multiplas"
	build_type = PROTOLATHE
	materials = list(/datum/material/gold = 5000, /datum/material/uranium = 8000, /datum/material/iron = 5000, /datum/material/titanium = 2500)
	build_path = /obj/item/gun/energy/plasma/multiplas
	category = list("Weapons")
	departmental_flags = DEPARTMENTAL_FLAG_SECURITY

/datum/design/xray
	name = "X-ray Laser Gun"
	desc = "Not quite as menacing as it sounds"
	id = "xray_laser"
	build_type = PROTOLATHE
	materials = list(/datum/material/gold = 5000, /datum/material/uranium = 4000, /datum/material/iron = 5000, /datum/material/titanium = 2000, /datum/material/bluespace = 2000)
	build_path = /obj/item/gun/energy/xray
	category = list("Weapons")
	departmental_flags = DEPARTMENTAL_FLAG_SECURITY

/datum/design/ioncarbine
	name = "Ion Carbine"
	desc = "How to dismantle a cyborg : The gun."
	id = "ioncarbine"
	build_type = PROTOLATHE
	materials = list(/datum/material/silver = 6000, /datum/material/iron = 8000, /datum/material/uranium = 2000)
	build_path = /obj/item/gun/energy/ionrifle/carbine
	category = list("Weapons")
	departmental_flags = DEPARTMENTAL_FLAG_SECURITY

/datum/design/wormhole_projector
	name = "Handheld Portal Device"
	desc = "Experimental tool designed to place two portals that objects can pass through."
	id = "wormholeprojector"
	build_type = PROTOLATHE
	materials = list(/datum/material/silver = 2000, /datum/material/iron = 5000, /datum/material/diamond = 2000, /datum/material/bluespace = 3000)
	build_path = /obj/item/gun/energy/wormhole_projector
	category = list("Weapons")
	departmental_flags = DEPARTMENTAL_FLAG_SCIENCE

//WT550 Mags

/datum/design/mag_oldsmg
	name = "WT-550 Auto Gun Magazine (4.6x30mm)"
	desc = "An empty 20 round magazine for the security WT-550 PDW"
	id = "mag_oldsmg"
	build_type = PROTOLATHE
	materials = list(/datum/material/iron = 2000, /datum/material/glass = 500)
	build_path = /obj/item/ammo_box/magazine/wt550m9/dry
	category = list("Ammo")
	departmental_flags = DEPARTMENTAL_FLAG_SECURITY

/datum/design/mag_oldsmg/ap_mag
	name = "WT-550 Auto Gun Armour Piercing Magazine (4.6x30mm AP)"
	desc = "A 20 round armour piercing magazine for the security WT-550 PDW"
	id = "mag_oldsmg_ap"
	materials = list(/datum/material/iron = 12000, /datum/material/silver = 600)
	build_path = /obj/item/ammo_box/magazine/wt550m9/wtap
	departmental_flags = DEPARTMENTAL_FLAG_SECURITY

/datum/design/mag_oldsmg/ic_mag
	name = "WT-550 Auto Gun Incendiary Magazine (4.6x30mm IC)"
	desc = "A 20 round armour piercing magazine for security WT-550 PDW"
	id = "mag_oldsmg_ic"
	materials = list(/datum/material/iron = 12000, /datum/material/silver = 600, /datum/material/glass = 1000)
	build_path = /obj/item/ammo_box/magazine/wt550m9/wtic
	departmental_flags = DEPARTMENTAL_FLAG_SECURITY

//Security Pistol Mags
/datum/design/mag_secpistol
	name = "Security Pistol Magazine (9mm)"
	desc = "An empty 12 round magazine for the standard-issue security pistol loaded."
	id = "mag_secpistol"
	build_type = PROTOLATHE
	materials = list(/datum/material/iron = 2000, /datum/material/glass = 500, /datum/material/copper = 15)
	build_path = /obj/item/ammo_box/magazine/sec9mm/dry
	category = list("Ammo")
	departmental_flags = DEPARTMENTAL_FLAG_SECURITY

/datum/design/mag_secpistol/ext
	name = "Security Pistol Extended Magazine (9mm)"
	desc = "An empty 20 round magazine for the standard-issue security pistol."
	id = "mag_secpistol_ext"
	build_type = PROTOLATHE
	materials = list(/datum/material/iron = 3000, /datum/material/glass = 750, /datum/material/copper = 20)
	build_path = /obj/item/ammo_box/magazine/sec9mm/ext/dry
	category = list("Ammo")
	departmental_flags = DEPARTMENTAL_FLAG_SECURITY

/datum/design/mag_riotrifle/
	name = "Riot Rifle Magazine (7.62mm)"
	desc = "An empty 10 round magazine for the security riot rifle."
	id = "mag_riotrifle"
	build_type = PROTOLATHE
	materials = list(/datum/material/iron = 3000, /datum/material/glass = 750, /datum/material/copper = 20)
	build_path = /obj/item/ammo_box/magazine/a762/mag/dry
	category = list("Ammo")
	departmental_flags = DEPARTMENTAL_FLAG_SECURITY

//Ammo Boxes
/datum/design/c9mm/sec
	name = "9mm Ammo Box"
	id = "9mmbox"
	build_type = PROTOLATHE
	category = list("Ammo")
	materials = list(/datum/material/iron = 20000, /datum/material/glass = 15000, /datum/material/copper = 500)
	build_path = /obj/item/ammo_box/c9mm
	departmental_flags = DEPARTMENTAL_FLAG_SECURITY

/datum/design/c9mmnl/sec
	name = "9mm Rubber Ammo Box"
	id = "9mmboxnl"
	build_type = PROTOLATHE
	category = list("Ammo")
	materials = list(/datum/material/iron = 15000, /datum/material/glass = 10000, /datum/material/copper = 500)
	build_path = /obj/item/ammo_box/c9mm/nl
	departmental_flags = DEPARTMENTAL_FLAG_SECURITY

/datum/design/c46x30mm/sec
	name = "4.6x30mm Ammo Box"
	id = "wtbox"
	build_type = PROTOLATHE
	category = list("Ammo")
	materials = list(/datum/material/iron = 24000, /datum/material/glass = 15000, /datum/material/copper = 500)
	build_path = /obj/item/ammo_box/c46x30mm
	departmental_flags = DEPARTMENTAL_FLAG_SECURITY

/datum/design/c46x30mmnl/sec
	name = "4.6x30mm Rubber Ammo Box"
	id = "wtboxnl"
	build_type = PROTOLATHE
	category = list("Ammo")
	materials = list(/datum/material/iron = 19000, /datum/material/glass = 10000, /datum/material/copper = 500)
	build_path = /obj/item/ammo_box/c46x30mm/nl
	departmental_flags = DEPARTMENTAL_FLAG_SECURITY

/datum/design/a762/sec
	name = "7.62mm Ammo Box"
	id = "762box"
	build_type = PROTOLATHE
	category = list("Ammo")
	materials = list(/datum/material/iron = 26000, /datum/material/glass = 15000, /datum/material/copper = 500)
	build_path = /obj/item/ammo_box/a762/box
	departmental_flags = DEPARTMENTAL_FLAG_SECURITY

/datum/design/a762nl/sec
	name = "7.62mm Rubber Ammo Box"
	id = "762boxnl"
	build_type = PROTOLATHE
	category = list("Ammo")
	materials = list(/datum/material/iron = 21000, /datum/material/glass = 10000, /datum/material/copper = 500)
	build_path = /obj/item/ammo_box/a762/box/nl
	departmental_flags = DEPARTMENTAL_FLAG_SECURITY

/datum/design/stunshell
	name = "Stun Shell"
	desc = "A stunning shell for a shotgun."
	id = "stunshell"
	build_type = PROTOLATHE
	materials = list(/datum/material/iron = 200)
	build_path = /obj/item/ammo_casing/shotgun/stunslug
	category = list("Ammo")
	departmental_flags = DEPARTMENTAL_FLAG_SECURITY

/datum/design/techshell
	name = "Unloaded Technological Shotshell"
	desc = "A high-tech shotgun shell which can be loaded with materials to produce unique effects."
	id = "techshotshell"
	build_type = PROTOLATHE
	materials = list(/datum/material/iron = 1000, /datum/material/glass = 200)
	build_path = /obj/item/ammo_casing/shotgun/techshell
	category = list("Ammo")
	departmental_flags = DEPARTMENTAL_FLAG_SECURITY | DEPARTMENTAL_FLAG_SCIENCE

/datum/design/suppressor
	name = "Suppressor"
	desc = "A reverse-engineered suppressor that fits on most small arms with threaded barrels."
	id = "suppressor"
	build_type = PROTOLATHE
	materials = list(/datum/material/iron = 2000, /datum/material/silver = 500)
	build_path = /obj/item/suppressor
	category = list("Weapons")
	departmental_flags = DEPARTMENTAL_FLAG_SECURITY

/datum/design/gravitygun
	name = "One-point Bluespace-gravitational Manipulator"
	desc = "A multi-mode device that blasts one-point bluespace-gravitational bolts that locally distort gravity."
	id = "gravitygun"
	build_type = PROTOLATHE
	materials = list(/datum/material/silver = 8000, /datum/material/uranium = 8000, /datum/material/glass = 12000, /datum/material/iron = 12000, /datum/material/diamond = 3000, /datum/material/bluespace = 3000)
	build_path = /obj/item/gun/energy/gravity_gun
	category = list("Weapons")
	departmental_flags = DEPARTMENTAL_FLAG_SCIENCE

/datum/design/largecrossbow
	name = "Energy Crossbow"
	desc = "A reverse-engineered energy crossbow favored by syndicate infiltration teams and carp hunters."
	id = "largecrossbow"
	build_type = PROTOLATHE
	materials = list(/datum/material/iron = 10000, /datum/material/titanium = 5000, /datum/material/uranium = 3000, /datum/material/silver = 1500)
	build_path = /obj/item/gun/energy/kinetic_accelerator/crossbow/large
	category = list("Weapons")
	departmental_flags = DEPARTMENTAL_FLAG_SCIENCE

/datum/design/memorizer
	name = "Memorizer"
	desc = "A single-use device capable of wiping out someone's short-term memory."
	id = "memorizer"
	build_type = PROTOLATHE
	materials = list(/datum/material/iron = 5000, /datum/material/glass = 1500, /datum/material/uranium = 1500, /datum/material/diamond = 1500)
	build_path = /obj/item/assembly/flash/memorizer
	category = list("Weapons")
	departmental_flags = DEPARTMENTAL_FLAG_SCIENCE

/datum/design/cryostasis_shotgun_dart
	name = "Cryostasis Shotgun Dart"
	desc = "A shotgun dart designed with similar internals to that of a cryostasis beaker, allowing reagents to not react when inside."
	id = "shotgundartcryostasis"
	build_type = PROTOLATHE
	materials = list(/datum/material/iron = 3500)
	build_path = /obj/item/ammo_casing/shotgun/dart/noreact
	category = list("Ammo")
	departmental_flags = DEPARTMENTAL_FLAG_MEDICAL

/datum/design/flashbulb
	name = "Security Flashbulb"
	desc = "A powerful bulb that, when placed into a flash device can emit a bright light that will disorientate and subdue targets."
	id = "flashbulb"
	build_type = PROTOLATHE
	materials = list(/datum/material/iron = 300, /datum/material/glass = 150)
	build_path = /obj/item/flashbulb
	category = list("Weapons")
	departmental_flags = DEPARTMENTAL_FLAG_SECURITY
