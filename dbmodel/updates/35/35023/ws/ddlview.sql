/*
This file is part of Giswater 3
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association
*/


SET search_path = SCHEMA_NAME, public, pg_catalog;

--2022/03/22
CREATE OR REPLACE VIEW vi_tanks AS 
 SELECT temp_node.node_id,
        CASE
            WHEN temp_node.elev IS NOT NULL THEN temp_node.elev
            ELSE temp_node.elevation
        END AS elevation,
    (temp_node.addparam::json ->> 'initlevel'::text)::numeric AS initlevel,
    (temp_node.addparam::json ->> 'minlevel'::text)::numeric AS minlevel,
    (temp_node.addparam::json ->> 'maxlevel'::text)::numeric AS maxlevel,
    (temp_node.addparam::json ->> 'diameter'::text)::numeric AS diameter,
    (temp_node.addparam::json ->> 'minvol'::text)::numeric AS minvol,
        CASE
            WHEN (temp_node.addparam::json ->> 'curve_id'::text) IS NULL THEN '*'::text
            ELSE temp_node.addparam::json ->> 'curve_id'::text
        END AS curve_id,
    temp_node.addparam::json ->> 'overflow'::text AS overflow,
    concat(';', temp_node.sector_id, ' ', temp_node.dma_id, ' ', temp_node.presszone_id, ' ', temp_node.dqa_id, ' ', temp_node.minsector_id, ' ', temp_node.node_type) AS other
   FROM temp_node
  WHERE temp_node.epa_type::text = 'TANK'::text
  ORDER BY temp_node.node_id;



  CREATE OR REPLACE VIEW v_anl_grafanalytics_mapzones AS 
 SELECT temp_anlgraf.arc_id,
    temp_anlgraf.node_1,
    temp_anlgraf.node_2,
    temp_anlgraf.flag,
    a2.flag AS flagi,
    a2.value,
    a2.trace
   FROM temp_anlgraf
     JOIN ( SELECT temp_anlgraf_1.arc_id,
            temp_anlgraf_1.node_1,
            temp_anlgraf_1.node_2,
            temp_anlgraf_1.water,
            temp_anlgraf_1.flag,
            temp_anlgraf_1.checkf,
            temp_anlgraf_1.value,
	    temp_anlgraf_1.trace
           FROM temp_anlgraf temp_anlgraf_1
          WHERE temp_anlgraf_1.water = 1) a2 ON temp_anlgraf.node_1::text = a2.node_2::text
  WHERE temp_anlgraf.flag < 2 AND temp_anlgraf.water = 0 AND a2.flag = 0;