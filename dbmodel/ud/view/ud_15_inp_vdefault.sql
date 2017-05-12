/*
This file is part of Giswater 2.0
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association


*/

SET search_path = "SCHEMA_NAME", public, pg_catalog;
-- ----------------------------
-- Default values of node editing views
-- ----------------------------


ALTER VIEW v_edit_inp_junction ALTER y0 SET DEFAULT 0;
ALTER VIEW v_edit_inp_junction ALTER ysur SET DEFAULT 0;
ALTER VIEW v_edit_inp_junction ALTER apond SET DEFAULT 0;


ALTER VIEW v_edit_inp_divider ALTER y0 SET DEFAULT 0;
ALTER VIEW v_edit_inp_divider ALTER ysur SET DEFAULT 0;
ALTER VIEW v_edit_inp_divider ALTER apond SET DEFAULT 0;


ALTER VIEW v_edit_inp_outfall ALTER outfall_type SET DEFAULT 'NORMAL';
ALTER VIEW v_edit_inp_outfall ALTER ymax SET DEFAULT 0;


ALTER VIEW v_edit_inp_storage ALTER y0 SET DEFAULT 0;
ALTER VIEW v_edit_inp_storage ALTER ysur SET DEFAULT 0;
ALTER VIEW v_edit_inp_storage ALTER apond SET DEFAULT 0;



-- ----------------------------
-- Default values of arc editing views
-- ----------------------------

ALTER VIEW v_edit_inp_conduit ALTER y1 SET DEFAULT 0;
ALTER VIEW v_edit_inp_conduit ALTER y2 SET DEFAULT 0;
ALTER VIEW v_edit_inp_conduit ALTER barrels SET DEFAULT 1;
ALTER VIEW v_edit_inp_conduit ALTER kentry SET DEFAULT 0;
ALTER VIEW v_edit_inp_conduit ALTER kexit SET DEFAULT 0;
ALTER VIEW v_edit_inp_conduit ALTER kavg SET DEFAULT 0;
ALTER VIEW v_edit_inp_conduit ALTER flap SET DEFAULT 'NO';
ALTER VIEW v_edit_inp_conduit ALTER q0 SET DEFAULT 0;
ALTER VIEW v_edit_inp_conduit ALTER qmax SET DEFAULT 0;
ALTER VIEW v_edit_inp_conduit ALTER seepage SET DEFAULT 0;
ALTER VIEW v_edit_inp_conduit ALTER state SET DEFAULT 'ON_SERVICE';
ALTER VIEW v_edit_inp_conduit ALTER verified SET DEFAULT 'TO REVIEW';

ALTER VIEW v_edit_inp_orifice ALTER state SET DEFAULT 'ON_SERVICE';
ALTER VIEW v_edit_inp_orifice ALTER verified SET DEFAULT 'TO REVIEW';

ALTER VIEW v_edit_inp_pump ALTER state SET DEFAULT 'ON_SERVICE';
ALTER VIEW v_edit_inp_pump ALTER verified SET DEFAULT 'TO REVIEW';

ALTER VIEW v_edit_inp_outlet ALTER state SET DEFAULT 'ON_SERVICE';
ALTER VIEW v_edit_inp_outlet ALTER verified SET DEFAULT 'TO REVIEW';

ALTER VIEW v_edit_inp_weir ALTER state SET DEFAULT 'ON_SERVICE';
ALTER VIEW v_edit_inp_weir ALTER verified SET DEFAULT 'TO REVIEW';





-- ----------------------------
-- Default values of hydrologics
-- ----------------------------
ALTER TABLE subcatchment ALTER COLUMN hydrology_id SET DEFAULT 'HC_DEFAULT';



-- ----------------------------
-- Default values of subcatchment
-- ----------------------------
ALTER TABLE subcatchment ALTER COLUMN imperv SET DEFAULT 90;
ALTER TABLE subcatchment ALTER COLUMN nimp SET DEFAULT 0.01;
ALTER TABLE subcatchment ALTER COLUMN nperv SET DEFAULT 0.1;
ALTER TABLE subcatchment ALTER COLUMN simp SET DEFAULT 0.05;
ALTER TABLE subcatchment ALTER COLUMN sperv SET DEFAULT 0.05;
ALTER TABLE subcatchment ALTER COLUMN zero SET DEFAULT 25;
ALTER TABLE subcatchment ALTER COLUMN rted SET DEFAULT 100;






