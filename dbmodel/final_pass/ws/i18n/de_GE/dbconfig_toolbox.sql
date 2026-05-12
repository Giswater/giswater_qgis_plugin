/*
This file is part of Giswater
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
*/


SET search_path = SCHEMA_NAME, public, pg_catalog;
UPDATE config_toolbox AS t SET alias = v.alias, observ = v.observ FROM (
	VALUES
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
    (3482, 'Analyse der Makromapozonen', NULL),
    (2302, 'Topologische Konsistenz der Knoten prüfen', NULL),
    (2430, 'Überprüfung der Daten gemäß den EPA-Vorschriften', NULL),
    (2496, 'Bögen mit den nächstgelegenen Knotenpunkten neu verbinden', NULL),
    (2706, 'Analyse des Minensektors', NULL),
    (2790, 'Daten für den Graphanalytik-Prozess prüfen', NULL),
    (2970, 'Zonen auf der Karte konfigurieren', NULL),
    (3108, 'Netzwerk-Dszenario aus ToC erstellen', NULL),
    (3110, 'Bedarfsszenario aus CRM erstellen', NULL),
    (3112, 'Bedarfsszenario aus ToC erstellen', NULL),
    (3142, 'Wasserbilanz nach Nutzungsart und Zeitraum', NULL),
    (3158, 'Ventil dscenario aus mincut erstellen', NULL),
    (3160, 'Berechnen Sie die Reichweite von Hydranten', 'Die Funktion erfordert Straßendaten, die in die Tabelle om_streetaxis eingefügt werden, wobei jede Straße in kurze Linien zwischen Kreuzungen unterteilt ist.'),
    (3236, 'Aktuelle Mincuts anzeigen', NULL),
    (3256, 'Mapzones Netscenario-Analyse', NULL),
    (3258, 'Musterwerte bei Bedarf einstellen dscenario', NULL),
    (3260, 'Leeres Netszenario erstellen', NULL),
    (3262, 'Netszenario aus ToC erstellen', NULL),
    (3264, 'Doppeltes Netszenario', NULL),
    (3268, 'Setzen von Initlevel-Werten aus der ausgeführten Simulation', NULL),
    (3308, 'Vollständiges Netzwerk-Dszenario erstellen', NULL),
    (3322, 'Kosten für entferntes Material auf Sektoren festlegen', NULL)
) AS v(id, alias, observ)
WHERE t.id = v.id;

