/*
This file is part of Giswater 3
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association
*/


SET search_path = SCHEMA_NAME ,public;


CREATE OR REPLACE VIEW vu_link AS
 SELECT l.link_id,
    l.feature_type,
    l.feature_id,
    l.exit_type,
    l.exit_id,
    l.state,
    l.expl_id,
    l.sector_id,
    l.dma_id,
    l.exit_topelev,
    l.exit_elev,
    l.fluid_type,
    st_length2d(l.the_geom)::numeric(12,3) AS gis_length,
    l.the_geom,
    s.name AS sector_name,
    s.macrosector_id,
    d.macrodma_id,
    l.expl_id2,
    l.epa_type,
    l.is_operative,
    l.drainzone_id,
    r.name as drainzone_name,
    l.connecat_id,
    l.workcat_id,
    l.workcat_id_end,
    l.builtdate,
    l.enddate,
    date_trunc('second'::text, l.lastupdate) AS lastupdate,
    l.lastupdate_user
   FROM link l
     LEFT JOIN sector s USING (sector_id)
     LEFT JOIN dma d USING (dma_id)
     LEFT JOIN drainzone r USING (drainzone_id);

create or replace view v_link_connec as 
select distinct on (link_id) * from vu_link_connec
JOIN v_state_link_connec USING (link_id);

create or replace view v_link_gully as 
select distinct on (link_id) * from vu_link_gully
JOIN v_state_link_gully USING (link_id);

create or replace view v_link as 
select distinct on (link_id) * from vu_link
JOIN v_state_link USING (link_id);

CREATE OR REPLACE VIEW v_edit_link AS SELECT *
FROM v_link l;