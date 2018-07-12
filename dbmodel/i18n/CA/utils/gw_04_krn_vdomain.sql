/*
This file is part of Giswater 3
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association
*/

SET search_path = "SCHEMA_NAME", public, pg_catalog;


INSERT INTO sys_csv2pg_cat VALUES (1, 'Importar preus a la base de dades', 'Importar preus a la base de dades', 
'El fitxer csv ha de tenir aquestes columnes per ordre: id, unit, descript, text, price.
- La columna price ha de ser tipus numero amb dos decimals.
- Pots triar un cataleg per els preus importats assignant-lo a Import label.
- Atencio: el fitxer csv ha de tenir una fila inicial amb els noms de columna','role_master');
INSERT INTO sys_csv2pg_cat VALUES (2, 'Importar taula de visites a nodes', 'Importar taula de visites a nodes', 'El fitxer csv ha de tenir aquestes columnes per ordre: node_id, unit', 'role_om');
INSERT INTO sys_csv2pg_cat VALUES (3, 'Importar elements', 'Importar elements', 
'El fitxer csv ha de tenir aquestes columnes per ordre: feature_id, elementcat_id, observ, comment, num_elements. 
- A Import labal cal afegir-hi el tipus d''element que vols importar (node, arc, connec, gully).
- Els camps Observ i Comment son opcionals.
- Atencio: el fitxer csv ha de tenir una fila inicial amb els noms de columna', 'role_admin');
INSERT INTO sys_csv2pg_cat VALUES (4, 'Importar camps addicionals', 'Importar camps addicionals', 'El fitxer csv ha de tenir aquestes columnes per ordre: 
feature_id (pot ser arc, node o connec), parameter_id (a triar de la taula man_addfields_parameter), value_param. 
- Atencio: el fitxer csv ha de tenir una fila inicial amb els noms de columna', 'role_admin');
INSERT INTO sys_csv2pg_cat VALUES (5, 'Importar taula de visites a arc', 'Importar taula de visites a arc', 'El fitxer csv ha de tenir aquestes columnes per ordre: arc_id unit', 'role_om');
INSERT INTO sys_csv2pg_cat VALUES (6, 'Importar taula de visites a connec', 'Importar taula de visites a connec', 'El fitxer csv ha de tenir aquestes columnes per ordre: connec_id unit', 'role_om');
INSERT INTO sys_csv2pg_cat VALUES (7, 'Importar taula de visites a gully', 'Importar taula de visites a gully', 'El fitxer csv ha de tenir aquestes columnes per ordre: gully_id, unit', 'role_om');