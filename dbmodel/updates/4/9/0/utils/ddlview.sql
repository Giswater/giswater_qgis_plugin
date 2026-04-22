/*
This file is part of Giswater
The program is free software: you can redistribute it and/or modify it under the terms of the GNU
General Public License as published by the Free Software Foundation, either version 3 of the License,
or (at your option) any later version.
*/


SET search_path = SCHEMA_NAME, public, pg_catalog;


CREATE OR REPLACE VIEW v_municipality AS
SELECT * FROM ext_municipality;

CREATE OR REPLACE VIEW ve_municipality
AS SELECT DISTINCT s.muni_id,
    m.name,
    m.active,
    m.the_geom
   FROM v_municipality m,
    selector_municipality s
  WHERE m.muni_id = s.muni_id AND s.cur_user = "current_user"()::text;
  
  
CREATE OR REPLACE VIEW v_streetaxis AS
SELECT * FROM ext_streetaxis;

CREATE OR REPLACE VIEW ve_streetaxis
AS SELECT v_streetaxis.id,
    v_streetaxis.code,
    v_streetaxis.type,
    v_streetaxis.name,
    v_streetaxis.text,
    v_streetaxis.the_geom,
    v_streetaxis.muni_id,
        CASE
            WHEN v_streetaxis.type IS NULL THEN v_streetaxis.name::text
            WHEN v_streetaxis.text IS NULL THEN ((v_streetaxis.name::text || ', '::text) || v_streetaxis.type::text) || '.'::text
            WHEN v_streetaxis.type IS NULL AND v_streetaxis.text IS NULL THEN v_streetaxis.name::text
            ELSE (((v_streetaxis.name::text || ', '::text) || v_streetaxis.type::text) || '. '::text) || v_streetaxis.text
        END AS descript,
    v_streetaxis.source
   FROM selector_municipality,
    v_streetaxis
  WHERE v_streetaxis.muni_id = selector_municipality.muni_id AND selector_municipality.cur_user = "current_user"()::text;
  
  
CREATE OR REPLACE VIEW v_address AS
SELECT * FROM ext_address;

CREATE OR REPLACE VIEW ve_address
AS SELECT v_address.id,
    v_address.muni_id,
    v_address.postcode,
    v_address.streetaxis_id,
    v_address.postnumber,
    v_address.plot_id,
    v_streetaxis.name,
    v_address.the_geom,
    v_address.postcomplement,
    v_address.code,
    v_address.source
   FROM selector_municipality s,
    v_address
     LEFT JOIN v_streetaxis ON v_streetaxis.id::text = v_address.streetaxis_id::text
  WHERE v_address.muni_id = s.muni_id AND s.cur_user = "current_user"()::text;
  
  
CREATE OR REPLACE VIEW v_plot AS
SELECT * FROM ext_plot;

CREATE OR REPLACE VIEW ve_plot
AS SELECT v_plot.id,
    v_plot.code,
    v_plot.muni_id,
    v_plot.postcode,
    v_plot.streetaxis_id,
    v_plot.postnumber,
    v_plot.complement,
    v_plot.placement,
    v_plot.square,
    v_plot.observ,
    v_plot.text,
    v_plot.the_geom
   FROM selector_municipality s,
    v_plot
  WHERE v_plot.muni_id = s.muni_id AND s.cur_user = "current_user"()::text;
  
  
CREATE OR REPLACE VIEW v_raster_dem AS
SELECT * FROM ext_raster_dem;

CREATE OR REPLACE VIEW ve_raster_dem
AS SELECT DISTINCT ON (r.id) r.id,
    c.code,
    c.alias,
    c.raster_type,
    c.descript,
    c.source,
    c.provider,
    c.year,
    r.rast,
    r.rastercat_id,
    r.envelope
   FROM ve_municipality a,
    v_raster_dem r
     JOIN ext_cat_raster c ON c.id = r.rastercat_id
  WHERE st_dwithin(r.envelope, a.the_geom, 0::double precision);
  
CREATE OR REPLACE VIEW v_district AS
SELECT * FROM ext_district;

CREATE OR REPLACE VIEW ve_district
AS SELECT v_district.*
   FROM selector_municipality s,
    v_district
  WHERE v_district.muni_id = s.muni_id AND s.cur_user = "current_user"()::text;

CREATE OR REPLACE VIEW v_region AS
SELECT * FROM ext_region;

CREATE OR REPLACE VIEW v_province AS
SELECT * FROM ext_province;

CREATE OR REPLACE VIEW vf_arc AS 
 SELECT a.arc_id, COALESCE(pp.state, a.state) AS p_state
   FROM arc a
     LEFT JOIN LATERAL ( SELECT pp_1.state
           FROM plan_psector_x_arc pp_1
          WHERE pp_1.arc_id = a.arc_id AND (pp_1.psector_id IN ( SELECT sp.psector_id
                   FROM selector_psector sp
                  WHERE sp.cur_user = CURRENT_USER))
          ORDER BY pp_1.psector_id DESC
         LIMIT 1) pp ON true
  WHERE (EXISTS ( SELECT 1
           FROM selector_state ss
          WHERE ss.state_id = COALESCE(pp.state, a.state) AND ss.cur_user = CURRENT_USER)) AND (EXISTS ( SELECT 1
           FROM selector_sector ssec
          WHERE ssec.sector_id = a.sector_id AND ssec.cur_user = CURRENT_USER)) AND (EXISTS ( SELECT 1
           FROM selector_municipality sm
          WHERE sm.muni_id = a.muni_id AND sm.cur_user = CURRENT_USER)) AND (EXISTS ( SELECT 1
           FROM selector_expl se
          WHERE (se.expl_id = ANY (array_append(a.expl_visibility::integer[], a.expl_id))) AND se.cur_user = CURRENT_USER));
          
CREATE OR REPLACE VIEW vf_node AS 
 SELECT n.node_id, COALESCE(pp.state, n.state) AS p_state
   FROM node n
     LEFT JOIN LATERAL ( SELECT pp_1.state
           FROM plan_psector_x_node pp_1
          WHERE pp_1.node_id = n.node_id AND (pp_1.psector_id IN ( SELECT sp.psector_id
                   FROM selector_psector sp
                  WHERE sp.cur_user = CURRENT_USER))
          ORDER BY pp_1.psector_id DESC
         LIMIT 1) pp ON true
  WHERE (EXISTS ( SELECT 1
           FROM selector_state ss
          WHERE ss.state_id = COALESCE(pp.state, n.state) AND ss.cur_user = CURRENT_USER)) AND (EXISTS ( SELECT 1
           FROM selector_sector ssec
          WHERE ssec.sector_id = n.sector_id AND ssec.cur_user = CURRENT_USER)) AND (EXISTS ( SELECT 1
           FROM selector_municipality sm
          WHERE sm.muni_id = n.muni_id AND sm.cur_user = CURRENT_USER)) AND (EXISTS ( SELECT 1
           FROM selector_expl se
          WHERE (se.expl_id = ANY (array_append(n.expl_visibility::integer[], n.expl_id))) AND se.cur_user = CURRENT_USER));

CREATE OR REPLACE VIEW vf_connec AS 
SELECT 
  c.connec_id, 
  COALESCE(pp.state, c.state) AS p_state, 
  COALESCE(pp.arc_id, c.arc_id) AS arc_id, 
  COALESCE(pp.exit_id, c.pjoint_id) AS pjoint_id, 
  COALESCE(pp.exit_type, c.pjoint_type) AS pjoint_type
FROM connec c
LEFT JOIN LATERAL (SELECT pp_1.state,
            pp_1.arc_id,
            l.exit_id,
            l.exit_type
           FROM plan_psector_x_connec pp_1
            LEFT JOIN link l ON l.link_id = pp_1.link_id AND l.state = 2
          WHERE pp_1.connec_id = c.connec_id AND (pp_1.psector_id IN ( SELECT sp.psector_id
                   FROM selector_psector sp
                  WHERE sp.cur_user = CURRENT_USER))
          ORDER BY pp_1.psector_id DESC, pp_1.state DESC
         LIMIT 1) pp ON true
  WHERE (EXISTS ( SELECT 1
           FROM selector_state ss
          WHERE ss.state_id = COALESCE(pp.state, c.state) AND ss.cur_user = CURRENT_USER)) AND (EXISTS ( SELECT 1
           FROM selector_sector ssec
          WHERE ssec.sector_id = c.sector_id AND ssec.cur_user = CURRENT_USER)) AND (EXISTS ( SELECT 1
           FROM selector_municipality sm
          WHERE sm.muni_id = c.muni_id AND sm.cur_user = CURRENT_USER)) AND (EXISTS ( SELECT 1
           FROM selector_expl se
          WHERE (se.expl_id = ANY (array_append(c.expl_visibility::integer[], c.expl_id))) AND se.cur_user = CURRENT_USER));

 CREATE OR REPLACE VIEW vf_element AS 
 SELECT e.element_id
   FROM element e
  WHERE (EXISTS ( SELECT 1
           FROM selector_state ss
          WHERE ss.state_id = e.state AND ss.cur_user = CURRENT_USER)) AND (EXISTS ( SELECT 1
           FROM selector_sector ssec
          WHERE ssec.sector_id = e.sector_id AND ssec.cur_user = CURRENT_USER)) AND (EXISTS ( SELECT 1
           FROM selector_municipality sm
          WHERE sm.muni_id = e.muni_id AND sm.cur_user = CURRENT_USER)) AND (EXISTS ( SELECT 1
           FROM selector_expl se
          WHERE (se.expl_id = ANY (array_append(e.expl_visibility::integer[], e.expl_id))) AND se.cur_user = CURRENT_USER));    


CREATE OR REPLACE VIEW ve_element
AS 
SELECT 
  e.element_id,
  e.code,
  e.sys_code,
  e.top_elev,
  cat_element.element_type,
  e.elementcat_id,
  e.num_elements,
  e.epa_type,
  e.state,
  e.state_type,
  e.expl_id,
  e.muni_id,
  e.sector_id,
  e.omzone_id,
  e.function_type,
  e.category_type,
  e.location_type,
  e.observ,
  e.comment,
  cat_element.link,
  e.workcat_id,
  e.workcat_id_end,
  e.builtdate,
  e.enddate,
  e.ownercat_id,
  e.brand_id,
  e.model_id,
  e.serial_number,
  e.asset_id,
  e.verified,
  e.datasource,
  e.label_x,
  e.label_y,
  e.label_rotation,
  e.rotation,
  e.inventory,
  e.publish,
  e.trace_featuregeom,
  e.lock_level,
  e.expl_visibility,
  e.created_at,
  e.created_by,
  e.updated_at,
  e.updated_by,
  e.the_geom,
  e.uuid
FROM element e
JOIN vf_element vf ON vf.element_id = e.element_id
JOIN cat_element ON e.elementcat_id::text = cat_element.id::text;

-- 22/04/2026
DROP VIEW IF EXISTS ve_om_visit;
CREATE OR REPLACE VIEW ve_om_visit
AS SELECT om_visit.id,
    om_visit.visitcat_id,
    om_visit.ext_code,
    om_visit.status,
    om_visit.startdate,
    om_visit.enddate,
    om_visit.user_name,
    om_visit.the_geom,
    om_visit.webclient_id,
    om_visit.expl_id
   FROM selector_expl,
    om_visit
  WHERE om_visit.expl_id = selector_expl.expl_id AND selector_expl.cur_user = "current_user"();