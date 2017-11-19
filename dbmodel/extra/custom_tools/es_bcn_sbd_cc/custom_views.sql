set search_path='sanejament';

drop extension tablefunc cascade;
create extension tablefunc;

-- review
drop view v_edit_om_review_arc;
CREATE VIEW v_edit_om_review_arc AS
select
om_visit_review_arc.*,
the_geom
from sanejament.om_visit_review_arc
join arc on arc.arc_id=om_visit_review_arc.arc_id where is_validated IS false;

drop view v_edit_om_review_node;
CREATE VIEW v_edit_om_review_node AS
select
om_visit_review_node.*,
the_geom
from sanejament.om_visit_review_node
join node on node.node_id=om_visit_review_node.node_id where is_validated IS false;



--visita
drop view if exists v_om_visit_arc;
create or replace view v_om_visit_arc as
select
arc.arc_id,
startdate::date as data,
arc.the_geom
FROM arc
JOIN om_visit_x_arc ON om_visit_x_arc.arc_id=arc.arc_id
JOIN om_visit ON om_visit.id=om_visit_x_arc.visit_id
JOIN selector_date a ON from_date < startdate
JOIN selector_date b ON b.to_date > enddate
WHERE b.context = 'om_visit' AND b.cur_user=current_user AND is_last IS TRUE;



drop view if exists v_om_visit_node;
create or replace view v_om_visit_node as
select
node.node_id,
startdate::date as data,
node.the_geom
FROM node
JOIN om_visit_x_node ON om_visit_x_node.node_id=node.node_id
JOIN om_visit ON om_visit.id=om_visit_x_node.visit_id
JOIN selector_date a ON from_date < startdate
JOIN selector_date b ON b.to_date > enddate
WHERE b.context = 'om_visit' AND b.cur_user=current_user AND is_last IS TRUE;


--residus
drop view if exists v_om_visit_sed_arc;
create or replace view v_om_visit_sed_arc as
select
arc.arc_id,
startdate::date as data,
value as nivell_sediments,
arc.the_geom
FROM arc
JOIN om_visit_x_arc ON om_visit_x_arc.arc_id=arc.arc_id
JOIN om_visit ON om_visit.id=om_visit_x_arc.visit_id
JOIN selector_date a ON from_date < startdate
JOIN selector_date b ON b.to_date > enddate
JOIN om_visit_event ON om_visit.id=om_visit_event.visit_id
WHERE b.context = 'om_visit' AND b.cur_user=current_user AND is_last IS TRUE
AND parameter_id ='NivellResidus' 
AND value::integer > 0;


drop view if exists v_om_visit_sed_node;
create or replace view v_om_visit_sed_node as
select
node.node_id,
startdate::date as data,
value as nivell_sediments,
node.the_geom
FROM node
JOIN om_visit_x_node ON om_visit_x_node.node_id=node.node_id
JOIN om_visit ON om_visit.id=om_visit_x_node.visit_id
JOIN selector_date a ON from_date < startdate
JOIN selector_date b ON b.to_date > enddate
JOIN om_visit_event ON om_visit.id=om_visit_event.visit_id
WHERE b.context = 'om_visit' AND b.cur_user=current_user AND is_last IS TRUE
AND parameter_id ='NivellResidus' 
AND value::integer > 0;


-- estat estructural
drop view if exists v_om_visit_estruct_arc;
create or replace view v_om_visit_estruct_arc as
SELECT
arc.arc_id,
--startdate::date as data,
estat_general,
estat_parets,
estat_solera,
estat_tester,
estat_volta,
arc.the_geom
FROM sanejament.arc
JOIN sanejament.om_visit_x_arc ON om_visit_x_arc.arc_id=arc.arc_id
JOIN sanejament.om_visit ON om_visit.id=om_visit_x_arc.visit_id
JOIN (
SELECT * FROM crosstab (
'SELECT arc_id, parameter_id, value
FROM sanejament.om_visit_x_arc
JOIN sanejament.om_visit ON om_visit.id=om_visit_x_arc.visit_id
JOIN sanejament.om_visit_event ON om_visit.id=om_visit_event.visit_id
JOIN sanejament.selector_date a ON from_date < startdate
JOIN sanejament.selector_date b ON b.to_date > enddate
WHERE b.context = ''om_visit'' AND b.cur_user=current_user AND is_last IS TRUE
AND (parameter_id =''EstatGeneral'' OR parameter_id =''EstatParets'' OR parameter_id =''EstatSolera'' OR parameter_id =''EstatTester'' OR parameter_id =''EstatVolta'')
AND (value !=''Bo'' AND value !=''Desconegut'')'
,
'SELECT id FROM sanejament.om_visit_parameter
WHERE (id =''EstatGeneral'' OR id =''EstatParets'' OR id =''EstatSolera'' OR id =''EstatTester'' OR id =''EstatVolta'')
ORDER by 1')

AS rpt ("arc_id" varchar(16), "estat_general" text, "estat_parets" text, "estat_solera" text, "estat_tester" text, "estat_volta" text)) a ON a.arc_id=arc.arc_id
WHERE is_last=TRUE;



drop view if exists v_om_visit_estruct_node;
create or replace view v_om_visit_estruct_node as
SELECT
node.node_id,
startdate::date as data,
estat_general,
estat_parets,
estat_solera,
node.the_geom
FROM node
JOIN sanejament.om_visit_x_node ON om_visit_x_node.node_id=node.node_id
JOIN sanejament.om_visit ON om_visit.id=om_visit_x_node.visit_id
JOIN (
SELECT * FROM crosstab (
'SELECT node_id, parameter_id, value
FROM sanejament.om_visit_x_node
JOIN sanejament.om_visit ON om_visit.id=om_visit_x_node.visit_id
JOIN sanejament.om_visit_event ON om_visit.id=om_visit_event.visit_id
JOIN sanejament.selector_date a ON from_date < startdate
JOIN sanejament.selector_date b ON b.to_date > enddate
WHERE b.context = ''om_visit'' AND b.cur_user=current_user AND is_last IS TRUE
AND (parameter_id =''EstatGeneral'' OR parameter_id =''EstatParets'' OR parameter_id =''EstatSolera'')
AND (value !=''Bo'' AND value !=''Desconegut'')'
,
'SELECT id FROM sanejament.om_visit_parameter
WHERE (id =''EstatGeneral'' OR id =''EstatParets'' OR id =''EstatSolera'')
ORDER by 1')

AS rpt ("node_id" varchar(16), "estat_general" text, "estat_parets" text, "estat_solera" text)) a ON a.node_id=node.node_id
WHERE is_last=TRUE
ORDER BY node_id
;




-- Anomalies
drop view if exists v_om_visit_anomalies_arc;
create or replace view v_om_visit_anomalies_arc as
select
arc.arc_id,
startdate::date as data,
value as anomalies,
arc.the_geom
FROM arc
JOIN om_visit_x_arc ON om_visit_x_arc.arc_id=arc.arc_id
JOIN om_visit ON om_visit.id=om_visit_x_arc.visit_id
JOIN selector_date a ON from_date < startdate
JOIN selector_date b ON b.to_date > enddate
JOIN om_visit_event ON om_visit.id=om_visit_event.visit_id
WHERE b.context = 'om_visit' AND b.cur_user=current_user AND is_last IS TRUE
AND (parameter_id ='Observacions' AND value IS NOT NULL );


drop view if exists v_om_visit_anomalies_node;
create or replace view v_om_visit_anomalies_node as
select
node.node_id,
startdate::date as data,
value as anomalies,
node.the_geom
FROM node
JOIN om_visit_x_node ON om_visit_x_node.node_id=node.node_id
JOIN om_visit ON om_visit.id=om_visit_x_node.visit_id
JOIN selector_date a ON from_date < startdate
JOIN selector_date b ON b.to_date > enddate
JOIN om_visit_event ON om_visit.id=om_visit_event.visit_id
WHERE b.context = 'om_visit' AND b.cur_user=current_user AND is_last IS TRUE
AND (parameter_id ='Observacions' AND value IS NOT NULL );


drop view if exists v_om_visit_reparar_tapa_node;
create or replace view v_om_visit_reparar_tapa_node as
select
node.node_id,
startdate::date as data,
value as estat_tapa,
node.the_geom
FROM node
JOIN om_visit_x_node ON om_visit_x_node.node_id=node.node_id
JOIN om_visit ON om_visit.id=om_visit_x_node.visit_id
JOIN selector_date a ON from_date < startdate
JOIN selector_date b ON b.to_date > enddate
JOIN om_visit_event ON om_visit.id=om_visit_event.visit_id
WHERE b.context = 'om_visit' AND b.cur_user=current_user AND is_last IS TRUE
AND (parameter_id ='EstatTapa')
AND (value !='Bo' OR value !='Desconegut');


drop view if exists v_om_visit_reposar_pate_node;
create or replace view v_om_visit_reposar_pate_node as
select
node.node_id,
startdate::date as data,
value as num_pates,
node.the_geom
FROM node
JOIN om_visit_x_node ON om_visit_x_node.node_id=node.node_id
JOIN om_visit ON om_visit.id=om_visit_x_node.visit_id
JOIN selector_date a ON from_date < startdate
JOIN selector_date b ON b.to_date > enddate
JOIN om_visit_event ON om_visit.id=om_visit_event.visit_id
WHERE b.context = 'om_visit' AND b.cur_user=current_user AND is_last IS TRUE
AND (parameter_id ='PatesReposar')
AND value::integer >0;


