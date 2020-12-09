/datum/ambition_template
	///Name of the template. Has to be unique
	var/name
	///If defined, only the antags in the whitelists will see the template
	var/list/antag_whitelist
	///If defined, only the jobs in the whitelist will see the template
	var/list/job_whitelist

	///Narrative given by the template
	var/narrative = ""
	///Objectives given by the templates
	var/list/objectives = list()
	///Intensity given by the template
	var/intensity = 0
	///Tips displayed to the antag
	var/list/tips

/datum/ambition_template/blank
	name = "Pusty"

/datum/ambition_template/money_problems
	name = "Problemy Finansowe"
	narrative = "W potrzebie przypływu gotówki na własne zachcianki, zmęczony życiem jak dron, za żałosne pensje, masz zamiar zdobyć jakiś szmal by w końcu sobie ulżyć i spłacić długi!"
	objectives = list("Zdobądź 20,000 kredytów.")
	tips = list("Spróbuj dodać cel pomagający spełnić twój wielki plan zgromadzenia szmalcu!" , "Możesz dokonać tego kupując broń i rabując ludzi, ale pamiętaj o ukryciu tożsamości. Użyj do tego chameleon kit i agent's ID, inaczej zaryzykujesz bycie poszukiwanym.", "Założenie sklepu też nie jest złym pomysłem! Przemyśl współpracę z działem zaopatrzenia i naukowym w celu uzyskania dóbr, czy implantów.", "Jeśli czujesz się wystarczająco pewnie, możesz nawet dokonać skoku na skarbiec!")
