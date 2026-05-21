/*
This file is part of Giswater
The program is free software: you can redistribute it and/or modify it under the terms of the GNU
General Public License as published by the Free Software Foundation, either version 3 of the License,
or (at your option) any later version.
*/


/*
This script enables to repair topological ws project with good performance
1) reconnect all the arcs to closest nodes
2) insert nodes where there are not nodes and arcs has not node_1 or node_2 (with buffer of 0.1)
3) adjust arcs to those created new nodes that have been removed because the proximity of other created node (DANGEROUS AND DISABLED BY DEFAULT)
*/

-- disable arc tiggers
ALTER TABLE arc DISABLE TRIGGER gw_trg_arc_link_update;
ALTER TABLE arc DISABLE TRIGGER gw_trg_arc_node_values;
ALTER TABLE arc DISABLE TRIGGER gw_trg_arc_noderotation_update;
ALTER TABLE arc DISABLE TRIGGER gw_trg_plan_psector_after_arc;
ALTER TABLE arc DISABLE TRIGGER gw_trg_topocontrol_arc;

/*
put ready sample tot test it (only for sample to test)
update arc set node_1 = null, nodetype_1 = null, elevation1 = null, depth1 = null, staticpressure1 = null, node_2 = null, nodetype_2 = null, elevation2 = null, depth2 = null, staticpressure2 = null
delete from node where node_id in (select node_id from node limit 200)
select * from arc
*/

-- update node_1
update arc set node_1 = c.node_id, nodetype_1= node_type, elevation1 = top_elev, depth1= depth, staticpressure1 = staticpressure from (	
SELECT arc_id, node_id, node_1, node_type, top_elev, depth, staticpressure
FROM (SELECT a.arc_id, n.node_id, a.node_1, node_type, n.top_elev, n.depth, n.staticpressure, 
ROW_NUMBER() OVER ( PARTITION BY a.arc_id  ORDER BY CASE WHEN isarcdivide IS TRUE THEN 1 ELSE 2 END, ST_Distance(n.the_geom, ST_StartPoint(a.the_geom))) AS rn
FROM arc a JOIN node n ON ST_DWithin(ST_StartPoint(a.the_geom), n.the_geom, 0.5) JOIN cat_node ON cat_node.id = n.nodecat_id  JOIN cat_feature_node ON cat_feature_node.id = node_type) t
WHERE rn = 1
) c where c.arc_id = arc.arc_id;


-- update node_2
update arc set node_2 = c.node_id, nodetype_2= node_type, elevation2 = top_elev, depth2= depth, staticpressure2 = staticpressure from (	
SELECT arc_id, node_id, node_2, node_type, top_elev, depth, staticpressure
FROM (SELECT a.arc_id, n.node_id, a.node_2, node_type, n.top_elev, n.depth, n.staticpressure, 
ROW_NUMBER() OVER ( PARTITION BY a.arc_id  ORDER BY CASE WHEN isarcdivide IS TRUE THEN 1 ELSE 2 END, ST_Distance(n.the_geom, ST_EndPoint(a.the_geom))) AS rn
FROM arc a JOIN node n ON ST_DWithin(ST_EndPoint(a.the_geom), n.the_geom, 0.5) JOIN cat_node ON cat_node.id = n.nodecat_id  JOIN cat_feature_node ON cat_feature_node.id = node_type) t
WHERE rn = 1
) c where c.arc_id = arc.arc_id;


select * from arc


-- create virtual node catalog to use in the insert
insert into cat_node (id, node_type, matcat_id, descript) values ('VIRTUAL', 'JUNCTION', 'N/I' , 'Nodos insertados durante las migraciones iniciales')

-- disable node triggers
ALTER TABLE node DISABLE TRIGGER gw_trg_node_arc_divide;
ALTER TABLE node DISABLE TRIGGER gw_trg_node_rotation_update;
ALTER TABLE node DISABLE TRIGGER gw_trg_node_statecontrol;
ALTER TABLE node DISABLE TRIGGER gw_trg_plan_psector_after_node;
ALTER TABLE node DISABLE TRIGGER gw_trg_topocontrol_node;

--insert parent table
INSERT INTO node (expl_id, workcat_id, state, state_type, the_geom, nodecat_id, epa_type)
WITH pts AS (
    SELECT  expl_id, workcat_id, ST_StartPoint(the_geom) AS geom, 'VIRTUAL' as nodecat_id FROM arc  WHERE node_1 IS null
    	UNION ALL
    SELECT  expl_id, workcat_id, ST_EndPoint(the_geom) AS geom, 'VIRTUAL' as nodecat_id FROM arc  WHERE node_2 IS NULL
),
clustered AS ( SELECT  *, ST_ClusterDBSCAN(geom, eps := 0.1, minpoints := 1)  OVER () AS cluster_id FROM pts
)
SELECT DISTINCT ON (cluster_id) expl_id, workcat_id,  1,  2,  geom,  nodecat_id, 'JUNCTION' FROM clustered;

-- enable node triggers
ALTER TABLE node ENABLE TRIGGER gw_trg_node_arc_divide;
ALTER TABLE node ENABLE TRIGGER gw_trg_node_rotation_update;
ALTER TABLE node ENABLE TRIGGER gw_trg_node_statecontrol;
ALTER TABLE node ENABLE TRIGGER gw_trg_plan_psector_after_node;
ALTER TABLE node ENABLE TRIGGER gw_trg_topocontrol_node;

-- man & inp tables
insert into inp_junction select node_id from node where epa_type = 'JUNCTION' on conflict (node_id) do nothing;
insert into man_junction select node_id from node where nodecat_id = 'VIRTUAL' on conflict (node_id) do nothing;


-- update node_1
update arc set node_1 = c.node_id, nodetype_1= node_type, elevation1 = top_elev, depth1= depth, staticpressure1 = staticpressure from (	
SELECT arc_id, node_id, node_1, node_type, top_elev, depth, staticpressure
FROM (SELECT a.arc_id, n.node_id, a.node_1, node_type, n.top_elev, n.depth, n.staticpressure, 
ROW_NUMBER() OVER ( PARTITION BY a.arc_id  ORDER BY CASE WHEN isarcdivide IS TRUE THEN 1 ELSE 2 END, ST_Distance(n.the_geom, ST_StartPoint(a.the_geom))) AS rn
FROM arc a JOIN node n ON ST_DWithin(ST_StartPoint(a.the_geom), n.the_geom, 0.11) JOIN cat_node ON cat_node.id = n.nodecat_id  JOIN cat_feature_node ON cat_feature_node.id = node_type where nodecat_id = 'VIRTUAL') t
WHERE rn = 1
) c where c.arc_id = arc.arc_id and arc.node_1 is null;


-- update node_2
update arc set node_2 = c.node_id, nodetype_2= node_type, elevation2 = top_elev, depth2= depth, staticpressure2 = staticpressure from (	
SELECT arc_id, node_id, node_2, node_type, top_elev, depth, staticpressure
FROM (SELECT a.arc_id, n.node_id, a.node_2, node_type, n.top_elev, n.depth, n.staticpressure, 
ROW_NUMBER() OVER ( PARTITION BY a.arc_id  ORDER BY CASE WHEN isarcdivide IS TRUE THEN 1 ELSE 2 END, ST_Distance(n.the_geom, ST_EndPoint(a.the_geom))) AS rn
FROM arc a JOIN node n ON ST_DWithin(ST_EndPoint(a.the_geom), n.the_geom, 0.11) JOIN cat_node ON cat_node.id = n.nodecat_id  JOIN cat_feature_node ON cat_feature_node.id = node_type where nodecat_id = 'VIRTUAL') t
WHERE rn = 1
) c where c.arc_id = arc.arc_id and arc.node_2 is null;


-- enable arc tiggers
ALTER TABLE arc ENABLE TRIGGER gw_trg_arc_link_update;
ALTER TABLE arc ENABLE TRIGGER gw_trg_arc_node_values;
ALTER TABLE arc ENABLE TRIGGER gw_trg_arc_noderotation_update;
ALTER TABLE arc ENABLE TRIGGER gw_trg_plan_psector_after_arc;
ALTER TABLE arc ENABLE TRIGGER gw_trg_topocontrol_arc;


/*
-- update the_geom to make it coherent the start and end points with node_1 i node_2 (DANGEROUS)

STEP1: Flag with is_cadamap = true on previous query

SETP2: update geometry
UPDATE arc a
SET the_geom = ST_SetPoint(
                  ST_SetPoint(
                      a.the_geom,
                      0,
                      ST_StartPoint(n1.the_geom)
                  ),
                  ST_NPoints(a.the_geom) - 1,
                  ST_StartPoint(n2.the_geom)
              )
FROM node n1, node n2
WHERE a.node_1 = n1.node_id
  AND a.node_2 = n2.node_id
  and a.is_scadamap ;


STEP3: delete flag
update arc set is_scadamap = false;ç

*/
