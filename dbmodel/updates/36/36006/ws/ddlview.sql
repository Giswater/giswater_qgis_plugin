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
    presszone_id::character varying(16) AS presszone_id,
    l.dqa_id,
    l.minsector_id,
    l.exit_topelev,
    l.exit_elev,
    l.fluid_type,
    st_length2d(l.the_geom)::numeric(12,3) AS gis_length,
    l.the_geom,
    s.name AS sector_name,
    d.name AS dma_name,
    q.name AS dqa_name,
    p.name AS presszone_name,
    s.macrosector_id,
    d.macrodma_id,
    q.macrodqa_id,
    l.expl_id2,
    l.epa_type,
    l.is_operative,
    l.staticpressure,
    l.connecat_id,
    l.workcat_id,
    l.workcat_id_end,
    l.builtdate,
    l.enddate,
    date_trunc('second'::text, l.lastupdate) AS lastupdate,
    l.lastupdate_user
   FROM link l
     LEFT JOIN sector s USING (sector_id)
     LEFT JOIN presszone p USING (presszone_id)
     LEFT JOIN dma d USING (dma_id)
     LEFT JOIN dqa q USING (dqa_id);

create or replace view v_link_connec as 
select * from vu_link
JOIN v_state_link_connec USING (link_id);


create or replace view v_link as 
select * from vu_link
JOIN v_state_link USING (link_id);

CREATE OR REPLACE VIEW v_edit_link AS SELECT *
FROM v_link l;
