/*
This file is part of Giswater
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
*/


SET search_path = SCHEMA_NAME, public, pg_catalog;
UPDATE config_toolbox AS t SET alias = v.alias, observ = v.observ FROM (
	VALUES
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
    (3482, 'Analiza makromapozonów', NULL),
    (2302, 'Sprawdzanie spójności topologicznej węzła', NULL),
    (2430, 'Sprawdź dane zgodnie z zasadami EPA', NULL),
    (2496, 'Połącz ponownie łuki z najbliższymi węzłami', NULL),
    (2706, 'Analiza minsektorowa', NULL),
    (2790, 'Sprawdź dane dla procesu analizy graficznej', NULL),
    (2970, 'Konfiguracja stref mapy', NULL),
    (3108, 'Tworzenie scenariusza sieciowego na podstawie ToC', NULL),
    (3110, 'Tworzenie scenariusza popytu z CRM', NULL),
    (3112, 'Tworzenie scenariusza popytu na podstawie ToC', NULL),
    (3142, 'Bilans wodny według eksploatacji i okresu', NULL),
    (3158, 'Utwórz scenariusz zaworu z mincut', NULL),
    (3160, 'Oblicz zasięg hydrantów', 'Funkcja wymaga danych ulicy wstawionych do tabeli om_streetaxis, gdzie każda ulica jest podzielona na krótkie linie między skrzyżowaniami.'),
    (3236, 'Pokaż bieżące przycięcia', NULL),
    (3256, 'Analiza scenariusza sieciowego Mapzones', NULL),
    (3258, 'Ustawianie wartości wzorca na żądanie dscenario', NULL),
    (3260, 'Utwórz pusty scenariusz sieciowy', NULL),
    (3262, 'Tworzenie scenariusza sieciowego na podstawie ToC', NULL),
    (3264, 'Duplikat scenariusza sieciowego', NULL),
    (3268, 'Ustaw wartości initlevel z wykonanej symulacji', NULL),
    (3308, 'Utwórz pełny scenariusz sieciowy', NULL),
    (3322, 'Ustaw koszt usuniętego materiału na sektorach', NULL)
) AS v(id, alias, observ)
WHERE t.id = v.id;

