/*
This file is part of Giswater 3
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association
*/



SET search_path = "SCHEMA_NAME", public, pg_catalog;


INSERT INTO inp_evaporation ('DRY_ONLY','NO');

DELETE FROM inp_junction WHERE node_id IN ('125','126','127','128','129','130','131','132');
UPDATE node set epa_type='OUTFALL' WHERE node_id IN ('126','127','128');
UPDATE node set epa_type='STORAGE' WHERE node_id IN ('125');
UPDATE node set epa_type='DIVIDER' WHERE node_id IN ('129','130','131','132');


DELETE FROM inp_conduit WHERE arc_id IN ('150','151','152','153','154','155','156','157','158','159');
UPDATE arc set epa_type='OUTLET' WHERE arc_id IN ('150','151','152','153');
UPDATE arc set epa_type='ORIFICE' WHERE arc_id IN ('158','159');
UPDATE arc set epa_type='WEIR' WHERE arc_id IN ('154','155','156','157');

UPDATE inp_conduit SET flap='NO';

UPDATE subcatchment SET snow_id='Spack_01';

INSERT INTO SCHEMA_NAME.inp_inflows (node_id, timser_id, sfactor, base, pattern_id) 
SELECT node_id, 'T5-5m', 1, 0.2, 'pattern_01' FROM SCHEMA_NAME.node;
INSERT INTO SCHEMA_NAME.inp_inflows_pol_x_node (poll_id, node_id, timser_id, form_type, mfactor, sfactor, base, pattern_id) 
SELECT 'SS',node_id, 'T5-5m', 'CONCEN_INFLOWS',1, 1, 0.2, 'pattern_01' FROM SCHEMA_NAME.node;

---------






---------

INSERT INTO SCHEMA_NAME.inp_coverage_land_x_subc SELECT subc_id, landus_id, 0.5 FROM SCHEMA_NAME.subcatchment, SCHEMA_NAME.inp_landuses

UPDATE inp_junction SET y0=random(), ysur=random(), apond=random()*100  ;
UPDATE inp_divider SET y0=random(), ysur=random(), apond= random()*100 ;
UPDATE inp_conduit SET kentry=random()*0.3, kexit=random()*0.3, kavg=random()*0.3 , q0=random()*01, qmax=random(), custom_n=0.011 ;

UPDATE inp_dwf SET pat1='pattern_01', pat2='pattern_02', pat3='pattern_03', pat4='pattern_04';

UPDATE 