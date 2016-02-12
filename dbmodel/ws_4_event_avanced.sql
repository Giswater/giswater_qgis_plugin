-- EVENT VINCULAT A TAULES DERIVADES




-- ----------------------------
-- Table structure for event_value_coverstate
-- ----------------------------
CREATE TABLE "SCHEMA_NAME"."event_value_coverstate" (
"id" varchar(16) COLLATE "default" NOT NULL,
"custom_id" varchar(16) COLLATE "default" NOT NULL,
CONSTRAINT event_value_coverstate_pkey PRIMARY KEY (id)
)
WITH (OIDS=FALSE)
;



-- ----------------------------
-- Table structure for event_value_sediment
-- ----------------------------
CREATE TABLE "SCHEMA_NAME"."event_value_sediment" (
"id" varchar(16) COLLATE "default" NOT NULL,
"custom_id" varchar(16) COLLATE "default" NOT NULL,
CONSTRAINT event_value_sediment_pkey PRIMARY KEY (id)
)
WITH (OIDS=FALSE)
;


-- ----------------------------
-- Table structure for event_value_state
-- ----------------------------
CREATE TABLE "SCHEMA_NAME"."event_value_state" (
"id" varchar(16) COLLATE "default" NOT NULL,
"custom_id" varchar(16) COLLATE "default" NOT NULL,
CONSTRAINT event_value_state_pkey PRIMARY KEY (id)
)
WITH (OIDS=FALSE)
;