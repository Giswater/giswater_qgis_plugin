/*
This file is part of Giswater 3
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association
*/



SET search_path = "SCHEMA_NAME", public, pg_catalog;

CREATE EXTENSION IF NOT EXISTS tablefunc;


--FROM SYSTEM FEATURE CHAMBER
----------------------

CREATE OR REPLACE VIEW v_custom_chamber AS
SELECT 
v_edit_man_chamber.*,
a.chamber_param_1 AS "Param 1",
a.chamber_param_2 AS "Param 2"
FROM v_edit_man_chamber
LEFT JOIN (
SELECT * FROM crosstab('SELECT feature_id, parameter_id, value_param FROM SCHEMA_NAME.man_addfields_value JOIN SCHEMA_NAME.man_addfields_parameter 
on man_addfields_parameter.id=parameter_id where featurecat_id=''CHAMBER'' ORDER BY 1,2')
AS rpt ("feature_id" varchar, "chamber_param_1" text, "chamber_param_2" text)
)a ON node_id=feature_id
WHERE node_type='CHAMBER';



CREATE OR REPLACE VIEW v_custom_weir AS
SELECT 
v_edit_man_chamber.*,
a.weir_param_1 AS "Param 1",
a.weir_param_2 AS "Param 2"
FROM v_edit_man_chamber
LEFT JOIN (
SELECT * FROM crosstab('SELECT feature_id, parameter_id, value_param FROM SCHEMA_NAME.man_addfields_value JOIN SCHEMA_NAME.man_addfields_parameter 
on man_addfields_parameter.id=parameter_id where featurecat_id=''WEIR'' ORDER BY 1,2')
AS rpt ("feature_id" varchar, "weir_param_1" text, "weir_param_2" text)
)a ON node_id=feature_id
WHERE node_type='WEIR';



CREATE OR REPLACE VIEW v_custom_pumpstation AS
SELECT 
v_edit_man_chamber.*,
a.pumpstation_param_1 AS "Param 1",
a.pumpstation_param_2 AS "Param 2"
FROM v_edit_man_chamber
LEFT JOIN (
SELECT * FROM crosstab('SELECT feature_id, parameter_id, value_param FROM SCHEMA_NAME.man_addfields_value JOIN SCHEMA_NAME.man_addfields_parameter 
on man_addfields_parameter.id=parameter_id where featurecat_id=''PUMP-STATION'' ORDER BY 1,2')
AS rpt ("feature_id" varchar, "pumpstation_param_1" text, "pumpstation_param_2" text)
)a ON node_id=feature_id
WHERE node_type='PUMP-STATION';



--FROM SYSTEM FEATURE JUNCTION
----------------------

CREATE OR REPLACE VIEW v_custom_highpoint AS
SELECT 
v_edit_man_junction.*
FROM v_edit_man_junction
WHERE node_type='HIGHPOINT';


CREATE OR REPLACE VIEW v_custom_change AS
SELECT 
v_edit_man_junction.*
FROM v_edit_man_junction
WHERE node_type='CHANGE';


CREATE OR REPLACE VIEW v_custom_register AS
SELECT 
v_edit_man_junction.*,
a.register_param_1 AS "Param 1",
a.register_param_2 AS "Param 2"
FROM v_edit_man_junction
LEFT JOIN (
SELECT * FROM crosstab('SELECT feature_id, parameter_id, value_param FROM SCHEMA_NAME.man_addfields_value JOIN SCHEMA_NAME.man_addfields_parameter 
on man_addfields_parameter.id=parameter_id where featurecat_id=''REGISTER'' ORDER BY 1,2')
AS rpt ("feature_id" varchar, "register_param_1" text, "register_param_2" text)
)a ON node_id=feature_id
WHERE node_type='REGISTER';



CREATE OR REPLACE VIEW v_custom_vnode AS
SELECT 
v_edit_man_junction.*
FROM v_edit_man_junction
WHERE node_type='VNODE';





--FROM SYSTEM FEATURE MANHOLE
----------------------

CREATE OR REPLACE VIEW v_custom_circmanhole AS
SELECT 
v_edit_man_manhole.*,
a.cirmanhole_param_1 AS "Param 1",
a.cirmanhole_param_2 AS "Param 2"
FROM v_edit_man_manhole
LEFT JOIN (
SELECT * FROM crosstab('SELECT feature_id, parameter_id, value_param FROM SCHEMA_NAME.man_addfields_value JOIN SCHEMA_NAME.man_addfields_parameter 
on man_addfields_parameter.id=parameter_id where featurecat_id=''CIRC-MANHOLE'' ORDER BY 1,2')
AS rpt ("feature_id" varchar, "cirmanhole_param_1" text, "cirmanhole_param_2" text)
)a ON node_id=feature_id
WHERE node_type='CIRC-MANHOLE';


CREATE OR REPLACE VIEW v_custom_rectmanhole AS
SELECT 
v_edit_man_manhole.*,
a.recmanhole_param_1 AS "Param 1",
a.recmanhole_param_2 AS "Param 2"
FROM v_edit_man_manhole
LEFT JOIN (
SELECT * FROM crosstab('SELECT feature_id, parameter_id, value_param FROM SCHEMA_NAME.man_addfields_value JOIN SCHEMA_NAME.man_addfields_parameter 
on man_addfields_parameter.id=parameter_id where featurecat_id=''RECT-MANHOLE'' ORDER BY 1,2')
AS rpt ("feature_id" varchar, "recmanhole_param_1" text, "recmanhole_param_2" text)
)a ON node_id=feature_id
WHERE node_type='RECT-MANHOLE';



--FROM SYSTEM FEATURE STORAGE
----------------------

CREATE OR REPLACE VIEW v_custom_sewstorage AS
SELECT v_edit_man_storage.*,
a.sewstorage_param_1 AS "Param 1",
a.sewstorage_param_2 AS "Param 2"
FROM v_edit_man_storage
LEFT JOIN (
SELECT * FROM crosstab('SELECT feature_id, parameter_id, value_param FROM SCHEMA_NAME.man_addfields_value JOIN SCHEMA_NAME.man_addfields_parameter 
on man_addfields_parameter.id=parameter_id where featurecat_id=''SEWER-STORAGE'' ORDER BY 1,2')
AS rpt ("feature_id" varchar, "sewstorage_param_1" text, "sewstorage_param_2" text)
)a ON node_id=feature_id
WHERE node_type='SEWER-STORAGE';


CREATE OR REPLACE VIEW v_custom_owestorage AS
SELECT 
v_edit_man_storage.*,
a.owestorage_param_1 AS "Param 1",
a.owestorage_param_2 AS "Param 2"
FROM v_edit_man_storage
LEFT JOIN (
SELECT * FROM crosstab('SELECT feature_id, parameter_id, value_param FROM SCHEMA_NAME.man_addfields_value JOIN SCHEMA_NAME.man_addfields_parameter 
on man_addfields_parameter.id=parameter_id where featurecat_id=''OWERFLOW-STORAGE'' ORDER BY 1,2')
AS rpt ("feature_id" varchar, "owestorage_param_1" text, "owestorage_param_2" text)
)a ON node_id=feature_id
WHERE node_type='OWERFLOW-STORAGE';




--FROM SYSTEM FEATURE NETINIT
----------------------

CREATE OR REPLACE VIEW v_custom_sandbox AS
SELECT 
v_edit_man_netinit.*
FROM v_edit_man_netinit
WHERE node_type='SANDBOX';



--FROM SYSTEM FEATURE NEGULLY
----------------------

CREATE OR REPLACE VIEW v_custom_netgully AS
SELECT 
v_edit_man_netgully.*
FROM v_edit_man_netgully
WHERE node_type='NETGULLY';




--FROM SYSTEM FEATURE OUTFALL
----------------------

CREATE OR REPLACE VIEW v_custom_outfall AS
SELECT 
v_edit_man_outfall.*
FROM v_edit_man_outfall
WHERE node_type='OUTFALL';





--FROM SYSTEM FEATURE VALVE
----------------------
CREATE OR REPLACE VIEW v_custom_valve AS
SELECT 
v_edit_man_valve.*
FROM v_edit_man_valve
WHERE node_type='VALVE';




--FROM SYSTEM FEATURE WJUMP
----------------------

CREATE OR REPLACE VIEW v_custom_jump AS
SELECT 
v_edit_man_wjump.*
FROM v_edit_man_wjump
WHERE node_type='JUMP';






--FROM SYSTEM FEATURE CONDUIT
----------------------

CREATE OR REPLACE VIEW v_custom_conduit AS
SELECT 
v_edit_man_conduit.*
FROM v_edit_man_conduit
WHERE arc_type='CONDUIT';



CREATE OR REPLACE VIEW v_custom_pumppipe AS
SELECT 
v_edit_man_conduit.*,
a.pumpipe_param_1 AS "Param 1",
a.pumpipe_param_2 AS "Param 2"
FROM v_edit_man_conduit
LEFT JOIN (
SELECT * FROM crosstab('SELECT feature_id, parameter_id, value_param FROM SCHEMA_NAME.man_addfields_value JOIN SCHEMA_NAME.man_addfields_parameter 
on man_addfields_parameter.id=parameter_id where featurecat_id=''PUMP-PIPE'' ORDER BY 1,2')
AS rpt ("feature_id" varchar, "pumpipe_param_1" text, "pumpipe_param_2" text)
)a ON arc_id=feature_id
WHERE arc_type='PUMP-PIPE';




--FROM SYSTEM FEATURE SIPHON
----------------------

CREATE OR REPLACE VIEW v_custom_siphon AS
SELECT 
v_edit_man_siphon.*
FROM v_edit_man_siphon
WHERE arc_type='SIPHON';





--FROM SYSTEM FEATURE WACCEL
----------------------

CREATE OR REPLACE VIEW v_custom_waccel AS
SELECT 
v_edit_man_waccel.*
FROM v_edit_man_waccel
WHERE arc_type='WACCEL';



--FROM SYSTEM FEATURE VARC
----------------------

CREATE OR REPLACE VIEW v_custom_varc AS
SELECT 
v_edit_man_varc.*
FROM v_edit_man_varc
WHERE arc_type='VARC';






--FROM SYSTEM FEATURE CONNEC
----------------------

CREATE OR REPLACE VIEW v_custom_connec AS
SELECT 
v_edit_man_connec.*
FROM v_edit_man_connec
WHERE connec_type='CONNEC';




--FROM SYSTEM FEATURE GULLY
----------------------

CREATE OR REPLACE VIEW v_custom_grate AS
SELECT 
v_edit_man_gully.*,
a.grate_param_1 AS "Param 1",
a.grate_param_2 AS "Param 2"
FROM v_edit_man_gully
LEFT JOIN (
SELECT * FROM crosstab('SELECT feature_id, parameter_id, value_param FROM SCHEMA_NAME.man_addfields_value JOIN SCHEMA_NAME.man_addfields_parameter 
on man_addfields_parameter.id=parameter_id where featurecat_id=''PGULLY'' ORDER BY 1,2')
AS rpt ("feature_id" varchar, "grate_param_1" text, "grate_param_2" text)
)a ON gully_id=a.feature_id
WHERE gully_type='PGULLY';


CREATE OR REPLACE VIEW v_custom_gully AS
SELECT 
v_edit_man_gully.*
FROM v_edit_man_gully
WHERE gully_type='GULLY';

