DROP DATABASE IF EXISTS insurance;
CREATE DATABASE insurance;

DROP USER IF EXISTS manager;
CREATE USER manager WITH PASSWORD '******';

GRANT ALL PRIVILEGES ON DATABASE insurance TO manager;

\connect insurance

/* -------------------------Enumeration Tables--------------------------- */

-- Individual
-- SHOP (Small Group)
CREATE TABLE market_coverage_type
(
    id        INT,
    type_name VARCHAR(31),
    primary key (id)
);

ALTER TABLE market_coverage_type
    OWNER TO manager;

-- Indemnity
-- PPO
-- HMO
-- POS
-- EPO
CREATE TABLE plan_type
(
    id        INT,
    type_name VARCHAR(15),
    primary key (id)
);

ALTER TABLE plan_type
    OWNER TO manager;

-- On the Exchange
-- Off the Exchange
-- Both
CREATE TABLE qhp_type
(
    id        INT,
    type_name VARCHAR(31),
    primary key (id)
);

ALTER TABLE qhp_type
    OWNER TO manager;


-- Allows Adult and Child-Only
-- Allows Adult-Only
-- Allows Child-Only
CREATE TABLE child_only_offering_type
(
    id        INT,
    type_name VARCHAR(31),
    primary key (id)
);

ALTER TABLE child_only_offering_type
    OWNER TO manager;


-- Platinum
-- Gold
-- Silver
-- Bronze
-- Expanded Bronze
-- Catastrophic
CREATE TABLE medical_metal_level_type
(
    id        INT,
    type_name VARCHAR(15),
    primary key (id)
);

ALTER TABLE medical_metal_level_type
    OWNER TO manager;

-- High
-- Low
CREATE TABLE dental_metal_level_type
(
    id        INT,
    type_name VARCHAR(7),
    primary key (id)
);

ALTER TABLE dental_metal_level_type
    OWNER TO manager;

-- Couple
-- PrimarySubscriberAndOneDependent
-- PrimarySubscriberAndTwoDependents
-- PrimarySubscriberAndThreeOrMoreDependents
-- CoupleAndOneDependent
-- CoupleAndTwoDependents
-- CoupleAndThreeOrMoreDependents
CREATE TABLE family_type
(
    id        INT,
    type_name VARCHAR(63),
    primary key (id)
);

ALTER TABLE family_type
    OWNER TO manager;

-- No Charge
-- No Charge after deductible
-- $X Copay
-- $X Copay after deductible
-- $X Copay before deductible
-- $X Copay with deductible
-- $X Copay per Day
-- $X Copay per Stay
-- $X Copay per Day after deductible
-- $X Copay per Stay after deductible
-- $X Copay per Day before deductible
-- $X Copay per Stay before deductible
-- $X Copay per Day with deductible
-- $X Copay per Stay with deductible
-- Not Applicable
CREATE TABLE copay_type
(
    id        INT,
    type_name VARCHAR(63),
    primary key (id)
);

ALTER TABLE copay_type
    OWNER TO manager;

-- No Charge
-- No Charge after deductible
-- X%
-- X% Coinsurance after deductible
-- Not Applicable
CREATE TABLE coins_type
(
    id        INT,
    type_name VARCHAR(63),
    primary key (id)
);

ALTER TABLE coins_type
    OWNER TO manager;

-- Design Type 1
-- Design Type 2
-- Design Type 3
-- Design Type 4
-- Design Type 5
-- Not Applicable
CREATE TABLE design_type
(
    id        INT,
    type_name VARCHAR(15),
    primary key (id)
);

ALTER TABLE design_type
    OWNER TO manager;

CREATE TABLE rate_rule_type
(
    id        INT,
    type_name VARCHAR(127),
    primary key (id)
);

ALTER TABLE rate_rule_type
    OWNER TO manager;

CREATE TABLE age_rule_type
(
    id        INT,
    type_name VARCHAR(127),
    primary key (id)
);

ALTER TABLE age_rule_type
    OWNER TO manager;

CREATE TABLE cohabit_type
(
    id        INT,
    type_name VARCHAR(31),
    primary key (id)
);

ALTER TABLE cohabit_type
    OWNER TO manager;

/* -------------------------Plan Attributes Data Set--------------------------- */
CREATE TABLE plans
(
    issuer_id                         CHAR(5),
    plan_id                           CHAR(17),
    plan_variant_name                 VARCHAR(255),
    std_component_id                  CHAR(14),
    plan_marketing_name               VARCHAR(255),
    year                              CHAR(4),
    state                             CHAR(2),
    source_name                       VARCHAR(15),
    import_date                       TIMESTAMP,
    hios_product_id                   CHAR(10),
    hpid                              CHAR(10),
    network_id                        CHAR(6),
    service_area_id                   CHAR(6),
    formulary_id                      CHAR(6),
    is_new_plan                       BOOLEAN,
    market_coverage                   INT REFERENCES market_coverage_type (id),
    plan_type                         INT REFERENCES plan_type (id),
    qhp_type                          INT REFERENCES qhp_type (id),
    design_type                       INT REFERENCES design_type (id),
    child_only_offering               INT REFERENCES child_only_offering_type (id),
    composite_rate_offered            BOOLEAN,
    out_of_country_coverage           BOOLEAN,
    out_of_country_coverage_desc      TEXT,
    out_of_service_area_coverage      BOOLEAN,
    out_of_service_area_coverage_desc TEXT,
    plan_level_exclusions             TEXT,
    effective_date                    DATE,
    expiration_date                   DATE,
    url_enrollment                    TEXT,
    url_formulary                     TEXT,
    url_plan_brochure                 TEXT,
    PRIMARY KEY (plan_id)
);

ALTER TABLE plans
    OWNER TO manager;

CREATE TABLE plan_multi_network
(
    plan_id                 CHAR(17) REFERENCES plans (plan_id),
    first_tier_utilization  DECIMAL(5, 2),
    second_tier_utilization DECIMAL(5, 2),
    PRIMARY KEY (plan_id)
);

ALTER TABLE plan_multi_network
    OWNER TO manager;

CREATE TABLE medical_plans
(
    plan_id                          CHAR(17) REFERENCES plans (plan_id),
    metal_level                      INT REFERENCES medical_metal_level_type (id),
    is_notice_required_for_pregnancy BOOLEAN,
    is_wellness_program_offered      BOOLEAN,
    unique_design                    BOOLEAN,
    ehb_percent_total_premium        DECIMAL,
    primary key (plan_id)
);

ALTER TABLE medical_plans
    OWNER TO manager;

CREATE TABLE medical_plan_referral
(
    plan_id             CHAR(17) REFERENCES medical_plans (plan_id),
    specialist_referral TEXT,
    PRIMARY KEY (plan_id)
);

ALTER TABLE medical_plan_referral
    OWNER TO manager;

CREATE TABLE medical_plan_sbc
(
    plan_id                            CHAR(17) REFERENCES medical_plans (plan_id),
    having_baby_deductible             INT,
    having_baby_copayment              INT,
    having_baby_coinsurance            INT,
    having_baby_limit                  INT,
    having_diabetes_deductible         INT,
    having_diabetes_copayment          INT,
    having_diabetes_coinsurance        INT,
    having_diabetes_limit              INT,
    having_simple_fracture_deductible  INT,
    having_simple_fracture_copayment   INT,
    having_simple_fracture_coinsurance INT,
    having_simple_fracture_limit       INT,
    PRIMARY KEY (plan_id)
);

ALTER TABLE medical_plan_sbc
    OWNER TO manager;

CREATE TABLE medical_plan_moop
(
    plan_id                                CHAR(17) REFERENCES medical_plans (plan_id),
    medical_inn_tier1_individual           INT,
    medical_inn_tier1_family_per_person    INT,
    medical_inn_tier1_family_per_group     INT,
    medical_inn_tier2_individual           INT,
    medical_inn_tier2_family_per_person    INT,
    medical_inn_tier2_family_per_group     INT,
    medical_oon_individual                 INT,
    medical_oon_family_per_person          INT,
    medical_oon_family_per_group           INT,
    medical_comb_inn_oon_individual        INT,
    medical_comb_inn_oon_family_per_person INT,
    medical_comb_inn_oon_family_per_group  INT,

    drug_inn_tier1_individual              INT,
    drug_inn_tier1_family_per_person       INT,
    drug_inn_tier1_family_per_group        INT,
    drug_inn_tier2_individual              INT,
    drug_inn_tier2_family_per_person       INT,
    drug_inn_tier2_family_per_group        INT,
    drug_oon_individual                    INT,
    drug_oon_family_per_person             INT,
    drug_oon_family_per_group              INT,
    drug_comb_inn_oon_individual           INT,
    drug_comb_inn_oon_family_per_person    INT,
    drug_comb_inn_oon_family_per_group     INT,
    PRIMARY KEY (plan_id)
);

ALTER TABLE medical_plan_moop
    OWNER TO manager;

CREATE TABLE medical_plan_moop_integrated
(
    plan_id                              CHAR(17) REFERENCES medical_plans (plan_id),
    total_inn_tier1_individual           INT,
    total_inn_tier1_family_per_person    INT,
    total_inn_tier1_family_per_group     INT,
    total_inn_tier2_individual           INT,
    total_inn_tier2_family_per_person    INT,
    total_inn_tier2_family_per_group     INT,
    total_oon_individual                 INT,
    total_oon_family_per_person          INT,
    total_oon_family_per_group           INT,
    total_comb_inn_oon_individual        INT,
    total_comb_inn_oon_family_per_person INT,
    total_comb_inn_oon_family_per_group  INT,
    PRIMARY KEY (plan_id)
);

ALTER TABLE medical_plan_moop_integrated
    OWNER TO manager;

CREATE TABLE medical_plan_ded
(
    plan_id                                CHAR(17) REFERENCES medical_plans (plan_id),
    medical_inn_tier1_individual           INT,
    medical_inn_tier1_family_per_person    INT,
    medical_inn_tier1_family_per_group     INT,
    medical_inn_tier1_coinsurance          INT,
    medical_inn_tier2_individual           INT,
    medical_inn_tier2_family_per_person    INT,
    medical_inn_tier2_family_per_group     INT,
    medical_inn_tier2_coinsurance          INT,
    medical_oon_individual                 INT,
    medical_oon_family_per_person          INT,
    medical_oon_family_per_group           INT,
    medical_comb_inn_oon_individual        INT,
    medical_comb_inn_oon_family_per_person INT,
    medical_comb_inn_oon_family_per_group  INT,

    drug_inn_tier1_individual              INT,
    drug_inn_tier1_family_per_person       INT,
    drug_inn_tier1_family_per_group        INT,
    drug_inn_tier1_coinsurance             INT,
    drug_inn_tier2_individual              INT,
    drug_inn_tier2_family_per_person       INT,
    drug_inn_tier2_family_per_group        INT,
    drug_inn_tier2_coinsurance             INT,
    drug_oon_individual                    INT,
    drug_oon_family_per_person             INT,
    drug_oon_family_per_group              INT,
    drug_comb_inn_oon_individual           INT,
    drug_comb_inn_oon_family_per_person    INT,
    drug_comb_inn_oon_family_per_group     INT,
    PRIMARY KEY (plan_id)
);

ALTER TABLE medical_plan_ded
    OWNER TO manager;

CREATE TABLE medical_plan_ded_integrated
(
    plan_id                              CHAR(17) REFERENCES medical_plans (plan_id),
    total_inn_tier1_individual           INT,
    total_inn_tier1_family_per_person    INT,
    total_inn_tier1_family_per_group     INT,
    total_inn_tier1_coinsurance          INT,
    total_inn_tier2_individual           INT,
    total_inn_tier2_family_per_person    INT,
    total_inn_tier2_family_per_group     INT,
    total_inn_tier2_coinsurance          INT,
    total_oon_individual                 INT,
    total_oon_family_per_person          INT,
    total_oon_family_per_group           INT,
    total_comb_inn_oon_individual        INT,
    total_comb_inn_oon_family_per_person INT,
    total_comb_inn_oon_family_per_group  INT,
    PRIMARY KEY (plan_id)
);

ALTER TABLE medical_plan_ded_integrated
    OWNER TO manager;

CREATE TABLE dental_plans
(
    plan_id                                CHAR(17) REFERENCES plans (plan_id),
    metal_level                            INT REFERENCES dental_metal_level_type (id),
    ehb_pediatric_dental_apportionment_qty DECIMAL,
    is_guaranteed_rate                     BOOLEAN,
    PRIMARY KEY (plan_id)
);

ALTER TABLE dental_plans
    OWNER TO manager;

CREATE TABLE dental_plan_moop
(
    plan_id                        CHAR(17) REFERENCES dental_plans (plan_id),
    inn_tier1_individual           INT,
    inn_tier1_family_per_person    INT,
    inn_tier1_family_per_group     INT,
    inn_tier2_individual           INT,
    inn_tier2_family_per_person    INT,
    inn_tier2_family_per_group     INT,
    oon_individual                 INT,
    oon_family_per_person          INT,
    oon_family_per_group           INT,
    comb_inn_oon_individual        INT,
    comb_inn_oon_family_per_person INT,
    comb_inn_oon_family_per_group  INT,
    PRIMARY KEY (plan_id)
);

ALTER TABLE dental_plan_moop
    OWNER TO manager;

CREATE TABLE dental_plan_ded
(
    plan_id                        CHAR(17) REFERENCES dental_plans (plan_id),
    inn_tier1_individual           INT,
    inn_tier1_family_per_person    INT,
    inn_tier1_family_per_group     INT,
    inn_tier2_individual           INT,
    inn_tier2_family_per_person    INT,
    inn_tier2_family_per_group     INT,
    oon_individual                 INT,
    oon_family_per_person          INT,
    oon_family_per_group           INT,
    comb_inn_oon_individual        INT,
    comb_inn_oon_family_per_person INT,
    comb_inn_oon_family_per_group  INT,
    PRIMARY KEY (plan_id)
);

ALTER TABLE dental_plan_ded
    OWNER TO manager;

/* -------------------------Benefits Data Set--------------------------- */

CREATE TABLE plan_benefit
(
    plan_id               CHAR(17) REFERENCES plans (plan_id),
    benefit_name          VARCHAR(127),
    copay_inn_tier1       DECIMAL,
    copay_inn_tier1_type  INT REFERENCES copay_type (id),
    copay_inn_tier2       DECIMAL,
    copay_inn_tier2_type  INT REFERENCES copay_type (id),
    copay_oon             DECIMAL,
    copay_oon_type        INT REFERENCES copay_type (id),
    coins_inn_tier1       DECIMAL(5, 2),
    coins_inn_tier1_type  INT REFERENCES coins_type (id),
    coins_inn_tier2       DECIMAL(5, 2),
    coins_inn_tier2_type  INT REFERENCES coins_type (id),
    coins_oon             DECIMAL(5, 2),
    coins_oon_type        INT REFERENCES coins_type (id),
    is_ehb                BOOLEAN,
    is_excl_from_inn_moop BOOLEAN,
    is_excl_from_oon_moop BOOLEAN,
    exclusions            TEXT,
    PRIMARY KEY (plan_id, benefit_name)
);

ALTER TABLE plan_benefit
    OWNER TO manager;

CREATE TABLE plan_benefit_limitation
(
    plan_id      CHAR(17),
    benefit_name VARCHAR(127),
    limit_qty    INT,
    limit_unit   VARCHAR(127),
    explanation  TEXT,
    PRIMARY KEY (plan_id, benefit_name),
    FOREIGN KEY (plan_id, benefit_name) REFERENCES plan_benefit (plan_id, benefit_name)
);

ALTER TABLE plan_benefit_limitation
    OWNER TO manager;


/* -------------------------Rate Data Set--------------------------- */

CREATE TABLE rate_individual
(
    effective_date          DATE,
    expiration_date         DATE,
    std_component_id        CHAR(14),
    rating_area_id          INT,
    tobacco                 BOOLEAN,
    age_range_from          INT,
    age_range_to            INT,
    individual_rate         DECIMAL(6, 2),
    individual_tobacco_rate DECIMAL(6, 2),
    PRIMARY KEY (effective_date, expiration_date, std_component_id, rating_area_id, age_range_from, age_range_to)
);

ALTER TABLE rate_individual OWNER TO manager;

CREATE TABLE rate_family
(
    effective_date   DATE,
    expiration_date  DATE,
    std_component_id CHAR(14),
    rating_area_id   INT,
    individual       NUMERIC(6, 2),
    family_type      INT,
    family_rate      NUMERIC(6, 2),
    PRIMARY KEY (effective_date, expiration_date, std_component_id, rating_area_id, family_type)
);

ALTER TABLE rate_family
    OWNER TO manager;

/* -------------------------Business Rule Data Set--------------------------- */
CREATE TABLE business_rules
(
    std_component_id             CHAR(14),
    product_id                   CHAR(10),
    rate_determination_rule_type INT REFERENCES rate_rule_type (id),
    single_parent_max_dependent  VARCHAR(15),
    two_parents_max_dependent    VARCHAR(15),
    dependent_max_age            INT,
    children_only_max_children   VARCHAR(15),
    domestic_partner_as_spouse   BOOLEAN,
    same_sex_partner_as_spouse   BOOLEAN,
    age_determination_rule       INT REFERENCES age_rule_type (id),
    min_tobacco_free_months      INT,
    PRIMARY KEY (std_component_id)
);

ALTER TABLE business_rules
    OWNER TO manager;

CREATE TABLE business_rules_cohabitation
(
    std_component_id CHAR(14),
    cohabit_type     INT REFERENCES cohabit_type (id),
    cohabit_required BOOLEAN
);

ALTER TABLE business_rules_cohabitation
    OWNER TO manager;

/* -------------------------Enumeration Initialization--------------------------- */

INSERT INTO market_coverage_type
VALUES (1, 'Individual');
INSERT INTO market_coverage_type
VALUES (2, 'SHOP (Small Group)');

INSERT INTO plan_type
VALUES (1, 'Indemnity');
INSERT INTO plan_type
VALUES (2, 'PPO');
INSERT INTO plan_type
VALUES (3, 'HMO');
INSERT INTO plan_type
VALUES (4, 'POS');
INSERT INTO plan_type
VALUES (5, 'EPO');

INSERT INTO qhp_type
VALUES (1, 'On the Exchange');
INSERT INTO qhp_type
VALUES (2, 'Off the Exchange');
INSERT INTO qhp_type
VALUES (3, 'Both');

INSERT INTO child_only_offering_type
VALUES (1, 'Allows Adult and Child-Only');
INSERT INTO child_only_offering_type
VALUES (2, 'Allows Adult-Only');
INSERT INTO child_only_offering_type
VALUES (3, 'Allows Child-Only');

INSERT INTO medical_metal_level_type
VALUES (1, 'Platinum');
INSERT INTO medical_metal_level_type
VALUES (2, 'Gold');
INSERT INTO medical_metal_level_type
VALUES (3, 'Silver');
INSERT INTO medical_metal_level_type
VALUES (4, 'Bronze');
INSERT INTO medical_metal_level_type
VALUES (5, 'Expanded Bronze');
INSERT INTO medical_metal_level_type
VALUES (6, 'Catastrophic');

INSERT INTO dental_metal_level_type
VALUES (1, 'High');
INSERT INTO dental_metal_level_type
VALUES (2, 'Low');

INSERT INTO family_type
VALUES (1, 'Couple');
INSERT INTO family_type
VALUES (2, 'PrimarySubscriberAndOneDependent');
INSERT INTO family_type
VALUES (3, 'PrimarySubscriberAndTwoDependents');
INSERT INTO family_type
VALUES (4, 'PrimarySubscriberAndThreeOrMoreDependents');
INSERT INTO family_type
VALUES (5, 'CoupleAndOneDependent');
INSERT INTO family_type
VALUES (6, 'CoupleAndTwoDependents');
INSERT INTO family_type
VALUES (7, 'CoupleAndThreeOrMoreDependents');

INSERT INTO copay_type
VALUES (1, 'No Charge');
INSERT INTO copay_type
VALUES (2, 'No Charge after deductible');
INSERT INTO copay_type
VALUES (3, 'Copay');
INSERT INTO copay_type
VALUES (4, 'Copay after deductible');
INSERT INTO copay_type
VALUES (5, 'Copay before deductible');
INSERT INTO copay_type
VALUES (6, 'Copay with deductible');
INSERT INTO copay_type
VALUES (7, 'Copay per Day');
INSERT INTO copay_type
VALUES (8, 'Copay per Stay');
INSERT INTO copay_type
VALUES (9, 'Copay per Day after deductible');
INSERT INTO copay_type
VALUES (10, 'Copay per Stay after deductible');
INSERT INTO copay_type
VALUES (11, 'Copay per Day before deductible');
INSERT INTO copay_type
VALUES (12, 'Copay per Stay before deductible');
INSERT INTO copay_type
VALUES (13, 'Copay per Day with deductible');
INSERT INTO copay_type
VALUES (14, 'Copay per Stay with deductible');
INSERT INTO copay_type
VALUES (15, 'Not Applicable');

INSERT INTO coins_type
VALUES (1, 'No Charge');
INSERT INTO coins_type
VALUES (2, 'No Charge after deductible');
INSERT INTO coins_type
VALUES (3, 'Coinsurance');
INSERT INTO coins_type
VALUES (4, 'Coinsurance after deductible');
INSERT INTO coins_type
VALUES (5, 'Not Applicable');

INSERT INTO design_type
VALUES (1, 'Design Type 1');
INSERT INTO design_type
VALUES (2, 'Design Type 2');
INSERT INTO design_type
VALUES (3, 'Design Type 3');
INSERT INTO design_type
VALUES (4, 'Design Type 4');
INSERT INTO design_type
VALUES (5, 'Design Type 5');
INSERT INTO design_type
VALUES (6, 'Not Applicable');

INSERT INTO rate_rule_type
VALUES (1, 'A different rate (specifically for parties of two or more)for each enrollee is added together');
INSERT INTO rate_rule_type
VALUES (2, 'There are rates specifically for couples and for families (not just addition of individual rates)');

INSERT INTO age_rule_type
VALUES (1, 'Age on effective date');
INSERT INTO age_rule_type
VALUES (2, 'Age on insurance date (age on birthday nearest the effective date)');
INSERT INTO age_rule_type
VALUES (3, 'Age on January 1st of the effective date year');

INSERT INTO cohabit_type
VALUES (1, 'Spouse');
INSERT INTO cohabit_type
VALUES (2, 'Father or Mother');
INSERT INTO cohabit_type
VALUES (3, 'Grandfather or Grandmother');
INSERT INTO cohabit_type
VALUES (4, 'Grandson or Granddaughter');
INSERT INTO cohabit_type
VALUES (5, 'Uncle or Aunt');
INSERT INTO cohabit_type
VALUES (6, 'Nephew or Niece');
INSERT INTO cohabit_type
VALUES (7, 'Cousin');
INSERT INTO cohabit_type
VALUES (8, 'Adopted Child');
INSERT INTO cohabit_type
VALUES (9, 'Foster Child');
INSERT INTO cohabit_type
VALUES (10, 'Son-in-Law or Daughter-in-Law');
INSERT INTO cohabit_type
VALUES (11, 'Brother-in-Law or Sister-in-Law');
INSERT INTO cohabit_type
VALUES (12, 'Mother-in-Law or Father-in Law');
INSERT INTO cohabit_type
VALUES (13, 'Brother or Sister');
INSERT INTO cohabit_type
VALUES (14, 'Ward');
INSERT INTO cohabit_type
VALUES (15, 'Stepparent');
INSERT INTO cohabit_type
VALUES (16, 'Stepson or Stepdaughter');
INSERT INTO cohabit_type
VALUES (17, 'Self');
INSERT INTO cohabit_type
VALUES (18, 'Child');
INSERT INTO cohabit_type
VALUES (19, 'Sponsored Dependent');
INSERT INTO cohabit_type
VALUES (20, 'Dependent on a Minor Dependent');
INSERT INTO cohabit_type
VALUES (21, 'Ex-Spouse');
INSERT INTO cohabit_type
VALUES (22, 'Guardian');
INSERT INTO cohabit_type
VALUES (23, 'Court Appointed Guardian');
INSERT INTO cohabit_type
VALUES (24, 'Collateral Dependent');
INSERT INTO cohabit_type
VALUES (25, 'Life Partner');
INSERT INTO cohabit_type
VALUES (26, 'Annultant');
INSERT INTO cohabit_type
VALUES (27, 'Trustee');
INSERT INTO cohabit_type
VALUES (28, 'Other Relationship');
INSERT INTO cohabit_type
VALUES (29, 'Other Relative');