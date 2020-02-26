/*
This file is part of Giswater 3
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association
*/


SET search_path = SCHEMA_NAME, public, pg_catalog;


UPDATE sys_csv2pg_cat SET csv_structure='GIS identifier (arc_id, node_id, connec_id), element catalog, observations, comments, num. elements, state type (id).
NOTES: 
1- CSV file must have header.
2- Observations and comments fields are optional
3- Import label has to be filled with the type of element (node, arc, connec)'
WHERE id=3;