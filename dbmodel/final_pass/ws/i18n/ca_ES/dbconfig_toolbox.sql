/*
This file is part of Giswater
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
*/


SET search_path = SCHEMA_NAME, public, pg_catalog;
UPDATE config_toolbox AS t SET alias = v.alias, observ = v.observ FROM (
	VALUES
	(2102, 'Comproveu els arcs sense l''inici/final del node', NULL),
    (2104, 'Comproveu arcs amb el mateix node inicial/final', NULL),
    (2106, 'Comproveu les connexions duplicades', NULL),
    (2108, 'Comproveu els nodes duplicats', NULL),
    (2110, 'Comproveu els nodes orfes', NULL),
    (2118, 'Construeix nodes utilitzant arcs vèrtexs inicials i finals', NULL),
    (2436, 'Comproveu les dades del pla', NULL),
    (2670, 'Comproveu les dades del procés d''o&m', NULL),
    (2760, 'Obteniu valors de DEM ràster', NULL),
    (2768, 'Anàlisi de zones de mapes', NULL),
    (2772, 'Analítica de traça de flux', NULL),
    (2776, 'Comproveu la configuració del backend', NULL),
    (2826, 'Sistema de referència lineal', NULL),
    (2890, 'Cost de reconstrucció i valors d''amortització', NULL),
    (2922, 'Restableix el perfil d''usuari', NULL),
    (2998, 'Dades de comprovació de l''usuari', NULL),
    (3008, 'Arc invers', NULL),
    (3040, 'Comproveu arcs duplicats', NULL),
    (3042, 'Gestioneu els valors de Dscenario', NULL),
    (3052, 'Arcs més curts/més grans que la longitud específica', NULL),
    (3080, 'Nodes de reparació duplicats (un per un)', NULL),
    (3130, 'Topocontrol per a la migració de dades', NULL),
    (3134, 'Creeu un Dscenario buit', NULL),
    (3156, 'Escenari duplicat', NULL),
    (3172, 'Comproveu els nodes T candidats', NULL),
    (3198, 'Obteniu els valors de l''adreça del número de carrer més proper', NULL),
    (3280, 'Actualització massiva de rotació de nodes', NULL),
    (3284, 'Combina dos o més sectors en un', NULL),
    (3336, 'Anàlisi macroinsector', NULL),
    (3426, 'Integrar la campanya a la producció', NULL),
    (3482, 'Anàlisi de macromapes', NULL),
    (2302, 'Comprovar la coherència topològica del node', NULL),
    (2430, 'Comproveu les dades segons les normes de l''EPA', NULL),
    (2496, 'Torneu a connectar els arcs amb els nodes més propers', NULL),
    (2706, 'Anàlisi sectorial', NULL),
    (2790, 'Comproveu les dades del procés de graphanalytics', NULL),
    (2970, 'Configura zones de mapes', NULL),
    (3108, 'Creeu un escenari de xarxa des de ToC', NULL),
    (3110, 'Creeu un escenari de demanda des del CRM', NULL),
    (3112, 'Crear un escenari de demanda des de ToC', NULL),
    (3142, 'Balanç hídric per explotació i període', NULL),
    (3158, 'Crea un escenari de vàlvules a partir de mincut', NULL),
    (3160, 'Calcula l''abast dels hidrants', 'La funció requereix que les dades del carrer s''insereixin a la taula om_streetaxis, on cada carrer es divideix en línies curtes entre interseccions.'),
    (3236, 'Mostra els mínims actuals', NULL),
    (3256, 'Mapzones Anàlisi d''escenaris nets', NULL),
    (3258, 'Estableix els valors dels patrons segons l''escenari de demanda', NULL),
    (3260, 'Crea un Netscenario buit', NULL),
    (3262, 'Crea Netscenario des de ToC', NULL),
    (3264, 'Netscenario duplicat', NULL),
    (3268, 'Estableix els valors de nivell inicial de la simulació executada', NULL),
    (3308, 'Creeu un escenari de xarxa complet', NULL),
    (3322, 'Establiu el cost del material eliminat als sectors', NULL)
) AS v(id, alias, observ)
WHERE t.id = v.id;

