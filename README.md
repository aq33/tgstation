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

Jeżeli czegoś nie wiesz/nie rozumiesz to poinformuj nas na kanale #koding.
Tu jest też link do ogólnego Discorda (anglojęzycznego) związanego z programowaniem SS13: https://discord.gg/Vh8TJp9

## LICENSE

All code after [commit 333c566b88108de218d882840e61928a9b759d8f on 2014/31/12 at 4:38 PM PST](https://github.com/tgstation/tgstation/commit/333c566b88108de218d882840e61928a9b759d8f) is licensed under [GNU AGPL v3](https://www.gnu.org/licenses/agpl-3.0.html).

All code before [commit 333c566b88108de218d882840e61928a9b759d8f on 2014/31/12 at 4:38 PM PST](https://github.com/tgstation/tgstation/commit/333c566b88108de218d882840e61928a9b759d8f) is licensed under [GNU GPL v3](https://www.gnu.org/licenses/gpl-3.0.html).
(Including tools unless their readme specifies otherwise.)

See LICENSE and GPLv3.txt for more details.

The TGS3 API is licensed as a subproject under the MIT license.

See the footers of code/\_\_DEFINES/server\_tools.dm, code/modules/server\_tools/st\_commands.dm, and code/modules/server\_tools/st\_inteface.dm for the MIT license.

All assets including icons and sound are under a [Creative Commons 3.0 BY-SA license](https://creativecommons.org/licenses/by-sa/3.0/) unless otherwise indicated.
