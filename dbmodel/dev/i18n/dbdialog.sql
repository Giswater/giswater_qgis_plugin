/*
This file is part of Giswater 3
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association
*/


-- get priority in terms of translate
select count(*), source, tt_eses from i18n.dbdialog group by source, tt_eses order by 1 desc

select * from i18n.dbdialog

-- translate it

-- result_id
update i18n.dbdialog set lb_eses = 'Id resultado' where source = 'result_id' and lb_caes is null;
update i18n.dbdialog set tt_eses = 'result_id - Identificador del resultado' where source = 'result_id' and tt_eses is null;

update i18n.dbdialog set lb_caes = 'Id resultat' where source = 'result_id' and lb_caes is null;
update i18n.dbdialog set tt_caes = 'result_id - Identificador del resultat' where source = 'result_id' and tt_caes is null;

update i18n.dbdialog set lb_ptpt = 'Id resultado' where source = 'result_id' and lb_ptpt is null;
update i18n.dbdialog set tt_ptpt = 'result_id - Identificador do resultado' where source = 'result_id' and tt_ptpt is null;


-- sector_id
update i18n.dbdialog set lb_eses = 'Id sector' where source = 'sector_id' and lb_caes is null;
update i18n.dbdialog set tt_eses = 'sector_id - Identificador del sector' where source = 'sector_id' and tt_eses is null;

update i18n.dbdialog set lb_caes = 'Id sector' where source = 'sector_id' and lb_caes is null;
update i18n.dbdialog set tt_caes = 'sector_id - Identificador del sector' where source = 'sector_id' and tt_caes is null;

-- node_id
update i18n.dbdialog set lb_eses = 'Id nodo' where source = 'node_id' and lb_caes is null;
update i18n.dbdialog set tt_eses = 'node_id - Identificador del nodo' where source = 'node_id' and tt_eses is null;

update i18n.dbdialog set lb_caes = 'Id node' where source = 'node_id' and lb_caes is null;
update i18n.dbdialog set tt_caes = 'node_id - Identificador del node' where source = 'node_id' and tt_caes is null;

-- descript
update i18n.dbdialog set lb_eses = 'Descrip.' where source = 'descript' and lb_caes is null;
update i18n.dbdialog set tt_eses = 'descript - Descripción' where source = 'descript' and tt_eses is null;

update i18n.dbdialog set lb_caes = 'Descrip.' where source = 'descript' and lb_caes is null;
update i18n.dbdialog set tt_caes = 'descript - Descripció' where source = 'descript' and tt_caes is null;

-- arc_id
update i18n.dbdialog set lb_eses = 'Id arco' where source = 'arc_id' and lb_caes is null;
update i18n.dbdialog set tt_eses = 'arc_id - Identificador del arco' where source = 'arc_id' and tt_eses is null;

update i18n.dbdialog set lb_caes = 'Id arc' where source = 'arc_id' and lb_caes is null;
update i18n.dbdialog set tt_caes = 'arc_id - Identificador de l''arc' where source = 'arc_id' and tt_caes is null;

-- expl_id
update i18n.dbdialog set lb_eses = 'Id expl.' where source = 'expl_id' and lb_caes is null;
update i18n.dbdialog set tt_eses = 'expl_id - Identificador de la explotación' where source = 'expl_id' and tt_eses is null;

update i18n.dbdialog set lb_caes = 'Id expl.' where source = 'arc_id' and lb_caes is null;
update i18n.dbdialog set tt_caes = 'expl_id - Identificador de l''explotació' where source = 'expl_id' and tt_caes is null;

-- state
update i18n.dbdialog set lb_eses = 'Estado' where source = 'state' and lb_caes is null;
update i18n.dbdialog set tt_eses = 'state - Estado' where source = 'state' and tt_eses is null;

update i18n.dbdialog set lb_caes = 'Estat' where source = 'state' and lb_caes is null;
update i18n.dbdialog set tt_caes = 'state - Estat' where source = 'state' and tt_caes is null;

-- link
update i18n.dbdialog set lb_eses = 'Link' where source = 'link' and lb_caes is null;
update i18n.dbdialog set tt_eses = 'link - Link' where source = 'link' and tt_eses is null;

update i18n.dbdialog set lb_caes = 'Link' where source = 'link' and lb_caes is null;
update i18n.dbdialog set tt_caes = 'link - Link' where source = 'link' and tt_caes is null;

-- name
update i18n.dbdialog set lb_eses = 'Nombre' where source = 'name' and lb_caes is null;
update i18n.dbdialog set tt_eses = 'name - Nombre' where source = 'name' and tt_eses is null;

update i18n.dbdialog set lb_caes = 'Nom' where source = 'name' and lb_caes is null;
update i18n.dbdialog set tt_caes = 'name - Nom' where source = 'name' and tt_caes is null;

-- nodecat_id
update i18n.dbdialog set lb_eses = 'Cat. nodo' where source = 'nodecat_id' and lb_caes is null;
update i18n.dbdialog set tt_eses = 'nodecat_id - Identificador del catálogo de nodo' where source = 'nodecat_id' and tt_eses is null;

update i18n.dbdialog set lb_caes = 'Cat. node' where source = 'nodecat_id' and lb_caes is null;
update i18n.dbdialog set tt_caes = 'nodecat_id - Identificador del catàlag de node' where source = 'nodecat_id' and tt_caes is null;

-- macrosector_id
update i18n.dbdialog set lb_eses = 'Id macrosector' where source = 'macrosector_id' and lb_caes is null;
update i18n.dbdialog set tt_eses = 'macrosector_id - Identificador del del macrosector' where source = 'macrosector_id' and tt_eses is null;

update i18n.dbdialog set lb_caes = 'Id macrosector' where source = 'macrosector_id' and lb_caes is null;
update i18n.dbdialog set tt_caes = 'macrosector_id - Identificador del macrosector' where source = 'macrosector_id' and tt_caes is null;

-- text
update i18n.dbdialog set lb_eses = 'Texto' where source = 'text' and lb_caes is null;
update i18n.dbdialog set tt_eses = 'text - Texto' where source = 'text' and tt_eses is null;

update i18n.dbdialog set lb_caes = 'Text' where source = 'text' and lb_caes is null;
update i18n.dbdialog set tt_caes = 'text - Text' where source = 'text' and tt_caes is null;

-- annotation
update i18n.dbdialog set lb_eses = 'Anotación' where source = 'annotation' and lb_caes is null;
update i18n.dbdialog set tt_eses = 'annotation - Anotación' where source = 'annotation' and tt_eses is null;

update i18n.dbdialog set lb_caes = 'Anotació' where source = 'annotation' and lb_caes is null;
update i18n.dbdialog set tt_caes = 'annotation - Anotació' where source = 'annotation' and tt_caes is null;

-- arccat_id
update i18n.dbdialog set lb_eses = 'Cat. arco' where source = 'arccat_id' and lb_caes is null;
update i18n.dbdialog set tt_eses = 'arccat_id - Catálogo de arco' where source = 'arccat_id' and tt_eses is null;

update i18n.dbdialog set lb_caes = 'Cat. arc' where source = 'arccat_id' and lb_caes is null;
update i18n.dbdialog set tt_caes = 'arccat_id - Catàleg arc' where source = 'arccat_id' and tt_caes is null;

-- matcat_id
update i18n.dbdialog set lb_eses = 'Cat. mat.' where source = 'matcat_id' and lb_caes is null;
update i18n.dbdialog set tt_eses = 'matcat_id - Identificador de catálogo de materiales' where source = 'matcat_id' and tt_eses is null;

update i18n.dbdialog set lb_caes = 'Cat. mat.' where source = 'matcat_id' and lb_caes is null;
update i18n.dbdialog set tt_caes = 'matcat_id - Identificador de catálag de materials' where source = 'matcat_id' and tt_caes is null;

-- node_type
update i18n.dbdialog set lb_eses = 'Tipo nodo' where source = 'node_type' and lb_caes is null;
update i18n.dbdialog set tt_eses = 'node_type - Tipo de nodo' where source = 'node_type' and tt_eses is null;

update i18n.dbdialog set lb_caes = 'Tipus node' where source = 'node_type' and lb_caes is null;
update i18n.dbdialog set tt_caes = 'node_type - Tipus de node' where source = 'node_type' and tt_caes is null;

-- enddate
update i18n.dbdialog set lb_eses = 'Data final' where source = 'enddate' and lb_caes is null;
update i18n.dbdialog set tt_eses = 'enddate - Data final' where source = 'enddate' and tt_eses is null;

update i18n.dbdialog set lb_caes = 'Data final' where source = 'enddate' and lb_caes is null;
update i18n.dbdialog set tt_caes = 'enddate - Data final' where source = 'enddate' and tt_caes is null;

-- observ
update i18n.dbdialog set lb_eses = 'Observación' where source = 'observ' and lb_caes is null;
update i18n.dbdialog set tt_eses = 'observ - Observación' where source = 'observ' and tt_eses is null;

update i18n.dbdialog set lb_caes = 'Observació' where source = 'observ' and lb_caes is null;
update i18n.dbdialog set tt_caes = 'observ - Observació' where source = 'observ' and tt_caes is null;

-- elevation
update i18n.dbdialog set lb_eses = 'Elevación' where source = 'elevation' and lb_caes is null;
update i18n.dbdialog set tt_eses = 'elevation - Elevación' where source = 'elevation' and tt_eses is null;

update i18n.dbdialog set lb_caes = 'Elevació' where source = 'elevation' and lb_caes is null;
update i18n.dbdialog set tt_caes = 'elevation - Elevació' where source = 'elevation' and tt_caes is null;

-- undelete
update i18n.dbdialog set lb_eses = 'Bloqueado' where source = 'undelete' and lb_caes is null;
update i18n.dbdialog set tt_eses = 'undelete - Bloqueado' where source = 'undelete' and tt_eses is null;

update i18n.dbdialog set lb_caes = 'Bloquejat' where source = 'undelete' and lb_caes is null;
update i18n.dbdialog set tt_caes = 'undelete - Bloquejat' where source = 'undelete' and tt_caes is null;

-- poll_id
update i18n.dbdialog set lb_eses = 'Id contaminante' where source = 'poll_id' and lb_caes is null;
update i18n.dbdialog set tt_eses = 'poll_id - Identificador de contaminante' where source = 'poll_id' and tt_eses is null;

update i18n.dbdialog set lb_caes = 'Id contaminant' where source = 'poll_id' and lb_caes is null;
update i18n.dbdialog set tt_caes = 'poll_id - Identificador de contaminant' where source = 'poll_id' and tt_caes is null;

-- backbutton
update i18n.dbdialog set lb_eses = 'Atras' where source = 'backbutton' and lb_caes is null;
update i18n.dbdialog set tt_eses = 'backbutton - Botón de atrás' where source = 'backbutton' and tt_eses is null;

update i18n.dbdialog set lb_caes = 'Enrera' where source = 'backbutton' and lb_caes is null;
update i18n.dbdialog set tt_caes = 'backbutton - Botó de darrere' where source = 'backbutton' and tt_caes is null;

-- status
update i18n.dbdialog set lb_eses = 'Estado' where source = 'status' and lb_caes is null;
update i18n.dbdialog set tt_eses = 'status - Estado' where source = 'status' and tt_eses is null;

update i18n.dbdialog set lb_caes = 'Estat' where source = 'status' and lb_caes is null;
update i18n.dbdialog set tt_caes = 'status - Estat' where source = 'status' and tt_caes is null;

-- curve_id
update i18n.dbdialog set lb_eses = 'Id curva' where source = 'curve_id' and lb_caes is null;
update i18n.dbdialog set tt_eses = 'curve_id - Identificador de la curva' where source = 'curve_id' and tt_eses is null;

update i18n.dbdialog set lb_caes = 'Id corva' where source = 'curve_id' and lb_caes is null;
update i18n.dbdialog set tt_caes = 'curve_id - Identificador de la corba' where source = 'curve_id' and tt_caes is null;

-- arc_type
update i18n.dbdialog set lb_eses = 'Tipo arco' where source = 'arc_type' and lb_caes is null;
update i18n.dbdialog set tt_eses = 'arc_type - Tipo de arco' where source = 'arc_type' and tt_eses is null;

update i18n.dbdialog set lb_caes = 'Tipus arc' where source = 'arc_type' and lb_caes is null;
update i18n.dbdialog set tt_caes = 'arc_type - Tipus d''arc' where source = 'arc_type' and tt_caes is null;

-- depth
update i18n.dbdialog set lb_eses = 'Profundidad' where source = 'depth' and lb_caes is null;
update i18n.dbdialog set tt_eses = 'depth - Profundidad del nodo' where source = 'depth' and tt_eses is null;

update i18n.dbdialog set lb_caes = 'Fondària' where source = 'depth' and lb_caes is null;
update i18n.dbdialog set tt_caes = 'depth - Fondària del node' where source = 'depth' and tt_caes is null;

-- dma_id 
update i18n.dbdialog set lb_eses = 'Id dma' where source = 'dma_id' and lb_caes is null;
update i18n.dbdialog set tt_eses = 'dma_id - Identificador de dma' where source = 'dma_id' and tt_eses is null;

update i18n.dbdialog set lb_caes = 'Id dma' where source = 'dma_id' and lb_caes is null;
update i18n.dbdialog set tt_caes = 'dma_id - Identificador de dma' where source = 'dma_id' and tt_caes is null;

-- muni_id 
update i18n.dbdialog set lb_eses = 'Id muni' where source = 'muni_id' and lb_caes is null;
update i18n.dbdialog set tt_eses = 'muni_id - Identificador del municipio' where source = 'muni_id' and tt_eses is null;

update i18n.dbdialog set lb_caes = 'Id muni' where source = 'muni_id' and lb_caes is null;
update i18n.dbdialog set tt_caes = 'muni_id - Identificador del municipi' where source = 'muni_id' and tt_caes is null;

-- macrodma_id 
update i18n.dbdialog set lb_eses = 'Id macrodma' where source = 'macrodma_id' and lb_caes is null;
update i18n.dbdialog set tt_eses = 'macrodma_id - Identificador de macrodma' where source = 'macrodma_id' and tt_eses is null;

update i18n.dbdialog set lb_caes = 'Id macrodma' where source = 'macrodma_id' and lb_caes is null;
update i18n.dbdialog set tt_caes = 'macrodma_id - Identificador de macrodma' where source = 'macrodma_id' and tt_caes is null;

-- pattern_id 
update i18n.dbdialog set lb_eses = 'Id pattern' where source = 'pattern_id' and lb_caes is null;
update i18n.dbdialog set tt_eses = 'pattern_id - Identificador de pattern' where source = 'pattern_id' and tt_eses is null;

update i18n.dbdialog set lb_caes = 'Id pattern' where source = 'pattern_id' and lb_caes is null;
update i18n.dbdialog set tt_caes = 'pattern_id - Identificador de pattern' where source = 'pattern_id' and tt_caes is null;

-- active 
update i18n.dbdialog set lb_eses = 'Activo' where source = 'active' and lb_caes is null;
update i18n.dbdialog set tt_eses = 'active - Activo' where source = 'active' and tt_eses is null;

update i18n.dbdialog set lb_caes = 'Actiu' where source = 'active' and lb_caes is null;
update i18n.dbdialog set tt_caes = 'active - Actiu' where source = 'active' and tt_caes is null;

-- code
update i18n.dbdialog set lb_eses = 'Código' where source = 'code' and lb_caes is null;
update i18n.dbdialog set tt_eses = 'code - Código' where source = 'code' and tt_eses is null;

update i18n.dbdialog set lb_caes = 'Codi' where source = 'code' and lb_caes is null;
update i18n.dbdialog set tt_caes = 'code - Codi' where source = 'code' and tt_caes is null;

-- class_id
update i18n.dbdialog set lb_eses = 'Id clase' where source = 'class_id' and lb_caes is null;
update i18n.dbdialog set tt_eses = 'class_id - Identificador de clase' where source = 'class_id' and tt_eses is null;

update i18n.dbdialog set lb_caes = 'Id classe' where source = 'class_id' and lb_caes is null;
update i18n.dbdialog set tt_caes = 'class_id - Identificador de classe' where source = 'class_id' and tt_caes is null;

-- length
update i18n.dbdialog set lb_eses = 'Longitud' where source = 'length' and lb_caes is null;
update i18n.dbdialog set tt_eses = 'length - Longitud' where source = 'length' and tt_eses is null;

update i18n.dbdialog set lb_caes = 'Longitut' where source = 'length' and lb_caes is null;
update i18n.dbdialog set tt_caes = 'length - Longitud' where source = 'length' and tt_caes is null;

-- visit_id
update i18n.dbdialog set lb_eses = 'Id visita' where source = 'visit_id' and lb_caes is null;
update i18n.dbdialog set tt_eses = 'visit_id - Identificador de visita' where source = 'visit_id' and tt_eses is null;

update i18n.dbdialog set lb_caes = 'Id visita' where source = 'visit_id' and lb_caes is null;
update i18n.dbdialog set tt_caes = 'visit_id - Identificador de visita' where source = 'visit_id' and tt_caes is null;

-- value
update i18n.dbdialog set lb_eses = 'Valor' where source = 'value' and lb_caes is null;
update i18n.dbdialog set tt_eses = 'value - Valor' where source = 'value' and tt_eses is null;

update i18n.dbdialog set lb_caes = 'Valor' where source = 'value' and lb_caes is null;
update i18n.dbdialog set tt_caes = 'value - Valor' where source = 'value' and tt_caes is null;

-- svg
update i18n.dbdialog set lb_eses = 'Svg' where source = 'svg' and lb_caes is null;
update i18n.dbdialog set tt_eses = 'svg - Svg' where source = 'svg' and tt_eses is null;

update i18n.dbdialog set lb_caes = 'Svg' where source = 'svg' and lb_caes is null;
update i18n.dbdialog set tt_caes = 'svg - Svg' where source = 'svg' and tt_caes is null;

-- builtdate
update i18n.dbdialog set lb_eses = 'Fecha cons.' where source = 'builtdate' and lb_caes is null;
update i18n.dbdialog set tt_eses = 'builtdate - Fecha de construcción' where source = 'builtdate' and tt_eses is null;

update i18n.dbdialog set lb_caes = 'Data cons.' where source = 'builtdate' and lb_caes is null;
update i18n.dbdialog set tt_caes = 'builtdate - Data de construcció' where source = 'builtdate' and tt_caes is null;

-- postcode
update i18n.dbdialog set lb_eses = 'Código postal' where source = 'postcode' and lb_caes is null;
update i18n.dbdialog set tt_eses = 'postcode - Código postal' where source = 'postcode' and tt_eses is null;

update i18n.dbdialog set lb_caes = 'Codi postal' where source = 'postcode' and lb_caes is null;
update i18n.dbdialog set tt_caes = 'postcode - Codi postal' where source = 'postcode' and tt_caes is null;

-- acceptbutton
update i18n.dbdialog set lb_eses = 'Aceptar' where source = 'acceptbutton' and lb_caes is null;
update i18n.dbdialog set tt_eses = 'acceptbutton - Botón de aceptado' where source = 'acceptbutton' and tt_eses is null;

update i18n.dbdialog set lb_caes = 'Acceptar' where source = 'acceptbutton' and lb_caes is null;
update i18n.dbdialog set tt_caes = 'acceptbutton - Botó d''acceptat' where source = 'acceptbutton' and tt_caes is null;

-- streetname
update i18n.dbdialog set lb_eses = 'Nom. calle' where source = 'streetname' and lb_caes is null;
update i18n.dbdialog set tt_eses = 'streetname - Nombre de la calle' where source = 'streetname' and tt_eses is null;

update i18n.dbdialog set lb_caes = 'Nom carrer' where source = 'streetname' and lb_caes is null;
update i18n.dbdialog set tt_caes = 'streetname - Nom del carrer' where source = 'streetname' and tt_caes is null;

-- postnumber
update i18n.dbdialog set lb_eses = 'Núm. post.' where source = 'postnumber' and lb_caes is null;
update i18n.dbdialog set tt_eses = 'postnumber - Número postal' where source = 'postnumber' and tt_eses is null;

update i18n.dbdialog set lb_caes = 'Núm. post' where source = 'postnumber' and lb_caes is null;
update i18n.dbdialog set tt_caes = 'postnumber - Número postal' where source = 'postnumber' and tt_caes is null;

-- label
update i18n.dbdialog set lb_eses = 'Etiqueta' where source = 'label' and lb_caes is null;
update i18n.dbdialog set tt_eses = 'label - Etiqueta' where source = 'label' and tt_eses is null;

update i18n.dbdialog set lb_caes = 'Etiqueta' where source = 'label' and lb_caes is null;
update i18n.dbdialog set tt_caes = 'label - Etiqueta' where source = 'label' and tt_caes is null;

-- comment
update i18n.dbdialog set lb_eses = 'Coment.' where source = 'comment' and lb_caes is null;
update i18n.dbdialog set tt_eses = 'comment - Comentario' where source = 'comment' and tt_eses is null;

update i18n.dbdialog set lb_caes = 'Coment.' where source = 'comment' and lb_caes is null;
update i18n.dbdialog set tt_caes = 'comment - Comentari' where source = 'comment' and tt_caes is null;

-- ext_code
update i18n.dbdialog set lb_eses = 'Ext. code' where source = 'ext_code' and lb_caes is null;
update i18n.dbdialog set tt_eses = 'ext_code - Código externo' where source = 'ext_code' and tt_eses is null;

update i18n.dbdialog set lb_caes = 'Ext. code.' where source = 'ext_code' and lb_caes is null;
update i18n.dbdialog set tt_caes = 'ext_code - Codi extern' where source = 'ext_code' and tt_caes is null;


-- time_hour
update i18n.dbdialog set lb_eses = 'Time_hora' where source = 'time_hour' and lb_caes is null;
update i18n.dbdialog set tt_eses = 'time_hour - Horas' where source = 'time_hour' and tt_eses is null;

update i18n.dbdialog set lb_caes = 'Time_hora' where source = 'time_hour' and lb_caes is null;
update i18n.dbdialog set tt_caes = 'time_hour - Hores' where source = 'time_hour' and tt_caes is null;

-- startdate
update i18n.dbdialog set lb_eses = 'Fecha in.' where source = 'startdate' and lb_caes is null;
update i18n.dbdialog set tt_eses = 'startdate - Fecha de inicio' where source = 'startdate' and tt_eses is null;

update i18n.dbdialog set lb_caes = 'Data in.' where source = 'startdate' and lb_caes is null;
update i18n.dbdialog set tt_caes = 'startdate - Data d''inici' where source = 'startdate' and tt_caes is null;

-- geom1
update i18n.dbdialog set lb_eses = 'Time_hora' where source = 'geom1' and lb_caes is null;
update i18n.dbdialog set tt_eses = 'geom1 - Horas' where source = 'geom1' and tt_eses is null;

update i18n.dbdialog set lb_caes = 'Time_hora' where source = 'geom1' and lb_caes is null;
update i18n.dbdialog set tt_caes = 'geom1 - Hores' where source = 'geom1' and tt_caes is null;

-- time_days
update i18n.dbdialog set lb_eses = 'Time_dia' where source = 'time_days' and lb_caes is null;
update i18n.dbdialog set tt_eses = 'time_days - Días' where source = 'time_days' and tt_eses is null;

update i18n.dbdialog set lb_caes = 'Time_dia' where source = 'time_days' and lb_caes is null;
update i18n.dbdialog set tt_caes = 'time_days - Dies' where source = 'time_days' and tt_caes is null;

-- shape
update i18n.dbdialog set lb_eses = 'Forma' where source = 'shape' and lb_caes is null;
update i18n.dbdialog set tt_eses = 'shape - Forma' where source = 'shape' and tt_eses is null;

update i18n.dbdialog set lb_caes = 'Forma' where source = 'shape' and lb_caes is null;
update i18n.dbdialog set tt_caes = 'shape - Forma' where source = 'shape' and tt_caes is null;

-- cont_error
update i18n.dbdialog set lb_eses = 'Cont_error' where source = 'cont_error' and lb_caes is null;
update i18n.dbdialog set tt_eses = 'cont_error - Error de continuidad' where source = 'cont_error' and tt_eses is null;

update i18n.dbdialog set lb_caes = 'Cont_error' where source = 'cont_error' and lb_caes is null;
update i18n.dbdialog set tt_caes = 'cont_error - Error de continuitat' where source = 'cont_error' and tt_caes is null;

-- max_flow
update i18n.dbdialog set lb_eses = 'Max. caudal' where source = 'max_flow' and lb_caes is null;
update i18n.dbdialog set tt_eses = 'max_flow - Caudal máximo' where source = 'max_flow' and tt_eses is null;

update i18n.dbdialog set lb_caes = 'Max. cabal' where source = 'max_flow' and lb_caes is null;
update i18n.dbdialog set tt_caes = 'max_flow - Cabal màxim' where source = 'max_flow' and tt_caes is null;

-- feature_id
update i18n.dbdialog set lb_eses = 'Feature' where source = 'feature_id' and lb_caes is null;
update i18n.dbdialog set tt_eses = 'feature_id - Identificador de Feature' where source = 'feature_id' and tt_eses is null;

update i18n.dbdialog set lb_caes = 'Feature' where source = 'feature_id' and lb_caes is null;
update i18n.dbdialog set tt_caes = 'feature_id - Identificador de Feature' where source = 'feature_id' and tt_caes is null;

-- time
update i18n.dbdialog set lb_eses = 'Tiempo' where source = 'time' and lb_caes is null;
update i18n.dbdialog set tt_eses = 'time - Tiempo' where source = 'time' and tt_eses is null;

update i18n.dbdialog set lb_caes = 'Temps' where source = 'time' and lb_caes is null;
update i18n.dbdialog set tt_caes = 'time - Temps' where source = 'time' and tt_caes is null;

-- workcat_id
update i18n.dbdialog set lb_eses = 'Cat. trabajo' where source = 'workcat_id' and lb_caes is null;
update i18n.dbdialog set tt_eses = 'workcat_id - Identificador del catálogo de trabajo' where source = 'workcat_id' and tt_eses is null;

update i18n.dbdialog set lb_caes = 'Cat. treball' where source = 'workcat_id' and lb_caes is null;
update i18n.dbdialog set tt_caes = 'workcat_id - Identificador del catàleg de treball' where source = 'workcat_id' and tt_caes is null;

-- subc_id
update i18n.dbdialog set lb_eses = 'Subcon.' where source = 'subc_id' and lb_caes is null;
update i18n.dbdialog set tt_eses = 'subc_id - Identificador de subcuenca de drenaje' where source = 'subc_id' and tt_eses is null;

update i18n.dbdialog set lb_caes = 'Subcon.' where source = 'subc_id' and lb_caes is null;
update i18n.dbdialog set tt_caes = 'subc_id - Identificador de subconque de drenatge' where source = 'subc_id' and tt_caes is null;

-- workcat_id_end
update i18n.dbdialog set lb_eses = 'Cat. trabajo' where source = 'workcat_id_end' and lb_caes is null;
update i18n.dbdialog set tt_eses = 'workcat_id_end - Identificador final del catálogo de trabajo' where source = 'workcat_id_end' and tt_eses is null;

update i18n.dbdialog set lb_caes = 'Cat. treball' where source = 'workcat_id_end' and lb_caes is null;
update i18n.dbdialog set tt_caes = 'workcat_id_end - Identificador final del catàleg de treball' where source = 'workcat_id_end' and tt_caes is null;

-- node_1
update i18n.dbdialog set lb_eses = 'Nodo 1' where source = 'node_1' and lb_caes is null;
update i18n.dbdialog set tt_eses = 'node_1 - Nodo 1' where source = 'node_1' and tt_eses is null;

update i18n.dbdialog set lb_caes = 'Node 1' where source = 'node_1' and lb_caes is null;
update i18n.dbdialog set tt_caes = 'node_1 - Node 1' where source = 'node_1' and tt_caes is null;

-- verified
update i18n.dbdialog set lb_eses = 'Verificado' where source = 'verified' and lb_caes is null;
update i18n.dbdialog set tt_eses = 'verified - Verificado' where source = 'verified' and tt_eses is null;

update i18n.dbdialog set lb_caes = 'Verificat' where source = 'verified' and lb_caes is null;
update i18n.dbdialog set tt_caes = 'verified - Verificat' where source = 'verified' and tt_caes is null;

-- to_arc
update i18n.dbdialog set lb_eses = 'to_arc' where source = 'to_arc' and lb_caes is null;
update i18n.dbdialog set tt_eses = 'to_arc - Arco destino' where source = 'to_arc' and tt_eses is null;

update i18n.dbdialog set lb_caes = 'to_arc' where source = 'to_arc' and lb_caes is null;
update i18n.dbdialog set tt_caes = 'to_arc - Arc destí' where source = 'to_arc' and tt_caes is null;

-- gis_length
update i18n.dbdialog set lb_eses = 'Long. gis' where source = 'gis_length' and lb_caes is null;
update i18n.dbdialog set tt_eses = 'gis_length - Longitud del gis' where source = 'gis_length' and tt_eses is null;

update i18n.dbdialog set lb_caes = 'Long. gis' where source = 'gis_length' and lb_caes is null;
update i18n.dbdialog set tt_caes = 'gis_length - Longitud del gis' where source = 'gis_length' and tt_caes is null;

-- rotation
update i18n.dbdialog set lb_eses = 'Rotación' where source = 'rotation' and lb_caes is null;
update i18n.dbdialog set tt_eses = 'rotation - Rotación' where source = 'rotation' and tt_eses is null;

update i18n.dbdialog set lb_caes = 'Rotació' where source = 'rotation' and lb_caes is null;
update i18n.dbdialog set tt_caes = 'rotation - Rotació' where source = 'rotation' and tt_caes is null;

-- node_2
update i18n.dbdialog set lb_eses = 'Node 2' where source = 'node_2' and lb_caes is null;
update i18n.dbdialog set tt_eses = 'node_2 - Node 2' where source = 'node_2' and tt_eses is null;

update i18n.dbdialog set lb_caes = 'Node 2' where source = 'node_2' and lb_caes is null;
update i18n.dbdialog set tt_caes = 'node_2 - Node 2' where source = 'node_2' and tt_caes is null;

-- inventory
update i18n.dbdialog set lb_eses = 'Inventario' where source = 'inventory' and lb_caes is null;
update i18n.dbdialog set tt_eses = 'inventory - Inventario' where source = 'inventory' and tt_eses is null;

update i18n.dbdialog set lb_caes = 'Inventari' where source = 'inventory' and lb_caes is null;
update i18n.dbdialog set tt_caes = 'inventory - Inventari' where source = 'inventory' and tt_caes is null;

-- model
update i18n.dbdialog set lb_eses = 'Modelo' where source = 'model' and lb_caes is null;
update i18n.dbdialog set tt_eses = 'model - Modelo' where source = 'model' and tt_eses is null;

update i18n.dbdialog set lb_caes = 'Model' where source = 'model' and lb_caes is null;
update i18n.dbdialog set tt_caes = 'model - Model' where source = 'model' and tt_caes is null;

-- y2
update i18n.dbdialog set lb_eses = 'Y2' where source = 'y2' and lb_caes is null;
update i18n.dbdialog set tt_eses = 'y2 - Y2' where source = 'y2' and tt_eses is null;

update i18n.dbdialog set lb_caes = 'Y2' where source = 'y2' and lb_caes is null;
update i18n.dbdialog set tt_caes = 'y2 - Y2' where source = 'y2' and tt_caes is null;

-- buildercat_id
update i18n.dbdialog set lb_eses = 'Cat. const' where source = 'buildercat_id' and lb_caes is null;
update i18n.dbdialog set tt_eses = 'buildercat_id - Identificador del catálogo de construcción' where source = 'buildercat_id' and tt_eses is null;

update i18n.dbdialog set lb_caes = 'Cat. const' where source = 'buildercat_id' and lb_caes is null;
update i18n.dbdialog set tt_caes = 'buildercat_id - Identificador del catàleg de construcció' where source = 'buildercat_id' and tt_caes is null;

-- state_type
update i18n.dbdialog set lb_eses = 'Tipo estado' where source = 'state_type' and lb_caes is null;
update i18n.dbdialog set tt_eses = 'state_type - Tipo de estado' where source = 'state_type' and tt_eses is null;

update i18n.dbdialog set lb_caes = 'Tipus estat' where source = 'model' and lb_caes is null;
update i18n.dbdialog set tt_caes = 'state_type - Tipus de estat' where source = 'state_type' and tt_caes is null;

-- publish
update i18n.dbdialog set lb_eses = 'Publicable' where source = 'publish' and lb_caes is null;
update i18n.dbdialog set tt_eses = 'publish - Publicable' where source = 'publish' and tt_eses is null;

update i18n.dbdialog set lb_caes = 'Publicable' where source = 'publish' and lb_caes is null;
update i18n.dbdialog set tt_caes = 'publish - Publicable' where source = 'publish' and tt_caes is null;

-- sander_depth
update i18n.dbdialog set lb_eses = 'Sorrer prof.' where source = 'sander_depth' and lb_caes is null;
update i18n.dbdialog set tt_eses = 'sander_depth - Profundidad del sorrer' where source = 'sander_depth' and tt_eses is null;

update i18n.dbdialog set lb_caes = 'Sorrer prof.' where source = 'sander_depth' and lb_caes is null;
update i18n.dbdialog set tt_caes = 'sander_depth - Profunditat del sorrer' where source = 'sander_depth' and tt_caes is null;

-- y1
update i18n.dbdialog set lb_eses = 'Y1' where source = 'y1' and lb_caes is null;
update i18n.dbdialog set tt_eses = 'y1 - Y1' where source = 'y1' and tt_eses is null;

update i18n.dbdialog set lb_caes = 'Y1' where source = 'y1' and lb_caes is null;
update i18n.dbdialog set tt_caes = 'y1 - Y1' where source = 'y1' and tt_caes is null;

-- category_type
update i18n.dbdialog set lb_eses = 'category_type.' where source = 'category_type' and lb_caes is null;
update i18n.dbdialog set tt_eses = 'category_type - Tipo de categoria' where source = 'category_type' and tt_eses is null;

update i18n.dbdialog set lb_caes = 'category_type.' where source = 'category_type' and lb_caes is null;
update i18n.dbdialog set tt_caes = 'category_type - Tipus de categoria' where source = 'category_type' and tt_caes is null;

-- location_type
update i18n.dbdialog set lb_eses = 'location_type.' where source = 'location_type' and lb_caes is null;
update i18n.dbdialog set tt_eses = 'location_type - Tipo de localización' where source = 'location_type' and tt_eses is null;

update i18n.dbdialog set lb_caes = 'location_type.' where source = 'location_type' and lb_caes is null;
update i18n.dbdialog set tt_caes = 'location_type - Tipus de localización' where source = 'location_type' and tt_caes is null;

-- visitcat_id
update i18n.dbdialog set lb_eses = 'Cat. visit' where source = 'visitcat_id' and lb_caes is null;
update i18n.dbdialog set tt_eses = 'visitcat_id - Identificador del catálogo de visita' where source = 'visitcat_id' and tt_eses is null;

update i18n.dbdialog set lb_caes = 'Cat. visit.' where source = 'visitcat_id' and lb_caes is null;
update i18n.dbdialog set tt_caes = 'visitcat_id - Identificador del catàleg de visita' where source = 'visitcat_id' and tt_caes is null;

-- postcomplement
update i18n.dbdialog set lb_eses = 'Comp. postal.' where source = 'postcomplement' and lb_caes is null;
update i18n.dbdialog set tt_eses = 'postcomplement - Complemento postal' where source = 'postcomplement' and tt_eses is null;

update i18n.dbdialog set lb_caes = 'Comp. postal.' where source = 'postcomplement' and lb_caes is null;
update i18n.dbdialog set tt_caes = 'postcomplement - Complement postal' where source = 'postcomplement' and tt_caes is null;

-- postcomplement2
update i18n.dbdialog set lb_eses = 'Comp. postal.' where source = 'postcomplement2' and lb_caes is null;
update i18n.dbdialog set tt_eses = 'postcomplement2 - Complemento postal 2' where source = 'postcomplement2' and tt_eses is null;

update i18n.dbdialog set lb_caes = 'Comp. postal.' where source = 'postcomplement2' and lb_caes is null;
update i18n.dbdialog set tt_caes = 'postcomplement2 - Complement postal 2' where source = 'postcomplement2' and tt_caes is null;

-- brand
update i18n.dbdialog set lb_eses = 'Marca' where source = 'brand' and lb_caes is null;
update i18n.dbdialog set tt_eses = 'brand - Marca' where source = 'brand' and tt_eses is null;

update i18n.dbdialog set lb_caes = 'Comp. postal.' where source = 'brand' and lb_caes is null;
update i18n.dbdialog set tt_caes = 'brand - Complement postal' where source = 'brand' and tt_caes is null;

-- streetname2
update i18n.dbdialog set lb_eses = 'Nom. calle 2' where source = 'streetname2' and lb_caes is null;
update i18n.dbdialog set tt_eses = 'streetname2 - Nombre de la calle 2' where source = 'streetname2' and tt_eses is null;

update i18n.dbdialog set lb_caes = 'Nom carre 2.' where source = 'streetname2' and lb_caes is null;
update i18n.dbdialog set tt_caes = 'streetname2 - Nom carre 2' where source = 'streetname2' and tt_caes is null;

-- postnumber2
update i18n.dbdialog set lb_eses = 'Núm. postal.' where source = 'postnumber2' and lb_caes is null;
update i18n.dbdialog set tt_eses = 'postnumber2 - Número postal 2' where source = 'postnumber2' and tt_eses is null;

update i18n.dbdialog set lb_caes = 'Núm. postal.' where source = 'postnumber2' and lb_caes is null;
update i18n.dbdialog set tt_caes = 'postnumber2 - Número postal 2' where source = 'postnumber2' and tt_caes is null;

-- fluid_type
update i18n.dbdialog set lb_eses = 'Tipo fluido' where source = 'fluid_type' and lb_caes is null;
update i18n.dbdialog set tt_eses = 'fluid_type - Tipo de fluido' where source = 'fluid_type' and tt_eses is null;

update i18n.dbdialog set lb_caes = 'Tipus fluit.' where source = 'fluid_type' and lb_caes is null;
update i18n.dbdialog set tt_caes = 'fluid_type - Tipus de fluit' where source = 'fluid_type' and tt_caes is null;

-- label_y
update i18n.dbdialog set lb_eses = 'Etiqueta y' where source = 'label_y' and lb_caes is null;
update i18n.dbdialog set tt_eses = 'label_y - Etiqueta y' where source = 'label_y' and tt_eses is null;

update i18n.dbdialog set lb_caes = 'Etiqueta y' where source = 'label_y' and lb_caes is null;
update i18n.dbdialog set tt_caes = 'label_y - Etiqueta y' where source = 'label_y' and tt_caes is null;

-- label_x
update i18n.dbdialog set lb_eses = 'Etiqueta x' where source = 'label_x' and lb_caes is null;
update i18n.dbdialog set tt_eses = 'label_x - Etiqueta x' where source = 'label_x' and tt_eses is null;

update i18n.dbdialog set lb_caes = 'Etiqueta x' where source = 'label_x' and lb_caes is null;
update i18n.dbdialog set tt_caes = 'label_x - Etiqueta x' where source = 'label_x' and tt_caes is null;

-- custom_length
update i18n.dbdialog set lb_eses = 'Long. pers.' where source = 'custom_length' and lb_caes is null;
update i18n.dbdialog set tt_eses = 'custom_length - Longitud personalizada' where source = 'custom_length' and tt_eses is null;

update i18n.dbdialog set lb_caes = 'Long. pers.' where source = 'custom_length' and lb_caes is null;
update i18n.dbdialog set tt_caes = 'custom_length - Longitud personalitzada' where source = 'custom_length' and tt_caes is null;

-- soilcat_id
update i18n.dbdialog set lb_eses = 'Cat. tierra' where source = 'soilcat_id' and lb_caes is null;
update i18n.dbdialog set tt_eses = 'soilcat_id - Identificador del catàlogo de tierra' where source = 'soilcat_id' and tt_eses is null;

update i18n.dbdialog set lb_caes = 'Cat. terra' where source = 'soilcat_id' and lb_caes is null;
update i18n.dbdialog set tt_caes = 'soilcat_id - Identificador del catàleg de terra' where source = 'soilcat_id' and tt_caes is null;

-- top_elev
update i18n.dbdialog set lb_eses = 'Elev. máx.' where source = 'top_elev' and lb_caes is null;
update i18n.dbdialog set tt_eses = 'top_elev - Elevación màxima' where source = 'top_elev' and tt_eses is null;

update i18n.dbdialog set lb_caes = 'Elev. màx.' where source = 'top_elev' and lb_caes is null;
update i18n.dbdialog set tt_caes = 'top_elev - Elevació màxima' where source = 'top_elev' and tt_caes is null;

-- function_type
update i18n.dbdialog set lb_eses = 'Topo func.' where source = 'function_type' and lb_caes is null;
update i18n.dbdialog set tt_eses = 'function_type - Tipo de función' where source = 'function_type' and tt_eses is null;

update i18n.dbdialog set lb_caes = 'Tipus func.' where source = 'function_type' and lb_caes is null;
update i18n.dbdialog set tt_caes = 'function_type - Tipus de funció' where source = 'function_type' and tt_caes is null;

-- label_rotation
update i18n.dbdialog set lb_eses = 'Etiqueta rot.' where source = 'label_rotation' and lb_caes is null;
update i18n.dbdialog set tt_eses = 'label_rotation - Etiqueta de rotación' where source = 'function_type' and tt_eses is null;

update i18n.dbdialog set lb_caes = 'Etiqueta rot.' where source = 'label_rotation' and lb_caes is null;
update i18n.dbdialog set tt_caes = 'label_rotation - Etiqueta rotació' where source = 'label_rotation' and tt_caes is null;

-- pol_id
--update i18n.dbdialog set lb_eses = 'Topo func.' where source = 'pol_id' and lb_caes is null;
--update i18n.dbdialog set tt_eses = 'pol_id - Tipo de función' where source = 'pol_id' and tt_eses is null;

--update i18n.dbdialog set lb_caes = 'Tipus func.' where source = 'pol_id' and lb_caes is null;
--update i18n.dbdialog set tt_caes = 'pol_id - Tipus de funció' where source = 'pol_id' and tt_caes is null;

-- ownercat_id
update i18n.dbdialog set lb_eses = 'ownercat_id' where source = 'ownercat_id' and lb_caes is null;
update i18n.dbdialog set tt_eses = 'ownercat_id - Identificador del catálogo del propietario' where source = 'ownercat_id' and tt_eses is null;

update i18n.dbdialog set lb_caes = 'ownercat_id' where source = 'ownercat_id' and lb_caes is null;
update i18n.dbdialog set tt_caes = 'ownercat_id - Identificador del catàleg del propietari' where source = 'ownercat_id' and tt_caes is null;

-- elev
update i18n.dbdialog set lb_eses = 'Elevación' where source = 'elev' and lb_caes is null;
update i18n.dbdialog set tt_eses = 'elev - Elevación' where source = 'elev' and tt_eses is null;

update i18n.dbdialog set lb_caes = 'Elevació' where source = 'elev' and lb_caes is null;
update i18n.dbdialog set tt_caes = 'elev - Elevació' where source = 'elev' and tt_caes is null;

-- num_value
update i18n.dbdialog set lb_eses = 'Valor num.' where source = 'num_value' and lb_caes is null;
update i18n.dbdialog set tt_eses = 'num_value - Valor numérico' where source = 'num_value' and tt_eses is null;

update i18n.dbdialog set lb_caes = 'Valor num.' where source = 'num_value' and lb_caes is null;
update i18n.dbdialog set tt_caes = 'num_value - Valor numèric' where source = 'num_value' and tt_caes is null;

-- lot_id
--update i18n.dbdialog set lb_eses = 'Topo func.' where source = 'lot_id' and lb_caes is null;
--update i18n.dbdialog set tt_eses = 'lot_id - Tipo de función' where source = 'lot_id' and tt_eses is null;

--update i18n.dbdialog set lb_caes = 'Tipus func.' where source = 'lot_id' and lb_caes is null;
--update i18n.dbdialog set tt_caes = 'lot_id - Tipus de funció' where source = 'lot_id' and tt_caes is null;

-- connec_id
update i18n.dbdialog set lb_eses = 'Topo func.' where source = 'connec_id' and lb_caes is null;
update i18n.dbdialog set tt_eses = 'connec_id - Tipo de función' where source = 'connec_id' and tt_eses is null;

update i18n.dbdialog set lb_caes = 'Tipus func.' where source = 'connec_id' and lb_caes is null;
update i18n.dbdialog set tt_caes = 'connec_id - Tipus de funció' where source = 'connec_id' and tt_caes is null;

-- lastupdate
update i18n.dbdialog set lb_eses = 'lastupdate' where source = 'lastupdate' and lb_caes is null;
update i18n.dbdialog set tt_eses = 'lastupdate - Última actulización' where source = 'lastupdate' and tt_eses is null;

update i18n.dbdialog set lb_caes = 'lastupdate' where source = 'lastupdate' and lb_caes is null;
update i18n.dbdialog set tt_caes = 'lastupdate - Última actualització' where source = 'lastupdate' and tt_caes is null;

-- demand
update i18n.dbdialog set lb_eses = 'Topo func.' where source = 'demand' and lb_caes is null;
update i18n.dbdialog set tt_eses = 'demand - Tipo de función' where source = 'demand' and tt_eses is null;

update i18n.dbdialog set lb_caes = 'Tipus func.' where source = 'demand' and lb_caes is null;
update i18n.dbdialog set tt_caes = 'demand - Tipus de funció' where source = 'demand' and tt_caes is null;

-- flap
update i18n.dbdialog set lb_eses = 'lastupdate' where source = 'flap' and lb_caes is null;
update i18n.dbdialog set tt_eses = 'flap - Última actulización' where source = 'flap' and tt_eses is null;

update i18n.dbdialog set lb_caes = 'lastupdate' where source = 'flap' and lb_caes is null;
update i18n.dbdialog set tt_caes = 'flap - Última actualització' where source = 'flap' and tt_caes is null;

-- epa_type
update i18n.dbdialog set lb_eses = '"lastupd. user"' where source = '"epa_type"' and lb_caes is null;
update i18n.dbdialog set tt_eses = '"epa_type" - Usuario de la útima actualización' where source = '"epa_type"' and tt_eses is null;

update i18n.dbdialog set lb_caes = '"lastupd. user"' where source = '"epa_type"' and lb_caes is null;
update i18n.dbdialog set tt_caes = '"epa_type" - Usuari de l''última actualització ' where source = '"epa_type"' and tt_caes is null;

-- custom_elev1
update i18n.dbdialog set lb_eses = 'lastupdate' where source = 'custom_elev1' and lb_caes is null;
update i18n.dbdialog set tt_eses = 'custom_elev1 - Última actulización' where source = 'custom_elev1' and tt_eses is null;

update i18n.dbdialog set lb_caes = 'lastupdate' where source = 'custom_elev1' and lb_caes is null;
update i18n.dbdialog set tt_caes = 'custom_elev1 - Última actualització' where source = 'custom_elev1' and tt_caes is null;

-- geom2
update i18n.dbdialog set lb_eses = 'lastupdate' where source = 'geom2' and lb_caes is null;
update i18n.dbdialog set tt_eses = 'geom2 - Última actulización' where source = 'geom2' and tt_eses is null;

update i18n.dbdialog set lb_caes = 'lastupdate' where source = 'geom2' and lb_caes is null;
update i18n.dbdialog set tt_caes = 'geom2 - Última actualització' where source = 'geom2' and tt_caes is null;

-- cost
update i18n.dbdialog set lb_eses = 'Valor' where source = 'cost' and lb_caes is null;
update i18n.dbdialog set tt_eses = 'cost - Valor' where source = 'cost' and tt_eses is null;

update i18n.dbdialog set lb_caes = 'Valor' where source = 'cost' and lb_caes is null;
update i18n.dbdialog set tt_caes = 'cost - Valor' where source = 'cost' and tt_caes is null;

-- offset
update i18n.dbdialog set lb_eses = 'Compensar' where source = 'offset' and lb_caes is null;
update i18n.dbdialog set tt_eses = 'offset - Compensar' where source = 'offset' and tt_eses is null;

update i18n.dbdialog set lb_caes = 'Compensar' where source = 'offset' and lb_caes is null;
update i18n.dbdialog set tt_caes = 'offset - Compensar' where source = 'offset' and tt_caes is null;

-- dnom
update i18n.dbdialog set lb_eses = 'dnom' where source = 'dnom' and lb_caes is null;
update i18n.dbdialog set tt_eses = 'dnom - Última actulización' where source = 'dnom' and tt_eses is null;

update i18n.dbdialog set lb_caes = 'dnom' where source = 'dnom' and lb_caes is null;
update i18n.dbdialog set tt_caes = 'dnom - Última actualització' where source = 'dnom' and tt_caes is null;

-- cost_unit
update i18n.dbdialog set lb_eses = 'Unidades' where source = 'cost_unit' and lb_caes is null;
update i18n.dbdialog set tt_eses = 'cost_unit - Unidades del coste' where source = 'dnom' and tt_eses is null;

update i18n.dbdialog set lb_caes = 'Unidades' where source = 'cost_unit' and lb_caes is null;
update i18n.dbdialog set tt_caes = 'cost_unit - Unitats del cost' where source = 'cost_unit' and tt_caes is null;

update i18n.dbdialog set lb_ptpt = 'Unidades' where source = 'cost_unit' and lb_ptpt is null;
update i18n.dbdialog set tt_ptpt = 'cost_unit - Unidades de custo' where source = 'cost_unit' and lb_ptpt is null;


"demand";""
"cost";""
"y2";""
"elev";""
"geom2";""
"geom3";""
"offset";""
"custom_length";""
"label";"label - Campo opcional para definir la etiqueta"
"muni_id";"muni_id - Identificador del municipio"
"macrodma_id";"macrodma_id - Identificador de macrodma"
"work_order";""
"rotation";"rotation - Rotación del sí­mbolo. Por defecto se calcula automáticamente en función de los ángulos de los arcos vinculados"
"timser_id";""
"vel";""
"cd";""
"limit";""
"top_elev";""
"inverted_slope";""
"svg";"svg - En caso de usar simbologí­a svg, se muestra la ruta hacia el fichero que contiene la simbologí­a"
"geom4";""
"flow";""
"custom_elev2";""
"elev2";""
"connec_id";""
"label";""
"grafconfig";""
"custom_elev1";""
"elev1";""
"sys_elev2";""
"bottom_channel";"bottom_channel - Para establecer si tiene canal al fondo o no"
"code";"code - Código"
"custom_y1";""
"inlet";"inlet - Elemento con aportaciones"
"pnom";""
"sys_elev1";""
"custom_y2";""
"rotation";""
"macroexpl_id";""
"flwreg_length";""
"wetw_inf";""
"postnumber";""
"parameter_id";""
"streetname";""
"power";"power - Potencia total"
"ground_inf";""
"custom_top_elev";""
"builtdate";"builtdate - Fecha de construcción"
"surf_runof";""
"presszonecat_id";"presszonecat_id - Relacionado con el catálogo de zonas de presión"
"avg_flow";""
"ymax";""
"min_flow";""
"sys_elev";""
"swnod_type";""
"percent";""
"quality";""
"postcode";"postcode - Código postal"
"dryw_inf";""
"minorloss";""
"ext_out";""
"cd2";""
"rdii_inf";""
"prot_surface";"prot_surface - Para establecer si existe un protector en superfície"
"event_id";""
"event_code";""
"comment";""
"ext_inf";""
"custom_elev";""
"landus_id";""
"infil_loss";""
"stylesheet";""
"flwreg_id";""
"custom_ymax";""
"uncertain";"uncertain - Para establecer si la ubicación del elemento es incierta"
"pjoint_id";"pjoint_id - Identificador del punto de unión con la red"
"cat_dnom";"cat_dnom - Díametro nominal del elemento en mm. No se puede rellenar. Se usa el que tenga el campo dnom en el catálogo correspondiente"
"connec_length";"connec_length - Longitud de la conexión"
"descript";"Campo para almacenar información adicional sobre el material."
"max_volume";"max_volume - Volumen máximo"
"sys_type";"sys_type - Tipo de elemento de sistema. Referente a la tabla sys_feature_cat"
"y0";""
"visit_start";""
"user_name";""
"cost_ut";""
"feature_type";""
"serial_number";"serial_number - Número de serie del elemento"
"value_7";""
"value_4";""
"press";""
"featurecat_id";"featurecat_id - Catálogo del elemento al cual se conecta"
"minsector_id";"minsector_id - Identificador del minsector (sector mínimo de la red) al que pertenece el elemento"
"linked_connec";"linked_connec - Identificador de la acometida asociada"
"area";""
"cat_valve";"cat_valve - Catálogo de la válvula asociada"
"value_3";""
"m2bottom_cost";""
"macrodqa_id";"macrodqa_id - Identificador de la macrodqa_id. Se rellena automáticamente en función de la dqa"
"district_id";""
"ysur";""
"value_5";""
"matcat_id";"cat_matcat_id - Material del elemento. No se puede rellenar Se usa el que tenga el campo matcat_id del catálogo correspondiente"
"scale";""
"feature_id";"feature_id - Identificador del elemento al cual se conecta"
"util_volume";"util_volume - Volumen útil"
"dqa_id";"dqa_id - Identificador de la dqa(zona de calidad del agua) a la que pertenece el elemento"
"tstamp";""
"cat_pnom";"cat_pnom - Presión nominal del elemento en atm. No se puede rellenar. Se usa el que tenga el campo pnom en el catálogo correspondiente"
"head";""
"value_6";""
"m3protec_cost";""
"ffactor";""
"fname";""
"headloss";""
"pjoint_type";"pjoint_type - Tipo de punto de unión con la red"
"value_2";""
"context";""
"apond";""
"setting";""
"idval";""
"max_headloss";""
"visit_code";""
"curve_type";""
"rem_buil";""
"verified";""
"evap_loss";""
"min_uheadloss";""
"max_full";""
"avg_full";""
"cat_matcat_id";"cat_matcat_id - Material del elemento. No se puede rellenar Se usa el que tenga el campo matcat_id del catálogo correspondiente"
"min_setting";""
"init_stor";""
"surf_buil";""
"finst_mas";""
"min_ffactor";""
"mass_reac";""
"min_shear";""
"coef_loss";""
"budget";""
"top_floor";"top_floor - Número máximo de plantas del edificio a abastecer"
"kwhr_mgal";""
"rdiip_prod";""
"ei_loss";""
"type";""
"node_2";"node_2 - Identificador del nodo final del tramo"
"form_type";""
"pat1";""
"vymax";""
"avg_effic";""
"max_vel";""
"pump_number";"pump_number - Número de bombas"
"max_out";""
"tot_runofl";""
"min_pressure";""
"m3fill_cost";""
"incident_type";""
"hydrology_id";""
"m2trenchl_cost";""
"total_vol";""
"upstream";""
"position_id";""
"hour_limit";""
"nodarc_id";""
"bmp_re";""
"sub_crit";""
"max_totinf";""
"min_quality";""
"day_min";""
"pat2";""
"int_out";""
"max_ponded";""
"max_uheadloss";""
"dext";""
"initlevel";""
"max_pressure";""
"final_stor";""
"sweep_re";""
"pressure";""
"maxlevel";""
"connec_depth";"connec_depth - Profundidad de la conexión"
"base";""
"cost_m3";""
"max_shear";""
"ori_type";""
"tsect_id";""
"sfactor";""
"c2";""
"wet_dep";""
"macrodqa_id";""
"surcharge";""
"initsw_co";""
"vmax";"vmax - Volumen máximo"
"staticpressure";"staticpressure - Presión estática calculada dinámicamente y vinculada con la zona de presión"
"composer";""
"epa_type";"epa_type - Tipo de nodo que se usará para el modelo hidráulico. No es necesario introducirlo, es automático en función del node type."
"orate";""
"value_8";""
"max_slope";""
"c1";""
"outlet_type";""
"cost_day";""
"sewer_rain";""
"shutoff";""
"workcat_id_end";""
"finst_vol";""
"aver_depth";""
"timoff_min";""
"cancelbutton";""
"mfactor";""
"tot_evap";""
"seepage_losses";""
"aquif_id";""
"groundw_fl";""
"m3excess_cost";""
"min_head";""
"tot_runoff";""
"max_rate";""
"y1";"y1 - Profundidad de salida del nodo inicial aportada por el inventario"
"day_max";""
"finalsw_co";""
"tot_runon";""
"max_setting";""
"custom_length";"custom_length - Longitud del arco en metros. Asignado por el usuario"
"both_ends";""
"avg_kw";""
"initst_mas";""
"down_dry";""
"max_ffactor";""
"minvol";""
"up_dry";""
"elevation";"elevation - Elevación del elemento en metros sobre el nivel del mar"
"int_inf";""
"x_value";""
"pat3";""
"timoff_max";""
"latinf_vol";""
"powus_kwh";""
"arq_patrimony";"arq_patrimony - Para establecer si la fuente es patrimonio arquitectónico o no"
"hour_flood";""
"flow_freq";""
"mfull_dept";""
"dnstream";""
"min_demand";""
"diameter";""
"deep_perc";""
"gis_length";"gis_length - Longitud del arco en metros. Calculado por el programa"
"epa_type";""
"max_quality";""
"parameter";""
"m3exc_cost";""
"total_prec";""
"aver_vol";""
"pat4";""
"cost_ml";""
"evap_losses";""
"tot_flood";""
"max_hgl";""
"rg_id";""
"rdiir_rat";""
"mfull_flow";""
"dint";""
"max_demand";""
"peak_runof";""
"distance";""
"value_1";""
"thickness";""
"vol_ltr";""
"totinf_vol";""
"connec_id";"connec_id - Identificador del connec. No es necesario introducirlo, es un serial automático"
"minlevel";""
"snow_re";""
"epa_type";"epa_type - Tipo de nodo que se usará para el modelo hidráulico. No es necesario introducirlo, es automático en función del nodecat."
"vxmax";""
"max_hr";""
"a2";""
"runoff_coe";""
"time_max";""
"tot_infil";""
"peak_kw";""
"initst_vol";""
"max_latinf";""
"class";""
"y_param";""
"max_depth";""
"max_head";""
"valv_type";""
"a1";""
"max_vol";""
"usage_fact";""
"ymax";"ymax - Profundidad del nodo aportada por el inventario"
"startup";""
"y2";"y2 - Profundidad de entrada del nodo final aportada por el inventario"
"max_veloc";""
"stor_loss";""
"b";""
"node_1";"node_1 - Identificador del nodo inicial del tramo"
"title";""
"hour_nflow";""
"speed";""
"sub_crit_1";""
"cd1";""
"up_crit";""
"weir_type";""
"depth";"depth - Profundidad del elemento en metros"
"init_buil";""
"pattern_type";""
"date";""
"team_id";""
"ec";""
"max_reaction";""
"customer_code";"customer_code - Código de abonado"
"infilt";""
"flow_balance_error";""
"min_reaction";""
"position_value";""
"presszone_id";""
"lowzone_et";""
"node_id";"node_id - Identificador del nodo. No es necesario introducirlo, es un serial automático"
"lidco_id";""
"workcat_id";""
"min_headloss";""
"x_symbol";""
"snow_id";""
"y_symbol";""
"dwfscenario_id";""
"y_value";""
"vhmax";""
"finals_sto";""
"min_vel";""
"tot_precip";""
"time_min";""
"dry";""
"upzone_et";""
"num_startup";""
"pattern";""



