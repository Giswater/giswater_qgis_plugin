/*
This file is part of Giswater 2.0
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association


*/


-- ----------------------------
-- Default values of node editing views
-- ----------------------------


ALTER VIEW "SCHEMA_NAME".v_edit_inp_junction ALTER y0 SET DEFAULT 0;
ALTER VIEW "SCHEMA_NAME".v_edit_inp_junction ALTER ysur SET DEFAULT 0;
ALTER VIEW "SCHEMA_NAME".v_edit_inp_junction ALTER apond SET DEFAULT 0;


ALTER VIEW "SCHEMA_NAME".v_edit_inp_divider ALTER y0 SET DEFAULT 0;
ALTER VIEW "SCHEMA_NAME".v_edit_inp_divider ALTER ysur SET DEFAULT 0;
ALTER VIEW "SCHEMA_NAME".v_edit_inp_divider ALTER apond SET DEFAULT 0;


ALTER VIEW "SCHEMA_NAME".v_edit_inp_outfall ALTER outfall_type SET DEFAULT 'NORMAL';
ALTER VIEW "SCHEMA_NAME".v_edit_inp_outfall ALTER ymax SET DEFAULT 0;


ALTER VIEW "SCHEMA_NAME".v_edit_inp_storage ALTER y0 SET DEFAULT 0;
ALTER VIEW "SCHEMA_NAME".v_edit_inp_storage ALTER ysur SET DEFAULT 0;
ALTER VIEW "SCHEMA_NAME".v_edit_inp_storage ALTER apond SET DEFAULT 0;



-- ----------------------------
-- Default values of arc editing views
-- ----------------------------

ALTER VIEW "SCHEMA_NAME".v_edit_inp_conduit ALTER y1 SET DEFAULT 0;
ALTER VIEW "SCHEMA_NAME".v_edit_inp_conduit ALTER y2 SET DEFAULT 0;
ALTER VIEW "SCHEMA_NAME".v_edit_inp_conduit ALTER barrels SET DEFAULT 1;
ALTER VIEW "SCHEMA_NAME".v_edit_inp_conduit ALTER kentry SET DEFAULT 0;
ALTER VIEW "SCHEMA_NAME".v_edit_inp_conduit ALTER kexit SET DEFAULT 0;
ALTER VIEW "SCHEMA_NAME".v_edit_inp_conduit ALTER kavg SET DEFAULT 0;
ALTER VIEW "SCHEMA_NAME".v_edit_inp_conduit ALTER flap SET DEFAULT 'NO';
ALTER VIEW "SCHEMA_NAME".v_edit_inp_conduit ALTER q0 SET DEFAULT 0;
ALTER VIEW "SCHEMA_NAME".v_edit_inp_conduit ALTER qmax SET DEFAULT 0;
ALTER VIEW "SCHEMA_NAME".v_edit_inp_conduit ALTER seepage SET DEFAULT 0;
ALTER VIEW "SCHEMA_NAME".v_edit_inp_conduit ALTER state SET DEFAULT 'ON_SERVICE';
ALTER VIEW "SCHEMA_NAME".v_edit_inp_conduit ALTER verified SET DEFAULT 'TO REVIEW';

ALTER VIEW "SCHEMA_NAME".v_edit_inp_orifice ALTER state SET DEFAULT 'ON_SERVICE';
ALTER VIEW "SCHEMA_NAME".v_edit_inp_orifice ALTER verified SET DEFAULT 'TO REVIEW';

ALTER VIEW "SCHEMA_NAME".v_edit_inp_pump ALTER state SET DEFAULT 'ON_SERVICE';
ALTER VIEW "SCHEMA_NAME".v_edit_inp_pump ALTER verified SET DEFAULT 'TO REVIEW';

ALTER VIEW "SCHEMA_NAME".v_edit_inp_outlet ALTER state SET DEFAULT 'ON_SERVICE';
ALTER VIEW "SCHEMA_NAME".v_edit_inp_outlet ALTER verified SET DEFAULT 'TO REVIEW';

ALTER VIEW "SCHEMA_NAME".v_edit_inp_weir ALTER state SET DEFAULT 'ON_SERVICE';
ALTER VIEW "SCHEMA_NAME".v_edit_inp_weir ALTER verified SET DEFAULT 'TO REVIEW';





-- ----------------------------
-- Default values of hydrologics
-- ----------------------------
INSERT INTO "SCHEMA_NAME"."cat_hydrology" VALUES ('HC_DEFAULT', 'CURVE_NUMBER', 'Default value of infiltration');
ALTER TABLE "SCHEMA_NAME".subcatchment ALTER COLUMN hydrology_id SET DEFAULT 'HC_DEFAULT';



-- ----------------------------
-- Default values of subcatchment
-- ----------------------------
ALTER TABLE "SCHEMA_NAME".subcatchment ALTER COLUMN imperv SET DEFAULT 90;
ALTER TABLE "SCHEMA_NAME".subcatchment ALTER COLUMN nimp SET DEFAULT 0.01;
ALTER TABLE "SCHEMA_NAME".subcatchment ALTER COLUMN nperv SET DEFAULT 0.1;
ALTER TABLE "SCHEMA_NAME".subcatchment ALTER COLUMN simp SET DEFAULT 0.05;
ALTER TABLE "SCHEMA_NAME".subcatchment ALTER COLUMN sperv SET DEFAULT 0.05;
ALTER TABLE "SCHEMA_NAME".subcatchment ALTER COLUMN zero SET DEFAULT 25;
ALTER TABLE "SCHEMA_NAME".subcatchment ALTER COLUMN rted SET DEFAULT 100;


-- ----------------------------
-- Records of inp_options
-- ----------------------------
 
INSERT INTO "SCHEMA_NAME"."inp_options" VALUES ('CMS', 'DYNWAVE', 'DEPTH', 'H-W', 'NO', 'NO', 'NO', 'NO', 'NO', 'NO', '01/01/2001', '00:00:00', '01/01/2001', '05:00:00', '01/01/2001', '00:00:00', '01/01', '12/31', '10', '00:15:00', '00:05:00', '01:00:00', '00:00:02', null, null, 'NONE', 'BOTH', '0', '0', 'YES', null, '0','0','5','5');


-- ----------------------------
-- Records of inp_report
-- ----------------------------
 
INSERT INTO "SCHEMA_NAME"."inp_report" VALUES ('YES', 'YES', 'YES', 'YES', 'ALL', 'ALL', 'ALL');



