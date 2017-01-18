/*
This file is part of Giswater 2.0
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association
*/

SET search_path = "SCHEMA_NAME", public, pg_catalog;



 
CREATE OR REPLACE VIEW v_om_visit_leak AS 
 SELECT om_visit_event.id,
    om_visit.the_geom,
    om_visit_event.parameter_id
   FROM om_visit
     JOIN om_visit_event ON om_visit.id = om_visit_event.visit_id
     JOIN om_visit_parameter ON om_visit_event.parameter_id::text = om_visit_parameter.id::text
  WHERE om_visit_parameter.parameter_type::text = 'LEAK'::text;