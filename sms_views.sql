CREATE OR REPLACE FORCE EDITIONABLE VIEW  "APX_V_ROLLEN" ("ID", "SCHEMA", "NAAM", "OMSCHRIJVING", "SCHERM_IND") AS 
  SELECT "ID", 
          "SCHEMA", 
          "NAAM", 
          "OMSCHRIJVING", 
          "SCHERM_IND" 
     FROM APX_ROLLEN
/



CREATE OR REPLACE FORCE EDITIONABLE VIEW  "APX_V_ROLLEN_HIERARCHIE" ("HOOFDROL_ID", "SCHEMA", "HOOFDROL", "SUBROL_ID", "SUBROL", "TOEKENNINGSPAD") AS 
  SELECT DISTINCT 
              r.id rol_id, 
              r.schema schema, 
              r.naam rol, 
              REGEXP_SUBSTR (SYS_CONNECT_BY_PATH (r.id, '/'), '[[:digit:]]+') subrol_id -- selecteer de string tussen de eerste en tweede slash van het 
                                                             -- toekenningspad 
              , 
              SUBSTR (SYS_CONNECT_BY_PATH (r.naam, '/') || '/', 
                      2, 
                        INSTR (SYS_CONNECT_BY_PATH (r.naam, '/') || '/', 
                               '/', 
                               1, 
                               2) 
                      - 2) 
                 subrol, 
              SYS_CONNECT_BY_PATH (r.naam, '/') toekenningspad 
         FROM apx_rollen r 
              LEFT OUTER JOIN apx_subrollen s ON s.hoofdrol_id = r.id 
   CONNECT BY NOCYCLE PRIOR r.id = s.subrol_id
/

CREATE OR REPLACE FORCE EDITIONABLE VIEW  "APX_V_SUBROLLEN" ("ID", "HOOFDROL_ID", "SUBROL_ID") AS 
  SELECT SRL.ID ID, SRL.HOOFDROL_ID HOOFDROL_ID, SRL.SUBROL_ID SUBROL_ID 
     FROM apx_subrollen srl
/



/* Formatted on 5-24-2017 2:48:02  (QP5 v5.287) */
CREATE OR REPLACE FORCE VIEW SMS_D_AUDITS
(
   AUD_ID,
   AUD_OMSCHRIJVING,
   AUD_SOORT,
   AUD_DATUM_INGANG,
   AUD_DATUM_EINDE,
   AUD_OPZET
)
AS
   SELECT id aud_id,
          omschrijving aud_omschrijving,
          soort aud_soort,
          datum_ingang aud_datum_ingang,
          datum_einde aud_datum_einde,
          opzet aud_opzet
     FROM sms_audits;


/* Formatted on 5-24-2017 2:48:02  (QP5 v5.287) */
CREATE OR REPLACE FORCE VIEW SMS_D_DOCUMENTEN
(
   DOC_ID,
   DOC_BEHEERDER,
   DOC_VERSIE,
   DOC_NAAM,
   DOC_BEVEILIGING,
   DOC_FILENAAM,
   DOC_DATUM_INGANG,
   DOC_DATUM_EINDE,
   DOC_CONTROLE_FREQUENTIE,
   DOC_IGENAAR,
   DOC_STATUS,
   DOC_DOCUMENT_SOORT
)
AS
   SELECT id doc_id,
          sms_pck.functie_naam (rai_id) doc_beheerder,
          versie doc_versie,
          naam doc_naam,
          beveiliging doc_beveiliging,
          filenaam doc_filenaam,
          datum_ingang doc_datum_ingang,
          datum_einde doc_datum_einde,
          controle_frequentie doc_controle_frequentie,
          sms_pck.functie_naam (rai_id_eigenaar) doc_igenaar,
          status doc_status,
          sms_pck.document_soort (dst_id) doc_document_soort
     FROM sms_documenten;


/* Formatted on 5-24-2017 2:48:02  (QP5 v5.287) */
CREATE OR REPLACE FORCE VIEW SMS_D_DOCUMENT_SOORTEN
(
   ID,
   SOORT
)
AS
   SELECT id, soort FROM sms_document_soorten;


/* Formatted on 5-24-2017 2:48:02  (QP5 v5.287) */
CREATE OR REPLACE FORCE VIEW SMS_D_OBW
(
   OBW_ID,
   OBW_MAATREGEL,
   OBW_CLASSIFICATIE,
   OBW_MAATREGELINHOUD,
   OBW_SCOPE,
   OBW_INTERPRETATIE,
   OBW_OPZET,
   OBW_OPMERKING,
   OBW_CONTROLEPLAN,
   OBW_DATUM_INGANG,
   OBW_DATUM_EINDE,
   OBW_EIGENAAR,
   OBW_BEHEER,
   OBW_NORMEN,
   OBW_PROCESSEN,
   OBW_ORGANISATIE,
   OBW_PRIORITEIT
)
AS
   SELECT id obw_id,
          maatregel obw_maatregel,
          classificatie obw_classificatie,
          sbni_maatregelinhoud obw_maatregelinhoud,
          scope obw_scope,
          interpretatie obw_interpretatie,
          hoe_werkt_het obw_opzet,
          toelichting_ib_programma obw_opmerking,
          borging_controleplan obw_controleplan,
          datum_ingang obw_datum_ingang,
          datum_einde obw_datum_einde,
          sms_pck.functie_naam (rai_id_eigenaar) obw_eigenaar,
          sms_pck.functie_naam (rai_id_beheerder) obw_beheer,
          sms_pck.normstring_naar_tekst (nrm_ids) obw_normen,
          sms_pck.processtring_naar_tekst (pcs_ids) obw_processen,
          sms_pck.organisaties_naam (pin_oge_id => oge_id) obw_organisatie,
          prioriteit
     FROM sms_obw;


/* Formatted on 5-24-2017 2:48:02  (QP5 v5.287) */
CREATE OR REPLACE FORCE VIEW SMS_D_PROCESSEN
(
   ID,
   PROCES
)
AS
   SELECT id, naam proces FROM sms_processen;


/* Formatted on 5-24-2017 2:48:02  (QP5 v5.287) */
CREATE OR REPLACE FORCE VIEW SMS_V_ACTIE_TOTALEN
(
   AFGEROND,
   OPEN,
   BRON,
   EIGENAAR,
   BEHEERDER,
   JAAR
)
AS
     SELECT SUM (afgerond) afgerond,
            SUM (open) open,
            bron,
            eigenaar,
            beheerder,
            jaar
       FROM (SELECT bron,
                    DECODE (NVL (obw_id, -1),
                            -1, sms_pck.bepaal_doc_eigenaar (dct_id),
                            sms_pck.bepaal_obw_eigenaar (p_obw_id => obw_id))
                       eigenaar,
                    DECODE (NVL (obw_id, -1),
                            -1, sms_pck.bepaal_doc_beheerder (dct_id),
                            sms_pck.bepaal_obw_beheerder (p_obw_id => obw_id))
                       beheerder,
                    DECODE (status, 'Afgerond', 1, 0) afgerond,
                    DECODE (status, 'Afgerond', 0, 1) open,
                    jaar
               FROM (SELECT sms_pck.herkomst_type (t.cte_id,
                                                   t.dct_id,
                                                   t.bvg_id)
                               bron,
                            dct_id,
                            sms_pck.bepaal_maatregel (bvg_id, dct_id, cte_id)
                               obw_id,
                            t.status,
                            EXTRACT (YEAR FROM t.datum_uitvoering) jaar
                       FROM sms_acties t))
   GROUP BY bron,
            eigenaar,
            beheerder,
            jaar;


/* Formatted on 5-24-2017 2:48:02  (QP5 v5.287) */
CREATE OR REPLACE FORCE VIEW SMS_V_DOCUMENTEN_GEBRUIKER
(
   DCT_ID
)
AS
   SELECT DISTINCT dct.id dct_id
     FROM sms_gebruiker_raci gri, sms_documenten dct
    WHERE     (dct.rai_id = gri.rai_id OR dct.rai_id_eigenaar = gri.rai_id)
          AND sms_pck.sms_gebruikers_id (p_windows_user => V ('APP_USER')) =
                 gri.gbr_id
   UNION
   SELECT DISTINCT dct.id dct_id
     FROM sms_gebruiker_raci gri, sms_documenten dct, sms_raci rai
    WHERE     (dct.rai_id = rai.id OR dct.rai_id_eigenaar = rai.id)
          AND rai.rai_id_ibs = gri.rai_id
          AND sms_pck.sms_gebruikers_id (p_windows_user => V ('APP_USER')) =
                 gri.gbr_id
   UNION
   SELECT dct.id
     FROM sms_documenten dct
    WHERE EXISTS
             (SELECT 'X'
                FROM sms_gebruiker_raci gri
               WHERE     1 = 1
                     AND sms_pck.sms_gebruikers_id (
                            p_windows_user   => V ('APP_USER')) = gri.gbr_id
                     AND gri.rai_id IN (SELECT id
                                          FROM sms_raci
                                         WHERE functie = 'BEHEERDER'))
   UNION
   SELECT dct.id
     FROM sms_documenten dct
    WHERE V ('APP_USER') = 'SMS_ADMIN';


/* Formatted on 5-24-2017 2:48:02  (QP5 v5.287) */
CREATE OR REPLACE FORCE VIEW SMS_V_ISO
(
   HOOFDSTUK_NR,
   HOOFDSTUK_TITEL,
   REGELGEVING,
   JAAR,
   SECTIE_NR,
   SECTIE_TITEL,
   SECTIE_DOEL,
   ID,
   PARAGRAAF_NR,
   PARAGRAAF_TITEL,
   NORM,
   COMMENTAAR,
   TOELICHTING,
   VERANTWOORDELIJK,
   REDEN_UITSLUITING,
   SELECTIE_REDEN,
   ORGANISATIE_IND,
   LEVERANCIER_IND,
   IHK_ID,
   ISE_ID
)
AS
   SELECT ihk.hoofdstuk_nr,
          ihk.hoofdstuk_titel,
          ihk.regelgeving,
          ihk.jaar,
          ise.sectie_nr,
          ise.sectie_titel,
          ise.sectie_doel,
          ipf.id,
          ipf.paragraaf_nr,
          ipf.paragraaf_titel,
          ipf.norm,
          ipf.commentaar,
          ipf.toelichting,
          ipf.verantwoordelijk,
          ipf.reden_uitsluiting,
          ipf.selectie_reden,
          ipf.organisatie_ind,
          ipf.leverancier_ind,
          ihk.id ihk_id,
          ise.id ise_id
     FROM sms_iso_hoofdstukken ihk,
          sms_iso_secties ise,
          sms_iso_paragrafen ipf
    WHERE ihk.id = ise.ihk_id AND ise.id = ipf.ise_id(+)
   UNION ALL
   (SELECT ihk.hoofdstuk_nr,
           ihk.hoofdstuk_titel,
           ihk.regelgeving,
           ihk.jaar,
           NULL,
           NULL,
           NULL,
           NULL,
           NULL,
           NULL,
           NULL,
           NULL,
           NULL,
           NULL,
           NULL,
           NULL,
           NULL,
           NULL,
           ihk.id ihk_id,
           NULL
      FROM sms_iso_hoofdstukken ihk
    MINUS
    SELECT ihk.hoofdstuk_nr,
           ihk.hoofdstuk_titel,
           ihk.regelgeving,
           ihk.jaar,
           NULL,
           NULL,
           NULL,
           NULL,
           NULL,
           NULL,
           NULL,
           NULL,
           NULL,
           NULL,
           NULL,
           NULL,
           NULL,
           NULL,
           ihk.id ihk_id,
           NULL
      FROM sms_iso_hoofdstukken ihk, sms_iso_secties ise
     WHERE ihk.id = ise.ihk_id);


/* Formatted on 5-24-2017 2:48:02  (QP5 v5.287) */
CREATE OR REPLACE FORCE VIEW SMS_V_OBW
(
   ID,
   MAATREGEL
)
AS
   SELECT id, maatregel FROM sms_owner.sms_obw;


/* Formatted on 5-24-2017 2:48:02  (QP5 v5.287) */
CREATE OR REPLACE FORCE VIEW SMS_V_OBW_MAATREGEL_GEBRUIKER
(
   ID
)
AS
   SELECT DISTINCT rob.id
     FROM sms_gebruiker_raci gri, sms_obw rob
    WHERE     (   rob.rai_id_eigenaar = gri.rai_id
               OR rob.rai_id_beheerder = gri.rai_id)
          AND sms_pck.sms_gebruikers_id (p_windows_user => V ('APP_USER')) =
                 gri.gbr_id
   UNION
   SELECT DISTINCT rob.id
     FROM sms_gebruiker_raci gri, sms_obw rob, sms_raci rai
    WHERE     (rob.rai_id_eigenaar = rai.id OR rob.rai_id_beheerder = rai.id)
          AND (rai.rai_id_ibs = gri.rai_id OR rai_id_cib = gri.rai_id)
          AND sms_pck.sms_gebruikers_id (p_windows_user => V ('APP_USER')) =
                 gri.gbr_id
   UNION
   SELECT obw.id
     FROM sms_obw obw
    WHERE EXISTS
             (SELECT 'X'
                FROM sms_gebruiker_raci gri
               WHERE     sms_pck.sms_gebruikers_id (
                            p_windows_user   => V ('APP_USER')) = gri.gbr_id
                     AND gri.rai_id IN
                            (SELECT id
                               FROM sms_raci
                              WHERE functie IN ('BEHEERDER', 'RISICOMANAGER')))
   UNION
   SELECT obw.id
     FROM sms_obw obw
    WHERE V ('APP_USER') = 'SMS_ADMIN';


/* Formatted on 5-24-2017 2:48:02  (QP5 v5.287) */
CREATE OR REPLACE FORCE VIEW SMS_V_RISICOS
(
   BEHEERDER,
   EIGENAAR,
   LAAG,
   MIDDEN,
   HOOG
)
AS
     SELECT beheerder,
            eigenaar,
            SUM (DECODE (categorie, 'LAAG', 1, 0)) laag,
            SUM (DECODE (categorie, 'MIDDEN', 1, 0)) midden,
            SUM (DECODE (categorie, 'HOOG', 1, 0)) hoog
       FROM (SELECT sms_pck.functie_naam (obw.rai_id_beheerder) beheerder,
                    sms_pck.functie_naam (obw.rai_id_eigenaar) eigenaar,
                    NVL (rso.risico_categorie, rae.risicoprofiel) categorie
               FROM SMS_RISICOS rso,
                    SMS_RISICO_ANALYSES rae,
                    sms_normen nrm,
                    sms_obw_normen onm,
                    sms_obw obw
              WHERE     rae.id = rso.rae_id
                    AND rso.id = nrm.rso_id
                    AND nrm.id = onm.nrm_id
                    AND onm.obw_id = obw.id)
   GROUP BY eigenaar, beheerder;


/* Formatted on 5-24-2017 2:48:02  (QP5 v5.287) */
CREATE OR REPLACE FORCE VIEW SMS_V_ROLLEN
(
   ROL_ID,
   ROL,
   OMSCHRIJVING,
   "SCHEMA",
   SCHERM_IND
)
AS
   SELECT avr.id rol_id,
          avr.naam rol,
          avr.omschrijving,
          avr.schema,
          SCHERM_IND
     FROM apx_owner.apx_v_rollen avr
    WHERE schema = 'SMS_OWNER';


/* Formatted on 5-24-2017 2:48:02  (QP5 v5.287) */
CREATE OR REPLACE FORCE VIEW SMS_V_ROLLEN_HIERARCHIE
(
   HOOFDROL_ID,
   HOOFDROL,
   SUBROL_ID,
   SUBROL,
   TOEKENNINGSPAD
)
AS
   SELECT hoofdrol_id,
          hoofdrol,
          subrol_id,
          subrol,
          toekenningspad
     FROM apx_owner.apx_v_rollen_hierarchie r
    WHERE schema = 'SMS_OWNER';


/* Formatted on 5-24-2017 2:48:02  (QP5 v5.287) */
CREATE OR REPLACE FORCE VIEW SMS_V_SUBROLLEN
(
   ID,
   HOOFDROL_ID,
   SUBROL_ID
)
AS
   SELECT srl.id, srl.hoofdrol_id, srl.subrol_id
     FROM apx_owner.apx_v_subrollen srl
    WHERE    srl.hoofdrol_id IN (SELECT rol_id
                                   FROM SMS_v_rollen)
          OR srl.subrol_id IN (SELECT rol_id
                                 FROM SMS_v_rollen);


/* Formatted on 5-24-2017 2:48:02  (QP5 v5.287) */
CREATE OR REPLACE FORCE VIEW SMS_D_BEVINDINGEN
(
   BVG_ID,
   BVG_OORSPRONG,
   BVG_DATUM_GEREED,
   BVG_BESCHRIJVING,
   BVG_GEREED_IND,
   BVG_REVIEW_IND,
   BVG_OBW,
   BVG_RISICO_ANALYSE,
   BVG_PROJECT_NAAM,
   AUD_ID,
   AUD_OMSCHRIJVING,
   AUD_SOORT,
   AUD_DATUM_INGANG,
   AUD_DATUM_EINDE,
   AUD_OPZET,
   OBW_ID,
   OBW_MAATREGEL,
   OBW_CLASSIFICATIE,
   OBW_MAATREGELINHOUD,
   OBW_SCOPE,
   OBW_INTERPRETATIE,
   OBW_OPZET,
   OBW_OPMERKING,
   OBW_CONTROLEPLAN,
   OBW_DATUM_INGANG,
   OBW_DATUM_EINDE,
   OBW_EIGENAAR,
   OBW_BEHEER,
   OBW_NORMEN,
   OBW_PROCESSEN,
   OBW_ORGANISATIE,
   OBW_PRIORITEIT,
   BVG_PRIORITEIT
)
AS
   SELECT bvg.id bvg_id,
          bvg.oorsprong bvg_oorsprong,
          bvg.datum_gereed bvg_datum_gereed,
          bvg.beschrijving bvg_beschrijving,
          bvg.gereed_ind bvg_gereed_ind,
          bvg.review_ind bvg_review_ind,
          sms_pck.maatregel_naam (bvg.obw_id) bvg_obw,
          sms_pck.risico_analyses_naam (bvg.rae_id) bvg_risico_analyse,
          sms_pck.projecten_naam (bvg.pjt_id) bvg_project_naam,
          adt."AUD_ID",
          adt."AUD_OMSCHRIJVING",
          adt."AUD_SOORT",
          adt."AUD_DATUM_INGANG",
          adt."AUD_DATUM_EINDE",
          adt."AUD_OPZET",
          obw."OBW_ID",
          obw."OBW_MAATREGEL",
          obw."OBW_CLASSIFICATIE",
          obw."OBW_MAATREGELINHOUD",
          obw."OBW_SCOPE",
          obw."OBW_INTERPRETATIE",
          obw."OBW_OPZET",
          obw."OBW_OPMERKING",
          obw."OBW_CONTROLEPLAN",
          obw."OBW_DATUM_INGANG",
          obw."OBW_DATUM_EINDE",
          obw."OBW_EIGENAAR",
          obw."OBW_BEHEER",
          obw."OBW_NORMEN",
          obw."OBW_PROCESSEN",
          obw."OBW_ORGANISATIE",
          obw.obw_prioriteit,
          bvg.prioriteit bvg_prioriteit
     FROM sms_bevindingen bvg, sms_d_audits adt, sms_d_obw obw
    WHERE bvg.adt_id = adt.aud_id(+) AND bvg.obw_id = obw.obw_id;


/* Formatted on 5-24-2017 2:48:02  (QP5 v5.287) */
CREATE OR REPLACE FORCE VIEW SMS_D_CONTROLES
(
   CON_ID,
   CON_RAPPORTAGE,
   CON_CONTROLE_INHOUD,
   CON_FREQUENTIE,
   CON_PROCES,
   CON_RESPONSIBLE_WERKING,
   CON_OBW_ID,
   OBW_ID,
   OBW_MAATREGEL,
   OBW_CLASSIFICATIE,
   OBW_MAATREGELINHOUD,
   OBW_SCOPE,
   OBW_INTERPRETATIE,
   OBW_OPZET,
   OBW_OPMERKING,
   OBW_CONTROLEPLAN,
   OBW_DATUM_INGANG,
   OBW_DATUM_EINDE,
   OBW_EIGENAAR,
   OBW_BEHEER,
   OBW_NORMEN,
   OBW_PROCESSEN,
   OBW_ORGANISATIE,
   OBW_PRIORITEIT,
   CON_PRIORITEIT
)
AS
   SELECT con.id con_id,
          con.rapportage con_rapportage,
          con.controle_inhoud con_controle_inhoud,
          con.frequentie con_frequentie,
          sms_pck.proces_naam (con.pcs_id) con_proces,
          sms_pck.functie_naam (con.rai_id_resp_werking)
             con_responsible_werking,
          con.obw_id con_obw_id,
          obw."OBW_ID",
          obw."OBW_MAATREGEL",
          obw."OBW_CLASSIFICATIE",
          obw."OBW_MAATREGELINHOUD",
          obw."OBW_SCOPE",
          obw."OBW_INTERPRETATIE",
          obw."OBW_OPZET",
          obw."OBW_OPMERKING",
          obw."OBW_CONTROLEPLAN",
          obw."OBW_DATUM_INGANG",
          obw."OBW_DATUM_EINDE",
          obw."OBW_EIGENAAR",
          obw."OBW_BEHEER",
          obw."OBW_NORMEN",
          obw."OBW_PROCESSEN",
          obw."OBW_ORGANISATIE",
          obw.obw_prioriteit,
          con.prioriteit con_prioriteit
     FROM sms_controles con, sms_d_obw obw
    WHERE obw.obw_id = con.obw_id;


/* Formatted on 5-24-2017 2:48:02  (QP5 v5.287) */
CREATE OR REPLACE FORCE VIEW SMS_F_ACTIES
(
   ACT_ID,
   ACT_CTE_ID,
   ACT_DCT_ID,
   ACT_BVG_ID,
   ACT_OMSCHRIJVING,
   ACT_DATUM_UITVOERING,
   ACT_UITVOERDER,
   ACT_DATUM_RAPPORTAGE,
   ACT_STATUS,
   ACT_BEVINDINGEN,
   ACT_AFWIJKINGEN_INDICATOR,
   ACT_TOELICHTING_AFWIJKING,
   ACT_CALLNR,
   ACT_AFWIJK_HERST_INDICATOR,
   ACT_AFWIJKING_HERSTELD_TOEL,
   ACT_BRON,
   ACT_TE_LAAT,
   AANTAL,
   ACT_JAAR,
   ACT_PRIORITEIT,
   BVG_ID,
   BVG_OORSPRONG,
   BVG_DATUM_GEREED,
   BVG_BESCHRIJVING,
   BVG_GEREED_IND,
   BVG_REVIEW_IND,
   BVG_OBW,
   BVG_RISICO_ANALYSE,
   BVG_PROJECT_NAAM,
   AUD_ID,
   AUD_OMSCHRIJVING,
   AUD_SOORT,
   AUD_DATUM_INGANG,
   AUD_DATUM_EINDE,
   AUD_OPZET,
   BVG_PRIORITEIT,
   CON_ID,
   CON_RAPPORTAGE,
   CON_CONTROLE_INHOUD,
   CON_FREQUENTIE,
   CON_PROCES,
   CON_RESPONSIBLE_WERKING,
   CON_OBW_ID,
   OBW_ID,
   OBW_MAATREGEL,
   OBW_CLASSIFICATIE,
   OBW_MAATREGELINHOUD,
   OBW_SCOPE,
   OBW_INTERPRETATIE,
   OBW_OPZET,
   OBW_OPMERKING,
   OBW_CONTROLEPLAN,
   OBW_DATUM_INGANG,
   OBW_DATUM_EINDE,
   OBW_EIGENAAR,
   OBW_BEHEER,
   OBW_NORMEN,
   OBW_PROCESSEN,
   OBW_ORGANISATIE,
   CON_PRIORITEIT,
   OBW_PRIORITEIT,
   DOC_ID,
   DOC_BEHEERDER,
   DOC_VERSIE,
   DOC_NAAM,
   DOC_BEVEILIGING,
   DOC_FILENAAM,
   DOC_DATUM_INGANG,
   DOC_DATUM_EINDE,
   DOC_CONTROLE_FREQUENTIE,
   DOC_IGENAAR,
   DOC_STATUS,
   DOC_DOCUMENT_SOORT
)
AS
   SELECT id act_id,
          act.cte_id act_cte_id,
          act.dct_id act_dct_id,
          act.bvg_id act_bvg_id,
          ACT.opmerking act_omschrijving,
          act.datum_uitvoering act_datum_uitvoering,
          sms_pck.functie_naam (act.rai_id) act_uitvoerder,
          act.datum_rapportage act_datum_rapportage,
          act.status act_status,
          act.bevindingen act_bevindingen,
          act.afwijkingen_indicator act_afwijkingen_indicator,
          act.toelichting_afwijking act_toelichting_afwijking,
          act.callnr act_callnr,
          act.afwijking_hersteld_indicator act_afwijk_herst_indicator,
          act.afwijking_hersteld_toelichting act_afwijking_hersteld_toel,
          NVL2 (
             act.cte_id,
             'CONTROLE',
             NVL2 (act.bvg_id,
                   'BEVINDING',
                   NVL2 (act.dct_id, 'DOCUMENT', 'GEEN')))
             act_bron,
          CASE
             WHEN act.status != 'Afgerond' AND datum_uitvoering < SYSDATE
             THEN
                'J'
             ELSE
                'N'
          END
             act_te_laat,
          1 aantal,
          EXTRACT (YEAR FROM datum_uitvoering) act_jaar,
          act.prioriteit act_prioriteit,
          bvg."BVG_ID",
          bvg."BVG_OORSPRONG",
          bvg."BVG_DATUM_GEREED",
          bvg."BVG_BESCHRIJVING",
          bvg."BVG_GEREED_IND",
          bvg."BVG_REVIEW_IND",
          bvg."BVG_OBW",
          bvg."BVG_RISICO_ANALYSE",
          bvg."BVG_PROJECT_NAAM",
          bvg."AUD_ID",
          bvg."AUD_OMSCHRIJVING",
          bvg."AUD_SOORT",
          bvg."AUD_DATUM_INGANG",
          bvg."AUD_DATUM_EINDE",
          bvg."AUD_OPZET",
          bvg.bvg_prioriteit,
          cte."CON_ID",
          cte."CON_RAPPORTAGE",
          cte."CON_CONTROLE_INHOUD",
          cte."CON_FREQUENTIE",
          cte."CON_PROCES",
          cte."CON_RESPONSIBLE_WERKING",
          cte."CON_OBW_ID",
          NVL (cte."OBW_ID", bvg."OBW_ID") "OBW_ID",
          NVL (cte."OBW_MAATREGEL", bvg."OBW_MAATREGEL") "OBW_MAATREGEL",
          NVL (cte."OBW_CLASSIFICATIE", bvg."OBW_CLASSIFICATIE")
             "OBW_CLASSIFICATIE",
          NVL (cte."OBW_MAATREGELINHOUD", bvg."OBW_MAATREGELINHOUD")
             "OBW_MAATREGELINHOUD",
          NVL (cte."OBW_SCOPE", bvg."OBW_SCOPE") "OBW_SCOPE",
          NVL (cte."OBW_INTERPRETATIE", bvg."OBW_INTERPRETATIE")
             "OBW_INTERPRETATIE",
          NVL (cte."OBW_OPZET", bvg."OBW_OPZET") "OBW_OPZET",
          NVL (cte."OBW_OPMERKING", bvg."OBW_OPMERKING") "OBW_OPMERKING",
          NVL (cte."OBW_CONTROLEPLAN", bvg."OBW_CONTROLEPLAN")
             "OBW_CONTROLEPLAN",
          NVL (cte."OBW_DATUM_INGANG", bvg."OBW_DATUM_INGANG")
             "OBW_DATUM_INGANG",
          NVL (cte."OBW_DATUM_EINDE", bvg."OBW_DATUM_EINDE")
             "OBW_DATUM_EINDE",
          NVL (cte."OBW_EIGENAAR", bvg."OBW_EIGENAAR") "OBW_EIGENAAR",
          NVL (cte."OBW_BEHEER", bvg."OBW_BEHEER") "OBW_BEHEER",
          NVL (cte."OBW_NORMEN", bvg."OBW_NORMEN") "OBW_NORMEN",
          NVL (cte."OBW_PROCESSEN", bvg."OBW_PROCESSEN") "OBW_PROCESSEN",
          NVL (cte."OBW_ORGANISATIE", bvg."OBW_ORGANISATIE")
             "OBW_ORGANISATIE",
          cte.con_prioriteit,
          NVL (cte.obw_prioriteit, bvg.obw_prioriteit) obw_prioriteit,
          dct."DOC_ID",
          dct."DOC_BEHEERDER",
          dct."DOC_VERSIE",
          dct."DOC_NAAM",
          dct."DOC_BEVEILIGING",
          dct."DOC_FILENAAM",
          dct."DOC_DATUM_INGANG",
          dct."DOC_DATUM_EINDE",
          dct."DOC_CONTROLE_FREQUENTIE",
          dct."DOC_IGENAAR",
          dct."DOC_STATUS",
          dct."DOC_DOCUMENT_SOORT"
     FROM sms_acties act,
          sms_d_documenten dct,
          sms_d_controles cte,
          sms_d_bevindingen bvg
    WHERE     act.dct_id = dct.doc_id(+)
          AND act.cte_id = cte.con_id(+)
          AND act.bvg_id = bvg.bvg_id(+);


/* Formatted on 5-24-2017 2:48:02  (QP5 v5.287) */
CREATE OR REPLACE FORCE VIEW SMS_V_GEBRUIKER_ROLLEN
(
   ROL_ID,
   GBR_ID
)
AS
   SELECT grl.rol_id, grl.gbr_id
     FROM sms_gebruiker_rollen grl
   UNION
   SELECT rol.rol_id, gbr.id gbr_id
     FROM SMS_GEBRUIKER_RACI gri,
          SMS_RACI rai,
          sms_v_rollen rol,
          sms_gebruikers gbr
    WHERE     rai.id = gri.rai_id
          AND rol.rol = rai.functie
          AND gri.gbr_id = gbr.id;


/* Formatted on 5-24-2017 2:48:02  (QP5 v5.287) */
CREATE OR REPLACE FORCE VIEW SMS_V_GBR_ROLLEN_HIERARCHIE
(
   MEDEWERKER,
   WINDOWS_USER,
   ROL,
   IND_DIRECT_TOEGEKEND,
   ROL_ID,
   GBR_ID
)
AS
   SELECT DISTINCT
          gbr.naam medewerker,
          gbr.windows_user windows_user,
          rol.subrol rol -- elke rol is ook subrol van zichzelf in SMS_v_rollen
                        ,
          CASE WHEN rol.hoofdrol_id = rol.subrol_id THEN 'J' ELSE 'N' END
             ind_direct_toegekend,
          rol.subrol_id rol_id,
          gbr.id gbr_id
     FROM sms_v_gebruiker_rollen grl
          JOIN SMS_GEBRUIKERS gbr ON gbr.id = grl.gbr_id
          JOIN SMS_v_rollen_hierarchie rol ON rol.hoofdrol_id = grl.rol_id;
