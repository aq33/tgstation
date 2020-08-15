/datum/gear/organ
    subtype_path = /datum/gear/organ
    cost = 1000
    sort_category = "Organs"

/datum/gear/organ/tongue
    subtype_path = /datum/gear/organ/tongue
    display_name = "Tongue"
    cost = 500
    path = /obj/item/organ/tongue

/datum/gear/organ/tongue/robot
    display_name = "Robotic Voicebox"
    path = /obj/item/organ/tongue/robot

/datum/gear/organ/tongue/skeleton
    display_name = "Bone \"Tongue\""
    path = /obj/item/organ/tongue/bone

/datum/gear/organ/tongue/lizard
    display_name = "Forked Tongue"
    path = /obj/item/organ/tongue/lizard

/datum/gear/organ/tongue/fly
    display_name = "Proboscis" // Szymon chujnia mainty robotyka pomocy
    path = /obj/item/organ/tongue/fly

/datum/gear/organ/tail
    subtype_path = /datum/gear/organ/tail
    display_name = "Lizard Tail"
    cost = 1000
    path = /obj/item/organ/tail/lizard

/datum/gear/organ/tail/cat
    display_name = "Cat Tail"
    cost = 1
    path = /obj/item/organ/tail/cat

/datum/gear/organ/lungs
    subtype_path = /datum/gear/organ/lungs
    display_name = "Lungs"
    cost = 1000
    path = /obj/item/organ/lungs
    species_blacklist = list("plasmaman", "ipc") // nie tak łatwo plazmemy

/datum/gear/organ/lungs/plasma // ;)
    display_name = "Plasma Filter"
    description = "Plasma not included."
    cost = 250
    path = /obj/item/organ/lungs/plasmaman

/datum/gear/organ/ears
    subtype_path = /datum/gear/organ/ears
    display_name = "Ears"
    cost = 1000
    path = /obj/item/organ/ears

/datum/gear/organ/ears/robot
    display_name = "Auditory Sensors"
    path = /obj/item/organ/ears/robot

/datum/gear/organ/ears/penguin
    display_name = "Penguin Ears"
    cost = 1200
    path = /obj/item/organ/ears/penguin

/datum/gear/organ/ears/cat
    display_name = "Cat Ears"
    cost = 1
    path = /obj/item/organ/ears/cat