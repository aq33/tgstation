/obj/effect/proc_holder/spell/targeted/genetic/mutate_shadowcover
	name = "Shadow Cover"
	desc = "This spell causes you to generate a dark cover of shadowy mist."

	school = "transmutation"
	charge_max = 1000
	clothes_req = FALSE
	invocation_type = "none"
	range = -1
	include_user = TRUE

	mutations = list(SUPERANTIGLOWY)
	duration = 150
	cooldown_min = 1000 //25 deciseconds reduction per rank

	action_icon_state = "smoke"
	sound = 'sound/magic/ethereal_exit.ogg'
