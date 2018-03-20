/*
This file is part of Giswater 3
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association
*/


SET search_path = "SCHEMA_NAME", public, pg_catalog;



DROP VIEW IF EXISTS "v_edit_custom_junction" CASCADE;			
CREATE OR REPLACE VIEW "v_edit_custom_junction" AS
SELECT 
v_edit_junction.*,
a.junction_parameter_1,
a.junction_parameter_2
FROM SCHEMA_NAME.v_edit_junction
LEFT JOIN (
SELECT * FROM crosstab('SELECT feature_id, parameter_id, value_param FROM SCHEMA_NAME.man_addfields_value JOIN SCHEMA_NAME.man_addfields_parameter 
on man_addfields_parameter.id=parameter_id where featurecat_id=''JUNCTION'' ORDER BY 1,2')
AS rpt ("feature_id" varchar, "junction_parameter_1" text, "junction_parameter_2" text)
)a ON node_id=feature_id
WHERE nodetype_id='JUNCTION';