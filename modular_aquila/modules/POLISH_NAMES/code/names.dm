/proc/human_last_name_random()
	return pick(pick(GLOB.last_names_female), pick(GLOB.last_names_male))

/proc/human_first_name_random()
	return pick(pick(GLOB.first_names_female), pick(GLOB.first_names_male))
