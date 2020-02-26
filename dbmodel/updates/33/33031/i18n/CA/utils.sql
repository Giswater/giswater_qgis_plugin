/*
This file is part of Giswater 3
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association
*/


SET search_path = SCHEMA_NAME, public, pg_catalog;


UPDATE sys_csv2pg_cat SET csv_structure='Identificador GIS (arc_id, node_id, connec_id), catàleg d''elements, observacions, comentaris, núm. elements, tipus d''estat (id).
NOTES: 
1- El fitxer CSV ha de tenir capçalera.
2- Els camps observacions i comentari son optatius
3- El import label ha de ser el tipus d''element (és a dir node o arc o connec)'
WHERE id=3;