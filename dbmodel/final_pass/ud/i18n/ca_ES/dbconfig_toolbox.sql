/*
This file is part of Giswater
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
*/


SET search_path = SCHEMA_NAME, public, pg_catalog;
UPDATE config_toolbox AS t SET alias = v.alias, observ = v.observ FROM (
	VALUES
	(2202, 'Comprovar Arcs Intersectats', NULL),
    (2204, 'Comprovar Arcs Amb Pendent Invertit', NULL),
    (2206, 'Comprovar Nodes-Trobar Arcs de Sortida Sobre Arcs d''Entrada', NULL),
    (2208, 'Comprovar Nodes amb Més d''una Sortida', NULL),
    (2210, 'Comprovar Nodes com a Desembocadura', NULL),
    (2212, 'Comprovar Consistència Topològica de Node', NULL),
    (2431, 'Comprovar Dades Segons Normes EPA', NULL),
    (2496, 'Reparació d''Arc', NULL),
    (2768, 'Anàlisi de Mapzones', NULL),
    (2986, 'Consistència de Pendent', NULL),
    (3064, 'Comprovar Valors de Cota de Nodes', NULL),
    (3066, 'Comprovar valors de cota dels arcs', NULL),
    (3100, 'Gestionar Valors d''Hidrologia', NULL),
    (3102, 'Gestionar Valors Dwf', NULL),
    (3118, 'Crear Dscenario Amb Valors de ToC', NULL),
    (3176, 'Controlar Seccions de Conducte', NULL),
    (3186, 'Establir Unions com a Sortida', NULL),
    (3242, 'Establir Sortida Òptima per a Subconques', NULL),
    (3290, 'Crear escenari d''Hidrologia buit', NULL),
    (3292, 'Crear Escenari DWF Buit', NULL),
    (3294, 'Duplicar escenari d''Hidrologia', NULL),
    (3296, 'Duplicar Escenari DWF', NULL),
    (3326, 'Calcular el rendiment hidràulic per a un resultat específic', NULL),
    (3360, 'Crear Thyssen Subconques', NULL),
    (3424, 'Anàlisi del tipus de fluid', NULL),
    (3492, 'Anàlisi Omunit', NULL),
    (3522, 'Anàlisi del tipus de tractament', NULL),
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
    (3482, 'Anàlisi de Macromapzones', NULL)
) AS v(id, alias, observ)
WHERE t.id = v.id;

