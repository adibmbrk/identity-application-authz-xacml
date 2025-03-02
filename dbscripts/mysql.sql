CREATE TABLE IF NOT EXISTS IDN_XACML_CONFIG (
    CONFIG_KEY VARCHAR(255) NOT NULL,
    CONFIG_VALUE VARCHAR(255) NOT NULL,
    TENANT_ID INTEGER NOT NULL,
    PRIMARY KEY (TENANT_ID, CONFIG_KEY)
) DEFAULT CHARACTER SET latin1 ENGINE INNODB;

CREATE TABLE IF NOT EXISTS IDN_XACML_POLICY (
    POLICY_ID VARCHAR(255) NOT NULL,
    VERSION INTEGER NOT NULL,
    IS_IN_PAP BOOLEAN NOT NULL DEFAULT TRUE,
    IS_IN_PDP BOOLEAN NOT NULL DEFAULT FALSE,
    POLICY MEDIUMTEXT NOT NULL,
    IS_ACTIVE BOOLEAN NOT NULL DEFAULT FALSE,
    POLICY_TYPE VARCHAR(255) NOT NULL,
    POLICY_EDITOR VARCHAR(255),
    POLICY_ORDER INTEGER NOT NULL,
    LAST_MODIFIED_TIME TIMESTAMP NOT NULL,
    LAST_MODIFIED_USER VARCHAR(255),
    TENANT_ID INTEGER NOT NULL,
    PRIMARY KEY (POLICY_ID, VERSION, TENANT_ID),
    CONSTRAINT IDN_XACML_POLICY_KEY_CONSTRAINT UNIQUE (POLICY_ID, VERSION, TENANT_ID)
) DEFAULT CHARACTER SET latin1 ENGINE INNODB;

CREATE TABLE IF NOT EXISTS IDN_XACML_POLICY_ATTRIBUTE (
    ID INTEGER NOT NULL AUTO_INCREMENT,
    ATTRIBUTE_ID VARCHAR(255) NOT NULL,
    ATTRIBUTE_VALUE VARCHAR(255) NOT NULL,
    DATA_TYPE VARCHAR(255) NOT NULL,
    CATEGORY VARCHAR(255) NOT NULL,
    POLICY_ID VARCHAR(255) NOT NULL,
    VERSION INTEGER NOT NULL,
    TENANT_ID INTEGER NOT NULL,
    PRIMARY KEY (ID),
    FOREIGN KEY (POLICY_ID, VERSION, TENANT_ID) REFERENCES IDN_XACML_POLICY (POLICY_ID, VERSION, TENANT_ID) ON DELETE CASCADE
) DEFAULT CHARACTER SET latin1 ENGINE INNODB;

CREATE TABLE IF NOT EXISTS IDN_XACML_POLICY_EDITOR_DATA (
    ID INTEGER NOT NULL AUTO_INCREMENT,
    DATA VARCHAR(500),
    DATA_ORDER INTEGER NOT NULL,
    POLICY_ID VARCHAR(255) NOT NULL,
    VERSION INTEGER NOT NULL,
    TENANT_ID INTEGER NOT NULL,
    PRIMARY KEY (ID),
    FOREIGN KEY (POLICY_ID, VERSION, TENANT_ID) REFERENCES IDN_XACML_POLICY (POLICY_ID, VERSION, TENANT_ID) ON DELETE CASCADE
) DEFAULT CHARACTER SET latin1 ENGINE INNODB;

CREATE TABLE IF NOT EXISTS IDN_XACML_POLICY_REFERENCE (
    REFERENCE VARCHAR(255) NOT NULL,
    POLICY_ID VARCHAR(255) NOT NULL,
    VERSION INTEGER NOT NULL,
    TENANT_ID INTEGER NOT NULL,
    PRIMARY KEY (REFERENCE, POLICY_ID, VERSION, TENANT_ID),
    FOREIGN KEY (POLICY_ID, VERSION, TENANT_ID) REFERENCES IDN_XACML_POLICY (POLICY_ID, VERSION, TENANT_ID) ON DELETE CASCADE
) DEFAULT CHARACTER SET latin1 ENGINE INNODB;

CREATE TABLE IF NOT EXISTS IDN_XACML_POLICY_SET_REFERENCE (
    SET_REFERENCE VARCHAR(255) NOT NULL,
    POLICY_ID VARCHAR(255) NOT NULL,
    VERSION INTEGER NOT NULL,
    TENANT_ID INTEGER NOT NULL,
    PRIMARY KEY (SET_REFERENCE, POLICY_ID, VERSION, TENANT_ID),
    FOREIGN KEY (POLICY_ID, VERSION, TENANT_ID) REFERENCES IDN_XACML_POLICY (POLICY_ID, VERSION, TENANT_ID) ON DELETE CASCADE
) DEFAULT CHARACTER SET latin1 ENGINE INNODB;

CREATE TABLE IF NOT EXISTS IDN_XACML_SUBSCRIBER (
    SUBSCRIBER_ID VARCHAR(255) NOT NULL,
    ENTITLEMENT_MODULE_NAME VARCHAR(255) NOT NULL,
    TENANT_ID INTEGER NOT NULL,
    PRIMARY KEY (SUBSCRIBER_ID, TENANT_ID),
    CONSTRAINT IDN_XACML_SUBSCRIBER_KEY_CONSTRAINT UNIQUE (SUBSCRIBER_ID, TENANT_ID)
) DEFAULT CHARACTER SET latin1 ENGINE INNODB;

CREATE TABLE IF NOT EXISTS IDN_XACML_SUBSCRIBER_PROPERTY (
    PROPERTY_ID VARCHAR(255) NOT NULL,
    DISPLAY_NAME VARCHAR(255) NOT NULL,
    PROPERTY_VALUE VARCHAR(2000) NOT NULL,
    IS_REQUIRED BOOLEAN NOT NULL DEFAULT FALSE,
    DISPLAY_ORDER INTEGER NOT NULL,
    IS_SECRET BOOLEAN NOT NULL DEFAULT FALSE,
    PROPERTY_MODULE VARCHAR(255),
    SUBSCRIBER_ID VARCHAR(255) NOT NULL,
    TENANT_ID INTEGER NOT NULL,
    PRIMARY KEY (PROPERTY_ID, SUBSCRIBER_ID, TENANT_ID),
    FOREIGN KEY (SUBSCRIBER_ID, TENANT_ID) REFERENCES IDN_XACML_SUBSCRIBER (SUBSCRIBER_ID, TENANT_ID) ON DELETE CASCADE
) DEFAULT CHARACTER SET latin1 ENGINE INNODB;

CREATE TABLE IF NOT EXISTS IDN_XACML_SUBSCRIBER_STATUS (
    ID INTEGER NOT NULL AUTO_INCREMENT,
    TYPE VARCHAR(255) NOT NULL,
    IS_SUCCESS BOOLEAN NOT NULL DEFAULT FALSE,
    USERNAME VARCHAR(255) NOT NULL,
    TARGET VARCHAR(255) NOT NULL,
    TARGET_ACTION VARCHAR(255) NOT NULL,
    LOGGED_AT TIMESTAMP NOT NULL,
    MESSAGE VARCHAR(255),
    SUBSCRIBER_ID VARCHAR(255) NOT NULL,
    TENANT_ID INTEGER NOT NULL,
    PRIMARY KEY (ID),
    FOREIGN KEY (SUBSCRIBER_ID, TENANT_ID) REFERENCES IDN_XACML_SUBSCRIBER (SUBSCRIBER_ID, TENANT_ID) ON DELETE CASCADE
) DEFAULT CHARACTER SET latin1 ENGINE INNODB;

CREATE TABLE IF NOT EXISTS IDN_XACML_POLICY_STATUS (
    ID INTEGER NOT NULL AUTO_INCREMENT,
    TYPE VARCHAR(255) NOT NULL,
    IS_SUCCESS BOOLEAN NOT NULL DEFAULT FALSE,
    USERNAME VARCHAR(255) NOT NULL,
    TARGET VARCHAR(255) NOT NULL,
    TARGET_ACTION VARCHAR(255) NOT NULL,
    LOGGED_AT TIMESTAMP NOT NULL,
    MESSAGE VARCHAR(255),
    POLICY_ID VARCHAR(255) NOT NULL,
    POLICY_VERSION INTEGER NOT NULL DEFAULT -1,
    TENANT_ID INTEGER NOT NULL,
    PRIMARY KEY (ID)
) DEFAULT CHARACTER SET latin1 ENGINE INNODB;

-- XACML --
CREATE INDEX IDX_POLICY_ATTRIBUTE ON IDN_XACML_POLICY_ATTRIBUTE (POLICY_ID, VERSION, TENANT_ID);
CREATE INDEX IDX_POLICY_EDITOR_DATA_FK ON IDN_XACML_POLICY_EDITOR_DATA (POLICY_ID, VERSION, TENANT_ID);
CREATE INDEX IDX_POLICY_REF ON IDN_XACML_POLICY_REFERENCE (POLICY_ID, VERSION, TENANT_ID);
CREATE INDEX IDX_POLICY_SET_REF ON IDN_XACML_POLICY_SET_REFERENCE (POLICY_ID, VERSION, TENANT_ID);
CREATE INDEX IDX_SUBSCRIBER_PROPERTY ON IDN_XACML_SUBSCRIBER_PROPERTY (SUBSCRIBER_ID, TENANT_ID);
CREATE INDEX IDX_XACML_SUBSCRIBER_STATUS ON IDN_XACML_SUBSCRIBER_STATUS (SUBSCRIBER_ID, TENANT_ID);
CREATE INDEX IDX_XACML_POLICY_STATUS ON IDN_XACML_POLICY_STATUS (POLICY_ID, POLICY_VERSION, TENANT_ID);
