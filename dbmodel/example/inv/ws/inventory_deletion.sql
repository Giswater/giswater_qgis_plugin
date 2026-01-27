/*
This file is part of Giswater
The program is free software: you can redistribute it and/or modify it under the terms of the GNU
General Public License as published by the Free Software Foundation, either version 3 of the License,
or (at your option) any later version.
*/



SET search_path = SCHEMA_NAME, public, pg_catalog;

ALTER TABLE sector DISABLE TRIGGER gw_trg_edit_controls;
ALTER TABLE dqa DISABLE TRIGGER gw_trg_edit_controls;

UPDATE config_param_user SET value = true where parameter = 'plan_psector_force_delete';

UPDATE arc SET sector_id = expl_id;
UPDATE node SET sector_id = expl_id;
UPDATE connec SET sector_id = expl_id;
UPDATE link SET sector_id = expl_id;

DELETE FROM inp_rules;
DELETE FROM inp_controls;

DELETE FROM sector WHERE sector_id > 2;

UPDATE sector s SET the_geom = e.the_geom FROM exploitation e WHERE s.sector_id = e.expl_id;
UPDATE sector SET "name"='sector2-1s', expl_id='{2}', macrosector_id=2 WHERE sector_id=2;

UPDATE inp_valve SET valve_type =NULL, custom_dint=null;
UPDATE inp_pump SET curve_id = null, status= null, pump_type = null;
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

UPDATE config_param_user SET value = false where parameter = 'plan_psector_force_delete';

DELETE FROM inp_pump_additional;

UPDATE arc SET dqa_id=0 ;
UPDATE node SET dqa_id=0 ;
UPDATE connec SET dqa_id=0 ;
UPDATE link SET dqa_id=0 ;

DELETE FROM dqa WHERE dqa_id > 0;

UPDATE man_valve SET to_arc=null WHERE node_id = 1083;
UPDATE inp_valve SET setting=null WHERE node_id = 1083;
UPDATE man_pump SET to_arc=null WHERE node_id = 1105;

ALTER TABLE sector ENABLE TRIGGER gw_trg_edit_controls;
ALTER TABLE dqa ENABLE TRIGGER gw_trg_edit_controls;

UPDATE man_valve SET to_arc=null WHERE node_id = 1107;
