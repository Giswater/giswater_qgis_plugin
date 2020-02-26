/*
This file is part of Giswater 3
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association
*/


SET search_path = SCHEMA_NAME, public, pg_catalog;


UPDATE sys_csv2pg_cat SET csv_structure='Identificador GIS (arc_id, node_id, connec_id), catalogo de elementos, observaciones, comentarios, num. elementos, tipo de estado(id).
NOTAS: 
1- El fichero CSV debe tener cabezera.
2- Los campos observaciones y comentarios son opcionales
3- El import label debe ser el tipo de elemento (es decir, node, arc o connec'
WHERE id=3;