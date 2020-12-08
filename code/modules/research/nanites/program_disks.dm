//Names are intentionally all the same - track your nanites, or use a hand labeler
//This also means that you can give flesh melting nanites to your victims if you feel like it

/obj/item/disk/nanite_program
	name = "nanite program disk"
	desc = "A disk capable of storing nanite programs. Can be customized using a Nanite Programming Console."
	var/program_type
	var/datum/nanite_program/program

/obj/item/disk/nanite_program/Initialize()
	. = ..()
	if(program_type)
		program = new program_type

/obj/item/disk/nanite_program/aggressive_replication
	program_type = /datum/nanite_program/aggressive_replication

/obj/item/disk/nanite_program/metabolic_synthesis
	program_type = /datum/nanite_program/metabolic_synthesis

/obj/item/disk/nanite_program/nutrition_synthesis
	program_type = /datum/nanite_program/nutrition_synthesis

/obj/item/disk/nanite_program/viral
	program_type = /datum/nanite_program/viral

/obj/item/disk/nanite_program/meltdown
	program_type = /datum/nanite_program/meltdown

/obj/item/disk/nanite_program/monitoring
	program_type = /datum/nanite_program/monitoring

/obj/item/disk/nanite_program/nanolink
	program_type = /datum/nanite_program/nanolink

/obj/item/disk/nanite_program/cloud_change
	program_type = /datum/nanite_program/cloud_change

/obj/item/disk/nanite_program/relay
	program_type = /datum/nanite_program/relay

/obj/item/disk/nanite_program/emp
	program_type = /datum/nanite_program/emp

/obj/item/disk/nanite_program/spreading
	program_type = /datum/nanite_program/spreading

/obj/item/disk/nanite_program/nanite_sting
	program_type = /datum/nanite_program/nanite_sting

/obj/item/disk/nanite_program/regenerative
	program_type = /datum/nanite_program/regenerative

/obj/item/disk/nanite_program/regenerative_advanced
	program_type = /datum/nanite_program/regenerative_advanced

/obj/item/disk/nanite_program/temperature
	program_type = /datum/nanite_program/temperature

/obj/item/disk/nanite_program/purging
	program_type = /datum/nanite_program/purging

/obj/item/disk/nanite_program/purging_advanced
	program_type = /datum/nanite_program/purging_advanced

/obj/item/disk/nanite_program/brain_heal
	program_type = /datum/nanite_program/brain_heal

/obj/item/disk/nanite_program/brain_heal_advanced
	program_type = /datum/nanite_program/brain_heal_advanced

/obj/item/disk/nanite_program/blood_restoring
	program_type = /datum/nanite_program/blood_restoring

/obj/item/disk/nanite_program/repairing
	program_type = /datum/nanite_program/repairing

/obj/item/disk/nanite_program/nervous
	program_type = /datum/nanite_program/nervous

/obj/item/disk/nanite_program/hardening
	program_type = /datum/nanite_program/hardening

/obj/item/disk/nanite_program/nanojutsu
	program_type = /datum/nanite_program/nanojutsu

/obj/item/disk/nanite_program/camo
	program_type = /datum/nanite_program/camo

/obj/item/disk/nanite_program/kunai
	program_type = /datum/nanite_program/kunai

/obj/item/disk/nanite_program/nanophage
	program_type = /datum/nanite_program/nanophage

/obj/item/disk/nanite_program/coagulating
	program_type = /datum/nanite_program/coagulating

/obj/item/disk/nanite_program/necrotic
	program_type = /datum/nanite_program/necrotic

/obj/item/disk/nanite_program/brain_decay
	program_type = /datum/nanite_program/brain_decay

/obj/item/disk/nanite_program/pyro
	program_type = /datum/nanite_program/pyro

/obj/item/disk/nanite_program/cryo
	program_type = /datum/nanite_program/cryo

/obj/item/disk/nanite_program/toxic
	program_type = /datum/nanite_program/toxic

/obj/item/disk/nanite_program/suffocating
	program_type = /datum/nanite_program/suffocating

/obj/item/disk/nanite_program/heart_stop
	program_type = /datum/nanite_program/heart_stop

/obj/item/disk/nanite_program/explosive
	program_type = /datum/nanite_program/explosive

/obj/item/disk/nanite_program/shock
	program_type = /datum/nanite_program/shocking

/obj/item/disk/nanite_program/sleepy
	program_type = /datum/nanite_program/sleepy

/obj/item/disk/nanite_program/paralyzing
	program_type = /datum/nanite_program/paralyzing

/obj/item/disk/nanite_program/fake_death
	program_type = /datum/nanite_program/fake_death

/obj/item/disk/nanite_program/pacifying
	program_type = /datum/nanite_program/pacifying

/obj/item/disk/nanite_program/movement
	program_type = /datum/nanite_program/movement

/obj/item/disk/nanite_program/glitch
	program_type = /datum/nanite_program/glitch

/obj/item/disk/nanite_program/brain_misfire
	program_type = /datum/nanite_program/pacifying

/obj/item/disk/nanite_program/skin_decay
	program_type = /datum/nanite_program/pacifying

/obj/item/disk/nanite_program/nerve_decay
	program_type = /datum/nanite_program/pacifying

/obj/item/disk/nanite_program/refractive
	program_type = /datum/nanite_program/refractive

/obj/item/disk/nanite_program/conductive
	program_type = /datum/nanite_program/pacifying

/obj/item/disk/nanite_program/stun
	program_type = /datum/nanite_program/stun

/obj/item/disk/nanite_program/kickstart
	program_type = /datum/nanite_program/protocol/kickstart

/obj/item/disk/nanite_program/factory
	program_type = /datum/nanite_program/protocol/factory

/obj/item/disk/nanite_program/tinker
	program_type = /datum/nanite_program/protocol/tinker

/obj/item/disk/nanite_program/offline
	program_type = /datum/nanite_program/protocol/offline

/obj/item/disk/nanite_program/free_range
	program_type = /datum/nanite_program/protocol/free_range

/obj/item/disk/nanite_program/zip
	program_type = /datum/nanite_program/protocol/zip

/obj/item/disk/nanite_program/species
	program_type = /datum/nanite_program/sensor/species

/obj/item/disk/nanite_program/voice
	program_type = /datum/nanite_program/sensor/voice

/obj/item/disk/nanite_program/damage
	program_type = /datum/nanite_program/sensor/damage

/obj/item/disk/nanite_program/impact
	program_type = /datum/nanite_program/sensor/impact

/obj/item/disk/nanite_program/health
	program_type = /datum/nanite_program/sensor/health

/obj/item/disk/nanite_program/crit
	program_type = /datum/nanite_program/sensor/crit

/obj/item/disk/nanite_program/nanite_volume
	program_type = /datum/nanite_program/sensor/nanite_volume

/obj/item/disk/nanite_program/death
	program_type = /datum/nanite_program/sensor/death

/obj/item/disk/nanite_program/relay_repeat
	program_type = /datum/nanite_program/sensor/relay_repeat

/obj/item/disk/nanite_program/repeat
	program_type = /datum/nanite_program/sensor/repeat