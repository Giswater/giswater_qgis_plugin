/*
This file is part of Giswater
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
*/


SET search_path = SCHEMA_NAME, public, pg_catalog;
UPDATE config_toolbox AS t SET alias = v.alias, observ = v.observ FROM (
	VALUES
	(2202, 'Comproveu els arcs tallats', NULL),
    (2204, 'Comproveu els arcs amb el pendent invertit', NULL),
    (2206, 'Comproveu els nodes-trobeu els arcs de sortida sobre els arcs d''entrada', NULL),
    (2208, 'Comproveu els nodes amb més d''una sortida', NULL),
    (2210, 'Comproveu els nodes com a emissari', NULL),
    (2212, 'Comprovar la coherència topològica del node', NULL),
    (2431, 'Comproveu les dades segons les normes de l''EPA', NULL),
    (2496, 'Reparació d''arcs', NULL),
    (2986, 'Coherència de pendent', NULL),
    (3064, 'Comproveu els valors d''elevació dels nodes', NULL),
    (3066, 'Comproveu els valors d''elevació dels arcs', NULL),
    (3100, 'Gestionar els valors d''Hidrologia', NULL),
    (3102, 'Gestioneu els valors Dwf', NULL),
    (3118, 'Creeu Dscenario amb valors de ToC', NULL),
    (3176, 'Control de seccions de conductes', NULL),
    (3186, 'Establiu les unions com a sortida', NULL),
    (3242, 'Establir la sortida òptima per a les subcaptacions', NULL),
    (3290, 'Crea un escenari d''Hidrologia buit', NULL),
    (3292, 'Creeu un escenari DWF buit', NULL),
    (3294, 'Escenari d''Hidrologia duplicat', NULL),
    (3296, 'Escenari DWF duplicat', NULL),
    (3326, 'Calcula el rendiment hidràulic per a un resultat específic', NULL),
    (3360, 'Crea subcaptacions de Thyssen', NULL),
    (3424, 'Anàlisi del tipus de fluid', NULL),
    (3492, 'Anàlisi Homunit', NULL),
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
    (3482, 'Anàlisi de macromapes', NULL)
) AS v(id, alias, observ)
WHERE t.id = v.id;

