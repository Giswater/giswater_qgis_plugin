/*
This file is part of Giswater
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
*/


SET search_path = SCHEMA_NAME, public, pg_catalog;
UPDATE config_toolbox AS t SET alias = v.alias, observ = v.observ FROM (
	VALUES
	(2202, 'Sprawdź przecięte łuki', NULL),
    (2204, 'Sprawdź łuki z odwróconym nachyleniem', NULL),
    (2206, 'Sprawdź węzły - znajdź exit-arcs nad entry-arcs', NULL),
    (2208, 'Sprawdź węzły z więcej niż jednym wyjściem', NULL),
    (2210, 'Węzły kontrolne jako odpływ', NULL),
    (2212, 'Sprawdzanie spójności topologicznej węzła', NULL),
    (2431, 'Sprawdź dane zgodnie z zasadami EPA', NULL),
    (2496, 'Naprawa łuku', NULL),
    (2986, 'Spójność nachylenia', NULL),
    (3064, 'Sprawdź wartości wysokości węzłów', NULL),
    (3066, 'Sprawdź wartości wysokości łuków', NULL),
    (3100, 'Zarządzanie wartościami hydrologicznymi', NULL),
    (3102, 'Zarządzanie wartościami Dwf', NULL),
    (3118, 'Utwórz scenariusz Dscenario z wartościami z ToC', NULL),
    (3176, 'Odcinki przewodów sterujących', NULL),
    (3186, 'Ustaw skrzyżowania jako wylot', NULL),
    (3242, 'Ustaw optymalny wylot dla zlewni cząstkowych', NULL),
    (3290, 'Utwórz pusty scenariusz Hydrology', NULL),
    (3292, 'Utwórz pusty scenariusz DWF', NULL),
    (3294, 'Zduplikowany scenariusz hydrologiczny', NULL),
    (3296, 'Scenariusz zduplikowanego pliku DWF', NULL),
    (3326, 'Oblicz wydajność hydrauliczną dla określonego wyniku', NULL),
    (3360, 'Tworzenie zlewni Thyssen', NULL),
    (3424, 'Analiza typu płynu', NULL),
    (3492, 'Analiza Omunit', NULL),
    (2102, 'Sprawdź łuki bez początku/końca węzła', NULL),
    (2104, 'Sprawdź łuki z tym samym węzłem początkowym/końcowym', NULL),
    (2106, 'Sprawdź zduplikowane połączenia', NULL),
    (2108, 'Sprawdź zduplikowane węzły', NULL),
    (2110, 'Sprawdź osierocone węzły', NULL),
    (2118, 'Tworzenie węzłów przy użyciu wierzchołków początkowych i końcowych łuków', NULL),
    (2436, 'Sprawdź dane planu', NULL),
    (2670, 'Sprawdzanie danych dla procesu o&m', NULL),
    (2760, 'Pobieranie wartości z rastrowego DEM', NULL),
    (2768, 'Analiza mapzones', NULL),
    (2772, 'Analiza śledzenia przepływu', NULL),
    (2776, 'Sprawdź konfigurację backendu', NULL),
    (2826, 'Liniowy układ odniesienia', NULL),
    (2890, 'Koszt odbudowy i wartości amortyzacji', NULL),
    (2922, 'Resetowanie profilu użytkownika', NULL),
    (2998, 'Dane kontrolne użytkownika', NULL),
    (3008, 'Odwrócony łuk', NULL),
    (3040, 'Sprawdź zduplikowane łuki', NULL),
    (3042, 'Zarządzanie wartościami scenariusza', NULL),
    (3052, 'Arcs shorter/bigger than specific length', NULL),
    (3080, 'Napraw zduplikowane węzły (jeden po drugim)', NULL),
    (3130, 'Topocontrol do migracji danych', NULL),
    (3134, 'Tworzenie pustego scenariusza Dscenario', NULL),
    (3156, 'Duplikat dscenario', NULL),
    (3172, 'Sprawdź węzły T kandydatów', NULL),
    (3198, 'Pobieranie wartości adresu od najbliższego numeru ulicy', NULL),
    (3280, 'Masowa aktualizacja rotacji węzłów', NULL),
    (3284, 'Połączenie dwóch lub więcej sektorów w jeden', NULL),
    (3336, 'Analiza makrosektora', NULL),
    (3426, 'Integracja kampanii z produkcją', NULL),
    (3482, 'Analiza makromapozonów', NULL)
) AS v(id, alias, observ)
WHERE t.id = v.id;

