/*
This file is part of Giswater
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
*/


SET search_path = SCHEMA_NAME, public, pg_catalog;
UPDATE config_toolbox AS t SET alias = v.alias, observ = v.observ FROM (
	VALUES
	(2102, 'Comprovar Arcs Sense Node Inici/Final', NULL),
    (2104, 'Comprova arcs amb mateix node d''inici/final', NULL),
    (2106, 'Comprovar Connexions Duplicades', NULL),
    (2108, 'Comprovar Nodes Duplicats', NULL),
    (2110, 'Check nodes orphan', NULL),
    (2118, 'Construir nodes utilitzant vèrtexs inicial i final dels arcs', NULL),
    (2436, 'Comprovar Dades del Pla', NULL),
    (2670, 'Comprovar dades per al procés o&m', NULL),
    (2760, 'Obtenir valors del raster DEM', NULL),
    (2772, 'Analítica de traça de cabal', NULL),
    (2776, 'Comprovar configuració del backend', NULL),
    (2826, 'Sistema de Referència Lineal', NULL),
    (2890, 'Cost de reconstrucció i valors d''amortització', NULL),
    (2922, 'Restablir perfil d''usuari', NULL),
    (2998, 'Usuari check data', NULL),
    (3008, 'Arc reverse', NULL),
    (3040, 'Check arcs duplicated', NULL),
    (3042, 'Gestionar valors Dscenario', NULL),
    (3052, 'Arcs més curts/més llargs que una longitud específica', NULL),
    (3080, 'Reparar Nodes Duplicats (Un per Un)', NULL),
    (3130, 'Topocontrol per a la migració de dades', NULL),
    (3134, 'Create empty Dscenario', NULL),
    (3156, 'Duplicar dscenario', NULL),
    (3172, 'Comprova candidats de nodes T', NULL),
    (3198, 'Obtenir valors d''adreça des del número de carrer més proper', NULL),
    (3280, 'Actualització Massiva de Rotació de Node', NULL),
    (3284, 'Fusionar dos o més psectors en un', NULL),
    (3336, 'Anàlisi de Macrominsector', NULL),
    (3426, 'Integrar campanya a producció', NULL),
    (3482, 'Anàlisi de Macromapzones', NULL),
    (2302, 'Comprova consistència topològica del node', NULL),
    (2430, 'Comprova dades segons les regles EPA', NULL),
    (2496, 'Reconnectar arcs amb els nodes més propers', NULL),
    (2706, 'Anàlisi Minsector', NULL),
    (2768, 'Anàlisi de Mapzones', NULL),
    (2790, 'Comprova dades per al procés graphanalytics', NULL),
    (2970, 'Configuració mapzones', NULL),
    (3108, 'Crea Network Dscenario des de ToC', NULL),
    (3110, 'Crea Demand Dscenario des de CRM', NULL),
    (3112, 'Crea Demand Dscenario des de ToC', NULL),
    (3142, 'Balanç híbrid per Explotació i Període', NULL),
    (3158, 'Crea vàlvula dscenario des de mincut', NULL),
    (3160, 'Calcula l''abast dels hidrants', 'Function requires street data inserted on table om_streetaxis, where each street is divided into short lines between intersections.'),
    (3236, 'Mostra mincuts actuals', NULL),
    (3256, 'Anàlisi Mapzones Netscenario', NULL),
    (3258, 'Estableix valors de patró a la demanda dscenario', NULL),
    (3260, 'Crea Netscenario buit', NULL),
    (3262, 'Crea Netscenario des de ToC', NULL),
    (3264, 'Duplica Netscenario', NULL),
    (3268, 'Estableix valors d''initlevel des de la simulació executada', NULL),
    (3308, 'Crea dscenario de Xarxa complet', NULL),
    (3322, 'Estableix cost per material eliminat a psectors', NULL)
) AS v(id, alias, observ)
WHERE t.id = v.id;

