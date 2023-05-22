/*
This file is part of Giswater 3
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association
*/

-- 22/05/2023
CREATE OR REPLACE VIEW ve_visit_arc_leak
AS SELECT om_visit_x_arc.id,
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
    om_visit.status,
    a.param_1 AS leak_arc
   FROM om_visit
     JOIN config_visit_class ON config_visit_class.id = om_visit.class_id
     JOIN om_visit_x_arc ON om_visit.id = om_visit_x_arc.visit_id
     LEFT JOIN ( SELECT ct.visit_id,
            ct.param_1
           FROM crosstab('SELECT visit_id, om_visit_event.parameter_id, value
      FROM om_visit LEFT JOIN om_visit_event ON om_visit.id= om_visit_event.visit_id
      LEFT JOIN config_visit_class on config_visit_class.id=om_visit.class_id
      LEFT JOIN config_visit_class_x_parameter on config_visit_class_x_parameter.parameter_id=om_visit_event.parameter_id
      where config_visit_class.ismultievent = TRUE AND config_visit_class.id = 1 ORDER  BY 1,2'::text, ' VALUES (''leak_arc'')'::text) ct(visit_id integer, param_1 text)) a ON a.visit_id = om_visit.id
  WHERE config_visit_class.ismultievent = true AND config_visit_class.id = 1;


CREATE OR REPLACE VIEW ve_visit_connec_insp
AS SELECT om_visit_x_connec.id,
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
    om_visit.status,
    a.param_1 AS sediments_connec,
    a.param_2 AS defect_connec,
    a.param_3 AS clean_connec
   FROM om_visit
     JOIN config_visit_class ON config_visit_class.id = om_visit.class_id
     JOIN om_visit_x_connec ON om_visit.id = om_visit_x_connec.visit_id
     LEFT JOIN ( SELECT ct.visit_id,
            ct.param_1,
            ct.param_2,
            ct.param_3
           FROM crosstab('SELECT visit_id, om_visit_event.parameter_id, value
      FROM om_visit LEFT JOIN om_visit_event ON om_visit.id= om_visit_event.visit_id
      LEFT JOIN config_visit_class on config_visit_class.id=om_visit.class_id
      LEFT JOIN config_visit_class_x_parameter on config_visit_class_x_parameter.parameter_id=om_visit_event.parameter_id
      where config_visit_class.ismultievent = TRUE AND config_visit_class.id = 2 ORDER  BY 1,2'::text, ' VALUES (''sediments_connec''),(''defect_connec''),(''clean_connec'')'::text) ct(visit_id integer, param_1 text, param_2 text, param_3 text)) a ON a.visit_id = om_visit.id
  WHERE config_visit_class.ismultievent = true AND config_visit_class.id = 2;


CREATE OR REPLACE VIEW ve_visit_node_leak
AS SELECT om_visit_x_node.id,
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
    om_visit.status,
    a.param_1 AS leak_node
   FROM om_visit
     JOIN config_visit_class ON config_visit_class.id = om_visit.class_id
     JOIN om_visit_x_node ON om_visit.id = om_visit_x_node.visit_id
     LEFT JOIN ( SELECT ct.visit_id,
            ct.param_1
           FROM crosstab('SELECT visit_id, om_visit_event.parameter_id, value
      FROM om_visit LEFT JOIN om_visit_event ON om_visit.id= om_visit_event.visit_id
      LEFT JOIN config_visit_class on config_visit_class.id=om_visit.class_id
      LEFT JOIN config_visit_class_x_parameter on config_visit_class_x_parameter.parameter_id=om_visit_event.parameter_id
      where config_visit_class.ismultievent = TRUE AND config_visit_class.id = 3 ORDER  BY 1,2'::text, ' VALUES (''leak_node'')'::text) ct(visit_id integer, param_1 text, param_2 text, param_3 text)) a ON a.visit_id = om_visit.id
  WHERE config_visit_class.ismultievent = true AND config_visit_class.id = 3;



CREATE OR REPLACE VIEW ve_visit_connec_leak
AS SELECT om_visit_x_connec.id,
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
    om_visit.status,
    a.param_1 AS leak_connec
   FROM om_visit
     JOIN config_visit_class ON config_visit_class.id = om_visit.class_id
     JOIN om_visit_x_connec ON om_visit.id = om_visit_x_connec.visit_id
     LEFT JOIN ( SELECT ct.visit_id,
            ct.param_1
           FROM crosstab('SELECT visit_id, om_visit_event.parameter_id, value
      FROM om_visit LEFT JOIN om_visit_event ON om_visit.id= om_visit_event.visit_id
      LEFT JOIN config_visit_class on config_visit_class.id=om_visit.class_id
      LEFT JOIN config_visit_class_x_parameter on config_visit_class_x_parameter.parameter_id=om_visit_event.parameter_id
      where config_visit_class.ismultievent = TRUE AND config_visit_class.id = 4 ORDER  BY 1,2'::text, ' VALUES (''leak_connec'')'::text) ct(visit_id integer, param_1 text)) a ON a.visit_id = om_visit.id
  WHERE config_visit_class.ismultievent = true AND config_visit_class.id = 4;


CREATE OR REPLACE VIEW ve_visit_node_insp
AS SELECT om_visit_x_node.id,
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
    om_visit.status,
    a.param_1 AS sediments_node,
    a.param_2 AS defect_node,
    a.param_3 AS clean_node
   FROM om_visit
     JOIN config_visit_class ON config_visit_class.id = om_visit.class_id
     JOIN om_visit_x_node ON om_visit.id = om_visit_x_node.visit_id
     LEFT JOIN ( SELECT ct.visit_id,
            ct.param_1,
            ct.param_2,
            ct.param_3
           FROM crosstab('SELECT visit_id, om_visit_event.parameter_id, value
      FROM om_visit LEFT JOIN om_visit_event ON om_visit.id= om_visit_event.visit_id
      LEFT JOIN config_visit_class on config_visit_class.id=om_visit.class_id
      LEFT JOIN config_visit_class_x_parameter on config_visit_class_x_parameter.parameter_id=om_visit_event.parameter_id
      where config_visit_class.ismultievent = TRUE AND config_visit_class.id = 5 ORDER  BY 1,2'::text, ' VALUES (''sediments_node''),(''defect_node''),(''clean_node'')'::text) ct(visit_id integer, param_1 text, param_2 text, param_3 text)) a ON a.visit_id = om_visit.id
  WHERE config_visit_class.ismultievent = true AND config_visit_class.id = 5;


CREATE OR REPLACE VIEW ve_visit_arc_insp
AS SELECT om_visit_x_arc.id,
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
    om_visit.status,
    a.param_1 AS sediments_arc,
    a.param_2 AS defect_arc,
    a.param_3 AS clean_arc
   FROM om_visit
     JOIN config_visit_class ON config_visit_class.id = om_visit.class_id
     JOIN om_visit_x_arc ON om_visit.id = om_visit_x_arc.visit_id
     LEFT JOIN ( SELECT ct.visit_id,
            ct.param_1,
            ct.param_2,
            ct.param_3
           FROM crosstab('SELECT visit_id, om_visit_event.parameter_id, value
      FROM om_visit LEFT JOIN om_visit_event ON om_visit.id= om_visit_event.visit_id
      LEFT JOIN config_visit_class on config_visit_class.id=om_visit.class_id
      LEFT JOIN config_visit_class_x_parameter on config_visit_class_x_parameter.parameter_id=om_visit_event.parameter_id
      where config_visit_class.ismultievent = TRUE AND config_visit_class.id = 6 ORDER  BY 1,2'::text, ' VALUES (''sediments_arc''),(''defect_arc''),(''clean_arc'')'::text) ct(visit_id integer, param_1 text, param_2 text, param_3 text)) a ON a.visit_id = om_visit.id
  WHERE config_visit_class.ismultievent = true AND config_visit_class.id = 6;


CREATE OR REPLACE VIEW ve_visit_valve_insp
AS SELECT om_visit_x_node.visit_id,
    om_visit_x_node.node_id,
    node.code,
    om_visit.visitcat_id,
    om_visit.ext_code,
    om_visit.startdate,
    om_visit.enddate,
    om_visit.user_name,
    om_visit.webclient_id,
    om_visit.expl_id,
    node.the_geom,
    om_visit.descript,
    om_visit.is_done,
    om_visit.class_id,
    config_visit_class.idval AS class_name,
    om_visit.lot_id,
    om_visit.status,
    s.idval AS status_name,
    a.param_1 AS defect_valve,
    d.idval AS defect_valve_v,
    a.param_2 AS clean_valve,
    c.idval AS clean_valve_v,
    a.param_3 AS manipulate_valve,
    a.param_4 AS observ_valve
   FROM om_visit
     JOIN config_visit_class ON config_visit_class.id = om_visit.class_id
     JOIN om_visit_x_node ON om_visit.id = om_visit_x_node.visit_id
     JOIN node ON node.node_id::text = om_visit_x_node.node_id::text
     LEFT JOIN om_typevalue s ON om_visit.status = s.id::integer AND s.typevalue = 'visit_status'::text
     LEFT JOIN ( SELECT ct.visit_id,
            ct.param_1,
            ct.param_2,
            ct.param_3,
            ct.param_4
           FROM crosstab('SELECT visit_id, om_visit_event.parameter_id, value
      FROM om_visit JOIN om_visit_event ON om_visit.id= om_visit_event.visit_id
      LEFT JOIN config_visit_class on config_visit_class.id=om_visit.class_id
      where config_visit_class.ismultievent = TRUE AND config_visit_class.id=7 ORDER  BY 1,2'::text, ' VALUES (''defect_valve''),(''clean_valve''),(''manipulate_valve''),(''observ_valve'')'::text) ct(visit_id integer, param_1 text, param_2 text, param_3 boolean, param_4 text)) a ON a.visit_id = om_visit.id
     LEFT JOIN om_typevalue d ON d.id::text = a.param_1 AND d.typevalue = 'visit_defect'::text
     LEFT JOIN om_typevalue c ON c.id::text = a.param_2 AND c.typevalue = 'visit_cleaned'::text
  WHERE config_visit_class.ismultievent = true AND config_visit_class.id = 7;


  -- GRANT PERMISIONS --

GRANT SELECT, TRIGGER, UPDATE, DELETE, REFERENCES, INSERT, TRUNCATE ON TABLE ve_visit_arc_insp TO role_om;
GRANT SELECT, TRIGGER, UPDATE, DELETE, REFERENCES, INSERT, TRUNCATE ON TABLE ve_visit_connec_insp TO role_om;
GRANT SELECT, TRIGGER, UPDATE, DELETE, REFERENCES, INSERT, TRUNCATE ON TABLE ve_visit_node_insp TO role_om;
GRANT SELECT, TRIGGER, UPDATE, DELETE, REFERENCES, INSERT, TRUNCATE ON TABLE ve_visit_valve_insp TO role_om;

GRANT SELECT, TRIGGER, UPDATE, DELETE, REFERENCES, INSERT, TRUNCATE ON TABLE ve_visit_arc_leak TO role_om;
GRANT SELECT, TRIGGER, UPDATE, DELETE, REFERENCES, INSERT, TRUNCATE ON TABLE ve_visit_node_leak TO role_om;
GRANT SELECT, TRIGGER, UPDATE, DELETE, REFERENCES, INSERT, TRUNCATE ON TABLE ve_visit_connec_leak TO role_om;