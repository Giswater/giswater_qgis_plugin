
ALTER TABLE ws_sample.inp_pump ADD COLUMN energyparam varchar (30);
ALTER TABLE ws_sample.inp_pump ADD COLUMN energyvalue varchar (30);

-- create fk energyparam to inp_typevalue

ALTER TABLE ws_sample.inp_pump_additional ADD COLUMN energyparam varchar (30);
ALTER TABLE ws_sample.inp_pump_additional ADD COLUMN energyvalue varchar (30);

-- create fk energyparam to inp_typevalue


ALTER TABLE ws_sample.inp_pipe ADD COLUMN reactiontype varchar (30);
ALTER TABLE ws_sample.inp_pipe ADD COLUMN reactionparam varchar (30);
ALTER TABLE ws_sample.inp_pipe ADD COLUMN reactionvalue varchar (30);

-- create fk reactiontype to inp_typevalue
-- create fk reactionparam to inp_typevalue


CREATE TABLE ws_sample.inp_reactions
( id serial PRIMARY KEY,
  descript text);

CREATE TABLE ws_sample.inp_energy 
(id serial PRIMARY KEY,
  descript text);

DROP VIEW ws_sample.vi_energy;
CREATE OR REPLACE VIEW ws_sample.vi_energy AS 
 SELECT concat ('PUMP ',arc_id) as pump_id,
	inp_typevalue.idval,
	inp_pump.energyvalue
	FROM ws_sample.inp_selector_result, ws_sample.inp_pump
	JOIN ws_sample.rpt_inp_arc ON concat(inp_pump.node_id,'_n2a') = rpt_inp_arc.arc_id::text
	LEFT JOIN ws_sample.inp_typevalue ON inp_pump.energyparam::text = inp_typevalue.id::text AND inp_typevalue.typevalue::text = 'inp_value_param_energy'::text
	WHERE rpt_inp_arc.result_id::text = inp_selector_result.result_id::text AND inp_selector_result.cur_user = "current_user"()::text
UNION
	SELECT concat ('PUMP ',arc_id) as pump_id,
	inp_pump.energyparam,
	inp_pump.energyvalue
	FROM ws_sample.inp_selector_result, ws_sample.inp_pump
	JOIN ws_sample.rpt_inp_arc ON concat(inp_pump.node_id,'_n2a') = rpt_inp_arc.arc_id::text
	WHERE rpt_inp_arc.result_id::text = inp_selector_result.result_id::text AND inp_selector_result.cur_user = "current_user"()::text
UNION
 SELECT descript, null as value,  null as value2  FROM ws_sample.inp_energy;


CREATE TRIGGER gw_trg_vi_energy
  INSTEAD OF INSERT OR UPDATE OR DELETE
  ON ws_sample.vi_energy
  FOR EACH ROW
  EXECUTE PROCEDURE ws_sample.gw_trg_vi('vi_energy');


DROP VIEW ws_sample.vi_reactions;
CREATE OR REPLACE VIEW ws_sample.vi_reactions AS 
 SELECT inp_pipe.reactiontype,
	inp_typevalue.idval,
	inp_pipe.reactionvalue
	FROM ws_sample.inp_selector_result, ws_sample.inp_pipe
	JOIN ws_sample.rpt_inp_arc ON inp_pipe.arc_id::text = rpt_inp_arc.arc_id::text
	LEFT JOIN ws_sample.inp_typevalue ON inp_pipe.reactionparam::text = inp_typevalue.id::text AND inp_typevalue.typevalue::text = 'inp_value_reactions_el'::text
	WHERE rpt_inp_arc.result_id::text = inp_selector_result.result_id::text AND inp_selector_result.cur_user = "current_user"()::text
UNION
 SELECT descript, null as value, null as value2
   FROM ws_sample.inp_reactions;


CREATE TRIGGER gw_trg_vi_reactions
  INSTEAD OF INSERT OR UPDATE OR DELETE
  ON ws_sample.vi_reactions
  FOR EACH ROW
  EXECUTE PROCEDURE ws_sample.gw_trg_vi('vi_reactions');


CREATE TABLE ws_sample.inp_rules(  
  id serial PRIMARY KEY,
  sector_id integer NOT NULL,
  descript text NOT NULL);


CREATE TABLE ws_sample.inp_controls(  
  id serial PRIMARY KEY,
  sector_id integer NOT NULL,
  descript text NOT NULL);


DROP view ws_sample.vi_controls;
CREATE OR REPLACE VIEW ws_sample.vi_controls AS 
 SELECT descript
  FROM ws_sample.inp_controls, ws_sample.inp_selector_sector
 WHERE inp_selector_sector.sector_id = inp_controls.sector_id AND inp_selector_sector.cur_user = "current_user"()::text
 ORDER BY inp_controls.id;
  

DROP view ws_sample.vi_rules;
CREATE OR REPLACE VIEW ws_sample.vi_rules AS 
 SELECT descript
  FROM ws_sample.inp_controls, ws_sample.inp_selector_sector
 WHERE inp_selector_sector.sector_id = inp_controls.sector_id AND inp_selector_sector.cur_user = "current_user"()::text
 ORDER BY inp_controls.id;
  
UPDATE ws_sample.audit_cat_table SET isdeprecated = true WHERE id='inp_report';
UPDATE ws_sample.audit_cat_table SET isdeprecated = true WHERE id='inp_times';
UPDATE ws_sample.audit_cat_table SET isdeprecated = true WHERE id='inp_energy_gl';
UPDATE ws_sample.audit_cat_table SET isdeprecated = true WHERE id='inp_energy_el';
UPDATE ws_sample.audit_cat_table SET isdeprecated = true WHERE id='inp_reactions_gl';
UPDATE ws_sample.audit_cat_table SET isdeprecated = true WHERE id='inp_reactions_el';
UPDATE ws_sample.audit_cat_table SET isdeprecated = true WHERE id='inp_controls_x_arc';
UPDATE ws_sample.audit_cat_table SET isdeprecated = true WHERE id='inp_controls_x_node';
UPDATE ws_sample.audit_cat_table SET isdeprecated = true WHERE id='inp_rules_x_arc';
UPDATE ws_sample.audit_cat_table SET isdeprecated = true WHERE id='inp_rules_x_node';

INSERT INTO ws_sample.audit_cat_table VALUES ('inp_energy') ;
INSERT INTO ws_sample.audit_cat_table VALUES ('inp_reactions') ;
INSERT INTO ws_sample.audit_cat_table VALUES ('inp_rules') ;
INSERT INTO ws_sample.audit_cat_table VALUES ('inp_controls') ;
