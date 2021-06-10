/*
This file is part of Giswater 3
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association
*/


SET search_path = SCHEMA_NAME, public, pg_catalog;


--2021/06/10
CREATE OR REPLACE VIEW v_edit_inp_lid AS 
SELECT 
subc_id, 
lidco_id, 
"number", 
l.area, 
l.width, 
initsat, 
fromimp, 
toperv, 
rptfile, 
l.hydrology_id, 
l.descript,
s.the_geom
FROM inp_lidusage_subc_x_lidco l
JOIN v_edit_inp_subcatchment s USING(subc_id)
WHERE s.hydrology_id=l.hydrology_id;



CREATE OR REPLACE VIEW vi_lid_usage AS 
 SELECT inp_lidusage_subc_x_lidco.subc_id,
    inp_lidusage_subc_x_lidco.lidco_id,
    inp_lidusage_subc_x_lidco.number::integer AS number,
    inp_lidusage_subc_x_lidco.area,
    inp_lidusage_subc_x_lidco.width,
    inp_lidusage_subc_x_lidco.initsat,
    inp_lidusage_subc_x_lidco.fromimp,
    inp_lidusage_subc_x_lidco.toperv::integer AS toperv,
    inp_lidusage_subc_x_lidco.rptfile,
    inp_lidusage_subc_x_lidco.hydrology_id
   FROM v_edit_inp_subcatchment
   JOIN inp_lidusage_subc_x_lidco ON inp_lidusage_subc_x_lidco.subc_id::text = v_edit_inp_subcatchment.subc_id::text
   WHERE v_edit_inp_subcatchment.hydrology_id = inp_lidusage_subc_x_lidco.hydrology_id;