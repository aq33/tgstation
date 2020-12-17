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

/datum/ambition_template/mi13
	name = "Operator MI13"
	narrative = "Jako operator MI13 twoim celem jest cicha infiltracja placówki. Jesteś jedynym agentem wysłanym przez tę komórkę Syndykatu do wykonania tego zadania. Nikt nigdy nie może dowiedzieć się o tym zleceniu"
	objectives = list("Wykradnij najnowsze zdobycze technologiczne stacji")
	tips = list("Celem są unikatowe technologie jak Hypospray, prototypowy pistolet kapitana, czy reaktywny pancerz", "Za istotne dla misji może zostać uznana jakakolwiek zaawansowana technologia opracowana przez stację. Broń plazmowa, zaawansowane eksktrakty szlamów, technologia teleportacji. Wszystko co może przydać się Syndykatowi w przyszłości", "Ogranicz wybór wyposażenia do ukrytej broni i przedmiotów maskujących")

/datum/ambition_template/waffle
	name = "Operator Waffle Corporation"
	narrative = "Twoim przełożonym nie podobają się komunistyczne zapędy Nanotrasen w sprawowaniu kontroli nad stacją. Niedopuszczalna jest też dominacja rynku na SS13 przez Donk Corporation. Spraw by kapitalizm po raz kolejny zwyciężył z czerwoną zarazą. Dokonaj tego dierżąc w dłoni produkty Waffle.Co"
	objectives = list("Zniszcz obecne struktury zarządzania", "Upowszechnij poglądy Syndykatu")
	tips = list("Pozbąć się głów personelu i sam przejmij kontrolę nad stacją", "Znajdź sobie sojuszników, będziesz ich potrzebować w realizacji tego celu", "Staraj się obnażyć wszelkie błedy postępowania zarządu stacji", "Chaos, dezinformacja i podżeganie załogi to twoi najwięksi przyjaciele")

/datum/ambition_template/tiger
	name = "Operator Tiger Cooperative"
	narrative = "Lata indoktrynacji w religijnym kulcie podążającym za naukami tajemniczych Exoliticów na stałe ukształtowały w tobie sposób postrzegania świata. Jedyną drogą ku zbawieniu jest ofiara i poświęcenie. Zapisz się na stałe w annałach pokazując swoim braciom i siostrom jak bardzo jesteś oddany sprawie"
	objectives = list("Spraw by wszyscy się o tobie dowiedzieli", "Zgiń bohaterską śmiercią")
	tips = list("Porwij ważnego członka załogi, wszyscy przejmą się zniknięciem Iana", "Zrób ze swojej śmierci show i zabierz ze sobą w zaświaty jak najwięcej osób", "Obserwuj i szukaj okazji, by zaistnieć w świadomości załogantów. Wykorzystaj moment i odejdź z hukiem")

/datum/ambition_template/gorlex
	name= "Operator Gorlex Marauders"
	narrative = "Gorlex Marauder to ojcowie założyciele Syndykatu. Dalej wierni pierwotnej wizji działalności tej organizacji, preferują zdobycze technologiczne i konwencjonalną walkę z Nanotrasenem ponad wszystko. Działaj zgodnie z ich schedą i niech tradycji stanie się zadość"
	objectives = list("Zniszcz SS13", "Porwij prom ratunkowy")
	tips = list("Doprowadź do poważnej awarii silnika stacji. To najbardziej sprawdzony sposób na destrukcję stacji", "Skontaktuj się z inymi agentami i razem skoordynujcie działalność wywrotową", "Zaopatrz się w bomby. Jeśli nie masz dostępu do toksyn, sprawdzi się klasyczna bomba Syndykatu", "Najtańszą metodą będzie zalanie stacji plazmą lub zaopatrzenie się w broń zasięgową i wystrzelanie załogi")

/datum/ambition_template/arc
	name = "Członek Animal Rights Consortium"
	narrative = "ARC to spadkobiercy pewnej antycznej organizacji o nazwie PETA. ARC jest jednak bardziej zradykalizowana w działaniach. W ramach walki o godne traktowanie zwierząt, ich działacze coraz częściej zaczynali sięgać po środki ostateczne. Jako wieloletni członek w myśl ich przkonaniom masz zamiar wyzwolić wszystkie zwierzęta na stacji spod jarzma bezdusznej korporacji"
	objectives = list("Uwolnij wszystkie zwierzęta na stacji")
	tips = list("Ewakuuj wszystkie maskotki departamentów", "Wypuść szlamy na wolność", "Zamień stację w rezerwat przyrody dla zagrożonych gatunków z Lavalandu")

/datum/ambition_template/donk
	name = "Operator Donk Corporation"
	narrative = "Donk.Co jako jedyna frakcja Syndykatu faktyczną potęge. Posiadając liczne kolonie i kontrolując miedzyplanetarne rządy, wojna między nimi a NAnotrasen coraz bardziej wygasa. W ostatnim czasie wiodącą strategią jest wykupwanie sobie wysoko postawionych urzędników i oferowanie swojej pomocy w formie najemnictwa. Nanotrasen nieoficjalnie zatrudnił cie do ochrony stacji przed zagrożeniami i innymi agentami. Jednakże nie pracujesz dla NT, nie obowiązują cie żadne prawa i to jak \"ochronisz\" stację zależy tylko od własnego kodeksu."
	objectives = list("Ochroń stację przed zagrożeniami")
	tips = list("Zatrudnij się w ochronie i pokaż wszystkim jak pałką zaprowadzić porządek", "Pozbywaj się wszelkich patologicznych elementów. Procesy to korporacyjny mit. Na tej stacji rządzi prawo spluwy", "Kapitan zagraża stacji swoimi działaniami? Obal go i sam pokieruj stacją", "Cargo znów się zbroi? Pozbądź się całego departamentu. Eliiminacja zagrożeń wymaga poświęceń")

