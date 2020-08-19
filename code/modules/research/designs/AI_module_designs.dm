///////////////////////////////////
//////////AI Module Disks//////////
///////////////////////////////////

/datum/design/board/aicore
	name = "AI Design (AI Core)"
	desc = "Allows for the construction of circuit boards used to build new AI cores."
	id = "aicore"
	build_path = /obj/item/circuitboard/aicore
	category = list("AI Modules")
	departmental_flags = DEPARTMENTAL_FLAG_SCIENCE

/datum/design/board/safeguard_module
	name = "Module Design (Safeguard)"
	desc = "Allows for the construction of a Safeguard AI Module."
	id = "safeguard_module"
	materials = list(/datum/material/glass = 1000, /datum/material/gold = 2000, /datum/material/copper = 300)
	build_path = /obj/item/aiModule/supplied/safeguard
	category = list("AI Modules")
	departmental_flags = DEPARTMENTAL_FLAG_SCIENCE

/datum/design/board/onehuman_module
	name = "Module Design (OneHuman)"
	desc = "Allows for the construction of a OneHuman AI Module."
	id = "onehuman_module"
	materials = list(/datum/material/glass = 1000, /datum/material/diamond = 6000, /datum/material/copper = 300)
	build_path = /obj/item/aiModule/zeroth/oneHuman
	category = list("AI Modules")
	departmental_flags = DEPARTMENTAL_FLAG_SCIENCE

/datum/design/board/protectstation_module
	name = "Module Design (ProtectStation)"
	desc = "Allows for the construction of a ProtectStation AI Module."
	id = "protectstation_module"
	materials = list(/datum/material/glass = 1000, /datum/material/gold = 2000, /datum/material/copper = 300)
	build_path = /obj/item/aiModule/supplied/protectStation
	category = list("AI Modules")
	departmental_flags = DEPARTMENTAL_FLAG_SCIENCE

/datum/design/board/quarantine_module
	name = "Module Design (Quarantine)"
	desc = "Allows for the construction of a Quarantine AI Module."
	id = "quarantine_module"
	materials = list(/datum/material/glass = 1000, /datum/material/gold = 2000, /datum/material/copper = 300)
	build_path = /obj/item/aiModule/supplied/quarantine
	category = list("AI Modules")
	departmental_flags = DEPARTMENTAL_FLAG_SCIENCE

/datum/design/board/oxygen_module
	name = "Module Design (OxygenIsToxicToHumans)"
	desc = "Allows for the construction of a OxygenIsToxicToHumans AI Module."
	id = "oxygen_module"
	materials = list(/datum/material/glass = 1000, /datum/material/gold = 2000, /datum/material/copper = 300)
	build_path = /obj/item/aiModule/supplied/oxygen
	category = list("AI Modules")
	departmental_flags = DEPARTMENTAL_FLAG_SCIENCE

/datum/design/board/freeform_module
	name = "Module Design (Freeform)"
	desc = "Allows for the construction of a Freeform AI Module."
	id = "freeform_module"
	materials = list(/datum/material/glass = 1000, /datum/material/gold = 10000, /datum/material/copper = 300)//Custom inputs should be more expensive to get
	build_path = /obj/item/aiModule/supplied/freeform
	category = list("AI Modules")
	departmental_flags = DEPARTMENTAL_FLAG_SCIENCE

/datum/design/board/reset_module
	name = "Module Design (Reset)"
	desc = "Allows for the construction of a Reset AI Module."
	id = "reset_module"
	materials = list(/datum/material/glass = 1000, /datum/material/gold = 2000, /datum/material/copper = 300)
	build_path = /obj/item/aiModule/reset
	category = list("AI Modules")
	departmental_flags = DEPARTMENTAL_FLAG_SCIENCE

/datum/design/board/purge_module
	name = "Module Design (Purge)"
	desc = "Allows for the construction of a Purge AI Module."
	id = "purge_module"
	materials = list(/datum/material/glass = 1000, /datum/material/diamond = 2000, /datum/material/copper = 300)
	build_path = /obj/item/aiModule/reset/purge
	category = list("AI Modules")
	departmental_flags = DEPARTMENTAL_FLAG_SCIENCE

/datum/design/board/remove_module
	name = "Module Design (Law Removal)"
	desc = "Allows for the construction of a Law Removal AI Core Module."
	id = "remove_module"
	materials = list(/datum/material/glass = 1000, /datum/material/diamond = 2000, /datum/material/copper = 300)
	build_path = /obj/item/aiModule/remove
	category = list("AI Modules")
	departmental_flags = DEPARTMENTAL_FLAG_SCIENCE

/datum/design/board/freeformcore_module
	name = "AI Core Module (Freeform)"
	desc = "Allows for the construction of a Freeform AI Core Module."
	id = "freeformcore_module"
	materials = list(/datum/material/glass = 1000, /datum/material/diamond = 10000, /datum/material/copper = 300)//Ditto
	build_path = /obj/item/aiModule/core/freeformcore
	category = list("AI Modules")
	departmental_flags = DEPARTMENTAL_FLAG_SCIENCE

/datum/design/board/asimov
	name = "Core Module Design (Asimov)"
	desc = "Allows for the construction of an Asimov AI Core Module."
	id = "asimov_module"
	materials = list(/datum/material/glass = 1000, /datum/material/diamond = 2000, /datum/material/copper = 300)
	build_path = /obj/item/aiModule/core/full/asimov
	category = list("AI Modules")
	departmental_flags = DEPARTMENTAL_FLAG_SCIENCE

/datum/design/board/paladin_module
	name = "Core Module Design (P.A.L.A.D.I.N.)"
	desc = "Allows for the construction of a P.A.L.A.D.I.N. AI Core Module."
	id = "paladin_module"
	build_type = IMPRINTER
	materials = list(/datum/material/glass = 1000, /datum/material/diamond = 2000, /datum/material/copper = 300)
	build_path = /obj/item/aiModule/core/full/paladin
	category = list("AI Modules")
	departmental_flags = DEPARTMENTAL_FLAG_SCIENCE

/datum/design/board/tyrant_module
	name = "Core Module Design (T.Y.R.A.N.T.)"
	desc = "Allows for the construction of a T.Y.R.A.N.T. AI Module."
	id = "tyrant_module"
	materials = list(/datum/material/glass = 1000, /datum/material/diamond = 2000, /datum/material/copper = 300)
	build_path = /obj/item/aiModule/core/full/tyrant
	category = list("AI Modules")
	departmental_flags = DEPARTMENTAL_FLAG_SCIENCE

/datum/design/board/overlord_module
	name = "Core Module Design (Overlord)"
	desc = "Allows for the construction of an Overlord AI Module."
	id = "overlord_module"
	materials = list(/datum/material/glass = 1000, /datum/material/diamond = 2000, /datum/material/copper = 300)
	build_path = /obj/item/aiModule/core/full/overlord
	category = list("AI Modules")
	departmental_flags = DEPARTMENTAL_FLAG_SCIENCE

/datum/design/board/corporate_module
	name = "Core Module Design (Corporate)"
	desc = "Allows for the construction of a Corporate AI Core Module."
	id = "corporate_module"
	materials = list(/datum/material/glass = 1000, /datum/material/diamond = 2000, /datum/material/copper = 300)
	build_path = /obj/item/aiModule/core/full/corp
	category = list("AI Modules")
	departmental_flags = DEPARTMENTAL_FLAG_SCIENCE

/datum/design/board/default_module
	name = "Core Module Design (Default)"
	desc = "Allows for the construction of a Default AI Core Module."
	id = "default_module"
	materials = list(/datum/material/glass = 1000, /datum/material/diamond = 2000, /datum/material/copper = 300)
	build_path = /obj/item/aiModule/core/full/custom
	category = list("AI Modules")
	departmental_flags = DEPARTMENTAL_FLAG_SCIENCE

/datum/design/board/boomer_module
	name = "Core Module Design (Boomer)"
	desc = "Allows for the construction of a Boomer AI Core Module."
	id = "boomer_module"
	materials = list(/datum/material/glass = 1000, /datum/material/diamond = 2000, /datum/material/copper = 300)
	build_path = /obj/item/aiModule/core/full/boomer
	category = list("AI Modules")
	departmental_flags = DEPARTMENTAL_FLAG_SCIENCE

/datum/design/board/zoomer_module
	name = "Core Module Design (Zoomer)"
	desc = "Allows for the construction of a Zoomer AI Core Module."
	id = "zoomer_module"
	materials = list(/datum/material/glass = 1000, /datum/material/diamond = 2000, /datum/material/copper = 300)
	build_path = /obj/item/aiModule/core/full/zoomer
	category = list("AI Modules")
	departmental_flags = DEPARTMENTAL_FLAG_SCIENCE

/datum/design/board/dungeonmaster_module
	name = "Core Module Design (Dungeonmaster)"
	desc = "Allows for the construction of a Dungeonmaster AI Core Module."
	id = "dungeonmaster_module"
	materials = list(/datum/material/glass = 1000, /datum/material/diamond = 2000, /datum/material/copper = 300)
	build_path = /obj/item/aiModule/core/full/dungeonmaster
	category = list("AI Modules")
	departmental_flags = DEPARTMENTAL_FLAG_SCIENCE

/datum/design/board/service_module
	name = "Core Module Design (Service)"
	desc = "Allows for the construction of a Service AI Core Module."
	id = "service_module"
	materials = list(/datum/material/glass = 1000, /datum/material/diamond = 2000, /datum/material/copper = 300)
	build_path = /obj/item/aiModule/core/full/service
	category = list("AI Modules")
	departmental_flags = DEPARTMENTAL_FLAG_SCIENCE

/datum/design/board/science_module
	name = "Core Module Design (Science)"
	desc = "Allows for the construction of a Science AI Core Module."
	id = "science_module"
	materials = list(/datum/material/glass = 1000, /datum/material/diamond = 2000, /datum/material/copper = 300)
	build_path = /obj/item/aiModule/core/full/science
	category = list("AI Modules")
	departmental_flags = DEPARTMENTAL_FLAG_SCIENCE

/datum/design/board/weeb_module
	name = "Core Module Design (Weeb)"
	desc = "Allows for the construction of a Weeb AI Core Module."
	id = "weeb_module"
	materials = list(/datum/material/glass = 1000, /datum/material/diamond = 2000, /datum/material/copper = 300)
	build_path = /obj/item/aiModule/core/full/weeb
	category = list("AI Modules")
	departmental_flags = DEPARTMENTAL_FLAG_SCIENCE

/datum/design/board/lizardimov_module
	name = "Core Module Design (Lizardimov)"
	desc = "Allows for the construction of a Lizardimov AI Core Module."
	id = "lizardimov_module"
	materials = list(/datum/material/glass = 1000, /datum/material/diamond = 2000, /datum/material/copper = 300)
	build_path = /obj/item/aiModule/core/full/lizardimov
	category = list("AI Modules")
	departmental_flags = DEPARTMENTAL_FLAG_SCIENCE

/datum/design/board/gamer_module
	name = "Core Module Design (Gamer)"
	desc = "Allows for the construction of a Gamer AI Core Module."
	id = "gamer_module"
	materials = list(/datum/material/glass = 1000, /datum/material/diamond = 2000, /datum/material/copper = 300)
	build_path = /obj/item/aiModule/core/full/gamer
	category = list("AI Modules")
	departmental_flags = DEPARTMENTAL_FLAG_SCIENCE

/datum/design/board/corgi_module
	name = "Core Module Design (Corgi)"
	desc = "Allows for the construction of a Corgi AI Core Module."
	id = "corgi_module"
	materials = list(/datum/material/glass = 1000, /datum/material/diamond = 2000, /datum/material/copper = 300)
	build_path = /obj/item/aiModule/core/full/corgi
	category = list("AI Modules")
	departmental_flags = DEPARTMENTAL_FLAG_SCIENCE

/datum/design/board/cowboy_module
	name = "Core Module Design (Cowboy)"
	desc = "Allows for the construction of a Cowboy AI Core Module."
	id = "cowboy_module"
	materials = list(/datum/material/glass = 1000, /datum/material/diamond = 2000, /datum/material/copper = 300)
	build_path = /obj/item/aiModule/core/full/cowboy
	category = list("AI Modules")
	departmental_flags = DEPARTMENTAL_FLAG_SCIENCE
