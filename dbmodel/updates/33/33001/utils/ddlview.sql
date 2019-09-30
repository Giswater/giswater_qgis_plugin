/*
This file is part of Giswater 3
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association
*/

SET search_path = SCHEMA_NAME, public, pg_catalog;

--30/09/2019

DROP VIEW IF EXISTS v_edit_samplepoint;
CREATE OR REPLACE VIEW v_edit_samplepoint AS 
 SELECT samplepoint.sample_id,
    samplepoint.code,
    samplepoint.lab_code,
    samplepoint.feature_id,
    samplepoint.featurecat_id,
    samplepoint.dma_id,
    dma.macrodma_id,
    samplepoint.state,
    samplepoint.builtdate,
    samplepoint.enddate,
    samplepoint.workcat_id,
    samplepoint.workcat_id_end,
    samplepoint.rotation,
    samplepoint.muni_id,
    samplepoint.postcode,
    samplepoint.streetaxis_id,
    samplepoint.postnumber,
    samplepoint.postcomplement,
    samplepoint.streetaxis2_id,
    samplepoint.postnumber2,
    samplepoint.postcomplement2,
    samplepoint.place_name,
    samplepoint.cabinet,
    samplepoint.observations,
    samplepoint.verified,
    samplepoint.the_geom,
    samplepoint.expl_id,
    samplepoint.link
   FROM selector_expl,
    samplepoint
     JOIN v_state_samplepoint ON samplepoint.sample_id::text = v_state_samplepoint.sample_id::text
     LEFT JOIN dma ON dma.dma_id = samplepoint.dma_id
  WHERE samplepoint.expl_id = selector_expl.expl_id AND selector_expl.cur_user = "current_user"()::text;