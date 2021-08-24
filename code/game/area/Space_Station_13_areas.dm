/*

### This file contains a list of all the areas in your station. Format is as follows:

/area/CATEGORY/OR/DESCRIPTOR/NAME 	(you can make as many subdivisions as you want)
	name = "NICE NAME" 				(not required but makes things really nice)
	icon = 'ICON FILENAME' 			(defaults to 'icons/turf/areas.dmi')
	icon_state = "NAME OF ICON" 	(defaults to "unknown" (blank))
	requires_power = FALSE 				(defaults to true)
	ambient_effects = list()				(defaults to GENERIC from sound.dm. override it as "ambient_effects = list('sound/ambience/signal.ogg')" or using another define.

NOTE: there are two lists of areas in the end of this file: centcom and station itself. Please maintain these lists valid. --rastaf0

*/


/*-----------------------------------------------------------------------------*/

/area/ai_monitored	//stub defined ai_monitored.dm

/area/ai_monitored/turret_protected

/area/space
	icon_state = "space"
	requires_power = TRUE
	always_unpowered = TRUE
	dynamic_lighting = DYNAMIC_LIGHTING_DISABLED
	power_light = FALSE
	power_equip = FALSE
	power_environ = FALSE
	valid_territory = FALSE
	outdoors = TRUE
	ambient_music = SPACE
	blob_allowed = FALSE //Eating up space doesn't count for victory as a blob.
	ambient_buzz = null // Space is pretty quiet

/area/space/nearstation
	icon_state = "space_near"
	dynamic_lighting = DYNAMIC_LIGHTING_IFSTARLIGHT

/area/start
	name = "start area"
	icon_state = "start"
	requires_power = FALSE
	dynamic_lighting = DYNAMIC_LIGHTING_DISABLED
	has_gravity = STANDARD_GRAVITY
	ambient_buzz = null


/area/testroom
	requires_power = FALSE
	name = "Test Room"
	icon_state = "storage"

//EXTRA

/area/asteroid
	name = "Asteroida"
	icon_state = "asteroid"
	requires_power = FALSE
	has_gravity = STANDARD_GRAVITY
	blob_allowed = FALSE //Nope, no winning on the asteroid as a blob. Gotta eat the station.
	valid_territory = FALSE
	ambient_effects = MINING

/area/asteroid/nearstation
	dynamic_lighting = DYNAMIC_LIGHTING_FORCED
	ambient_effects = RUINS
	always_unpowered = FALSE
	requires_power = TRUE
	blob_allowed = TRUE

/area/asteroid/nearstation/bomb_site
	name = "Asteroida do testowania bomb"

//STATION13

//Maintenance

/area/maintenance
	ambient_effects = MAINTENANCE
	valid_territory = FALSE
	mood_bonus = -1
	mood_message = "<span class='warning'>It's kind of cramped in here!\n</span>"
	lighting_colour_tube = "#ffe5cb"
	lighting_colour_bulb = "#ffdbb4"

//Departments

/area/maintenance/department/chapel
	name = "Tunel Techniczny Kaplica"
	icon_state = "maint_chapel"

/area/maintenance/department/chapel/monastery
	name = "Tunel Techniczny Klasztor"
	icon_state = "maint_monastery"

/area/maintenance/department/crew_quarters/bar
	name = "Tunel Techniczny Bar"
	icon_state = "maint_bar"

/area/maintenance/department/crew_quarters/dorms
	name = "Tunel Techniczny Sala Sypialna"
	icon_state = "maint_dorms"

/area/maintenance/department/eva
	name = "Tunel Techniczny EVA"
	icon_state = "maint_eva"

/area/maintenance/department/electrical
	name = "Tunel Techniczny Energetyka"
	icon_state = "maint_electrical"

/area/maintenance/department/engine/atmos
	name = "Tunel Techniczny Atmosferyka"
	icon_state = "maint_atmos"

/area/maintenance/department/security
	name = "Tunel Techniczny Ochrona"
	icon_state = "maint_sec"

/area/maintenance/department/security/upper
	name = "Górny Tunel Techniczny Ochrona"

/area/maintenance/department/security/brig
	name = "Tunel Techniczny Areszt"
	icon_state = "maint_brig"

/area/maintenance/department/medical
	name = "Tunel Techniczny Szpital"
	icon_state = "medbay_maint"

/area/maintenance/department/medical/central
	name = "Centralny Tunel Techniczny Szpital"
	icon_state = "medbay_maint_central"

/area/maintenance/department/medical/morgue
	name = "Tunel Techniczny Kostnica"
	icon_state = "morgue_maint"

/area/maintenance/department/science
	name = "Tunel Techniczny Wydział Badawczy"
	icon_state = "maint_sci"

/area/maintenance/department/science/central
	name = "Centralny Tunel Techniczny Wydział Badawczy"
	icon_state = "maint_sci_central"

/area/maintenance/department/cargo
	name = "Tunel Techniczny Ładownia"
	icon_state = "maint_cargo"

/area/maintenance/department/bridge
	name = "Tunel Techniczny Mostek"
	icon_state = "maint_bridge"

/area/maintenance/department/engine
	name = "Tunel Techniczny Inżynieria"
	icon_state = "maint_engi"

/area/maintenance/department/science/xenobiology
	name = "Tunel Techniczny Ksenobiologia"
	icon_state = "xenomaint"
	xenobiology_compatible = TRUE


//Maintenance - Generic

/area/maintenance/aft
	name = "Tunel Techniczny Rufa"
	icon_state = "amaint"

/area/maintenance/aft/upper
	name = "Górny Tunel Techniczny Rufa"

/area/maintenance/aft/secondary
	name = "Tunel Techniczny Rufa"
	icon_state = "amaint_2"

/area/maintenance/central
	name = "Centralny Tunel Techniczny"
	icon_state = "maintcentral"

/area/maintenance/central/secondary
	name = "Centralny Tunel Techniczny"
	icon_state = "maintcentral"

/area/maintenance/fore
	name = "Tunel Techniczny Dziób"
	icon_state = "fmaint"

/area/maintenance/fore/upper
	name = "Górny Tunel Techniczny Dziób"

/area/maintenance/fore/secondary
	name = "Tunel Techniczny Dziób"
	icon_state = "fmaint_2"

/area/maintenance/starboard
	name = "Tunel Techniczny Sterburta"
	icon_state = "smaint"

/area/maintenance/starboard/upper
	name = "Górny Tunel Techniczny Sterburta"

/area/maintenance/starboard/central
	name = "Centralny Tunel Techniczny Sterburta"
	icon_state = "smaint"

/area/maintenance/starboard/secondary
	name = "Drugorzędny Tunel Techniczny Sterburta"
	icon_state = "smaint_2"

/area/maintenance/starboard/aft
	name = "Dolny Tunel Techniczny Sterburta"
	icon_state = "asmaint"

/area/maintenance/starboard/aft/secondary
	name = "Drugorzędny Dolny Tunel Techniczny Sterburta"
	icon_state = "asmaint_2"

/area/maintenance/starboard/fore
	name = "Przedni Tunel Techniczny Sterburta"
	icon_state = "fsmaint"

/area/maintenance/port
	name = "Tunel Techniczny Bakburta"
	icon_state = "pmaint"

/area/maintenance/port/central
	name = "Centralny Tunel Techniczny Bakburta"
	icon_state = "maintcentral"

/area/maintenance/port/aft
	name = "Górny Tunel Techniczny Bakburta"
	icon_state = "apmaint"

/area/maintenance/port/fore
	name = "Dolny Tunel Techniczny Bakburta"
	icon_state = "fpmaint"

/area/maintenance/disposal
	name = "Utylizacja Odpadów"
	icon_state = "disposal"

/area/maintenance/disposal/incinerator
	name = "Spalarnia"
	icon_state = "incinerator"


//Hallway

/area/hallway
	lighting_colour_tube = "#ffce99"
	lighting_colour_bulb = "#ffdbb4"
	lighting_brightness_tube = 8


/area/hallway/primary/aft
	name = "Dolny Główny Korytarz"
	icon_state = "hallA"

/area/hallway/primary/fore
	name = "Górny Główny Koryatrz"
	icon_state = "hallF"

/area/hallway/primary/starboard
	name = "Główny Korytarz Sterburta"
	icon_state = "hallS"

/area/hallway/primary/port
	name = "Główny Korytarz Bakburta"
	icon_state = "hallP"

/area/hallway/primary/central
	name = "Centralny Główny Korytarz"
	icon_state = "hallC"

/area/hallway/primary/upper
	name = "Górny Centralny Główny Korytarz"
	icon_state = "hallC"

/area/hallway/secondary/command
	name = "Korytarz Dowództwa"
	icon_state = "bridge_hallway"

/area/hallway/secondary/construction
	name = "Strefa Budowlana"
	icon_state = "construction"

/area/hallway/secondary/exit
	name = "Korytarz Prom Ratunkowy"
	icon_state = "escape"

/area/hallway/secondary/exit/departure_lounge
	name = "Hala Odlotów"
	icon_state = "escape_lounge"

/area/hallway/secondary/entry
	name = "Korytarz Hala Przylotów"
	icon_state = "entry"

/area/hallway/secondary/service
	name = "Korytarz Usług"
	icon_state = "hall_service"

//Command

/area/bridge
	name = "Mostek"
	icon_state = "bridge"
	ambient_effects = list('sound/ambience/signal.ogg')

	lighting_colour_tube = "#ffce99"
	lighting_colour_bulb = "#ffdbb4"
	lighting_brightness_tube = 8

/area/bridge/meeting_room
	name = "Sala Konferencyjna Dyrektorów Departamentów"
	icon_state = "meeting"

/area/bridge/meeting_room/council
	name = "Izba Rady"
	icon_state = "meeting"

/area/bridge/showroom/corporate
	name = "Sala Prezentacyjna"
	icon_state = "showroom"

/area/crew_quarters/heads/captain
	name = "Biuro Kapitana"
	icon_state = "captain"

/area/crew_quarters/heads/captain/private
	name = "Kwatera Kapitana"
	icon_state = "captain_private"

/area/crew_quarters/heads/chief
	name = "Biuro Majstra"
	icon_state = "ce_office"

/area/crew_quarters/heads/cmo
	name = "Biuro Ordynatora"
	icon_state = "cmo_office"

/area/crew_quarters/heads/hop
	name = "Biuro Głowy Personelu"
	icon_state = "hop_office"

/area/crew_quarters/heads/hos
	name = "Biuro Głowy Ochrony"
	icon_state = "hos_office"

/area/crew_quarters/heads/hor
	name = "Biuro Dyrektora Naukowego"
	icon_state = "rd_office"

/area/comms
	name = "Radiowęzeł"
	icon_state = "tcomsatcham"
	lighting_colour_tube = "#e2feff"
	lighting_colour_bulb = "#d5fcff"

/area/server
	name = "Serwerownia Systemu Wiadmości"
	icon_state = "server"

//Crew

/area/crew_quarters
	lighting_colour_tube = "#ffce99"
	lighting_colour_bulb = "#ffdbb4"
	lighting_brightness_tube = 8

/area/crew_quarters/dorms
	name = "Dormitoria"
	icon_state = "dorms"
	safe = TRUE
	mood_bonus = 3
	mood_message = "<span class='nicegreen'>There's no place like the dorms!\n</span>"

/area/crew_quarters/cryopods
	name = "Cryopod Room"
	safe = TRUE
	icon_state = "cryopod"
	lighting_colour_tube = "#e3ffff"
	lighting_colour_bulb = "#d5ffff"

/area/crew_quarters/dorms/barracks
	name = "Sypialnie"

/area/crew_quarters/dorms/barracks/male
	name = "Sypialnie Męskie"
	icon_state = "dorms_male"

/area/crew_quarters/dorms/barracks/female
	name = "Sypialnie Damskie"
	icon_state = "dorms_female"

/area/crew_quarters/toilet
	name = "Sala Sypialna Toaleta"
	icon_state = "toilet"
	lighting_colour_tube = "#e3ffff"
	lighting_colour_bulb = "#d5ffff"

/area/crew_quarters/toilet/auxiliary
	name = "Dodatkowa Toaleta"
	icon_state = "toilet"

/area/crew_quarters/toilet/locker
	name = "Szatnia Toaleta"
	icon_state = "toilet"

/area/crew_quarters/toilet/restrooms
	name = "Toalety"
	icon_state = "toilet"

/area/crew_quarters/locker
	name = "Szatnia"
	icon_state = "locker"

/area/crew_quarters/lounge
	name = "Hol"
	icon_state = "lounge"

/area/crew_quarters/fitness
	name = "Siłownia"
	icon_state = "fitness"

/area/crew_quarters/fitness/locker_room
	name = "Szatnia Dzielona"
	icon_state = "locker"

/area/crew_quarters/fitness/recreation
	name = "Obszar Rekreacji"
	icon_state = "fitness"

/area/crew_quarters/fitness/locker_room/male
	name = "Szatnia Męska"
	icon_state = "locker_male"

/area/crew_quarters/fitness/locker_room/female
	name = "Szatnia Damska"
	icon_state = "locker_female"


/area/crew_quarters/fitness/recreation
	name = "Strefa Wypoczynkowa"
	icon_state = "rec"

/area/crew_quarters/cafeteria
	name = "Kafeteria"
	icon_state = "cafeteria"

/area/crew_quarters/kitchen
	name = "Kuchnia"
	icon_state = "kitchen"
	lighting_colour_tube = "#e3ffff"
	lighting_colour_bulb = "#d5ffff"

/area/crew_quarters/kitchen/coldroom
	name = "Kuchnia Chłodnia"
	icon_state = "kitchen_cold"

/area/crew_quarters/bar
	name = "Bar"
	icon_state = "bar"
	mood_bonus = 5
	mood_message = "<span class='nicegreen'>Kocham przesiadywać w barze!\n</span>"
	lighting_colour_tube = "#fff4d6"
	lighting_colour_bulb = "#ffebc1"

/area/crew_quarters/bar/atrium
	name = "Atrium"
	icon_state = "bar"

/area/crew_quarters/electronic_marketing_den
	name = "Market Części Elektronicznych"
	icon_state = "abandoned_m_den"

/area/crew_quarters/abandoned_gambling_den
	name = "Opuszczona Szulernia"
	icon_state = "abandoned_g_den"

/area/crew_quarters/abandoned_gambling_den/secondary
	icon_state = "abandoned_g_den_2"

/area/crew_quarters/theatre
	name = "Teatr"
	icon_state = "theatre"

/area/crew_quarters/theatre/abandoned
	name = "Opuszczony Teatr"
	icon_state = "abandoned_theatre"

/area/library
	name = "Biblioteka"
	icon_state = "library"
	flags_1 = NONE

	lighting_colour_tube = "#ffce99"
	lighting_colour_bulb = "#ffdbb4"
	lighting_brightness_tube = 8

/area/library/lounge
	name = "Biblioteka Hol"
	icon_state = "library_lounge"

/area/library/abandoned
	name = "Opuszczona Biblioteka"
	icon_state = "library"
	flags_1 = NONE

/area/library/artgallery
	name = "Galeria Sztuki"
	icon_state = "library_gallery"

/area/library/private
	name = "Biblioteka Czytalnia"
	icon_state = "library_gallery_private"

/area/library/upper
	name = "Biblioteka Górne Piętro"
	icon_state = "library"

/area/library/printer
	name = "Biblioteka Drukarnia"
	icon_state = "library"

/area/library/abandoned
	name = "Opuszczona Biblioteka"
	icon_state = "abandoned_library"
	flags_1 = NONE

/area/chapel
	icon_state = "chapel"
	ambient_effects = HOLY
	flags_1 = NONE
	clockwork_warp_allowed = FALSE
	clockwork_warp_fail = "The consecration here prevents you from warping in."

/area/chapel/main
	name = "Kaplica"

/area/chapel/main/monastery
	name = "Klasztor"

/area/chapel/office
	name = "Biuro Kapelana"
	icon_state = "chapeloffice"

/area/chapel/asteroid
	name = "Kaplica Asterioidy"
	icon_state = "explored"

/area/chapel/asteroid/monastery
	name = "Klasztor Asteroidy"

/area/chapel/dock
	name = "Dok Kaplicy"
	icon_state = "construction"

/area/lawoffice
	name = "Biuro Prawnicze"
	icon_state = "law"


//Engineering

/area/engine
	ambient_effects = ENGINEERING
	lighting_colour_tube = "#ffce93"
	lighting_colour_bulb = "#ffbc6f"

/area/engine/engine_smes
	name = "Inżynieria SMES"
	icon_state = "engine_smes"

/area/engine/engineering
	name = "Inżynieria"
	icon_state = "engine"

/area/engine/atmos
	name = "Atmosferyka"
	icon_state = "atmos"
	flags_1 = NONE

/area/engine/atmos/upper
	name = "Górna Atmosferyka"

/area/engine/atmospherics_engine
	name = "Atmosferyka Silnik"
	icon_state = "atmos_engine"

/area/engine/engine_room //donut station specific
	name = "Maszynownia"
	icon_state = "atmos_engine"

/area/engine/lobby
	name = "Inżynieria Hol"
	icon_state = "engi_lobby"

/area/engine/engine_room/external
	name = "Supermateria Zewnętrzny Dostęp"
	icon_state = "engine_foyer"

/area/engine/supermatter
	name = "Reaktor Supermaterii"
	icon_state = "engine_sm"

/area/engine/break_room
	name = "Lobby Inżynierii"
	icon_state = "engine_break"
	mood_bonus = 2
	mood_message = "<span class='nicegreen'>Ahhh, dobrze zrobić sobie przerwę.\n</span>"

/area/engine/gravity_generator
	name = "Pomieszczenie Generatora Grawitacji"
	icon_state = "grav_gen"
	clockwork_warp_allowed = FALSE
	clockwork_warp_fail = "The gravitons generated here could throw off your warp's destination and possibly throw you into deep space."

/area/engine/storage
	name = "Inżynieria Magazyn"
	icon_state = "engi_storage"

/area/engine/storage_shared
	name = "Inżynieria Współdzielony Magazyn"
	icon_state = "engi_storage"

/area/engine/transit_tube
	name = "Tuba Przesyłowa"
	icon_state = "transit_tube"


//Solars

/area/solar
	requires_power = FALSE
	dynamic_lighting = DYNAMIC_LIGHTING_IFSTARLIGHT
	valid_territory = FALSE
	blob_allowed = FALSE
	flags_1 = NONE
	ambient_effects = ENGINEERING

/area/solar/fore
	name = "Górne Panele Słoneczne"
	icon_state = "yellow"

/area/solar/aft
	name = "Dolne Panele Słoneczne"
	icon_state = "yellow"

/area/solar/aux/port
	name = "Górne Dodatkowe Panele Słoneczne Bakburta"
	icon_state = "panelsA"

/area/solar/aux/starboard
	name = "Górne Dodatkowe Panele Słoneczne Sterburta"
	icon_state = "panelsA"

/area/solar/starboard
	name = "Panele Słoneczne Sterburta"
	icon_state = "panelsS"

/area/solar/starboard/aft
	name = "Dolne Panele Słoneczne Sterburta"
	icon_state = "panelsAS"

/area/solar/starboard/fore
	name = "Górne Panele Słoneczne Sterburta"
	icon_state = "panelsFS"

/area/solar/port
	name = "Panele Słoneczne Bakburta"
	icon_state = "panelsP"

/area/solar/port/aft
	name = "Dolne Panele Słoneczne Bakburta"
	icon_state = "panelsAP"

/area/solar/port/fore
	name = "Górne Panele Słoneczne Bakburta"
	icon_state = "panelsFP"

/area/solar/aisat
	name = "Panele Słoneczne Satelita AI"
	icon_state = "yellow"

//Solar Maint

/area/maintenance/solars
	name = "Tunel Techniczny Panele Słoneczne"
	icon_state = "yellow"

/area/maintenance/solars/port
	name = "Tunel Techniczny Panele Słoneczne Bakburta"
	icon_state = "SolarcontrolP"

/area/maintenance/solars/port/aft
	name = "Dolny Tunel Techniczny Panele Słoneczne Bakburta"
	icon_state = "SolarcontrolAP"

/area/maintenance/solars/port/fore
	name = "Górny Tunel Techniczny Panele Słoneczne Bakburta"
	icon_state = "SolarcontrolFP"

/area/maintenance/solars/starboard
	name = "Tunel Techniczny Panele Słoneczne Sterburta"
	icon_state = "SolarcontrolS"

/area/maintenance/solars/starboard/aft
	name = "Dolny Tunel Techniczny Panele Słoneczne Sterburta"
	icon_state = "SolarcontrolAS"

/area/maintenance/solars/starboard/fore
	name = "Górny Tunel Techniczny Panele Słoneczne Sterburta"
	icon_state = "SolarcontrolFS"

//Teleporter

/area/teleporter
	name = "Pomieszczenie Teleportera"
	icon_state = "teleporter"
	ambient_effects = ENGINEERING

/area/gateway
	name = "Brama"
	icon_state = "gateway"
	ambient_effects = ENGINEERING

//MedBay

/area/medical
	name = "Szpital"
	icon_state = "medbay3"
	ambient_effects = MEDICAL
	mood_bonus = 2
	mood_message = "<span class='nicegreen'>Czuję się tutaj bezpiecznie!\n</span>"
	lighting_colour_tube = "#e7f8ff"
	lighting_colour_bulb = "#d5f2ff"


/area/medical/abandoned
	name = "Opuszczony Szpital"
	icon_state = "medbay3"
	ambient_effects = list('sound/ambience/signal.ogg')

/area/medical/medbay/central
	name = "Szpital Głowny"
	icon_state = "med_central"

/area/medical/medbay/lobby
	name = "Szpital Hol"
	icon_state = "med_lobby"

	//Medbay is a large area, these additional areas help level out APC load.

/area/medical/medbay/zone2
	name = "Szpital"
	icon_state = "medbay2"

/area/medical/medbay/aft
	name = "Szpital Górny"
	icon_state = "med_aft"

/area/medical/storage
	name = "Szpital Magazyn"
	icon_state = "med_storage"

/area/medical/paramedic
	name = "Pomieszczenie Ratowników Medycznych"
	icon_state = "paramedic"

/area/medical/office
	name = "Gabinet Medyczny"
	icon_state = "med_office"

/area/medical/surgery/room_c
	name = "Sala Operacyjna C"
	icon_state = "surgery"

/area/medical/surgery/room_d
	name = "Sala Operacyjna D"
	icon_state = "surgery"

/area/medical/break_room
	name = "Szpital Pokój Socjalny"
	icon_state = "med_break"

/area/medical/coldroom
	name = "Szpital Chłodnia"
	icon_state = "kitchen_cold"

/area/medical/patients_rooms
	name = "Pokoje Pacjentów"
	icon_state = "patients"

/area/medical/patients_rooms/room_a
	name = "Pokój Pacjenta A"
	icon_state = "patients"

/area/medical/patients_rooms/room_b
	name = "Pokój Pacjenta B"
	icon_state = "patients"

/area/medical/virology
	name = "Wirologia"
	icon_state = "virology"
	flags_1 = NONE

/area/medical/morgue
	name = "Kostnica"
	icon_state = "morgue"
	ambient_effects = SPOOKY
	mood_bonus = -2
	mood_message = "<span class='warning'>It smells like death in here!\n</span>"

/area/medical/chemistry
	name = "Chemia"
	icon_state = "chem"

/area/medical/apothecary
	name = "Aptekarz"
	icon_state = "apothecary"

/area/medical/pharmacy
	name = "Farmaceutyka"
	icon_state = "pharmacy"

/area/medical/surgery
	name = "Chirurgia"
	icon_state = "surgery"

/area/medical/surgery/room_b
	name = "Sala Operacyjna B"
	icon_state = "surgery"

/area/medical/cryo
	name = "Kriogenika"
	icon_state = "cryo"

/area/medical/exam_room
	name = "Pomieszczenie Egzaminacyjne"
	icon_state = "exam_room"

/area/medical/genetics
	name = "Laboratorium Genetyczne"
	icon_state = "genetics"

/area/medical/genetics/cloning
	name = "Cloning Lab"
	icon_state = "cloning"

/area/medical/sleeper
	name = "Sala Medyczna"
	icon_state = "exam_room"

//Security

/area/security
	name = "Ochrona"
	icon_state = "security"
	ambient_effects = HIGHSEC
	lighting_colour_tube = "#ffeee2"
	lighting_colour_bulb = "#ffdfca"

/area/security/main
	name = "Biuro Ochrony"
	icon_state = "security"

/area/security/brig
	name = "Areszt"
	icon_state = "brig"
	mood_bonus = -3
	mood_message = "<span class='warning'>Nienawidzę ciasnych cel w areszcie.\n</span>"

/area/security/courtroom
	name = "Sala Sądowa"
	icon_state = "courtroom"

/area/security/prison
	name = "Skrzydło Więzienne"
	icon_state = "sec_prison"

/area/security/prison/toilet //radproof
	name = "Więzienie Toaleta"
	icon_state = "sec_prison_safe"

/area/security/prison/safe //radproof
	name = "Cele Więzienne"
	icon_state = "sec_prison_safe"

/area/security/prison/upper
	name = "Górne Skrzydło Więzienne"
	icon_state = "prison_upper"

/area/security/prison/visit
	name = "Pomieszczenie Odwiedzin"
	icon_state = "prison_visit"

/area/security/prison/rec
	name = "Więzienna Sala Przesłuchań"
	icon_state = "prison_rec"

/area/security/prison/mess
	name = "Więzienie Hol"
	icon_state = "prison_mess"

/area/security/prison/work
	name = "Więzienie Warsztat"
	icon_state = "prison_work"

/area/security/prison/shower
	name = "Więzienie Prysznic"
	icon_state = "prison_shower"

/area/security/prison/workout
	name = "Więzienie Siłownia"
	icon_state = "prison_workout"

/area/security/prison/garden
	name = "Więzienie Ogród"
	icon_state = "prison_garden"

/area/security/processing
	name = "Prom Kolonia Karna"
	icon_state = "sec_processing"

/area/security/processing/cremation
	name = "Ochrona Krematorium"
	icon_state = "sec_cremation"

/area/security/warden
	name = "Dowództwo Aresztu"
	icon_state = "warden"

/area/security/detectives_office
	name = "Biuro Detektywa"
	icon_state = "detective"
	ambient_effects = list('sound/ambience/ambidet1.ogg','sound/ambience/ambidet2.ogg','sound/ambience/ambidet3.ogg','sound/ambience/ambidet4.ogg')

/area/security/detectives_office/private_investigators_office
	name = "Biuro Prywatnego Detektywa"
	icon_state = "investigate_office"

/area/security/range
	name = "Strzelnica"
	icon_state = "firingrange"

/area/security/execution
	icon_state = "execution_room"
	mood_bonus = -5
	mood_message = "<span class='warning'>I feel a sense of impending doom.\n</span>"

/area/security/execution/transfer
	name = "Centrum Transferowe"
	icon_state = "sec_processing"

/area/security/execution/education
	name = "Sala Edukacji Więźniów"

/area/security/nuke_storage
	name = "Skarbiec"
	icon_state = "nuke_storage"

/area/ai_monitored/nuke_storage
	name = "Skarbiec"
	icon_state = "nuke_storage"

/area/security/checkpoint
	name = "Punkt Kontrolny Ochrony"
	icon_state = "checkpoint1"

/area/security/checkpoint/auxiliary
	icon_state = "checkpoint_aux"

/area/security/checkpoint/escape
	icon_state = "checkpoint_esc"

/area/security/checkpoint/supply
	name = "Posterunek Ochrony - Ładownia"
	icon_state = "checkpoint_supp"

/area/security/checkpoint/engineering
	name = "Posterunek Ochrony - Inżynieria"
	icon_state = "checkpoint_engi"

/area/security/checkpoint/medical
	name = "Posterunek Ochrony - Szpital"
	icon_state = "checkpoint_med"

/area/security/checkpoint/science
	name = "Posterunek Ochrony - Wydział Naukowy"
	icon_state = "checkpoint_sci"

/area/security/checkpoint/science/research
	name = "Posterunek Ochrony - Wydział Naukowy"
	icon_state = "checkpoint_res"

/area/security/checkpoint/customs
	name = "Urząd Celny"
	icon_state = "customs_point"

/area/security/checkpoint/customs/auxiliary
	icon_state = "customs_point_aux"


//Service

/area/quartermaster
	name = "Kwatermistrza"
	icon_state = "quart"
	lighting_colour_tube = "#ffe3cc"
	lighting_colour_bulb = "#ffdbb8"

/area/quartermaster/sorting
	name = "Biuro Pocztowe"
	icon_state = "cargo_delivery"

/area/quartermaster/warehouse
	name = "Magazyn"
	icon_state = "cargo_warehouse"

/area/quartermaster/warehouse/upper
	name = "Górny Magazyn"

/area/quartermaster/office
	name = "Biuro Ładowni"
	icon_state = "cargo_office"

/area/quartermaster/storage
	name = "Strefa Załadunku"
	icon_state = "cargo_bay"

/area/quartermaster/qm
	name = "Biuro Kwatermistrza"
	icon_state = "quart_office"

/area/quartermaster/qm/perch
	name = "Punkt Obserwacyjny Kwatermistrza"
	icon_state = "quart_perch"

/area/quartermaster/miningdock
	name = "Dok Górniczy"
	icon_state = "mining"

/area/quartermaster/miningoffice
	name = "Biuro Górnicze"
	icon_state = "mining"

/area/janitor
	name = "Schowek Sprzątacza"
	icon_state = "janitor"
	flags_1 = NONE
	mood_bonus = -1
	mood_message = "<span class='warning'>It feels dirty in here!\n</span>"

/area/hydroponics
	name = "Hydroponika"
	icon_state = "hydro"

/area/hydroponics/upper
	name = "Górna Hydroponika"
	icon_state = "hydro"

/area/hydroponics/garden
	name = "Ogród"
	icon_state = "garden"
	mood_bonus = 2
	mood_message = "<span class='nicegreen'>It's so peaceful in here!\n</span>"

/area/hydroponics/garden/abandoned
	name = "Opuszczony Ogród"
	icon_state = "abandoned_garden"

/area/hydroponics/garden/monastery
	name = "Ogród Klasztoru"
	icon_state = "hydro"


//Science

/area/science
	name = "Wydział Badawczy"
	icon_state = "toxlab"
	lighting_colour_tube = "#f0fbff"
	lighting_colour_bulb = "#e4f7ff"

/area/science/lab
	name = "Badania i Rozwój"
	icon_state = "research"

/area/science/xenobiology
	name = "Laboratorium Ksenobiologii"
	icon_state = "xenobio"

/area/science/shuttle
	name = "Shuttle Construction"
	lighting_colour_tube = "#ffe3cc"
	lighting_colour_bulb = "#ffdbb8"

/area/science/storage
	name = "Przechowalnia Toksyn"
	icon_state = "tox_storage"

/area/science/test_area
	valid_territory = FALSE
	name = "Obszar Testowania Toksyn"
	icon_state = "tox_test"

/area/science/mixing
	name = "Laboratorium Fuzji Toksyn"
	icon_state = "tox_mix"

/area/science/mixing/chamber
	name = "Komora Fuzji Toksyn"
	icon_state = "tox_mix_chamber"
	valid_territory = FALSE

/area/science/genetics
	name = "Laboratorium Genetyczne"
	icon_state = "geneticssci"

/area/science/misc_lab
	name = "Laboratorium Testowe"
	icon_state = "tox_misc"

/area/science/misc_lab/range
	name = "Obszar Testowania Wynalazków"
	icon_state = "tox_range"

/area/science/server
	name = "Serwerownia Wydziału Badawczego"
	icon_state = "server"

/area/science/explab
	name = "Laboratorium Eksperymentalne"
	icon_state = "exp_lab"

/area/science/robotics
	name = "Robotyka"
	icon_state = "robotics"

/area/science/robotics/mechbay
	name = "Zatoka Mechów"
	icon_state = "mechbay"

/area/science/robotics/lab
	name = "Laboratorium Robotyki"
	icon_state = "ass_line"

/area/science/research
	name = "Wydział Badawczy"
	icon_state = "science"

/area/science/research/abandoned
	name = "Opuszczone Laboratorium Badawcze"
	icon_state = "abandoned_sci"

/area/science/nanite
	name = "Laboratorium Nanitowe"
	icon_state = "nanite"

/area/science/shuttledock
	name = "Science Shuttle Dock"
	icon_state = "toxmisc"

//Storage

/area/storage/tools
	name = "Dodatkowy Skład Narzędziowy"
	icon_state = "tool_storage"

/area/storage/primary
	name = "Główny Skład Narzędziowy"
	icon_state = "primary_storage"

/area/storage/art
	name = "Skład Przyborów Plastycznych"
	icon_state = "art_storage"

/area/storage/tcom
	name = "Skład Urządzeń Telekomunikacyjnych"
	icon_state = "tcom"
	valid_territory = FALSE

/area/storage/eva
	name = "Skład EVA"
	icon_state = "eva"
	clockwork_warp_allowed = FALSE

/area/storage/emergency/starboard
	name = "Skład Ratunkowy Sterburta"
	icon_state = "emergency_storage"

/area/storage/emergency/port
	name = "Skład Ratunkowy Bakburta"
	icon_state = "emergency_storage"

/area/storage/tech
	name = "Skład Techniczny"
	icon_state = "aux_storage"

/area/storage/mining
	name = "Publiczny Skład Górniczy"
	icon_state = "mining"

//Construction

/area/construction
	name = "Strefa Budowlana"
	icon_state = "yellow"
	ambient_effects = ENGINEERING

/area/construction/mining/aux_base
	name = "Strefa Budowlana Bazy Dodatkowej"
	icon_state = "aux_base_construction"

/area/construction/storage_wing
	name = "Skrzydło Magazynowe"
	icon_state = "storage_wing"

// Vacant Rooms
/area/vacant_room
	name = "Wolne Pomieszczenie"
	icon_state = "yellow"
	ambient_effects = MAINTENANCE

/area/vacant_room/office
	name = "Wolne Biuro"
	icon_state = "vacant_office"

/area/vacant_room/commissary
	name = "Wolna Kantyna"
	icon_state = "vacant_commissary"

//AI

/area/ai_monitored/security/armory
	name = "Zbrojownia"
	icon_state = "armory"
	ambient_effects = HIGHSEC

/area/ai_monitored/security/armory/upper
	name = "Górna Zbrojownia"

/area/ai_monitored/storage/eva
	name = "Skład EVA"
	icon_state = "eva"
	ambient_effects = HIGHSEC

/area/ai_monitored/storage/satellite
	name = "Tunel Techniczny Satelity AI"
	icon_state = "storage"
	ambient_effects = HIGHSEC

	//Turret_protected

/area/ai_monitored/turret_protected
	ambient_effects = list('sound/ambience/ambimalf.ogg', 'sound/ambience/ambitech.ogg', 'sound/ambience/ambitech2.ogg', 'sound/ambience/ambiatmos.ogg', 'sound/ambience/ambiatmos2.ogg')

/area/ai_monitored/turret_protected/ai_upload
	name = "Komora Zgrywania AI"
	icon_state = "ai_upload"

/area/ai_monitored/turret_protected/ai_upload_foyer
	name = "Śluza Komory Zgrywania AI"
	icon_state = "ai_upload_foyer"

/area/ai_monitored/turret_protected/ai
	name = "Komora AI"
	icon_state = "ai_chamber"

/area/ai_monitored/turret_protected/aisat
	name = "Satelita AI"
	icon_state = "ai"

/area/ai_monitored/turret_protected/aisat/atmos
	name = "Satelita AI Atmosferyka"
	icon_state = "ai"

/area/ai_monitored/turret_protected/aisat/foyer
	name = "Satelita AI Hol"
	icon_state = "ai_foyer"

/area/ai_monitored/turret_protected/aisat/service
	name = "Satelita AI Serwis"
	icon_state = "ai"

/area/ai_monitored/turret_protected/aisat/hallway
	name = "Satelita AI Korytarz"
	icon_state = "ai"

/area/aisat
	name = "Satelita AI Powłoka"
	icon_state = "ai"

/area/ai_monitored/turret_protected/aisat_interior
	name = "Satelita AI Wejście"
	icon_state = "ai_interior"

/area/ai_monitored/turret_protected/AIsatextAS
	name = "Satelita AI Wyjście"
	icon_state = "ai_sat_east"

/area/ai_monitored/turret_protected/AIsatextAP
	name = "Satelita AI Wyjście"
	icon_state = "ai_sat_west"


// Telecommunications Satellite

/area/tcommsat
	clockwork_warp_allowed = FALSE
	clockwork_warp_fail = "For safety reasons, warping here is disallowed; the radio and bluespace noise could cause catastrophic results."
	ambient_effects = list('sound/ambience/ambisin2.ogg', 'sound/ambience/signal.ogg', 'sound/ambience/signal.ogg', 'sound/ambience/ambigen10.ogg', 'sound/ambience/ambitech.ogg',\
											'sound/ambience/ambitech2.ogg', 'sound/ambience/ambitech3.ogg', 'sound/ambience/ambimystery.ogg')

/area/tcommsat/computer
	name = "Pomieszczenie Kontrolne Telekomunikacji"
	icon_state = "tcomsatcomp"

/area/tcommsat/server
	name = "Serwerownia Telekomunikacji"
	icon_state = "tcomsatcham"

 // AQUILA EDIT
/area/bluespace_locker
	name = "Bluespace Locker"
	icon_state = "away"
	requires_power = FALSE
	has_gravity = STANDARD_GRAVITY
	dynamic_lighting = DYNAMIC_LIGHTING_FORCED
	// AQUILA EDIT END
