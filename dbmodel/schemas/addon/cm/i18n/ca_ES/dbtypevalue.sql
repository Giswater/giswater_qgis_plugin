/*
This file is part of Giswater
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
*/


SET search_path = cm, public, public;
UPDATE sys_typevalue AS t SET idval = v.idval, descript = v.descript FROM (
	VALUES
	('1', 'campaign_feature_status', 'PLANIFICAT', NULL),
    ('2', 'campaign_feature_status', 'NO VISITAT', NULL),
    ('3', 'campaign_feature_status', 'VISITAT', NULL),
    ('4', 'campaign_feature_status', 'TORNAR A VISITAR', NULL),
    ('5', 'campaign_feature_status', 'ACCEPTAT', NULL),
    ('6', 'campaign_feature_status', 'CANCELAT', NULL),
    ('1', 'campaign_status', 'PLANIFICACIÓ', NULL),
    ('10', 'campaign_status', 'CANCELAT', NULL),
    ('2', 'campaign_status', 'PLANIFICAT', NULL),
    ('3', 'campaign_status', 'ASIGNAT', NULL),
    ('4', 'campaign_status', 'EN MARCHA', NULL),
    ('5', 'campaign_status', 'STAND-BY', NULL),
    ('6', 'campaign_status', 'EXECUTAT', NULL),
    ('7', 'campaign_status', 'REBUTAT', NULL),
    ('8', 'campaign_status', 'LLES PER A ACCEPTAR', NULL),
    ('9', 'campaign_status', 'ACCEPTAT', NULL),
    ('1', 'campaign_type', 'REVISIÓ', NULL),
    ('2', 'campaign_type', 'VISITA', NULL),
    ('3', 'campaign_type', 'INVENTARI', NULL),
    ('lyt_buttons', 'layout_name_typevalue', 'botons_lyt', NULL),
    ('1', 'lot_feature_status', 'PLANIFICAT', NULL),
    ('2', 'lot_feature_status', 'NO VISITAT', NULL),
    ('3', 'lot_feature_status', 'VISITAT', NULL),
    ('4', 'lot_feature_status', 'TORNAR A VISITAR', NULL),
    ('5', 'lot_feature_status', 'ACCEPTAT', NULL),
    ('6', 'lot_feature_status', 'CANCELAT', NULL),
    ('1', 'lot_status', 'PLANIFICACIÓ', NULL),
    ('10', 'lot_status', 'CANCELAT', NULL),
    ('2', 'lot_status', 'PLANIFICAT', NULL),
    ('3', 'lot_status', 'ASIGNAT', NULL),
    ('4', 'lot_status', 'EN MARCHA', NULL),
    ('5', 'lot_status', 'STAND-BY', NULL),
    ('6', 'lot_status', 'EXECUTAT', NULL),
    ('7', 'lot_status', 'REBUTAT', NULL),
    ('8', 'lot_status', 'LLES PER A ACCEPTAR', NULL),
    ('9', 'lot_status', 'ACCEPTAT', NULL)
) AS v(id, typevalue, idval, descript)
WHERE t.id = v.id AND t.typevalue = v.typevalue;

