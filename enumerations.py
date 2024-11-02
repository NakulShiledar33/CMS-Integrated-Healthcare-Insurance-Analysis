import psycopg2.extras
import constants


class Enum:
    """
    Enumeration Class

    This class would load enum table into memory.
    It contains two formats for each table:
    1. xxx_type: Value to ID Map
    2. xxx_type_rev: ID to Value Map
    """

    # Table - <market_coverage_type>
    mark_cov_type = dict()
    mark_cov_type_rev = dict()

    # Table - <plan_type>
    plan_type = dict()
    plan_type_rev = dict()

    # Table - <qhp_type>
    qhp_type = dict()
    qhp_type_rev = dict()

    # Table - <child_only_offering_type>
    child_only_type = dict()
    child_only_type_rev = dict()

    # Table - <medical_metal_level_type>
    m_metal_type = dict()
    m_metal_type_rev = dict()

    # Table - <dental_metal_level_type>
    d_metal_type = dict()
    d_metal_type_rev = dict()

    # Table - <family_type>
    family_type = dict()
    family_type_rev = dict()

    # Table - <copay_type>
    copay_type = dict()
    copay_type_rev = dict()

    # Table - <coin_type>
    coins_type = dict()
    coins_type_rev = dict()

    # Table - <design_type>
    design_type = dict()
    design_type_rev = dict()

    # Table - <rate_rule_type>
    rate_rule_type = dict()
    rate_rule_type_rev = dict()

    # Table - <age_rule_type>
    age_rule_type = dict()
    age_rule_type_rev = dict()

    # Table - <cohabit_type>
    cohabit_type = dict()
    cohabit_type_rev = dict()

    @classmethod
    def init(cls, hostname, dbname, user, password):
        conn = psycopg2.connect("host=%s dbname=%s user=%s password=%s" % (hostname, dbname, user, password))
        cursor = conn.cursor(cursor_factory=psycopg2.extras.DictCursor)

        # Read Enumeration Table into memory
        cls.load_type_table(cursor, cls.plan_type, cls.plan_type_rev, constants.TABLE_PLAN_TYPE)
        cls.load_type_table(cursor, cls.mark_cov_type, cls.mark_cov_type_rev, constants.TABLE_MARK_COV_TYPE)
        cls.load_type_table(cursor, cls.qhp_type, cls.qhp_type_rev, constants.QHP_TYPE)
        cls.load_type_table(cursor, cls.child_only_type, cls.child_only_type_rev, constants.TABLE_CHILD_ONLY_TYPE)
        cls.load_type_table(cursor, cls.m_metal_type, cls.m_metal_type_rev, constants.TABLE_M_METAL_TYPE)
        cls.load_type_table(cursor, cls.d_metal_type, cls.d_metal_type_rev, constants.TABLE_D_METAL_TYPE)
        cls.load_type_table(cursor, cls.family_type, cls.family_type_rev, constants.TABLE_FAMILY_TYPE)
        cls.load_type_table(cursor, cls.copay_type, cls.copay_type_rev, constants.TABLE_COPAY_TYPE)
        cls.load_type_table(cursor, cls.coins_type, cls.coins_type_rev, constants.TABLE_COINS_TYPE)
        cls.load_type_table(cursor, cls.design_type, cls.design_type_rev, constants.TABLE_DESIGN_TYPE)
        cls.load_type_table(cursor, cls.rate_rule_type, cls.rate_rule_type_rev, constants.TABLE_RATE_RULE_TYPE)
        cls.load_type_table(cursor, cls.age_rule_type, cls.age_rule_type_rev, constants.TABLE_AGE_RULE_TYPE)
        cls.load_type_table(cursor, cls.cohabit_type, cls.cohabit_type_rev, constants.TABLE_COHABIT_TYPE)

        conn.close()

    @staticmethod
    def load_type_table(cursor, obj, obj_rev, table_name):
        cursor.execute("SELECT * FROM %s" % (table_name,))
        records = cursor.fetchall()
        for record in records:
            obj[record['type_name']] = record['id']
            obj_rev[record['id']] = record['type_name']


# Init Enumeration Type
Enum.init(constants.HOST_NAME, constants.DB_NAME, constants.DB_USER, constants.DB_PASSWORD)