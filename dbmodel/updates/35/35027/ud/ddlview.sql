/*
This file is part of Giswater 3
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association
*/


SET search_path = SCHEMA_NAME, public, pg_catalog;

--2022/07/26


CREATE OR REPLACE VIEW v_anl_graph AS 
 SELECT anl_graph.arc_id,
    anl_graph.node_1,
    anl_graph.node_2,
    anl_graph.flag,
    a.flag AS flagi,
    a.value
   FROM temp_anlgraph anl_graph
     JOIN ( SELECT anl_graph_1.arc_id,
            anl_graph_1.node_1,
            anl_graph_1.node_2,
            anl_graph_1.water,
            anl_graph_1.flag,
            anl_graph_1.checkf,
            anl_graph_1.value
           FROM temp_anlgraph anl_graph_1
          WHERE anl_graph_1.water = 1) a ON anl_graph.node_1::text = a.node_2::text
  WHERE anl_graph.flag < 2 AND anl_graph.water = 0 AND a.flag < 2;
  

CREATE OR REPLACE VIEW v_anl_graphanalytics_upstream AS 
 SELECT temp_anlgraph.arc_id,
    temp_anlgraph.node_1,
    temp_anlgraph.node_2,
    temp_anlgraph.flag,
    a2.flag AS flagi,
    a2.value,
    a2.trace
   FROM temp_anlgraph
     JOIN ( SELECT temp_anlgraph_1.arc_id,
            temp_anlgraph_1.node_1,
            temp_anlgraph_1.node_2,
            temp_anlgraph_1.water,
            temp_anlgraph_1.flag,
            temp_anlgraph_1.checkf,
            temp_anlgraph_1.value,
            temp_anlgraph_1.trace
           FROM temp_anlgraph temp_anlgraph_1
          WHERE temp_anlgraph_1.water = 1) a2 ON temp_anlgraph.node_2::text = a2.node_1::text
  WHERE temp_anlgraph.flag < 2 AND temp_anlgraph.water = 0 AND a2.flag = 0;

--2022/08/10
DROP VIEW ve_pol_gully;

CREATE OR REPLACE VIEW ve_pol_gully AS 
 SELECT polygon.pol_id,
    polygon.feature_id,
    polygon.featurecat_id,
    polygon.state,
    polygon.sys_type,
    polygon.the_geom
   FROM gully
     JOIN v_state_gully USING (gully_id)
     JOIN polygon ON polygon.feature_id::text = gully.gully_id::text;



CREATE OR REPLACE VIEW vi_infiltration AS 
SELECT v_edit_inp_subcatchment.subc_id,
    v_edit_inp_subcatchment.curveno AS other1,
    v_edit_inp_subcatchment.conduct_2 AS other2,
    v_edit_inp_subcatchment.drytime_2 AS other3,
    NULL::numeric AS other4,
    NULL::double precision AS other5
   FROM v_edit_inp_subcatchment
     JOIN cat_hydrology ON cat_hydrology.hydrology_id = v_edit_inp_subcatchment.hydrology_id
     JOIN ( SELECT a.subc_id,
            a.outlet_id
           FROM ( SELECT unnest(inp_subcatchment.outlet_id::character varying[]) AS outlet_id,
                    inp_subcatchment.subc_id
                   FROM inp_subcatchment
                     JOIN temp_node ON inp_subcatchment.outlet_id::text = temp_node.node_id::text
                  WHERE "left"(inp_subcatchment.outlet_id::text, 1) = '{'::text
                UNION
                 SELECT inp_subcatchment.outlet_id,
                    inp_subcatchment.subc_id
                   FROM inp_subcatchment
                  WHERE "left"(inp_subcatchment.outlet_id::text, 1) <> '{'::text) a) b USING (outlet_id)
  WHERE cat_hydrology.infiltration::text = 'CURVE_NUMBER'::text
UNION
 SELECT v_edit_inp_subcatchment.subc_id,
    v_edit_inp_subcatchment.suction AS other1,
    v_edit_inp_subcatchment.conduct AS other2,
    v_edit_inp_subcatchment.initdef AS other3,
    NULL::integer AS other4,
    NULL::double precision AS other5
   FROM v_edit_inp_subcatchment
     JOIN cat_hydrology ON cat_hydrology.hydrology_id = v_edit_inp_subcatchment.hydrology_id
     JOIN ( SELECT a.subc_id,
            a.outlet_id
           FROM ( SELECT unnest(inp_subcatchment.outlet_id::character varying[]) AS outlet_id,
                    inp_subcatchment.subc_id
                   FROM inp_subcatchment
                     JOIN temp_node ON inp_subcatchment.outlet_id::text = temp_node.node_id::text
                  WHERE "left"(inp_subcatchment.outlet_id::text, 1) = '{'::text
                UNION
                 SELECT inp_subcatchment.outlet_id,
                    inp_subcatchment.subc_id
                   FROM inp_subcatchment
                  WHERE "left"(inp_subcatchment.outlet_id::text, 1) <> '{'::text) a) b USING (outlet_id)
  WHERE cat_hydrology.infiltration::text = 'GREEN_AMPT'::text
UNION
 SELECT v_edit_inp_subcatchment.subc_id,
    v_edit_inp_subcatchment.curveno AS other1,
    v_edit_inp_subcatchment.conduct_2 AS other2,
    v_edit_inp_subcatchment.drytime_2 AS other3,
    NULL::integer AS other4,
    NULL::double precision AS other5
   FROM v_edit_inp_subcatchment
     JOIN cat_hydrology ON cat_hydrology.hydrology_id = v_edit_inp_subcatchment.hydrology_id
     JOIN ( SELECT a.subc_id,
            a.outlet_id
           FROM ( SELECT unnest(inp_subcatchment.outlet_id::character varying[]) AS outlet_id,
                    inp_subcatchment.subc_id
                   FROM inp_subcatchment
                     JOIN temp_node ON inp_subcatchment.outlet_id::text = temp_node.node_id::text
                  WHERE "left"(inp_subcatchment.outlet_id::text, 1) = '{'::text
                UNION
                 SELECT inp_subcatchment.outlet_id,
                    inp_subcatchment.subc_id
                   FROM inp_subcatchment
                  WHERE "left"(inp_subcatchment.outlet_id::text, 1) <> '{'::text) a) b USING (outlet_id)
  WHERE cat_hydrology.infiltration::text = ANY (ARRAY['MODIFIED_HORTON'::text, 'HORTON'::text]);
