/*
This file is part of Giswater 3
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association
*/



SET search_path = SCHEMA_NAME, public, pg_catalog;

UPDATE arc SET sector_id = expl_id;
UPDATE node SET sector_id = expl_id;
UPDATE connec SET sector_id = expl_id;
UPDATE link SET sector_id = expl_id;

DELETE FROM inp_rules;
DELETE FROM inp_controls;
DELETE FROM node_border_sector;

DELETE FROM sector WHERE sector_id > 2;

UPDATE sector s SET the_geom = e.the_geom FROM exploitation e WHERE s.sector_id = e.expl_id;

UPDATE inp_valve SET valv_type =NULL, custom_dint=null, status= null, pressure=null, flow=null, to_arc=null;
UPDATE inp_pump SET curve_id = null, status= null, to_arc = null, pump_type = null;
UPDATE inp_pump_additional SET curve_id = null, status= null;
UPDATE inp_reservoir SET head = null, pattern_id = null;
UPDATE inp_inlet SET head = null, pattern_id = null, initlevel=null, minlevel=null, maxlevel=null, diameter=null, curve_id=null, overflow=null;
UPDATE inp_junction SET demand=null, pattern_id = null;
UPDATE inp_connec SET demand=null, pattern_id = null;

UPDATE ext_hydrometer_category SET pattern_id = null;
UPDATE ext_rtc_dma_period SET pattern_id = null;
UPDATE dma SET pattern_id = null;
UPDATE sector SET pattern_id = null;

DELETE FROM cat_dscenario;

DELETE FROM inp_pattern;
DELETE FROM inp_curve;

DELETE FROM plan_psector;

UPDATE cat_mat_roughness SET roughness = null;

DELETE FROM rpt_cat_result;