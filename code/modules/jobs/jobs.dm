GLOBAL_LIST_INIT(command_positions, list(
	"Kapitan",
	"Kadrowy",
	"Szef Ochrony",
	"Główny Inżynier",
	"Dyrektor Naukowy",
	"Ordynator"))


GLOBAL_LIST_INIT(engineering_positions, list(
	"Główny Inżynier",
	"Inżynier",
	"Inżynier Atmosferyki"))


GLOBAL_LIST_INIT(medical_positions, list(
	"Ordynator",
	"Lekarz",
	"Genetyk",
	"Wirolog",
	"Paramedyk",
	"Chemik",
	"Lekarz Ochrony"))


GLOBAL_LIST_INIT(science_positions, list(
	"Dyrektor Naukowy",
	"Naukowiec",
	"Robotyk"))


GLOBAL_LIST_INIT(supply_positions, list(
	"Kadrowy",
	"Kwartermistrz",
	"Magazynier",
	"Górnik"))


GLOBAL_LIST_INIT(civilian_positions, list(
	"Barman",
	"Botanik",
	"Kucharz",
	"Woźny",
	"Kurator",
	"Prawnik",
	"Kapłan",
	"Klaun",
	"Mim",
	"Assistant"))

GLOBAL_LIST_INIT(gimmick_positions, list(
	"Cywilne",
	"Fryzjer",
	"Magik",
	"Dłużnik",
	"Psychiatra",
	"VIP"))

GLOBAL_LIST_INIT(security_positions, list(
	"Szef Ochrony",
	"Naczelnik",
	"Detektyw",
	"Funkcjonariusz Ochrony",
	"Aspirant"))


GLOBAL_LIST_INIT(nonhuman_positions, list(
	"SI Stacji",
	"Cyborg",
	ROLE_PAI))

GLOBAL_LIST_INIT(exp_jobsmap, list(
	EXP_TYPE_CREW = list("titles" = command_positions | engineering_positions | medical_positions | science_positions | supply_positions | security_positions | civilian_positions | gimmick_positions | list("AI","Cyborg")), // crew positions
	EXP_TYPE_COMMAND = list("titles" = command_positions),
	EXP_TYPE_ENGINEERING = list("titles" = engineering_positions),
	EXP_TYPE_MEDICAL = list("titles" = medical_positions),
	EXP_TYPE_SCIENCE = list("titles" = science_positions),
	EXP_TYPE_SUPPLY = list("titles" = supply_positions),
	EXP_TYPE_SECURITY = list("titles" = security_positions),
	EXP_TYPE_SILICON = list("titles" = list("AI","Cyborg")),
	EXP_TYPE_SERVICE = list("titles" = civilian_positions | gimmick_positions),
	EXP_TYPE_GIMMICK = list("titles" = gimmick_positions)
))

GLOBAL_LIST_INIT(exp_specialmap, list(
	EXP_TYPE_LIVING = list(), // all living mobs
	EXP_TYPE_ANTAG = list(),
	EXP_TYPE_SPECIAL = list("Lifebringer","Ash Walker","Exile","Servant Golem","Free Golem","Hermit","Translocated Vet","Escaped Prisoner","Hotel Staff","SuperFriend","Space Syndicate","Ancient Crew","Space Doctor","Space Bartender","Beach Bum","Skeleton","Zombie","Space Bar Patron","Lavaland Syndicate","Ghost Role"), // Ghost roles
	EXP_TYPE_GHOST = list() // dead people, observers
))
GLOBAL_PROTECT(exp_jobsmap)
GLOBAL_PROTECT(exp_specialmap)

/proc/guest_jobbans(job)
	return ((job in GLOB.command_positions) || (job in GLOB.nonhuman_positions) || (job in GLOB.security_positions))



//this is necessary because antags happen before job datums are handed out, but NOT before they come into existence
//so I can't simply use job datum.department_head straight from the mind datum, laaaaame.
/proc/get_department_heads(var/job_title)
	if(!job_title)
		return list()

	for(var/datum/job/J in SSjob.occupations)
		if(J.title == job_title)
			return J.department_head //this is a list

/proc/get_full_job_name(job)
	var/static/regex/cap_expand = new("cap(?!tain)")
	var/static/regex/cmo_expand = new("cmo")
	var/static/regex/hos_expand = new("hos")
	var/static/regex/hop_expand = new("hop")
	var/static/regex/rd_expand = new("rd")
	var/static/regex/ce_expand = new("ce")
	var/static/regex/qm_expand = new("qm")
	var/static/regex/sec_expand = new("(?<!security )officer")
	var/static/regex/engi_expand = new("(?<!station )engineer")
	var/static/regex/atmos_expand = new("atmos tech")
	var/static/regex/doc_expand = new("(?<!medical )doctor|medic(?!al)")
	var/static/regex/mine_expand = new("(?<!shaft )miner")
	var/static/regex/chef_expand = new("chef")
	var/static/regex/borg_expand = new("(?<!cy)borg")

	job = lowertext(job)
	job = cap_expand.Replace(job, "kapitan")
	job = cmo_expand.Replace(job, "ordynator")
	job = hos_expand.Replace(job, "szef ochrony")
	job = hop_expand.Replace(job, "kadrowy")
	job = rd_expand.Replace(job, "dyrektor naukowy")
	job = ce_expand.Replace(job, "główny inżynier")
	job = qm_expand.Replace(job, "kwartermistrz")
	job = sec_expand.Replace(job, "funkcjariusz ochrony")
	job = engi_expand.Replace(job, "inżynier")
	job = atmos_expand.Replace(job, "inżynier atmosferyki")
	job = doc_expand.Replace(job, "lekarz")
	job = mine_expand.Replace(job, "górnik")
	job = chef_expand.Replace(job, "kucharz")
	return job
