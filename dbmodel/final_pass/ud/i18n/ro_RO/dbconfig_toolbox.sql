/*
This file is part of Giswater
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
*/


SET search_path = SCHEMA_NAME, public, pg_catalog;
UPDATE config_toolbox AS t SET alias = v.alias, observ = v.observ FROM (
	VALUES
	(2202, 'Verificați arcele intersectate', NULL),
    (2204, 'Verificarea arcurilor cu panta inversată', NULL),
    (2206, 'Verificarea nodurilor - găsirea arcurilor de ieșire în locul arcurilor de intrare', NULL),
    (2208, 'Verificarea nodurilor cu mai mult de o ieșire', NULL),
    (2210, 'Verificați nodurile ca o ieșire', NULL),
    (2212, 'Verificarea coerenței topologice a nodurilor', NULL),
    (2431, 'Verificarea datelor în conformitate cu normele EPA', NULL),
    (2496, 'Repararea arcului', NULL),
    (2986, 'Consistența pantei', NULL),
    (3064, 'Verificarea valorilor elevației nodurilor', NULL),
    (3066, 'Verificarea valorilor elevației arcurilor', NULL),
    (3100, 'Gestionarea valorilor hidrologice', NULL),
    (3102, 'Gestionarea valorilor Dwf', NULL),
    (3118, 'Creați Dscenario cu valorile din ToC', NULL),
    (3176, 'Secțiuni de conducte de control', NULL),
    (3186, 'Setați joncțiunile ca ieșire', NULL),
    (3242, 'Stabilirea ieșirii optime pentru subtraversări', NULL),
    (3290, 'Creați un scenariu hidrologic gol', NULL),
    (3292, 'Creați un scenariu DWF gol', NULL),
    (3294, 'Scenariu hidrologic duplicat', NULL),
    (3296, 'Scenariu DWF duplicat', NULL),
    (3326, 'Calculați performanța hidraulică pentru un rezultat specific', NULL),
    (3360, 'Crearea subtraversărilor Thyssen', NULL),
    (3424, 'Analiza tipului de fluid', NULL),
    (3492, 'Analiza Omunit', NULL),
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
    (3482, 'Analiza macromapzonelor', NULL)
) AS v(id, alias, observ)
WHERE t.id = v.id;

