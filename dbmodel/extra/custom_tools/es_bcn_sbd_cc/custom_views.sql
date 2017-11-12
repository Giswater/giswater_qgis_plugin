set search_path='sanejament';

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
WHERE b.context='om_visit';


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
WHERE b.context='om_visit';


--residus
drop view if exists v_om_sed_arc;
create or replace view v_om_sed_arc as
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
WHERE b.context='om_visit'
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
WHERE b.context='om_visit'
AND parameter_id ='NivellResidus' 
AND value::integer > 0;


-- estat estructural
drop view if exists v_om_estruct_arc;
create or replace view v_om_estruct_arc as
select
arc.arc_id,
startdate::date as data,
value as estat,
arc.the_geom
FROM arc
JOIN om_visit_x_arc ON om_visit_x_arc.arc_id=arc.arc_id
JOIN om_visit ON om_visit.id=om_visit_x_arc.visit_id
JOIN selector_date a ON from_date < startdate
JOIN selector_date b ON b.to_date > enddate
JOIN om_visit_event ON om_visit.id=om_visit_event.visit_id
WHERE b.context='om_visit'
AND (parameter_id ='EstatGeneral' OR parameter_id ='EstatParets' OR parameter_id ='EstatSolera' OR parameter_id ='EstatTester' OR parameter_id ='EstatVolta')
AND (value !='Bo' OR value !='Desconegut');


drop view if exists v_om_visit_estruct_node;
create or replace view v_om_visit_estruct_node as
select
node.node_id,
startdate::date as data,
value as estat,
node.the_geom
FROM node
JOIN om_visit_x_node ON om_visit_x_node.node_id=node.node_id
JOIN om_visit ON om_visit.id=om_visit_x_node.visit_id
JOIN selector_date a ON from_date < startdate
JOIN selector_date b ON b.to_date > enddate
JOIN om_visit_event ON om_visit.id=om_visit_event.visit_id
WHERE b.context='om_visit'
AND (parameter_id ='EstatGeneral' OR parameter_id ='EstatParets' OR parameter_id ='EstatSolera' OR parameter_id ='EstatTester' OR parameter_id ='EstatVolta')
AND (value !='Bo' OR value !='Desconegut');


-- Anomalies
drop view if exists v_om_anomalies_arc;
create or replace view v_om_anomalies_arc as
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
WHERE b.context='om_visit'
AND (parameter_id ='Observacions' IS NOT NULL);


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
WHERE b.context='om_visit'
AND (parameter_id ='Observacions' IS NOT NULL);


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
WHERE b.context='om_visit'
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
WHERE b.context='om_visit'
AND (parameter_id ='PatesReposar')
AND value::integer >0;


