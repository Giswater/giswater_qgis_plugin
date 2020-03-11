/*
This file is part of Giswater 3
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association
*/

SET search_path = SCHEMA_NAME, public, pg_catalog;
--2020/03/11


CREATE OR REPLACE VIEW v_anl_flow_gully AS 
 SELECT v_edit_gully.gully_id,
    anl_flow_arc.context,
    anl_flow_arc.expl_id,
    v_edit_gully.the_geom
   FROM anl_flow_arc
     JOIN v_edit_gully ON anl_flow_arc.arc_id::text = v_edit_gully.arc_id::text
     JOIN selector_expl ON anl_flow_arc.expl_id = selector_expl.expl_id AND selector_expl.cur_user = "current_user"()::text AND anl_flow_arc.cur_user::name = "current_user"();
