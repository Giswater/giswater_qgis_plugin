/*
This file is part of Giswater
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
*/


SET search_path = cm, public, public;
UPDATE sys_typevalue AS t SET idval = v.idval, descript = v.descript FROM (
	VALUES
	('1', 'campaign_feature_status', 'PLANIFICADO', NULL),
    ('2', 'campaign_feature_status', 'NO VISITADO', NULL),
    ('3', 'campaign_feature_status', 'VISITADO', NULL),
    ('4', 'campaign_feature_status', 'VUELVE A VISITAR', NULL),
    ('5', 'campaign_feature_status', 'ACEPTADO', NULL),
    ('6', 'campaign_feature_status', 'CANCELADO', NULL),
    ('1', 'campaign_status', 'PLANIFICACIÓN', NULL),
    ('10', 'campaign_status', 'CANCELADO', NULL),
    ('2', 'campaign_status', 'PLANIFICADO', NULL),
    ('3', 'campaign_status', 'ASIGNADO', NULL),
    ('4', 'campaign_status', 'EN MARCHA', NULL),
    ('5', 'campaign_status', 'STAND-BY', NULL),
    ('6', 'campaign_status', 'EJECUTADO (Fijar OPERATIVO y Guardar Traza)', NULL),
    ('7', 'campaign_status', 'RECHAZADO', NULL),
    ('8', 'campaign_status', 'LISTO PARA ACEPTAR', NULL),
    ('9', 'campaign_status', 'ACEPTADO', NULL),
    ('1', 'campaign_type', 'REVISIÓN', NULL),
    ('2', 'campaign_type', 'VISTA', NULL),
    ('3', 'campaign_type', 'INVENTARIO', NULL),
    ('lyt_buttons', 'layout_name_typevalue', 'lyt_buttons', NULL),
    ('1', 'lot_feature_status', 'PLANIFICADO', NULL),
    ('2', 'lot_feature_status', 'NO VISITADO', NULL),
    ('3', 'lot_feature_status', 'VISITADO', NULL),
    ('4', 'lot_feature_status', 'VUELVE A VISITAR', NULL),
    ('5', 'lot_feature_status', 'ACEPTADO', NULL),
    ('6', 'lot_feature_status', 'CANCELADO', NULL),
    ('1', 'lot_status', 'PLANIFICACIÓN', NULL),
    ('10', 'lot_status', 'CANCELADO', NULL),
    ('2', 'lot_status', 'PLANIFICADO', NULL),
    ('3', 'lot_status', 'ASIGNADO', NULL),
    ('4', 'lot_status', 'EN MARCHA', NULL),
    ('5', 'lot_status', 'STAND-BY', NULL),
    ('6', 'lot_status', 'EJECUTADO (Fijar OPERATIVO y Guardar Traza)', NULL),
    ('7', 'lot_status', 'RECHAZADO', NULL),
    ('8', 'lot_status', 'LISTO PARA ACEPTAR', NULL),
    ('9', 'lot_status', 'ACEPTADO', NULL)
) AS v(id, typevalue, idval, descript)
WHERE t.id = v.id AND t.typevalue = v.typevalue;

