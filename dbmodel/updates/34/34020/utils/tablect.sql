/*
This file is part of Giswater 3
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association
*/


SET search_path = SCHEMA_NAME, public, pg_catalog;

      
ALTER TABLE temp_csv DROP CONSTRAINT IF EXISTS temp_csv2pg_csv2pgcat_id_fkey2;

ALTER TABLE element_x_arc DROP CONSTRAINT IF EXISTS element_x_arc_unique;
ALTER TABLE element_x_arc ADD CONSTRAINT element_x_arc_unique UNIQUE(element_id, arc_id);
  
ALTER TABLE element_x_node DROP CONSTRAINT IF EXISTS element_x_node_unique;
ALTER TABLE element_x_node ADD CONSTRAINT element_x_node_unique UNIQUE(element_id, node_id);
  
ALTER TABLE element_x_connec DROP CONSTRAINT IF EXISTS element_x_connec_unique;
ALTER TABLE element_x_connec ADD CONSTRAINT element_x_connec_unique UNIQUE(element_id, connec_id);