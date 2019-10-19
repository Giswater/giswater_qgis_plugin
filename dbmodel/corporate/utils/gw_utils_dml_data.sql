/*
This file is part of Giswater 3
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association
*/


SET search_path = "utils", public, pg_catalog;
/*
INSERT INTO utils.address 
SELECT 
 id ,
  muni_id,
  postcode,
  streetaxis_id,
  postnumber,
  plot_id ,
  the_geom ,
 expl_id,
expl_id
 FROM ws.ext_address;
  

  INSERT INTO utils.streetaxis
  SELECT 
  id ,
  code,
  type, 
  name, 
  text, 
  the_geom, 
expl_id,
expl_id,
  muni_id FROM ws.ext_streetaxis;


  INSERT INTO utils.municipality
  SELECT * FROM ws.ext_municipality;


INSERT INTO utils.plot
SELECT 
id,
plot_code,
muni_id,
postcode::integer,
streetaxis_id,
postnumber,
complement,
placement,
square,
observ,
text,
the_geom,
expl_id,
expl_id
FROM ws.ext_plot;



INSERT INTO utils.type_street
  SELECT * FROM ws.ext_type_street;


delete from ws.audit_cat_table where id='ext_type_street';
delete from ws.audit_cat_table where id='ext_type_street';


INSERT INTO utils.config_param_system(id, parameter, value, data_type, context, descript)
    VALUES (1, 'ws_current_schema', NULL , 'text', 'NULL','WS');

INSERT INTO utils.config_param_system(id, parameter, value, data_type, context, descript)
    VALUES (2, 'ud_current_schema', NULL , 'text', NULL,'UD');
*/

  
