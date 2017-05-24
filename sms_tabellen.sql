CREATE TABLE  "APX_ROLLEN" 
   (	"ID" NUMBER(10,0) NOT NULL ENABLE, 
	"SCHEMA" VARCHAR2(30), 
	"NAAM" VARCHAR2(100) NOT NULL ENABLE, 
	"OMSCHRIJVING" VARCHAR2(1000), 
	"SCHERM_IND" VARCHAR2(1)
   )
/
CREATE UNIQUE INDEX  "APX_ROL_UK1" ON  "APX_ROLLEN" ("NAAM", "SCHEMA")
/

CREATE UNIQUE INDEX  "IVV_ROL_PK" ON  "APX_ROLLEN" ("ID")
/

CREATE TABLE  "APX_SUBROLLEN" 
   (	"ID" NUMBER(*,10) NOT NULL ENABLE, 
	"HOOFDROL_ID" NUMBER(*,10) NOT NULL ENABLE, 
	"SUBROL_ID" NUMBER(*,10) NOT NULL ENABLE
   )
/

CREATE UNIQUE INDEX  "APX_SRL_PK" ON  "APX_SUBROLLEN" ("ID")
/

CREATE UNIQUE INDEX  "APX_SRL_UK1" ON  "APX_SUBROLLEN" ("SUBROL_ID", "HOOFDROL_ID")
/




CREATE TABLE SBN_MAATREGELEN
(
  MR_ID                NUMBER,
  HOOFDSTUK_NR         NUMBER                   NOT NULL,
  SECTIE_NR            NUMBER                   NOT NULL,
  PARAGRAAF_NR         NUMBER                   NOT NULL,
  MAATREGELTEKST       VARCHAR2(512 BYTE),
  BEI                  VARCHAR2(4 BYTE),
  VERANTWOORDELIJK     VARCHAR2(256 BYTE),
  MAATREGELCOMMENTAAR  VARCHAR2(512 BYTE),
  CRAMM                VARCHAR2(1 BYTE),
  NUMMER               NUMBER(2),
  KA                   VARCHAR2(1 BYTE),
  IAM                  VARCHAR2(1 BYTE)
)
LOGGING 
NOCOMPRESS 
NOCACHE
MONITORING;


CREATE TABLE SMS_APPLICATIE_REGISTER
(
  APPLICATIE    VARCHAR2(10 BYTE)               NOT NULL,
  VARIABELE     VARCHAR2(25 BYTE)               NOT NULL,
  WAARDE        VARCHAR2(4000 BYTE),
  OMSCHRIJVING  VARCHAR2(200 BYTE)
)
LOGGING 
NOCOMPRESS 
NOCACHE
MONITORING;


CREATE TABLE SMS_AUDITS
(
  ID                            NUMBER          NOT NULL,
  OMSCHRIJVING                  VARCHAR2(100 BYTE) NOT NULL,
  SOORT                         VARCHAR2(100 BYTE) NOT NULL,
  DATUM_INGANG                  DATE,
  DATUM_EINDE                   DATE,
  UITGEVOERD_DOOR               VARCHAR2(1000 BYTE),
  CONTACTPERSOON_UITVOERDER     VARCHAR2(100 BYTE),
  CONTACTPERSOON_OPDRACHTGEVER  VARCHAR2(100 BYTE),
  OPZET                         VARCHAR2(1000 BYTE),
  FILENAAM_OPZET                VARCHAR2(200 BYTE),
  DOC_CONTENT_OPZET             BLOB,
  MIMETYPE_OPZET                VARCHAR2(100 BYTE),
  DATUM_FILE_OPZET              DATE,
  RESULTATEN                    VARCHAR2(1000 BYTE),
  FILENAAM_RESULTATEN           VARCHAR2(200 BYTE),
  DOC_CONTENT_RESULTATEN        BLOB,
  MIMETYPE_RESULTATEN           VARCHAR2(100 BYTE),
  DATUM_FILE_RESULTATEN         DATE,
  MANAGEMENT_REACTIE            VARCHAR2(1000 BYTE),
  DOC_CONTENT_MAN_REACTIE       BLOB,
  FILENAAM_MAN_REACTIE          VARCHAR2(200 BYTE),
  MIMETYPE_MAN_REACTIE          VARCHAR2(100 BYTE),
  DATUM_FILE_MAN_REACTIE        DATE,
  OPMERKING                     VARCHAR2(1000 BYTE),
  UPDATED_BY                    VARCHAR2(30 BYTE) NOT NULL,
  UPDATE_DATE                   DATE            NOT NULL,
  CREATION_DATE                 DATE            NOT NULL,
  CREATED_BY                    VARCHAR2(30 BYTE) NOT NULL
)
LOGGING 
NOCOMPRESS 
NOCACHE
MONITORING;

COMMENT ON COLUMN SMS_AUDITS.ID IS 'pk';

COMMENT ON COLUMN SMS_AUDITS.OMSCHRIJVING IS 'auditplan';

COMMENT ON COLUMN SMS_AUDITS.SOORT IS 'intern/extern';

COMMENT ON COLUMN SMS_AUDITS.DATUM_INGANG IS 'aanvangsdatum';

COMMENT ON COLUMN SMS_AUDITS.DATUM_EINDE IS 'einddatum';

COMMENT ON COLUMN SMS_AUDITS.UITGEVOERD_DOOR IS 'namen van de personen die de audit hebben uitgevoerd';

COMMENT ON COLUMN SMS_AUDITS.CONTACTPERSOON_UITVOERDER IS ' ';

COMMENT ON COLUMN SMS_AUDITS.CONTACTPERSOON_OPDRACHTGEVER IS ' ';

COMMENT ON COLUMN SMS_AUDITS.OPZET IS 'omschrijving opzet van de audit';

COMMENT ON COLUMN SMS_AUDITS.FILENAAM_OPZET IS 'naam van het fysieke document met de opzet van de audit';

COMMENT ON COLUMN SMS_AUDITS.RESULTATEN IS 'beschrijving van de resultaten van de audit';

COMMENT ON COLUMN SMS_AUDITS.FILENAAM_RESULTATEN IS 'naam van het fysieke document met resultaten';

COMMENT ON COLUMN SMS_AUDITS.MANAGEMENT_REACTIE IS 'beschrijving van de management reactie';

COMMENT ON COLUMN SMS_AUDITS.FILENAAM_MAN_REACTIE IS 'naam van het fysieke document met management reactie';

COMMENT ON COLUMN SMS_AUDITS.OPMERKING IS ' ';


CREATE TABLE SMS_BEHANDELPLANNEN
(
  ID                 NUMBER                     NOT NULL,
  OMSCHRIJVING_KORT  VARCHAR2(100 BYTE)         NOT NULL,
  OMSCHRIJVING       VARCHAR2(1000 BYTE)        NOT NULL,
  AFDELING           VARCHAR2(100 BYTE),
  NAAM_OBJECT        VARCHAR2(100 BYTE),
  SOORT_OBJECT       VARCHAR2(100 BYTE),
  UPDATED_BY         VARCHAR2(30 BYTE)          NOT NULL,
  UPDATE_DATE        DATE                       NOT NULL,
  CREATION_DATE      DATE                       NOT NULL,
  CREATED_BY         VARCHAR2(30 BYTE)          NOT NULL
)
LOGGING 
NOCOMPRESS 
NOCACHE
MONITORING;


CREATE TABLE SMS_CONTROLES_BACK
(
  ID                       NUMBER               NOT NULL,
  RAPPORTAGE               VARCHAR2(4000 BYTE),
  BEHEERSCONTROLE_FO_ISMS  VARCHAR2(4000 BYTE),
  CONTROLE_INHOUD          VARCHAR2(4000 BYTE),
  FREQUENTIE               VARCHAR2(100 BYTE),
  VERWIJDER_IND            VARCHAR2(1 BYTE),
  UPDATED_BY               VARCHAR2(30 BYTE)    NOT NULL,
  UPDATE_DATE              DATE                 NOT NULL,
  CREATION_DATE            DATE                 NOT NULL,
  CREATED_BY               VARCHAR2(30 BYTE)    NOT NULL,
  PCS_ID                   NUMBER,
  RAI_ID_RESP_WERKING      NUMBER,
  OBW_ID                   NUMBER               NOT NULL,
  PRIORITEIT               VARCHAR2(20 BYTE)
)
LOGGING 
NOCOMPRESS 
NOCACHE
MONITORING;


CREATE TABLE SMS_CONTROLES_WIJZIG
(
  ID                       NUMBER               NOT NULL,
  RAPPORTAGE               VARCHAR2(4000 BYTE),
  BEHEERSCONTROLE_FO_ISMS  VARCHAR2(4000 BYTE),
  CONTROLE_INHOUD          VARCHAR2(4000 BYTE),
  FREQUENTIE               VARCHAR2(100 BYTE),
  VERWIJDER_IND            VARCHAR2(1 BYTE),
  UPDATED_BY               VARCHAR2(30 BYTE)    NOT NULL,
  UPDATE_DATE              DATE                 NOT NULL,
  CREATION_DATE            DATE                 NOT NULL,
  CREATED_BY               VARCHAR2(30 BYTE)    NOT NULL,
  PCS_ID                   NUMBER,
  RAI_ID_RESP_WERKING      NUMBER,
  OBW_ID                   NUMBER,
  PRIORITEIT               VARCHAR2(20 BYTE)
)
LOGGING 
NOCOMPRESS 
NOCACHE
MONITORING;


CREATE TABLE SMS_DATUMS
(
  DATUM     DATE                                NOT NULL,
  JAAR      VARCHAR2(4 BYTE),
  KWARTAAL  VARCHAR2(6 BYTE),
  MAAND     VARCHAR2(12 BYTE),
  DAG       VARCHAR2(2 BYTE)
)
LOGGING 
NOCOMPRESS 
NOCACHE
MONITORING;


CREATE TABLE SMS_DOCUMENTEN_BACK
(
  PK_ID                NUMBER                   NOT NULL,
  ID                   NUMBER                   NOT NULL,
  RAI_ID               NUMBER,
  VERSIE               VARCHAR2(20 BYTE),
  NAAM                 VARCHAR2(1000 BYTE),
  BEVEILIGING          VARCHAR2(1 BYTE),
  FILENAAM             VARCHAR2(200 BYTE),
  DATUM_INGANG         DATE,
  DATUM_EINDE          DATE,
  DOC_CONTENT          BLOB,
  MIMETYPE             VARCHAR2(100 BYTE),
  DATUM_FILE           DATE,
  DOCUMENT_LINK        VARCHAR2(1000 BYTE),
  CONTROLE_FREQUENTIE  VARCHAR2(100 BYTE),
  DST_ID               NUMBER,
  RAI_ID_EIGENAAR      NUMBER,
  STATUS               VARCHAR2(100 BYTE),
  UPDATED_BY           VARCHAR2(30 BYTE)        NOT NULL,
  UPDATE_DATE          DATE                     NOT NULL,
  CREATION_DATE        DATE                     NOT NULL,
  CREATED_BY           VARCHAR2(30 BYTE)        NOT NULL,
  VOORBLAD_IND         VARCHAR2(1 BYTE),
  VOORBLAD_VOLGORDE    NUMBER(4),
  OGE_ID               NUMBER,
  DCT_IDS_VERVANGT     VARCHAR2(1000 BYTE)
)
LOGGING 
NOCOMPRESS 
NOCACHE
MONITORING;


CREATE TABLE SMS_DOCUMENTEN_OBW_BACK
(
  ID             NUMBER                         NOT NULL,
  DCT_ID         NUMBER                         NOT NULL,
  VERWIJDER_IND  VARCHAR2(1 BYTE),
  UPDATED_BY     VARCHAR2(30 BYTE)              NOT NULL,
  UPDATE_DATE    DATE                           NOT NULL,
  CREATION_DATE  DATE                           NOT NULL,
  CREATED_BY     VARCHAR2(30 BYTE)              NOT NULL,
  OBW_ID         NUMBER
)
LOGGING 
NOCOMPRESS 
NOCACHE
MONITORING;


CREATE TABLE SMS_DOCUMENTEN_OBW_WIJZIG
(
  ID             NUMBER                         NOT NULL,
  DCT_ID         NUMBER                         NOT NULL,
  VERWIJDER_IND  VARCHAR2(1 BYTE),
  UPDATED_BY     VARCHAR2(30 BYTE)              NOT NULL,
  UPDATE_DATE    DATE                           NOT NULL,
  CREATION_DATE  DATE                           NOT NULL,
  CREATED_BY     VARCHAR2(30 BYTE)              NOT NULL,
  OBW_ID         NUMBER                         NOT NULL
)
LOGGING 
NOCOMPRESS 
NOCACHE
MONITORING;


CREATE TABLE SMS_DOCUMENTEN_WIJZIG
(
  ID                   NUMBER                   NOT NULL,
  RAI_ID               NUMBER,
  VERSIE               VARCHAR2(20 BYTE),
  NAAM                 VARCHAR2(1000 BYTE),
  BEVEILIGING          VARCHAR2(1 BYTE),
  FILENAAM             VARCHAR2(200 BYTE),
  DATUM_INGANG         DATE,
  DATUM_EINDE          DATE,
  DOC_CONTENT          BLOB,
  MIMETYPE             VARCHAR2(100 BYTE),
  DATUM_FILE           DATE,
  DOCUMENT_LINK        VARCHAR2(1000 BYTE),
  CONTROLE_FREQUENTIE  VARCHAR2(100 BYTE),
  DST_ID               NUMBER,
  RAI_ID_EIGENAAR      NUMBER,
  STATUS               VARCHAR2(100 BYTE),
  UPDATED_BY           VARCHAR2(30 BYTE)        NOT NULL,
  UPDATE_DATE          DATE                     NOT NULL,
  CREATION_DATE        DATE                     NOT NULL,
  CREATED_BY           VARCHAR2(30 BYTE)        NOT NULL,
  VOORBLAD_IND         VARCHAR2(1 BYTE),
  VOORBLAD_VOLGORDE    NUMBER(4),
  OGE_ID               NUMBER,
  DCT_IDS_VERVANGT     VARCHAR2(1000 BYTE)
)
LOGGING 
NOCOMPRESS 
NOCACHE
MONITORING;


CREATE TABLE SMS_DOCUMENT_SOORTEN
(
  ID             NUMBER                         NOT NULL,
  SOORT          VARCHAR2(100 BYTE),
  UPDATED_BY     VARCHAR2(30 BYTE)              NOT NULL,
  UPDATE_DATE    DATE                           NOT NULL,
  CREATION_DATE  DATE                           NOT NULL,
  CREATED_BY     VARCHAR2(30 BYTE)              NOT NULL
)
LOGGING 
NOCOMPRESS 
NOCACHE
MONITORING;

COMMENT ON COLUMN SMS_DOCUMENT_SOORTEN.ID IS ' ';

COMMENT ON COLUMN SMS_DOCUMENT_SOORTEN.SOORT IS ' ';


CREATE TABLE SMS_FOUTENLOG
(
  ID                NUMBER                      NOT NULL,
  BOODSCHAP         VARCHAR2(4000 BYTE),
  FOUT_BOODSCHAP    VARCHAR2(4000 BYTE),
  ADDITIONAL_INFO   VARCHAR2(4000 BYTE),
  DISPLAY_LOCATION  VARCHAR2(40 BYTE),
  PAGE_ITEM_NAME    VARCHAR2(255 BYTE),
  COLUMN_ALIAS      VARCHAR2(255 BYTE),
  UPDATED_BY        VARCHAR2(30 BYTE)           NOT NULL,
  UPDATE_DATE       DATE                        NOT NULL,
  CREATION_DATE     DATE                        NOT NULL,
  CREATED_BY        VARCHAR2(30 BYTE)           NOT NULL
)
LOGGING 
NOCOMPRESS 
NOCACHE
MONITORING;


CREATE TABLE SMS_FOUT_BOODSCHAPPEN
(
  ID                     NUMBER                 NOT NULL,
  BOODSCHAP              VARCHAR2(4000 BYTE),
  FUNCTIONELE_BOODSCHAP  VARCHAR2(4000 BYTE),
  UPDATED_BY             VARCHAR2(30 BYTE)      NOT NULL,
  UPDATE_DATE            DATE                   NOT NULL,
  CREATION_DATE          DATE                   NOT NULL,
  CREATED_BY             VARCHAR2(30 BYTE)      NOT NULL
)
LOGGING 
NOCOMPRESS 
NOCACHE
MONITORING;


CREATE TABLE SMS_GEBRUIKERS
(
  ID                    NUMBER(10)              NOT NULL,
  NAAM                  VARCHAR2(25 BYTE)       NOT NULL,
  WINDOWS_USER          VARCHAR2(240 BYTE),
  VERVALLEN_IND         VARCHAR2(1 BYTE)        DEFAULT 'N',
  UPDATED_BY            VARCHAR2(30 BYTE)       NOT NULL,
  UPDATE_DATE           DATE                    NOT NULL,
  CREATION_DATE         DATE                    NOT NULL,
  CREATED_BY            VARCHAR2(30 BYTE)       NOT NULL,
  VOORNAAM              VARCHAR2(100 BYTE),
  EMAIL                 VARCHAR2(100 BYTE),
  TELEFOON              VARCHAR2(100 BYTE),
  OPMERKING             VARCHAR2(1000 BYTE),
  LAST_LOGIN_DATUM      DATE,
  PRE_LAST_LOGIN_DATUM  DATE
)
LOGGING 
NOCOMPRESS 
NOCACHE
MONITORING;


CREATE TABLE SMS_GEBRUIKER_RACI_BACK
(
  ID               NUMBER                       NOT NULL,
  RAI_ID           NUMBER                       NOT NULL,
  UPDATED_BY       VARCHAR2(30 BYTE)            NOT NULL,
  UPDATE_DATE      DATE                         NOT NULL,
  CREATION_DATE    DATE                         NOT NULL,
  CREATED_BY       VARCHAR2(30 BYTE)            NOT NULL,
  GEBRUIKERS_NAAM  VARCHAR2(30 BYTE),
  GBR_ID           NUMBER
)
LOGGING 
NOCOMPRESS 
NOCACHE
MONITORING;


CREATE TABLE SMS_GEBRUIKER_ROLLEN
(
  ID             NUMBER(10)                     NOT NULL,
  GBR_ID         NUMBER(10)                     NOT NULL,
  ROL_ID         NUMBER(10)                     NOT NULL,
  UPDATED_BY     VARCHAR2(30 BYTE)              NOT NULL,
  UPDATE_DATE    DATE                           NOT NULL,
  CREATION_DATE  DATE                           NOT NULL,
  CREATED_BY     VARCHAR2(30 BYTE)              NOT NULL
)
LOGGING 
NOCOMPRESS 
NOCACHE
MONITORING;


CREATE TABLE SMS_IMP_NIEUWE_REGELGEVING
(
  OBW              VARCHAR2(3 BYTE),
  BEST_PRACTICES   VARCHAR2(100 BYTE),
  REGELGEVING      VARCHAR2(100 BYTE),
  HOOFDSTUK_NR     VARCHAR2(10 BYTE),
  HOOFDSTUK_TITEL  VARCHAR2(1000 BYTE),
  SECTIE_NR        VARCHAR2(10 BYTE),
  SECTIE_TITEL     VARCHAR2(1000 BYTE),
  SECTIE_DOEL      VARCHAR2(1000 BYTE),
  PARAGRAAF_NR     VARCHAR2(10 BYTE),
  PARAGRAAF_TITEL  VARCHAR2(1000 BYTE),
  NORM             VARCHAR2(4000 BYTE),
  ID               NUMBER(10),
  JAAR             VARCHAR2(4 BYTE)
)
LOGGING 
NOCOMPRESS 
NOCACHE
MONITORING;


CREATE TABLE SMS_ISO_HOOFDSTUKKEN
(
  HOOFDSTUK_NR     NUMBER,
  HOOFDSTUK_TITEL  VARCHAR2(1000 BYTE),
  JAAR             VARCHAR2(4 BYTE),
  UPDATED_BY       VARCHAR2(30 BYTE)            NOT NULL,
  UPDATE_DATE      DATE                         NOT NULL,
  CREATION_DATE    DATE                         NOT NULL,
  CREATED_BY       VARCHAR2(30 BYTE)            NOT NULL,
  ID               NUMBER                       NOT NULL,
  REGELGEVING      VARCHAR2(100 BYTE)
)
LOGGING 
NOCOMPRESS 
NOCACHE
MONITORING;

COMMENT ON COLUMN SMS_ISO_HOOFDSTUKKEN.HOOFDSTUK_NR IS ' ';

COMMENT ON COLUMN SMS_ISO_HOOFDSTUKKEN.HOOFDSTUK_TITEL IS ' ';

COMMENT ON COLUMN SMS_ISO_HOOFDSTUKKEN.JAAR IS ' ';


CREATE TABLE SMS_ISO_SECTIES
(
  SECTIE_NR      NUMBER,
  SECTIE_TITEL   VARCHAR2(1000 BYTE),
  SECTIE_DOEL    VARCHAR2(1000 BYTE),
  UPDATED_BY     VARCHAR2(30 BYTE)              NOT NULL,
  UPDATE_DATE    DATE                           NOT NULL,
  CREATION_DATE  DATE                           NOT NULL,
  CREATED_BY     VARCHAR2(30 BYTE)              NOT NULL,
  IHK_ID         NUMBER                         NOT NULL,
  ID             NUMBER                         NOT NULL
)
LOGGING 
NOCOMPRESS 
NOCACHE
MONITORING;

COMMENT ON COLUMN SMS_ISO_SECTIES.SECTIE_NR IS 'pk';

COMMENT ON COLUMN SMS_ISO_SECTIES.SECTIE_TITEL IS ' ';

COMMENT ON COLUMN SMS_ISO_SECTIES.SECTIE_DOEL IS ' ';


CREATE TABLE SMS_LOG_TRANSACTIES
(
  ID             NUMBER                         NOT NULL,
  TABEL          VARCHAR2(30 BYTE)              NOT NULL,
  PK             VARCHAR2(30 BYTE),
  CRUD           VARCHAR2(1 BYTE),
  NIEUWE_WAARDE  VARCHAR2(4000 BYTE),
  CREATION_DATE  DATE                           NOT NULL,
  CREATED_BY     VARCHAR2(30 BYTE)              NOT NULL
)
LOGGING 
NOCOMPRESS 
NOCACHE
MONITORING;

COMMENT ON COLUMN SMS_LOG_TRANSACTIES.ID IS 'pk';

COMMENT ON COLUMN SMS_LOG_TRANSACTIES.TABEL IS 'tabel waarop transactie plaatvindt';

COMMENT ON COLUMN SMS_LOG_TRANSACTIES.PK IS 'primary key van tabel';

COMMENT ON COLUMN SMS_LOG_TRANSACTIES.CRUD IS 'C,U of D';

COMMENT ON COLUMN SMS_LOG_TRANSACTIES.NIEUWE_WAARDE IS 'nieuwe waarde';


CREATE TABLE SMS_OBW_BACK
(
  MAATREGEL                 VARCHAR2(20 BYTE)   NOT NULL,
  CLASSIFICATIE             VARCHAR2(4 BYTE),
  SBNI_MAATREGELINHOUD      VARCHAR2(4000 BYTE),
  SCOPE                     VARCHAR2(4000 BYTE),
  INTERPRETATIE             VARCHAR2(4000 BYTE),
  HOE_WERKT_HET             VARCHAR2(4000 BYTE),
  TOELICHTING_IB_PROGRAMMA  VARCHAR2(4000 BYTE),
  WERKPAKKET                VARCHAR2(20 BYTE),
  BORGING_CONTROLEPLAN      VARCHAR2(4000 BYTE),
  DATUM_INGANG              DATE,
  DATUM_EINDE               DATE,
  RAI_ID_EIGENAAR           NUMBER,
  RAI_ID_BEHEERDER          NUMBER,
  UPDATED_BY                VARCHAR2(30 BYTE)   NOT NULL,
  UPDATE_DATE               DATE                NOT NULL,
  CREATION_DATE             DATE                NOT NULL,
  CREATED_BY                VARCHAR2(30 BYTE)   NOT NULL,
  ID                        NUMBER,
  NRM_IDS                   VARCHAR2(1000 BYTE),
  PCS_IDS                   VARCHAR2(1000 BYTE),
  OGE_ID                    NUMBER,
  PRIORITEIT                VARCHAR2(20 BYTE)
)
LOGGING 
NOCOMPRESS 
NOCACHE
MONITORING;


CREATE TABLE SMS_OBW_WIJZIG
(
  MAATREGEL                 VARCHAR2(20 BYTE)   NOT NULL,
  CLASSIFICATIE             VARCHAR2(4 BYTE),
  SBNI_MAATREGELINHOUD      VARCHAR2(4000 BYTE),
  SCOPE                     VARCHAR2(4000 BYTE),
  INTERPRETATIE             VARCHAR2(4000 BYTE),
  HOE_WERKT_HET             VARCHAR2(4000 BYTE),
  TOELICHTING_IB_PROGRAMMA  VARCHAR2(4000 BYTE),
  WERKPAKKET                VARCHAR2(20 BYTE),
  BORGING_CONTROLEPLAN      VARCHAR2(4000 BYTE),
  DATUM_INGANG              DATE,
  DATUM_EINDE               DATE,
  RAI_ID_EIGENAAR           NUMBER,
  RAI_ID_BEHEERDER          NUMBER,
  UPDATED_BY                VARCHAR2(30 BYTE)   NOT NULL,
  UPDATE_DATE               DATE                NOT NULL,
  CREATION_DATE             DATE                NOT NULL,
  CREATED_BY                VARCHAR2(30 BYTE)   NOT NULL,
  ID                        NUMBER              NOT NULL,
  NRM_IDS                   VARCHAR2(1000 BYTE),
  PCS_IDS                   VARCHAR2(1000 BYTE),
  OGE_ID                    NUMBER,
  PRIORITEIT                VARCHAR2(20 BYTE)
)
LOGGING 
NOCOMPRESS 
NOCACHE
MONITORING;


CREATE TABLE SMS_ORGANISATIES
(
  ID              NUMBER                        NOT NULL,
  NAAM            VARCHAR2(100 BYTE)            NOT NULL,
  AFKORTING       VARCHAR2(10 BYTE)             NOT NULL,
  DIRECTEUR       VARCHAR2(100 BYTE),
  CONTACTPERSOON  VARCHAR2(100 BYTE),
  UPDATED_BY      VARCHAR2(30 BYTE)             NOT NULL,
  UPDATE_DATE     DATE                          NOT NULL,
  CREATION_DATE   DATE                          NOT NULL,
  CREATED_BY      VARCHAR2(30 BYTE)             NOT NULL
)
LOGGING 
NOCOMPRESS 
NOCACHE
MONITORING;

COMMENT ON COLUMN SMS_ORGANISATIES.NAAM IS 'uitgeschreven naam van de organisatie';

COMMENT ON COLUMN SMS_ORGANISATIES.AFKORTING IS 'afkorting van de organisatie';


CREATE TABLE SMS_PROCESSEN
(
  ID             NUMBER                         NOT NULL,
  NAAM           VARCHAR2(100 BYTE)             NOT NULL,
  UPDATED_BY     VARCHAR2(30 BYTE)              NOT NULL,
  UPDATE_DATE    DATE                           NOT NULL,
  CREATION_DATE  DATE                           NOT NULL,
  CREATED_BY     VARCHAR2(30 BYTE)              NOT NULL
)
LOGGING 
NOCOMPRESS 
NOCACHE
MONITORING;


CREATE TABLE SMS_PROJECTEN
(
  ID             NUMBER                         NOT NULL,
  PROJECTNAAM    VARCHAR2(100 BYTE)             NOT NULL,
  PROJECTLEIDER  VARCHAR2(100 BYTE),
  OPDRACHTGEVER  VARCHAR2(100 BYTE),
  PROJECTCODE    VARCHAR2(100 BYTE),
  STARTDATUM     DATE                           NOT NULL,
  EINDDATUM      DATE,
  BUDGET         NUMBER,
  UPDATED_BY     VARCHAR2(30 BYTE)              NOT NULL,
  UPDATE_DATE    DATE                           NOT NULL,
  CREATION_DATE  DATE                           NOT NULL,
  CREATED_BY     VARCHAR2(30 BYTE)              NOT NULL
)
LOGGING 
NOCOMPRESS 
NOCACHE
MONITORING;


CREATE TABLE SMS_RACI
(
  ID             NUMBER                         NOT NULL,
  FUNCTIE        VARCHAR2(200 BYTE)             NOT NULL,
  RAI_ID         NUMBER,
  RAI_ID_CIB     NUMBER,
  RAI_ID_IBS     NUMBER,
  UPDATED_BY     VARCHAR2(30 BYTE)              NOT NULL,
  UPDATE_DATE    DATE                           NOT NULL,
  CREATION_DATE  DATE                           NOT NULL,
  CREATED_BY     VARCHAR2(30 BYTE)              NOT NULL,
  TOELICHTING    VARCHAR2(1000 BYTE),
  VERVALLEN_IND  VARCHAR2(1 BYTE)
)
LOGGING 
NOCOMPRESS 
NOCACHE
MONITORING;

COMMENT ON COLUMN SMS_RACI.ID IS ' ';

COMMENT ON COLUMN SMS_RACI.FUNCTIE IS 'functieomschrijving';

COMMENT ON COLUMN SMS_RACI.RAI_ID IS 'technische kolom gebruikt bij conversie voor vervangen dubbele functies';

COMMENT ON COLUMN SMS_RACI.RAI_ID_CIB IS 'coordinator ib horende bij functie';


CREATE TABLE SMS_RACI_OBW_BACK
(
  ID             NUMBER                         NOT NULL,
  OBW_MAATREGEL  VARCHAR2(10 BYTE),
  RAI_ID         NUMBER,
  CTE_ID         NUMBER,
  ROLNAAM        VARCHAR2(30 BYTE)              NOT NULL,
  UPDATED_BY     VARCHAR2(30 BYTE)              NOT NULL,
  UPDATE_DATE    DATE                           NOT NULL,
  CREATION_DATE  DATE                           NOT NULL,
  CREATED_BY     VARCHAR2(30 BYTE)              NOT NULL
)
LOGGING 
NOCOMPRESS 
NOCACHE
MONITORING;


CREATE TABLE SMS_RISICO_ANALYSES
(
  ID                    NUMBER                  NOT NULL,
  OMSCHRIJVING          VARCHAR2(1000 BYTE)     NOT NULL,
  DATUM                 DATE,
  OBJECT                VARCHAR2(100 BYTE),
  CLASSIFICATIE         VARCHAR2(100 BYTE),
  BEDREIGINGEN_PROFIEL  VARCHAR2(100 BYTE),
  RISICOPROFIEL         VARCHAR2(100 BYTE),
  DOC_CONTENT_BIA       BLOB,
  FILENAAM_BIA          VARCHAR2(200 BYTE),
  MIMETYPE_BIA          VARCHAR2(100 BYTE),
  DATUM_FILE_BIA        DATE,
  DOC_CONTENT_TANDVA    BLOB,
  FILENAAM_TANDVA       VARCHAR2(200 BYTE),
  MIMETYPE_TANDVA       VARCHAR2(100 BYTE),
  DATUM_FILE_TANDVA     DATE,
  UPDATED_BY            VARCHAR2(30 BYTE)       NOT NULL,
  UPDATE_DATE           DATE                    NOT NULL,
  CREATION_DATE         DATE                    NOT NULL,
  CREATED_BY            VARCHAR2(30 BYTE)       NOT NULL,
  OMSCHRIJVING_KORT     VARCHAR2(100 BYTE),
  DOC_CONTENT_RAPPORT   BLOB,
  FILENAAM_RAPPORT      VARCHAR2(200 BYTE),
  MIMETYPE_RAPPORT      VARCHAR2(100 BYTE),
  DATUM_FILE_RAPPORT    DATE
)
LOGGING 
NOCOMPRESS 
NOCACHE
MONITORING;


CREATE TABLE SMS_VERANTWOORDINGEN
(
  ID     NUMBER                                 NOT NULL,
  TITEL  VARCHAR2(1000 BYTE)                    NOT NULL,
  TEKST  VARCHAR2(4000 BYTE)
)
LOGGING 
NOCOMPRESS 
NOCACHE
MONITORING;


CREATE UNIQUE INDEX SBN_MAATREGELEN_PK ON SBN_MAATREGELEN
(MR_ID)
LOGGING;

CREATE UNIQUE INDEX SMS_ADT_PK ON SMS_AUDITS
(ID)
LOGGING;

CREATE UNIQUE INDEX SMS_ARR_PK ON SMS_APPLICATIE_REGISTER
(APPLICATIE, VARIABELE)
LOGGING;

CREATE UNIQUE INDEX SMS_BPN_PK ON SMS_BEHANDELPLANNEN
(ID)
LOGGING;

CREATE INDEX SMS_DCTB_IDX1 ON SMS_DOCUMENTEN_BACK
(ID)
LOGGING;

CREATE UNIQUE INDEX SMS_DCTB_PK ON SMS_DOCUMENTEN_BACK
(PK_ID)
LOGGING;

CREATE UNIQUE INDEX SMS_DST_PK ON SMS_DOCUMENT_SOORTEN
(ID)
LOGGING;

CREATE UNIQUE INDEX SMS_FBP_PK ON SMS_FOUT_BOODSCHAPPEN
(ID)
LOGGING;

CREATE UNIQUE INDEX SMS_FBP_UK1 ON SMS_FOUT_BOODSCHAPPEN
(BOODSCHAP)
LOGGING;

CREATE UNIQUE INDEX SMS_FLG_PK ON SMS_FOUTENLOG
(ID)
LOGGING;

CREATE UNIQUE INDEX SMS_GBR_PK ON SMS_GEBRUIKERS
(ID)
LOGGING;

CREATE UNIQUE INDEX SMS_GBR_UK1 ON SMS_GEBRUIKERS
(WINDOWS_USER)
LOGGING;

CREATE INDEX SMS_GPL_IDX2 ON SMS_GEBRUIKER_ROLLEN
(ROL_ID)
LOGGING;

CREATE UNIQUE INDEX SMS_GPL_UK1 ON SMS_GEBRUIKER_ROLLEN
(ROL_ID, GBR_ID)
LOGGING;

CREATE INDEX SMS_GRL_IDX1 ON SMS_GEBRUIKER_ROLLEN
(GBR_ID)
LOGGING;

CREATE UNIQUE INDEX SMS_GRL_PK ON SMS_GEBRUIKER_ROLLEN
(ID)
LOGGING;

CREATE UNIQUE INDEX SMS_IHK_PK ON SMS_ISO_HOOFDSTUKKEN
(ID)
LOGGING;

CREATE UNIQUE INDEX SMS_IHK_UK1 ON SMS_ISO_HOOFDSTUKKEN
(HOOFDSTUK_NR, REGELGEVING, JAAR)
LOGGING;

CREATE UNIQUE INDEX SMS_ISE_PK ON SMS_ISO_SECTIES
(ID)
LOGGING;

CREATE UNIQUE INDEX SMS_ISE_UK1 ON SMS_ISO_SECTIES
(IHK_ID, SECTIE_NR)
LOGGING;

CREATE UNIQUE INDEX SMS_LTE_PK ON SMS_LOG_TRANSACTIES
(ID)
LOGGING;

CREATE UNIQUE INDEX SMS_OBWB_PK ON SMS_OBW_WIJZIG
(ID)
LOGGING;

CREATE UNIQUE INDEX SMS_OGE_PK ON SMS_ORGANISATIES
(ID)
LOGGING;

CREATE UNIQUE INDEX SMS_PCS_PK ON SMS_PROCESSEN
(ID)
LOGGING;

CREATE UNIQUE INDEX SMS_PJT_PK ON SMS_PROJECTEN
(ID)
LOGGING;

CREATE UNIQUE INDEX SMS_RAE_PK ON SMS_RISICO_ANALYSES
(ID)
LOGGING;

CREATE UNIQUE INDEX SMS_RAI_PK ON SMS_RACI
(ID)
LOGGING;

CREATE UNIQUE INDEX SMS_VAG_PK ON SMS_VERANTWOORDINGEN
(ID)
LOGGING;

CREATE OR REPLACE TRIGGER SMS_ADT_BR_IUD_TRG BEFORE
  INSERT OR UPDATE OR DELETE
  ON sms_audits
FOR EACH ROW
BEGIN
  IF INSERTING
  THEN
    SELECT sms_adt_sq1.NEXTVAL
    INTO   :NEW.id
    FROM   DUAL
    ;
    :NEW.created_by    := NVL(V('APP_USER'),USER);
    :NEW.creation_date := SYSDATE;
    sms_pck.log_insert('sms_audits',NULL,:NEW.id);
  END IF;
  IF UPDATING
  THEN
    IF :NEW.filenaam_opzet IS NULL
    AND :OLD.filenaam_opzet IS NOT NULL
    THEN
      :NEW.doc_content_opzet := NULL;
      :NEW.mimetype_opzet := NULL;
      :NEW.datum_file_opzet := NULL;
    END IF;
    IF :NEW.filenaam_resultaten IS NULL
    AND :OLD.filenaam_resultaten IS NOT NULL
    THEN
      :NEW.doc_content_resultaten := NULL;
      :NEW.mimetype_resultaten := NULL;
      :NEW.datum_file_resultaten := NULL;
    END IF;
    IF :NEW.filenaam_man_reactie IS NULL
    AND :OLD.filenaam_man_reactie IS NOT NULL
    THEN
      :NEW.doc_content_man_reactie := NULL;
      :NEW.mimetype_man_reactie := NULL;
      :NEW.datum_file_man_reactie := NULL;
    END IF;
  END IF;
  IF UPDATING THEN
    sms_pck.log_update('sms_audits',NULL,:NEW.id);
  END IF;
  IF INSERTING OR UPDATING
  THEN
    :NEW.updated_by  := NVL(V('APP_USER'),USER);
    :NEW.update_date := SYSDATE;
  END IF;
  IF DELETING
  THEN
    sms_pck.log_delete('sms_bevinding_acties',NULL,:OLD.id);
  END IF;
END;
/


CREATE OR REPLACE TRIGGER SMS_BPN_BR_IU_TRG
  BEFORE INSERT OR UPDATE
  ON  sms_behandelplannen
   FOR EACH ROW
BEGIN
  IF INSERTING
  THEN
    :NEW.created_by  := NVL(V('APP_USER'),USER);
    :NEW.creation_date := SYSDATE;
    :NEW.id            := sms_bpn_sq1.NEXTVAL;
  END IF;
  IF INSERTING OR UPDATING
  THEN
    :NEW.updated_by  := NVL(V('APP_USER'),USER);
    :NEW.update_date := SYSDATE;
  END IF;
END;
/


CREATE OR REPLACE TRIGGER SMS_CTEW_BR_IU_TRG
  BEFORE INSERT OR UPDATE
  ON  sms_controles_wijzig
   FOR EACH ROW
BEGIN
  IF INSERTING
  THEN
    IF :NEW.id IS NULL
    THEN
      SELECT sms_cte_sq1.NEXTVAL INTO :NEW.id
      FROM   DUAL;
    END IF;
    :NEW.created_by  := NVL(V('APP_USER'),USER);
    :NEW.creation_date := SYSDATE;
  END IF;
  IF INSERTING OR UPDATING
  THEN
    :NEW.updated_by  := NVL(V('APP_USER'),USER);
    :NEW.update_date := SYSDATE;
  END IF;
END;
/


CREATE OR REPLACE TRIGGER SMS_DCTW_BR_IU_TRG
  BEFORE INSERT OR UPDATE
  ON  sms_documenten_wijzig
   FOR EACH ROW
BEGIN
  IF INSERTING
  THEN
    IF :NEW.id IS NULL
    THEN
      SELECT sms_dct_sq1.NEXTVAL INTO :NEW.id
      FROM   DUAL;
    END IF;
   :NEW.created_by  := NVL(V('APP_USER'),USER);
   :NEW.creation_date := SYSDATE;
  END IF;
  IF INSERTING OR UPDATING
  THEN
    IF :NEW.filenaam IS NULL
    AND :OLD.filenaam IS NOT NULL
    THEN
      :NEW.doc_content := NULL;
      :NEW.mimetype := NULL;
      :NEW.datum_file := NULL;
    END IF;
    :NEW.updated_by  := NVL(V('APP_USER'),USER);
    :NEW.update_date := SYSDATE;
  END IF;
END;
/


CREATE OR REPLACE TRIGGER SMS_DOWW_BR_IU_TRG
  BEFORE INSERT OR UPDATE
  ON  sms_documenten_obw_wijzig
   FOR EACH ROW
BEGIN
  IF INSERTING
  THEN
    IF :NEW.ID IS NULL
    THEN
      SELECT sms_dow_sq1.NEXTVAL INTO :NEW.id
      FROM   DUAL;
    END IF;
    :NEW.created_by  := NVL(V('APP_USER'),USER);
    :NEW.creation_date := SYSDATE;
  END IF;
  IF INSERTING OR UPDATING
  THEN
    :NEW.updated_by  := NVL(V('APP_USER'),USER);
    :NEW.update_date := SYSDATE;
  END IF;
END;
/


CREATE OR REPLACE TRIGGER SMS_DST_BR_IUD_TRG
  BEFORE INSERT OR UPDATE OR DELETE
  ON  sms_document_soorten
   FOR EACH ROW
BEGIN
  IF INSERTING
  THEN
    SELECT sms_dst_sq1.NEXTVAL INTO :NEW.id
    FROM   DUAL;
    :NEW.created_by  := NVL(V('APP_USER'),USER);
    :NEW.creation_date := SYSDATE;
    sms_pck.log_insert('sms_document_soorten',NULL,:NEW.id);
  END IF;
  IF UPDATING
  THEN
    sms_pck.log_update('sms_document_soorten',NULL,:NEW.id);
  END IF;
  IF INSERTING OR UPDATING
  THEN
    :NEW.updated_by  := NVL(V('APP_USER'),USER);
    :NEW.update_date := SYSDATE;
  END IF;
  IF DELETING
  THEN
    sms_pck.log_delete('sms_document_soorten',NULL,:OLD.id);
  END IF;
END;
/


CREATE OR REPLACE TRIGGER sms_fbp_br_iu_trg
  BEFORE INSERT OR UPDATE
  ON  sms_fout_boodschappen
   FOR EACH ROW
BEGIN
  IF INSERTING
  THEN
    :NEW.created_by    := NVL(V('APP_USER'),USER);
    :NEW.creation_date := SYSDATE;
    :NEW.id            := sms_fbp_sq1.NEXTVAL;
  END IF;
  IF INSERTING OR UPDATING
  THEN
    :NEW.updated_by  := NVL(V('APP_USER'),USER);
    :NEW.update_date := SYSDATE;
  END IF;
END;
/


CREATE OR REPLACE TRIGGER sms_flg_br_iu_trg
  BEFORE INSERT OR UPDATE
  ON  sms_foutenlog
   FOR EACH ROW
BEGIN
  IF INSERTING
  THEN
    :NEW.created_by    := NVL(V('APP_USER'),USER);
    :NEW.creation_date := SYSDATE;
    :NEW.id            := sms_flg_sq1.NEXTVAL;
  END IF;
  IF INSERTING OR UPDATING
  THEN
    :NEW.updated_by  := NVL(V('APP_USER'),USER);
    :NEW.update_date := SYSDATE;
  END IF;
END;
/


CREATE OR REPLACE TRIGGER SMS_GBR_BR_IU_TRG 
  BEFORE INSERT OR UPDATE
  ON  SMS_GEBRUIKERS
   FOR EACH ROW
BEGIN
  IF INSERTING
  THEN
    :NEW.created_by    := NVL(V('APP_USER'),USER);
    :NEW.creation_date := SYSDATE;
    :NEW.id            := SMS_GBR_sq1.NEXTVAL;
    sms_pck.log_insert('sms_gebruikers',NULL,:NEW.id);
  END IF;
  IF INSERTING OR UPDATING
  THEN
    :NEW.updated_by  := NVL(V('APP_USER'),USER);
    :NEW.update_date := SYSDATE;
  END IF;
  IF UPDATING
  THEN
    sms_pck.log_update('sms_gebruikers',NULL,:NEW.id);
  END IF;
END;
/


CREATE OR REPLACE TRIGGER SMS_GRL_BR_IU_TRG 
  BEFORE INSERT OR UPDATE
  ON  SMS_GEBRUIKER_ROLLEN
   FOR EACH ROW
BEGIN
  IF INSERTING
  THEN
    :NEW.created_by    := NVL(V('APP_USER'),USER);
    :NEW.creation_date := SYSDATE;
    :NEW.id            := SMS_GRL_sq1.NEXTVAL;
  END IF;
  IF INSERTING OR UPDATING
  THEN
    :NEW.updated_by  := NVL(V('APP_USER'),USER);
    :NEW.update_date := SYSDATE;
  END IF;
END;
/


CREATE OR REPLACE TRIGGER sms_ihk_br_iud_trg
  BEFORE INSERT OR UPDATE OR DELETE
  ON  sms_iso_hoofdstukken
   FOR EACH ROW
BEGIN
  IF INSERTING
  THEN
    :NEW.created_by  := NVL(V('APP_USER'),USER);
    :NEW.creation_date := SYSDATE;
    :NEW.id            := sms_ihk_sq1.NEXTVAL;
    sms_pck.log_insert('sms_iso_hoofstukken',NULL,:NEW.id);
  END IF;
  IF UPDATING
  THEN
    sms_pck.log_update('sms_iso_hoofstukken',NULL,:NEW.id);
  END IF;
  IF INSERTING OR UPDATING
  THEN
    :NEW.updated_by  := NVL(V('APP_USER'),USER);
    :NEW.update_date := SYSDATE;
  END IF;
  IF DELETING
  THEN
    sms_pck.log_delete('sms_iso_hoofstukken',NULL,:OLD.id);
  END IF;
END;
/


CREATE OR REPLACE TRIGGER sms_ise_br_iud_trg
  BEFORE INSERT OR UPDATE OR DELETE
  ON  sms_iso_secties
   FOR EACH ROW
BEGIN
  IF INSERTING
  THEN
    :NEW.created_by  := NVL(V('APP_USER'),USER);
    :NEW.creation_date := SYSDATE;
    :NEW.id            := sms_ise_sq1.NEXTVAL;
    sms_pck.log_insert('sms_iso_secties',NULL,:NEW.id);
  END IF;
  IF UPDATING
  THEN
    sms_pck.log_update('sms_iso_secties',NULL,:NEW.id);
  END IF;
  IF INSERTING OR UPDATING
  THEN
    :NEW.updated_by  := NVL(V('APP_USER'),USER);
    :NEW.update_date := SYSDATE;
  END IF;
  IF DELETING
  THEN
    sms_pck.log_delete('sms_iso_secties',NULL,:OLD.id);
  END IF;
END;
/


CREATE OR REPLACE TRIGGER SMS_LTE_BR_IUD_TRG
  BEFORE INSERT OR UPDATE
  ON   sms_log_transacties
   FOR EACH ROW
BEGIN
  IF INSERTING
  THEN
    SELECT sms_lte_sq1.NEXTVAL INTO :NEW.id
    FROM   DUAL;
    :NEW.created_by  := NVL(V('APP_USER'),USER);
    :NEW.creation_date := SYSDATE;
  END IF;
END;
/


CREATE OR REPLACE TRIGGER sms_obww_br_iu_trg
  BEFORE INSERT OR UPDATE
  ON  sms_obw_wijzig
   FOR EACH ROW
BEGIN
  IF INSERTING
  THEN
    :NEW.created_by  := NVL(V('APP_USER'),USER);
    :NEW.creation_date := SYSDATE;
    IF :NEW.id IS NULL
    THEN
       :NEW.id            := sms_obw_sq1.NEXTVAL;
    END IF;
  END IF;
  IF INSERTING OR UPDATING
  THEN
    :NEW.updated_by  := NVL(V('APP_USER'),USER);
    :NEW.update_date := SYSDATE;
  END IF;
END;
/


CREATE OR REPLACE TRIGGER SMS_OGE_BR_IUD_TRG
  BEFORE INSERT OR UPDATE OR DELETE
  ON  sms_organisaties
   FOR EACH ROW
BEGIN
  IF INSERTING
  THEN
    :NEW.id := sms_oge_sq1.NEXTVAL;
    :NEW.created_by  := NVL(V('APP_USER'),USER);
    :NEW.creation_date := SYSDATE;
  END IF;
  IF INSERTING OR UPDATING
  THEN
    :NEW.updated_by  := NVL(V('APP_USER'),USER);
    :NEW.update_date := SYSDATE;
  END IF;
END;
/


CREATE OR REPLACE TRIGGER SMS_PCS_BR_IUD_TRG
  BEFORE INSERT OR UPDATE OR DELETE
  ON  sms_processen
   FOR EACH ROW
BEGIN
  IF INSERTING
  THEN
    IF :NEW.ID IS NULL
    THEN
      SELECT sms_pcs_sq1.NEXTVAL INTO :NEW.id
      FROM   DUAL;
    END IF;
    :NEW.created_by  := NVL(V('APP_USER'),USER);
    :NEW.creation_date := SYSDATE;
    sms_pck.log_insert('SMS_PROCESSEN',NULL,:NEW.id);
  END IF;
  IF INSERTING OR UPDATING
  THEN
    :NEW.updated_by  := NVL(V('APP_USER'),USER);
    :NEW.update_date := SYSDATE;
  END IF;
  IF updating
  THEN
    sms_pck.log_update('SMS_PROCESSEN',NULL,:NEW.id);
  END IF;
  IF deleting
  THEN
    sms_pck.log_delete('SMS_PROCESSEN',NULL,:OLD.id);
  END IF;
END;
/


CREATE OR REPLACE TRIGGER SMS_PJT_BR_IUD_TRG
  BEFORE INSERT OR UPDATE OR DELETE
  ON  sms_projecten
   FOR EACH ROW
BEGIN
  IF INSERTING
  THEN
    :NEW.id := sms_pjt_sq1.NEXTVAL;
    :NEW.created_by  := NVL(V('APP_USER'),USER);
    :NEW.creation_date := SYSDATE;
  END IF;
  IF INSERTING OR UPDATING
  THEN
    :NEW.updated_by  := NVL(V('APP_USER'),USER);
    :NEW.update_date := SYSDATE;
  END IF;
END;
/


CREATE OR REPLACE TRIGGER SMS_RAE_BR_IU_TRG
  BEFORE INSERT OR UPDATE
  ON  sms_risico_analyses
   FOR EACH ROW
BEGIN
  IF INSERTING
  THEN
    :NEW.created_by    := NVL(V('APP_USER'),USER);
    :NEW.creation_date := SYSDATE;
    :NEW.id            := sms_rae_sq1.NEXTVAL;
  END IF;
  IF UPDATING
  THEN
    IF  :NEW.filenaam_bia IS NULL
    AND :OLD.filenaam_bia IS NOT NULL
    THEN
      :NEW.doc_content_bia := NULL;
      :NEW.mimetype_bia    := NULL;
      :NEW.datum_file_bia  := NULL;
    END IF;
    IF  :NEW.filenaam_tandva IS NULL
    AND :OLD.filenaam_tandva IS NOT NULL
    THEN
      :NEW.doc_content_tandva := NULL;
      :NEW.mimetype_tandva    := NULL;
      :NEW.datum_file_tandva  := NULL;
    END IF;
    IF  :NEW.filenaam_rapport IS NULL
    AND :OLD.filenaam_rapport IS NOT NULL
    THEN
      :NEW.doc_content_rapport := NULL;
      :NEW.mimetype_rapport    := NULL;
      :NEW.datum_file_rapport  := NULL;
    END IF;
  END IF;
  IF INSERTING OR UPDATING
  THEN
    :NEW.updated_by  := NVL(V('APP_USER'),USER);
    :NEW.update_date := SYSDATE;
  END IF;
END;
/


CREATE OR REPLACE TRIGGER SMS_RAI_BR_IUD_TRG
  BEFORE INSERT OR UPDATE OR DELETE
  ON  sms_raci
   FOR EACH ROW
BEGIN
  IF INSERTING
  THEN
    IF :NEW.id IS NULL
    THEN
      SELECT sms_rai_sq1.NEXTVAL INTO :NEW.id
      FROM   DUAL;
    END IF;
    :NEW.created_by  := NVL(V('APP_USER'),USER);
    :NEW.creation_date := SYSDATE;
    sms_pck.log_insert('sms_raci',NULL,:NEW.id);
  END IF;
  IF INSERTING OR UPDATING
  THEN
    :NEW.updated_by  := NVL(V('APP_USER'),USER);
    :NEW.update_date := SYSDATE;
  END IF;
  IF UPDATING
  THEN
    sms_pck.log_update('sms_raci',NULL,:NEW.id);
  END IF;
  IF DELETING
  THEN
    sms_pck.log_delete('sms_raci',NULL,:OLD.id);
  END IF;
END;
/


CREATE TABLE SMS_DOCUMENTEN
(
  ID                   NUMBER                   NOT NULL,
  RAI_ID               NUMBER,
  VERSIE               VARCHAR2(20 BYTE),
  NAAM                 VARCHAR2(1000 BYTE),
  BEVEILIGING          VARCHAR2(1 BYTE),
  FILENAAM             VARCHAR2(200 BYTE),
  DATUM_INGANG         DATE,
  DATUM_EINDE          DATE,
  DOC_CONTENT          BLOB,
  MIMETYPE             VARCHAR2(100 BYTE),
  DATUM_FILE           DATE,
  DOCUMENT_LINK        VARCHAR2(1000 BYTE),
  CONTROLE_FREQUENTIE  VARCHAR2(100 BYTE),
  DST_ID               NUMBER,
  RAI_ID_EIGENAAR      NUMBER,
  STATUS               VARCHAR2(100 BYTE),
  UPDATED_BY           VARCHAR2(30 BYTE)        NOT NULL,
  UPDATE_DATE          DATE                     NOT NULL,
  CREATION_DATE        DATE                     NOT NULL,
  CREATED_BY           VARCHAR2(30 BYTE)        NOT NULL,
  VOORBLAD_IND         VARCHAR2(1 BYTE),
  VOORBLAD_VOLGORDE    NUMBER(4),
  OGE_ID               NUMBER,
  DCT_IDS_VERVANGT     VARCHAR2(1000 BYTE)
)
LOGGING 
NOCOMPRESS 
NOCACHE
MONITORING;

COMMENT ON COLUMN SMS_DOCUMENTEN.ID IS ' ';

COMMENT ON COLUMN SMS_DOCUMENTEN.RAI_ID IS 'beheerder';

COMMENT ON COLUMN SMS_DOCUMENTEN.VERSIE IS ' ';

COMMENT ON COLUMN SMS_DOCUMENTEN.NAAM IS 'functionele naam van het document';

COMMENT ON COLUMN SMS_DOCUMENTEN.BEVEILIGING IS 'indien Ja dan mag document beperkt worden getoond';

COMMENT ON COLUMN SMS_DOCUMENTEN.FILENAAM IS 'naam van het fysieke document';

COMMENT ON COLUMN SMS_DOCUMENTEN.DATUM_INGANG IS 'aanmaakdatum';

COMMENT ON COLUMN SMS_DOCUMENTEN.DATUM_EINDE IS 'vervaldatum';

COMMENT ON COLUMN SMS_DOCUMENTEN.DOC_CONTENT IS 'fysieke document';

COMMENT ON COLUMN SMS_DOCUMENTEN.MIMETYPE IS 'technische kolom voor fysieke document';

COMMENT ON COLUMN SMS_DOCUMENTEN.DATUM_FILE IS 'technische kolom voor fysieke document';

COMMENT ON COLUMN SMS_DOCUMENTEN.DOCUMENT_LINK IS 'link naar het fysieke document';

COMMENT ON COLUMN SMS_DOCUMENTEN.CONTROLE_FREQUENTIE IS 'jaarlijks, maandelijks, etc';

COMMENT ON COLUMN SMS_DOCUMENTEN.DST_ID IS 'fk naar documentsoort';

COMMENT ON COLUMN SMS_DOCUMENTEN.RAI_ID_EIGENAAR IS 'fk naar raci';

COMMENT ON COLUMN SMS_DOCUMENTEN.STATUS IS 'actueel, concept,vervallen';


CREATE TABLE SMS_GEBRUIKER_RACI
(
  ID             NUMBER                         NOT NULL,
  RAI_ID         NUMBER                         NOT NULL,
  UPDATED_BY     VARCHAR2(30 BYTE)              NOT NULL,
  UPDATE_DATE    DATE                           NOT NULL,
  CREATION_DATE  DATE                           NOT NULL,
  CREATED_BY     VARCHAR2(30 BYTE)              NOT NULL,
  GBR_ID         NUMBER
)
LOGGING 
NOCOMPRESS 
NOCACHE
MONITORING;

COMMENT ON COLUMN SMS_GEBRUIKER_RACI.ID IS ' ';

COMMENT ON COLUMN SMS_GEBRUIKER_RACI.RAI_ID IS ' ';


CREATE TABLE SMS_ISO_PARAGRAFEN
(
  ID                 NUMBER,
  PARAGRAAF_NR       NUMBER,
  PARAGRAAF_TITEL    VARCHAR2(1000 BYTE),
  NORM               VARCHAR2(4000 BYTE),
  COMMENTAAR         VARCHAR2(1000 BYTE),
  TOELICHTING        VARCHAR2(1000 BYTE),
  VERANTWOORDELIJK   VARCHAR2(20 BYTE),
  ORGANISATIE_IND    VARCHAR2(1 BYTE),
  LEVERANCIER_IND    VARCHAR2(1 BYTE),
  REDEN_UITSLUITING  VARCHAR2(1000 BYTE),
  SELECTIE_REDEN     VARCHAR2(100 BYTE),
  UPDATED_BY         VARCHAR2(30 BYTE)          NOT NULL,
  UPDATE_DATE        DATE                       NOT NULL,
  CREATION_DATE      DATE                       NOT NULL,
  CREATED_BY         VARCHAR2(30 BYTE)          NOT NULL,
  ISE_ID             NUMBER                     NOT NULL
)
LOGGING 
NOCOMPRESS 
NOCACHE
MONITORING;

COMMENT ON COLUMN SMS_ISO_PARAGRAFEN.ID IS ' ';

COMMENT ON COLUMN SMS_ISO_PARAGRAFEN.PARAGRAAF_NR IS ' ';

COMMENT ON COLUMN SMS_ISO_PARAGRAFEN.PARAGRAAF_TITEL IS ' ';

COMMENT ON COLUMN SMS_ISO_PARAGRAFEN.NORM IS 'omschrijving van de norm';

COMMENT ON COLUMN SMS_ISO_PARAGRAFEN.COMMENTAAR IS ' ';

COMMENT ON COLUMN SMS_ISO_PARAGRAFEN.TOELICHTING IS ' ';

COMMENT ON COLUMN SMS_ISO_PARAGRAFEN.VERANTWOORDELIJK IS ' ';

COMMENT ON COLUMN SMS_ISO_PARAGRAFEN.ORGANISATIE_IND IS 'geldt deze voor de onderhavige organisatie';

COMMENT ON COLUMN SMS_ISO_PARAGRAFEN.LEVERANCIER_IND IS 'geldt deze voor de onderhavige organisatie als zijnde leverancier van diensten';

COMMENT ON COLUMN SMS_ISO_PARAGRAFEN.REDEN_UITSLUITING IS ' ';

COMMENT ON COLUMN SMS_ISO_PARAGRAFEN.SELECTIE_REDEN IS ' ';


CREATE TABLE SMS_OBW
(
  MAATREGEL                 VARCHAR2(20 BYTE)   NOT NULL,
  CLASSIFICATIE             VARCHAR2(4 BYTE),
  SBNI_MAATREGELINHOUD      VARCHAR2(4000 BYTE),
  SCOPE                     VARCHAR2(4000 BYTE),
  INTERPRETATIE             VARCHAR2(4000 BYTE),
  HOE_WERKT_HET             VARCHAR2(4000 BYTE),
  TOELICHTING_IB_PROGRAMMA  VARCHAR2(4000 BYTE),
  WERKPAKKET                VARCHAR2(20 BYTE),
  BORGING_CONTROLEPLAN      VARCHAR2(4000 BYTE),
  DATUM_INGANG              DATE,
  DATUM_EINDE               DATE,
  RAI_ID_EIGENAAR           NUMBER,
  RAI_ID_BEHEERDER          NUMBER,
  UPDATED_BY                VARCHAR2(30 BYTE)   NOT NULL,
  UPDATE_DATE               DATE                NOT NULL,
  CREATION_DATE             DATE                NOT NULL,
  CREATED_BY                VARCHAR2(30 BYTE)   NOT NULL,
  ID                        NUMBER              NOT NULL,
  NRM_IDS                   VARCHAR2(1000 BYTE),
  PCS_IDS                   VARCHAR2(1000 BYTE),
  OGE_ID                    NUMBER,
  PRIORITEIT                VARCHAR2(20 BYTE)
)
LOGGING 
NOCOMPRESS 
NOCACHE
MONITORING;

COMMENT ON COLUMN SMS_OBW.MAATREGEL IS ' ';

COMMENT ON COLUMN SMS_OBW.CLASSIFICATIE IS ' ';

COMMENT ON COLUMN SMS_OBW.SBNI_MAATREGELINHOUD IS 'omschriving van de maatregel';

COMMENT ON COLUMN SMS_OBW.SCOPE IS ' ';

COMMENT ON COLUMN SMS_OBW.INTERPRETATIE IS ' ';

COMMENT ON COLUMN SMS_OBW.HOE_WERKT_HET IS ' ';

COMMENT ON COLUMN SMS_OBW.TOELICHTING_IB_PROGRAMMA IS 'obsolete';

COMMENT ON COLUMN SMS_OBW.WERKPAKKET IS ' ';

COMMENT ON COLUMN SMS_OBW.BORGING_CONTROLEPLAN IS ' ';

COMMENT ON COLUMN SMS_OBW.DATUM_INGANG IS 'ingangsdatum';

COMMENT ON COLUMN SMS_OBW.DATUM_EINDE IS 'vervaldatum';

COMMENT ON COLUMN SMS_OBW.RAI_ID_EIGENAAR IS 'fk naar raci';

COMMENT ON COLUMN SMS_OBW.RAI_ID_BEHEERDER IS 'fk naar raci';


CREATE TABLE SMS_OBW_HIS
(
  MAATREGEL                 VARCHAR2(10 BYTE)   NOT NULL,
  CLASSIFICATIE             VARCHAR2(4 BYTE),
  SBNI_MAATREGELINHOUD      VARCHAR2(4000 BYTE),
  SCOPE                     VARCHAR2(4000 BYTE),
  INTERPRETATIE             VARCHAR2(4000 BYTE),
  HOE_WERKT_HET             VARCHAR2(4000 BYTE),
  TOELICHTING_IB_PROGRAMMA  VARCHAR2(4000 BYTE),
  BORGING_CONTROLEPLAN      VARCHAR2(4000 BYTE),
  DATUM_INGANG              DATE,
  DATUM_EINDE               DATE,
  NRM_ID                    NUMBER,
  RAI_ID_EIGENAAR           NUMBER,
  RAI_ID_BEHEERDER          NUMBER,
  UPDATED_BY                VARCHAR2(30 BYTE)   NOT NULL,
  UPDATE_DATE               DATE                NOT NULL,
  CREATION_DATE             DATE                NOT NULL,
  CREATED_BY                VARCHAR2(30 BYTE)   NOT NULL,
  NORM                      VARCHAR2(4000 BYTE),
  DOCUMENTEN_BIJ_OBW        VARCHAR2(4000 BYTE),
  EIGENAAR                  VARCHAR2(4000 BYTE),
  BEHEERDER                 VARCHAR2(4000 BYTE),
  CONTROLES_BIJ_OBW         VARCHAR2(4000 BYTE),
  BEVINDINGEN_BIJ_OBW       VARCHAR2(4000 BYTE),
  IPF_ID                    NUMBER,
  ID                        NUMBER              NOT NULL
)
LOGGING 
NOCOMPRESS 
NOCACHE
MONITORING;


CREATE TABLE SMS_OBW_PROCESSEN
(
  ID             NUMBER                         NOT NULL,
  OBW_ID         NUMBER                         NOT NULL,
  PCS_ID         NUMBER                         NOT NULL,
  UPDATED_BY     VARCHAR2(30 BYTE)              NOT NULL,
  UPDATE_DATE    DATE                           NOT NULL,
  CREATION_DATE  DATE                           NOT NULL,
  CREATED_BY     VARCHAR2(30 BYTE)              NOT NULL
)
LOGGING 
NOCOMPRESS 
NOCACHE
MONITORING;


CREATE TABLE SMS_RISICOS
(
  ID                    NUMBER                  NOT NULL,
  RAE_ID                NUMBER                  NOT NULL,
  KORTE_OMSCHRIJVING    VARCHAR2(100 BYTE),
  OMSCHRIJVING          VARCHAR2(1000 BYTE),
  RISICO_IDENTIFICATIE  VARCHAR2(1000 BYTE),
  GROEPERING            VARCHAR2(100 BYTE),
  REGISTRATIE           VARCHAR2(100 BYTE),
  BUSINESS_IMPACT       VARCHAR2(100 BYTE),
  RISICO_CATEGORIE      VARCHAR2(100 BYTE),
  CATEGORIE_WAARDE      VARCHAR2(1000 BYTE),
  BEHEERSING            VARCHAR2(100 BYTE),
  URGENTIE              VARCHAR2(100 BYTE),
  RAI_ID_EIGENAAR       NUMBER,
  BEDREIGING            VARCHAR2(100 BYTE),
  RISICO_MITIGATIE      VARCHAR2(100 BYTE),
  MATE_VAN_MITIGATIE    VARCHAR2(100 BYTE),
  UPDATED_BY            VARCHAR2(30 BYTE)       NOT NULL,
  UPDATE_DATE           DATE                    NOT NULL,
  CREATION_DATE         DATE                    NOT NULL,
  CREATED_BY            VARCHAR2(30 BYTE)       NOT NULL
)
LOGGING 
NOCOMPRESS 
NOCACHE
MONITORING;


CREATE UNIQUE INDEX SMS_DCT_PK ON SMS_DOCUMENTEN
(ID)
LOGGING;

CREATE INDEX SMS_GBR_IDX1 ON SMS_GEBRUIKER_RACI
(GBR_ID)
LOGGING;

CREATE UNIQUE INDEX SMS_GRI_PK ON SMS_GEBRUIKER_RACI
(ID)
LOGGING;

CREATE UNIQUE INDEX SMS_IPF_PK ON SMS_ISO_PARAGRAFEN
(ID)
LOGGING;

CREATE UNIQUE INDEX SMS_OBW_PK ON SMS_OBW
(ID)
LOGGING;

CREATE UNIQUE INDEX SMS_OBW_UK1 ON SMS_OBW
(MAATREGEL, OGE_ID)
LOGGING;

CREATE UNIQUE INDEX SMS_OHS_PK ON SMS_OBW_HIS
(ID)
LOGGING;

CREATE UNIQUE INDEX SMS_OPS_PK ON SMS_OBW_PROCESSEN
(ID)
LOGGING;

CREATE UNIQUE INDEX SMS_RSO_PK ON SMS_RISICOS
(ID)
LOGGING;

CREATE OR REPLACE TRIGGER SMS_DCT_AS_IU_TRG
  AFTER INSERT OR UPDATE
  ON  sms_documenten
BEGIN
  FOR i IN 1..sms_pck.g_dct_tab.COUNT
  LOOP
    INSERT
    INTO   sms_documenten_back ( id
                               , pk_id
                               , versie
                               , naam
                               , beveiliging
                               , updated_by
                               , update_date
                               , creation_date
                               , created_by
                               , filenaam
                               , doc_content
                               , mimetype
                               , datum_file
                               , rai_id
                               , datum_ingang
                               , datum_einde
                               , dct_ids_vervangt
                               , document_link
                               , controle_frequentie
                               , dst_id
                               , rai_id_eigenaar
                               , status
                               )
    SELECT id
    ,      sms_dctb_sq1.NEXTVAL
    ,      versie
    ,      naam
    ,      beveiliging
    ,      updated_by
    ,      update_date
    ,      creation_date
    ,      created_by
    ,      filenaam
    ,      doc_content
    ,      mimetype
    ,      datum_file
    ,      rai_id
    ,      datum_ingang
    ,      datum_einde
    ,      dct_ids_vervangt
    ,      document_link
    ,      controle_frequentie
    ,      dst_id
    ,      rai_id_eigenaar
    ,      status
    FROM   sms_documenten
    WHERE  id = sms_pck.g_dct_tab(i);
  END LOOP;
END;
/


CREATE OR REPLACE TRIGGER SMS_DCT_BR_IUD_TRG
  BEFORE INSERT OR UPDATE OR DELETE
  ON  sms_documenten
   FOR EACH ROW
BEGIN
  IF INSERTING
  THEN
    IF :NEW.id IS NULL
    THEN
      SELECT sms_dct_sq1.NEXTVAL INTO :NEW.id
      FROM   DUAL;
    END IF;
    :NEW.created_by  := NVL(V('APP_USER'),USER);
    :NEW.creation_date := SYSDATE;
    sms_pck.log_insert('sms_documenten',NULL,:NEW.id);
  END IF;
  IF INSERTING OR UPDATING
  THEN
    IF :NEW.filenaam IS NULL
    AND :OLD.filenaam IS NOT NULL
    THEN
      :NEW.doc_content := NULL;
      :NEW.mimetype := NULL;
      :NEW.datum_file := NULL;
    END IF;
    :NEW.updated_by  := NVL(V('APP_USER'),USER);
    :NEW.update_date := SYSDATE;
    sms_pck.g_dct_tab(sms_pck.g_dct_tab.COUNT+1) := :NEW.id;
  END IF;
  IF UPDATING
  THEN
    sms_pck.log_update('sms_documenten',NULL,:NEW.id);
  END IF;
  IF DELETING
  THEN
    sms_pck.log_delete('SMS_DOCUMENTEN',NULL,:OLD.id);
  END IF;
END;
/


CREATE OR REPLACE TRIGGER SMS_DCT_BS_IU_TRG
  BEFORE INSERT OR UPDATE
  ON  sms_documenten
BEGIN
  sms_pck.g_dct_tab.DELETE;
END;
/


CREATE OR REPLACE TRIGGER SMS_GRI_BR_IUD_TRG
  BEFORE INSERT OR UPDATE OR DELETE
  ON   SMS_GEBRUIKER_RACI
   FOR EACH ROW
BEGIN
  IF INSERTING
  THEN
    SELECT sms_gri_sq1.NEXTVAL INTO :NEW.id
    FROM   DUAL;
    :NEW.created_by  := NVL(V('APP_USER'),USER);
    :NEW.creation_date := SYSDATE;
    sms_pck.log_insert('sms_gebruiker_raci',NULL,:NEW.id);
  END IF;
  IF UPDATING
  THEN
    sms_pck.log_update('sms_gebruiker_raci',NULL,:NEW.id);
  END IF;
  IF INSERTING OR UPDATING
  THEN
    :NEW.updated_by  := NVL(V('APP_USER'),USER);
    :NEW.update_date := SYSDATE;
  END IF;
  IF DELETING
  THEN
    sms_pck.log_delete('sms_gebruiker_raci',NULL,:OLD.id);
  END IF;
END;
/


CREATE OR REPLACE TRIGGER SMS_IPF_AS_I_TRG
  AFTER INSERT
  ON  SMS_ISO_PARAGRAFEN
BEGIN
  FOR i IN 1..sms_pck.g_ipf_tab.COUNT
  LOOP
    INSERT INTO sms_normen (ipf_id) VALUES (sms_pck.g_ipf_tab(i));
  END LOOP;
END;
/


CREATE OR REPLACE TRIGGER sms_ipf_br_iud_trg
  BEFORE INSERT OR UPDATE OR DELETE
  ON  SMS_ISO_PARAGRAFEN
   FOR EACH ROW
BEGIN
  IF INSERTING
  THEN
    SELECT sms_ipf_sq1.NEXTVAL INTO :NEW.id
    FROM   DUAL;
    :NEW.created_by  := NVL(V('APP_USER'),USER);
    :NEW.creation_date := SYSDATE;
    sms_pck.g_ipf_tab(sms_pck.g_ipf_tab.COUNT+1) := :NEW.id;
    sms_pck.log_insert('SMS_ISO_PARAGRAFEN',NULL,:NEW.id);
  END IF;
  IF UPDATING
  THEN
    sms_pck.log_update('SMS_ISO_PARAGRAFEN',NULL,:NEW.id);
  END IF;
  IF INSERTING OR UPDATING
  THEN
    :NEW.updated_by  := NVL(V('APP_USER'),USER);
    :NEW.update_date := SYSDATE;
  END IF;
  IF DELETING
  THEN
    sms_pck.log_delete('sms_iso_paragrafen',NULL,:OLD.id);
  END IF;
END;
/


CREATE OR REPLACE TRIGGER SMS_IPF_BS_I_TRG
  BEFORE INSERT
  ON  SMS_ISO_PARAGRAFEN
BEGIN
  sms_pck.g_ipf_tab.DELETE;
END;
/


CREATE OR REPLACE TRIGGER SMS_OBW2_BR_I_TRG 
  BEFORE INSERT
  ON  sms_obw
   FOR EACH ROW
BEGIN
  IF INSERTING
  THEN
       :NEW.id            := sms_obw_sq1.NEXTVAL;
  END IF;
END;
/


CREATE OR REPLACE TRIGGER SMS_OBW_AS_IU_TRG
  AFTER INSERT OR UPDATE
  ON  sms_obw
BEGIN
  FOR i IN 1..sms_pck.g_obw_tab.COUNT
  LOOP
    INSERT
    INTO   sms_obw_back
    SELECT *
    FROM   sms_obw
    WHERE  id = sms_pck.g_obw_tab(i)
    ;
    sms_pck.verwerk_nrm_string_in_onm ( p_obw_id => sms_pck.g_obw_tab(i)
                                      )
    ;
    sms_pck.verwerk_pcs_string_in_ops ( p_obw_id => sms_pck.g_obw_tab(i)
                                      )
    ;
  END LOOP;
END;
/


CREATE OR REPLACE TRIGGER SMS_OBW_BR_IUD_TRG
  BEFORE INSERT OR UPDATE OR DELETE
  ON  sms_obw
   FOR EACH ROW
BEGIN
  IF INSERTING
  THEN
    sms_pck.log_insert('SMS_OBW',NULL,:NEW.id);
    :NEW.created_by  := NVL(V('APP_USER'),USER);
    :NEW.creation_date := SYSDATE;
  END IF;
  IF INSERTING OR UPDATING
  THEN
    :NEW.updated_by  := NVL(V('APP_USER'),USER);
    :NEW.update_date := SYSDATE;
    sms_pck.g_obw_tab(sms_pck.g_obw_tab.COUNT+1) := :NEW.id;
  END IF;
  IF UPDATING
  THEN
    sms_pck.log_update('SMS_OBW',NULL,:NEW.id);
  END IF;
  IF DELETING
  THEN
    sms_pck.log_delete('SMS_OBW',NULL,:OLD.id);
  END IF;
END;
/


CREATE OR REPLACE TRIGGER SMS_OBW_BS_IU_TRG
  BEFORE INSERT OR UPDATE
  ON  sms_obw
BEGIN
  sms_pck.g_obw_tab.DELETE;
END;
/


CREATE OR REPLACE TRIGGER SMS_OBW_HIS_BR_IU_TRG
  BEFORE INSERT OR UPDATE OR DELETE
  ON  sms_obw_his
   FOR EACH ROW
BEGIN
  IF INSERTING
  THEN
    :NEW.id := sms_ohs_sq1.NEXTVAL;
    sms_pck.log_insert('sms_obw_his',NULL,:NEW.id);
    :NEW.created_by  := NVL(V('APP_USER'),USER);
    :NEW.creation_date := SYSDATE;
  END IF;
  IF INSERTING OR UPDATING
  THEN
    :NEW.updated_by  := NVL(V('APP_USER'),USER);
    :NEW.update_date := SYSDATE;
  END IF;
  IF UPDATING
  THEN
    sms_pck.log_update('sms_obw_his',NULL,:NEW.id);
  END IF;
END;
/


CREATE OR REPLACE TRIGGER SMS_OPS_BR_IUD_TRG
  BEFORE INSERT OR UPDATE OR DELETE
  ON  sms_obw_processen
   FOR EACH ROW
BEGIN
  IF INSERTING
  THEN
    :NEW.id := sms_ops_sq1.NEXTVAL;
    :NEW.created_by  := NVL(V('APP_USER'),USER);
    :NEW.creation_date := SYSDATE;
  END IF;
  IF INSERTING OR UPDATING
  THEN
    :NEW.updated_by  := NVL(V('APP_USER'),USER);
    :NEW.update_date := SYSDATE;
  END IF;
END;
/


CREATE OR REPLACE TRIGGER sms_rso_as_i_trg
  AFTER INSERT
  ON  sms_risicos
BEGIN
  FOR i IN 1..sms_pck.g_rso_tab.COUNT
  LOOP
    INSERT INTO sms_normen (rso_id) VALUES (sms_pck.g_rso_tab(i));
  END LOOP;
END;
/


CREATE OR REPLACE TRIGGER sms_rso_br_iud_trg
  BEFORE INSERT OR UPDATE OR DELETE
  ON  sms_risicos
   FOR EACH ROW
BEGIN
  IF INSERTING
  THEN
    :NEW.created_by  := NVL(V('APP_USER'),USER);
    :NEW.creation_date := SYSDATE;
    :NEW.id            := sms_rso_sq1.NEXTVAL;
    sms_pck.g_rso_tab(sms_pck.g_rso_tab.COUNT+1) := :NEW.id;
    sms_pck.log_insert('sms_risicos',NULL,:NEW.id);
  END IF;
  IF UPDATING
  THEN
    sms_pck.log_update('sms_risicos',NULL,:NEW.id);
  END IF;
  IF INSERTING OR UPDATING
  THEN
    :NEW.updated_by  := NVL(V('APP_USER'),USER);
    :NEW.update_date := SYSDATE;
  END IF;
  IF DELETING
  THEN
    DELETE
    FROM   sms_normen
    WHERE  rso_id = :OLD.id;
  END IF;
  IF DELETING
  THEN
    sms_pck.log_delete('sms_risicos',NULL,:OLD.id);
  END IF;
END;
/


CREATE TABLE SMS_BEVINDINGEN
(
  ID              NUMBER                        NOT NULL,
  OORSPRONG       VARCHAR2(20 BYTE),
  DATUM_GEREED    DATE,
  BESCHRIJVING    VARCHAR2(4000 BYTE),
  GEREED_IND      VARCHAR2(1 BYTE),
  REVIEW_IND      VARCHAR2(1 BYTE),
  CAE_LIJST       VARCHAR2(1000 BYTE),
  ADT_ID          NUMBER,
  UPDATED_BY      VARCHAR2(30 BYTE)             NOT NULL,
  UPDATE_DATE     DATE                          NOT NULL,
  CREATION_DATE   DATE                          NOT NULL,
  CREATED_BY      VARCHAR2(30 BYTE)             NOT NULL,
  OBW_ID          NUMBER                        NOT NULL,
  RAE_ID          NUMBER,
  PJT_ID          NUMBER,
  TOELICHTING_IB  VARCHAR2(4000 BYTE),
  PRIORITEIT      VARCHAR2(20 BYTE)
)
LOGGING 
NOCOMPRESS 
NOCACHE
MONITORING;

COMMENT ON COLUMN SMS_BEVINDINGEN.ID IS 'pk';

COMMENT ON COLUMN SMS_BEVINDINGEN.OORSPRONG IS 'audit of borgingscontrole';

COMMENT ON COLUMN SMS_BEVINDINGEN.DATUM_GEREED IS ' ';

COMMENT ON COLUMN SMS_BEVINDINGEN.BESCHRIJVING IS ' ';

COMMENT ON COLUMN SMS_BEVINDINGEN.GEREED_IND IS ' ';

COMMENT ON COLUMN SMS_BEVINDINGEN.REVIEW_IND IS ' ';

COMMENT ON COLUMN SMS_BEVINDINGEN.CAE_LIJST IS 'litanie met actie ids wordt gebruikt voor shuttle via trigger gesynchroniseerd in bevinding acties';

COMMENT ON COLUMN SMS_BEVINDINGEN.ADT_ID IS 'fk naar audit';


CREATE TABLE SMS_CONTROLES
(
  ID                       NUMBER               NOT NULL,
  RAPPORTAGE               VARCHAR2(4000 BYTE),
  BEHEERSCONTROLE_FO_ISMS  VARCHAR2(4000 BYTE),
  CONTROLE_INHOUD          VARCHAR2(4000 BYTE),
  FREQUENTIE               VARCHAR2(100 BYTE),
  VERWIJDER_IND            VARCHAR2(1 BYTE),
  UPDATED_BY               VARCHAR2(30 BYTE)    NOT NULL,
  UPDATE_DATE              DATE                 NOT NULL,
  CREATION_DATE            DATE                 NOT NULL,
  CREATED_BY               VARCHAR2(30 BYTE)    NOT NULL,
  PCS_ID                   NUMBER,
  RAI_ID_RESP_WERKING      NUMBER,
  OBW_ID                   NUMBER               NOT NULL,
  PRIORITEIT               VARCHAR2(20 BYTE)
)
LOGGING 
NOCOMPRESS 
NOCACHE
MONITORING;

COMMENT ON COLUMN SMS_CONTROLES.ID IS 'pk ';

COMMENT ON COLUMN SMS_CONTROLES.RAPPORTAGE IS 'beschrijving van de rapportage';

COMMENT ON COLUMN SMS_CONTROLES.BEHEERSCONTROLE_FO_ISMS IS 'overbodige kolom bij conversie';

COMMENT ON COLUMN SMS_CONTROLES.CONTROLE_INHOUD IS 'inhoud van de controle';

COMMENT ON COLUMN SMS_CONTROLES.FREQUENTIE IS 'jaarlijks, maandelijks, etc';

COMMENT ON COLUMN SMS_CONTROLES.VERWIJDER_IND IS ' ';


CREATE TABLE SMS_DOCUMENTEN_OBW
(
  ID             NUMBER                         NOT NULL,
  DCT_ID         NUMBER                         NOT NULL,
  VERWIJDER_IND  VARCHAR2(1 BYTE),
  UPDATED_BY     VARCHAR2(30 BYTE)              NOT NULL,
  UPDATE_DATE    DATE                           NOT NULL,
  CREATION_DATE  DATE                           NOT NULL,
  CREATED_BY     VARCHAR2(30 BYTE)              NOT NULL,
  OBW_ID         NUMBER                         NOT NULL
)
LOGGING 
NOCOMPRESS 
NOCACHE
MONITORING;

COMMENT ON COLUMN SMS_DOCUMENTEN_OBW.ID IS ' ';

COMMENT ON COLUMN SMS_DOCUMENTEN_OBW.DCT_ID IS ' ';

COMMENT ON COLUMN SMS_DOCUMENTEN_OBW.VERWIJDER_IND IS 'technische kolom om aan te geven of deze verwijderd moeten worden';


CREATE TABLE SMS_NORMEN
(
  ID             NUMBER                         NOT NULL,
  IPF_ID         NUMBER,
  UPDATED_BY     VARCHAR2(30 BYTE)              NOT NULL,
  UPDATE_DATE    DATE                           NOT NULL,
  CREATION_DATE  DATE                           NOT NULL,
  CREATED_BY     VARCHAR2(30 BYTE)              NOT NULL,
  RSO_ID         NUMBER,
  BPN_ID         NUMBER
)
LOGGING 
NOCOMPRESS 
NOCACHE
MONITORING;

COMMENT ON COLUMN SMS_NORMEN.ID IS ' ';

COMMENT ON COLUMN SMS_NORMEN.IPF_ID IS ' ';


CREATE TABLE SMS_OBW_NORMEN
(
  ID             NUMBER                         NOT NULL,
  OBW_ID         NUMBER                         NOT NULL,
  NRM_ID         NUMBER                         NOT NULL,
  UPDATED_BY     VARCHAR2(30 BYTE)              NOT NULL,
  UPDATE_DATE    DATE                           NOT NULL,
  CREATION_DATE  DATE                           NOT NULL,
  CREATED_BY     VARCHAR2(30 BYTE)              NOT NULL
)
LOGGING 
NOCOMPRESS 
NOCACHE
MONITORING;


CREATE INDEX SMS_BVG_IDX1 ON SMS_BEVINDINGEN
(OBW_ID)
LOGGING;

CREATE UNIQUE INDEX SMS_BVG_PK ON SMS_BEVINDINGEN
(ID)
LOGGING;

CREATE INDEX SMS_CTE_IDX1 ON SMS_CONTROLES
(OBW_ID)
LOGGING;

CREATE UNIQUE INDEX SMS_CTE_PK ON SMS_CONTROLES
(ID)
LOGGING;

CREATE INDEX SMS_DOW_IDX1 ON SMS_DOCUMENTEN_OBW
(OBW_ID)
LOGGING;

CREATE UNIQUE INDEX SMS_DOW_PK ON SMS_DOCUMENTEN_OBW
(ID)
LOGGING;

CREATE UNIQUE INDEX SMS_NRM_PK ON SMS_NORMEN
(ID)
LOGGING;

CREATE UNIQUE INDEX SMS_ONM_PK ON SMS_OBW_NORMEN
(ID)
LOGGING;

CREATE OR REPLACE TRIGGER SMS_BVG_AS_IU_TRG
  AFTER INSERT OR UPDATE
  ON  sms_bevindingen
BEGIN
  FOR i IN 1..sms_pck.g_bvg_tab.COUNT
  LOOP
    sms_pck.werk_cae_string_in_bae ( p_bvg_id => sms_pck.g_bvg_tab(i)
                                   )
    ;
  END LOOP;
END;
/


CREATE OR REPLACE TRIGGER SMS_BVG_BR_IUD_TRG
  BEFORE INSERT OR UPDATE OR DELETE
  ON  sms_bevindingen
   FOR EACH ROW
BEGIN
  IF INSERTING
  THEN
    IF :NEW.id IS NULL
    THEN
      SELECT sms_bvg_sq1.NEXTVAL INTO :NEW.id
      FROM   DUAL;
    END IF;
   :NEW.created_by  := NVL(V('APP_USER'),USER);
   :NEW.creation_date := SYSDATE;
    sms_pck.log_insert('sms_bevindingen',NULL,:NEW.id);
  END IF;
  IF UPDATING
  THEN
    sms_pck.log_update('sms_bevindingen',NULL,:NEW.id);
  END IF;
  IF INSERTING OR UPDATING
  THEN
    :NEW.updated_by  := NVL(V('APP_USER'),USER);
    :NEW.update_date := SYSDATE;
    IF NVL(:NEW.cae_lijst,'X') != NVL(:OLD.cae_lijst,'X')
    AND (:NEW.cae_lijst IS NOT NULL OR :OLD.cae_lijst IS NOT NULL)
    THEN
      sms_pck.g_bvg_tab(sms_pck.g_bvg_tab.COUNT+1) := :NEW.id;
    END IF;
  END IF;
  IF DELETING
  THEN
    DELETE
    FROM  sms_bevinding_acties
    WHERE bvg_id = :OLD.id;
  END IF;
  IF DELETING
  THEN
    sms_pck.log_delete('sms_bevinding_acties',NULL,:OLD.id);
  END IF;
END;
/


CREATE OR REPLACE TRIGGER SMS_BVG_BS_IU_TRG
  BEFORE INSERT OR UPDATE
  ON  sms_bevindingen
BEGIN
  sms_pck.g_bvg_tab.DELETE;
END;
/


CREATE OR REPLACE TRIGGER SMS_CTE_AS_IU_TRG
  AFTER INSERT OR UPDATE
  ON  sms_controles
BEGIN
  FOR i IN 1..sms_pck.g_cte_tab.COUNT
  LOOP
    INSERT
    INTO   sms_controles_back
    SELECT *
    FROM   sms_controles
    WHERE  id = sms_pck.g_cte_tab(i);
  END LOOP;
END;
/


CREATE OR REPLACE TRIGGER SMS_CTE_BR_IUD_TRG
  BEFORE INSERT OR UPDATE OR DELETE
  ON  sms_controles
   FOR EACH ROW
BEGIN
  IF INSERTING
  THEN
    IF :NEW.id IS NULL
    THEN
      SELECT sms_cte_sq1.NEXTVAL INTO :NEW.id
      FROM   DUAL;
    END IF;
    :NEW.created_by  := NVL(V('APP_USER'),USER);
    :NEW.creation_date := SYSDATE;
    sms_pck.log_insert('sms_controles',NULL,:NEW.id);
  END IF;
  IF INSERTING OR UPDATING
  THEN
    :NEW.updated_by  := NVL(V('APP_USER'),USER);
    :NEW.update_date := SYSDATE;
    sms_pck.g_cte_tab(sms_pck.g_cte_tab.COUNT+1) := :NEW.id;
  END IF;
  IF UPDATING
  THEN
    sms_pck.log_update('sms_controles',NULL,:NEW.id);
  END IF;
  IF DELETING
  THEN
    sms_pck.log_delete('sms_controles',NULL,:OLD.id);
  END IF;
END;
/


CREATE OR REPLACE TRIGGER SMS_CTE_BS_IU_TRG
  BEFORE INSERT OR UPDATE
  ON  sms_controles
BEGIN
  sms_pck.g_cte_tab.DELETE;
END;
/


CREATE OR REPLACE TRIGGER SMS_DOW_AS_IU_TRG
  AFTER INSERT OR UPDATE
  ON  sms_documenten_obw
BEGIN
  FOR i IN 1..sms_pck.g_dow_tab.COUNT
  LOOP
    INSERT
    INTO   sms_documenten_obw_back
    SELECT *
    FROM   sms_documenten_obw
    WHERE  id = sms_pck.g_dow_tab(i);
  END LOOP;
END;
/


CREATE OR REPLACE TRIGGER SMS_DOW_BR_IUD_TRG
  BEFORE INSERT OR UPDATE OR DELETE
  ON  sms_documenten_obw
   FOR EACH ROW
BEGIN
  IF INSERTING
  THEN
    SELECT sms_dow_sq1.NEXTVAL INTO :NEW.id
    FROM   DUAL;
    :NEW.created_by  := NVL(V('APP_USER'),USER);
    :NEW.creation_date := SYSDATE;
    sms_pck.log_insert('sms_documenten_obw',NULL,:NEW.id);
  END IF;
  IF INSERTING OR UPDATING
  THEN
    :NEW.updated_by  := NVL(V('APP_USER'),USER);
    :NEW.update_date := SYSDATE;
    sms_pck.g_dow_tab(sms_pck.g_dow_tab.COUNT+1) := :NEW.id;
  END IF;
  IF UPDATING
  THEN
    sms_pck.log_update('sms_documenten_obw',NULL,:NEW.id);
  END IF;
  IF DELETING
  THEN
    sms_pck.log_delete('SMS_DOCUMENTEN_OBW',NULL,:OLD.id);
  END IF;
END;
/


CREATE OR REPLACE TRIGGER SMS_DOW_BS_IU_TRG
  BEFORE INSERT OR UPDATE
  ON  sms_documenten_obw
BEGIN
  sms_pck.g_dow_tab.DELETE;
END;
/


CREATE OR REPLACE TRIGGER SMS_NRM_BR_IUD_TRG
  BEFORE INSERT OR UPDATE OR DELETE
  ON  sms_normen
   FOR EACH ROW
BEGIN
  IF INSERTING
  THEN
    SELECT sms_nrm_sq1.NEXTVAL INTO :NEW.id
    FROM   DUAL;
    :NEW.created_by  := NVL(V('APP_USER'),USER);
    :NEW.creation_date := SYSDATE;
    sms_pck.log_insert('sms_normen',NULL,:NEW.id);
  END IF;
  IF UPDATING
  THEN
    sms_pck.log_update('sms_normen',NULL,:NEW.id);
  END IF;
  IF INSERTING OR UPDATING
  THEN
    :NEW.updated_by  := NVL(V('APP_USER'),USER);
    :NEW.update_date := SYSDATE;
  END IF;
  IF DELETING
  THEN
    sms_pck.log_delete('sms_normen',NULL,:OLD.id);
  END IF;
END;
/


CREATE OR REPLACE TRIGGER SMS_ONM_BR_IUD_TRG
  BEFORE INSERT OR UPDATE OR DELETE
  ON  sms_obw_normen
   FOR EACH ROW
BEGIN
  IF INSERTING
  THEN
    :NEW.id := sms_onm_sq1.NEXTVAL;
    :NEW.created_by  := NVL(V('APP_USER'),USER);
    :NEW.creation_date := SYSDATE;
  END IF;
  IF INSERTING OR UPDATING
  THEN
    :NEW.updated_by  := NVL(V('APP_USER'),USER);
    :NEW.update_date := SYSDATE;
  END IF;
END;
/


CREATE TABLE SMS_ACTIES
(
  ID                              NUMBER        NOT NULL,
  CTE_ID                          NUMBER,
  DCT_ID                          NUMBER,
  BVG_ID                          NUMBER,
  DATUM_UITVOERING                DATE,
  RAI_ID                          NUMBER,
  DATUM_RAPPORTAGE                DATE,
  STATUS                          VARCHAR2(20 BYTE),
  BEVINDINGEN                     VARCHAR2(4000 BYTE),
  FILENAAM                        VARCHAR2(200 BYTE),
  DOC_CONTENT                     BLOB,
  MIMETYPE                        VARCHAR2(100 BYTE),
  DATUM_FILE                      DATE,
  AFWIJKINGEN_INDICATOR           VARCHAR2(1 BYTE),
  TOELICHTING_AFWIJKING           VARCHAR2(4000 BYTE),
  CALLNR                          VARCHAR2(10 BYTE),
  UPDATED_BY                      VARCHAR2(30 BYTE) NOT NULL,
  UPDATE_DATE                     DATE          NOT NULL,
  CREATION_DATE                   DATE          NOT NULL,
  CREATED_BY                      VARCHAR2(30 BYTE) NOT NULL,
  AFWIJKING_HERSTELD_INDICATOR    VARCHAR2(1 BYTE),
  AFWIJKING_HERSTELD_TOELICHTING  VARCHAR2(4000 BYTE),
  OPMERKING                       VARCHAR2(1000 BYTE),
  PRIORITEIT                      VARCHAR2(20 BYTE)
)
LOGGING 
NOCOMPRESS 
NOCACHE
MONITORING;

COMMENT ON COLUMN SMS_ACTIES.ID IS 'pk';

COMMENT ON COLUMN SMS_ACTIES.CTE_ID IS 'fk naar controle';

COMMENT ON COLUMN SMS_ACTIES.DCT_ID IS 'fk naar document';

COMMENT ON COLUMN SMS_ACTIES.BVG_ID IS 'fk naar bevinding';

COMMENT ON COLUMN SMS_ACTIES.DATUM_UITVOERING IS ' ';

COMMENT ON COLUMN SMS_ACTIES.RAI_ID IS 'uitvoerder';

COMMENT ON COLUMN SMS_ACTIES.DATUM_RAPPORTAGE IS ' ';

COMMENT ON COLUMN SMS_ACTIES.STATUS IS 'gepland, in behandeling, afgerond';

COMMENT ON COLUMN SMS_ACTIES.BEVINDINGEN IS 'verslaglegging';

COMMENT ON COLUMN SMS_ACTIES.FILENAAM IS 'naam van het fysieke document';

COMMENT ON COLUMN SMS_ACTIES.DOC_CONTENT IS ' ';

COMMENT ON COLUMN SMS_ACTIES.AFWIJKINGEN_INDICATOR IS 'Ja/nee';

COMMENT ON COLUMN SMS_ACTIES.TOELICHTING_AFWIJKING IS 'indien afwijkend';

COMMENT ON COLUMN SMS_ACTIES.CALLNR IS 'assyst callnummer';


CREATE TABLE SMS_BEVINDING_ACTIES
(
  ID             NUMBER                         NOT NULL,
  CAE_ID         NUMBER                         NOT NULL,
  BVG_ID         NUMBER                         NOT NULL,
  UPDATED_BY     VARCHAR2(30 BYTE)              NOT NULL,
  UPDATE_DATE    DATE                           NOT NULL,
  CREATION_DATE  DATE                           NOT NULL,
  CREATED_BY     VARCHAR2(30 BYTE)              NOT NULL
)
LOGGING 
NOCOMPRESS 
NOCACHE
MONITORING;

COMMENT ON COLUMN SMS_BEVINDING_ACTIES.ID IS 'pk';

COMMENT ON COLUMN SMS_BEVINDING_ACTIES.CAE_ID IS 'fk naar actie';

COMMENT ON COLUMN SMS_BEVINDING_ACTIES.BVG_ID IS 'fk naar bevinding';


CREATE UNIQUE INDEX SMS_BAE_PK ON SMS_BEVINDING_ACTIES
(ID)
LOGGING;

CREATE UNIQUE INDEX SMS_CAE_PK ON SMS_ACTIES
(ID)
LOGGING;

CREATE OR REPLACE TRIGGER SMS_BAE_BR_IUD_TRG
  BEFORE INSERT OR UPDATE OR DELETE
  ON  sms_bevinding_acties
   FOR EACH ROW
BEGIN
  IF INSERTING
  THEN
    SELECT sms_bae_sq1.NEXTVAL INTO :NEW.id
    FROM   DUAL;
    :NEW.created_by  := NVL(V('APP_USER'),USER);
    :NEW.creation_date := SYSDATE;
    sms_pck.log_insert('SMS_BEVINDING_ACTIES',NULL,:NEW.id);
  END IF;
  IF UPDATING
  THEN
    sms_pck.log_update('SMS_BEVINDING_ACTIES',NULL,:NEW.id);
  END IF;
  IF INSERTING OR UPDATING
  THEN
    :NEW.updated_by  := NVL(V('APP_USER'),USER);
    :NEW.update_date := SYSDATE;
  END IF;
  IF DELETING
  THEN
    sms_pck.log_delete('sms_bevinding_acties',NULL,:OLD.id);
  END IF;
END;
/


CREATE OR REPLACE TRIGGER SMS_CAE_BR_IUD_TRG
  BEFORE INSERT OR UPDATE OR DELETE
  ON  sms_acties
   FOR EACH ROW
BEGIN
  IF INSERTING
  THEN
    SELECT sms_cae_sq1.NEXTVAL INTO :NEW.id
    FROM   DUAL;
    :NEW.created_by  := NVL(V('APP_USER'),USER);
    :NEW.creation_date := SYSDATE;
    sms_pck.log_insert('sms_acties',:NEW.status,:NEW.id);
  END IF;
  IF UPDATING
  THEN
    IF :NEW.filenaam IS NULL
    AND :OLD.filenaam IS NOT NULL
    THEN
      :NEW.doc_content := NULL;
      :NEW.mimetype := NULL;
      :NEW.datum_file := NULL;
    END IF;
    sms_pck.log_update('sms_acties',:NEW.status,:NEW.id);
  END IF;
  IF INSERTING OR UPDATING
  THEN
    :NEW.updated_by  := NVL(V('APP_USER'),USER);
    :NEW.update_date := SYSDATE;
  END IF;
  IF DELETING
  THEN
    sms_pck.log_delete('sms_acties',NULL,:OLD.id);
  END IF;
END;
/


ALTER TABLE SBN_MAATREGELEN ADD (
  CONSTRAINT SBN_MAATREGELEN_PK
  PRIMARY KEY
  (MR_ID)
  USING INDEX SBN_MAATREGELEN_PK
  ENABLE VALIDATE);

ALTER TABLE SMS_APPLICATIE_REGISTER ADD (
  CONSTRAINT SMS_ARR_PK
  PRIMARY KEY
  (APPLICATIE, VARIABELE)
  USING INDEX SMS_ARR_PK
  ENABLE VALIDATE);

ALTER TABLE SMS_AUDITS ADD (
  CONSTRAINT SMS_ADT_PK
  PRIMARY KEY
  (ID)
  USING INDEX SMS_ADT_PK
  ENABLE VALIDATE);

ALTER TABLE SMS_BEHANDELPLANNEN ADD (
  CONSTRAINT SMS_BPN_PK
  PRIMARY KEY
  (ID)
  USING INDEX SMS_BPN_PK
  ENABLE VALIDATE);

ALTER TABLE SMS_DOCUMENTEN_BACK ADD (
  CONSTRAINT SMS_DCTB_PK
  PRIMARY KEY
  (PK_ID)
  USING INDEX SMS_DCTB_PK
  ENABLE VALIDATE);

ALTER TABLE SMS_DOCUMENT_SOORTEN ADD (
  CONSTRAINT SMS_DST_PK
  PRIMARY KEY
  (ID)
  USING INDEX SMS_DST_PK
  ENABLE VALIDATE);

ALTER TABLE SMS_FOUTENLOG ADD (
  CONSTRAINT SMS_FLG_PK
  PRIMARY KEY
  (ID)
  USING INDEX SMS_FLG_PK
  ENABLE VALIDATE);

ALTER TABLE SMS_FOUT_BOODSCHAPPEN ADD (
  CONSTRAINT SMS_FBP_PK
  PRIMARY KEY
  (ID)
  USING INDEX SMS_FBP_PK
  ENABLE VALIDATE);

ALTER TABLE SMS_GEBRUIKERS ADD (
  CONSTRAINT AVCON_GBR_VERVA_001
  CHECK (VERVALLEN_IND IN ('J', 'N'))
  ENABLE VALIDATE,
  CONSTRAINT SMS_GBR_PK
  PRIMARY KEY
  (ID)
  USING INDEX SMS_GBR_PK
  ENABLE VALIDATE,
  CONSTRAINT SMS_GBR_UK1
  UNIQUE (WINDOWS_USER)
  USING INDEX SMS_GBR_UK1
  ENABLE VALIDATE);

ALTER TABLE SMS_GEBRUIKER_ROLLEN ADD (
  CONSTRAINT SMS_GRL_PK
  PRIMARY KEY
  (ID)
  USING INDEX SMS_GRL_PK
  ENABLE VALIDATE,
  CONSTRAINT SMS_GRL_UK1
  UNIQUE (ROL_ID, GBR_ID)
  USING INDEX SMS_GPL_UK1
  ENABLE VALIDATE);

ALTER TABLE SMS_ISO_HOOFDSTUKKEN ADD (
  CONSTRAINT SMS_IHK_PK
  PRIMARY KEY
  (ID)
  USING INDEX SMS_IHK_PK
  ENABLE VALIDATE);

ALTER TABLE SMS_ISO_SECTIES ADD (
  CONSTRAINT SMS_ISE_PK
  PRIMARY KEY
  (ID)
  USING INDEX SMS_ISE_PK
  ENABLE VALIDATE);

ALTER TABLE SMS_LOG_TRANSACTIES ADD (
  CONSTRAINT SMS_LTE_PK
  PRIMARY KEY
  (ID)
  USING INDEX SMS_LTE_PK
  ENABLE VALIDATE);

ALTER TABLE SMS_OBW_WIJZIG ADD (
  CONSTRAINT SMS_OBWB_PK
  PRIMARY KEY
  (ID)
  USING INDEX SMS_OBWB_PK
  ENABLE VALIDATE);

ALTER TABLE SMS_ORGANISATIES ADD (
  CONSTRAINT SMS_OGE_PK
  PRIMARY KEY
  (ID)
  USING INDEX SMS_OGE_PK
  ENABLE VALIDATE);

ALTER TABLE SMS_PROCESSEN ADD (
  CONSTRAINT SMS_PCS_PK
  PRIMARY KEY
  (ID)
  USING INDEX SMS_PCS_PK
  ENABLE VALIDATE);

ALTER TABLE SMS_PROJECTEN ADD (
  CONSTRAINT SMS_PJT_PK
  PRIMARY KEY
  (ID)
  USING INDEX SMS_PJT_PK
  ENABLE VALIDATE);

ALTER TABLE SMS_RACI ADD (
  CONSTRAINT SMS_RAI_PK
  PRIMARY KEY
  (ID)
  USING INDEX SMS_RAI_PK
  ENABLE VALIDATE);

ALTER TABLE SMS_RISICO_ANALYSES ADD (
  CONSTRAINT SMS_RAE_PK
  PRIMARY KEY
  (ID)
  USING INDEX SMS_RAE_PK
  ENABLE VALIDATE);

ALTER TABLE SMS_VERANTWOORDINGEN ADD (
  CONSTRAINT SMS_VAG_PK
  PRIMARY KEY
  (ID)
  USING INDEX SMS_VAG_PK
  ENABLE VALIDATE);

ALTER TABLE SMS_DOCUMENTEN ADD (
  CONSTRAINT SMS_DCT_PK
  PRIMARY KEY
  (ID)
  USING INDEX SMS_DCT_PK
  ENABLE VALIDATE);

ALTER TABLE SMS_GEBRUIKER_RACI ADD (
  CONSTRAINT SMS_GRI_PK
  PRIMARY KEY
  (ID)
  USING INDEX SMS_GRI_PK
  ENABLE VALIDATE);

ALTER TABLE SMS_ISO_PARAGRAFEN ADD (
  CONSTRAINT SMS_IPF_PK
  PRIMARY KEY
  (ID)
  USING INDEX SMS_IPF_PK
  ENABLE VALIDATE);

ALTER TABLE SMS_OBW ADD (
  CONSTRAINT SMS_OBW_PK
  PRIMARY KEY
  (ID)
  USING INDEX SMS_OBW_PK
  ENABLE VALIDATE);

ALTER TABLE SMS_OBW_HIS ADD (
  CONSTRAINT SMS_OHS_PK
  PRIMARY KEY
  (ID)
  USING INDEX SMS_OHS_PK
  ENABLE VALIDATE);

ALTER TABLE SMS_OBW_PROCESSEN ADD (
  CONSTRAINT SMS_OPS_PK
  PRIMARY KEY
  (ID)
  USING INDEX SMS_OPS_PK
  ENABLE VALIDATE);

ALTER TABLE SMS_RISICOS ADD (
  CONSTRAINT SMS_RSO_PK
  PRIMARY KEY
  (ID)
  USING INDEX SMS_RSO_PK
  ENABLE VALIDATE);

ALTER TABLE SMS_BEVINDINGEN ADD (
  CONSTRAINT SMS_BVG_PK
  PRIMARY KEY
  (ID)
  USING INDEX SMS_BVG_PK
  ENABLE VALIDATE);

ALTER TABLE SMS_CONTROLES ADD (
  CONSTRAINT SMS_CTE_PK
  PRIMARY KEY
  (ID)
  USING INDEX SMS_CTE_PK
  ENABLE VALIDATE);

ALTER TABLE SMS_DOCUMENTEN_OBW ADD (
  CONSTRAINT SMS_DOW_PK
  PRIMARY KEY
  (ID)
  USING INDEX SMS_DOW_PK
  ENABLE VALIDATE);

ALTER TABLE SMS_NORMEN ADD (
  CONSTRAINT SMS_NRM_PK
  PRIMARY KEY
  (ID)
  USING INDEX SMS_NRM_PK
  ENABLE VALIDATE);

ALTER TABLE SMS_OBW_NORMEN ADD (
  CONSTRAINT SMS_ONM_PK
  PRIMARY KEY
  (ID)
  USING INDEX SMS_ONM_PK
  ENABLE VALIDATE);

ALTER TABLE SMS_ACTIES ADD (
  CONSTRAINT SMS_CAE_PK
  PRIMARY KEY
  (ID)
  USING INDEX SMS_CAE_PK
  ENABLE VALIDATE);

ALTER TABLE SMS_BEVINDING_ACTIES ADD (
  CONSTRAINT SMS_BAE_PK
  PRIMARY KEY
  (ID)
  USING INDEX SMS_BAE_PK
  ENABLE VALIDATE);

ALTER TABLE SMS_GEBRUIKER_ROLLEN ADD (
  CONSTRAINT SMS_GRL_FK1 
  FOREIGN KEY (GBR_ID) 
  REFERENCES SMS_GEBRUIKERS (ID)
  ENABLE VALIDATE);

ALTER TABLE SMS_ISO_SECTIES ADD (
  CONSTRAINT SMS_ISE_FK1 
  FOREIGN KEY (IHK_ID) 
  REFERENCES SMS_ISO_HOOFDSTUKKEN (ID)
  ENABLE VALIDATE);

ALTER TABLE SMS_DOCUMENTEN ADD (
  CONSTRAINT SMS_DCT_FK1 
  FOREIGN KEY (RAI_ID) 
  REFERENCES SMS_RACI (ID)
  ENABLE VALIDATE,
  CONSTRAINT SMS_DCT_FK2 
  FOREIGN KEY (DST_ID) 
  REFERENCES SMS_DOCUMENT_SOORTEN (ID)
  ENABLE VALIDATE,
  CONSTRAINT SMS_DCT_FK3 
  FOREIGN KEY (RAI_ID_EIGENAAR) 
  REFERENCES SMS_RACI (ID)
  ENABLE VALIDATE,
  CONSTRAINT SMS_DOCUMENTEN_FK4 
  FOREIGN KEY (OGE_ID) 
  REFERENCES SMS_ORGANISATIES (ID)
  ENABLE VALIDATE);

ALTER TABLE SMS_GEBRUIKER_RACI ADD (
  CONSTRAINT SMS_GRI_FK1 
  FOREIGN KEY (RAI_ID) 
  REFERENCES SMS_RACI (ID)
  ENABLE VALIDATE,
  CONSTRAINT SMS_GRI_FK2 
  FOREIGN KEY (GBR_ID) 
  REFERENCES SMS_GEBRUIKERS (ID)
  ENABLE VALIDATE);

ALTER TABLE SMS_ISO_PARAGRAFEN ADD (
  CONSTRAINT SMS_IPF_FK1 
  FOREIGN KEY (ISE_ID) 
  REFERENCES SMS_ISO_SECTIES (ID)
  ENABLE VALIDATE);

ALTER TABLE SMS_OBW ADD (
  CONSTRAINT SMS_OBW_FK2 
  FOREIGN KEY (RAI_ID_EIGENAAR) 
  REFERENCES SMS_RACI (ID)
  ENABLE VALIDATE,
  CONSTRAINT SMS_OBW_FK3 
  FOREIGN KEY (RAI_ID_BEHEERDER) 
  REFERENCES SMS_RACI (ID)
  ENABLE VALIDATE,
  CONSTRAINT SMS_OBW_FK4 
  FOREIGN KEY (OGE_ID) 
  REFERENCES SMS_ORGANISATIES (ID)
  ENABLE VALIDATE);

ALTER TABLE SMS_OBW_HIS ADD (
  CONSTRAINT SMS_OHS_FK1 
  FOREIGN KEY (IPF_ID) 
  REFERENCES SMS_ISO_PARAGRAFEN (ID)
  ENABLE VALIDATE);

ALTER TABLE SMS_OBW_PROCESSEN ADD (
  CONSTRAINT SMS_OPS_FK1 
  FOREIGN KEY (OBW_ID) 
  REFERENCES SMS_OBW (ID)
  ENABLE VALIDATE,
  CONSTRAINT SMS_OPS_FK2 
  FOREIGN KEY (PCS_ID) 
  REFERENCES SMS_PROCESSEN (ID)
  ENABLE VALIDATE);

ALTER TABLE SMS_RISICOS ADD (
  CONSTRAINT SMS_RSO_FK1 
  FOREIGN KEY (RAE_ID) 
  REFERENCES SMS_RISICO_ANALYSES (ID)
  ENABLE VALIDATE);

ALTER TABLE SMS_BEVINDINGEN ADD (
  CONSTRAINT SMS_BVG_FK1 
  FOREIGN KEY (OBW_ID) 
  REFERENCES SMS_OBW (ID)
  ENABLE VALIDATE,
  CONSTRAINT SMS_BVG_FK2 
  FOREIGN KEY (ADT_ID) 
  REFERENCES SMS_AUDITS (ID)
  ENABLE VALIDATE,
  CONSTRAINT SMS_BVG_FK3 
  FOREIGN KEY (RAE_ID) 
  REFERENCES SMS_RISICO_ANALYSES (ID)
  ENABLE VALIDATE,
  CONSTRAINT SMS_BVG_FK4 
  FOREIGN KEY (PJT_ID) 
  REFERENCES SMS_PROJECTEN (ID)
  ENABLE VALIDATE);

ALTER TABLE SMS_CONTROLES ADD (
  CONSTRAINT SMS_CTE_FK1 
  FOREIGN KEY (OBW_ID) 
  REFERENCES SMS_OBW (ID)
  ENABLE VALIDATE,
  CONSTRAINT SMS_CTE_FK2 
  FOREIGN KEY (PCS_ID) 
  REFERENCES SMS_PROCESSEN (ID)
  ENABLE VALIDATE);

ALTER TABLE SMS_DOCUMENTEN_OBW ADD (
  CONSTRAINT SMS_DOW_FK1 
  FOREIGN KEY (OBW_ID) 
  REFERENCES SMS_OBW (ID)
  ENABLE VALIDATE);

ALTER TABLE SMS_NORMEN ADD (
  CONSTRAINT SMS_NRM_FK1 
  FOREIGN KEY (IPF_ID) 
  REFERENCES SMS_ISO_PARAGRAFEN (ID)
  ENABLE VALIDATE,
  CONSTRAINT SMS_NRM_FK2 
  FOREIGN KEY (RSO_ID) 
  REFERENCES SMS_RISICOS (ID)
  ENABLE VALIDATE,
  CONSTRAINT SMS_NRM_FK3 
  FOREIGN KEY (BPN_ID) 
  REFERENCES SMS_BEHANDELPLANNEN (ID)
  ENABLE VALIDATE);

ALTER TABLE SMS_OBW_NORMEN ADD (
  CONSTRAINT SMS_ONM_FK1 
  FOREIGN KEY (OBW_ID) 
  REFERENCES SMS_OBW (ID)
  ENABLE VALIDATE,
  CONSTRAINT SMS_ONM_FK2 
  FOREIGN KEY (NRM_ID) 
  REFERENCES SMS_NORMEN (ID)
  ENABLE VALIDATE);

ALTER TABLE SMS_ACTIES ADD (
  CONSTRAINT SMS_CAE_FK1 
  FOREIGN KEY (CTE_ID) 
  REFERENCES SMS_CONTROLES (ID)
  ENABLE VALIDATE,
  CONSTRAINT SMS_CAE_FK2 
  FOREIGN KEY (DCT_ID) 
  REFERENCES SMS_DOCUMENTEN (ID)
  ENABLE VALIDATE,
  CONSTRAINT SMS_CAE_FK3 
  FOREIGN KEY (BVG_ID) 
  REFERENCES SMS_BEVINDINGEN (ID)
  ENABLE VALIDATE,
  CONSTRAINT SMS_CAE_FK4 
  FOREIGN KEY (RAI_ID) 
  REFERENCES SMS_RACI (ID)
  ENABLE VALIDATE);

ALTER TABLE SMS_BEVINDING_ACTIES ADD (
  CONSTRAINT SMS_BAE_FK1 
  FOREIGN KEY (CAE_ID) 
  REFERENCES SMS_ACTIES (ID)
  ENABLE VALIDATE,
  CONSTRAINT SMS_BAE_FK2 
  FOREIGN KEY (BVG_ID) 
  REFERENCES SMS_BEVINDINGEN (ID)
  ENABLE VALIDATE);
