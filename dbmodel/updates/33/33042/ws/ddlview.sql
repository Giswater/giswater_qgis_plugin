/*
This file is part of Giswater 3
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association
*/


SET search_path = SCHEMA_NAME, public, pg_catalog;

CREATE OR REPLACE VIEW vi_pjoint AS 
SELECT connec.pjoint_id,
sum(inp_connec.demand)
FROM inp_connec
JOIN connec USING (connec_id)
GROUP BY pjoint_id;