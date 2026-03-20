/*
This file is part of Giswater
The program is free software: you can redistribute it and/or modify it under the terms of the GNU
General Public License as published by the Free Software Foundation, either version 3 of the License,
or (at your option) any later version.
*/


SET search_path = SCHEMA_NAME, public, pg_catalog;

-- 19/03/2026
CREATE OR REPLACE VIEW ve_inp_dscenario_pattern
AS SELECT p.dscenario_id,
    p.pattern_id,
    p.pattern_type,
    p.observ,
    p.tsparameters,
    p.expl_id,
    p.log,
    p.active
FROM inp_dscenario_pattern p
JOIN cat_dscenario d USING (dscenario_id)
WHERE EXISTS (
	SELECT 1
	FROM selector_inp_dscenario s
	WHERE s.dscenario_id = p.dscenario_id
	AND s.cur_user = CURRENT_USER
);

CREATE OR REPLACE VIEW ve_inp_dscenario_pattern_value
AS SELECT 
	p.dscenario_id,
    p.pattern_id,
    p.observ,
    p.tsparameters,
    p.expl_id,
    pv.factor_1,
    pv.factor_2,
    pv.factor_3,
    pv.factor_4,
    pv.factor_5,
    pv.factor_6,
    pv.factor_7,
    pv.factor_8,
    pv.factor_9,
    pv.factor_10,
    pv.factor_11,
    pv.factor_12,
    pv.factor_13,
    pv.factor_14,
    pv.factor_15,
    pv.factor_16,
    pv.factor_17,
    pv.factor_18,
    pv.factor_19,
    pv.factor_20,
    pv.factor_21,
    pv.factor_22,
    pv.factor_23,
    pv.factor_24
FROM inp_dscenario_pattern p
JOIN inp_dscenario_pattern_value pv USING (pattern_id)
WHERE EXISTS (
	SELECT 1
	FROM selector_inp_dscenario s
	WHERE s.dscenario_id = p.dscenario_id
	AND s.cur_user = CURRENT_USER
) AND EXISTS ( 
	SELECT 1
	FROM selector_expl s
	WHERE s.expl_id = p.expl_id
	AND s.cur_user = CURRENT_USER
);

