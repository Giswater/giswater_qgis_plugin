


-- ve_exploitation source

CREATE OR REPLACE VIEW ve_exploitation
AS SELECT e.expl_id,
    e.code,
    e.name,
    e.macroexpl_id,
    e.sector_id,
    e.muni_id,
    e.owner_vdefault,
    e.descript,
    e.lock_level,
    e.active,
    e.the_geom,
    e.created_at,
    e.created_by,
    e.updated_at,
    e.updated_by
   FROM selector_expl se,
    exploitation e
  WHERE e.expl_id = se.expl_id AND se.cur_user = CURRENT_USER AND e.active IS TRUE;

CREATE OR REPLACE VIEW v_ui_om_visit
AS SELECT om_visit.id,
    om_visit_cat.name AS visit_catalog,
    om_visit.ext_code,
    om_visit.startdate,
    om_visit.enddate,
    om_visit.user_name,
    om_visit.webclient_id,
    exploitation.name AS exploitation,
    om_visit.the_geom,
    om_visit.descript,
    om_visit.is_done,
    om_visit.visit_type
   FROM om_visit
     LEFT JOIN om_visit_cat ON om_visit.visitcat_id = om_visit_cat.id
     LEFT JOIN exploitation ON exploitation.expl_id = om_visit.expl_id;


-- improve performance of v_anl_* with a CTE instead of a cross join
CREATE OR REPLACE VIEW v_anl_arc
AS WITH sel_audit AS (
    SELECT selector_audit.fid 
    FROM selector_audit 
    WHERE selector_audit.cur_user = CURRENT_USER
)
SELECT anl_arc.id,
    anl_arc.arc_id,
    anl_arc.arccat_id AS arc_type,
    anl_arc.state,
    anl_arc.arc_id_aux,
    anl_arc.fid AS fprocesscat_id,
    exploitation.name AS expl_name,
    anl_arc.the_geom,
    anl_arc.result_id,
    anl_arc.descript
FROM anl_arc
JOIN exploitation ON anl_arc.expl_id = exploitation.expl_id
WHERE EXISTS (
    SELECT 1 
    FROM sel_audit 
    WHERE sel_audit.fid = anl_arc.fid
)
AND anl_arc.cur_user = CURRENT_USER;


CREATE OR REPLACE VIEW v_anl_arc_point
AS WITH sel_audit AS (
    SELECT selector_audit.fid 
    FROM selector_audit 
    WHERE selector_audit.cur_user = CURRENT_USER
)
SELECT anl_arc.id,
    anl_arc.arc_id,
    anl_arc.arccat_id AS arc_type,
    anl_arc.state,
    anl_arc.arc_id_aux,
    anl_arc.fid AS fprocesscat_id,
    exploitation.name AS expl_name,
    anl_arc.the_geom_p
FROM anl_arc
JOIN sys_fprocess ON anl_arc.fid = sys_fprocess.fid
JOIN exploitation ON anl_arc.expl_id = exploitation.expl_id
WHERE EXISTS (
    SELECT 1 
    FROM sel_audit 
    WHERE sel_audit.fid = anl_arc.fid
)
AND anl_arc.cur_user = CURRENT_USER;


CREATE OR REPLACE VIEW v_anl_arc_x_node
AS WITH sel_audit AS (
    SELECT selector_audit.fid
    FROM selector_audit
    WHERE selector_audit.cur_user = CURRENT_USER
)
SELECT anl_arc_x_node.id,
    anl_arc_x_node.arc_id,
    anl_arc_x_node.arccat_id AS arc_type,
    anl_arc_x_node.state,
    anl_arc_x_node.node_id,
    anl_arc_x_node.fid AS fprocesscat_id,
    exploitation.name AS expl_name,
    anl_arc_x_node.the_geom
FROM anl_arc_x_node
JOIN exploitation ON anl_arc_x_node.expl_id = exploitation.expl_id
WHERE EXISTS (
    SELECT 1
    FROM sel_audit
    WHERE anl_arc_x_node.fid = sel_audit.fid
)
AND anl_arc_x_node.cur_user = CURRENT_USER;

CREATE OR REPLACE VIEW v_anl_arc_x_node_point
AS WITH sel_audit AS (
    SELECT selector_audit.fid
    FROM selector_audit
    WHERE selector_audit.cur_user = CURRENT_USER
)
SELECT anl_arc_x_node.id,
    anl_arc_x_node.arc_id,
    anl_arc_x_node.arccat_id AS arc_type,
    anl_arc_x_node.node_id,
    anl_arc_x_node.fid AS fprocesscat_id,
    exploitation.name AS expl_name,
    anl_arc_x_node.the_geom_p
FROM anl_arc_x_node
JOIN exploitation ON anl_arc_x_node.expl_id = exploitation.expl_id
WHERE EXISTS (
    SELECT 1
    FROM sel_audit
    WHERE anl_arc_x_node.fid = sel_audit.fid
)
AND anl_arc_x_node.cur_user = CURRENT_USER;

CREATE OR REPLACE VIEW v_anl_connec
AS WITH sel_audit AS (
    SELECT selector_audit.fid
    FROM selector_audit
    WHERE selector_audit.cur_user = CURRENT_USER
)
SELECT anl_connec.id,
    anl_connec.connec_id,
    anl_connec.conneccat_id AS connecat_id,
    anl_connec.state,
    anl_connec.connec_id_aux,
    anl_connec.connecat_id_aux AS state_aux,
    anl_connec.fid AS fprocesscat_id,
    exploitation.name AS expl_name,
    anl_connec.the_geom,
    anl_connec.result_id,
    anl_connec.descript
FROM anl_connec
    JOIN exploitation ON anl_connec.expl_id = exploitation.expl_id
WHERE EXISTS (
    SELECT 1
    FROM sel_audit
    WHERE anl_connec.fid = sel_audit.fid
)
AND anl_connec.cur_user = CURRENT_USER;


CREATE OR REPLACE VIEW v_anl_node
AS WITH sel_audit AS (
    SELECT selector_audit.fid
    FROM selector_audit
    WHERE selector_audit.cur_user = CURRENT_USER
)
SELECT anl_node.id,
    anl_node.node_id,
    anl_node.nodecat_id,
    anl_node.state,
    anl_node.node_id_aux,
    anl_node.nodecat_id_aux AS state_aux,
    anl_node.num_arcs,
    anl_node.fid AS fprocesscat_id,
    exploitation.name AS expl_name,
    anl_node.the_geom,
    anl_node.result_id,
    anl_node.descript
FROM anl_node
JOIN exploitation ON anl_node.expl_id = exploitation.expl_id
WHERE EXISTS (
    SELECT 1
    FROM sel_audit
    WHERE anl_node.fid = sel_audit.fid
)
AND anl_node.cur_user = CURRENT_USER;

CREATE OR REPLACE VIEW v_ui_macrosector
AS SELECT DISTINCT ON (macrosector_id) macrosector_id,
    code,
    name,
    descript,
    active,
    expl_id,
    muni_id,
    stylesheet::text AS stylesheet,
    lock_level,
    link,
    addparam::text AS addparam,
    created_at,
    created_by,
    updated_at,
    updated_by
FROM macrosector
WHERE macrosector_id > 0
ORDER BY macrosector_id;

CREATE OR REPLACE VIEW ve_macrosector
AS SELECT DISTINCT ON (macrosector_id) macrosector_id,
    code,
    name,
    descript,
    active,
    expl_id,
    muni_id,
    stylesheet::text AS stylesheet,
    lock_level,
    link,
    the_geom,
    addparam::text AS addparam,
    created_at,
    created_by,
    updated_at,
    updated_by
FROM macrosector m
WHERE macrosector_id > 0
ORDER BY macrosector_id;


CREATE OR REPLACE VIEW v_ui_macroomzone
AS SELECT DISTINCT ON (macroomzone_id) macroomzone_id,
    code,
    name,
    descript,
    active,
    expl_id,
    sector_id,
    muni_id,
    stylesheet::text AS stylesheet,
    lock_level,
    link,
    addparam::text AS addparam,
    created_at,
    created_by,
    updated_at,
    updated_by
FROM macroomzone m
WHERE macroomzone_id > 0
ORDER BY macroomzone_id;

CREATE OR REPLACE VIEW ve_macroomzone
AS SELECT DISTINCT ON (macroomzone_id) macroomzone_id,
    code,
    name,
    descript,
    active,
    expl_id,
    sector_id,
    muni_id,
    stylesheet::text AS stylesheet,
    lock_level,
    link,
    addparam::text AS addparam,
    created_at,
    created_by,
    updated_at,
    updated_by,
    the_geom
FROM macroomzone m
WHERE macroomzone_id > 0
ORDER BY macroomzone_id;
