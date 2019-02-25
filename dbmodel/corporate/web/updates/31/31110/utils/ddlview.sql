/*
This file is part of Giswater 3
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association
*/


SET search_path = "SCHEMA_NAME", public, pg_catalog;



--2019/02/25
CREATE OR REPLACE VIEW v_web_parent_gully AS 
 SELECT v_edit_gully.gully_id AS nid,
    v_edit_gully.gully_type AS custom_type,
    gully_type.descript
   FROM v_edit_gully
   JOIN gully_type ON gully_type.id = v_edit_gully.gully_type;

