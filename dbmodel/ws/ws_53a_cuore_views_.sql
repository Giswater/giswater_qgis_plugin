/*
This file is part of Giswater 2.0
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association
*/


DROP VIEW IF EXISTS "SCHEMA_NAME".v_ext_urban_propierties;
CREATE OR REPLACE VIEW "SCHEMA_NAME".v_ext_urban_propierties AS
SELECT
    ext_urban_propierties.id,
    connec.connec_id, 
    connec.connecat_id, 
    cat_connec.type AS cat_connectype_id, 
    cat_connec.matcat_id AS cat_matcat_id, 
    cat_connec.pnom AS cat_pnom, 
    cat_connec.dnom AS cat_dnom, 
    connec.sector_id, 
    connec.code, 
    v_rtc_hydrometer_x_connec.n_hydrometer, 
    connec.demand, 
    connec.state, 
    connec.annotation, 
    connec.observ, 
    connec.comment, 
    connec.dma_id, 
    dma.presszonecat_id, 
    connec.soilcat_id, 
    connec.category_type, 
    connec.fluid_type, 
    connec.location_type, 
    connec.workcat_id, 
    connec.buildercat_id, 
    connec.builtdate, 
    connec.ownercat_id, 
    connec.adress_01, 
    connec.adress_02, 
    connec.adress_03, 
    connec.streetaxis_id, 
    ext_streetaxis.name, 
    connec.postnumber, 
    connec.descript, 
    vnode.arc_id, 
    cat_connec.svg AS cat_svg, 
    connec.rotation, 
    connec.link, 
    connec.verified, 
    ext_urban_propierties.the_geom
   FROM SCHEMA_NAME.connec
   JOIN SCHEMA_NAME.ext_urban_propierties ON connec.code::text = ext_urban_propierties.code::text
   JOIN SCHEMA_NAME.v_rtc_hydrometer_x_connec ON connec.connec_id::text = v_rtc_hydrometer_x_connec.connec_id::text
   JOIN SCHEMA_NAME.cat_connec ON connec.connecat_id::text = cat_connec.id::text
   LEFT JOIN SCHEMA_NAME.ext_streetaxis ON connec.streetaxis_id::text = ext_streetaxis.id::text
   LEFT JOIN SCHEMA_NAME.link ON connec.connec_id::text = link.connec_id::text
   LEFT JOIN SCHEMA_NAME.vnode ON vnode.vnode_id::text = link.vnode_id::text
   LEFT JOIN SCHEMA_NAME.dma ON connec.dma_id::text = dma.dma_id::text;