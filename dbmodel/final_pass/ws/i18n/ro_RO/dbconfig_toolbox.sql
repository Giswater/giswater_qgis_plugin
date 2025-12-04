/*
This file is part of Giswater
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
*/


SET search_path = SCHEMA_NAME, public, pg_catalog;
UPDATE config_toolbox AS t SET alias = v.alias, observ = v.observ FROM (
	VALUES
	(2102, 'Verificarea arcurilor fără nod de început/ sfârșit', NULL),
    (2104, 'Verificați arcele cu același nod de început/ sfârșit', NULL),
    (2106, 'Verificarea conexiunilor duplicate', NULL),
    (2108, 'Verificarea nodurilor duplicate', NULL),
    (2110, 'Verificarea nodurilor orfane', NULL),
    (2118, 'Construiți noduri folosind arcuri de început și de sfârșit', NULL),
    (2436, 'Verificarea datelor planului', NULL),
    (2670, 'Verificarea datelor pentru procesul o&m', NULL),
    (2760, 'Obținerea valorilor din rasterul DEM', NULL),
    (2768, 'Analiza Mapzones', NULL),
    (2772, 'Analiza urmei fluxului', NULL),
    (2776, 'Verificați configurația backend', NULL),
    (2826, 'Sistem de referință liniar', NULL),
    (2890, 'Costuri de reconstrucție și valori de amortizare', NULL),
    (2922, 'Resetați profilul utilizatorului', NULL),
    (2998, 'Datele de verificare ale utilizatorului', NULL),
    (3008, 'Arc invers', NULL),
    (3040, 'Verificarea arcurilor duplicate', NULL),
    (3042, 'Gestionarea valorilor Dscenario', NULL),
    (3052, 'Arcuri mai scurte/mai mari decât lungimea specifică', NULL),
    (3080, 'Repararea nodurilor duplicate (unul câte unul)', NULL),
    (3130, 'Topocontrol pentru migrarea datelor', NULL),
    (3134, 'Creați Dscenario gol', NULL),
    (3156, 'Duplicați dscenario', NULL),
    (3172, 'Verificarea nodurilor T candidate', NULL),
    (3198, 'Obțineți valorile adresei de la cel mai apropiat număr de stradă', NULL),
    (3280, 'Actualizare masivă a rotației nodurilor', NULL),
    (3284, 'Fuzionarea a două sau mai multe psectoare într-unul singur', NULL),
    (3336, 'Analiza macrosectorială', NULL),
    (3426, 'Integrarea campaniei în producție', NULL),
    (3482, 'Analiza macromapzonelor', NULL),
    (2302, 'Verificarea coerenței topologice a nodurilor', NULL),
    (2430, 'Verificarea datelor în conformitate cu normele EPA', NULL),
    (2496, 'Reconectați arcele cu nodurile cele mai apropiate', NULL),
    (2706, 'Analiza minisectorială', NULL),
    (2790, 'Verificarea datelor pentru procesul graphanalytics', NULL),
    (2970, 'Configurați zonele hărții', NULL),
    (3108, 'Crearea Dscenarului de rețea din ToC', NULL),
    (3110, 'Crearea unui scenariu al cererii din CRM', NULL),
    (3112, 'Crearea Dscenarului cererii din ToC', NULL),
    (3142, 'Bilanțul de apă în funcție de exploatare și perioadă', NULL),
    (3158, 'Crearea supapei dscenario din mincut', NULL),
    (3160, 'Calculați raza de acțiune a hidranților', 'Funcția necesită date privind străzile introduse în tabelul om_streetaxis, unde fiecare stradă este împărțită în linii scurte între intersecții.'),
    (3236, 'Afișați tăieturile curente', NULL),
    (3256, 'Analiza Netscenario Mapzones', NULL),
    (3258, 'Setarea valorilor modelului la cerere dscenario', NULL),
    (3260, 'Crearea unui Netscenario gol', NULL),
    (3262, 'Crearea unui scenariu net din ToC', NULL),
    (3264, 'Duplicate Netscenario', NULL),
    (3268, 'Setarea valorilor initlevel din simularea executată', NULL),
    (3308, 'Crearea rețelei complete dscenario', NULL),
    (3322, 'Stabilirea costului pentru materialul eliminat pe psectoare', NULL)
) AS v(id, alias, observ)
WHERE t.id = v.id;

