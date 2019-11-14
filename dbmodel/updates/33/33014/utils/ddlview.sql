/*
This file is part of Giswater 3
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association
*/


SET search_path = SCHEMA_NAME, public, pg_catalog;


--14/11/2019
CREATE OR REPLACE VIEW v_anl_graf AS 
 WITH nodes_a AS (
         SELECT anl_graf_1.id,
            anl_graf_1.grafclass,
            anl_graf_1.arc_id,
            anl_graf_1.node_1,
            anl_graf_1.node_2,
            anl_graf_1.water,
            anl_graf_1.flag,
            anl_graf_1.checkf,
            anl_graf_1.user_name
           FROM anl_graf anl_graf_1
          WHERE anl_graf_1.water = 1
        )
 SELECT anl_graf.grafclass,
    anl_graf.arc_id,
    anl_graf.node_1,
    anl_graf.node_2,
    anl_graf.flag,
    nodes_a.flag AS flagi
   FROM anl_graf
     JOIN nodes_a ON anl_graf.node_1 = nodes_a.node_2 OR anl_graf.node_2 = nodes_a.node_2
  WHERE anl_graf.flag < 2 AND anl_graf.water = 0 AND nodes_a.flag < 2 AND anl_graf.user_name::name = "current_user"();

