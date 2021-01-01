/datum/looping_sound/showering
	start_sound = 'sound/machines/shower/shower_start.ogg'
	start_length = 2
	mid_sounds = list('sound/machines/shower/shower_mid1.ogg'=1,'sound/machines/shower/shower_mid2.ogg'=1,'sound/machines/shower/shower_mid3.ogg'=1)
	mid_length = 10
	end_sound = 'sound/machines/shower/shower_end.ogg'
	volume = 20

///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

/datum/looping_sound/supermatter
	mid_sounds = list('sound/machines/sm/loops/calm.ogg' = 1)
	mid_length = 60
	volume = 40
	extra_range = 10

///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

/datum/looping_sound/generator
	start_sound = 'sound/machines/generator/generator_start.ogg'
	start_length = 4
	mid_sounds = list('sound/machines/generator/generator_mid1.ogg'=1, 'sound/machines/generator/generator_mid2.ogg'=1, 'sound/machines/generator/generator_mid3.ogg'=1)
	mid_length = 4
	end_sound = 'sound/machines/generator/generator_end.ogg'
	volume = 15

///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////


/datum/looping_sound/deep_fryer
	start_sound = 'sound/machines/fryer/deep_fryer_immerse.ogg' //my immersions
	start_length = 10
	mid_sounds = list('sound/machines/fryer/deep_fryer_1.ogg' = 1, 'sound/machines/fryer/deep_fryer_2.ogg' = 1)
	mid_length = 2
	end_sound = 'sound/machines/fryer/deep_fryer_emerge.ogg'
	volume = 15

///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

/datum/looping_sound/grill
	mid_length = 2
	mid_sounds = list('sound/machines/fryer/deep_fryer_1.ogg' = 1, 'sound/machines/fryer/deep_fryer_2.ogg' = 1)
	volume = 20

///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

/datum/looping_sound/microwave
	start_sound = 'sound/machines/microwave/microwave-start.ogg'
	start_length = 10
	mid_sounds = list('sound/machines/microwave/microwave-mid1.ogg'=10, 'sound/machines/microwave/microwave-mid2.ogg'=1)
	mid_length = 10
	end_sound = 'sound/machines/microwave/microwave-end.ogg'
	volume = 70

///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

/datum/looping_sound/thermal
	mid_length = 2
	mid_sounds = list('sound/machines/thermal/thermal_mid.ogg'=1)
	volume = 3

///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

/datum/looping_sound/computer
	start_sound = 'sound/machines/electronics/computer_start.ogg'
	start_length = 5
	mid_sounds = list('sound/machines/electronics/computer_mid1.ogg'=1, 'sound/machines/electronics/computer_mid2.ogg'=1, 'sound/machines/electronics/computer_mid3.ogg'=1, 'sound/machines/electronics/computer_mid4.ogg'=1, 'sound/machines/electronics/computer_mid5.ogg'=1)
	mid_length = 5
	end_sound = 'sound/machines/electronics/computer_stop.ogg'
	volume = 3

///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

/datum/looping_sound/lathe
	start_sound = 'sound/machines/electronics/lathe_start.ogg'
	start_length = 2
	mid_sounds = list('sound/machines/electronics/lathe_idle.ogg'=10, 'sound/machines/electronics/lathe_working.ogg'=1, 'sound/machines/electronics/lathe_working2.ogg'=1, 'sound/machines/electronics/lathe_working3.ogg'=1, 'sound/machines/electronics/lathe_working4.ogg'=1)
	mid_length = 2
	end_sound = 'sound/machines/electronics/computer_stop.ogg'
	volume = 8
	extra_range = 1

///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

/datum/looping_sound/smes
	start_sound = 'sound/machines/electronics/transformator_start.ogg'
	start_length = 2
	mid_sounds = list('sound/machines/electronics/transformator_mid.ogg'=1)
	mid_length = 2
	end_sound = 'sound/machines/electronics/transformator_stop.ogg'
	volume = 3

///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

datum/looping_sound/vent
	start_sound = 'sound/machines/thermal/vent_start.ogg'
	start_length = 1
	mid_sounds = list('sound/machines/thermal/vent_mid.ogg'=1)
	mid_length = 4
	end_sound = 'sound/machines/thermal/vent_stop.ogg'
	volume = 5

///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
