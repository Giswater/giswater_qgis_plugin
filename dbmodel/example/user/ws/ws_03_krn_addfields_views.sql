/*
This file is part of Giswater 3
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association
*/



SET search_path = "SCHEMA_NAME", public, pg_catalog;

CREATE EXTENSION IF NOT EXISTS tablefunc;

--FROM SYSTEM FEATURE EXPANSIONTANK
----------------------

CREATE OR REPLACE VIEW v_custom_expantank AS
SELECT 
v_edit_man_expansiontank.*
FROM v_edit_man_expansiontank
WHERE nodetype_id='EXPANTANK';




--FROM SYSTEM FEATURE FILTER
----------------------

CREATE OR REPLACE VIEW v_custom_filter AS
SELECT 
v_edit_man_filter.*
FROM v_edit_man_filter
WHERE nodetype_id='FILTER';




--FROM SYSTEM FEATURE FLEXUNION
----------------------

CREATE OR REPLACE VIEW v_custom_flexuion AS
SELECT 
v_edit_man_flexunion.*
FROM v_edit_man_flexunion
WHERE nodetype_id='FLEXUNION';




--FROM SYSTEM FEATURE HYDRANT
----------------------

CREATE OR REPLACE VIEW v_custom_hydrant AS
SELECT 
v_edit_man_hydrant.*
FROM v_edit_man_hydrant
WHERE nodetype_id='HYDRANT';




--FROM SYSTEM FEATURE JUNCTION
----------------------

CREATE OR REPLACE VIEW v_custom_t AS
SELECT 
v_edit_man_junction.*
FROM v_edit_man_junction
WHERE nodetype_id='T';

CREATE OR REPLACE VIEW v_custom_adaptation AS
SELECT 
v_edit_man_junction.*
FROM v_edit_man_junction
WHERE nodetype_id='ADAPTATION';


CREATE OR REPLACE VIEW v_custom_curve AS
SELECT 
v_edit_man_junction.*
FROM v_edit_man_junction
WHERE nodetype_id='CURVE';


CREATE OR REPLACE VIEW v_custom_endline AS
SELECT 
v_edit_man_junction.*
FROM v_edit_man_junction
WHERE nodetype_id='ENDLINE';


CREATE OR REPLACE VIEW v_custom_junction AS
SELECT 
v_edit_man_junction.*
FROM v_edit_man_junction
WHERE nodetype_id='JUNCTION';


CREATE OR REPLACE VIEW v_custom_x AS
SELECT 
v_edit_man_junction.*
FROM v_edit_man_junction
WHERE nodetype_id='X';




--FROM SYSTEM FEATURE MANHOLE
----------------------

CREATE OR REPLACE VIEW v_custom_register AS
SELECT 
v_edit_man_register.*
FROM v_edit_man_register
WHERE nodetype_id='REGISTER';




--FROM SYSTEM FEATURE METER
----------------------

CREATE OR REPLACE VIEW v_custom_register AS
SELECT 
v_edit_man_register.*
FROM v_edit_man_register
WHERE nodetype_id='REGISTER';



CREATE OR REPLACE VIEW v_custom_register AS
SELECT 
v_edit_man_register.*
FROM v_edit_man_register
WHERE nodetype_id='REGISTER';




--FROM SYSTEM FEATURE NETELEMENT
----------------------

CREATE OR REPLACE VIEW v_custom_register AS
SELECT 
v_edit_man_register.*
FROM v_edit_man_register
WHERE nodetype_id='REGISTER';




--FROM SYSTEM FEATURE NETSAMPLEPOINT
----------------------

CREATE OR REPLACE VIEW v_custom_register AS
SELECT 
v_edit_man_register.*
FROM v_edit_man_register
WHERE nodetype_id='REGISTER';




--FROM SYSTEM FEATURE NETWJOIN
----------------------

CREATE OR REPLACE VIEW v_custom_register AS
SELECT 
v_edit_man_register.*
FROM v_edit_man_register
WHERE nodetype_id='REGISTER';




--FROM SYSTEM FEATURE REDUCTION
----------------------

CREATE OR REPLACE VIEW v_custom_register AS
SELECT 
v_edit_man_register.*
FROM v_edit_man_register
WHERE nodetype_id='REGISTER';




--FROM SYSTEM FEATURE REGISTER
----------------------

CREATE OR REPLACE VIEW v_custom_controlregister AS
SELECT 
v_edit_man_register.*,
a.ctrlregister_param_1 AS "Param 1",
a.ctrlregister_param_2 AS "Param 2"
FROM v_edit_man_register
LEFT JOIN (
SELECT * FROM crosstab('SELECT feature_id, parameter_id, value_param FROM SCHEMA_NAME.man_addfields_value JOIN SCHEMA_NAME.man_addfields_parameter 
on man_addfields_parameter.id=parameter_id where featurecat_id=''CONTROL-REGISTER'' ORDER BY 1,2')
AS rpt ("feature_id" varchar, "ctrlregister_param_1" text, "ctrlregister_param_2" text)
)a ON node_id=feature_id
WHERE nodetype_id='CONTROL-REGISTER';


CREATE OR REPLACE VIEW v_custom_bypassregister AS
SELECT 
v_edit_man_register.*,
a.bpregister_param_1 AS "Param 1",
a.bpregister_param_2 AS "Param 2"
FROM v_edit_man_register
LEFT JOIN (
SELECT * FROM crosstab('SELECT feature_id, parameter_id, value_param FROM SCHEMA_NAME.man_addfields_value JOIN SCHEMA_NAME.man_addfields_parameter 
on man_addfields_parameter.id=parameter_id where featurecat_id=''BYPASS-REGISTER'' ORDER BY 1,2')
AS rpt ("feature_id" varchar, "bpregister_param_1" text, "bpregister_param_2" text)
)a ON node_id=feature_id
WHERE nodetype_id='BYPASS-REGISTER';


CREATE OR REPLACE VIEW v_custom_valveregister AS
SELECT 
v_edit_man_register.*,
a.valregister_param_1 AS "Param 1",
a.valregister_param_2 AS "Param 2"
FROM v_edit_man_register
LEFT JOIN (
SELECT * FROM crosstab('SELECT feature_id, parameter_id, value_param FROM SCHEMA_NAME.man_addfields_value JOIN SCHEMA_NAME.man_addfields_parameter 
on man_addfields_parameter.id=parameter_id where featurecat_id=''VALVE-REGISTER'' ORDER BY 1,2')
AS rpt ("feature_id" varchar, "valregister_param_1" text, "valregister_param_2" text)
)a ON node_id=feature_id
WHERE nodetype_id='VALVE-REGISTER';


CREATE OR REPLACE VIEW v_custom_register AS
SELECT 
v_edit_man_register.*
FROM v_edit_man_register
WHERE nodetype_id='REGISTER';



--FROM SYSTEM FEATURE SOURCE
----------------------

CREATE OR REPLACE VIEW v_custom_source AS
SELECT 
v_edit_man_source.*
FROM v_edit_man_source
WHERE nodetype_id='SOURCE';



--FROM SYSTEM FEATURE TANK
----------------------

CREATE OR REPLACE VIEW v_custom_tank AS
SELECT 
v_edit_man_tank.*
FROM v_edit_man_tank
WHERE nodetype_id='TANK';



--FROM SYSTEM FEATURE VALVE
----------------------

CREATE OR REPLACE VIEW v_custom_prsustvalve AS
SELECT 
v_edit_man_valve.*
FROM v_edit_man_valve
WHERE nodetype_id='PR-SUSTA.VALVE';



CREATE OR REPLACE VIEW v_custom_prredvalve AS
SELECT 
v_edit_man_valve.*
FROM v_edit_man_valve
WHERE nodetype_id='PR-REDUC.VALVE';


CREATE OR REPLACE VIEW v_custom_flowvalve AS
SELECT 
v_edit_man_valve.*
FROM v_edit_man_valve
WHERE nodetype_id='FL-CONTR.VALVE';


CREATE OR REPLACE VIEW v_custom_throttletvalve AS
SELECT 
v_edit_man_valve.*
FROM v_edit_man_valve
WHERE nodetype_id='THROTTLE.VALVE';


CREATE OR REPLACE VIEW v_custom_genvalve AS
SELECT 
v_edit_man_valve.*
FROM v_edit_man_valve
WHERE nodetype_id='GEN-PURP.VALVE';


CREATE OR REPLACE VIEW v_custom_shutoffvalve AS
SELECT 
v_edit_man_valve.*,
a.shtvalve_param_1 AS "Param 1",
a.shtvalve_param_2 AS "Param 2"
FROM v_edit_man_valve
LEFT JOIN (
SELECT * FROM crosstab('SELECT feature_id, parameter_id, value_param FROM SCHEMA_NAME.man_addfields_value JOIN SCHEMA_NAME.man_addfields_parameter 
on man_addfields_parameter.id=parameter_id where featurecat_id=''SHUTOFF-VALVE'' ORDER BY 1,2')
AS rpt ("feature_id" varchar, "shtvalve_param_1" text, "shtvalve_param_2" text)
)a ON node_id=feature_id
WHERE nodetype_id='SHUTOFF-VALVE';


CREATE OR REPLACE VIEW v_custom_outfallvalve AS
SELECT 
v_edit_man_valve.*,
a.outfallvalve_param_1 AS "Param 1",
a.outfallvalve_param_2 AS "Param 2"
FROM v_edit_man_valve
LEFT JOIN (
SELECT * FROM crosstab('SELECT feature_id, parameter_id, value_param FROM SCHEMA_NAME.man_addfields_value JOIN SCHEMA_NAME.man_addfields_parameter 
on man_addfields_parameter.id=parameter_id where featurecat_id=''OUTFALL-VALVE'' ORDER BY 1,2')
AS rpt ("feature_id" varchar, "outfallvalve_param_1" text, "outfallvalve_param_2" text)
)a ON node_id=feature_id
WHERE nodetype_id='OUTFALL-VALVE';


CREATE OR REPLACE VIEW v_custom_greenvalve AS
SELECT 
v_edit_man_valve.*,
a.greenvalve_param_1 AS "Param 1",
a.greenvalve_param_2 AS "Param 2"
FROM v_edit_man_valve
LEFT JOIN (
SELECT * FROM crosstab('SELECT feature_id, parameter_id, value_param FROM SCHEMA_NAME.man_addfields_value JOIN SCHEMA_NAME.man_addfields_parameter 
on man_addfields_parameter.id=parameter_id where featurecat_id=''GREEN-VALVE'' ORDER BY 1,2')
AS rpt ("feature_id" varchar, "greenvalve_param_1" text, "greenvalve_param_2" text)
)a ON node_id=feature_id
WHERE nodetype_id='GREEN-VALVE';


CREATE OR REPLACE VIEW v_custom_checkvalve AS
SELECT 
v_edit_man_valve.*,
a.checkvalve_param_1 AS "Param 1",
a.checkvalve_param_2 AS "Param 2"
FROM v_edit_man_valve
LEFT JOIN (
SELECT * FROM crosstab('SELECT feature_id, parameter_id, value_param FROM SCHEMA_NAME.man_addfields_value JOIN SCHEMA_NAME.man_addfields_parameter 
on man_addfields_parameter.id=parameter_id where featurecat_id=''CHECK-VALVE'' ORDER BY 1,2')
AS rpt ("feature_id" varchar, "checkvalve_param_1" text, "checkvalve_param_2" text)
)a ON node_id=feature_id
WHERE nodetype_id='CHECK-VALVE';


CREATE OR REPLACE VIEW v_custom_airvalve AS
SELECT 
v_edit_man_valve.*,
a.airvalve_param_1 AS "Param 1",
a.airvalve_param_2 AS "Param 2"
FROM v_edit_man_valve
LEFT JOIN (
SELECT * FROM crosstab('SELECT feature_id, parameter_id, value_param FROM SCHEMA_NAME.man_addfields_value JOIN SCHEMA_NAME.man_addfields_parameter 
on man_addfields_parameter.id=parameter_id where featurecat_id=''AIR-VALVE'' ORDER BY 1,2')
AS rpt ("feature_id" varchar, "airvalve_param_1" text, "airvalve_param_2" text)
)a ON node_id=feature_id
WHERE nodetype_id='AIR-VALVE';



CREATE OR REPLACE VIEW v_custom_prbreakvalve AS
SELECT 
v_edit_man_valve.*,
a.prbkvalve_param_1 AS "Param 1",
a.prbkvalve_param_2 AS "Param 2"
FROM v_edit_man_valve
LEFT JOIN (
SELECT * FROM crosstab('SELECT feature_id, parameter_id, value_param FROM SCHEMA_NAME.man_addfields_value JOIN SCHEMA_NAME.man_addfields_parameter 
on man_addfields_parameter.id=parameter_id where featurecat_id=''PR.BREAK.VALVE'' ORDER BY 1,2')
AS rpt ("feature_id" varchar, "prbkvalve_param_1" text, "prbkvalve_param_2" text)
)a ON node_id=feature_id
WHERE nodetype_id='PR.BREAK.VALVE';




--FROM SYSTEM FEATURE PIPE
----------------------

CREATE OR REPLACE VIEW v_custom_pipe AS
SELECT 
v_edit_man_pipe.*
FROM v_edit_man_pipe
WHERE cat_arctype_id='PIPE';



--FROM SYSTEM FEATURE VARC
----------------------
CREATE OR REPLACE VIEW v_custom_varc AS
SELECT 
v_edit_man_varc.*
FROM v_edit_man_varc
WHERE cat_arctype_id='VARC';



--FROM SYSTEM FEATURE FOUNTAIN
----------------------

CREATE OR REPLACE VIEW v_custom_fountain AS
SELECT 
v_edit_man_fountain.*
FROM v_edit_man_fountain
WHERE connectype_id='FOUNTAIN';


--FROM SYSTEM FEATURE GREENTAP
----------------------

CREATE OR REPLACE VIEW v_custom_greentap AS
SELECT 
v_edit_man_greentap.*
FROM v_edit_man_greentap
WHERE connectype_id='GREENTAP';


--FROM SYSTEM FEATURE TAP
----------------------

CREATE OR REPLACE VIEW v_custom_tap AS
SELECT 
v_edit_man_tap.*
FROM v_edit_man_tap
WHERE connectype_id='TAP';


--FROM SYSTEM FEATURE WJOIN
----------------------

CREATE OR REPLACE VIEW v_custom_wjoin AS
SELECT 
v_edit_man_wjoin.*
FROM v_edit_man_wjoin
WHERE connectype_id='WJOIN';

