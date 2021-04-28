/*
This file is part of Giswater 3
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association
*/


SET search_path = SCHEMA_NAME, public, pg_catalog;

-- 2021/04/20
CREATE OR REPLACE VIEW v_edit_vnode AS 
 SELECT DISTINCT ON (a.vnode_id) a.vnode_id,
    a.feature_type,
    a.elev,
    a.sector_id,
    a.dma_id,
    a.state,
    a.the_geom,
    a.expl_id,
    a.link_class
   FROM ( SELECT v.vnode_id,
            l.feature_type,
            v.elev,
            l.sector_id,
            l.dma_id,
            l.state,
            st_endpoint(l.the_geom) AS the_geom,
            l.expl_id,
            l.link_class
           FROM v_edit_link l
             JOIN vnode v ON l.exit_id::integer = v.vnode_id
          WHERE l.exit_type::text = 'VNODE'::text
          ORDER BY l.link_class DESC) a;