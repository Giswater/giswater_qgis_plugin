/*
This file is part of Giswater 3
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association
*/


SET search_path = SCHEMA_NAME, public, pg_catalog;

--2022/09/21

CREATE OR REPLACE VIEW v_anl_graphanalytics_upstream AS
 SELECT temp_anlgraph.arc_id,
    temp_anlgraph.node_1,
    temp_anlgraph.node_2,
    temp_anlgraph.flag,
    a2.flag AS flagi,
    a2.value,
    a2.trace
   FROM (temp_anlgraph
     JOIN ( SELECT temp_anlgraph_1.arc_id,
            temp_anlgraph_1.node_1,
            temp_anlgraph_1.node_2,
            temp_anlgraph_1.water,
            temp_anlgraph_1.flag,
            temp_anlgraph_1.checkf,
            temp_anlgraph_1.value,
            temp_anlgraph_1.trace
           FROM temp_anlgraph temp_anlgraph_1
          WHERE (temp_anlgraph_1.water = 1)) a2 ON (((temp_anlgraph.node_2)::text = (a2.node_1)::text)))
  WHERE ((temp_anlgraph.flag < 2) AND (temp_anlgraph.water = 0) AND (a2.flag = 0));