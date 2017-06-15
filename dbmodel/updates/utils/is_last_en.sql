


-- ----------------------------
-- STATE TOPOLOGYC COHERENCE
-- ----------------------------

-- CATALOG OF ERRORS
INSERT INTO audit_cat_error VALUES ('205', 'Is not possible to update the state of the node. There are one or more arcs with state incompatible', 'Review your data', '2', 't', null);
INSERT INTO audit_cat_error VALUES ('210', 'One or more arcs was not inserted because it has not start/end node perharps due the diferent state of its', 'Review state of nodes or/and tolerence of arc searching nodes', '2', 't', null);
INSERT INTO audit_cat_error VALUES ('215', 'Is not possible to update the state of the arc. Nodes initial or end have incompatible state', 'Review your data', '2', 't', null);
