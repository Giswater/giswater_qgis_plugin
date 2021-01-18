/*
This file is part of Giswater 3
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association
*/


-- get priority in terms of translate
select count(*), source, tt_es_es from i18n.dbdialog group by source, tt_es_es order by 1 desc

select * from i18n.dbdialog

-- translate it

-- result_id
update i18n.dbdialog set lb_es_es = 'Id resultado' where source = 'result_id' and lb_ca_es is null;
update i18n.dbdialog set tt_es_es = 'result_id - Identificador del resultado' where source = 'result_id' and tt_es_es is null;

-- sector_id
update i18n.dbdialog set lb_es_es = 'Id sector' where source = 'sector_id' and lb_ca_es is null;
update i18n.dbdialog set tt_es_es = 'sector_id - Identificador del sector' where source = 'sector_id' and tt_es_es is null;

-- node_id
update i18n.dbdialog set lb_es_es = 'Id nodo' where source = 'node_id' and lb_ca_es is null;
update i18n.dbdialog set tt_es_es = 'node_id - Identificador del nodo' where source = 'node_id' and tt_es_es is null;

-- descript
update i18n.dbdialog set lb_es_es = 'Descrip.' where source = 'descript' and lb_ca_es is null;
update i18n.dbdialog set tt_es_es = 'descript - Descripción' where source = 'descript' and tt_es_es is null;

-- arc_id
update i18n.dbdialog set lb_es_es = 'Id arco' where source = 'arc_id' and lb_ca_es is null;
update i18n.dbdialog set tt_es_es = 'arc_id - Identificador del arco' where source = 'arc_id' and tt_es_es is null;

-- expl_id
update i18n.dbdialog set lb_es_es = 'Id expl.' where source = 'expl_id' and lb_ca_es is null;
update i18n.dbdialog set tt_es_es = 'expl_id - Identificador de la explotación' where source = 'expl_id' and tt_es_es is null;

-- state
update i18n.dbdialog set lb_es_es = 'Estado' where source = 'state' and lb_ca_es is null;
update i18n.dbdialog set tt_es_es = 'state - Estado' where source = 'state' and tt_es_es is null;

-- link
update i18n.dbdialog set lb_es_es = 'Link' where source = 'link' and lb_ca_es is null;
update i18n.dbdialog set tt_es_es = 'link - Link' where source = 'link' and tt_es_es is null;

-- name
update i18n.dbdialog set lb_es_es = 'Nombre' where source = 'name' and lb_ca_es is null;
update i18n.dbdialog set tt_es_es = 'name - Nombre' where source = 'name' and tt_es_es is null;

-- nodecat_id
update i18n.dbdialog set lb_es_es = 'Cat. nodo' where source = 'nodecat_id' and lb_ca_es is null;
update i18n.dbdialog set tt_es_es = 'nodecat_id - Identificador del catálogo de nodo' where source = 'nodecat_id' and tt_es_es is null;

-- macrosector_id
update i18n.dbdialog set lb_es_es = 'Id macrosector' where source = 'macrosector_id' and lb_ca_es is null;
update i18n.dbdialog set tt_es_es = 'macrosector_id - Identificador del del macrosector' where source = 'macrosector_id' and tt_es_es is null;

-- text
update i18n.dbdialog set lb_es_es = 'Texto' where source = 'text' and lb_ca_es is null;
update i18n.dbdialog set tt_es_es = 'text - Texto' where source = 'text' and tt_es_es is null;

-- annotation
update i18n.dbdialog set lb_es_es = 'Anotación' where source = 'annotation' and lb_ca_es is null;
update i18n.dbdialog set tt_es_es = 'annotation - Anotación' where source = 'annotation' and tt_es_es is null;

-- arccat_id
update i18n.dbdialog set lb_es_es = 'Cat. arco' where source = 'arccat_id' and lb_ca_es is null;
update i18n.dbdialog set tt_es_es = 'arccat_id - Catálogo de arco' where source = 'arccat_id' and tt_es_es is null;

-- matcat_id
update i18n.dbdialog set lb_es_es = 'Cat. mat.' where source = 'matcat_id' and lb_ca_es is null;
update i18n.dbdialog set tt_es_es = 'matcat_id - Identificador de catálogo de materiales' where source = 'matcat_id' and tt_es_es is null;

-- node_type
update i18n.dbdialog set lb_es_es = 'Tipo nodo' where source = 'node_type' and lb_ca_es is null;
update i18n.dbdialog set tt_es_es = 'node_type - Tipo de nodo' where source = 'node_type' and tt_es_es is null;

-- enddate
update i18n.dbdialog set lb_es_es = 'Data final' where source = 'enddate' and lb_ca_es is null;
update i18n.dbdialog set tt_es_es = 'enddate - Data final' where source = 'enddate' and tt_es_es is null;

-- observ
update i18n.dbdialog set lb_es_es = 'Observación' where source = 'observ' and lb_ca_es is null;
update i18n.dbdialog set tt_es_es = 'observ - Observación' where source = 'observ' and tt_es_es is null;

-- elevation
update i18n.dbdialog set lb_es_es = 'Elevación' where source = 'elevation' and lb_ca_es is null;
update i18n.dbdialog set tt_es_es = 'elevation - Elevación' where source = 'elevation' and tt_es_es is null;

-- undelete
update i18n.dbdialog set lb_es_es = 'Bloqueado' where source = 'undelete' and lb_ca_es is null;
update i18n.dbdialog set tt_es_es = 'undelete - Bloqueado' where source = 'undelete' and tt_es_es is null;

-- poll_id
update i18n.dbdialog set lb_es_es = 'Id contaminante' where source = 'poll_id' and lb_ca_es is null;
update i18n.dbdialog set tt_es_es = 'poll_id - Identificador de contaminante' where source = 'poll_id' and tt_es_es is null;

-- backbutton
update i18n.dbdialog set lb_es_es = 'Atras' where source = 'backbutton' and lb_ca_es is null;
update i18n.dbdialog set tt_es_es = 'backbutton - Botón de atrás' where source = 'backbutton' and tt_es_es is null;

-- status
update i18n.dbdialog set lb_es_es = 'Estado' where source = 'status' and lb_ca_es is null;
update i18n.dbdialog set tt_es_es = 'status - Estado' where source = 'status' and tt_es_es is null;

-- curve_id
update i18n.dbdialog set lb_es_es = 'Id curva' where source = 'curve_id' and lb_ca_es is null;
update i18n.dbdialog set tt_es_es = 'curve_id - Identificador de la curva' where source = 'curve_id' and tt_es_es is null;

-- arc_type
update i18n.dbdialog set lb_es_es = 'Tipo arco' where source = 'arc_type' and lb_ca_es is null;
update i18n.dbdialog set tt_es_es = 'arc_type - Tipo de arco' where source = 'arc_type' and tt_es_es is null;

-- depth
update i18n.dbdialog set lb_es_es = 'Profundidad' where source = 'depth' and lb_ca_es is null;
update i18n.dbdialog set tt_es_es = 'depth - Profundidad del nodo' where source = 'depth' and tt_es_es is null;

-- dma_id 
update i18n.dbdialog set lb_es_es = 'Id dma' where source = 'dma_id' and lb_ca_es is null;
update i18n.dbdialog set tt_es_es = 'dma_id - Identificador de dma' where source = 'dma_id' and tt_es_es is null;

-- muni_id 
update i18n.dbdialog set lb_es_es = 'Id muni' where source = 'muni_id' and lb_ca_es is null;
update i18n.dbdialog set tt_es_es = 'muni_id - Identificador del municipio' where source = 'muni_id' and tt_es_es is null;

-- macrodma_id 
update i18n.dbdialog set lb_es_es = 'Id macrodma' where source = 'macrodma_id' and lb_ca_es is null;
update i18n.dbdialog set tt_es_es = 'macrodma_id - Identificador de macrodma' where source = 'macrodma_id' and tt_es_es is null;

-- pattern_id 
update i18n.dbdialog set lb_es_es = 'Id pattern' where source = 'pattern_id' and lb_ca_es is null;
update i18n.dbdialog set tt_es_es = 'pattern_id - Identificador de pattern' where source = 'pattern_id' and tt_es_es is null;

-- active 
update i18n.dbdialog set lb_es_es = 'Activo' where source = 'active' and lb_ca_es is null;
update i18n.dbdialog set tt_es_es = 'active - Activo' where source = 'active' and tt_es_es is null;

-- code
update i18n.dbdialog set lb_es_es = 'Código' where source = 'code' and lb_ca_es is null;
update i18n.dbdialog set tt_es_es = 'code - Código' where source = 'code' and tt_es_es is null;

-- class_id
update i18n.dbdialog set lb_es_es = 'Id clase' where source = 'class_id' and lb_ca_es is null;
update i18n.dbdialog set tt_es_es = 'class_id - Identificador de clase' where source = 'class_id' and tt_es_es is null;

-- length
update i18n.dbdialog set lb_es_es = 'Longitud' where source = 'length' and lb_ca_es is null;
update i18n.dbdialog set tt_es_es = 'length - Longitud' where source = 'length' and tt_es_es is null;

-- visit_id
update i18n.dbdialog set lb_es_es = 'Id visita' where source = 'visit_id' and lb_ca_es is null;
update i18n.dbdialog set tt_es_es = 'visit_id - Identificador de visita' where source = 'visit_id' and tt_es_es is null;

-- value
update i18n.dbdialog set lb_es_es = 'Valor' where source = 'value' and lb_ca_es is null;
update i18n.dbdialog set tt_es_es = 'value - Valor' where source = 'value' and tt_es_es is null;

-- svg
update i18n.dbdialog set lb_es_es = 'Svg' where source = 'svg' and lb_ca_es is null;
update i18n.dbdialog set tt_es_es = 'svg - Svg' where source = 'svg' and tt_es_es is null;

-- builtdate
update i18n.dbdialog set lb_es_es = 'Fecha cons.' where source = 'builtdate' and lb_ca_es is null;
update i18n.dbdialog set tt_es_es = 'builtdate - Fecha de construcción' where source = 'builtdate' and tt_es_es is null;

-- postcode
update i18n.dbdialog set lb_es_es = 'Código postal' where source = 'postcode' and lb_ca_es is null;
update i18n.dbdialog set tt_es_es = 'postcode - Código postal' where source = 'postcode' and tt_es_es is null;

-- acceptbutton
update i18n.dbdialog set lb_es_es = 'Aceptar' where source = 'acceptbutton' and lb_ca_es is null;
update i18n.dbdialog set tt_es_es = 'acceptbutton - Botón de aceptado' where source = 'acceptbutton' and tt_es_es is null;

-- streetname
update i18n.dbdialog set lb_es_es = 'Nom. calle' where source = 'streetname' and lb_ca_es is null;
update i18n.dbdialog set tt_es_es = 'streetname - Nombre de la calle' where source = 'streetname' and tt_es_es is null;

-- postnumber
update i18n.dbdialog set lb_es_es = 'Núm. post.' where source = 'postnumber' and lb_ca_es is null;
update i18n.dbdialog set tt_es_es = 'postnumber - Número postal' where source = 'postnumber' and tt_es_es is null;

-- label
update i18n.dbdialog set lb_es_es = 'Etiqueta' where source = 'label' and lb_ca_es is null;
update i18n.dbdialog set tt_es_es = 'label - Etiqueta' where source = 'label' and tt_es_es is null;

-- comment
update i18n.dbdialog set lb_es_es = 'Coment.' where source = 'comment' and lb_ca_es is null;
update i18n.dbdialog set tt_es_es = 'comment - Comentario' where source = 'comment' and tt_es_es is null;

-- ext_code
update i18n.dbdialog set lb_es_es = 'Ext. code' where source = 'ext_code' and lb_ca_es is null;
update i18n.dbdialog set tt_es_es = 'ext_code - Código externo' where source = 'ext_code' and tt_es_es is null;

-- time_hour
update i18n.dbdialog set lb_es_es = 'Time_hora' where source = 'time_hour' and lb_ca_es is null;
update i18n.dbdialog set tt_es_es = 'time_hour - Horas' where source = 'time_hour' and tt_es_es is null;

-- startdate
update i18n.dbdialog set lb_es_es = 'Fecha in.' where source = 'startdate' and lb_ca_es is null;
update i18n.dbdialog set tt_es_es = 'startdate - Fecha de inicio' where source = 'startdate' and tt_es_es is null;

-- geom1
update i18n.dbdialog set lb_es_es = 'Time_hora' where source = 'geom1' and lb_ca_es is null;
update i18n.dbdialog set tt_es_es = 'geom1 - Horas' where source = 'geom1' and tt_es_es is null;

-- time_days
update i18n.dbdialog set lb_es_es = 'Time_dia' where source = 'time_days' and lb_ca_es is null;
update i18n.dbdialog set tt_es_es = 'time_days - Días' where source = 'time_days' and tt_es_es is null;

-- shape
update i18n.dbdialog set lb_es_es = 'Forma' where source = 'shape' and lb_ca_es is null;
update i18n.dbdialog set tt_es_es = 'shape - Forma' where source = 'shape' and tt_es_es is null;

-- cont_error
update i18n.dbdialog set lb_es_es = 'Cont_error' where source = 'cont_error' and lb_ca_es is null;
update i18n.dbdialog set tt_es_es = 'cont_error - Error de continuidad' where source = 'cont_error' and tt_es_es is null;

-- max_flow
update i18n.dbdialog set lb_es_es = 'Max. caudal' where source = 'max_flow' and lb_ca_es is null;
update i18n.dbdialog set tt_es_es = 'max_flow - Caudal máximo' where source = 'max_flow' and tt_es_es is null;

-- feature_id
update i18n.dbdialog set lb_es_es = 'Feature' where source = 'feature_id' and lb_ca_es is null;
update i18n.dbdialog set tt_es_es = 'feature_id - Identificador de Feature' where source = 'feature_id' and tt_es_es is null;

-- time
update i18n.dbdialog set lb_es_es = 'Tiempo' where source = 'time' and lb_ca_es is null;
update i18n.dbdialog set tt_es_es = 'time - Tiempo' where source = 'time' and tt_es_es is null;

-- workcat_id
update i18n.dbdialog set lb_es_es = 'Cat. trabajo' where source = 'workcat_id' and lb_ca_es is null;
update i18n.dbdialog set tt_es_es = 'workcat_id - Identificador del catálogo de trabajo' where source = 'workcat_id' and tt_es_es is null;

-- subc_id
update i18n.dbdialog set lb_es_es = 'Subcon.' where source = 'subc_id' and lb_ca_es is null;
update i18n.dbdialog set tt_es_es = 'subc_id - Identificador de subcuenca de drenaje' where source = 'subc_id' and tt_es_es is null;

-- workcat_id_end
update i18n.dbdialog set lb_es_es = 'Cat. trabajo' where source = 'workcat_id_end' and lb_ca_es is null;
update i18n.dbdialog set tt_es_es = 'workcat_id_end - Identificador final del catálogo de trabajo' where source = 'workcat_id_end' and tt_es_es is null;

-- node_1
update i18n.dbdialog set lb_es_es = 'Nodo 1' where source = 'node_1' and lb_ca_es is null;
update i18n.dbdialog set tt_es_es = 'node_1 - Nodo 1' where source = 'node_1' and tt_es_es is null;

-- verified
update i18n.dbdialog set lb_es_es = 'Verificado' where source = 'verified' and lb_ca_es is null;
update i18n.dbdialog set tt_es_es = 'verified - Verificado' where source = 'verified' and tt_es_es is null;

-- to_arc
update i18n.dbdialog set lb_es_es = 'to_arc' where source = 'to_arc' and lb_ca_es is null;
update i18n.dbdialog set tt_es_es = 'to_arc - Arco destino' where source = 'to_arc' and tt_es_es is null;

-- gis_length
update i18n.dbdialog set lb_es_es = 'Long. gis' where source = 'gis_length' and lb_ca_es is null;
update i18n.dbdialog set tt_es_es = 'gis_length - Longitud del gis' where source = 'gis_length' and tt_es_es is null;

-- rotation
update i18n.dbdialog set lb_es_es = 'Rotación' where source = 'rotation' and lb_ca_es is null;
update i18n.dbdialog set tt_es_es = 'rotation - Rotación' where source = 'rotation' and tt_es_es is null;

-- node_2
update i18n.dbdialog set lb_es_es = 'Node 2' where source = 'node_2' and lb_ca_es is null;
update i18n.dbdialog set tt_es_es = 'node_2 - Node 2' where source = 'node_2' and tt_es_es is null;

-- inventory
update i18n.dbdialog set lb_es_es = 'Inventario' where source = 'inventory' and lb_ca_es is null;
update i18n.dbdialog set tt_es_es = 'inventory - Inventario' where source = 'inventory' and tt_es_es is null;

-- model
update i18n.dbdialog set lb_es_es = 'Modelo' where source = 'model' and lb_ca_es is null;
update i18n.dbdialog set tt_es_es = 'model - Modelo' where source = 'model' and tt_es_es is null;

-- y2
update i18n.dbdialog set lb_es_es = 'Y2' where source = 'y2' and lb_ca_es is null;
update i18n.dbdialog set tt_es_es = 'y2 - Y2' where source = 'y2' and tt_es_es is null;

-- buildercat_id
update i18n.dbdialog set lb_es_es = 'Cat. const' where source = 'buildercat_id' and lb_ca_es is null;
update i18n.dbdialog set tt_es_es = 'buildercat_id - Identificador del catálogo de construcción' where source = 'buildercat_id' and tt_es_es is null;

-- state_type
update i18n.dbdialog set lb_es_es = 'Tipo estado' where source = 'state_type' and lb_ca_es is null;
update i18n.dbdialog set tt_es_es = 'state_type - Tipo de estado' where source = 'state_type' and tt_es_es is null;

-- publish
update i18n.dbdialog set lb_es_es = 'Publicable' where source = 'publish' and lb_ca_es is null;
update i18n.dbdialog set tt_es_es = 'publish - Publicable' where source = 'publish' and tt_es_es is null;

-- sander_depth
update i18n.dbdialog set lb_es_es = 'Sorrer prof.' where source = 'sander_depth' and lb_ca_es is null;
update i18n.dbdialog set tt_es_es = 'sander_depth - Profundidad del sorrer' where source = 'sander_depth' and tt_es_es is null;

-- y1
update i18n.dbdialog set lb_es_es = 'Y1' where source = 'y1' and lb_ca_es is null;
update i18n.dbdialog set tt_es_es = 'y1 - Y1' where source = 'y1' and tt_es_es is null;

-- category_type
update i18n.dbdialog set lb_es_es = 'category_type.' where source = 'category_type' and lb_ca_es is null;
update i18n.dbdialog set tt_es_es = 'category_type - Tipo de categoria' where source = 'category_type' and tt_es_es is null;

-- location_type
update i18n.dbdialog set lb_es_es = 'location_type.' where source = 'location_type' and lb_ca_es is null;
update i18n.dbdialog set tt_es_es = 'location_type - Tipo de localización' where source = 'location_type' and tt_es_es is null;

-- visitcat_id
update i18n.dbdialog set lb_es_es = 'Cat. visit' where source = 'visitcat_id' and lb_ca_es is null;
update i18n.dbdialog set tt_es_es = 'visitcat_id - Identificador del catálogo de visita' where source = 'visitcat_id' and tt_es_es is null;

-- postcomplement
update i18n.dbdialog set lb_es_es = 'Comp. postal.' where source = 'postcomplement' and lb_ca_es is null;
update i18n.dbdialog set tt_es_es = 'postcomplement - Complemento postal' where source = 'postcomplement' and tt_es_es is null;

-- postcomplement2
update i18n.dbdialog set lb_es_es = 'Comp. postal.' where source = 'postcomplement2' and lb_ca_es is null;
update i18n.dbdialog set tt_es_es = 'postcomplement2 - Complemento postal 2' where source = 'postcomplement2' and tt_es_es is null;

-- brand
update i18n.dbdialog set lb_es_es = 'Marca' where source = 'brand' and lb_ca_es is null;
update i18n.dbdialog set tt_es_es = 'brand - Marca' where source = 'brand' and tt_es_es is null;

-- streetname2
update i18n.dbdialog set lb_es_es = 'Nom. calle 2' where source = 'streetname2' and lb_ca_es is null;
update i18n.dbdialog set tt_es_es = 'streetname2 - Nombre de la calle 2' where source = 'streetname2' and tt_es_es is null;

-- postnumber2
update i18n.dbdialog set lb_es_es = 'Núm. postal.' where source = 'postnumber2' and lb_ca_es is null;
update i18n.dbdialog set tt_es_es = 'postnumber2 - Número postal 2' where source = 'postnumber2' and tt_es_es is null;

-- fluid_type
update i18n.dbdialog set lb_es_es = 'Tipo fluido' where source = 'fluid_type' and lb_ca_es is null;
update i18n.dbdialog set tt_es_es = 'fluid_type - Tipo de fluido' where source = 'fluid_type' and tt_es_es is null;

-- label_y
update i18n.dbdialog set lb_es_es = 'Etiqueta y' where source = 'label_y' and lb_ca_es is null;
update i18n.dbdialog set tt_es_es = 'label_y - Etiqueta y' where source = 'label_y' and tt_es_es is null;

-- label_x
update i18n.dbdialog set lb_es_es = 'Etiqueta x' where source = 'label_x' and lb_ca_es is null;
update i18n.dbdialog set tt_es_es = 'label_x - Etiqueta x' where source = 'label_x' and tt_es_es is null;

-- custom_length
update i18n.dbdialog set lb_es_es = 'Long. pers.' where source = 'custom_length' and lb_ca_es is null;
update i18n.dbdialog set tt_es_es = 'custom_length - Longitud personalizada' where source = 'custom_length' and tt_es_es is null;

-- soilcat_id
update i18n.dbdialog set lb_es_es = 'Cat. tierra' where source = 'soilcat_id' and lb_ca_es is null;
update i18n.dbdialog set tt_es_es = 'soilcat_id - Identificador del catàlogo de tierra' where source = 'soilcat_id' and tt_es_es is null;

-- top_elev
update i18n.dbdialog set lb_es_es = 'Elev. máx.' where source = 'top_elev' and lb_ca_es is null;
update i18n.dbdialog set tt_es_es = 'top_elev - Elevación màxima' where source = 'top_elev' and tt_es_es is null;

-- function_type
update i18n.dbdialog set lb_es_es = 'Topo func.' where source = 'function_type' and lb_ca_es is null;
update i18n.dbdialog set tt_es_es = 'function_type - Tipo de función' where source = 'function_type' and tt_es_es is null;

-- label_rotation
update i18n.dbdialog set lb_es_es = 'Etiqueta rot.' where source = 'label_rotation' and lb_ca_es is null;
update i18n.dbdialog set tt_es_es = 'label_rotation - Etiqueta de rotación' where source = 'function_type' and tt_es_es is null;

-- ownercat_id
update i18n.dbdialog set lb_es_es = 'ownercat_id' where source = 'ownercat_id' and lb_ca_es is null;
update i18n.dbdialog set tt_es_es = 'ownercat_id - Identificador del catálogo del propietario' where source = 'ownercat_id' and tt_es_es is null;

-- elev
update i18n.dbdialog set lb_es_es = 'Elevación' where source = 'elev' and lb_ca_es is null;
update i18n.dbdialog set tt_es_es = 'elev - Elevación' where source = 'elev' and tt_es_es is null;

-- num_value
update i18n.dbdialog set lb_es_es = 'Valor num.' where source = 'num_value' and lb_ca_es is null;
update i18n.dbdialog set tt_es_es = 'num_value - Valor numérico' where source = 'num_value' and tt_es_es is null;

-- connec_id
update i18n.dbdialog set lb_es_es = 'Topo func.' where source = 'connec_id' and lb_ca_es is null;
update i18n.dbdialog set tt_es_es = 'connec_id - Tipo de función' where source = 'connec_id' and tt_es_es is null;

-- lastupdate
update i18n.dbdialog set lb_es_es = 'lastupdate' where source = 'lastupdate' and lb_ca_es is null;
update i18n.dbdialog set tt_es_es = 'lastupdate - Última actulización' where source = 'lastupdate' and tt_es_es is null;

-- demand
update i18n.dbdialog set lb_es_es = 'Topo func.' where source = 'demand' and lb_ca_es is null;
update i18n.dbdialog set tt_es_es = 'demand - Tipo de función' where source = 'demand' and tt_es_es is null;

-- flap
update i18n.dbdialog set lb_es_es = 'lastupdate' where source = 'flap' and lb_ca_es is null;
update i18n.dbdialog set tt_es_es = 'flap - Última actulización' where source = 'flap' and tt_es_es is null;

-- epa_type
update i18n.dbdialog set lb_es_es = '"lastupd. user"' where source = '"epa_type"' and lb_ca_es is null;
update i18n.dbdialog set tt_es_es = '"epa_type" - Usuario de la útima actualización' where source = '"epa_type"' and tt_es_es is null;

-- custom_elev1
update i18n.dbdialog set lb_es_es = 'lastupdate' where source = 'custom_elev1' and lb_ca_es is null;
update i18n.dbdialog set tt_es_es = 'custom_elev1 - Última actulización' where source = 'custom_elev1' and tt_es_es is null;

-- geom2
update i18n.dbdialog set lb_es_es = 'lastupdate' where source = 'geom2' and lb_ca_es is null;
update i18n.dbdialog set tt_es_es = 'geom2 - Última actulización' where source = 'geom2' and tt_es_es is null;

-- cost
update i18n.dbdialog set lb_es_es = 'Valor' where source = 'cost' and lb_ca_es is null;
update i18n.dbdialog set tt_es_es = 'cost - Valor' where source = 'cost' and tt_es_es is null;

-- offset
update i18n.dbdialog set lb_es_es = 'Distancia' where source = 'offset' and lb_ca_es is null;
update i18n.dbdialog set tt_es_es = 'offset - Compensar' where source = 'offset' and tt_es_es is null;

-- dnom
update i18n.dbdialog set lb_es_es = 'dnom' where source = 'dnom' and lb_ca_es is null;
update i18n.dbdialog set tt_es_es = 'dnom - Última actulización' where source = 'dnom' and tt_es_es is null;

-- cost_unit
update i18n.dbdialog set lb_es_es = 'Unidades' where source = 'cost_unit' and lb_ca_es is null;
update i18n.dbdialog set tt_es_es = 'cost_unit - Unidades del coste' where source = 'cost_unit' and tt_es_es is null;

-- demand
update i18n.dbdialog set lb_es_es = 'Demand' where source = 'demand' and lb_ca_es is null;
update i18n.dbdialog set tt_es_es = 'demand - Demanda de consumo' where source = 'demand' and tt_es_es is null;


/* to develop

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
*/