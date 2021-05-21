# Aquila Station 13

* **Discord:** https://discord.gg/66DeZmB

## Zgłaszanie bugów lub sugestii

Jeżeli chcesz zgłosić buga, lub zasugerować nową zmianę to zrób to w zakładce Issues.

## Ważne
Jeżeli robisz wiele PR z twojego forka, z różnych branchów, to muszą te branche być bazowane na naszym masterze, a nie na twoich innych branchach.
W innym przypadku jeden branch może nanosić 2 PRy.

Każdy otwarty PR, będzie aktywnie rozpatrywany przez administrację pod względem merge lub test merge,
dlatego jeżeli uważasz, że PR nie jest gotowy do merge, zamień go w draft PR (guzik jest na prawo pod sekcją reviewers).
Tak samo administracja może w dowolnym momencie przekonwertować twój PR w draft, pisząc co jest do poprawy.
Wtedy spowrotem zmień PR w normalny, jeżeli uważasz, że naprawiłeś wskazane błędy i twój PR jest znowu gotowy do merge.

Na dodatek, administracja zakłada, że każdy non-draft PR, był bardzo ogólnie przetestowany na lokalnym serwerze.
PRy które przez długi czas są w stanie drafta, mogą być zamknięte z powodu braku aktywności, możesz w dowolnej chwili otworzyć taki PR ponownie.
PRy które zostaną odrzucone ze względu na swój pomysł/funkcjonalność, mogą zostać zamknięte permanentnie.

Gdy masz już gotowy i otwarty PR, musi on przejść testy automatyczne, oraz code review.
Jeżeli test automatyczny failuje i nie wiesz dlaczego, możesz wejść w details i zobaczyć logi, gdzie znajdziesz konkretny błąd.

## Modularyzacja
Od rebase teraz stosujemy nową metode co do wprowadzania zmian, polega ona na dodawaniu nowego folderu w modular_aquila/modules. W tym folderze jest EXAMPLE_MODULE a w nim plik readme.dm. ![modularyzacja guide 1](https://user-images.githubusercontent.com/60329232/113522111-5fd38080-959e-11eb-93df-6adc94a06947.png) 
Po zrobieniu folderu głównego twoich zmian dodaj foldery osobne dla code/icons/sounds, czyli jak tylko coś od kodu to tylko code przykładowo. Jeżeli twoja zmiana nie jest tak spora by robić osobne pliki to robisz tak jak na zdjęciu poniżej;![modularyzacja guide 2](https://user-images.githubusercontent.com/60329232/113522310-af667c00-959f-11eb-9eb6-0c28c98d95ef.png) lub; ![modularyzacja guide 3](https://user-images.githubusercontent.com/60329232/113522328-d624b280-959f-11eb-96d8-4c36f7863fda.png) Sprite wymagają nowych osobnych plików, jeżeli dany plik dmi jest używany przez wiele innych objektów i jest łatwiej zamienić jedną ścieżke niż dodać mase nowych to dodaj takie coś przy zmienionych sprite;
![modularyzacja guide 5](https://user-images.githubusercontent.com/60329232/113522574-edfd3600-95a1-11eb-8dfd-6d44e7e8ab8e.png)
## Twój PR musi się stosować do zasad modularyzacji jak chcesz by twoja zmiana nie została odrzucona odrazu.


## Pomoc w tłumaczeniu/programowaniu

Jeżeli chcesz pomóc to najpierw wybierz issue którym chcesz się zając, napisz tam, ze ty zajmiesz się np. jakimś konkretnym plikiem, lub całym issue, itd.
Najłatwiejsze issues to te z labelem "tweak", "tłumaczenie", "grafika" i "dźwięk".
Wtedy zforkuj te repozytorium, i tam nanieś zmiany tworząc commity (nie branche),
pliki można też edytować z poziomu strony. Gdy chcesz zaproponować złączenie twojego forka do głównego repo,
utwórz PR (pull request).
Twój PR musi mieć wypełnioną formę changeloga, przykładowy changelog:
```
:cl:
add: dodano coś tam, można go zrobić z czegoś tam
fix: naprawiono jakiś bug
/:cl:
```
Twój PR będzie wtedy sprawdzany przez automatyczne testy pod względem literówek itd.
Jeżeli chcesz nanosić zmiany na swoim kompie, będziesz musiał użyć programu jak np. Git Bash lub Github Desktop.

Do programowania polecam Visual Studio Code i wtedy otworzenie workspace, pokaże to zalecane pluginy które bardzo ułatwiają pracę z Byondem.

<<<<<<< HEAD
Jeżeli czegoś nie wiesz/nie rozumiesz to poinformuj nas na kanale #koding.
Tu jest też link do ogólnego Discorda (anglojęzycznego) związanego z programowaniem SS13: https://discord.gg/Vh8TJp9
=======
* [DeltaStation (default)](https://wiki.beestation13.com/view/DeltaStation)
* [BoxStation](https://wiki.beestation13.com/view/Boxstation)
* [MetaStation](https://wiki.beestation13.com/view/MetaStation)
* [PubbyStation](https://wiki.beestation13.com/view/PubbyStation)


All maps have their own code file that is in the base of the _maps directory. Maps are loaded dynamically when the game starts. Follow this guideline when adding your own map, to your fork, for easy compatibility.

The map that will be loaded for the upcoming round is determined by reading data/next_map.json, which is a copy of the json files found in the _maps tree. If this file does not exist, the default map from config/maps.txt will be loaded. Failing that, BoxStation will be loaded. If you want to set a specific map to load next round you can use the Change Map verb in game before restarting the server or copy a json from _maps to data/next_map.json before starting the server. Also, for debugging purposes, ticking a corresponding map's code file in Dream Maker will force that map to load every round.

If you are hosting a server, and want randomly picked maps to be played each round, you can enable map rotation in [config.txt](config/config.txt) and then set the maps to be picked in the [maps.txt](config/maps.txt) file.

Anytime you want to make changes to a map it's imperative you use the [Map Merging tools](https://wiki.beestation13.com/view/Map_Merger)

## AWAY MISSIONS

BeeStation supports loading away missions however they are disabled by default.

Map files for away missions are located in the _maps/RandomZLevels directory. Each away mission includes it's own code definitions located in /code/modules/awaymissions/mission_code. These files must be included and compiled with the server beforehand otherwise the server will crash upon trying to load away missions that lack their code.

To enable an away mission open `config/awaymissionconfig.txt` and uncomment one of the .dmm lines by removing the #. If more than one away mission is uncommented then the away mission loader will randomly select one the enabled ones to load.

## SQL SETUP

The SQL backend requires a Mariadb server running 10.2 or later. Mysql is not supported but Mariadb is a drop in replacement for mysql. SQL is required for the library, stats tracking, admin notes, and job-only bans, among other features, mostly related to server administration. Your server details go in /config/dbconfig.txt, and the SQL schema is in /SQL/beestation_schema.sql and /SQL/beestation_schema_prefix.sql depending on if you want table prefixes.  More detailed setup instructions are located here: https://wiki.beestation13.com/view/Downloading_the_source_code#Setting_up_the_database

If you are hosting a testing server on windows you can use a standalone version of MariaDB pre load with a blank (but initialized) tgdb database. Find them here: https://tgstation13.download/database/ Just unzip and run for a working (but insecure) database server. Includes a zipped copy of the data folder for easy resetting back to square one.

## WEB/CDN RESOURCE DELIVERY

Web delivery of game resources makes it quicker for players to join and reduces some of the stress on the game server.

1. Edit compile_options.dm to set the `PRELOAD_RSC` define to `0`
1. Add a url to config/external_rsc_urls pointing to a .zip file containing the .rsc.
    * If you keep up to date with BeeStation you could reuse our rsc cdn at http://rsc.beestation13.buzz/beestation.zip. Otherwise you can use cdn services like CDN77 or cloudflare (requires adding a page rule to enable caching of the zip), or roll your own cdn using route 53 and vps providers.
	* Regardless even offloading the rsc to a website without a CDN will be a massive improvement over the in game system for transferring files.

## IRC BOT SETUP

Included in the repository is a python3 compatible IRC bot capable of relaying adminhelps to a specified
IRC channel/server, see the /tools/minibot folder for more

## CONTRIBUTING

Please see [CONTRIBUTING.md](.github/CONTRIBUTING.md)
>>>>>>> 1fe04b8a5a... Removes donutstation (#4174)

## LICENSE

All code after [commit 333c566b88108de218d882840e61928a9b759d8f on 2014/31/12 at 4:38 PM PST](https://github.com/tgstation/tgstation/commit/333c566b88108de218d882840e61928a9b759d8f) is licensed under [GNU AGPL v3](https://www.gnu.org/licenses/agpl-3.0.html).

All code before [commit 333c566b88108de218d882840e61928a9b759d8f on 2014/31/12 at 4:38 PM PST](https://github.com/tgstation/tgstation/commit/333c566b88108de218d882840e61928a9b759d8f) is licensed under [GNU GPL v3](https://www.gnu.org/licenses/gpl-3.0.html).
(Including tools unless their readme specifies otherwise.)

See LICENSE and GPLv3.txt for more details.

The TGS3 API is licensed as a subproject under the MIT license.

See the footers of code/\_\_DEFINES/server\_tools.dm, code/modules/server\_tools/st\_commands.dm, and code/modules/server\_tools/st\_inteface.dm for the MIT license.

All assets including icons and sound are under a [Creative Commons 3.0 BY-SA license](https://creativecommons.org/licenses/by-sa/3.0/) unless otherwise indicated.
