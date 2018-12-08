-- View: ws_sample.ve_visit_multievent_x_arc

DROP VIEW ws_sample.ve_visit_multievent_x_arc;

CREATE OR REPLACE VIEW ws_sample.ve_visit_multievent_x_arc AS 
 SELECT 
    om_visit_x_arc.visit_id,
    om_visit_x_arc.arc_id,
    om_visit.visitcat_id,
    om_visit.ext_code,
    om_visit.startdate,
    om_visit.enddate,
    om_visit.user_name,
    om_visit.webclient_id,
    om_visit.expl_id,
    om_visit.the_geom,
    om_visit.descript,
    om_visit.is_done,
    om_visit.class_id,
    om_visit.suspendendcat_id,
    a.param_1 AS sediments_arc,
    a.param_2 AS desperfectes_arc,
    a.param_3 AS neteja_arc
   FROM ws_sample.om_visit
     JOIN ws_sample.om_visit_class ON om_visit_class.id = om_visit.class_id
     JOIN ws_sample.om_visit_x_arc ON om_visit.id = om_visit_x_arc.visit_id
     LEFT JOIN ( SELECT ct.visit_id,
            ct.param_1,
            ct.param_2,
            ct.param_3
           FROM crosstab('SELECT visit_id, om_visit_event.parameter_id, value 
			FROM ws_sample.om_visit JOIN ws_sample.om_visit_event ON om_visit.id= om_visit_event.visit_id 
			JOIN ws_sample.om_visit_class on om_visit_class.id=om_visit.class_id
			JOIN ws_sample.om_visit_class_x_parameter on om_visit_class_x_parameter.parameter_id=om_visit_event.parameter_id 
			where om_visit_class.ismultievent = TRUE ORDER  BY 1,2'::text, ' VALUES (''sediments_arc''),(''desperfectes_arc''),(''neteja_arc'')'::text) ct(visit_id integer, param_1 text, param_2 text, param_3 text)) a ON a.visit_id = om_visit.id
  WHERE om_visit_class.ismultievent = true;

ALTER TABLE ws_sample.ve_visit_multievent_x_arc
  OWNER TO geoadmin;
GRANT ALL ON TABLE ws_sample.ve_visit_multievent_x_arc TO geoadmin;
GRANT ALL ON TABLE ws_sample.ve_visit_multievent_x_arc TO role_basic;

-- Trigger: gw_trg_om_visit_multievent on ws_sample.ve_visit_multievent_x_arc

-- DROP TRIGGER gw_trg_om_visit_multievent ON ws_sample.ve_visit_multievent_x_arc;

CREATE TRIGGER gw_trg_om_visit_multievent
  INSTEAD OF INSERT OR UPDATE OR DELETE
  ON ws_sample.ve_visit_multievent_x_arc
  FOR EACH ROW
  EXECUTE PROCEDURE ws_sample.gw_trg_om_visit_multievent('arc');




-- View: ws_sample.ve_visit_multievent_x_node

DROP VIEW ws_sample.ve_visit_multievent_x_node;

CREATE OR REPLACE VIEW ws_sample.ve_visit_multievent_x_node AS 
 SELECT 
    om_visit_x_node.visit_id,
    om_visit_x_node.node_id,
    om_visit.visitcat_id,
    om_visit.ext_code,
    om_visit.startdate,
    om_visit.enddate,
    om_visit.user_name,
    om_visit.webclient_id,
    om_visit.expl_id,
    om_visit.the_geom,
    om_visit.descript,
    om_visit.is_done,
    om_visit.class_id,
    om_visit.suspendendcat_id,
    a.param_1 AS sediments_node,
    a.param_2 AS desperfectes_node,
    a.param_3 AS neteja_node
   FROM ws_sample.om_visit
     JOIN ws_sample.om_visit_class ON om_visit_class.id = om_visit.class_id
     JOIN ws_sample.om_visit_x_node ON om_visit.id = om_visit_x_node.visit_id
     LEFT JOIN ( SELECT ct.visit_id,
            ct.param_1,
            ct.param_2,
            ct.param_3
           FROM crosstab('SELECT visit_id, om_visit_event.parameter_id, value 
			FROM ws_sample.om_visit JOIN ws_sample.om_visit_event ON om_visit.id= om_visit_event.visit_id 
			JOIN ws_sample.om_visit_class on om_visit_class.id=om_visit.class_id
			JOIN ws_sample.om_visit_class_x_parameter on om_visit_class_x_parameter.parameter_id=om_visit_event.parameter_id 
			where om_visit_class.ismultievent = TRUE ORDER  BY 1,2'::text, ' VALUES (''sediments_node''),(''desperfectes_node''),(''neteja_node'')'::text) ct(visit_id integer, param_1 text, param_2 text, param_3 text)) a ON a.visit_id = om_visit.id
  WHERE om_visit_class.ismultievent = true;

ALTER TABLE ws_sample.ve_visit_multievent_x_node
  OWNER TO geoadmin;
GRANT ALL ON TABLE ws_sample.ve_visit_multievent_x_node TO geoadmin;
GRANT ALL ON TABLE ws_sample.ve_visit_multievent_x_node TO role_basic;

-- Trigger: gw_trg_om_visit_multievent on ws_sample.ve_visit_multievent_x_node

-- DROP TRIGGER gw_trg_om_visit_multievent ON ws_sample.ve_visit_multievent_x_node;

CREATE TRIGGER gw_trg_om_visit_multievent
  INSTEAD OF INSERT OR UPDATE OR DELETE
  ON ws_sample.ve_visit_multievent_x_node
  FOR EACH ROW
  EXECUTE PROCEDURE ws_sample.gw_trg_om_visit_multievent('node');


-- View: ws_sample.ve_visit_multievent_x_connec

DROP VIEW ws_sample.ve_visit_multievent_x_connec;

CREATE OR REPLACE VIEW ws_sample.ve_visit_multievent_x_connec AS 
 SELECT 
    om_visit_x_connec.visit_id,
    om_visit_x_connec.connec_id,
    om_visit.visitcat_id,
    om_visit.ext_code,
    om_visit.startdate,
    om_visit.enddate,
    om_visit.user_name,
    om_visit.webclient_id,
    om_visit.expl_id,
    om_visit.the_geom,
    om_visit.descript,
    om_visit.is_done,
    om_visit.class_id,
    om_visit.suspendendcat_id,
    a.param_1 AS sediments_connec,
    a.param_2 AS desperfectes_connec,
    a.param_3 AS neteja_connec
   FROM ws_sample.om_visit
     JOIN ws_sample.om_visit_class ON om_visit_class.id = om_visit.class_id
     JOIN ws_sample.om_visit_x_connec ON om_visit.id = om_visit_x_connec.visit_id
     LEFT JOIN ( SELECT ct.visit_id,
            ct.param_1,
            ct.param_2,
            ct.param_3
           FROM crosstab('SELECT visit_id, om_visit_event.parameter_id, value 
			FROM ws_sample.om_visit JOIN ws_sample.om_visit_event ON om_visit.id= om_visit_event.visit_id 
			JOIN ws_sample.om_visit_class on om_visit_class.id=om_visit.class_id
			JOIN ws_sample.om_visit_class_x_parameter on om_visit_class_x_parameter.parameter_id=om_visit_event.parameter_id 
			where om_visit_class.ismultievent = TRUE ORDER  BY 1,2'::text, ' VALUES (''sediments_connec''),(''desperfectes_connec''),(''neteja_connec'')'::text) ct(visit_id integer, param_1 text, param_2 text, param_3 text)) a ON a.visit_id = om_visit.id
  WHERE om_visit_class.ismultievent = true;

ALTER TABLE ws_sample.ve_visit_multievent_x_connec
  OWNER TO geoadmin;
GRANT ALL ON TABLE ws_sample.ve_visit_multievent_x_connec TO geoadmin;
GRANT ALL ON TABLE ws_sample.ve_visit_multievent_x_connec TO role_basic;

-- Trigger: gw_trg_om_visit_multievent on ws_sample.ve_visit_multievent_x_connec

-- DROP TRIGGER gw_trg_om_visit_multievent ON ws_sample.ve_visit_multievent_x_connec;

CREATE TRIGGER gw_trg_om_visit_multievent
  INSTEAD OF INSERT OR UPDATE OR DELETE
  ON ws_sample.ve_visit_multievent_x_connec
  FOR EACH ROW
  EXECUTE PROCEDURE ws_sample.gw_trg_om_visit_multievent('connec');



-- View: ws_sample.ve_visit_singlevent_x_arc

DROP VIEW ws_sample.ve_visit_singlevent_x_arc;

CREATE OR REPLACE VIEW ws_sample.ve_visit_singlevent_x_arc AS 
 SELECT 
    om_visit_x_arc.visit_id,
    om_visit_x_arc.arc_id,
    om_visit.visitcat_id,
    om_visit.ext_code,
    om_visit.startdate,
    om_visit.enddate,
    om_visit.user_name,
    om_visit.webclient_id,
    om_visit.expl_id,
    om_visit.the_geom,
    om_visit.descript,
    om_visit.is_done,
    om_visit.class_id,
    om_visit.suspendendcat_id,
    om_visit_event.event_code,
    om_visit_event.position_id,
    om_visit_event.position_value,
    om_visit_event.parameter_id,
    om_visit_event.value,
    om_visit_event.value1,
    om_visit_event.value2,
    om_visit_event.geom1,
    om_visit_event.geom2,
    om_visit_event.geom3,
    om_visit_event.xcoord,
    om_visit_event.ycoord,
    om_visit_event.compass,
    om_visit_event.tstamp,
    om_visit_event.text,
    om_visit_event.index_val,
    om_visit_event.is_last
   FROM ws_sample.om_visit
     JOIN ws_sample.om_visit_event ON om_visit.id = om_visit_event.visit_id
     JOIN ws_sample.om_visit_x_arc ON om_visit.id = om_visit_x_arc.visit_id
     JOIN ws_sample.om_visit_class ON om_visit_class.id = om_visit.class_id
  WHERE om_visit_class.ismultievent = false;

ALTER TABLE ws_sample.ve_visit_singlevent_x_arc
  OWNER TO geoadmin;
GRANT ALL ON TABLE ws_sample.ve_visit_singlevent_x_arc TO geoadmin;
GRANT ALL ON TABLE ws_sample.ve_visit_singlevent_x_arc TO role_basic;

-- Trigger: gw_trg_om_visit_singlevent on ws_sample.ve_visit_singlevent_x_arc

-- DROP TRIGGER gw_trg_om_visit_singlevent ON ws_sample.ve_visit_singlevent_x_arc;

CREATE TRIGGER gw_trg_om_visit_singlevent
  INSTEAD OF INSERT OR UPDATE OR DELETE
  ON ws_sample.ve_visit_singlevent_x_arc
  FOR EACH ROW
  EXECUTE PROCEDURE ws_sample.gw_trg_om_visit_singlevent('singlevent_x_arc');






-- View: ws_sample.ve_visit_multievent_x_connec


-- View: ws_sample.ve_visit_singlevent_x_connec
 DROP VIEW ws_sample.ve_visit_singlevent_x_connec;

CREATE OR REPLACE VIEW ws_sample.ve_visit_singlevent_x_connec AS 
 SELECT 
    om_visit_x_connec.visit_id,
    om_visit_x_connec.connec_id,
    om_visit.visitcat_id,
    om_visit.ext_code,
    om_visit.startdate,
    om_visit.enddate,
    om_visit.user_name,
    om_visit.webclient_id,
    om_visit.expl_id,
    om_visit.the_geom,
    om_visit.descript,
    om_visit.is_done,
    om_visit.class_id,
    om_visit.suspendendcat_id,
    om_visit_event.event_code,
    om_visit_event.position_id,
    om_visit_event.position_value,
    om_visit_event.parameter_id,
    om_visit_event.value,
    om_visit_event.value1,
    om_visit_event.value2,
    om_visit_event.geom1,
    om_visit_event.geom2,
    om_visit_event.geom3,
    om_visit_event.xcoord,
    om_visit_event.ycoord,
    om_visit_event.compass,
    om_visit_event.tstamp,
    om_visit_event.text,
    om_visit_event.index_val,
    om_visit_event.is_last
   FROM ws_sample.om_visit
     JOIN ws_sample.om_visit_event ON om_visit.id = om_visit_event.visit_id
     JOIN ws_sample.om_visit_x_connec ON om_visit.id = om_visit_x_connec.visit_id
     JOIN ws_sample.om_visit_class ON om_visit_class.id = om_visit.class_id
  WHERE om_visit_class.ismultievent = false;

ALTER TABLE ws_sample.ve_visit_singlevent_x_connec
  OWNER TO geoadmin;
GRANT ALL ON TABLE ws_sample.ve_visit_singlevent_x_connec TO geoadmin;
GRANT ALL ON TABLE ws_sample.ve_visit_singlevent_x_connec TO role_basic;

-- Trigger: gw_trg_om_visit_singlevent on ws_sample.ve_visit_singlevent_x_connec

-- DROP TRIGGER gw_trg_om_visit_singlevent ON ws_sample.ve_visit_singlevent_x_connec;

CREATE TRIGGER gw_trg_om_visit_singlevent
  INSTEAD OF INSERT OR UPDATE OR DELETE
  ON ws_sample.ve_visit_singlevent_x_connec
  FOR EACH ROW
  EXECUTE PROCEDURE ws_sample.gw_trg_om_visit_singlevent('singlevent_x_connec');

-- View: ws_sample.ve_visit_singlevent_x_node
DROP VIEW ws_sample.ve_visit_singlevent_x_node;

CREATE OR REPLACE VIEW ws_sample.ve_visit_singlevent_x_node AS 
 SELECT 
    om_visit_x_node.visit_id,
    om_visit_x_node.node_id,
    om_visit.visitcat_id,
    om_visit.ext_code,
    om_visit.startdate,
    om_visit.enddate,
    om_visit.user_name,
    om_visit.webclient_id,
    om_visit.expl_id,
    om_visit.the_geom,
    om_visit.descript,
    om_visit.is_done,
    om_visit.class_id,
    om_visit.suspendendcat_id,
    om_visit_event.event_code,
    om_visit_event.position_id,
    om_visit_event.position_value,
    om_visit_event.parameter_id,
    om_visit_event.value,
    om_visit_event.value1,
    om_visit_event.value2,
    om_visit_event.geom1,
    om_visit_event.geom2,
    om_visit_event.geom3,
    om_visit_event.xcoord,
    om_visit_event.ycoord,
    om_visit_event.compass,
    om_visit_event.tstamp,
    om_visit_event.text,
    om_visit_event.index_val,
    om_visit_event.is_last
   FROM ws_sample.om_visit
     JOIN ws_sample.om_visit_event ON om_visit.id = om_visit_event.visit_id
     JOIN ws_sample.om_visit_x_node ON om_visit.id = om_visit_x_node.visit_id
     JOIN ws_sample.om_visit_class ON om_visit_class.id = om_visit.class_id
  WHERE om_visit_class.ismultievent = false;

ALTER TABLE ws_sample.ve_visit_singlevent_x_node
  OWNER TO geoadmin;
GRANT ALL ON TABLE ws_sample.ve_visit_singlevent_x_node TO geoadmin;
GRANT ALL ON TABLE ws_sample.ve_visit_singlevent_x_node TO role_basic;

-- Trigger: gw_trg_om_visit_singlevent on ws_sample.ve_visit_singlevent_x_node

-- DROP TRIGGER gw_trg_om_visit_singlevent ON ws_sample.ve_visit_singlevent_x_node;

CREATE TRIGGER gw_trg_om_visit_singlevent
  INSTEAD OF INSERT OR UPDATE OR DELETE
  ON ws_sample.ve_visit_singlevent_x_node
  FOR EACH ROW
  EXECUTE PROCEDURE ws_sample.gw_trg_om_visit_singlevent('singlevent_x_node');

