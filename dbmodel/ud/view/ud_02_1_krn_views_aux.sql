SET search_path = "SCHEMA_NAME", public, pg_catalog;

-- COMMON SQL (WS & UD)


-------------------------------------------------------
-- STATE VIEWS & JOINED WITH MASTERPLAN (ALTERNATIVES)
-------------------------------------------------------

DROP VIEW IF EXISTS v_state_arc CASCADE;
CREATE VIEW v_state_arc AS
SELECT 
	arc_id
	FROM selector_state,arc
	WHERE arc.state=selector_state.state_id
	AND selector_state.cur_user=current_user

EXCEPT SELECT
	arc_id
	FROM selector_psector,plan_arc_x_psector
	WHERE plan_arc_x_psector.psector_id=selector_psector.psector_id
	AND selector_psector.cur_user=current_user AND state=0

UNION SELECT
	arc_id
	FROM selector_psector,plan_arc_x_psector
	WHERE plan_arc_x_psector.psector_id=selector_psector.psector_id
	AND selector_psector.cur_user=current_user AND state=1;
	


DROP VIEW IF EXISTS v_state_node CASCADE;
CREATE VIEW v_state_node AS
SELECT 
	node_id
	FROM selector_state,node
	WHERE node.state=selector_state.state_id
	AND selector_state.cur_user=current_user

EXCEPT SELECT
	node_id
	FROM selector_psector,plan_node_x_psector
	WHERE plan_node_x_psector.psector_id=selector_psector.psector_id
	AND selector_psector.cur_user=current_user AND state=0

UNION SELECT
	node_id
	FROM selector_psector,plan_node_x_psector
	WHERE plan_node_x_psector.psector_id=selector_psector.psector_id
	AND selector_psector.cur_user=current_user AND state=1;


	
DROP VIEW IF EXISTS v_state_connec CASCADE;
CREATE VIEW v_state_connec AS
SELECT 
	connec_id
	FROM selector_state,connec
	WHERE connec.state=selector_state.state_id
	AND selector_state.cur_user=current_user;

	

DROP VIEW IF EXISTS v_state_gully CASCADE;
CREATE VIEW v_state_gully AS
SELECT 
	gully_id
	FROM selector_state,gully
	WHERE gully.state=selector_state.state_id
	AND selector_state.cur_user=current_user;

		
	
-- ----------------------------
-- View structure for v_arc_x_node
-- ----------------------------

DROP VIEW IF EXISTS v_arc CASCADE;
CREATE OR REPLACE VIEW v_arc AS 
SELECT 
arc.arc_id, 
arc.node_1, 
arc.node_2,
(CASE 
	WHEN (arc.custom_y1 IS NOT NULL) THEN arc.custom_y1::numeric (12,3)    
	ELSE y1::numeric (12,3) END) AS y1,													-- field to customize the different options of y1 (mts or cms, field name or behaviour about the use of y1/custom_y1 fields
(CASE 
	WHEN (arc.custom_y2 IS NOT NULL) THEN arc.custom_y2::numeric (12,3)		
	ELSE y2::numeric (12,3) END) AS y2,													-- field to customize the different options of y2 (mts or cms, field name or behaviour about the use of y2/custom_y2 fields
CASE
	WHEN arc.custom_elev1 IS NOT NULL THEN arc.custom_elev1
    ELSE arc.elev1
    END AS elev1,
CASE
    WHEN arc.custom_elev2 IS NOT NULL THEN arc.custom_elev2
    ELSE arc.elev2
    END AS elev2,												
arc.arccat_id,
cat_arc.matcat_id,																	-- field to customize de source of the data matcat_id (from arc catalog or directly from arc table)
arc.arc_type,
arc.soilcat_id,
CASE
	WHEN arc.builtdate IS NOT NULL THEN arc.builtdate
	ELSE '1900-01-01'::date
	END AS builtdate, 
arc.epa_type,
arc.sector_id,
arc.state,
arc.state_type,
arc.annotation,
(CASE 
WHEN (arc.custom_length IS NOT NULL) THEN custom_length::numeric (12,3)				-- field to use length/customized_length
ELSE st_length2d(arc.the_geom)::numeric (12,3) END) AS length,
arc.the_geom
FROM arc
	JOIN cat_arc ON arc.arccat_id = cat_arc.id
	JOIN v_state_arc ON arc.arc_id=v_state_arc.arc_id;



DROP VIEW IF EXISTS v_node CASCADE;
CREATE OR REPLACE VIEW v_node AS
SELECT
node.node_id,
(CASE 
	WHEN (node.custom_top_elev IS NOT NULL) THEN node.custom_top_elev::numeric (12,3)    
	ELSE top_elev::numeric (12,3) END) AS top_elev,										-- field to customize the different options of top_elev (mts or cms, field name or behaviour about the use of top_elev/custom_top_elev fields)
(CASE 
	WHEN (node.custom_ymax IS NOT NULL) THEN node.custom_ymax::numeric (12,3)		
	ELSE ymax::numeric (12,3) END) AS ymax,												-- field to customize the different options of ymax (mts or cms, field name or behaviour about the use of y2/custom_y2 fields)
CASE
    WHEN (node.elev IS NOT NULL AND node.custom_elev IS NULL) THEN node.elev
    WHEN node.custom_elev IS NOT NULL THEN node.custom_elev
    ELSE (node.top_elev - node.ymax)::numeric(12,3)
    END AS elev,
node.nodecat_id,
node.node_type,
node.epa_type,
node.soilcat_id,
node.sector_id,
node.dma_id,
node.state,
node.state_type,
node.annotation,
node.the_geom
FROM node
JOIN v_state_node ON node.node_id=v_state_node.node_id;

   
   
DROP VIEW IF EXISTS v_arc_x_node1 CASCADE;
CREATE OR REPLACE VIEW v_arc_x_node1 AS 
SELECT arc.arc_id,
    arc.node_1,
    node.top_elev AS top_elev1,
    node.ymax AS ymax1,
    node.elev AS elev1,
    CASE
          WHEN arc.elev1 IS NOT NULL THEN arc.elev1
          ELSE node.top_elev - arc.y1
          END AS elevmax1,
    arc.y1,
    node.ymax - arc.y1 AS z1,
    cat_arc.geom1,
    arc.y1 - cat_arc.geom1 AS r1
   FROM v_arc arc
     JOIN v_node node ON arc.node_1 = node.node_id
     JOIN cat_arc ON arc.arccat_id = cat_arc.id AND arc.arccat_id = cat_arc.id;

	 	 
	 
DROP VIEW IF EXISTS v_arc_x_node2 CASCADE;
CREATE OR REPLACE VIEW v_arc_x_node2 AS 
SELECT arc.arc_id,
    arc.node_2,
    node.top_elev AS top_elev2,
    node.ymax AS ymax2,
	node.elev AS elev2,
    CASE
          WHEN arc.elev2 IS NOT NULL THEN arc.elev2
          ELSE node.top_elev - arc.y2
          END AS elevmax2,
    arc.y2,
    node.ymax - arc.y2 AS z2,
    cat_arc.geom1,
    arc.y2 - cat_arc.geom1 AS r2
   FROM v_arc arc
     JOIN v_node node ON arc.node_2 = node.node_id
     JOIN cat_arc ON arc.arccat_id = cat_arc.id AND arc.arccat_id = cat_arc.id;

	 

DROP VIEW IF EXISTS v_arc_x_node CASCADE;
CREATE OR REPLACE VIEW v_arc_x_node AS 
 SELECT v_arc.arc_id,
    v_arc_x_node1.node_1,
    v_arc_x_node1.top_elev1,
    v_arc_x_node1.ymax1,
    v_arc_x_node1.elev1,
    v_arc.y1,
        CASE
            WHEN v_arc_x_node1.z1 IS NOT NULL THEN v_arc_x_node1.z1
            ELSE 0::numeric
        END AS z1,
    v_arc_x_node1.elevmax1,
    v_arc_x_node2.node_2,
    v_arc_x_node2.top_elev2,
    v_arc_x_node2.ymax2,
    v_arc_x_node2.elev2,
    v_arc.y2,
        CASE
            WHEN v_arc_x_node2.z2 IS NOT NULL THEN v_arc_x_node2.z2
            ELSE 0::numeric
        END AS z2,
    v_arc_x_node2.elevmax2,
    v_arc_x_node1.geom1,
    v_arc_x_node1.r1,
    v_arc_x_node2.r2,
        CASE
            WHEN st_length(v_arc.the_geom) = 0::double precision THEN NULL::numeric(6,4)
            WHEN ((1::numeric * (v_arc_x_node1.elevmax1 - v_arc_x_node2.elevmax2))::double precision / st_length(v_arc.the_geom)) > 1::double precision THEN NULL::numeric(6,4)
            ELSE ((1::numeric * (v_arc_x_node1.elevmax1 - v_arc_x_node2.elevmax2))::double precision / st_length(v_arc.the_geom))::numeric(6,4)
        END AS slope,
    v_arc.state,
	v_arc.state_type,
    v_arc.sector_id,
    v_arc.soilcat_id,
    v_arc.annotation,
	v_arc.builtdate,
    v_arc.length,
    v_arc.the_geom
   FROM v_arc
     LEFT JOIN v_arc_x_node1 ON v_arc_x_node1.arc_id::text = v_arc.arc_id::text
     LEFT JOIN v_arc_x_node2 ON v_arc_x_node2.arc_id::text = v_arc.arc_id::text;

