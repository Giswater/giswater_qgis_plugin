CREATE OR REPLACE VIEW SCHEMA_NAME.vp_epa_arc AS 
 SELECT arc_id AS nid,
 epa_type,
	case when epa_type='PIPE' THEN 've_inp_pipe' 
	     when epa_type='NOT DEFINED' THEN null
	     end as epatable	
   FROM SCHEMA_NAME.arc;

GRANT ALL ON TABLE SCHEMA_NAME.vp_epa_arc TO geoadmin;
GRANT ALL ON TABLE SCHEMA_NAME.vp_epa_arc TO user_dev;
GRANT ALL ON TABLE SCHEMA_NAME.vp_epa_arc TO qgisserver;
GRANT ALL ON TABLE SCHEMA_NAME.vp_epa_arc TO xtorret;
GRANT ALL ON TABLE SCHEMA_NAME.vp_epa_arc TO user_test;
GRANT ALL ON TABLE SCHEMA_NAME.vp_epa_arc TO rol_dev;
GRANT ALL ON TABLE SCHEMA_NAME.vp_epa_arc TO abofill;
GRANT ALL ON TABLE SCHEMA_NAME.vp_epa_arc TO postgres;
GRANT ALL ON TABLE SCHEMA_NAME.vp_epa_arc TO role_basic;

CREATE OR REPLACE VIEW SCHEMA_NAME.vp_epa_node AS 

 SELECT node_id AS nid,
  epa_type,
	case when epa_type='JUNCTION' THEN 've_inp_junction' 
		when epa_type='PUMP' THEN 've_inp_pump' 
		when epa_type='RESERVOIR' THEN 've_inp_reservoir' 
		when epa_type='TANK' THEN 've_inp_tank' 
		when epa_type='VALVE' THEN 've_inp_valve' 
		when epa_type='SHORTPIPE' THEN 've_inp_shortpipe' 
		when epa_type='NOT DEFINED' THEN null
		end as epatable
   FROM SCHEMA_NAME.node;

ALTER TABLE SCHEMA_NAME.vp_epa_node
  OWNER TO geoadmin;
GRANT ALL ON TABLE SCHEMA_NAME.vp_epa_node TO geoadmin;
GRANT ALL ON TABLE SCHEMA_NAME.vp_epa_node TO user_dev;
GRANT ALL ON TABLE SCHEMA_NAME.vp_epa_node TO qgisserver;
GRANT ALL ON TABLE SCHEMA_NAME.vp_epa_node TO xtorret;
GRANT ALL ON TABLE SCHEMA_NAME.vp_epa_node TO user_test;
GRANT ALL ON TABLE SCHEMA_NAME.vp_epa_node TO rol_dev;
GRANT ALL ON TABLE SCHEMA_NAME.vp_epa_node TO abofill;
GRANT ALL ON TABLE SCHEMA_NAME.vp_epa_node TO postgres;
GRANT ALL ON TABLE SCHEMA_NAME.vp_epa_node TO role_basic;