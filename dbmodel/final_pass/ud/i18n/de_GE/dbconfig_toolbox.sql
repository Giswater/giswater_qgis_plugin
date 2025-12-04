/*
This file is part of Giswater
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
*/


SET search_path = SCHEMA_NAME, public, pg_catalog;
UPDATE config_toolbox AS t SET alias = v.alias, observ = v.observ FROM (
	VALUES
	(2202, 'Überprüfe Bögen, die sich schneiden', NULL),
    (2204, 'Bögen mit umgekehrter Steigung prüfen', NULL),
    (2206, 'Knoten prüfen - Ausgangs-Arcs über Eingangs-Arcs finden', NULL),
    (2208, 'Knoten mit mehr als einem Ausgang prüfen', NULL),
    (2210, 'Knotenpunkte als Abfluss kontrollieren', NULL),
    (2212, 'Topologische Konsistenz der Knoten prüfen', NULL),
    (2431, 'Überprüfung der Daten gemäß den EPA-Vorschriften', NULL),
    (2496, 'Lichtbogen-Reparatur', NULL),
    (2986, 'Konsistenz der Neigung', NULL),
    (3064, 'Überprüfen der Knotenhöhenwerte', NULL),
    (3066, 'Bogenhöhenwerte prüfen', NULL),
    (3100, 'Hydrologie-Werte verwalten', NULL),
    (3102, 'Dwf-Werte verwalten', NULL),
    (3118, 'Dscenario mit Werten aus ToC erstellen', NULL),
    (3176, 'Control conduit sections', NULL),
    (3186, 'Abzweigungen als Ausgang einstellen', NULL),
    (3242, 'Optimaler Auslass für Teileinzugsgebiete festlegen', NULL),
    (3290, 'Leeres Hydrologie-Szenario erstellen', NULL),
    (3292, 'Leeres DWF-Szenario erstellen', NULL),
    (3294, 'Hydrologie-Szenario duplizieren', NULL),
    (3296, 'DWF-Szenario duplizieren', NULL),
    (3326, 'Berechnen Sie die hydraulische Leistung für ein bestimmtes Ergebnis', NULL),
    (3360, 'Thyssen Teileinzugsgebiete anlegen', NULL),
    (3424, 'Analyse des Flüssigkeitstyps', NULL),
    (3492, 'Omunit-Analyse', NULL),
    (2102, 'Bögen ohne Knotenanfang/-ende prüfen', NULL),
    (2104, 'Bögen mit gleichem Start-/Endknoten prüfen', NULL),
    (2106, 'Verbindungen prüfen doppelt', NULL),
    (2108, 'Doppelte Knoten prüfen', NULL),
    (2110, 'Verwaiste Knoten prüfen', NULL),
    (2118, 'Knoten mit Start- und Endpunkten von Bögen erstellen', NULL),
    (2436, 'Plandaten prüfen', NULL),
    (2670, 'Daten für o&m-Prozess prüfen', NULL),
    (2760, 'Werte aus Raster-DEM holen', NULL),
    (2768, 'Mapzones-Analyse', NULL),
    (2772, 'Analyse von Flussverläufen', NULL),
    (2776, 'Backend-Konfiguration prüfen', NULL),
    (2826, 'Lineares Bezugssystem', NULL),
    (2890, 'Wiederherstellungskosten und Abschreibungswerte', NULL),
    (2922, 'Benutzerprofil zurücksetzen', NULL),
    (2998, 'Benutzerprüfdaten', NULL),
    (3008, 'Bogen rückwärts', NULL),
    (3040, 'Doppelte Bögen prüfen', NULL),
    (3042, 'Dscenario-Werte verwalten', NULL),
    (3052, 'Arcs shorter/bigger than specific length', NULL),
    (3080, 'Duplizierte Knoten reparieren (einen nach dem anderen)', NULL),
    (3130, 'Topocontrol für die Datenmigration', NULL),
    (3134, 'Leeres Dszenario erstellen', NULL),
    (3156, 'Doppeltes dscenario', NULL),
    (3172, 'Knoten T Kandidaten prüfen', NULL),
    (3198, 'Adresswerte von der nächstgelegenen Hausnummer abrufen', NULL),
    (3280, 'Massive Aktualisierung der Knotenrotation', NULL),
    (3284, 'Zwei oder mehr Sektoren zu einem zusammenführen', NULL),
    (3336, 'Analyse des Makroministeriums', NULL),
    (3426, 'Integration der Kampagne in die Produktion', NULL),
    (3482, 'Analyse der Makromapozonen', NULL)
) AS v(id, alias, observ)
WHERE t.id = v.id;

