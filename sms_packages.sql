create or replace PACKAGE "SMS_APEX" 
IS
/* Opslaan wijzigingen in MEDEWERKERROLLEN */
PROCEDURE SET_ROL_SHUTTLE
 (P_gbr_ID IN NUMBER
 ,P_SELECTED IN VARCHAR2
 );
/* geef rol_id's van gegeven medewerker terug in string tbv. shuttle */
FUNCTION GET_ROL_SHUTTLE
 (P_gbr_ID IN number
 )
 RETURN VARCHAR2;


/* Opslaan wijzigingen in SMS_V_ROLLEN_HIERARCHIE */
PROCEDURE SET_SUBROL_SHUTTLE
 (P_ROL_ID IN NUMBER
 ,P_SELECTED IN VARCHAR2
 );
/* geef rol_id's van gegeven rol terug in string tbv. shuttle */
FUNCTION GET_SUBROL_SHUTTLE
 (P_ROL_ID IN number
 )
 RETURN VARCHAR2;
END SMS_APEX;

/

create or replace PACKAGE BODY "SMS_APEX" 
IS

/* Opslaan wijzigingen in MEDEWERKERROLLEN */
PROCEDURE SET_ROL_SHUTTLE
 (P_gbr_ID IN NUMBER
 ,P_SELECTED IN VARCHAR2
 )
 IS
  l_selected apex_application_global.vc_arr2;
  l_count    pls_integer;
  l_behouden boolean := false;
begin
  -- convert the colon separated string into an array
  l_selected := apex_util.string_to_table(p_selected);

  -- voeg medewerker_rollen in
  for i in 1..l_selected.count
  loop
    -- bestaat medewerker_rol al?
    select count(*)
    into   l_count
    from   SMS_GEBRUIKER_ROLLEN
    where  gbr_id = p_gbr_id
    and    rol_id = l_selected(i);
    if l_count = 0
    then
      -- nee, bestaat nog niet: toevoegen
      insert into SMS_GEBRUIKER_ROLLEN (gbr_id, rol_id)
      values (p_gbr_id, l_selected(i));
    end if;
  end loop;

  -- verwijderen van database entries die niet in l_selected voorkomen
  -- loop door medewerker_rollen en vergelijk deze met lijst van rol id's in v_selected.
  -- zet vlaggetje 'keep' op true indien gevonden.
  -- na doorlopen v_selected, als keep = false, verwijder dan record.
 for m in (select id
           ,      rol_id
           from   SMS_GEBRUIKER_ROLLEN
           where  gbr_id = p_gbr_id
          )
 loop
   -- ga ervan uit dat medewerker_rollen moet worden opgeruimd
   l_behouden := false;
   -- kijk of medewerker id voorkomt in geselecteerde lijst
   for i in 1..l_selected.count loop
     if l_selected(i) = m.rol_id
     then
        -- ja, komt voor. dan niet verwijderen.
        l_behouden := true;
     end if;
   end loop; -- selected loop
   if not l_behouden
   then
     delete SMS_GEBRUIKER_ROLLEN
     where  id = m.id;
   end if;
 end loop;  -- medewerker loop

end set_rol_shuttle;
/* geef rol_id's van gegeven medewerker terug in string tbv. shuttle */
FUNCTION GET_ROL_SHUTTLE
 (P_gbr_ID IN number
 )
 RETURN VARCHAR2
 IS
  l_selected apex_application_global.vc_arr2;
begin
   -- ophalen rollen die gekoppeld zijn aan gebruiker
   select rol_id
   bulk   collect into l_selected
   from   SMS_GEBRUIKER_ROLLEN
   where  gbr_id = p_gbr_id;

   -- teruggeven als string tbv shuttle
   return apex_util.table_to_string(l_selected);

end get_rol_shuttle;



/* Opslaan wijzigingen in SMS_V_HIERARCHIE_ROLLEN */
PROCEDURE SET_SUBROL_SHUTTLE
 (P_ROL_ID IN NUMBER
 ,P_SELECTED IN VARCHAR2
 )
 IS
  l_selected apex_application_global.vc_arr2;
  l_count    pls_integer;
  l_behouden boolean := false;
begin
  -- convert the colon separated string into an array
  l_selected := apex_util.string_to_table(p_selected);

  -- voeg medewerker_rollen in
  for i in 1..l_selected.count
  loop
    -- bestaat subrol_rol al?
    select count(*)
    into   l_count
    from SMS_v_subrollen
    where  hoofdrol_id = p_rol_id
    and    subrol_id = l_selected(i);
    if l_count = 0
    then
      -- nee, bestaat nog niet: toevoegen
      insert into SMS_v_subrollen (hoofdrol_id, subrol_id)
      values (p_rol_id, l_selected(i));
    end if;
  end loop;

  -- verwijderen van database entries die niet in l_selected voorkomen
  -- loop door rollen_hierarchie en vergelijk deze met lijst van subrol id's in v_selected.
  -- zet vlaggetje 'keep' op true indien gevonden.
  -- na doorlopen v_selected, als keep = false, verwijder dan record.
 for m in (select hoofdrol_id
           ,      subrol_id
           ,      id
           from   SMS_v_subrollen
           where  hoofdrol_id = p_rol_id
          )
 loop
   -- ga ervan uit dat hierarchie_rollen moet worden opgeruimd
   l_behouden := false;
   -- kijk of medewerker id voorkomt in geselecteerde lijst
   for i in 1..l_selected.count loop
     if l_selected(i) = m.subrol_id
     then
        -- ja, komt voor. dan niet verwijderen.
        l_behouden := true;
     end if;
   end loop; -- selected loop
   if not l_behouden
   then
     delete SMS_v_subrollen
     where  id = m.id
     ;
   end if;
 end loop;  -- hierarchie_rollen loop

end set_subrol_shuttle;
/* geef subrol_id's van gegeven hierarchie_rollen terug in string tbv. shuttle */
FUNCTION GET_SUBROL_SHUTTLE
 (P_ROL_ID IN number
 )
 RETURN VARCHAR2
 IS
  l_selected apex_application_global.vc_arr2;
begin
   -- ophalen rollen die gekoppeld zijn aan gebruiker
   select subrol_id
   bulk   collect into l_selected
   from   SMS_v_subrollen
   where  hoofdrol_id = p_rol_id;

   -- teruggeven als string tbv shuttle
   return apex_util.table_to_string(l_selected);

end get_subrol_shuttle;
END SMS_APEX;
/

create or replace PACKAGE "SMS_AUTORISATIE_PCK" 
IS
PROCEDURE create_user ( p_user_name      IN VARCHAR2
                      , p_first_name     IN VARCHAR2
                      , p_last_name      IN VARCHAR2
                      , p_description    IN VARCHAR2
                      , p_email_address  IN VARCHAR2
                      , p_web_password   IN VARCHAR2
                      , p_group_ids      IN VARCHAR2
                      , p_developer_role IN VARCHAR2
                      )
;
PROCEDURE fetch_user ( p_user_id        IN  NUMBER
                     , p_user_name      OUT VARCHAR2
                     , p_first_name     OUT VARCHAR2
                     , p_last_name      OUT VARCHAR2
                     , p_email_address  OUT VARCHAR2
                     , p_groups         OUT VARCHAR2
                     , p_developer_role OUT VARCHAR2
                     , p_description    OUT VARCHAR2
                     )
;
FUNCTION is_administrator
RETURN BOOLEAN
;
function heeft_rol ( p_username in varchar2
                   , p_rol      in varchar2)
return boolean
;
FUNCTION gebruiker_id
RETURN SMS_GEBRUIKERS.id%TYPE
;
END;
/

create or replace PACKAGE BODY "SMS_AUTORISATIE_PCK" 
IS
PROCEDURE create_user ( p_user_name     IN VARCHAR2
                      , p_first_name    IN VARCHAR2
                      , p_last_name     IN VARCHAR2
                      , p_description   IN VARCHAR2
                      , p_email_address IN VARCHAR2
                      , p_web_password  IN VARCHAR2
                      , p_group_ids     IN VARCHAR2
                      , p_developer_role IN VARCHAR2
                      )
IS
  /**************************************************************************
  * DESCRIPTION wrapper van APEX_UTIL.CREATE_USER om wizard voor form te kunnen gebruiken
  *
  * PARAMETERS
  * ==========
  * NAME              TYPE     DESCRIPTION
  * ----------------- -------- ---------------------------------------------
  * ..
  *
  * HISTORY
  * =======
  * VERSION DATE       AUTHOR(S)       DESCRIPTION
  * ------- ---------- --------------- --------------------------
  *   1.0   26-10-2011 FBO             Initiele versie
  *************************************************************************/
BEGIN
  APEX_UTIL.CREATE_USER ( p_user_name                     => p_user_name
                        , p_first_name                    => p_first_name
                        , p_last_name                     => p_last_name
                        , p_description                   => p_description
                        , p_email_address                 => p_email_address
                        , p_web_password                  => p_web_password
                        , p_group_ids                     => p_group_ids
                        , p_developer_privs               => p_developer_role
                        , p_change_password_on_first_use  => 'N'
                        , p_failed_access_attempts        => 10
                        )
  ;
END;
--
--
PROCEDURE fetch_user ( p_user_id        IN  NUMBER
                     , p_user_name      OUT VARCHAR2
                     , p_first_name     OUT VARCHAR2
                     , p_last_name      OUT VARCHAR2
                     , p_email_address  OUT VARCHAR2
                     , p_groups         OUT VARCHAR2
                     , p_developer_role OUT VARCHAR2
                     , p_description    OUT VARCHAR2
                     )
IS
  /**************************************************************************
  * DESCRIPTION wrapper van APEX_UTIL.FETCH_USER om wizard voor form te kunnen gebruiken
  *
  * PARAMETERS
  * ==========
  * NAME              TYPE     DESCRIPTION
  * ----------------- -------- ---------------------------------------------
  * ..
  *
  * HISTORY
  * =======
  * VERSION DATE       AUTHOR(S)       DESCRIPTION
  * ------- ---------- --------------- --------------------------
  *   1.0   26-10-2011 FBO             Initiele versie
  *************************************************************************/
BEGIN
  APEX_UTIL.FETCH_USER ( p_user_id        => p_user_id
                       , p_user_name      => p_user_name
                       , p_first_name     => p_first_name
                       , p_last_name      => p_last_name
                       , p_email_address  => p_email_address
                       , p_groups         => p_groups
                       , p_developer_role => p_developer_role
                       , p_description    => p_description
                       )
  ;
END;
--
--
FUNCTION is_administrator
RETURN BOOLEAN
IS
  /**************************************************************************
  * DESCRIPTION bepalen of een apex-gebruiker administrator rechten heeft
  * wordt gebruikt bij het beheren van gebruikers
  *
  * PARAMETERS
  * ==========
  * NAME              TYPE     DESCRIPTION
  * ----------------- -------- ---------------------------------------------
  * RETURN                     TRUE=apex gebruiker is administrator
  *
  * HISTORY
  * =======
  * VERSION DATE       AUTHOR(S)       DESCRIPTION
  * ------- ---------- --------------- --------------------------
  *   1.0   26-10-2011 FBO             Initiele versie
  *************************************************************************/
  ln_aantal PLS_INTEGER;
BEGIN
  SELECT COUNT(*)
  INTO   ln_aantal
  FROM   APEX_WORKSPACE_APEX_USERS
  WHERE  is_admin = 'Yes'
  AND    V('APP_USER') = USER_NAME
  ;
  --RETURN (ln_aantal = 1);
  return true;
END;
--
--
function heeft_rol ( p_username in varchar2
                   , p_rol      in varchar2)
return boolean
is
  cursor c_heeft_rol (b_username in varchar2
                     ,b_rol      in varchar2)
  is
    select 1
    from   SMS_v_gbr_rollen_hierarchie    gbr
    where  gbr.windows_user =             b_username
    and    gbr.rol          =             b_rol
    UNION ALL
    select 1
    from   SMS_V_ROLLEN_HIERARCHIE
    WHERE  hoofdrol = 'STANDAARD'
    AND    subrol = b_rol
    ;
  l_dummy  pls_integer ;
  l_return boolean;
begin
  l_return := false;
  IF p_username = 'D.L.BERGHOUT@DICTU.NL'
  THEN
    RETURN TRUE;
  ELSE
    open c_heeft_rol (b_username => p_username
                     ,b_rol        => p_rol
                     );
    fetch c_heeft_rol into l_dummy;
    if  c_heeft_rol%rowcount = 0
    then
       l_return := false;
    else
       l_return := true;
    end if;
    close c_heeft_rol;
  END IF;
  --return l_return;
  return true;
end heeft_rol;
--
--
FUNCTION gebruiker_id
RETURN sms_gebruikers.id%TYPE
IS
  l_retval sms_gebruikers.id%TYPE;
BEGIN
	SELECT MAX(gbr.id)
	INTO   l_retval
	FROM   sms_gebruikers gbr
  WHERE  gbr.windows_user =  V('APP_USER')
  ;
  RETURN l_retval;
END;
--
--
END;
/

create or replace PACKAGE  "SMS_PCK" 
IS

/**************************************************************************
  * HISTORY
  * =======
  * VERSION DATE       AUTHOR(S)       DESCRIPTION
  * ------- ---------- --------------- --------------------------
  *   1.0   05-08-2011 FBO             Initiele versie
  *   2.0   06-09-2016 Dick            aanmaken_actie_bij_doc aangepast
  *************************************************************************/
  

FUNCTION sms_documenten_record ( pin_dct_id sms_documenten.id%TYPE
                               )
RETURN sms_documenten%ROWTYPE
;
FUNCTION doc_naam ( pin_dct_id sms_documenten.id%TYPE
                  )
RETURN sms_documenten.naam%TYPE
;
FUNCTION sms_raci_record ( pin_rai_id sms_raci.id%TYPE
                         )
RETURN sms_raci%ROWTYPE
;
FUNCTION functie_naam (  pin_rai_id sms_raci.id%TYPE
                      )
RETURN VARCHAR2
;
FUNCTION sms_obw_record ( pin_obw_id sms_obw.id%TYPE
                           )
RETURN sms_obw%ROWTYPE
;
FUNCTION maatregel_naam (  pin_obw_id sms_obw.id%TYPE
                        )
RETURN VARCHAR2
;
FUNCTION controle_naam ( pin_cte_id sms_controles.id%TYPE
                       )
RETURN VARCHAR2
;
PROCEDURE aanmaken_dct_wijzig ( pin_dct_id sms_documenten.id%TYPE
                              , pov_status OUT VARCHAR2
                              )
;
TYPE gewijzigd_rec IS RECORD (
 kolomnaam    VARCHAR2(100)
,waarde_oud   VARCHAR2(4000)
,waarde_nieuw VARCHAR2(4000)
,gewijzigd    VARCHAR2(1)
,bron         VARCHAR2(20)
);
TYPE wijzigingen_tab IS TABLE OF gewijzigd_rec;
FUNCTION wijzigingen_dct ( pin_dct_id sms_documenten.id%TYPE
                         )
RETURN wijzigingen_tab PIPELINED
;
PROCEDURE wijzigingen_dct_akkoord ( pin_dct_id sms_documenten.id%TYPE
                                  )
;
PROCEDURE wijzigingen_dct_niet_akkoord ( pin_dct_id sms_documenten.id%TYPE
                                       )
;
PROCEDURE aanmaken_obw_wijzig ( pin_obw_id sms_obw.id%TYPE
                              )
;
FUNCTION wijzigingen_obw ( pin_obw_id sms_obw.id%TYPE
                         )
RETURN wijzigingen_tab PIPELINED
;
PROCEDURE wijzigingen_obw_akkoord ( pin_obw_id sms_obw.id%TYPE
                                  )
;
PROCEDURE wijzigingen_obw_niet_akkoord ( pin_obw_id sms_obw.id%TYPE
                                       )
;

FUNCTION bevinding_naam ( pin_bvg_id sms_bevindingen.id%TYPE
                        )
RETURN VARCHAR2
;
FUNCTION norm_naam ( pin_nrm_id sms_normen.id%TYPE
                   )
RETURN VARCHAR2
;
FUNCTION herkomst_naam ( pin_cte_id  sms_controles.id%TYPE
                       , pin_dct_id  sms_documenten.id%TYPE
                       , pin_bvg_id  sms_bevindingen.id%TYPE
                       )
RETURN VARCHAR2
;
FUNCTION actie_naam ( pin_cae_id sms_acties.id%TYPE
                    )
RETURN VARCHAR2
;
FUNCTION controles_bij_obw ( pin_obw_id sms_obw.id%TYPE
                           )
RETURN VARCHAR2
;
FUNCTION bevindingen_bij_obw ( pin_obw_id           sms_obw.id%TYPE
                             , pin_uitsluitend_open VARCHAR2 DEFAULT NULL
                             )
RETURN VARCHAR2
;
FUNCTION documenten_bij_obw ( pin_obw_id sms_obw.id%TYPE
                            )
RETURN VARCHAR2
;
PROCEDURE del_dctw  ( pin_dctw_id sms_documenten.id%TYPE
                    )
;
PROCEDURE aanmaken_dow_wijzig ( pin_dow_id     sms_documenten.id%TYPE
                              , pov_status OUT VARCHAR2
                              )
;
PROCEDURE zet_dow_op_verwijderd ( pin_dow_id sms_documenten.id%TYPE
                                )
;
PROCEDURE zet_cte_op_verwijderd ( pin_cte_id sms_documenten.id%TYPE
                                )
;
PROCEDURE del_ctew  ( pin_obw_id sms_obw.id%TYPE
                    )
;
PROCEDURE del_ctew  ( pin_dce_id sms_controles.id%TYPE
                    )
;
PROCEDURE aanmaken_cte_wijzig ( pin_cte_id     sms_documenten.id%TYPE
                              , pov_status OUT VARCHAR2
                              )
;
--
--
FUNCTION herkomst_type ( pin_cte_id  sms_controles.id%TYPE
                       , pin_dct_id  sms_documenten.id%TYPE
                       , pin_bvg_id  sms_bevindingen.id%TYPE
                       )
RETURN VARCHAR2
;
PROCEDURE upgrade_documenten ( pin_nieuwe_dct_id sms_documenten.id%TYPE
                             , p_vervang_dct_ids_vervangt sms_documenten.dct_ids_vervangt%TYPE
                             )
;
PROCEDURE aanmaken_obw_wijzig ( pin_obw_id sms_obw.id%TYPE
                              , pov_status OUT VARCHAR2
                              )
;
PROCEDURE del_obww  ( pin_obw_id sms_obw.id%TYPE
                    )
;
PROCEDURE del_doww ( pin_dow_id sms_documenten.id%TYPE
                   )
;
PROCEDURE ins_sms_gebruiker_raci ( p_gebruikers_naam  sms_gebruikers.windows_user%TYPE
                                 , piv_string_raci VARCHAR2
                                 )
;
FUNCTION raci_gebruiker_string  (  p_gebruikers_naam  sms_gebruikers.windows_user%TYPE
                                )
RETURN VARCHAR2
;
FUNCTION raci_gebruiker_functie_string  (  p_gebruikers_naam  sms_gebruikers.windows_user%TYPE
                                        )
RETURN VARCHAR2
;
FUNCTION sms_controles_record ( pin_cte_id sms_controles.id%TYPE
                               )
RETURN sms_controles%ROWTYPE
;
FUNCTION obw_aanpassen
RETURN BOOLEAN
;
FUNCTION doc_aanpassen
RETURN BOOLEAN
;
FUNCTION is_beheerder ( p_gebruiker VARCHAR2 DEFAULT NULL 
                      )
RETURN BOOLEAN
;

FUNCTION is_docbeheerder ( p_gebruiker VARCHAR2 DEFAULT NULL 
                      )
RETURN BOOLEAN
;

FUNCTION is_security_officer
RETURN BOOLEAN
;
FUNCTION is_obw_eigenaar ( pin_obw_id sms_obw.id%TYPE
                         )
RETURN BOOLEAN
;
FUNCTION is_doc_eigenaar ( p_dct_id sms_documenten.id%TYPE
                         )
RETURN BOOLEAN
;
FUNCTION is_actie_eigenaar ( p_bvg_id sms_bevindingen.id%TYPE DEFAULT NULL
                           , p_dct_id sms_documenten.id%TYPE  DEFAULT NULL
                           , p_cte_id sms_controles.id%TYPE   DEFAULT NULL
                           )
RETURN BOOLEAN
;
FUNCTION is_actie_uitvoerder ( p_rai_id sms_raci.id%TYPE
                             )
RETURN BOOLEAN
;
FUNCTION autorisatie_nummer ( p_bvg_id sms_bevindingen.id%TYPE DEFAULT NULL
                            , p_dct_id sms_documenten.id%TYPE  DEFAULT NULL
                            , p_cte_id sms_controles.id%TYPE   DEFAULT NULL
                            , p_rai_id sms_raci.id%TYPE        DEFAULT NULL
                            )
RETURN PLS_INTEGER
;
PROCEDURE log_insert ( p_tabel sms_log_transacties.tabel%TYPE
                     , p_nieuwe_waarde sms_log_transacties.nieuwe_waarde%TYPE
                     , p_pk  sms_log_transacties.pk %TYPE
                     )
;
PROCEDURE log_update ( p_tabel sms_log_transacties.tabel%TYPE
                     , p_nieuwe_waarde sms_log_transacties.nieuwe_waarde%TYPE
                     , p_pk  sms_log_transacties.pk%TYPE
                     )
;
PROCEDURE aanmaken_acties_bij_doc ( p_jaar PLS_INTEGER
                                  , p_aantal_aangemaakte_acties OUT PLS_INTEGER
                                  )
;
PROCEDURE aanmaken_acties_bij_cte ( p_jaar PLS_INTEGER
                                  , p_aantal_aangemaakte_acties OUT PLS_INTEGER
                                  )
;
PROCEDURE aanmaken_acties ( p_jaar PLS_INTEGER
                          )
;
PROCEDURE welkome_tekst
;
PROCEDURE verwijder_niet_gewijzigde_obw
;
PROCEDURE verwijder_niet_gewijzigde_dct
;
FUNCTION is_beheerder_ja_nee
RETURN VARCHAR2
;

FUNCTION is_docbeheerder_ja_nee
RETURN VARCHAR2
;
PROCEDURE werk_cae_string_in_bae ( p_bvg_id sms_bevindingen.id%TYPE
                                 )
;
FUNCTION document_soort ( pin_dst_id sms_document_soorten.id%TYPE
                        )
RETURN VARCHAR2
;
FUNCTION autorisatie_nummer_beperkt
RETURN PLS_INTEGER
;
FUNCTION audit_naam  ( pin_adt_id sms_audits.id%TYPE
                     )
RETURN VARCHAR2
;
FUNCTION is_security_officer ( pin_obw_id sms_obw.id%TYPE
                             )
RETURN BOOLEAN
;
FUNCTION is_security_officer ( pin_dct_id sms_documenten.id%TYPE
                             )
RETURN BOOLEAN
;
FUNCTION bepaal_maatregel  ( p_bvg_id sms_bevindingen.id%TYPE
                           , p_dct_id sms_documenten.id%TYPE
                           , p_cte_id sms_controles.id%TYPE
                           )
RETURN sms_obw.id%TYPE
;
FUNCTION bepaal_obw_eigenaar ( p_obw_id sms_obw.id%TYPE
                             )
RETURN VARCHAR2
;
FUNCTION bepaal_obw_beheerder ( p_obw_id sms_obw.id%TYPE
                              )
RETURN VARCHAR2
;
FUNCTION bepaal_doc_eigenaar ( pin_dct_id sms_documenten.id%TYPE
                             )
RETURN VARCHAR2
;
FUNCTION bepaal_doc_beheerder ( pin_dct_id sms_documenten.id%TYPE
                              )
RETURN VARCHAR2
;
--
--
FUNCTION gewijzigd_j_n ( piv_waarde_oud   VARCHAR2
                       , piv_waarde_nieuw VARCHAR2
                       )
RETURN VARCHAR2
;
FUNCTION geef_rai_id ( p_functie sms_raci.functie%TYPE
                     )
RETURN sms_raci.id%TYPE
;
PROCEDURE log_delete ( p_tabel sms_log_transacties.tabel%TYPE
                     , p_oude_waarde sms_log_transacties.nieuwe_waarde%TYPE
                     , p_pk  sms_log_transacties.pk %TYPE
                     )
;
FUNCTION register_waarde ( p_applicatie sms_APPLICATIE_REGISTER.applicatie%TYPE
                         , p_variabele sms_APPLICATIE_REGISTER.variabele%TYPE
                         )
RETURN sms_applicatie_register.waarde%TYPE
;
PROCEDURE security_incident_tekst
;
PROCEDURE dictu_ib_org_tekst
;
PROCEDURE delete_obw ( p_obw_id  sms_obw.id%TYPE
                     )
;
FUNCTION proces_naam ( pin_pcs_id sms_processen.id%TYPE
                     )
RETURN sms_processen.naam%TYPE
;
PROCEDURE geef_html ( p_tekst VARCHAR2
                    )
;
FUNCTION maatregel (  pin_obw_id sms_obw.id%TYPE
                   )
RETURN VARCHAR2
;
PROCEDURE verwerk_nrm_string_in_onm ( p_obw_id sms_obw.id%TYPE
                                    )
;
FUNCTION normstring_naar_tekst ( p_nrm_ids sms_obw.nrm_ids%TYPE
                               )
RETURN VARCHAR2
;
FUNCTION processtring_naar_tekst ( p_pcs_ids sms_obw.pcs_ids%TYPE
                                 )
RETURN VARCHAR2
;
FUNCTION sms_risico_naam ( pin_rso_id sms_risicos.id%TYPE
                         )
RETURN VARCHAR2
;
FUNCTION paragraaf_naam ( pin_ipf_id sms_iso_paragrafen.id%TYPE
                        )
RETURN VARCHAR2
;
FUNCTION behandelplan_naam ( pin_bpn_id sms_behandelplannen.id%TYPE
                           )
RETURN VARCHAR2
;
PROCEDURE verwerk_pcs_string_in_ops ( p_obw_id sms_obw.id%TYPE
                                    )
;
FUNCTION is_security_officer_ja_nee ( pin_obw_id sms_obw.id%TYPE
                                    )
RETURN VARCHAR2
;
FUNCTION is_risicomanager
RETURN BOOLEAN
;
FUNCTION is_auditor
RETURN BOOLEAN
;
FUNCTION is_auditor_risicomanager
RETURN BOOLEAN
;
FUNCTION obw_bij_risico_litanie ( pin_rso_id sms_risicos.id%TYPE
                                )
RETURN VARCHAR2
;
FUNCTION behandelplan_bij_risico ( pin_rso_id sms_risicos.id%TYPE
                                 )
RETURN VARCHAR2
;
FUNCTION risico_analyses_naam ( pin_rae_id sms_risico_analyses.id%TYPE
                              )
RETURN VARCHAR2
;
FUNCTION projecten_naam ( pin_pjt_id sms_projecten.id%TYPE
                        )
RETURN VARCHAR2
;
FUNCTION obw_pcs_ids ( pin_obw_id sms_obw.id%TYPE
                     )
RETURN sms_obw.pcs_ids%TYPE
;
FUNCTION organisaties_naam ( pin_oge_id sms_organisaties.id%TYPE
                           )
RETURN VARCHAR2
;
FUNCTION is_ib_specialist
RETURN BOOLEAN
;
FUNCTION bevinding_aanpassen ( pin_obw_id sms_obw.id%TYPE
                             )
RETURN PLS_INTEGER
;
FUNCTION account_is_locked ( p_user_name VARCHAR2
                           )
RETURN VARCHAR2
;
FUNCTION rolnaam  ( pin_rol_id sms_v_rollen.rol_id%TYPE
                  )
RETURN VARCHAR2
;
FUNCTION rollen_bij_medewer_lit ( pin_mwr_id sms_gebruikers.id%TYPE
                                 )
RETURN VARCHAR2
;
FUNCTION obw_bij_documenten ( pin_dct_id sms_documenten.id%TYPE
                            )
RETURN VARCHAR2
;
FUNCTION apex_error_handling ( p_error IN OUT apex_error.t_error 
                             )
RETURN apex_error.t_error_result
;
PROCEDURE log_gebruiker
;
FUNCTION maatregel_prioriteit ( pin_obw_id sms_obw.id%TYPE
                              )
RETURN VARCHAR2
;
FUNCTION controle_prioriteit ( pin_cte_id sms_controles.id%TYPE
                             )
RETURN VARCHAR2
;
FUNCTION alleen_beheerder_inloggen ( p_gebruiker VARCHAR2
                                   )
RETURN BOOLEAN
;
FUNCTION documentstring_naar_tekst ( p_dct_ids sms_documenten.dct_ids_vervangt%TYPE
                                   )
RETURN VARCHAR2                                  
;
FUNCTION sms_gebruikers_id ( p_windows_user sms_gebruikers.windows_user%TYPE
                           )
RETURN sms_gebruikers.id%TYPE
;
FUNCTION check_bestaat_regelgeving ( p_regelgeving VARCHAR2
                                   )
RETURN BOOLEAN
;
PROCEDURE verwerk_nieuwe_regelgeving
;
FUNCTION check_regelg_reeds_geladen
RETURN BOOLEAN
;
FUNCTION is_obw_eigenaar_ja_nee ( pin_obw_id sms_obw.id%TYPE
                                )
RETURN VARCHAR2
;
g_obw_tab dbms_sql.varchar2_table;
g_row_tab dbms_sql.number_table;
g_cte_tab dbms_sql.number_table;
g_dow_tab dbms_sql.number_table;
g_dct_tab dbms_sql.number_table;
g_ipf_tab dbms_sql.number_table;
g_rso_tab dbms_sql.number_table;
g_bvg_tab dbms_sql.number_table;
END;
/

create or replace PACKAGE BODY  "SMS_PCK" 
IS
  gcv_verwijderd CONSTANT VARCHAR2(20) := 'VERWIJDERD';
  gcd_grote_datum CONSTANT DATE := DATE '3000-1-1';
  gcd_kleine_datum CONSTANT DATE := DATE '1000-1-1';
  g_jaar          CONSTANT VARCHAR2(20) := 'JAAR';
  g_twee_jaar     CONSTANT VARCHAR2(20) := 'TWEE_JAAR';
  g_half_jaar     CONSTANT VARCHAR2(20) := 'HALF_JAAR';
  g_kwartaal      CONSTANT VARCHAR2(20) := 'KWARTAAL';
  g_maand         CONSTANT VARCHAR2(20) := 'MAAND';
  g_week          CONSTANT VARCHAR2(20) := 'WEEK';
  g_gepland       CONSTANT VARCHAR2(20) := 'Gepland';
  g_komma         CONSTANT VARCHAR2(20) := ', ';
  g_spatie        CONSTANT VARCHAR2(100) := CHR(38)||'nbsp;';
  g_nee           CONSTANT VARCHAR2(20) := 'N';
  g_ja            CONSTANT VARCHAR2(20) := 'J';
  g_break         CONSTANT VARCHAR2(20) := '<br/>';
FUNCTION wijzigingen_cte ( pin_obw_id sms_obw.id%TYPE
                         )
RETURN wijzigingen_tab
;
FUNCTION wijzigingen_dow ( pin_obw_id sms_obw.id%TYPE
                         )
RETURN wijzigingen_tab
;
PROCEDURE wijzigingen_dow_akkoord ( pin_obw_id sms_obw.id%TYPE
                                  )
;
PROCEDURE wijzigingen_dow_niet_akkoord ( pin_obw_id sms_obw.id%TYPE
                                       )
;
PROCEDURE wijzigingen_cte_akkoord ( pin_obw_id sms_obw.id%TYPE
                                  )
;
PROCEDURE wijzigingen_cte_niet_akkoord ( pin_obw_id sms_obw.id%TYPE
                                       )
;
--
--
--
FUNCTION sms_v_rollen_record ( pin_rol_id sms_v_rollen.rol_id%TYPE
                             )
RETURN sms_v_rollen%ROWTYPE
IS
  /**************************************************************************
  * DESCRIPTION ophalen record ahv primary key
  *
  *
  * PARAMETERS
  * ==========
  * NAME              TYPE     DESCRIPTION
  * ----------------- -------- ---------------------------------------------
  *pin_rol_id                 IN PK=programmanummer ID
  *
  * HISTORY
  * =======
  * VERSION DATE       AUTHOR(S)       DESCRIPTION
  * ------- ---------- --------------- --------------------------
  *   1.0   01-05-2013 FBO             Initiele versie
  *************************************************************************/
  CURSOR a
  IS
  SELECT *
  FROM   sms_v_rollen
  WHERE  rol_id = pin_rol_id
  ;
  lt_sms_v_rollen sms_v_rollen%ROWTYPE;
BEGIN
  OPEN a;
  FETCH a INTO lt_sms_v_rollen;
  CLOSE a;
  RETURN lt_sms_v_rollen;
END;
--
--
FUNCTION rolnaam  ( pin_rol_id sms_v_rollen.rol_id%TYPE
                  )
RETURN VARCHAR2
  /**************************************************************************
  * DESCRIPTION rolnaam
  *
  *
  * PARAMETERS
  * ==========
  * NAME              TYPE     DESCRIPTION
  * ----------------- -------- ---------------------------------------------
  *pin_rol_id                 IN PK=ROL_ID
  *
  * HISTORY
  * =======
  * VERSION DATE       AUTHOR(S)       DESCRIPTION
  * ------- ---------- --------------- --------------------------
  *   1.0   01-05-2013 FBO             Initiele versie
  *************************************************************************/
IS
  lt_sms_v_rollen sms_v_rollen%ROWTYPE :=  sms_v_rollen_record ( pin_rol_id => pin_rol_id);
BEGIN
    RETURN lt_sms_v_rollen.rol;
END;
--
--
FUNCTION sms_risico_analyses_record ( pin_rae_id sms_risico_analyses.id%TYPE
                                    )
RETURN sms_risico_analyses%ROWTYPE
IS
  /**************************************************************************
  * DESCRIPTION ophalen record ahv primary key
  *
  *
  * PARAMETERS
  * ==========
  * NAME              TYPE     DESCRIPTION
  * ----------------- -------- ---------------------------------------------
  *pin_rae_id                 IN PK=programmanummer ID
  *
  * HISTORY
  * =======
  * VERSION DATE       AUTHOR(S)       DESCRIPTION
  * ------- ---------- --------------- --------------------------
  *   1.0   05-08-2011 FBO             Initiele versie
  *************************************************************************/
  CURSOR a
  IS
  SELECT *
  FROM   sms_risico_analyses
  WHERE  id = pin_rae_id
  ;
  lt_sms_risico_analyses sms_risico_analyses%ROWTYPE;
BEGIN
  OPEN a;
  FETCH a INTO lt_sms_risico_analyses;
  CLOSE a;
  RETURN lt_sms_risico_analyses;
END;
--
--
FUNCTION risico_analyses_naam ( pin_rae_id sms_risico_analyses.id%TYPE
                              )
RETURN VARCHAR2
IS
  /**************************************************************************
  * DESCRIPTION ophalen record ahv primary key
  *
  *
  * PARAMETERS
  * ==========
  * NAME              TYPE     DESCRIPTION
  * ----------------- -------- ---------------------------------------------
  *pin_rae_id                 IN PK=programmanummer ID
  *
  * HISTORY
  * =======
  * VERSION DATE       AUTHOR(S)       DESCRIPTION
  * ------- ---------- --------------- --------------------------
  *   1.0   05-08-2011 FBO             Initiele versie
  *************************************************************************/
  lt_sms_risico_analyses sms_risico_analyses%ROWTYPE := sms_risico_analyses_record ( pin_rae_id => pin_rae_id);
BEGIN
  RETURN lt_sms_risico_analyses.omschrijving_kort||' '||lt_sms_risico_analyses.omschrijving;
END;
--
--
FUNCTION sms_iso_hoofdstukken_record ( pin_ihk_id sms_iso_hoofdstukken.id%TYPE
                                    )
RETURN sms_iso_hoofdstukken%ROWTYPE
IS
  /**************************************************************************
  * DESCRIPTION ophalen record ahv primary key
  *
  *
  * PARAMETERS
  * ==========
  * NAME              TYPE     DESCRIPTION
  * ----------------- -------- ---------------------------------------------
  * pin_ihk_id              IN PK sms_iso_hoofdstukken_record
  *
  * HISTORY
  * =======
  * VERSION DATE       AUTHOR(S)       DESCRIPTION
  * ------- ---------- --------------- --------------------------
  *   1.0   05-08-2011 FBO             Initiele versie
  *************************************************************************/
  CURSOR a
  IS
  SELECT *
  FROM   sms_iso_hoofdstukken
  WHERE  id = pin_ihk_id
  ;
  l_sms_iso_hoofdstukken_record sms_iso_hoofdstukken%ROWTYPE;
BEGIN
  OPEN a;
  FETCH a INTO l_sms_iso_hoofdstukken_record;
  CLOSE a;
  RETURN l_sms_iso_hoofdstukken_record;
END;
--
--
FUNCTION sms_iso_secties_record ( pin_ise_id sms_iso_secties.id%TYPE
                                )
RETURN sms_iso_secties%ROWTYPE
IS
  /**************************************************************************
  * DESCRIPTION ophalen record ahv primary key
  *
  *
  * PARAMETERS
  * ==========
  * NAME              TYPE     DESCRIPTION
  * ----------------- -------- ---------------------------------------------
  * pin_ise_id              IN PK sms_iso_secties_record
  *
  * HISTORY
  * =======
  * VERSION DATE       AUTHOR(S)       DESCRIPTION
  * ------- ---------- --------------- --------------------------
  *   1.0   05-08-2011 FBO             Initiele versie
  *************************************************************************/
  CURSOR a
  IS
  SELECT *
  FROM   sms_iso_secties
  WHERE  id = pin_ise_id
  ;
  l_sms_iso_secties_record sms_iso_secties%ROWTYPE;
BEGIN
  OPEN a;
  FETCH a INTO l_sms_iso_secties_record;
  CLOSE a;
  RETURN l_sms_iso_secties_record;
END;
--
--
FUNCTION sms_document_soorten_record ( pin_dst_id sms_document_soorten.id%TYPE
                                     )
RETURN sms_document_soorten%ROWTYPE
IS
  /**************************************************************************
  * DESCRIPTION ophalen record ahv primary key
  *
  *
  * PARAMETERS
  * ==========
  * NAME              TYPE     DESCRIPTION
  * ----------------- -------- ---------------------------------------------
  *pin_dst_id                 IN PK=programmanummer ID
  *
  * HISTORY
  * =======
  * VERSION DATE       AUTHOR(S)       DESCRIPTION
  * ------- ---------- --------------- --------------------------
  *   1.0   11-05-2012 FBO             Initiele versie
  *************************************************************************/
  CURSOR a
  IS
  SELECT *
  FROM   sms_document_soorten
  WHERE  id = pin_dst_id
  ;
  lt_sms_document_soorten sms_document_soorten%ROWTYPE;
BEGIN
  OPEN a;
  FETCH a INTO lt_sms_document_soorten;
  CLOSE a;
  RETURN lt_sms_document_soorten;
END;
--
--
FUNCTION document_soort ( pin_dst_id sms_document_soorten.id%TYPE
                        )
RETURN VARCHAR2
IS
  /**************************************************************************
  * DESCRIPTION ophalen naam
  *
  *
  * PARAMETERS
  * ==========
  * NAME              TYPE     DESCRIPTION
  * ----------------- -------- ---------------------------------------------
  *pin_dst_id                 IN PK=programmanummer ID
  *
  * HISTORY
  * =======
  * VERSION DATE       AUTHOR(S)       DESCRIPTION
  * ------- ---------- --------------- --------------------------
  *   1.0   11-05-2012 FBO             Initiele versie
  *************************************************************************/
BEGIN
  RETURN sms_document_soorten_record ( pin_dst_id => pin_dst_id).soort;
END;
--
--
FUNCTION sms_processen_record ( pin_pcs_id sms_processen.id%TYPE
                              )
RETURN sms_processen%ROWTYPE
IS
  /**************************************************************************
  * DESCRIPTION ophalen record ahv primary key
  *
  *
  * PARAMETERS
  * ==========
  * NAME              TYPE     DESCRIPTION
  * ----------------- -------- ---------------------------------------------
  * pin_pcs_id                 IN PK=programmanummer ID
  *
  * HISTORY
  * =======
  * VERSION DATE       AUTHOR(S)       DESCRIPTION
  * ------- ---------- --------------- --------------------------
  *   1.0   05-08-2011 FBO             Initiele versie
  *************************************************************************/
  CURSOR a
  IS
  SELECT *
  FROM   sms_processen
  WHERE  id = pin_pcs_id
  ;
  lt_sms_processen sms_processen%ROWTYPE;
BEGIN
  OPEN a;
  FETCH a INTO lt_sms_processen;
  CLOSE a;
  RETURN lt_sms_processen;
END;
--
--
FUNCTION proces_naam ( pin_pcs_id sms_processen.id%TYPE
                     )
RETURN sms_processen.naam%TYPE
IS
BEGIN
  RETURN sms_processen_record ( pin_pcs_id => pin_pcs_id).naam;
END;
--
--
FUNCTION gewijzigd_j_n ( piv_waarde_oud   VARCHAR2
                       , piv_waarde_nieuw VARCHAR2
                       )
RETURN VARCHAR2
IS
  /**************************************************************************
  * DESCRIPTION vergelijken twee strings op basis van inhoud
  *
  *
  * PARAMETERS
  * ==========
  * NAME              TYPE     DESCRIPTION
  * ----------------- -------- ---------------------------------------------
  * piv_waarde_oud    VARCHAR2
  * piv_waarde_nieuw  VARCHAR2
  * RETURN                     J=gewijzigd N=niet gewijzigd
  *
  * HISTORY
  * =======
  * VERSION DATE       AUTHOR(S)       DESCRIPTION
  * ------- ---------- --------------- --------------------------
  *   1.0   05-08-2011 FBO             Initiele versie
  *************************************************************************/
  l_retval VARCHAR2(1) := 'J';
  FUNCTION geef_waarde ( piv_waarde VARCHAR2
                       )
  RETURN VARCHAR2
  IS
    l_waarde VARCHAR2(4000) := piv_waarde;
  BEGIN
    l_waarde := wwv_flow_utilities.striphtml(l_waarde);
    l_waarde := REPLACE(l_waarde,CHR(10));
    l_waarde := REPLACE(l_waarde,CHR(13));
    l_waarde := REPLACE(l_waarde,CHR(9));
    RETURN translate(upper(trim(l_waarde)),'1234567890ABCDEFGHIJKLMNOPQRSTUVWXYZ ~!@#$%^&*()_+}{":?><`-=]['''';/.,','1234567890ABCDEFGHIJKLMNOPQRSTUVWXYZ');
  END;
BEGIN
  IF NVL(geef_waarde(piv_waarde_oud),'X') = NVL(geef_waarde(piv_waarde_nieuw),'X')
  THEN
    l_retval := 'N';
  END IF;
  RETURN l_retval;
END;
--
--
FUNCTION sms_documenten_obw_record ( pin_dow_id sms_documenten_obw.id%TYPE
                                   )
RETURN sms_documenten_obw%ROWTYPE
IS
  /**************************************************************************
  * DESCRIPTION ophalen record ahv primary key
  *
  *
  * PARAMETERS
  * ==========
  * NAME              TYPE     DESCRIPTION
  * ----------------- -------- ---------------------------------------------
  *pin_rai_id                 IN PK=programmanummer ID
  *
  * HISTORY
  * =======
  * VERSION DATE       AUTHOR(S)       DESCRIPTION
  * ------- ---------- --------------- --------------------------
  *   1.0   05-08-2011 FBO             Initiele versie
  *************************************************************************/
  CURSOR a
  IS
  SELECT *
  FROM   sms_documenten_obw
  WHERE  id = pin_dow_id
  ;
  lt_sms_documenten_obw sms_documenten_obw%ROWTYPE;
BEGIN
  OPEN a;
  FETCH a INTO lt_sms_documenten_obw;
  CLOSE a;
  RETURN lt_sms_documenten_obw;
END;
---
--
FUNCTION sms_documenten_record ( pin_dct_id sms_documenten.id%TYPE
                               )
RETURN sms_documenten%ROWTYPE
IS
  /**************************************************************************
  * DESCRIPTION ophalen record ahv primary key
  *
  *
  * PARAMETERS
  * ==========
  * NAME              TYPE     DESCRIPTION
  * ----------------- -------- ---------------------------------------------
  *pin_dct_id                 IN PK=programmanummer ID
  *
  * HISTORY
  * =======
  * VERSION DATE       AUTHOR(S)       DESCRIPTION
  * ------- ---------- --------------- --------------------------
  *   1.0   05-08-2011 FBO             Initiele versie
  *************************************************************************/
  CURSOR a
  IS
  SELECT *
  FROM   sms_documenten
  WHERE  id = pin_dct_id
  ;
  lt_sms_documenten sms_documenten%ROWTYPE;
BEGIN
  OPEN a;
  FETCH a INTO lt_sms_documenten;
  CLOSE a;
  RETURN lt_sms_documenten;
END;
--
--
FUNCTION doc_naam ( pin_dct_id sms_documenten.id%TYPE
                  )
RETURN sms_documenten.naam%TYPE
IS
  /**************************************************************************
  * DESCRIPTION
  *
  *
  * PARAMETERS
  * ==========
  * NAME              TYPE     DESCRIPTION
  * ----------------- -------- ---------------------------------------------
  * pin_dct_id        IN       PK documenten
  * RETURN                     documentnaam
  *
  * HISTORY
  * =======
  * VERSION DATE       AUTHOR(S)       DESCRIPTION
  * ------- ---------- --------------- --------------------------
  *   1.0   05-08-2011 FBO             Initiele versie
  *************************************************************************/
BEGIN
  RETURN sms_documenten_record ( pin_dct_id => pin_dct_id).naam;
END;
--
--
FUNCTION sms_raci_record ( pin_rai_id sms_raci.id%TYPE
                         )
RETURN sms_raci%ROWTYPE
IS
  /**************************************************************************
  * DESCRIPTION ophalen record ahv primary key
  *
  *
  * PARAMETERS
  * ==========
  * NAME              TYPE     DESCRIPTION
  * ----------------- -------- ---------------------------------------------
  *pin_rai_id                 IN PK=programmanummer ID
  *
  * HISTORY
  * =======
  * VERSION DATE       AUTHOR(S)       DESCRIPTION
  * ------- ---------- --------------- --------------------------
  *   1.0   05-08-2011 FBO             Initiele versie
  *************************************************************************/
  CURSOR a
  IS
  SELECT *
  FROM   sms_raci
  WHERE  id = pin_rai_id
  ;
  lt_sms_raci sms_raci%ROWTYPE;
BEGIN
  OPEN a;
  FETCH a INTO lt_sms_raci;
  CLOSE a;
  RETURN lt_sms_raci;
END;
--
--
FUNCTION functie_naam (  pin_rai_id sms_raci.id%TYPE
                      )
RETURN VARCHAR2
IS
  /**************************************************************************
  * DESCRIPTION
  *
  *
  * PARAMETERS
  * ==========
  * NAME              TYPE     DESCRIPTION
  * ----------------- -------- ---------------------------------------------
  * pin_raci_id        IN      PK raci
  * RETURN                     functienaam
  *
  * HISTORY
  * =======
  * VERSION DATE       AUTHOR(S)       DESCRIPTION
  * ------- ---------- --------------- --------------------------
  *   1.0   05-08-2011 FBO             Initiele versie
  *************************************************************************/
BEGIN
  RETURN sms_raci_record ( pin_rai_id => pin_rai_id).functie;
END;
--
--
FUNCTION sms_obw_record ( pin_obw_id sms_obw.id%TYPE
                        )
RETURN sms_obw%ROWTYPE
IS
  /**************************************************************************
  * DESCRIPTION ophalen record ahv primary key
  *
  *
  * PARAMETERS
  * ==========
  * NAME              TYPE     DESCRIPTION
  * ----------------- -------- ---------------------------------------------
  * pin_obw_id           IN PK=programmanummer ID
  *
  * HISTORY
  * =======
  * VERSION DATE       AUTHOR(S)       DESCRIPTION
  * ------- ---------- --------------- --------------------------
  *   1.0   05-08-2011 FBO             Initiele versie
  *************************************************************************/
  CURSOR a
  IS
  SELECT *
  FROM   sms_obw
  WHERE  id = pin_obw_id
  ;
  lt_sms_obw sms_obw%ROWTYPE;
BEGIN
  OPEN a;
  FETCH a INTO lt_sms_obw;
  CLOSE a;
  RETURN lt_sms_obw;
END;
--
--
FUNCTION maatregel_naam ( pin_obw_id sms_obw.id%TYPE
                        )
RETURN VARCHAR2
IS
  /**************************************************************************
  * DESCRIPTION
  *
  *
  * PARAMETERS
  * ==========
  * NAME              TYPE     DESCRIPTION
  * ----------------- -------- ---------------------------------------------
  * pin_obw_id     IN       PK obw
  * RETURN                     maatregelnaam
  *
  * HISTORY
  * =======
  * VERSION DATE       AUTHOR(S)       DESCRIPTION
  * ------- ---------- --------------- --------------------------
  *   1.0   05-08-2011 FBO             Initiele versie
  *************************************************************************/
  l_sms_obw_record sms_obw%ROWTYPE;
BEGIN
  l_sms_obw_record := sms_obw_record ( pin_obw_id => pin_obw_id);
  RETURN wwv_flow_utilities.striphtml(l_sms_obw_record.sbni_maatregelinhoud||' ('||l_sms_obw_record.maatregel||')');
END;
--
--
FUNCTION maatregel ( pin_obw_id sms_obw.id%TYPE
                   )
RETURN VARCHAR2
IS
  /**************************************************************************
  * DESCRIPTION
  *
  *
  * PARAMETERS
  * ==========
  * NAME              TYPE     DESCRIPTION
  * ----------------- -------- ---------------------------------------------
  * pin_obw_id     IN       PK obw
  * RETURN                     maatregel
  *
  * HISTORY
  * =======
  * VERSION DATE       AUTHOR(S)       DESCRIPTION
  * ------- ---------- --------------- --------------------------
  *   1.0   05-08-2011 FBO             Initiele versie
  *************************************************************************/
  l_sms_obw_record sms_obw%ROWTYPE;
BEGIN
  l_sms_obw_record := sms_obw_record ( pin_obw_id => pin_obw_id);
  RETURN l_sms_obw_record.maatregel;
END;
--
--
FUNCTION maatregel_prioriteit ( pin_obw_id sms_obw.id%TYPE
                              )
RETURN VARCHAR2
IS
  /**************************************************************************
  * DESCRIPTION
  *
  *
  * PARAMETERS
  * ==========
  * NAME              TYPE     DESCRIPTION
  * ----------------- -------- ---------------------------------------------
  * pin_obw_id     IN       PK obw
  * RETURN                     maatregel
  *
  * HISTORY
  * =======
  * VERSION DATE       AUTHOR(S)       DESCRIPTION
  * ------- ---------- --------------- --------------------------
  *   1.0   05-08-2011 FBO             Initiele versie
  *************************************************************************/
  l_sms_obw_record sms_obw%ROWTYPE;
BEGIN
  l_sms_obw_record := sms_obw_record ( pin_obw_id => pin_obw_id);
  RETURN l_sms_obw_record.prioriteit;
END;
--
--
FUNCTION obw_pcs_ids ( pin_obw_id sms_obw.id%TYPE
                     )
RETURN sms_obw.pcs_ids%TYPE
IS
  /**************************************************************************
  * DESCRIPTION
  *
  *
  * PARAMETERS
  * ==========
  * NAME              TYPE     DESCRIPTION
  * ----------------- -------- ---------------------------------------------
  * pin_obw_id     IN       PK obw
  * RETURN                     maatregel
  *
  * HISTORY
  * =======
  * VERSION DATE       AUTHOR(S)       DESCRIPTION
  * ------- ---------- --------------- --------------------------
  *   1.0   05-08-2011 FBO             Initiele versie
  *************************************************************************/
  l_sms_obw_record sms_obw%ROWTYPE;
BEGIN
  l_sms_obw_record := sms_obw_record ( pin_obw_id => pin_obw_id);
  RETURN 'D'||REPLACE(l_sms_obw_record.pcs_ids,CHR(58),'D')||'D';
END;
--
--
FUNCTION sms_controles_record ( pin_cte_id sms_controles.id%TYPE
                               )
RETURN sms_controles%ROWTYPE
IS
  /**************************************************************************
  * DESCRIPTION ophalen record ahv primary key
  *
  *
  * PARAMETERS
  * ==========
  * NAME              TYPE     DESCRIPTION
  * ----------------- -------- ---------------------------------------------
  *pin_cte_id                 IN PK=programmanummer ID
  *
  * HISTORY
  * =======
  * VERSION DATE       AUTHOR(S)       DESCRIPTION
  * ------- ---------- --------------- --------------------------
  *   1.0   05-08-2011 FBO             Initiele versie
  *************************************************************************/
  CURSOR a
  IS
  SELECT *
  FROM   sms_controles
  WHERE  id = pin_cte_id
  ;
  lt_sms_controles sms_controles%ROWTYPE;
BEGIN
  OPEN a;
  FETCH a INTO lt_sms_controles;
  CLOSE a;
  RETURN lt_sms_controles;
END;
--
--
FUNCTION bestaat_sms_controles  ( pin_cte_id sms_controles.id%TYPE
                                )
RETURN BOOLEAN
IS
  /**************************************************************************
  * DESCRIPTION check of een controle bestaat
  *
  *
  * PARAMETERS
  * ==========
  * NAME              TYPE     DESCRIPTION
  * ----------------- -------- ---------------------------------------------
  * pin_cte_id              IN PK=programmanummer ID
  * RETURN                     TRUE=contrle bestaat FALSE=bestaat niet
  *
  * HISTORY
  * =======
  * VERSION DATE       AUTHOR(S)       DESCRIPTION
  * ------- ---------- --------------- --------------------------
  *   1.0   05-08-2011 FBO             Initiele versie
  *************************************************************************/
BEGIN
  RETURN (sms_controles_record ( pin_cte_id => pin_cte_id).id > 0);
END;
--
--
FUNCTION controle_naam ( pin_cte_id sms_controles.id%TYPE
                       )
RETURN VARCHAR2
IS
  /**************************************************************************
  * DESCRIPTION
  *
  * PARAMETERS
  * ==========
  * NAME              TYPE     DESCRIPTION
  * ----------------- -------- ---------------------------------------------
  * pin_cte_id              IN PK=programmanummer ID
  * RETURN                     controlenaam
  *
  * HISTORY
  * =======
  * VERSION DATE       AUTHOR(S)       DESCRIPTION
  * ------- ---------- --------------- --------------------------
  *   1.0   05-08-2011 FBO             Initiele versie
  *   1.1   12-01-2011 FBO             controle_inhoud ipv maatregel
  *************************************************************************/
  l_sms_controles_record sms_controles%ROWTYPE;
  l_retval VARCHAR2(32767);
BEGIN
  l_sms_controles_record := sms_controles_record ( pin_cte_id => pin_cte_id);
  l_retval := l_sms_controles_record.frequentie||CHR(32)||l_sms_controles_record.controle_inhoud||CHR(32)||'('||maatregel(pin_obw_id => l_sms_controles_record.obw_id)||')';
  RETURN REGEXP_REPLACE (l_retval, '<[^>]+>');
END;
--
--
FUNCTION controle_prioriteit ( pin_cte_id sms_controles.id%TYPE
                             )
RETURN VARCHAR2
IS
  /**************************************************************************
  * DESCRIPTION
  *
  * PARAMETERS
  * ==========
  * NAME              TYPE     DESCRIPTION
  * ----------------- -------- ---------------------------------------------
  * pin_cte_id              IN PK=programmanummer ID
  * RETURN                     controlenaam
  *
  * HISTORY
  * =======
  * VERSION DATE       AUTHOR(S)       DESCRIPTION
  * ------- ---------- --------------- --------------------------
  *   1.0   05-08-2011 FBO             Initiele versie
  *   1.1   12-01-2011 FBO             controle_inhoud ipv maatregel
  *************************************************************************/
  l_sms_controles_record sms_controles%ROWTYPE;
BEGIN
  l_sms_controles_record := sms_controles_record ( pin_cte_id => pin_cte_id);
  RETURN l_sms_controles_record.prioriteit;
END;
--
--
FUNCTION  splits_string_met_delimeter ( p_string    IN VARCHAR2
                                      , p_delimiter IN VARCHAR2
                                      )
RETURN dbms_sql.varchar2s
IS
  /**************************************************************************
  * DESCRIPTION maat array van een string met een bepaalde delimeter
  *
  * PARAMETERS
  * ==========
  * NAME              TYPE     DESCRIPTION
  * ----------------- -------- ---------------------------------------------
  * p_string                IN
  * p_delimeter             IN
  *
  * HISTORY
  * =======
  * VERSION DATE       AUTHOR(S)       DESCRIPTION
  * ------- ---------- --------------- --------------------------
  *   1.0   05-08-2011 FBO             Initiele versie
  *************************************************************************/
  lt_split_string_tab dbms_sql.varchar2s;
  li_positie          PLS_INTEGER;
  li_index            PLS_INTEGER := 0;
  li_begin_positie    PLS_INTEGER := 1;
  lv_index            VARCHAR2(10);
  lv_waarde           VARCHAR2(10);
BEGIN
  IF p_string IS NOT NULL
  THEN
    LOOP
      li_index := li_index + 1;
      li_positie := INSTR(p_string,p_delimiter,1,li_index);
      IF li_positie = 0
      THEN
        lt_split_string_tab(lt_split_string_tab.COUNT + 1) := SUBSTR(p_string,li_begin_positie);
        EXIT;
      ELSE
        lt_split_string_tab(lt_split_string_tab.COUNT + 1) := SUBSTR(p_string,li_begin_positie,li_positie-li_begin_positie);
      END IF;
      li_begin_positie := li_positie + 1;
    END LOOP;
  END IF;
  RETURN lt_split_string_tab;
END;
--
--
FUNCTION normstring_naar_tekst ( p_nrm_ids sms_obw.nrm_ids%TYPE
                               )
RETURN VARCHAR2
IS
  /**************************************************************************
  * DESCRIPTION omdat gewerkt wordt met een shuttle wordt op deze manier gezorgd
  * dat de kinderen tabel sms_obw_normen goed wordt gesynchroniseerd
  *
  * PARAMETERS
  * ==========
  * NAME              TYPE     DESCRIPTION
  * ----------------- -------- ---------------------------------------------
  *
  * HISTORY
  * =======
  * VERSION DATE       AUTHOR(S)       DESCRIPTION
  * ------- ---------- --------------- -------------------------
  *   1.0   16-04-2012 FBO             Initiele versie
  *************************************************************************/
 l_norm_tekst_string VARCHAR2(32767);
 l_nrm_id_tab dbms_sql.varchar2s;
BEGIN
  l_nrm_id_tab := splits_string_met_delimeter ( p_string    => p_nrm_ids
                                              , p_delimiter => ':'
                                              )
  ;
  FOR i IN 1..l_nrm_id_tab.COUNT
  LOOP
    l_norm_tekst_string := l_norm_tekst_string||norm_naam ( pin_nrm_id => l_nrm_id_tab(i))||g_komma;
  END LOOP;
  RETURN RTRIM(l_norm_tekst_string,g_komma);
END;
--
--
FUNCTION processtring_naar_tekst ( p_pcs_ids sms_obw.pcs_ids%TYPE
                                 )
RETURN VARCHAR2
IS
  /**************************************************************************
  * DESCRIPTION omdat gewerkt wordt met een shuttle wordt op deze manier gezorgd
  * dat de kinderen tabel sms_obw_procesen goed wordt gesynchroniseerd
  *
  * PARAMETERS
  * ==========
  * NAME              TYPE     DESCRIPTION
  * ----------------- -------- ---------------------------------------------
  *
  * HISTORY
  * =======
  * VERSION DATE       AUTHOR(S)       DESCRIPTION
  * ------- ---------- --------------- --------------------------
  *   1.0   16-04-2012 FBO             Initiele versie
  *************************************************************************/
 l_proces_tekst_string VARCHAR2(32767);
 l_pcs_id_tab dbms_sql.varchar2s;
BEGIN
  l_pcs_id_tab := splits_string_met_delimeter ( p_string    => p_pcs_ids
                                              , p_delimiter => ':'
                                              )
  ;
  FOR i IN 1..l_pcs_id_tab.COUNT
  LOOP
    l_proces_tekst_string := l_proces_tekst_string||proces_naam ( pin_pcs_id => l_pcs_id_tab(i))||g_komma;
  END LOOP;
  RETURN RTRIM(l_proces_tekst_string,g_komma);
END;
--
--
PROCEDURE aanmaken_dct_wijzig ( pin_dct_id sms_documenten.id%TYPE
                              , pov_status OUT VARCHAR2
                              )
IS
  /**************************************************************************
  * DESCRIPTION aanmaken record in sms_documenten_wijzig indien deze nog niet bestaat
  * Het aangemaakt record is een copy van sms_documenten.
  *
  * PARAMETERS
  * ==========
  * NAME              TYPE     DESCRIPTION
  * ----------------- -------- ---------------------------------------------
  * piv_dct_id              IN PK document
  * pov_status             OUT indien document wijzig aangemaakt dan NIEUW
  *
  * HISTORY
  * =======
  * VERSION DATE       AUTHOR(S)       DESCRIPTION
  * ------- ---------- --------------- --------------------------
  *   1.1   01-08-2012 FBO             oge_id toegevoegd
  *   1.0   05-08-2011 FBO             Initiele versie
  *************************************************************************/
  FUNCTION bestaat_dctw_record
  RETURN BOOLEAN
  IS
    l_aantal PLS_INTEGER;
  BEGIN
    SELECT COUNT(*)
    INTO   l_aantal
    FROM   sms_documenten_wijzig dctw
    WHERE  dctw.id = pin_dct_id
    AND    ROWNUM < 2
    ;
    RETURN (l_aantal=1);
  END;
BEGIN
  IF  pin_dct_id > 0
  AND NOT bestaat_dctw_record
  THEN
    INSERT
    INTO   sms_documenten_wijzig dctw ( rai_id
                                      , versie
                                      , naam
                                      , beveiliging
                                      , filenaam
                                      , doc_content
                                      , mimetype
                                      , datum_file
                                      , id
                                      , datum_ingang
                                      , datum_einde
                                      , dct_ids_vervangt
                                      , document_link
                                      , controle_frequentie
                                      , dst_id
                                      , rai_id_eigenaar
                                      , status
                                      , voorblad_ind
                                      , voorblad_volgorde
                                      , oge_id
                                      )
    SELECT rai_id
    ,      versie
    ,      naam
    ,      beveiliging
    ,      filenaam
    ,      doc_content
    ,      mimetype
    ,      datum_file
    ,      id
    ,      datum_ingang
    ,      datum_einde
    ,      dct_ids_vervangt
    ,      document_link
    ,      controle_frequentie
    ,      dst_id
    ,      rai_id_eigenaar
    ,      status
    ,      voorblad_ind
    ,      voorblad_volgorde
    ,      oge_id
    FROM   sms_documenten dct
    WHERE  dct.id = pin_dct_id
    ;
    pov_status := 'NIEUW';
  END IF;
END;
--
--
FUNCTION wijzigingen_dct ( pin_dct_id sms_documenten.id%TYPE
                         )
RETURN wijzigingen_tab PIPELINED
IS
  /**************************************************************************
  * DESCRIPTION
  *
  * PARAMETERS
  * ==========
  * NAME              TYPE     DESCRIPTION
  * ----------------- -------- ---------------------------------------------
  * piv_dct_id              IN PK document
  * RETURN                     array oude en nieuwe waarden van een document
  *
  * HISTORY
  * =======
  * VERSION DATE       AUTHOR(S)       DESCRIPTION
  * ------- ---------- --------------- --------------------------
  *   1.1   01-08-2012 FBO             organisatie toegevoegd
  *   1.0   05-08-2011 FBO             Initiele versie
  *************************************************************************/
  CURSOR a
  IS
  SELECT dctw.id
  ,      functie_naam(dct.rai_id)     dct_beheerder
  ,      functie_naam(dctw.rai_id)    dctw_beheerder
  ,      functie_naam(dct.rai_id_eigenaar)     dct_eigenaar
  ,      functie_naam(dctw.rai_id_eigenaar)    dctw_eigenaar
  ,      dct.versie                   dct_versie
  ,      dctw.versie                  dctw_versie
  ,      dct.naam                     dct_naam
  ,      dctw.naam                    dctw_naam
  ,      dct.beveiliging              dct_beveiliging
  ,      dctw.beveiliging             dctw_beveiliging
  ,      dct.filenaam                 dct_filenaam
  ,      dctw.filenaam                dctw_filenaam
  ,      dct.datum_ingang             dct_datum_ingang
  ,      dctw.datum_ingang            dctw_datum_ingang
  ,      dct.datum_einde              dct_datum_einde
  ,      dctw.datum_einde             dctw_datum_einde
  ,      documentstring_naar_tekst(dct.dct_ids_vervangt)  dct_ids
  ,      documentstring_naar_tekst(dctw.dct_ids_vervangt) dctw_ids
  ,      dct.document_link            dct_document_link
  ,      dctw.document_link           dctw_document_link
  ,      dct.controle_frequentie      dct_controle_frequentie
  ,      dctw.controle_frequentie     dctw_controle_frequentie
  ,      document_soort(dct.dst_id)   dct_soort
  ,      document_soort(dctw.dst_id)  dctw_soort
  ,      dct.status                   dct_status
  ,      dctw.status                  dctw_status
  ,      dct.voorblad_ind             dct_voorblad
  ,      dctw.voorblad_ind            dctw_voorblad
  ,      dct.voorblad_volgorde        dct_voorblad_volgorde
  ,      dctw.voorblad_volgorde       dctw_voorblad_volgorde
  ,      organisaties_naam(dct.oge_id) dct_organisatie
  ,      organisaties_naam(dctw.oge_id) dctw_organisatie
  FROM   sms_documenten dct
  ,      sms_documenten_wijzig dctw
  WHERE  dctw.id = dct.id (+)
  AND    dctw.id = pin_dct_id
  ;
  l_wijzigingen_record gewijzigd_rec;
BEGIN
  FOR r_a IN a
  LOOP
    l_wijzigingen_record.kolomnaam     := 'beheerder';
    l_wijzigingen_record.waarde_oud    := r_a.dct_beheerder;
    l_wijzigingen_record.waarde_nieuw  := r_a.dctw_beheerder;
    PIPE ROW (l_wijzigingen_record);
    l_wijzigingen_record.kolomnaam     := 'eigenaar';
    l_wijzigingen_record.waarde_oud    := r_a.dct_eigenaar;
    l_wijzigingen_record.waarde_nieuw  := r_a.dctw_eigenaar;
    l_wijzigingen_record.gewijzigd     := gewijzigd_j_n(l_wijzigingen_record.waarde_oud,l_wijzigingen_record.waarde_nieuw);
    PIPE ROW (l_wijzigingen_record);
    l_wijzigingen_record.kolomnaam     := 'versie';
    l_wijzigingen_record.waarde_oud    := r_a.dct_versie;
    l_wijzigingen_record.waarde_nieuw  := r_a.dctw_versie;
    l_wijzigingen_record.gewijzigd     := gewijzigd_j_n(l_wijzigingen_record.waarde_oud,l_wijzigingen_record.waarde_nieuw);
    PIPE ROW (l_wijzigingen_record);
    l_wijzigingen_record.kolomnaam     := 'naam';
    l_wijzigingen_record.waarde_oud    := r_a.dct_naam;
    l_wijzigingen_record.waarde_nieuw  := r_a.dctw_naam;
    l_wijzigingen_record.gewijzigd     := gewijzigd_j_n(l_wijzigingen_record.waarde_oud,l_wijzigingen_record.waarde_nieuw);
    PIPE ROW (l_wijzigingen_record);
    l_wijzigingen_record.kolomnaam     := 'beveiliging';
    l_wijzigingen_record.waarde_oud    := r_a.dct_beveiliging;
    l_wijzigingen_record.waarde_nieuw  := r_a.dctw_beveiliging;
    l_wijzigingen_record.gewijzigd     := gewijzigd_j_n(l_wijzigingen_record.waarde_oud,l_wijzigingen_record.waarde_nieuw);
    PIPE ROW (l_wijzigingen_record);
    l_wijzigingen_record.kolomnaam     := 'filenaam';
    l_wijzigingen_record.waarde_oud    := r_a.dct_filenaam;
    l_wijzigingen_record.waarde_nieuw  := r_a.dctw_filenaam;
    l_wijzigingen_record.gewijzigd     := gewijzigd_j_n(l_wijzigingen_record.waarde_oud,l_wijzigingen_record.waarde_nieuw);
    PIPE ROW (l_wijzigingen_record);
    l_wijzigingen_record.kolomnaam     := 'vervangt';
    l_wijzigingen_record.waarde_oud    := r_a.dct_ids;
    l_wijzigingen_record.waarde_nieuw  := r_a.dctw_ids;
    l_wijzigingen_record.gewijzigd     := gewijzigd_j_n(l_wijzigingen_record.waarde_oud,l_wijzigingen_record.waarde_nieuw);
    PIPE ROW (l_wijzigingen_record);
    l_wijzigingen_record.kolomnaam     := 'aanmaakdatum';
    l_wijzigingen_record.waarde_oud    := r_a.dct_datum_ingang;
    l_wijzigingen_record.waarde_nieuw  := r_a.dctw_datum_ingang;
    l_wijzigingen_record.gewijzigd     := gewijzigd_j_n(l_wijzigingen_record.waarde_oud,l_wijzigingen_record.waarde_nieuw);
    PIPE ROW (l_wijzigingen_record);
    l_wijzigingen_record.kolomnaam     := 'vervaldatum';
    l_wijzigingen_record.waarde_oud    := r_a.dct_datum_einde;
    l_wijzigingen_record.waarde_nieuw  := r_a.dctw_datum_einde;
    l_wijzigingen_record.gewijzigd     := gewijzigd_j_n(l_wijzigingen_record.waarde_oud,l_wijzigingen_record.waarde_nieuw);
    PIPE ROW (l_wijzigingen_record);
    l_wijzigingen_record.kolomnaam     := 'document_link';
    l_wijzigingen_record.waarde_oud    := r_a.dct_document_link;
    l_wijzigingen_record.waarde_nieuw  := r_a.dctw_document_link;
    l_wijzigingen_record.gewijzigd     := gewijzigd_j_n(l_wijzigingen_record.waarde_oud,l_wijzigingen_record.waarde_nieuw);
    PIPE ROW (l_wijzigingen_record);
    l_wijzigingen_record.kolomnaam     := 'controle_frequentie';
    l_wijzigingen_record.waarde_oud    := r_a.dct_controle_frequentie;
    l_wijzigingen_record.waarde_nieuw  := r_a.dctw_controle_frequentie;
    l_wijzigingen_record.gewijzigd     := gewijzigd_j_n(l_wijzigingen_record.waarde_oud,l_wijzigingen_record.waarde_nieuw);
    PIPE ROW (l_wijzigingen_record);
    l_wijzigingen_record.kolomnaam     := 'soort';
    l_wijzigingen_record.waarde_oud    := r_a.dct_soort;
    l_wijzigingen_record.waarde_nieuw  := r_a.dctw_soort;
    l_wijzigingen_record.gewijzigd     := gewijzigd_j_n(l_wijzigingen_record.waarde_oud,l_wijzigingen_record.waarde_nieuw);
    PIPE ROW (l_wijzigingen_record);
    l_wijzigingen_record.kolomnaam     := 'status';
    l_wijzigingen_record.waarde_oud    := r_a.dct_status;
    l_wijzigingen_record.waarde_nieuw  := r_a.dctw_status;
    l_wijzigingen_record.gewijzigd     := gewijzigd_j_n(l_wijzigingen_record.waarde_oud,l_wijzigingen_record.waarde_nieuw);
    PIPE ROW (l_wijzigingen_record);
    l_wijzigingen_record.kolomnaam     := 'voorblad';
    l_wijzigingen_record.waarde_oud    := r_a.dct_voorblad;
    l_wijzigingen_record.waarde_nieuw  := r_a.dctw_voorblad;
    l_wijzigingen_record.gewijzigd     := gewijzigd_j_n(l_wijzigingen_record.waarde_oud,l_wijzigingen_record.waarde_nieuw);
    PIPE ROW (l_wijzigingen_record);
    l_wijzigingen_record.kolomnaam     := 'voorblad volgorde';
    l_wijzigingen_record.waarde_oud    := r_a.dct_voorblad_volgorde;
    l_wijzigingen_record.waarde_nieuw  := r_a.dctw_voorblad_volgorde;
    l_wijzigingen_record.gewijzigd     := gewijzigd_j_n(l_wijzigingen_record.waarde_oud,l_wijzigingen_record.waarde_nieuw);
    PIPE ROW (l_wijzigingen_record);
    l_wijzigingen_record.kolomnaam     := 'organisatie';
    l_wijzigingen_record.waarde_oud    := r_a.dct_organisatie;
    l_wijzigingen_record.waarde_nieuw  := r_a.dctw_organisatie;
    l_wijzigingen_record.gewijzigd     := gewijzigd_j_n(l_wijzigingen_record.waarde_oud,l_wijzigingen_record.waarde_nieuw);
    PIPE ROW (l_wijzigingen_record);
  END LOOP;
  RETURN;
END;
--
--
FUNCTION sms_dct_wijzig_record ( pin_dctw_id sms_documenten_wijzig.id%TYPE
                               )
RETURN sms_documenten_wijzig%ROWTYPE
IS
  /**************************************************************************
  * DESCRIPTION ophalen record ahv primary key
  *
  *
  * PARAMETERS
  * ==========
  * NAME              TYPE     DESCRIPTION
  * ----------------- -------- ---------------------------------------------
  * pin_dctw_id                 IN PK sms_documenten_wijzig
  *
  * HISTORY
  * =======
  * VERSION DATE       AUTHOR(S)       DESCRIPTION
  * ------- ---------- --------------- --------------------------
  *   1.0   05-08-2011 FBO             Initiele versie
  *************************************************************************/
  CURSOR a
  IS
  SELECT *
  FROM   sms_documenten_wijzig
  WHERE  id = pin_dctw_id
  ;
  lt_sms_dct_wijzig sms_documenten_wijzig%ROWTYPE;
BEGIN
  OPEN a;
  FETCH a INTO lt_sms_dct_wijzig;
  CLOSE a;
  RETURN lt_sms_dct_wijzig;
END;
--
--
PROCEDURE del_dctw  ( pin_dctw_id sms_documenten.id%TYPE
                    )
IS
  /**************************************************************************
  * DESCRIPTION verwijdereren van document wijzig record
  *
  * PARAMETERS
  * ==========
  * NAME              TYPE     DESCRIPTION
  * ----------------- -------- ---------------------------------------------
  * piv_dctw_id             IN PK document wijzig
  *
  * HISTORY
  * =======
  * VERSION DATE       AUTHOR(S)       DESCRIPTION
  * ------- ---------- --------------- --------------------------
  *   1.0   05-08-2011 FBO             Initiele versie
  *************************************************************************/
BEGIN
  DELETE
  FROM   sms_documenten_wijzig
  WHERE  id = pin_dctw_id
  ;
END;
--
--
FUNCTION bestaat_dct ( pin_dct_id sms_documenten.id%TYPE
                     )
RETURN BOOLEAN
IS
  /**************************************************************************
  * DESCRIPTION
  *
  * PARAMETERS
  * ==========
  * NAME              TYPE     DESCRIPTION
  * ----------------- -------- ---------------------------------------------
  * piv_dct_id              IN PK document
  * RETURN                     TRUE=document bestaat
  *
  * HISTORY
  * =======
  * VERSION DATE       AUTHOR(S)       DESCRIPTION
  * ------- ---------- --------------- --------------------------
  *   1.0   05-08-2011 FBO             Initiele versie
  *************************************************************************/
BEGIN
  RETURN ( sms_documenten_record ( pin_dct_id => pin_dct_id).id > 0);
END;
--
--
PROCEDURE wijzigingen_dct_akkoord ( pin_dct_id sms_documenten.id%TYPE
                                  )
IS
  /**************************************************************************
  * DESCRIPTION document wijzigingen akkoord
  * inhoud van document wijzig wordt weggeschreven in document
  * als toetje worden het document geupgrade
  * Tenslotte wordt het document wijzig record verwijderd
  *
  * PARAMETERS
  * ==========
  * NAME              TYPE     DESCRIPTION
  * ----------------- -------- ---------------------------------------------
  * piv_dct_id              IN PK document
  *
  * HISTORY
  * =======
  * VERSION DATE       AUTHOR(S)       DESCRIPTION
  * ------- ---------- --------------- --------------------------
  *   1.0   05-08-2011 FBO             Initiele versie
  *************************************************************************/
  lt_sms_dct_wijzig sms_documenten_wijzig%ROWTYPE;
BEGIN
  lt_sms_dct_wijzig := sms_dct_wijzig_record ( pin_dctw_id => pin_dct_id
                                             )
  ;
  IF bestaat_dct ( pin_dct_id => pin_dct_id)
  THEN
    UPDATE sms_documenten dct
    SET    dct.rai_id              = lt_sms_dct_wijzig.rai_id
    ,      dct.versie              = lt_sms_dct_wijzig.versie
    ,      dct.naam                = lt_sms_dct_wijzig.naam
    ,      dct.beveiliging         = lt_sms_dct_wijzig.beveiliging
    ,      dct.filenaam            = lt_sms_dct_wijzig.filenaam
    ,      dct.doc_content         = lt_sms_dct_wijzig.doc_content
    ,      dct.mimetype            = lt_sms_dct_wijzig.mimetype
    ,      dct.datum_file          = lt_sms_dct_wijzig.datum_file
    ,      dct.datum_ingang        = lt_sms_dct_wijzig.datum_ingang
    ,      dct.datum_einde         = lt_sms_dct_wijzig.datum_einde
    ,      dct.dct_ids_vervangt    = lt_sms_dct_wijzig.dct_ids_vervangt
    ,      dct.document_link       = lt_sms_dct_wijzig.document_link
    ,      dct.controle_frequentie = lt_sms_dct_wijzig.controle_frequentie
    ,      dct.dst_id              = lt_sms_dct_wijzig.dst_id
    ,      dct.rai_id_eigenaar     = lt_sms_dct_wijzig.rai_id_eigenaar
    ,      dct.status              = lt_sms_dct_wijzig.status
    ,      dct.voorblad_ind        = lt_sms_dct_wijzig.voorblad_ind
    ,      dct.voorblad_volgorde   = lt_sms_dct_wijzig.voorblad_volgorde
    ,      dct.oge_id              = lt_sms_dct_wijzig.oge_id
    WHERE  dct.id = pin_dct_id
    ;
  ELSE
    INSERT INTO sms_documenten ( id
                               , rai_id
                               , versie
                               , naam
                               , beveiliging
                               , filenaam
                               , doc_content
                               , mimetype
                               , datum_file
                               , datum_ingang
                               , datum_einde
                               , dct_ids_vervangt
                               , document_link
                               , controle_frequentie
                               , dst_id
                               , rai_id_eigenaar
                               , status
                               , voorblad_ind
                               , voorblad_volgorde
                               , oge_id
                               )
    VALUES                     ( pin_dct_id
                               , lt_sms_dct_wijzig.rai_id
                               , lt_sms_dct_wijzig.versie
                               , lt_sms_dct_wijzig.naam
                               , lt_sms_dct_wijzig.beveiliging
                               , lt_sms_dct_wijzig.filenaam
                               , lt_sms_dct_wijzig.doc_content
                               , lt_sms_dct_wijzig.mimetype
                               , lt_sms_dct_wijzig.datum_file
                               , lt_sms_dct_wijzig.datum_ingang
                               , lt_sms_dct_wijzig.datum_einde
                               , lt_sms_dct_wijzig.dct_ids_vervangt
                               , lt_sms_dct_wijzig.document_link
                               , lt_sms_dct_wijzig.controle_frequentie
                               , lt_sms_dct_wijzig.dst_id
                               , lt_sms_dct_wijzig.rai_id_eigenaar
                               , lt_sms_dct_wijzig.status
                               , lt_sms_dct_wijzig.voorblad_ind
                               , lt_sms_dct_wijzig.voorblad_volgorde
                               , lt_sms_dct_wijzig.oge_id
                               )
    ;
  END IF;
  IF lt_sms_dct_wijzig.dct_ids_vervangt IS NOT NULL
  THEN
    upgrade_documenten ( pin_nieuwe_dct_id  => pin_dct_id
                       , p_vervang_dct_ids_vervangt => lt_sms_dct_wijzig.dct_ids_vervangt
                       )
    ;
  END IF;
  del_dctw  ( pin_dctw_id => pin_dct_id
            )
  ;
END;
--
--
PROCEDURE wijzigingen_dct_niet_akkoord ( pin_dct_id sms_documenten.id%TYPE
                                       )
IS
  /**************************************************************************
  * DESCRIPTION document wijzigingen niet akkoord
  * inhoud van document wijzig behoeft niet te worden weggeschreven in document
  * Het document wijzig record wordt daarom verwijderd.
  *
  * PARAMETERS
  * ==========
  * NAME              TYPE     DESCRIPTION
  * ----------------- -------- ---------------------------------------------
  * pin_dct_id              IN PK document
  *
  * HISTORY
  * =======
  * VERSION DATE       AUTHOR(S)       DESCRIPTION
  * ------- ---------- --------------- --------------------------
  *   1.0   05-08-2011 FBO             Initiele versie
  *************************************************************************/
BEGIN
  del_dctw  ( pin_dctw_id => pin_dct_id
            )
  ;
END;
--
--
FUNCTION sms_bevindingen_record ( pin_bvg_id sms_bevindingen.id%TYPE
                               )
RETURN sms_bevindingen%ROWTYPE
IS
  /**************************************************************************
  * DESCRIPTION ophalen record ahv primary key
  *
  *
  * PARAMETERS
  * ==========
  * NAME              TYPE     DESCRIPTION
  * ----------------- -------- ---------------------------------------------
  *pin_bvg_id                 IN PK=programmanummer ID
  *
  * HISTORY
  * =======
  * VERSION DATE       AUTHOR(S)       DESCRIPTION
  * ------- ---------- --------------- --------------------------
  *   1.0   05-08-2011 FBO             Initiele versie
  *************************************************************************/
  CURSOR a
  IS
  SELECT *
  FROM   sms_bevindingen
  WHERE  id = pin_bvg_id
  ;
  lt_sms_bevindingen sms_bevindingen%ROWTYPE;
BEGIN
  OPEN a;
  FETCH a INTO lt_sms_bevindingen;
  CLOSE a;
  RETURN lt_sms_bevindingen;
END;
--
--
FUNCTION bevinding_naam ( pin_bvg_id sms_bevindingen.id%TYPE
                        )
RETURN VARCHAR2
IS
  /**************************************************************************
  * DESCRIPTION
  *
  *
  * PARAMETERS
  * ==========
  * NAME              TYPE     DESCRIPTION
  * ----------------- -------- ---------------------------------------------
  * pin_bvg_id              IN PK bevinding
  * RETURN                     bevindingnaam
  *
  * HISTORY
  * =======
  * VERSION DATE       AUTHOR(S)       DESCRIPTION
  * ------- ---------- --------------- --------------------------
  *   1.0   05-08-2011 FBO             Initiele versie
  *************************************************************************/
  lt_sms_bevindingen sms_bevindingen%ROWTYPE;
BEGIN
  lt_sms_bevindingen := sms_bevindingen_record ( pin_bvg_id =>  pin_bvg_id
                                               )
  ;
  RETURN wwv_flow_utilities.striphtml(lt_sms_bevindingen.beschrijving||' ('||maatregel(pin_obw_id => lt_sms_bevindingen.obw_id)||')');
END;


PROCEDURE aanmaken_obw_wijzig ( pin_obw_id sms_obw.id%TYPE
                              )
IS
  /**************************************************************************
  * DESCRIPTION aanmaken obw wijzig record
  *
  * PARAMETERS
  * ==========
  * NAME              TYPE     DESCRIPTION
  * ----------------- -------- ---------------------------------------------
  * p_obw_id             IN PK OBW
  *
  * HISTORY
  * =======
  * VERSION DATE       AUTHOR(S)       DESCRIPTION
  * ------- ---------- --------------- --------------------------
  *   1.0   05-08-2011 FBO             Initiele versie
  *************************************************************************/
  l_status VARCHAR2(10);
BEGIN
  aanmaken_obw_wijzig ( pin_obw_id => pin_obw_id
                      , pov_status    => l_status
                      )
  ;
END;
--
--
PROCEDURE aanmaken_obw_wijzig ( pin_obw_id sms_obw.id%TYPE
                              , pov_status OUT VARCHAR2
                              )
IS
  /**************************************************************************
  * DESCRIPTION aanmaken obw wijzig record
  *
  * PARAMETERS
  * ==========
  * NAME              TYPE     DESCRIPTION
  * ----------------- -------- ---------------------------------------------
  * pin_obw_id           IN PK OBW
  * pov_status             OUT NIEUW=nieuw obw wijzig record aangemaakt
  *
  * HISTORY
  * =======
  * VERSION DATE       AUTHOR(S)       DESCRIPTION
  * ------- ---------- --------------- --------------------------
  *   1.0   05-08-2011 FBO             Initiele versie
  *************************************************************************/
  FUNCTION bestaat_obww_record
  RETURN BOOLEAN
  IS
    l_aantal PLS_INTEGER;
  BEGIN
    SELECT COUNT(*)
    INTO   l_aantal
    FROM   sms_obw_wijzig obww
    WHERE  obww.id = pin_obw_id
    AND    ROWNUM < 2
    ;
    RETURN (l_aantal=1);
  END;
BEGIN
  IF pin_obw_id IS NOT NULL
  AND NOT bestaat_obww_record
  THEN
    INSERT
    INTO   sms_obw_wijzig obww
    SELECT *
    FROM   sms_obw obw
    WHERE  obw.id = pin_obw_id
    ;
    pov_status := 'NIEUW';
  END IF;
END;
--
--
FUNCTION wijzigingen_obw ( pin_obw_id sms_obw.id%TYPE
                         )
RETURN wijzigingen_tab PIPELINED
IS
  /**************************************************************************
  * DESCRIPTION
  *
  * PARAMETERS
  * ==========
  * NAME              TYPE     DESCRIPTION
  * ----------------- -------- ---------------------------------------------
  * pin_obw_id           IN PK OBW
  * RETURN                     array oude en nieuwe waarden van een obw en kinderen
  *
  * HISTORY
  * =======
  * VERSION DATE       AUTHOR(S)       DESCRIPTION
  * ------- ---------- --------------- --------------------------
  *   1.0   05-08-2011 FBO             Initiele versie
  *************************************************************************/
  CURSOR a
  IS
  SELECT *
  FROM   ( SELECT obww.maatregel
           ,      obww.id
           ,      obw.classificatie obw_classificatie
           ,      obww.classificatie obww_classificatie
           ,      obw.sbni_maatregelinhoud obw_sbni_maatregelinhoud
           ,      obww.sbni_maatregelinhoud obww_sbni_maatregelinhoud
           ,      obw.scope obw_scope
           ,      obww.scope obww_scope
           ,      obw.interpretatie obw_interpretatie
           ,      obww.interpretatie obww_interpretatie
           ,      obw.hoe_werkt_het obw_hoe_werkt_het
           ,      obww.hoe_werkt_het obww_hoe_werkt_het
           ,      obw.toelichting_ib_programma obw_toelichting_ib_programma
           ,      obww.toelichting_ib_programma obww_toelichting_ib_programma
           ,      obw.borging_controleplan obw_borging_controleplan
           ,      obww.borging_controleplan obww_borging_controleplan
           ,      obw.datum_ingang obw_datum_ingang
           ,      obww.datum_ingang obww_datum_ingang
           ,      obw.datum_einde obw_datum_einde
           ,      obww.datum_einde obww_datum_einde
           ,      functie_naam(obw.rai_id_eigenaar) obw_eigenaar
           ,      functie_naam(obww.rai_id_eigenaar) obww_eigenaar
           ,      functie_naam(obw.rai_id_beheerder) obw_beheerder
           ,      functie_naam(obww.rai_id_beheerder) obww_beheerder
           ,      obw.nrm_ids obw_nrm_ids
           ,      obww.nrm_ids obww_nrm_ids
           ,      obw.pcs_ids obw_pcs_ids
           ,      obww.pcs_ids obww_pcs_ids
           ,      obww.update_date
           ,      obww.creation_date
           ,      organisaties_naam(obw.oge_id) obw_oge_id
           ,      organisaties_naam(obww.oge_id) obww_oge_id
           ,      obw.maatregel obw_maatregel
           ,      obww.maatregel obww_maatregel
           ,      obw.prioriteit obw_prioriteit
           ,      obww.prioriteit obww_prioriteit
           FROM   sms_obw obw
           ,      sms_obw_wijzig obww
           WHERE  obww.id = obw.id (+)
           AND    obww.id = pin_obw_id
         )
  WHERE  creation_date != update_date
  OR     obw_maatregel IS NULL
  ;
  l_wijzigingen_record gewijzigd_rec;
  l_wijzigingen_tab wijzigingen_tab;
BEGIN
  FOR r_a IN a
  LOOP
    l_wijzigingen_record.bron          := 'OBW';
    l_wijzigingen_record.kolomnaam     := 'Maatregel';
    l_wijzigingen_record.waarde_oud    := r_a.obw_maatregel;
    l_wijzigingen_record.waarde_nieuw  := r_a.obww_maatregel;
    l_wijzigingen_record.gewijzigd     := gewijzigd_j_n(l_wijzigingen_record.waarde_oud,l_wijzigingen_record.waarde_nieuw);
    PIPE ROW (l_wijzigingen_record);
    l_wijzigingen_record.kolomnaam     := 'Eigenaar';
    l_wijzigingen_record.waarde_oud    := r_a.obw_eigenaar;
    l_wijzigingen_record.waarde_nieuw  := r_a.obww_eigenaar;
    l_wijzigingen_record.gewijzigd     := gewijzigd_j_n(l_wijzigingen_record.waarde_oud,l_wijzigingen_record.waarde_nieuw);
    PIPE ROW (l_wijzigingen_record);
    l_wijzigingen_record.kolomnaam     := 'Beheerder';
    l_wijzigingen_record.waarde_oud    := r_a.obw_beheerder;
    l_wijzigingen_record.waarde_nieuw  := r_a.obww_beheerder;
    l_wijzigingen_record.gewijzigd     := gewijzigd_j_n(l_wijzigingen_record.waarde_oud,l_wijzigingen_record.waarde_nieuw);
    PIPE ROW (l_wijzigingen_record);
    l_wijzigingen_record.kolomnaam     := 'Classificatie';
    l_wijzigingen_record.waarde_oud    := r_a.obw_classificatie;
    l_wijzigingen_record.waarde_nieuw  := r_a.obww_classificatie;
    l_wijzigingen_record.gewijzigd     := gewijzigd_j_n(r_a.obw_classificatie,r_a.obww_classificatie);
    PIPE ROW (l_wijzigingen_record);
    l_wijzigingen_record.kolomnaam     := 'Prioriteit';
    l_wijzigingen_record.waarde_oud    := r_a.obw_prioriteit;
    l_wijzigingen_record.waarde_nieuw  := r_a.obww_prioriteit;
    l_wijzigingen_record.gewijzigd     := gewijzigd_j_n(r_a.obw_prioriteit,r_a.obww_prioriteit);
    PIPE ROW (l_wijzigingen_record);
    l_wijzigingen_record.kolomnaam     := 'Organisatie';
    l_wijzigingen_record.waarde_oud    := r_a.obw_oge_id;
    l_wijzigingen_record.waarde_nieuw  := r_a.obww_oge_id;
    l_wijzigingen_record.gewijzigd     := gewijzigd_j_n(r_a.obw_oge_id,r_a.obww_oge_id);
    PIPE ROW (l_wijzigingen_record);
    l_wijzigingen_record.kolomnaam     := 'Normen';
    l_wijzigingen_record.waarde_oud    := normstring_naar_tekst( p_nrm_ids => r_a.obw_nrm_ids);
    l_wijzigingen_record.waarde_nieuw  := normstring_naar_tekst( p_nrm_ids => r_a.obww_nrm_ids);
    l_wijzigingen_record.gewijzigd     := gewijzigd_j_n(l_wijzigingen_record.waarde_oud,l_wijzigingen_record.waarde_nieuw);
    PIPE ROW (l_wijzigingen_record);
    l_wijzigingen_record.kolomnaam     := 'Processen';
    l_wijzigingen_record.waarde_oud    := processtring_naar_tekst( p_pcs_ids => r_a.obw_pcs_ids);
    l_wijzigingen_record.waarde_nieuw  := processtring_naar_tekst( p_pcs_ids => r_a.obww_pcs_ids);
    l_wijzigingen_record.gewijzigd     := gewijzigd_j_n(l_wijzigingen_record.waarde_oud,l_wijzigingen_record.waarde_nieuw);
    PIPE ROW (l_wijzigingen_record);
    l_wijzigingen_record.kolomnaam     := 'Maatregelinhoud';
    l_wijzigingen_record.waarde_oud    := r_a.obw_sbni_maatregelinhoud;
    l_wijzigingen_record.waarde_nieuw  := r_a.obww_sbni_maatregelinhoud;
    l_wijzigingen_record.gewijzigd     := gewijzigd_j_n(r_a.obw_sbni_maatregelinhoud,r_a.obww_sbni_maatregelinhoud);
    PIPE ROW (l_wijzigingen_record);
    l_wijzigingen_record.kolomnaam     := 'Scope';
    l_wijzigingen_record.waarde_oud    := r_a.obw_scope;
    l_wijzigingen_record.waarde_nieuw  := r_a.obww_scope;
    l_wijzigingen_record.gewijzigd     := gewijzigd_j_n(r_a.obw_scope,r_a.obww_scope);
    PIPE ROW (l_wijzigingen_record);
    l_wijzigingen_record.kolomnaam     := 'Interpretatie';
    l_wijzigingen_record.waarde_oud    := r_a.obw_interpretatie;
    l_wijzigingen_record.waarde_nieuw  := r_a.obww_interpretatie;
    l_wijzigingen_record.gewijzigd     := gewijzigd_j_n(r_a.obw_interpretatie,r_a.obww_interpretatie);
    PIPE ROW (l_wijzigingen_record);
    l_wijzigingen_record.kolomnaam     := 'Opzet';
    l_wijzigingen_record.waarde_oud    := r_a.obw_hoe_werkt_het;
    l_wijzigingen_record.waarde_nieuw  := r_a.obww_hoe_werkt_het;
    l_wijzigingen_record.gewijzigd     := gewijzigd_j_n(r_a.obw_hoe_werkt_het,r_a.obww_hoe_werkt_het);
    PIPE ROW (l_wijzigingen_record);
    l_wijzigingen_record.kolomnaam     := 'Opmerkingen';
    l_wijzigingen_record.waarde_oud    := r_a.obw_toelichting_ib_programma;
    l_wijzigingen_record.waarde_nieuw  := r_a.obww_toelichting_ib_programma;
    l_wijzigingen_record.gewijzigd     := gewijzigd_j_n(r_a.obw_toelichting_ib_programma,r_a.obww_toelichting_ib_programma);
    PIPE ROW (l_wijzigingen_record);
    l_wijzigingen_record.kolomnaam     := 'Controleplan';
    l_wijzigingen_record.waarde_oud    := r_a.obw_borging_controleplan;
    l_wijzigingen_record.waarde_nieuw  := r_a.obww_borging_controleplan;
    l_wijzigingen_record.gewijzigd     := gewijzigd_j_n(r_a.obw_borging_controleplan,r_a.obww_borging_controleplan);
    PIPE ROW (l_wijzigingen_record);
    l_wijzigingen_record.kolomnaam     := 'Datum ingang';
    l_wijzigingen_record.waarde_oud    := r_a.obw_datum_ingang;
    l_wijzigingen_record.waarde_nieuw  := r_a.obww_datum_ingang;
    l_wijzigingen_record.gewijzigd     := gewijzigd_j_n(r_a.obw_datum_ingang,r_a.obww_datum_ingang);
    PIPE ROW (l_wijzigingen_record);
    l_wijzigingen_record.kolomnaam     := 'Datum einde';
    l_wijzigingen_record.waarde_oud    := r_a.obw_datum_einde;
    l_wijzigingen_record.waarde_nieuw  := r_a.obww_datum_einde;
    l_wijzigingen_record.gewijzigd     := gewijzigd_j_n(r_a.obw_datum_einde,r_a.obww_datum_einde);
    PIPE ROW (l_wijzigingen_record);
  END LOOP;
  l_wijzigingen_tab := wijzigingen_cte ( pin_obw_id => pin_obw_id
                                       )
  ;
  FOR i IN 1..l_wijzigingen_tab.COUNT
  LOOP
    PIPE ROW (l_wijzigingen_tab(i));
  END LOOP;
  l_wijzigingen_tab := wijzigingen_dow ( pin_obw_id => pin_obw_id
                                       )
  ;
  FOR i IN 1..l_wijzigingen_tab.COUNT
  LOOP
    PIPE ROW (l_wijzigingen_tab(i));
  END LOOP;
  RETURN;
END;
--
--
FUNCTION sms_obw_wijzig_record ( pin_obw_id sms_obw_wijzig.id%TYPE
                               )
RETURN sms_obw_wijzig%ROWTYPE
IS
  /**************************************************************************
  * DESCRIPTION ophalen record ahv primary key
  *
  *
  * PARAMETERS
  * ==========
  * NAME              TYPE     DESCRIPTION
  * ----------------- -------- ---------------------------------------------
  * pin_obw_id           IN PK OBW
  *
  * HISTORY
  * =======
  * VERSION DATE       AUTHOR(S)       DESCRIPTION
  * ------- ---------- --------------- --------------------------
  *   1.0   05-08-2011 FBO             Initiele versie
  *************************************************************************/
  CURSOR a
  IS
  SELECT *
  FROM   sms_obw_wijzig
  WHERE  id = pin_obw_id
  ;
  lt_sms_obw_wijzig sms_obw_wijzig%ROWTYPE;
BEGIN
  OPEN a;
  FETCH a INTO lt_sms_obw_wijzig;
  CLOSE a;
  RETURN lt_sms_obw_wijzig;
END;
--
--
PROCEDURE del_obww  ( pin_obw_id sms_obw.id%TYPE
                    )
IS
  /**************************************************************************
  * DESCRIPTION verwijdereren van OBW wijzig record
  *
  * PARAMETERS
  * ==========
  * NAME              TYPE     DESCRIPTION
  * ----------------- -------- ---------------------------------------------
  * pin_obw_id           IN PK OBW
  *
  * HISTORY
  * =======
  * VERSION DATE       AUTHOR(S)       DESCRIPTION
  * ------- ---------- --------------- --------------------------
  *   1.0   05-08-2011 FBO             Initiele versie
  *************************************************************************/
BEGIN
  DELETE
  FROM   sms_obw_wijzig
  WHERE  id = pin_obw_id
  ;
END;
--
--
FUNCTION bestaat_obw ( pin_obw_id sms_obw.id%TYPE
                     )
RETURN BOOLEAN
IS
  /**************************************************************************
  * DESCRIPTION
  *
  * PARAMETERS
  * ==========
  * NAME              TYPE     DESCRIPTION
  * ----------------- -------- ---------------------------------------------
  * pin_obw_id           IN PK OBW
  * RETURN                     TRUE=OBW record bestaat
  *
  * HISTORY
  * =======
  * VERSION DATE       AUTHOR(S)       DESCRIPTION
  * ------- ---------- --------------- --------------------------
  *   1.0   05-08-2011 FBO             Initiele versie
  *************************************************************************/
BEGIN
  RETURN ( sms_obw_record ( pin_obw_id => pin_obw_id).id > 0);
END;
--
--
PROCEDURE update_obw ( pit_sms_obw_wijzig_record sms_obw_wijzig%ROWTYPE
                     )
IS
  /**************************************************************************
  * DESCRIPTION overschrijven obw origineel met obw wijzig
  *
  * PARAMETERS
  * ==========
  * NAME              TYPE     DESCRIPTION
  * ----------------- -------- ---------------------------------------------
  * pit_sms_obw_wijzig_record IN obw wijzig record
  *
  * HISTORY
  * =======
  * VERSION DATE       AUTHOR(S)       DESCRIPTION
  * ------- ---------- --------------- --------------------------
  *   1.0   05-08-2011 FBO             Initiele versie
  *************************************************************************/
BEGIN
    UPDATE sms_obw obw
    SET    obw.classificatie            = pit_sms_obw_wijzig_record.classificatie
    ,      obw.sbni_maatregelinhoud     = pit_sms_obw_wijzig_record.sbni_maatregelinhoud
    ,      obw.scope                    = pit_sms_obw_wijzig_record.scope
    ,      obw.interpretatie            = pit_sms_obw_wijzig_record.interpretatie
    ,      obw.hoe_werkt_het            = pit_sms_obw_wijzig_record.hoe_werkt_het
    ,      obw.toelichting_ib_programma = pit_sms_obw_wijzig_record.toelichting_ib_programma
    ,      obw.borging_controleplan     = pit_sms_obw_wijzig_record.borging_controleplan
    ,      obw.datum_ingang             = pit_sms_obw_wijzig_record.datum_ingang
    ,      obw.datum_einde              = pit_sms_obw_wijzig_record.datum_einde
    ,      obw.nrm_ids                  = pit_sms_obw_wijzig_record.nrm_ids
    ,      obw.pcs_ids                  = pit_sms_obw_wijzig_record.pcs_ids
    ,      obw.rai_id_eigenaar          = pit_sms_obw_wijzig_record.rai_id_eigenaar
    ,      obw.rai_id_beheerder         = pit_sms_obw_wijzig_record.rai_id_beheerder
    ,      obw.maatregel                = pit_sms_obw_wijzig_record.maatregel
    ,      obw.oge_id                   = pit_sms_obw_wijzig_record.oge_id
    ,      obw.prioriteit               = pit_sms_obw_wijzig_record.prioriteit
    WHERE  obw.id                       = pit_sms_obw_wijzig_record.id
    ;
END;
--
--
FUNCTION sms_normen_record ( pin_nrm_id sms_normen.id%TYPE
                           )
RETURN sms_normen%ROWTYPE
IS
  /**************************************************************************
  * DESCRIPTION ophalen record ahv primary key
  *
  *
  * PARAMETERS
  * ==========
  * NAME              TYPE     DESCRIPTION
  * ----------------- -------- ---------------------------------------------
  * pin_nrm_id              IN PK sms_normen
  *
  * HISTORY
  * =======
  * VERSION DATE       AUTHOR(S)       DESCRIPTION
  * ------- ---------- --------------- --------------------------
  *   1.0   05-08-2011 FBO             Initiele versie
  *************************************************************************/
  CURSOR a
  IS
  SELECT *
  FROM   sms_normen
  WHERE  id = pin_nrm_id
  ;
  lt_sms_normen sms_normen%ROWTYPE;
BEGIN
  OPEN a;
  FETCH a INTO lt_sms_normen;
  CLOSE a;
  RETURN lt_sms_normen;
END;
--
--
FUNCTION sms_iso_paragrafen_record ( pin_ipf_id sms_iso_paragrafen.id%TYPE
                                   )
RETURN sms_iso_paragrafen%ROWTYPE
IS
  /**************************************************************************
  * DESCRIPTION ophalen record ahv primary key
  *
  *
  * PARAMETERS
  * ==========
  * NAME              TYPE     DESCRIPTION
  * ----------------- -------- ---------------------------------------------
  * pin_ipf_id              IN PK sms_iso_paragrafen_record
  *
  * HISTORY
  * =======
  * VERSION DATE       AUTHOR(S)       DESCRIPTION
  * ------- ---------- --------------- --------------------------
  *   1.0   05-08-2011 FBO             Initiele versie
  *************************************************************************/
  CURSOR a
  IS
  SELECT *
  FROM   sms_iso_paragrafen
  WHERE  id = pin_ipf_id
  ;
  l_sms_iso_paragrafen_record sms_iso_paragrafen%ROWTYPE;
BEGIN
  OPEN a;
  FETCH a INTO l_sms_iso_paragrafen_record;
  CLOSE a;
  RETURN l_sms_iso_paragrafen_record;
END;
--
--
FUNCTION paragraaf_naam ( pin_ipf_id sms_iso_paragrafen.id%TYPE
                        )
RETURN VARCHAR2
IS
  /**************************************************************************
  * DESCRIPTION
  *
  * PARAMETERS
  * ==========
  * NAME              TYPE     DESCRIPTION
  * ----------------- -------- ---------------------------------------------
  * pin_nrm_id              IN PK sms_normen
  * RETURN                     normnaam
  *
  * HISTORY
  * =======
  * VERSION DATE       AUTHOR(S)       DESCRIPTION
  * ------- ---------- --------------- --------------------------
  *   1.0   05-08-2011 FBO             Initiele versie
  *   1.1   07-05-2012 FBO             regelgeving toegevoegd
  *************************************************************************/
  l_sms_iso_paragrafen_record sms_iso_paragrafen%ROWTYPE := sms_iso_paragrafen_record ( pin_ipf_id => pin_ipf_id
                                                                                      )
  ;
  l_sms_iso_secties_record    sms_iso_secties%ROWTYPE := sms_iso_secties_record ( pin_ise_id => l_sms_iso_paragrafen_record.ise_id
                                                                                )
  ;
  l_sms_iso_hoofdstukken_record sms_iso_hoofdstukken%ROWTYPE := sms_iso_hoofdstukken_record( pin_ihk_id => l_sms_iso_secties_record.ihk_id)
  ;
BEGIN
  RETURN RTRIM(l_sms_iso_hoofdstukken_record.regelgeving||':'||l_sms_iso_hoofdstukken_record.jaar,':')||' '||l_sms_iso_hoofdstukken_record.hoofdstuk_nr||'.'||l_sms_iso_secties_record.sectie_nr||'.'||l_sms_iso_paragrafen_record.paragraaf_nr;
END;
--
--
FUNCTION norm_naam ( pin_nrm_id sms_normen.id%TYPE
                   )
RETURN VARCHAR2
IS
  /**************************************************************************
  * DESCRIPTION
  *
  * PARAMETERS
  * ==========
  * NAME              TYPE     DESCRIPTION
  * ----------------- -------- ---------------------------------------------
  * pin_nrm_id              IN PK sms_normen
  * RETURN                     normnaam
  *
  * HISTORY
  * =======
  * VERSION DATE       AUTHOR(S)       DESCRIPTION
  * ------- ---------- --------------- --------------------------
  *   1.0   05-08-2011 FBO             Initiele versie
  *************************************************************************/
  lt_sms_normen               sms_normen%ROWTYPE := sms_normen_record ( pin_nrm_id => pin_nrm_id
                                                                      )
  ;
  l_retval                    VARCHAR2(32767);
BEGIN
    IF lt_sms_normen.ipf_id IS NOT NULL
    THEN
      l_retval := paragraaf_naam ( pin_ipf_id => lt_sms_normen.ipf_id
                                 )
    ;
  END IF;
    IF lt_sms_normen.rso_id IS NOT NULL
    THEN
      l_retval := sms_risico_naam ( pin_rso_id => lt_sms_normen.rso_id);
    END IF;
  RETURN l_retval;
END;
--
--
FUNCTION herkomst_naam ( pin_cte_id  sms_controles.id%TYPE
                       , pin_dct_id  sms_documenten.id%TYPE
                       , pin_bvg_id  sms_bevindingen.id%TYPE
                       )
RETURN VARCHAR2
IS
  /**************************************************************************
  * DESCRIPTION bij een actie dient een herkomstnaam te worden vermeld
  * deze kan drie bronnen hebben
  *
  * PARAMETERS
  * ==========
  * NAME              TYPE     DESCRIPTION
  * ----------------- -------- ---------------------------------------------
  * pin_cte_id              IN PK controle
  * pin_dct_id              IN PK document
  * pin_bvg_id              IN PK bevinding
  * RETURN                     herkomstnaam
  *
  * HISTORY
  * =======
  * VERSION DATE       AUTHOR(S)       DESCRIPTION
  * ------- ---------- --------------- --------------------------
  *   1.0   05-08-2011 FBO             Initiele versie
  *************************************************************************/
BEGIN
  RETURN CASE
           WHEN pin_dct_id > 0 THEN 'DOCUMENT: '||sms_pck.doc_naam(pin_dct_id)
           WHEN pin_bvg_id > 0 THEN 'BEVINDING: '||sms_pck.bevinding_naam(pin_bvg_id)
           WHEN pin_cte_id > 0 THEN 'CONTROLE: '||sms_pck.controle_naam(pin_cte_id)
         END;
END;
--
--
FUNCTION herkomst_type ( pin_cte_id  sms_controles.id%TYPE
                       , pin_dct_id  sms_documenten.id%TYPE
                       , pin_bvg_id  sms_bevindingen.id%TYPE
                       )
RETURN VARCHAR2
IS
  /**************************************************************************
  * DESCRIPTION bij een actie dient de herkomst te worden bepaald
  * deze kan drie bronnen hebben
  *
  * PARAMETERS
  * ==========
  * NAME              TYPE     DESCRIPTION
  * ----------------- -------- ---------------------------------------------
  * pin_cte_id              IN PK controle
  * pin_dct_id              IN PK document
  * pin_bvg_id              IN PK bevinding
  * RETURN                     DOCUMENT/BEVINDING/CONTROLE
  *
  * HISTORY
  * =======
  * VERSION DATE       AUTHOR(S)       DESCRIPTION
  * ------- ---------- --------------- --------------------------
  *   1.0   05-08-2011 FBO             Initiele versie
  *************************************************************************/
BEGIN
  RETURN CASE
           WHEN pin_dct_id > 0 THEN 'DOCUMENT'
           WHEN pin_bvg_id > 0 THEN 'BEVINDING'
           WHEN pin_cte_id > 0 THEN 'CONTROLE'
         END;
END;
--
--


FUNCTION sms_acties_record ( pin_cae_id sms_acties.id%TYPE
                           )
RETURN sms_acties%ROWTYPE
IS
  /**************************************************************************
  * DESCRIPTION ophalen record ahv primary key
  *
  *
  * PARAMETERS
  * ==========
  * NAME              TYPE     DESCRIPTION
  * ----------------- -------- ---------------------------------------------
  * pin_cae_id                 IN PK acties
  *
  * HISTORY
  * =======
  * VERSION DATE       AUTHOR(S)       DESCRIPTION
  * ------- ---------- --------------- --------------------------
  *   1.0   05-08-2011 FBO             Initiele versie
  *************************************************************************/
  CURSOR a
  IS
  SELECT *
  FROM   sms_acties
  WHERE  id = pin_cae_id
  ;
  lt_sms_acties sms_acties%ROWTYPE;
BEGIN
  OPEN a;
  FETCH a INTO lt_sms_acties;
  CLOSE a;
  RETURN lt_sms_acties;
END;


FUNCTION actie_naam ( pin_cae_id sms_acties.id%TYPE
                    )
RETURN VARCHAR2
IS
  /**************************************************************************
  * DESCRIPTION
  *
  * PARAMETERS
  * ==========
  * NAME              TYPE     DESCRIPTION
  * ----------------- -------- ---------------------------------------------
  * pin_cae_id              IN PK acties
  * RETURN                     actienaam
  *
  * HISTORY
  * =======
  * VERSION DATE       AUTHOR(S)       DESCRIPTION
  * ------- ---------- --------------- --------------------------
  *   1.0   05-08-2011 FBO             Initiele versie
  *************************************************************************/
  l_sms_acties_record sms_acties%ROWTYPE;
BEGIN
  l_sms_acties_record := sms_acties_record ( pin_cae_id => pin_cae_id);
  RETURN 'Datum uitvoering'||l_sms_acties_record.datum_uitvoering||' '||l_sms_acties_record.status||' '||functie_naam(l_sms_acties_record.rai_id);
END;
--
--
FUNCTION acties_bij_controle ( pin_cte_id sms_controles.id%TYPE
                             )
RETURN VARCHAR2
IS
  /**************************************************************************
  * DESCRIPTION
  *
  * PARAMETERS
  * ==========
  * NAME              TYPE     DESCRIPTION
  * ----------------- -------- ---------------------------------------------
  * pin_cae_id              IN PK acties
  * RETURN                     string met actienamen bij controle
  *
  * HISTORY
  * =======
  * VERSION DATE       AUTHOR(S)       DESCRIPTION
  * ------- ---------- --------------- --------------------------
  *   1.0   05-08-2011 FBO             Initiele versie
  *************************************************************************/
  CURSOR a
  IS
  SELECT actie_naam ( cae.id) actie
  FROM   sms_acties cae
  WHERE  cae.cte_id = pin_cte_id
  AND    EXTRACT(YEAR FROM SYSDATE) = EXTRACT(YEAR FROM datum_uitvoering)
  ;
  l_retval VARCHAR2(32767);
BEGIN
  FOR r_a IN a
  LOOP
    l_retval := l_retval||r_a.actie||g_komma;
  END LOOP;
  IF l_retval IS NOT NULL
  THEN
    l_retval := ' ACTIES: '||RTRIM(l_retval,g_komma);
  END IF;
  RETURN l_retval;
END;
--
--
FUNCTION acties_bij_bevindingen ( pin_bvg_id sms_controles.id%TYPE
                                )
RETURN VARCHAR2
IS
  /**************************************************************************
  * DESCRIPTION
  *
  * PARAMETERS
  * ==========
  * NAME              TYPE     DESCRIPTION
  * ----------------- -------- ---------------------------------------------
  * pin_bvg_id              IN PK bevinding
  * RETURN                     string met actienamen bij bevinding
  *
  * HISTORY
  * =======
  * VERSION DATE       AUTHOR(S)       DESCRIPTION
  * ------- ---------- --------------- --------------------------
  *   1.0   05-08-2011 FBO             Initiele versie
  *************************************************************************/
  CURSOR a
  IS
  SELECT actie_naam ( cae.id) actie
  FROM   sms_acties cae
  WHERE  cae.bvg_id = pin_bvg_id
  AND    EXTRACT(YEAR FROM SYSDATE) = EXTRACT(YEAR FROM datum_uitvoering)
  ;
  l_retval VARCHAR2(32767);
BEGIN
  FOR r_a IN a
  LOOP
    l_retval := l_retval||r_a.actie||g_komma;
  END LOOP;
  IF l_retval IS NOT NULL
  THEN
    l_retval := ' ACTIES: '||RTRIM(l_retval,g_komma);
  END IF;
  RETURN l_retval;
END;


FUNCTION controles_bij_obw ( pin_obw_id sms_obw.id%TYPE
                           )
RETURN VARCHAR2
IS
  /**************************************************************************
  * DESCRIPTION
  *
  * PARAMETERS
  * ==========
  * NAME              TYPE     DESCRIPTION
  * ----------------- -------- ---------------------------------------------
  * pin_obw_id           IN PK OBW
  * RETURN                     string met controlenamen bij OBW
  *
  * HISTORY
  * =======
  * VERSION DATE       AUTHOR(S)       DESCRIPTION
  * ------- ---------- --------------- --------------------------
  *   1.0   05-08-2011 FBO             Initiele versie
  *************************************************************************/
  CURSOR a
  IS
  SELECT controle_naam ( cte.id) controle
  ,      cte.id cte_id
  FROM   sms_controles cte
  WHERE  cte.obw_id = pin_obw_id
  ;
  l_teller PLS_INTEGER := 0;
  l_retval VARCHAR2(32767);
BEGIN
  FOR r_a IN a
  LOOP
    l_teller := l_teller + 1;
    l_retval := l_retval||'#'||l_teller||':'||r_a.controle||acties_bij_controle (r_a.cte_id)||g_break;
  END LOOP;
  IF l_retval IS NOT NULL
  THEN
    l_retval := SUBSTR(RTRIM(l_retval,g_break),1,32767);
  END IF;
  RETURN l_retval;
END;
--
--
FUNCTION bevindingen_bij_obw ( pin_obw_id           sms_obw.id%TYPE
                             , pin_uitsluitend_open VARCHAR2 DEFAULT NULL
                             )
RETURN VARCHAR2
IS
  /**************************************************************************
  * DESCRIPTION
  *
  * PARAMETERS
  * ==========
  * NAME              TYPE     DESCRIPTION
  * ----------------- -------- ---------------------------------------------
  * pin_obw_id           IN PK OBW
  * RETURN                     string met bevindingen bij OBW
  *
  * HISTORY
  * =======
  * VERSION DATE       AUTHOR(S)       DESCRIPTION
  * ------- ---------- --------------- --------------------------
  *   1.0   05-08-2011 FBO             Initiele versie
  *************************************************************************/
  CURSOR a
  IS
  SELECT bevinding_naam ( cte.id) bevinding
  ,      cte.id cte_id
  FROM   sms_bevindingen cte
  WHERE  cte.obw_id = pin_obw_id
  AND    ( pin_uitsluitend_open IS NULL OR ( GEREED_IND='N' OR REVIEW_IND='N'))
  ;
  l_teller PLS_INTEGER := 0;
  l_retval VARCHAR2(32767);
BEGIN
  FOR r_a IN a
  LOOP
    l_teller := l_teller + 1;
    l_retval := l_retval||'#'||l_teller||':'||r_a.bevinding||acties_bij_bevindingen (r_a.cte_id)||g_break;
  END LOOP;
  IF l_retval IS NOT NULL
  THEN
    l_retval := RTRIM(l_retval,g_break);
  END IF;
  RETURN l_retval;
END;
--
--
FUNCTION documenten_bij_obw ( pin_obw_id sms_obw.id%TYPE
                            )
RETURN VARCHAR2
IS
  /**************************************************************************
  * DESCRIPTION
  *
  * PARAMETERS
  * ==========
  * NAME              TYPE     DESCRIPTION
  * ----------------- -------- ---------------------------------------------
  * pin_obw_id           IN PK OBW wijzig
  * RETURN                     string met documenten bij OBW
  *
  * HISTORY
  * =======
  * VERSION DATE       AUTHOR(S)       DESCRIPTION
  * ------- ---------- --------------- --------------------------
  *   1.0   05-08-2011 FBO             Initiele versie
  *************************************************************************/
  l_retval VARCHAR2(32767);
BEGIN
  SELECT RTRIM (XMLAGG (XMLELEMENT (e, doc_naam ( dow.dct_id) || ',')).EXTRACT ('//text()'), ',')
  INTO   l_retval
  FROM   sms_documenten_obw dow
  WHERE  dow.obw_id = pin_obw_id
  ;
  RETURN l_retval;
END;
--
--
FUNCTION documenten_bij_obw_wijzig ( pin_obw_id sms_obw.id%TYPE
                                   )
RETURN VARCHAR2
IS
  /**************************************************************************
  * DESCRIPTION
  *
  * PARAMETERS
  * ==========
  * NAME              TYPE     DESCRIPTION
  * ----------------- -------- ---------------------------------------------
  * pin_obw_id           IN PK OBW wijzig
  * RETURN                     string met documenten bij OBW
  *
  * HISTORY
  * =======
  * VERSION DATE       AUTHOR(S)       DESCRIPTION
  * ------- ---------- --------------- --------------------------
  *   1.0   05-08-2011 FBO             Initiele versie
  *************************************************************************/
  l_retval VARCHAR2(32767);
BEGIN
  SELECT RTRIM (XMLAGG (XMLELEMENT (e, doc_naam ( dow.dct_id) || ',')).EXTRACT ('//text()'), ',')
  INTO   l_retval
  FROM   sms_documenten_obw_wijzig dow
  WHERE  dow.obw_id = pin_obw_id
  AND    dow.dct_id > 0
  ;
  RETURN l_retval;
END;
--
--
PROCEDURE aanmaken_dow_wijzig ( pin_dow_id     sms_documenten.id%TYPE
                              , pov_status OUT VARCHAR2
                              )
IS
  /**************************************************************************
  * DESCRIPTION
  *
  * PARAMETERS
  * ==========
  * NAME              TYPE     DESCRIPTION
  * ----------------- -------- ---------------------------------------------
  * pin_dow_id              IN PK sms_documenten_obw_wijzig
  * pov_status             OUT NIEUW=nieuw record sms_documenten_obw_wijzig aangemaakt
  *
  * HISTORY
  * =======
  * VERSION DATE       AUTHOR(S)       DESCRIPTION
  * ------- ---------- --------------- --------------------------
  *   1.0   05-08-2011 FBO             Initiele versie
  *************************************************************************/
  l_sms_documenten_obw_record sms_documenten_obw%ROWTYPE;
  FUNCTION bestaat_doww_record
  RETURN BOOLEAN
  IS
    l_aantal PLS_INTEGER;
  BEGIN
    SELECT COUNT(*)
    INTO   l_aantal
    FROM   sms_documenten_obw_wijzig doww
    WHERE  doww.id = pin_dow_id
    AND    ROWNUM < 2
    ;
    RETURN (l_aantal=1);
  END;
BEGIN
  IF  pin_dow_id IS NOT NULL
  AND NOT bestaat_doww_record
  THEN
    l_sms_documenten_obw_record := sms_documenten_obw_record ( pin_dow_id => pin_dow_id
                                                             )
    ;
    INSERT
    INTO   sms_documenten_obw_wijzig
    VALUES l_sms_documenten_obw_record
    ;
    aanmaken_obw_wijzig ( pin_obw_id => l_sms_documenten_obw_record.obw_id
                        )
    ;
    pov_status := 'NIEUW';
  END IF;
END;
--
--
FUNCTION wijzigingen_dow ( pin_obw_id sms_obw.id%TYPE
                         )
RETURN wijzigingen_tab
IS
  /**************************************************************************
  * DESCRIPTION
  *
  * PARAMETERS
  * ==========
  * NAME              TYPE     DESCRIPTION
  * ----------------- -------- ---------------------------------------------
  * pin_obw_id           IN PK OBW
  * RETURN                     array oude en nieuwe waarden van sms_documenten_obw
  *
  * HISTORY
  * =======
  * VERSION DATE       AUTHOR(S)       DESCRIPTION
  * ------- ---------- --------------- --------------------------
  *   1.0   05-08-2011 FBO             Initiele versie
  *************************************************************************/
  l_wijzigingen_record      gewijzigd_rec;
  l_waarde_nieuw            VARCHAR2(32767);
  l_waarde_oud              VARCHAR2(32767);
  l_wijzigingen_tab         wijzigingen_tab := wijzigingen_tab();
  lb_sms_doc_obw_gewijzigd  BOOLEAN;
  CURSOR c_insert_doww
  IS
  SELECT *
  FROM   sms_documenten_obw_wijzig doww
  WHERE  obw_id = pin_obw_id
  AND    verwijder_ind = 'N'  --trucje om uitsluitend gewijzigd of nieuwe te selecteren
  ;
  CURSOR c_del_dow
  IS
  SELECT *
  FROM   sms_documenten_obw dow
  WHERE  obw_id = pin_obw_id
  AND    verwijder_ind = 'J'
  ;
BEGIN
  FOR r_insert_doww IN c_insert_doww
  LOOP
    l_waarde_nieuw := sms_pck.doc_naam ( r_insert_doww.dct_id
                                       )
    ;
    l_waarde_oud   := NULL;
    l_wijzigingen_record.bron          := 'Document';
    l_wijzigingen_record.kolomnaam     := 'DOCUMENTEN bij OBW';
    l_wijzigingen_record.waarde_oud    := l_waarde_oud;
    l_wijzigingen_record.waarde_nieuw  := l_waarde_nieuw;
    l_wijzigingen_record.gewijzigd     := gewijzigd_j_n(l_wijzigingen_record.waarde_oud,l_wijzigingen_record.waarde_nieuw);
    l_wijzigingen_tab.EXTEND;
    l_wijzigingen_tab(l_wijzigingen_tab.COUNT) := l_wijzigingen_record;
  END LOOP;
  FOR r_del_dow IN c_del_dow
  LOOP
    l_waarde_oud := sms_pck.doc_naam ( r_del_dow.dct_id
                                     )
    ;
    l_waarde_nieuw   := NULL;
    l_wijzigingen_record.bron          := 'Document';
    l_wijzigingen_record.kolomnaam     := 'DOCUMENTEN bij OBW';
    l_wijzigingen_record.waarde_oud    := l_waarde_oud;
    l_wijzigingen_record.waarde_nieuw  := l_waarde_nieuw;
    l_wijzigingen_record.gewijzigd     := gewijzigd_j_n(l_wijzigingen_record.waarde_oud,l_wijzigingen_record.waarde_nieuw);
    l_wijzigingen_tab.EXTEND;
    l_wijzigingen_tab(l_wijzigingen_tab.COUNT) := l_wijzigingen_record;
  END LOOP;
  RETURN l_wijzigingen_tab;
END;
--
--
PROCEDURE del_doww  ( pin_obw_id sms_obw.id%TYPE
                    )
IS
  /**************************************************************************
  * DESCRIPTION verwijderen sms_documenten_obw_wijzig records
  *
  * PARAMETERS
  * ==========
  * NAME              TYPE     DESCRIPTION
  * ----------------- -------- ---------------------------------------------
  * pin_obw_id           IN PK OBW
  *
  * HISTORY
  * =======
  * VERSION DATE       AUTHOR(S)       DESCRIPTION
  * ------- ---------- --------------- --------------------------
  *   1.0   05-08-2011 FBO             Initiele versie
  *************************************************************************/
BEGIN
  DELETE
  FROM   sms_documenten_obw_wijzig
  WHERE  obw_id = pin_obw_id
  ;
END;
--
--
PROCEDURE del_doww ( pin_dow_id sms_documenten.id%TYPE
                   )
IS
  /**************************************************************************
  * DESCRIPTION verwijderen sms_documenten_obw_wijzig record
  *
  * PARAMETERS
  * ==========
  * NAME              TYPE     DESCRIPTION
  * ----------------- -------- ---------------------------------------------
  * pin_dow_id              IN PK sms_documenten_obw_wijzig
  *
  * HISTORY
  * =======
  * VERSION DATE       AUTHOR(S)       DESCRIPTION
  * ------- ---------- --------------- --------------------------
  *   1.0   05-08-2011 FBO             Initiele versie
  *************************************************************************/
BEGIN
  DELETE
  FROM   sms_documenten_obw_wijzig
  WHERE  id = pin_dow_id
  ;
END;
--
--
PROCEDURE zet_dow_op_verwijderd ( pin_dow_id sms_documenten.id%TYPE
                                )
IS
  /**************************************************************************
  * DESCRIPTION sms_documenten_obw op verwijderd zetten
  *
  * PARAMETERS
  * ==========
  * NAME              TYPE     DESCRIPTION
  * ----------------- -------- ---------------------------------------------
  * pin_dow_id              IN PK sms_documenten_obw_wijzig
  *
  * HISTORY
  * =======
  * VERSION DATE       AUTHOR(S)       DESCRIPTION
  * ------- ---------- --------------- --------------------------
  *   1.0   05-08-2011 FBO             Initiele versie
  *************************************************************************/
BEGIN
  UPDATE sms_documenten_obw
  SET    verwijder_ind = 'J'
  WHERE  id = pin_dow_id
  ;
END;
--
--
PROCEDURE wijzigingen_dow_akkoord ( pin_obw_id sms_obw.id%TYPE
                                  )
IS
  /**************************************************************************
  * DESCRIPTION wijzigingen sms_documenten_obw akkoord
  *
  * PARAMETERS
  * ==========
  * NAME              TYPE     DESCRIPTION
  * ----------------- -------- ---------------------------------------------
  * pin_obw_id           IN PK OBW
  *
  * HISTORY
  * =======
  * VERSION DATE       AUTHOR(S)       DESCRIPTION
  * ------- ---------- --------------- --------------------------
  *   1.0   05-08-2011 FBO             Initiele versie
  *************************************************************************/
  lt_sms_dow_wijzig sms_documenten_obw_wijzig%ROWTYPE;
  ln_aantal PLS_INTEGER;
  lb_dow_verwijderen BOOLEAN;
BEGIN
  DELETE
  FROM   sms_documenten_obw
  WHERE  obw_id = pin_obw_id
  AND    verwijder_ind = 'J'
  ;
  INSERT
  INTO   sms_documenten_obw
  SELECT *
  FROM   sms_documenten_obw_wijzig
  WHERE  obw_id = pin_obw_id
  AND    verwijder_ind = 'N'
  ;
  del_doww ( pin_obw_id => pin_obw_id
           )
  ;
END;
--
--
PROCEDURE wijzigingen_dow_niet_akkoord ( pin_obw_id sms_obw.id%TYPE
                                       )
IS
  /**************************************************************************
  * DESCRIPTION wijzigingen sms_documenten_obw NIET akkoord
  *
  * PARAMETERS
  * ==========
  * NAME              TYPE     DESCRIPTION
  * ----------------- -------- ---------------------------------------------
  * pin_obw_id           IN PK OBW
  *
  * HISTORY
  * =======
  * VERSION DATE       AUTHOR(S)       DESCRIPTION
  * ------- ---------- --------------- --------------------------
  *   1.0   05-08-2011 FBO             Initiele versie
  *************************************************************************/
BEGIN
  del_doww ( pin_obw_id => pin_obw_id
           )
  ;
  UPDATE sms_documenten_obw
  SET    verwijder_ind = NULL
  WHERE  obw_id = pin_obw_id
  AND    verwijder_ind = 'J'
  ;
END;
--
--
PROCEDURE aanmaken_cte_wijzig ( pin_cte_id     sms_documenten.id%TYPE
                              , pov_status OUT VARCHAR2
                              )
IS
  /**************************************************************************
  * DESCRIPTION
  *
  * PARAMETERS
  * ==========
  * NAME              TYPE     DESCRIPTION
  * ----------------- -------- ---------------------------------------------
  * pin_cte_id              IN PK controle
  * pov_status             OUT NIEUW=nieuw record sms_controles_wijzig
  *
  * HISTORY
  * =======
  * VERSION DATE       AUTHOR(S)       DESCRIPTION
  * ------- ---------- --------------- --------------------------
  *   1.0   05-08-2011 FBO             Initiele versie
  *************************************************************************/
  l_sms_controles_record sms_controles%ROWTYPE;
  FUNCTION bestaat_ctew_record
  RETURN BOOLEAN
  IS
    l_aantal PLS_INTEGER;
  BEGIN
    SELECT COUNT(*)
    INTO   l_aantal
    FROM   sms_controles_wijzig ctew
    WHERE  ctew.id = pin_cte_id
    AND    ROWNUM < 2
    ;
    RETURN (l_aantal=1);
  END;
BEGIN
  IF  pin_cte_id IS NOT NULL
  AND NOT bestaat_ctew_record
  THEN
    l_sms_controles_record := sms_controles_record ( pin_cte_id => pin_cte_id
                                                   )
    ;
    INSERT
    INTO   sms_controles_wijzig
    VALUES l_sms_controles_record
    ;
    aanmaken_obw_wijzig ( pin_obw_id => l_sms_controles_record.obw_id
                        )
    ;
    pov_status := 'NIEUW';
  END IF;
END;
--
--
FUNCTION wijzigingen_cte ( pin_obw_id sms_obw.id%TYPE
                         )
RETURN wijzigingen_tab
IS
  /**************************************************************************
  * DESCRIPTION
  *
  * PARAMETERS
  * ==========
  * NAME              TYPE     DESCRIPTION
  * ----------------- -------- ---------------------------------------------
  * pin_obw_id           IN PK OBW
  * RETURN                     array oude en nieuwe waarden van controle
  *
  * HISTORY
  * =======
  * VERSION DATE       AUTHOR(S)       DESCRIPTION
  * ------- ---------- --------------- --------------------------
  *   1.0   05-08-2011 FBO             Initiele versie
  *   1.1   25-06-2012 FBO             namen gewijzigd
  *************************************************************************/
  l_wijzigingen_record      gewijzigd_rec;
  l_waarde_nieuw            VARCHAR2(32767);
  l_waarde_oud              VARCHAR2(32767);
  l_wijzigingen_tab         wijzigingen_tab := wijzigingen_tab();
  lb_sms_doc_obw_gewijzigd  BOOLEAN;
  CURSOR a
  IS
  SELECT *
  FROM   ( SELECT cte.obw_id obw_id
           ,      ctew.rapportage ctew_rapportage
           ,      cte.rapportage cte_rapportage
           ,      ctew.controle_inhoud ctew_controle_inhoud
           ,      cte.controle_inhoud cte_controle_inhoud
           ,      ctew.frequentie ctew_frequentie
           ,      cte.frequentie cte_frequentie
           ,      cte.id cte_id
           ,      ctew.creation_date
           ,      ctew.update_date
           ,      proces_naam(cte.pcs_id) cte_proces
           ,      proces_naam(ctew.pcs_id) ctew_proces
           ,      functie_naam(cte.rai_id_resp_werking) cte_resp_werking
           ,      functie_naam(ctew.rai_id_resp_werking) ctew_resp_werking
           ,      ctew.prioriteit ctew_prioriteit
           ,      cte.prioriteit cte_prioriteit
           FROM   sms_controles_wijzig ctew
           ,      sms_controles cte
           WHERE  ctew.obw_id = pin_obw_id
           AND    cte.id(+) = ctew.id
         )
  WHERE  cte_id IS NULL
  OR     creation_date != update_date
  ;
  CURSOR c_del_cte
  IS
  SELECT *
  FROM   sms_controles cte
  WHERE  obw_id = pin_obw_id
  AND    verwijder_ind = 'J'
  ;
BEGIN
  FOR r_a IN a
  LOOP
    l_waarde_nieuw := r_a.ctew_rapportage;
    l_waarde_oud   := r_a.cte_rapportage;
    l_wijzigingen_record.bron          := 'Controle';
    l_wijzigingen_record.kolomnaam     := 'Rapportage';
    l_wijzigingen_record.waarde_oud    := l_waarde_oud;
    l_wijzigingen_record.waarde_nieuw  := l_waarde_nieuw;
    l_wijzigingen_record.gewijzigd     := gewijzigd_j_n(l_wijzigingen_record.waarde_oud,l_wijzigingen_record.waarde_nieuw);
    l_wijzigingen_tab.EXTEND;
    l_wijzigingen_tab(l_wijzigingen_tab.COUNT) := l_wijzigingen_record;
    l_waarde_nieuw := r_a.ctew_controle_inhoud;
    l_waarde_oud   := r_a.cte_controle_inhoud;
    l_wijzigingen_record.kolomnaam     := 'Controle inhoud';
    l_wijzigingen_record.waarde_oud    := l_waarde_oud;
    l_wijzigingen_record.waarde_nieuw  := l_waarde_nieuw;
    l_wijzigingen_record.gewijzigd     := gewijzigd_j_n(l_wijzigingen_record.waarde_oud,l_wijzigingen_record.waarde_nieuw);
    l_wijzigingen_tab.EXTEND;
    l_wijzigingen_tab(l_wijzigingen_tab.COUNT) := l_wijzigingen_record;
    l_waarde_nieuw := r_a.ctew_frequentie;
    l_waarde_oud   := r_a.cte_frequentie;
    l_wijzigingen_record.kolomnaam     := 'Frequentie';
    l_wijzigingen_record.waarde_oud    := l_waarde_oud;
    l_wijzigingen_record.waarde_nieuw  := l_waarde_nieuw;
    l_wijzigingen_record.gewijzigd     := gewijzigd_j_n(l_wijzigingen_record.waarde_oud,l_wijzigingen_record.waarde_nieuw);
    l_wijzigingen_tab.EXTEND;
    l_wijzigingen_tab(l_wijzigingen_tab.COUNT) := l_wijzigingen_record;
    --
    l_waarde_nieuw := r_a.ctew_prioriteit;
    l_waarde_oud   := r_a.cte_prioriteit;
    l_wijzigingen_record.kolomnaam     := 'prioriteit';
    l_wijzigingen_record.waarde_oud    := l_waarde_oud;
    l_wijzigingen_record.waarde_nieuw  := l_waarde_nieuw;
    l_wijzigingen_record.gewijzigd     := gewijzigd_j_n(l_wijzigingen_record.waarde_oud,l_wijzigingen_record.waarde_nieuw);
    l_wijzigingen_tab.EXTEND;
    l_wijzigingen_tab(l_wijzigingen_tab.COUNT) := l_wijzigingen_record;
    --
    l_waarde_nieuw := r_a.ctew_proces;
    l_waarde_oud   := r_a.cte_proces;
    l_wijzigingen_record.kolomnaam     := 'Proces';
    l_wijzigingen_record.waarde_oud    := l_waarde_oud;
    l_wijzigingen_record.waarde_nieuw  := l_waarde_nieuw;
    l_wijzigingen_record.gewijzigd     := gewijzigd_j_n(l_wijzigingen_record.waarde_oud,l_wijzigingen_record.waarde_nieuw);
    l_wijzigingen_tab.EXTEND;
    l_wijzigingen_tab(l_wijzigingen_tab.COUNT) := l_wijzigingen_record;
    l_waarde_nieuw := r_a.ctew_resp_werking;
    l_waarde_oud   := r_a.cte_resp_werking;
    l_wijzigingen_record.kolomnaam     := 'Uitvoeren';
    l_wijzigingen_record.waarde_oud    := l_waarde_oud;
    l_wijzigingen_record.waarde_nieuw  := l_waarde_nieuw;
    l_wijzigingen_record.gewijzigd     := gewijzigd_j_n(l_wijzigingen_record.waarde_oud,l_wijzigingen_record.waarde_nieuw);
    l_wijzigingen_tab.EXTEND;
    l_wijzigingen_tab(l_wijzigingen_tab.COUNT) := l_wijzigingen_record;
  END LOOP;
  FOR r_del_cte IN c_del_cte
  LOOP
    l_waarde_nieuw := NULL;
    l_waarde_oud   := r_del_cte.rapportage;
    l_wijzigingen_record.bron          := 'Controle';
    l_wijzigingen_record.kolomnaam     := 'rapportage';
    l_wijzigingen_record.waarde_oud    := l_waarde_oud;
    l_wijzigingen_record.waarde_nieuw  := l_waarde_nieuw;
    l_wijzigingen_record.gewijzigd     := gewijzigd_j_n(l_wijzigingen_record.waarde_oud,l_wijzigingen_record.waarde_nieuw);
    l_wijzigingen_tab.EXTEND;
    l_wijzigingen_tab(l_wijzigingen_tab.COUNT) := l_wijzigingen_record;
    l_waarde_nieuw := NULL;
    l_waarde_oud   := r_del_cte.controle_inhoud;
    l_wijzigingen_record.kolomnaam     := 'Controle inhoud';
    l_wijzigingen_record.waarde_oud    := l_waarde_oud;
    l_wijzigingen_record.waarde_nieuw  := l_waarde_nieuw;
    l_wijzigingen_record.gewijzigd     := gewijzigd_j_n(l_wijzigingen_record.waarde_oud,l_wijzigingen_record.waarde_nieuw);
    l_wijzigingen_tab.EXTEND;
    l_wijzigingen_tab(l_wijzigingen_tab.COUNT) := l_wijzigingen_record;
    l_waarde_nieuw := NULL;
    l_waarde_oud   := r_del_cte.frequentie;
    l_wijzigingen_record.kolomnaam     := 'Frequentie';
    l_wijzigingen_record.waarde_oud    := l_waarde_oud;
    l_wijzigingen_record.waarde_nieuw  := l_waarde_nieuw;
    l_wijzigingen_record.gewijzigd     := gewijzigd_j_n(l_wijzigingen_record.waarde_oud,l_wijzigingen_record.waarde_nieuw);
    l_wijzigingen_tab.EXTEND;
    l_wijzigingen_tab(l_wijzigingen_tab.COUNT) := l_wijzigingen_record;
    l_waarde_nieuw := NULL;
    l_waarde_oud   := r_del_cte.prioriteit;
    l_wijzigingen_record.kolomnaam     := 'prioriteit';
    l_wijzigingen_record.waarde_oud    := l_waarde_oud;
    l_wijzigingen_record.waarde_nieuw  := l_waarde_nieuw;
    l_wijzigingen_record.gewijzigd     := gewijzigd_j_n(l_wijzigingen_record.waarde_oud,l_wijzigingen_record.waarde_nieuw);
    l_wijzigingen_tab.EXTEND;
    l_wijzigingen_tab(l_wijzigingen_tab.COUNT) := l_wijzigingen_record;
    l_waarde_nieuw := NULL;
    l_waarde_oud   := proces_naam(r_del_cte.pcs_id);
    l_wijzigingen_record.kolomnaam     := 'Proces';
    l_wijzigingen_record.waarde_oud    := l_waarde_oud;
    l_wijzigingen_record.waarde_nieuw  := l_waarde_nieuw;
    l_wijzigingen_record.gewijzigd     := gewijzigd_j_n(l_wijzigingen_record.waarde_oud,l_wijzigingen_record.waarde_nieuw);
    l_wijzigingen_tab.EXTEND;
    l_wijzigingen_tab(l_wijzigingen_tab.COUNT) := l_wijzigingen_record;
    l_waarde_nieuw := NULL;
    l_waarde_oud   := functie_naam(r_del_cte.rai_id_resp_werking);
    l_wijzigingen_record.kolomnaam     := 'Uitvoerder';
    l_wijzigingen_record.waarde_oud    := l_waarde_oud;
    l_wijzigingen_record.waarde_nieuw  := l_waarde_nieuw;
    l_wijzigingen_record.gewijzigd     := gewijzigd_j_n(l_wijzigingen_record.waarde_oud,l_wijzigingen_record.waarde_nieuw);
    l_wijzigingen_tab.EXTEND;
    l_wijzigingen_tab(l_wijzigingen_tab.COUNT) := l_wijzigingen_record;
  END LOOP;
  RETURN l_wijzigingen_tab;
END;
--
--
PROCEDURE del_ctew  ( pin_obw_id sms_obw.id%TYPE
                    )
IS
  /**************************************************************************
  * DESCRIPTION verwijderen sms_controles_wijzig
  *
  * PARAMETERS
  * ==========
  * NAME              TYPE     DESCRIPTION
  * ----------------- -------- ---------------------------------------------
  * pin_obw_id           IN PK OBW
  *
  * HISTORY
  * =======
  * VERSION DATE       AUTHOR(S)       DESCRIPTION
  * ------- ---------- --------------- --------------------------
  *   1.0   05-08-2011 FBO             Initiele versie
  *************************************************************************/
BEGIN
  DELETE
  FROM   sms_controles_wijzig
  WHERE  obw_id = pin_obw_id
  ;
END;
--
--
PROCEDURE del_ctew  ( pin_dce_id sms_controles.id%TYPE
                    )
IS
  /**************************************************************************
  * DESCRIPTION verwijderen sms_controles_wijzig
  *
  * PARAMETERS
  * ==========
  * NAME              TYPE     DESCRIPTION
  * ----------------- -------- ---------------------------------------------
  * pin_dce_id              IN PK sms_controles_wijzig
  *
  * HISTORY
  * =======
  * VERSION DATE       AUTHOR(S)       DESCRIPTION
  * ------- ---------- --------------- --------------------------
  *   1.0   05-08-2011 FBO             Initiele versie
  *************************************************************************/
BEGIN
  DELETE
  FROM   sms_controles_wijzig
  WHERE  id = pin_dce_id
  ;
END;
--
--
PROCEDURE zet_cte_op_verwijderd ( pin_cte_id sms_documenten.id%TYPE
                                )
IS
  /**************************************************************************
  * DESCRIPTION controle record op verwijderd zetten
  *
  * PARAMETERS
  * ==========
  * NAME              TYPE     DESCRIPTION
  * ----------------- -------- ---------------------------------------------
  * pin_dce_id              IN PK sms_controle
  *
  * HISTORY
  * =======
  * VERSION DATE       AUTHOR(S)       DESCRIPTION
  * ------- ---------- --------------- --------------------------
  *   1.0   05-08-2011 FBO             Initiele versie
  *************************************************************************/
BEGIN
  UPDATE sms_controles
  SET    verwijder_ind = 'J'
  WHERE  id = pin_cte_id
  ;
END;
--
--
PROCEDURE wijzigingen_cte_akkoord ( pin_obw_id sms_obw.id%TYPE
                                  )
IS
  /**************************************************************************
  * DESCRIPTION wijzigingen controle akkoord
  *
  * PARAMETERS
  * ==========
  * NAME              TYPE     DESCRIPTION
  * ----------------- -------- ---------------------------------------------
  * pin_obw_id           IN PK OBW
  *
  * HISTORY
  * =======
  * VERSION DATE       AUTHOR(S)       DESCRIPTION
  * ------- ---------- --------------- --------------------------
  *   1.0   05-08-2011 FBO             Initiele versie
  *************************************************************************/
  lt_sms_cte_wijzig  sms_controles_wijzig%ROWTYPE;
  ln_aantal          PLS_INTEGER;
  lb_cte_verwijderen BOOLEAN;
  --
  --
  CURSOR a
  IS
  SELECT *
  FROM   sms_controles_wijzig
  WHERE  obw_id = pin_obw_id
  AND    verwijder_ind = 'N'
  ;
  --
  --
BEGIN
  DELETE
  FROM   sms_controles
  WHERE  obw_id = pin_obw_id
  AND    verwijder_ind = 'J'
  ;
  FOR r_a IN a
  LOOP
    IF bestaat_sms_controles ( pin_cte_id => r_a.id
                             )
    THEN
      UPDATE sms_controles
      SET    rapportage              = r_a.rapportage
      ,      controle_inhoud         = r_a.controle_inhoud
      ,      frequentie              = r_a.frequentie
      ,      prioriteit              = r_a.prioriteit
      ,      pcs_id                  = r_a.pcs_id
      ,      rai_id_resp_werking     = r_a.rai_id_resp_werking
      WHERE  id = r_a.id
      ;
    ELSE
      INSERT
      INTO   sms_controles
      VALUES r_a
      ;
    END IF;
  END LOOP;
  del_ctew ( pin_obw_id => pin_obw_id
           )
  ;
END;
--
--
PROCEDURE wijzigingen_cte_niet_akkoord ( pin_obw_id sms_obw.id%TYPE
                                       )
IS
  /**************************************************************************
  * DESCRIPTION wijzigingen controle NIET akkoord
  *
  * PARAMETERS
  * ==========
  * NAME              TYPE     DESCRIPTION
  * ----------------- -------- ---------------------------------------------
  * pin_obw_id           IN PK OBW
  *
  * HISTORY
  * =======
  * VERSION DATE       AUTHOR(S)       DESCRIPTION
  * ------- ---------- --------------- --------------------------
  *   1.0   05-08-2011 FBO             Initiele versie
  *************************************************************************/
BEGIN
  del_ctew ( pin_obw_id => pin_obw_id
           )
  ;
  UPDATE sms_controles
  SET    verwijder_ind = NULL
  WHERE  obw_id = pin_obw_id
  AND    verwijder_ind = 'J'
  ;
END;
--
--
PROCEDURE upgrade_documenten ( pin_nieuwe_dct_id sms_documenten.id%TYPE
                             , p_vervang_dct_ids_vervangt sms_documenten.dct_ids_vervangt%TYPE
                             )
IS
  /**************************************************************************
  * DESCRIPTION gekoppelde documenten aan een OBW dienen soms geupgrade te worden
  * dit betekent dat doc A vervangen wordt door doc B
  *
  * PARAMETERS
  * ==========
  * NAME              TYPE     DESCRIPTION
  * ----------------- -------- ---------------------------------------------
  * pin_obw_id           IN PK OBW
  *
  * HISTORY
  * =======
  * VERSION DATE       AUTHOR(S)       DESCRIPTION
  * ------- ---------- --------------- --------------------------
  *   1.0   05-08-2011 FBO             Initiele versie
  *************************************************************************/
 l_dct_id_tab dbms_sql.varchar2s;
BEGIN
  l_dct_id_tab := splits_string_met_delimeter ( p_string    => p_vervang_dct_ids_vervangt
                                              , p_delimiter => ':'
                                              )
  ;
  FOR i IN 1..l_dct_id_tab.COUNT
  LOOP
    IF i=1
    THEN
      UPDATE sms_documenten_obw
      SET    dct_id = pin_nieuwe_dct_id
      WHERE  dct_id = l_dct_id_tab(1)
      ;
    ELSE
      DELETE
      FROM   sms_documenten_obw
      WHERE  dct_id = l_dct_id_tab(i)
      ;
    END IF;
  END LOOP;
END;
--
--
PROCEDURE wijzigingen_obw_akkoord ( pin_obw_id sms_obw.id%TYPE
                                  )
IS
  /**************************************************************************
  * DESCRIPTION wijzigingen gehele OBW akkoord
  *
  * PARAMETERS
  * ==========
  * NAME              TYPE     DESCRIPTION
  * ----------------- -------- ---------------------------------------------
  * pin_obw_id           IN PK OBW
  *
  * HISTORY
  * =======
  * VERSION DATE       AUTHOR(S)       DESCRIPTION
  * ------- ---------- --------------- --------------------------
  *   1.0   05-08-2011 FBO             Initiele versie
  *************************************************************************/
  lt_sms_obw_wijzig sms_obw_wijzig%ROWTYPE;
  lt_sms_obw_record sms_obw%ROWTYPE;
  lb_is_obw_gewijzigd BOOLEAN;
BEGIN
  lt_sms_obw_wijzig := sms_obw_wijzig_record ( pin_obw_id => pin_obw_id
                                             )
  ;
  lt_sms_obw_record := sms_obw_record ( pin_obw_id => pin_obw_id
                                      )
  ;
  lb_is_obw_gewijzigd := (lt_sms_obw_wijzig.creation_date != lt_sms_obw_wijzig.update_date OR lt_sms_obw_record.id IS NULL);
  IF lb_is_obw_gewijzigd
  THEN
    IF lt_sms_obw_record.id IS NOT NULL
    THEN
      update_obw ( pit_sms_obw_wijzig_record => lt_sms_obw_wijzig
                 )
      ;
    ELSE
      INSERT INTO sms_obw  VALUES lt_sms_obw_wijzig;
    END IF;
  END IF;
  del_obww  ( pin_obw_id => pin_obw_id
            )
  ;
  wijzigingen_cte_akkoord ( pin_obw_id => pin_obw_id
                          )
  ;
  wijzigingen_dow_akkoord ( pin_obw_id => pin_obw_id
                          )
  ;
END;
--
--
PROCEDURE wijzigingen_obw_niet_akkoord ( pin_obw_id sms_obw.id%TYPE
                                       )
IS
  /**************************************************************************
  * DESCRIPTION wijzigingen gehele OBW niet akkoord
  *
  * PARAMETERS
  * ==========
  * NAME              TYPE     DESCRIPTION
  * ----------------- -------- ---------------------------------------------
  * pin_obw_id           IN PK OBW
  *
  * HISTORY
  * =======
  * VERSION DATE       AUTHOR(S)       DESCRIPTION
  * ------- ---------- --------------- --------------------------
  *   1.0   05-08-2011 FBO             Initiele versie
  *************************************************************************/
BEGIN
  del_obww  ( pin_obw_id => pin_obw_id
            )
  ;
  wijzigingen_cte_niet_akkoord ( pin_obw_id => pin_obw_id
                               )
  ;
  wijzigingen_dow_niet_akkoord ( pin_obw_id => pin_obw_id
                               )
  ;
END;
--
--
PROCEDURE ins_sms_gebruiker_raci ( p_gebruikers_naam  sms_gebruikers.windows_user%TYPE
                                 , piv_string_raci   VARCHAR2
                                 )
IS
  /**************************************************************************
  * DESCRIPTION shuttle output verwerken. Bestaande weggooien en nieuwe toevoegen.
  *
  * PARAMETERS
  * ==========
  * NAME              TYPE     DESCRIPTION
  * ----------------- -------- ---------------------------------------------
  * p_gebruikers_naam               IN
  * piv_string_raci         IN string met raci afkomstig uit shuttle PK's raci met delimiter colon
  *
  * HISTORY
  * =======
  * VERSION DATE       AUTHOR(S)       DESCRIPTION
  * ------- ---------- --------------- --------------------------
  *   1.0   05-08-2011 FBO             Initiele versie
  *************************************************************************/
  lt_raci_id_tab dbms_sql.varchar2s;
  l_sms_gebruiker_raci_record sms_gebruiker_raci%ROWTYPE;
BEGIN
  DELETE
  FROM   sms_gebruiker_raci
  WHERE  gbr_id = sms_gebruikers_id ( p_windows_user => p_gebruikers_naam )
  ;
  lt_raci_id_tab := splits_string_met_delimeter ( p_string    => piv_string_raci
                                                , p_delimiter => ':'
                                                )
  ;
  FOR i IN 1..lt_raci_id_tab.COUNT
  LOOP
    l_sms_gebruiker_raci_record.gbr_id := sms_gebruikers_id ( p_windows_user => p_gebruikers_naam );
    l_sms_gebruiker_raci_record.rai_id := lt_raci_id_tab(i);
    INSERT INTO sms_gebruiker_raci VALUES l_sms_gebruiker_raci_record;
  END LOOP;
END;
--
--
FUNCTION raci_gebruiker_string  (  p_gebruikers_naam  sms_gebruikers.windows_user%TYPE
                                )
RETURN VARCHAR2
IS
  /**************************************************************************
  * DESCRIPTION
  *
  * PARAMETERS
  * ==========
  * NAME              TYPE     DESCRIPTION
  * ----------------- -------- ---------------------------------------------
  * p_gebruikers_naam               IN
  * RETURN                     string met RACI pk's met delimeter colon
  *
  * HISTORY
  * =======
  * VERSION DATE       AUTHOR(S)       DESCRIPTION
  * ------- ---------- --------------- --------------------------
  *   1.0   05-08-2011 FBO             Initiele versie
  *************************************************************************/
  l_retval VARCHAR2(32767);
BEGIN
  SELECT RTRIM (XMLAGG (XMLELEMENT (e, rai_id  || ':')).EXTRACT ('//text()'), ':')
  INTO   l_retval
  FROM   sms_gebruiker_raci
  WHERE  gbr_id = sms_gebruikers_id ( p_windows_user => p_gebruikers_naam )
  ;
  RETURN l_retval;
END;
--
--
FUNCTION raci_gebruiker_functie_string  (  p_gebruikers_naam  sms_gebruikers.windows_user%TYPE
                                        )
RETURN VARCHAR2
IS
  /**************************************************************************
  * DESCRIPTION
  *
  * PARAMETERS
  * ==========
  * NAME              TYPE     DESCRIPTION
  * ----------------- -------- ---------------------------------------------
  * p_gebruikers_naam               IN
  * RETURN                     string met RACI functienamen met delimeter colon
  *
  * HISTORY
  * =======
  * VERSION DATE       AUTHOR(S)       DESCRIPTION
  * ------- ---------- --------------- --------------------------
  *   1.0   05-08-2011 FBO             Initiele versie
  *************************************************************************/
  l_retval VARCHAR2(32767);
BEGIN
  SELECT RTRIM (XMLAGG (XMLELEMENT (e, sms_pck.functie_naam(rai_id)  || ',')).EXTRACT ('//text()'), ',')
  INTO   l_retval
  FROM   sms_gebruiker_raci
  WHERE  gbr_id = sms_gebruikers_id ( p_windows_user => p_gebruikers_naam )
  ;
  RETURN l_retval;
END;


FUNCTION obw_aanpassen
RETURN BOOLEAN
IS
  /**************************************************************************
  * DESCRIPTION
  *
  * PARAMETERS
  * ==========
  * NAME              TYPE     DESCRIPTION
  * ----------------- -------- ---------------------------------------------
  * RETURN                     TRUE=gebruiker mag een of meer maatregelen aanpassen
  *
  * HISTORY
  * =======
  * VERSION DATE       AUTHOR(S)       DESCRIPTION
  * ------- ---------- --------------- --------------------------
  *   1.0   05-08-2011 FBO             Initiele versie
  *************************************************************************/
  l_aantal PLS_INTEGER;
BEGIN
  SELECT COUNT(*)
  INTO   l_aantal
  FROM   sms_v_obw_maatregel_gebruiker
  WHERE  ROWNUM < 2
  ;
  RETURN (l_aantal=1);
END;
--
--
FUNCTION doc_aanpassen
RETURN BOOLEAN
IS
  /**************************************************************************
  * DESCRIPTION
  *
  * PARAMETERS
  * ==========
  * NAME              TYPE     DESCRIPTION
  * ----------------- -------- ---------------------------------------------
  * RETURN                     TRUE=gebruiker mag een of meer documenten aanpassen
  *
  * HISTORY
  * =======
  * VERSION DATE       AUTHOR(S)       DESCRIPTION
  * ------- ---------- --------------- --------------------------
  *   1.0   05-08-2011 FBO             Initiele versie
  *************************************************************************/
  l_aantal PLS_INTEGER;
BEGIN
  SELECT COUNT(*)
  INTO   l_aantal
  FROM   sms_v_documenten_gebruiker
  WHERE  ROWNUM < 2
  ;
  RETURN (l_aantal=1);
END;
--
--
FUNCTION is_beheerder ( p_gebruiker VARCHAR2 DEFAULT NULL 
                      )
RETURN BOOLEAN
IS
  /**************************************************************************
  * DESCRIPTION
  *
  * PARAMETERS
  * ==========
  * NAME              TYPE     DESCRIPTION
  * ----------------- -------- ---------------------------------------------
  * RETURN                     TRUE=apex gebruiker is een beheerder
  *
  * HISTORY
  * =======
  * VERSION DATE       AUTHOR(S)       DESCRIPTION
  * ------- ---------- --------------- --------------------------
  *   1.0   05-08-2011 FBO             Initiele versie
  *************************************************************************/
  l_aantal PLS_INTEGER;
  l_retval BOOLEAN := FALSE;
BEGIN
    IF NVL(UPPER(p_gebruiker),V('APP_USER')) = 'SMS_ADMIN'
    THEN
       l_retval := TRUE;
    ELSE
    SELECT COUNT(*)
    INTO   l_aantal
    FROM   sms_gebruiker_raci gri
    WHERE  sms_gebruikers_id ( p_windows_user => NVL(UPPER(p_gebruiker),V('APP_USER'))) = gri.gbr_id
    AND    gri.rai_id IN ( SELECT id
                           FROM   sms_raci
                           WHERE  functie = 'BEHEERDER'
                         )
    ;
    l_retval := (l_aantal > 0);
  END IF;
  RETURN l_retval;
END;
--
--
FUNCTION is_beheerder_ja_nee
RETURN VARCHAR2
IS
  /**************************************************************************
  * DESCRIPTION
  *
  * PARAMETERS
  * ==========
  * NAME              TYPE     DESCRIPTION
  * ----------------- -------- ---------------------------------------------
  * RETURN                     J=gebruiker is beheerder N=gebruiker is geen beheerder
  *
  * HISTORY
  * =======
  * VERSION DATE       AUTHOR(S)       DESCRIPTION
  * ------- ---------- --------------- --------------------------
  *   1.0   05-08-2011 FBO             Initiele versie
  *************************************************************************/
  l_retval VARCHAR2(1) := g_nee;
BEGIN
  IF is_beheerder
  THEN
    l_retval := g_ja;
  END IF;
  RETURN l_retval;
END;
--
--
FUNCTION is_docbeheerder ( p_gebruiker VARCHAR2 DEFAULT NULL 
                      )
RETURN BOOLEAN
IS
  /**************************************************************************
  * DESCRIPTION
  *
  * PARAMETERS
  * ==========
  * NAME              TYPE     DESCRIPTION
  * ----------------- -------- ---------------------------------------------
  * RETURN                     TRUE=apex gebruiker is een beheerder
  *
  * HISTORY
  * =======
  * VERSION DATE       AUTHOR(S)       DESCRIPTION
  * ------- ---------- --------------- --------------------------
  *   1.0   05-08-2011 FBO             Initiele versie
  *************************************************************************/
  l_aantal PLS_INTEGER;
  l_retval BOOLEAN := FALSE;
BEGIN
    IF NVL(UPPER(p_gebruiker),V('APP_USER')) = 'SMS_ADMIN'
    THEN
       l_retval := TRUE;
    ELSE
    SELECT COUNT(*)
    INTO   l_aantal
    FROM   sms_gebruiker_raci gri
    WHERE  sms_gebruikers_id ( p_windows_user => NVL(UPPER(p_gebruiker),V('APP_USER'))) = gri.gbr_id
    AND    gri.rai_id IN ( SELECT id
                           FROM   sms_raci
                           WHERE  functie = 'DOCBEHEERDER'
                         )
    ;
    l_retval := (l_aantal > 0);
  END IF;
  RETURN l_retval;
END;
--
--
FUNCTION is_docbeheerder_ja_nee
RETURN VARCHAR2
IS
  /**************************************************************************
  * DESCRIPTION
  *
  * PARAMETERS
  * ==========
  * NAME              TYPE     DESCRIPTION
  * ----------------- -------- ---------------------------------------------
  * RETURN                     J=gebruiker is beheerder N=gebruiker is geen beheerder
  *
  * HISTORY
  * =======
  * VERSION DATE       AUTHOR(S)       DESCRIPTION
  * ------- ---------- --------------- --------------------------
  *   1.0   05-08-2011 FBO             Initiele versie
  *************************************************************************/
  l_retval VARCHAR2(1) := g_nee;
BEGIN
  IF is_beheerder
  THEN
    l_retval := g_ja;
  END IF;
  RETURN l_retval;
END;
--
--
FUNCTION is_auditor_risicomanager
RETURN BOOLEAN
IS
  /**************************************************************************
  * DESCRIPTION
  *
  * PARAMETERS
  * ==========
  * NAME              TYPE     DESCRIPTION
  * ----------------- -------- ---------------------------------------------
  * RETURN                     TRUE=apex gebruiker is een auditor/risicomanager
  *
  * HISTORY
  * =======
  * VERSION DATE       AUTHOR(S)       DESCRIPTION
  * ------- ---------- --------------- --------------------------
  *   1.0   12-05-2012 FBO             Initiele versie
  *************************************************************************/
BEGIN
  RETURN (is_auditor OR is_risicomanager);
END;
--
--
FUNCTION is_auditor
RETURN BOOLEAN
IS
  /**************************************************************************
  * DESCRIPTION
  *
  * PARAMETERS
  * ==========
  * NAME              TYPE     DESCRIPTION
  * ----------------- -------- ---------------------------------------------
  * RETURN                     TRUE=apex gebruiker is auditor
  *
  * HISTORY
  * =======
  * VERSION DATE       AUTHOR(S)       DESCRIPTION
  * ------- ---------- --------------- --------------------------
  *   1.0   12-05-2012 FBO             Initiele versie
  *************************************************************************/
  l_aantal PLS_INTEGER;
  l_retval BOOLEAN := FALSE;
BEGIN
  IF is_beheerder
  THEN
    l_retval := TRUE;
  ELSE 
    SELECT COUNT(*)
    INTO   l_aantal
    FROM   sms_gebruiker_raci gri
    WHERE  sms_gebruikers_id ( p_windows_user => V('APP_USER')) = gri.gbr_id
    AND    gri.rai_id IN ( SELECT id
                           FROM   sms_raci
                           WHERE  functie IN ('AUDITOR')
                         )
    AND    ROWNUM < 2
    ;
    l_retval := (l_aantal=1);
  END IF;
  RETURN l_retval;
END;
--
--
FUNCTION is_risicomanager
RETURN BOOLEAN
IS
  /**************************************************************************
  * DESCRIPTION
  *
  * PARAMETERS
  * ==========
  * NAME              TYPE     DESCRIPTION
  * ----------------- -------- ---------------------------------------------
  * RETURN                     TRUE=apex gebruiker is risico manager
  *
  * HISTORY
  * =======
  * VERSION DATE       AUTHOR(S)       DESCRIPTION
  * ------- ---------- --------------- --------------------------
  *   1.0   12-05-2012 FBO             Initiele versie
  *************************************************************************/
  l_aantal PLS_INTEGER;
  l_retval BOOLEAN := FALSE;
BEGIN
    IF is_beheerder
    THEN
      l_retval := TRUE;
    ELSE 
    SELECT COUNT(*)
    INTO   l_aantal
    FROM   sms_gebruiker_raci gri
    WHERE  sms_gebruikers_id ( p_windows_user => V('APP_USER')) = gri.gbr_id
    AND    gri.rai_id IN ( SELECT id
                           FROM   sms_raci
                           WHERE  functie IN ('RISICOMANAGER')
                         )
    AND    ROWNUM < 2
    ;
    l_retval := (l_aantal=1);
  END IF;
  RETURN l_retval;
END;
--
--

FUNCTION is_security_officer
RETURN BOOLEAN
IS
  /**************************************************************************
  * DESCRIPTION
  *
  * PARAMETERS
  * ==========
  * NAME              TYPE     DESCRIPTION
  * ----------------- -------- ---------------------------------------------
  * RETURN                     TRUE=gebruiker is security officer
  *
  * HISTORY
  * =======
  * VERSION DATE       AUTHOR(S)       DESCRIPTION
  * ------- ---------- --------------- --------------------------
  *   1.0   05-08-2011 FBO             Initiele versie
  *************************************************************************/
  l_aantal PLS_INTEGER;
  l_retval BOOLEAN := FALSE;
BEGIN
    IF is_beheerder
    THEN
      l_retval := TRUE;
    ELSE 
    SELECT COUNT(*)
    INTO   l_aantal
    FROM   sms_gebruiker_raci gri
    WHERE  sms_gebruikers_id ( p_windows_user => V('APP_USER')) = gri.gbr_id
    AND    gri.rai_id IN ( SELECT id
                           FROM   sms_raci
                           WHERE  functie IN ('SECURITY OFFICER','BEHEERDER','ACCEPTANT')
                         )
    AND    ROWNUM < 2
    ;
    l_retval := (l_aantal=1);
  END IF;
  RETURN l_retval;
END;
--
--
FUNCTION is_security_officer_ja_nee ( pin_obw_id sms_obw.id%TYPE
                                    )
RETURN VARCHAR2
IS
  l_retval VARCHAR2(1) := 'N';
BEGIN
    IF is_security_officer ( pin_obw_id => pin_obw_id
                           )
    THEN
      l_retval := 'J';
    END IF;
    RETURN l_retval;
END;
--
--
FUNCTION is_security_officer ( pin_obw_id sms_obw.id%TYPE
                             )
RETURN BOOLEAN
IS
  /**************************************************************************
  * DESCRIPTION wordt gebruikt voor het bepalen wie bevindingen mag aanmaken
  *
  * PARAMETERS
  * ==========
  * NAME              TYPE     DESCRIPTION
  * ----------------- -------- ---------------------------------------------
  * RETURN                     TRUE=gebruiker is security officer
  *                            COORDINATOR IB behoort ook tot de club
  *
  * HISTORY
  * =======
  * VERSION DATE       AUTHOR(S)       DESCRIPTION
  * ------- ---------- --------------- --------------------------
  *   1.0   10-05-2012 FBO             Initiele versie
  *************************************************************************/
  l_aantal PLS_INTEGER;
BEGIN
  IF is_security_officer
  THEN
    l_aantal := 1;
  ELSIF is_risicomanager
  THEN
    l_aantal := 1;
  ELSE
    SELECT COUNT(*)
    INTO   l_aantal
    FROM   sms_gebruiker_raci gri
    WHERE  sms_gebruikers_id ( p_windows_user => V('APP_USER')) = gri.gbr_id
    AND    gri.rai_id IN ( SELECT rai.rai_id_cib
                           FROM   sms_obw obw
                           ,      sms_raci rai
                           WHERE  (obw.rai_id_eigenaar = rai.id OR obw.rai_id_beheerder = rai.id)
                           AND    obw.id = pin_obw_id
                         )
    AND    ROWNUM < 2
    ;
  END IF;
  RETURN (l_aantal=1);
END;
--
--
FUNCTION bevinding_aanpassen ( pin_obw_id sms_obw.id%TYPE
                             )
RETURN PLS_INTEGER
IS
  /**************************************************************************
  * DESCRIPTION wordt gebruikt voor het bepalen wie bevindingen mag aanpassen
  * 1=beheerder 2=eigenaar maatregel (mag alleen gereed_ind aanpassen)
  *
  * PARAMETERS
  * ==========
  * NAME              TYPE     DESCRIPTION
  * ----------------- -------- ---------------------------------------------
  * RETURN                     TRUE=gebruiker is security officer
  *
  * HISTORY
  * =======
  * VERSION DATE       AUTHOR(S)       DESCRIPTION
  * ------- ---------- --------------- --------------------------
  *   1.0   10-05-2012 FBO             Initiele versie
  *************************************************************************/
  l_retval PLS_INTEGER := 0;
  l_aantal PLS_INTEGER := 0;
BEGIN
  IF is_security_officer ( pin_obw_id => pin_obw_id)
  THEN
    l_retval := 1;
  ELSE
    SELECT COUNT(*)
    INTO   l_aantal
    FROM   sms_v_obw_maatregel_gebruiker omg
    WHERE  omg.id = pin_obw_id
    AND    ROWNUM < 2
    ;
    IF l_aantal = 1
    THEN
      l_retval := 2;
    END IF;
  END IF;
  RETURN (l_retval);
END;
--
--
FUNCTION is_security_officer ( pin_dct_id sms_documenten.id%TYPE
                             )
RETURN BOOLEAN
IS
  /**************************************************************************
  * DESCRIPTION
  *
  * PARAMETERS
  * ==========
  * NAME              TYPE     DESCRIPTION
  * ----------------- -------- ---------------------------------------------
  * RETURN                     TRUE=gebruiker is security officer
  *
  * HISTORY
  * =======
  * VERSION DATE       AUTHOR(S)       DESCRIPTION
  * ------- ---------- --------------- --------------------------
  *   1.0   05-08-2011 FBO             Initiele versie
  *************************************************************************/
  l_aantal PLS_INTEGER;
BEGIN
  IF is_security_officer
  THEN
    l_aantal := 1;
  ELSE
    SELECT COUNT(*)
    INTO   l_aantal
    FROM   sms_gebruiker_raci gri
    WHERE  sms_gebruikers_id ( p_windows_user => V('APP_USER')) = gri.gbr_id
    AND    gri.rai_id IN ( SELECT rai.rai_id_cib
                           FROM   sms_documenten dct
                           ,      sms_raci rai
                           WHERE  ( rai.id = dct.rai_id_eigenaar OR rai.id = dct.rai_id )
                           AND    dct.id = pin_dct_id
                         )
    AND    ROWNUM < 2
    ;
  END IF;
  RETURN (l_aantal=1);
END;
--
--
FUNCTION is_obw_eigenaar ( pin_obw_id sms_obw.id%TYPE
                         )
RETURN BOOLEAN
IS
  /**************************************************************************
  * DESCRIPTION
  *
  * PARAMETERS
  * ==========
  * NAME              TYPE     DESCRIPTION
  * ----------------- -------- ---------------------------------------------
  * pin_obw_id           IN PK OBW
  * RETURN                     TRUE=gebruiker is obw eigenaar
  *
  * HISTORY
  * =======
  * VERSION DATE       AUTHOR(S)       DESCRIPTION
  * ------- ---------- --------------- --------------------------
  *   1.0   05-08-2011 FBO             Initiele versie
  *************************************************************************/
  l_aantal PLS_INTEGER;
BEGIN
  SELECT COUNT(*)
  INTO   l_aantal
  FROM   sms_v_obw_maatregel_gebruiker
  WHERE  ROWNUM < 2
  AND    id = pin_obw_id
  ;
  RETURN (l_aantal=1);
END;
--
--
FUNCTION is_obw_eigenaar_ja_nee ( pin_obw_id sms_obw.id%TYPE
                                )
RETURN VARCHAR2
IS
  l_retval VARCHAR2(1) := 'N';
BEGIN
  IF is_obw_eigenaar ( pin_obw_id => pin_obw_id)
  THEN
    l_retval := 'J';
  END IF;
  RETURN l_retval;
END;
--
--
FUNCTION is_doc_eigenaar ( p_dct_id sms_documenten.id%TYPE
                         )
RETURN BOOLEAN
IS
  /**************************************************************************
  * DESCRIPTION
  *
  * PARAMETERS
  * ==========
  * NAME              TYPE     DESCRIPTION
  * ----------------- -------- ---------------------------------------------
  * pin_obw_id           IN PK OBW
  * RETURN                     TRUE=gebruiker is document eigenaar
  *
  * HISTORY
  * =======
  * VERSION DATE       AUTHOR(S)       DESCRIPTION
  * ------- ---------- --------------- --------------------------
  *   1.0   05-08-2011 FBO             Initiele versie
  *************************************************************************/
  l_aantal PLS_INTEGER;
BEGIN
  SELECT COUNT(*)
  INTO   l_aantal
  FROM   sms_v_documenten_gebruiker
  WHERE  ROWNUM < 2
  AND    dct_id = p_dct_id
  ;
  RETURN (l_aantal=1);
END;
--
--
FUNCTION is_actie_eigenaar ( p_bvg_id sms_bevindingen.id%TYPE DEFAULT NULL
                           , p_dct_id sms_documenten.id%TYPE  DEFAULT NULL
                           , p_cte_id sms_controles.id%TYPE   DEFAULT NULL
                           )
RETURN BOOLEAN
IS
  /**************************************************************************
  * DESCRIPTION
  *
  * PARAMETERS
  * ==========
  * NAME              TYPE     DESCRIPTION
  * ----------------- -------- ---------------------------------------------
  * pin_obw_id           IN PK OBW
  * RETURN                     TRUE=gebruiker is actie eigenaar
  *
  * HISTORY
  * =======
  * VERSION DATE       AUTHOR(S)       DESCRIPTION
  * ------- ---------- --------------- --------------------------
  *   1.0   05-08-2011 FBO             Initiele versie
  *************************************************************************/
  l_retval BOOLEAN;
BEGIN
  l_retval := CASE
                WHEN p_dct_id > 0 THEN is_doc_eigenaar ( p_dct_id => p_dct_id)
                WHEN p_bvg_id > 0 THEN is_obw_eigenaar ( pin_obw_id => sms_bevindingen_record ( pin_bvg_id => p_bvg_id).obw_id)
                WHEN p_cte_id > 0 THEN is_obw_eigenaar ( pin_obw_id => sms_controles_record ( pin_cte_id => p_cte_id).obw_id)
                ELSE FALSE
              END;
  RETURN l_retval;
END;
--
--
FUNCTION is_actie_uitvoerder ( p_rai_id sms_raci.id%TYPE
                             )
RETURN BOOLEAN
IS
  /**************************************************************************
  * DESCRIPTION
  *
  * PARAMETERS
  * ==========
  * NAME              TYPE     DESCRIPTION
  * ----------------- -------- ---------------------------------------------
  * pin_obw_id           IN PK OBW
  * RETURN                     TRUE=gebruiker is actie uitvoerder
  *
  * HISTORY
  * =======
  * VERSION DATE       AUTHOR(S)       DESCRIPTION
  * ------- ---------- --------------- --------------------------
  *   1.0   05-08-2011 FBO             Initiele versie
  *   1.1   10-11-2011 FBO             rai_id_ibs toegevoegd
  *************************************************************************/
  l_aantal PLS_INTEGER;
BEGIN
  SELECT COUNT(*)
  INTO   l_aantal
  FROM   ( SELECT 'x'
           FROM   sms_gebruiker_raci gri
           WHERE  sms_gebruikers_id ( p_windows_user => V('APP_USER')) = gri.gbr_id
           AND    gri.rai_id = p_rai_id
           AND    ROWNUM < 2
           UNION ALL
           SELECT 'x'
           FROM   sms_gebruiker_raci gri
           ,      sms_raci rai
           WHERE  sms_gebruikers_id ( p_windows_user => V('APP_USER')) = gri.gbr_id
           AND    rai.rai_id_ibs                       = gri.rai_id
           AND    rai.id = p_rai_id
           AND    ROWNUM < 2
         )
  ;
  RETURN (l_aantal>=1);
END;
--
--
FUNCTION autorisatie_nummer_beperkt
RETURN PLS_INTEGER
IS
  /**************************************************************************
  * DESCRIPTION bepalen welke autorisatie iemand heeft bij een bepaalde actie
  * je weet in dit geval al welke actie het betreft. Aan de hand van het nummer
  * wordt de autorisatie in een scherm ingesteld.
  *
  * PARAMETERS
  * ==========
  * NAME              TYPE     DESCRIPTION
  * ----------------- -------- ---------------------------------------------
  * ..
  * RETURN                     1=beheerder 2=eigenaar 3=uitvoerder 4=gebruiker
  *
  * HISTORY
  * =======
  * VERSION DATE       AUTHOR(S)       DESCRIPTION
  * ------- ---------- --------------- --------------------------
  *   1.0   05-08-2011 FBO             Initiele versie
  *************************************************************************/
  l_retval PLS_INTEGER;
BEGIN
  IF is_beheerder
  THEN
    l_retval := 1;
  ELSE
    l_retval := 2;
  END IF;
  RETURN l_retval;
END;
--
--
FUNCTION autorisatie_nummer ( p_bvg_id sms_bevindingen.id%TYPE DEFAULT NULL
                            , p_dct_id sms_documenten.id%TYPE  DEFAULT NULL
                            , p_cte_id sms_controles.id%TYPE   DEFAULT NULL
                            , p_rai_id sms_raci.id%TYPE        DEFAULT NULL
                            )
RETURN PLS_INTEGER
IS
  /**************************************************************************
  * DESCRIPTION bepalen welke autorisatie iemand heeft bij een bepaalde actie
  * je weet in dit geval al welke actie het betreft. Aan de hand van het nummer
  * wordt de autorisatie in een scherm ingesteld.
  *
  * PARAMETERS
  * ==========
  * NAME              TYPE     DESCRIPTION
  * ----------------- -------- ---------------------------------------------
  * ..
  * RETURN                     1=beheerder 2=eigenaar 3=uitvoerder 4=gebruiker
  *
  * HISTORY
  * =======
  * VERSION DATE       AUTHOR(S)       DESCRIPTION
  * ------- ---------- --------------- --------------------------
  *   1.0   05-08-2011 FBO             Initiele versie
  *************************************************************************/
  l_retval              PLS_INTEGER;
  l_is_actie_uitvoerder BOOLEAN;
  l_is_actie_eigenaar   BOOLEAN;
BEGIN
  IF is_beheerder
  THEN
    l_retval := 1;
  ELSE
    l_is_actie_uitvoerder := is_actie_uitvoerder ( p_rai_id => p_rai_id
                                                 )
    ;
    l_is_actie_eigenaar := is_actie_eigenaar ( p_bvg_id => p_bvg_id
                                             , p_dct_id => p_dct_id
                                             , p_cte_id => p_cte_id
                                             )
    ;
    IF l_is_actie_uitvoerder AND l_is_actie_eigenaar
    THEN
      l_retval := 1;
    ELSIF l_is_actie_uitvoerder
    THEN
      l_retval := 3;
    ELSIF l_is_actie_eigenaar
    THEN
      l_retval := 2;
    ELSE
      l_retval := 4;
    END IF;
  END IF;
  RETURN l_retval;
END;
--
--
PROCEDURE log_insert ( p_tabel sms_log_transacties.tabel%TYPE
                     , p_nieuwe_waarde sms_log_transacties.nieuwe_waarde%TYPE
                     , p_pk  sms_log_transacties.pk %TYPE
                     )
IS
  /**************************************************************************
  * DESCRIPTION insert in sms_log_transacties dit is een generieke log tabel
  *
  * PARAMETERS
  * ==========
  * NAME              TYPE     DESCRIPTION
  * ----------------- -------- ---------------------------------------------
  * ..
  *
  * HISTORY
  * =======
  * VERSION DATE       AUTHOR(S)       DESCRIPTION
  * ------- ---------- --------------- --------------------------
  *   1.0   05-08-2011 FBO             Initiele versie
  *************************************************************************/
  l_sms_log_transacties_record sms_log_transacties%ROWTYPE;
BEGIN
  l_sms_log_transacties_record.tabel := UPPER(p_tabel);
  l_sms_log_transacties_record.nieuwe_waarde := p_nieuwe_waarde;
  l_sms_log_transacties_record.pk := p_pk;
  l_sms_log_transacties_record.crud := 'I';
  INSERT INTO sms_log_transacties VALUES l_sms_log_transacties_record;
END;
--
--
PROCEDURE log_delete ( p_tabel sms_log_transacties.tabel%TYPE
                     , p_oude_waarde sms_log_transacties.nieuwe_waarde%TYPE
                     , p_pk  sms_log_transacties.pk %TYPE
                     )
IS
  /**************************************************************************
  * DESCRIPTION insert in sms_log_transacties dit is een generieke log tabel
  *
  * PARAMETERS
  * ==========
  * NAME              TYPE     DESCRIPTION
  * ----------------- -------- ---------------------------------------------
  * ..
  *
  * HISTORY
  * =======
  * VERSION DATE       AUTHOR(S)       DESCRIPTION
  * ------- ---------- --------------- --------------------------
  *   1.0   05-08-2011 FBO             Initiele versie
  *************************************************************************/
  l_sms_log_transacties_record sms_log_transacties%ROWTYPE;
BEGIN
  l_sms_log_transacties_record.tabel := UPPER(p_tabel);
  l_sms_log_transacties_record.nieuwe_waarde := p_oude_waarde;
  l_sms_log_transacties_record.pk := p_pk;
  l_sms_log_transacties_record.crud := 'D';
  INSERT INTO sms_log_transacties VALUES l_sms_log_transacties_record;
END;
--
--
PROCEDURE log_update ( p_tabel sms_log_transacties.tabel%TYPE
                     , p_nieuwe_waarde sms_log_transacties.nieuwe_waarde%TYPE
                     , p_pk  sms_log_transacties.pk %TYPE
                     )
IS
  /**************************************************************************
  * DESCRIPTION insert in sms_log_transacties dit is een generieke log tabel
  *
  * PARAMETERS
  * ==========
  * NAME              TYPE     DESCRIPTION
  * ----------------- -------- ---------------------------------------------
  * ..
  *
  * HISTORY
  * =======
  * VERSION DATE       AUTHOR(S)       DESCRIPTION
  * ------- ---------- --------------- --------------------------
  *   1.0   05-08-2011 FBO             Initiele versie
  *************************************************************************/
  l_sms_log_transacties_record sms_log_transacties%ROWTYPE;
BEGIN
  l_sms_log_transacties_record.tabel := UPPER(p_tabel);
  l_sms_log_transacties_record.nieuwe_waarde := p_nieuwe_waarde;
  l_sms_log_transacties_record.pk := p_pk;
  l_sms_log_transacties_record.crud := 'U';
  INSERT INTO sms_log_transacties VALUES l_sms_log_transacties_record;
END;
--
--
--
--
FUNCTION genereer_kwartaal ( pid_begin_datum DATE
                           )
RETURN dbms_sql.date_table
IS
  /**************************************************************************
  * DESCRIPTION genereren van data
  *
  * PARAMETERS
  * ==========
  * NAME              TYPE     DESCRIPTION
  * ----------------- -------- ---------------------------------------------
  * pid_begin_datum         IN begindatum meestal 1 januari
  * RETURN                     array met datum in dit geval 4
  *
  * HISTORY
  * =======
  * VERSION DATE       AUTHOR(S)       DESCRIPTION
  * ------- ---------- --------------- --------------------------
  *   1.0   05-08-2011 FBO             Initiele versie
  *************************************************************************/
  l_datum_tab dbms_sql.date_table;
  l_datum     DATE := pid_begin_datum;
BEGIN
  FOR i IN 1..4
  LOOP
    l_datum_tab(i) := l_datum;
    l_datum := ADD_MONTHS(l_datum,3);
  END LOOP;
  RETURN l_datum_tab;
END;
--
--
FUNCTION genereer_maand ( pid_begin_datum DATE
                        )
RETURN dbms_sql.date_table
IS
  l_datum_tab dbms_sql.date_table;
  l_datum     DATE := pid_begin_datum;
BEGIN
  FOR i IN 1..12
  LOOP
    l_datum_tab(i) := l_datum;
    l_datum := ADD_MONTHS(l_datum,1);
  END LOOP;
  RETURN l_datum_tab;
END;
--
--
FUNCTION genereer_week ( pid_begin_datum DATE
                       )
RETURN dbms_sql.date_table
IS
  l_datum_tab dbms_sql.date_table;
  l_datum     DATE := pid_begin_datum;
BEGIN
  FOR i IN 1..52
  LOOP
    l_datum_tab(i) := l_datum;
    l_datum := l_datum + 7;
  END LOOP;
  RETURN l_datum_tab;
END;
--
--
FUNCTION genereer_half_jaar ( pid_begin_datum DATE
                            )
RETURN dbms_sql.date_table
IS
  l_datum_tab dbms_sql.date_table;
  l_datum DATE := pid_begin_datum;
BEGIN
  l_datum_tab(1) := l_datum;
  l_datum_tab(2) := ADD_MONTHS(l_datum,6);
  RETURN l_datum_tab;
END;
--
--
FUNCTION genereer_jaar ( pid_begin_datum DATE
                       )
RETURN dbms_sql.date_table
IS
  l_datum_tab dbms_sql.date_table;
  l_datum DATE := pid_begin_datum;
BEGIN
  l_datum_tab(1) := ADD_MONTHS(l_datum,6);
  RETURN l_datum_tab;
END;
--
--
FUNCTION genereer_twee_jaar ( pid_begin_datum DATE
                            )
RETURN dbms_sql.date_table
IS
  l_datum_tab dbms_sql.date_table;
  l_datum DATE := pid_begin_datum;
BEGIN
  IF MOD(TO_CHAR(pid_begin_datum,'YY'),2) = 0
  THEN
    l_datum_tab(1) := ADD_MONTHS(l_datum,12);
  END IF;
  RETURN l_datum_tab;
END;
--
--
FUNCTION doc_actie_kandidaten ( p_begin_datum DATE
                              )
RETURN dbms_sql.number_table
IS
  /**************************************************************************
  * DESCRIPTION bepalen voor welke documenten voor een bepaald jaar acties kunnen
  * worden uitgevoerd
  *
  * PARAMETERS
  * ==========
  * NAME              TYPE     DESCRIPTION
  * ----------------- -------- ---------------------------------------------
  * pid_begin_datum         IN begindatum meestal 1 januari
  * RETURN                     array documenten pk's
  *
  * HISTORY
  * =======
  * VERSION DATE       AUTHOR(S)       DESCRIPTION
  * ------- ---------- --------------- --------------------------
  *   1.0   05-08-2011 FBO             Initiele versie
  *************************************************************************/
  CURSOR a ( pcd_datum DATE
           )
  IS
  SELECT id
  FROM   sms_documenten
  WHERE  NVL(datum_einde,gcd_grote_datum) > pcd_datum
  MINUS
  SELECT dct_id
  FROM   sms_acties
  WHERE  dct_id IS NOT NULL
  AND    EXTRACT(YEAR FROM pcd_datum) = EXTRACT(YEAR FROM datum_uitvoering)
  ;
  l_dct_id_tab dbms_sql.number_table;
BEGIN
  OPEN a (p_begin_datum);
  FETCH a BULK COLLECT INTO l_dct_id_tab;
  CLOSE a;
  RETURN l_dct_id_tab;
END;
--
--
FUNCTION cte_actie_kandidaten ( p_begin_datum DATE
                              )
RETURN dbms_sql.number_table
IS
  /**************************************************************************
  * DESCRIPTION bepalen voor welke controles voor een bepaald jaar acties kunnen
  * worden uitgevoerd
  *
  * PARAMETERS
  * ==========
  * NAME              TYPE     DESCRIPTION
  * ----------------- -------- ---------------------------------------------
  * p_begin_datum           IN begindatum meestal 1 januari
  * RETURN                     array controles pk's
  *
  * HISTORY
  * =======
  * VERSION DATE       AUTHOR(S)       DESCRIPTION
  * ------- ---------- --------------- --------------------------
  *   1.0   05-08-2011 FBO             Initiele versie
  *************************************************************************/
  CURSOR a ( pcd_datum DATE
           )
  IS
  SELECT cte.id
  FROM   sms_controles cte
  ,      sms_obw obw
  WHERE  NVL(obw.datum_einde,gcd_grote_datum) > pcd_datum
  AND    obw.id = cte.obw_id
  MINUS
  SELECT cte_id
  FROM   sms_acties
  WHERE  cte_id IS NOT NULL
  AND    EXTRACT(YEAR FROM pcd_datum) = EXTRACT(YEAR FROM datum_uitvoering)
  ;
  l_dct_id_tab dbms_sql.number_table;
BEGIN
  OPEN a (p_begin_datum);
  FETCH a BULK COLLECT INTO l_dct_id_tab;
  CLOSE a;
  RETURN l_dct_id_tab;
END;
--
--
PROCEDURE ins_cae ( p_cae_record sms_acties%ROWTYPE
                  )
IS
  /**************************************************************************
  * DESCRIPTION insert in table sms_acties
  *
  * PARAMETERS
  * ==========
  * NAME              TYPE     DESCRIPTION
  * ----------------- -------- ---------------------------------------------
  * p_cae_record            IN actie record
  *
  * HISTORY
  * =======
  * VERSION DATE       AUTHOR(S)       DESCRIPTION
  * ------- ---------- --------------- --------------------------
  *   1.0   05-08-2011 FBO             Initiele versie
  *************************************************************************/
BEGIN
  INSERT INTO sms_acties VALUES p_cae_record;
END;
--
--
FUNCTION genereer_datum_tab ( pid_begin_datum DATE
                            , piv_frequentie sms_documenten.controle_frequentie%TYPE
                            )
RETURN dbms_sql.date_table
IS
  /**************************************************************************
  * DESCRIPTION
  *
  * PARAMETERS
  * ==========
  * NAME              TYPE     DESCRIPTION
  * ----------------- -------- ---------------------------------------------
  * p_begin_datum           IN begindatum meestal 1 januari
  * piv_frequentie          IN frequentie waarmee datums worden gegenereerd (jaarlijks,maandelijks,etc)
  * RETURN                     array met datums
  *
  * HISTORY
  * =======
  * VERSION DATE       AUTHOR(S)       DESCRIPTION
  * ------- ---------- --------------- --------------------------
  *   1.0   05-08-2011 FBO             Initiele versie
  *************************************************************************/
  l_datum_tab dbms_sql.date_table;
BEGIN
  l_datum_tab := CASE piv_frequentie
                   WHEN g_jaar THEN genereer_jaar (pid_begin_datum)
                   WHEN g_half_jaar THEN genereer_half_jaar (pid_begin_datum)
                   WHEN g_twee_jaar THEN genereer_twee_jaar (pid_begin_datum)
                   WHEN g_kwartaal THEN genereer_kwartaal (pid_begin_datum)
                   WHEN g_maand THEN genereer_maand (pid_begin_datum)
                   WHEN g_week THEN genereer_week (pid_begin_datum)
                   ELSE NULL
                 END;
  RETURN l_datum_tab;
END;
--
--
PROCEDURE aanmaken_actie_bij_doc ( pin_dct_id sms_documenten.id%TYPE
                                 , pid_begin_datum DATE
                                 , pon_aantal_aangemaakte_acties OUT PLS_INTEGER
                                 )
IS
  /**************************************************************************
  * DESCRIPTION aanmaken acties bij een document
  *
  * PARAMETERS
  * ==========
  * NAME              TYPE     DESCRIPTION
  * ----------------- -------- ---------------------------------------------
  * pid_begin_datum         IN begindatum meestal 1 januari
  * pin_dct_id              IN pk document
  *
  * HISTORY
  * =======
  * VERSION DATE       AUTHOR(S)       DESCRIPTION
  * ------- ---------- --------------- --------------------------
  *   1.0   05-08-2011 FBO             Initiele versie
  *   2.0   06-09-2016 Dick            indien anders dan niets aanmaken.
  *************************************************************************/
  l_sms_documenten_record sms_documenten%ROWTYPE;
  l_cae_record            sms_acties%ROWTYPE;
  l_datum_tab             dbms_sql.date_table;
BEGIN
  pon_aantal_aangemaakte_acties := 0;
  l_sms_documenten_record := sms_pck.sms_documenten_record ( pin_dct_id => pin_dct_id
                                                           )
  ;
  IF l_sms_documenten_record.controle_frequentie != 'ANDERS'
  THEN
    l_datum_tab := genereer_datum_tab ( pid_begin_datum => pid_begin_datum
                                      , piv_frequentie  => l_sms_documenten_record.controle_frequentie
                                      )
    ;
  ELSE
    null; -- indien anders dan niets aanmaken.
    --l_datum_tab := genereer_jaar (pid_begin_datum);
  END IF;
  FOR i IN 1..l_datum_tab.COUNT
  LOOP
    IF l_datum_tab(i) BETWEEN NVL(l_sms_documenten_record.datum_ingang,gcd_kleine_datum) AND NVL(l_sms_documenten_record.datum_einde,gcd_grote_datum)
    THEN
      l_cae_record.datum_uitvoering := l_datum_tab(i);
      l_cae_record.dct_id           := pin_dct_id;
      l_cae_record.rai_id           := l_sms_documenten_record.rai_id;
      l_cae_record.status           := g_gepland;
      ins_cae ( p_cae_record => l_cae_record
              )
      ;
      pon_aantal_aangemaakte_acties := pon_aantal_aangemaakte_acties + 1;
    END IF;
  END LOOP;
END;
--
--
PROCEDURE aanmaken_actie_bij_cte ( pin_cte_id      sms_controles.id%TYPE
                                 , pid_begin_datum DATE
                                 , pon_aantal_aangemaakte_acties OUT PLS_INTEGER
                                 )
IS
  /**************************************************************************
  * DESCRIPTION aanmaken acties bij een document
  *
  * PARAMETERS
  * ==========
  * NAME              TYPE     DESCRIPTION
  * ----------------- -------- ---------------------------------------------
  * pid_begin_datum         IN begindatum meestal 1 januari
  * pin_cte_id              IN pk controle
  *
  * HISTORY
  * =======
  * VERSION DATE       AUTHOR(S)       DESCRIPTION
  * ------- ---------- --------------- --------------------------
  *   1.0   05-08-2011 FBO             Initiele versie
  *   1.1   20-01-2012 FBO             rai_id_resp_werking toegevoegd
  *************************************************************************/
  l_sms_controles_record sms_controles%ROWTYPE;
  l_sms_obw_record        sms_obw%ROWTYPE;
  l_raci_bij_cte_tab dbms_sql.number_table;
  l_cae_record            sms_acties%ROWTYPE;
  l_datum_tab dbms_sql.date_table;
BEGIN
  pon_aantal_aangemaakte_acties := 0;
  l_sms_controles_record := sms_pck.sms_controles_record ( pin_cte_id => pin_cte_id
                                                         )
  ;
  l_sms_obw_record := sms_obw_record ( pin_obw_id => l_sms_controles_record.obw_id);
  IF l_sms_controles_record.rai_id_resp_werking > 0
  THEN
    l_raci_bij_cte_tab(1) := l_sms_controles_record.rai_id_resp_werking;
  END IF;
  l_datum_tab := genereer_datum_tab ( pid_begin_datum => pid_begin_datum
                                    , piv_frequentie  => l_sms_controles_record.frequentie
                                    )
  ;
  IF l_raci_bij_cte_tab.COUNT > 0
  THEN
    FOR i IN 1..l_datum_tab.COUNT
    LOOP
      FOR j IN 1..l_raci_bij_cte_tab.COUNT
      LOOP
        IF l_datum_tab(i) BETWEEN NVL(l_sms_obw_record.datum_ingang,gcd_kleine_datum) AND NVL(l_sms_obw_record.datum_einde,gcd_grote_datum)
        THEN
          l_cae_record.datum_uitvoering := l_datum_tab(i);
          l_cae_record.cte_id           := pin_cte_id;
          l_cae_record.rai_id           := l_raci_bij_cte_tab(j);
          l_cae_record.status           := g_gepland;
          ins_cae ( p_cae_record => l_cae_record
                  )
          ;
          pon_aantal_aangemaakte_acties := pon_aantal_aangemaakte_acties + 1;
        END IF;
      END LOOP;
    END LOOP;
  END IF;
  IF pon_aantal_aangemaakte_acties > 0
  THEN
    sms_pck.log_insert('sms_batch_controles',pon_aantal_aangemaakte_acties,1);
  END IF;
END;
--
--
PROCEDURE aanmaken_acties_bij_doc ( p_jaar PLS_INTEGER
                                  , p_aantal_aangemaakte_acties OUT PLS_INTEGER
                                  )
IS
  /**************************************************************************
  * DESCRIPTION hoofdprocedure voor batch voor het aanmaken van acties bij documenten
  * voor een jaar
  *
  * PARAMETERS
  * ==========
  * NAME              TYPE     DESCRIPTION
  * ----------------- -------- ---------------------------------------------
  * p_jaar                  IN jaar waarvoor actie aangemaakt moeten worden
  * pid_begin_datum         IN begindatum meestal 1 januari
  * pin_dct_id              IN pk document
  *
  * HISTORY
  * =======
  * VERSION DATE       AUTHOR(S)       DESCRIPTION
  * ------- ---------- --------------- --------------------------
  *   1.0   05-08-2011 FBO             Initiele versie
  *************************************************************************/
  l_dct_id_tab  dbms_sql.number_table;
  l_begin_datum DATE := TRUNC(TO_DATE(p_jaar,'yyyy'),'YYYY');
  l_aantal_aangemaakte_acties PLS_INTEGER;
BEGIN
  p_aantal_aangemaakte_acties := 0;
  l_dct_id_tab := doc_actie_kandidaten ( p_begin_datum => l_begin_datum
                                       )
  ;
  FOR i IN 1..l_dct_id_tab.COUNT
  LOOP
    aanmaken_actie_bij_doc ( pin_dct_id      => l_dct_id_tab(i)
                           , pid_begin_datum => l_begin_datum
                           , pon_aantal_aangemaakte_acties => l_aantal_aangemaakte_acties
                           )
    ;
    p_aantal_aangemaakte_acties := p_aantal_aangemaakte_acties + l_aantal_aangemaakte_acties;
  END LOOP;
  IF p_aantal_aangemaakte_acties > 0
  THEN
    sms_pck.log_insert('sms_batch_documenten',p_aantal_aangemaakte_acties,1);
  END IF;
END;
--
--
PROCEDURE aanmaken_acties_bij_cte ( p_jaar PLS_INTEGER
                                  , p_aantal_aangemaakte_acties OUT PLS_INTEGER
                                  )
IS
  /**************************************************************************
  * DESCRIPTION hoofdprocedure voor batch voor het aanmaken van acties bij controles
  * voor een jaar
  *
  * PARAMETERS
  * ==========
  * NAME              TYPE     DESCRIPTION
  * ----------------- -------- ---------------------------------------------
  * p_jaar                  IN jaar waarvoor actie aangemaakt moeten worden
  * pid_begin_datum         IN begindatum meestal 1 januari
  * pin_dct_id              IN pk document
  *
  * HISTORY
  * =======
  * VERSION DATE       AUTHOR(S)       DESCRIPTION
  * ------- ---------- --------------- --------------------------
  *   1.0   05-08-2011 FBO             Initiele versie
  *************************************************************************/
  l_cte_id_tab  dbms_sql.number_table;
  l_begin_datum DATE := TRUNC(TO_DATE(p_jaar,'yyyy'),'YYYY');
  l_aantal_aangemaakte_acties PLS_INTEGER;
BEGIN
  p_aantal_aangemaakte_acties := 0;
  l_cte_id_tab := cte_actie_kandidaten ( p_begin_datum => l_begin_datum
                                       )
  ;
  FOR i IN 1..l_cte_id_tab.COUNT
  LOOP
    aanmaken_actie_bij_cte ( pin_cte_id      => l_cte_id_tab(i)
                           , pid_begin_datum => l_begin_datum
                           , pon_aantal_aangemaakte_acties => l_aantal_aangemaakte_acties
                           )
    ;
    p_aantal_aangemaakte_acties := p_aantal_aangemaakte_acties + l_aantal_aangemaakte_acties;
  END LOOP;
  COMMIT;
END;
--
--
PROCEDURE aanmaken_acties ( p_jaar PLS_INTEGER
                          )
IS
  /**************************************************************************
  * DESCRIPTION hoofdprocedure voor batch voor het aanmaken van acties bij controles
  * en documenten voor een jaar
  *
  * PARAMETERS
  * ==========
  * NAME              TYPE     DESCRIPTION
  * ----------------- -------- ---------------------------------------------
  * p_jaar                  IN jaar waarvoor actie aangemaakt moeten worden
  * pid_begin_datum         IN begindatum meestal 1 januari
  * pin_dct_id              IN pk document
  *
  * HISTORY
  * =======
  * VERSION DATE       AUTHOR(S)       DESCRIPTION
  * ------- ---------- --------------- --------------------------
  *   1.0   05-08-2011 FBO             Initiele versie
  *************************************************************************/
  l_aantal PLS_INTEGER;
BEGIN
  aanmaken_acties_bij_cte ( p_jaar => p_jaar
                          , p_aantal_aangemaakte_acties => l_aantal
                          )
  ;
  aanmaken_acties_bij_doc ( p_jaar => p_jaar
                          , p_aantal_aangemaakte_acties => l_aantal
                          )
  ;
END;
--
--
FUNCTION beheerders
RETURN VARCHAR2
IS
  /**************************************************************************
  * DESCRIPTION
  *
  * PARAMETERS
  * ==========
  * NAME              TYPE     DESCRIPTION
  * ----------------- -------- ---------------------------------------------
  * RETURN                     string met beheerder voor beginscherm
  *
  * HISTORY
  * =======
  * VERSION DATE       AUTHOR(S)       DESCRIPTION
  * ------- ---------- --------------- --------------------------
  *   1.0   05-08-2011 FBO             Initiele versie
  *************************************************************************/
  CURSOR a
  IS
  SELECT DISTINCT
         APEX_UTIL.GET_LAST_NAME(sms_gebruikers_id ( p_windows_user => gri.gbr_id))||' ('||APEX_UTIL.GET_EMAIL(sms_gebruikers_id ( p_windows_user => gri.gbr_id))||')' achternaam
  FROM   sms_gebruiker_raci gri
  WHERE  gri.rai_id IN ( SELECT id
                         FROM   sms_raci
                         WHERE  functie = 'BEHEERDER'
                       )
  ;
  l_retval VARCHAR2(32767);
BEGIN
  FOR r_a IN a
  LOOP
    l_retval := l_retval||r_a.achternaam||g_komma;
  END LOOP;
  RETURN RTRIM(l_retval,g_komma);
END;
--
--
PROCEDURE welkom_test
IS
  /**************************************************************************
  * DESCRIPTION inhoud pagina 1
  *
  * PARAMETERS
  * ==========
  * NAME              TYPE     DESCRIPTION
  * ----------------- -------- ---------------------------------------------
  *
  * HISTORY
  * =======
  * VERSION DATE       AUTHOR(S)       DESCRIPTION
  * ------- ---------- --------------- --------------------------
  *   1.0   05-08-2011 FBO             Initiele versie
  *************************************************************************/
  CURSOR a
  IS
  SELECT user_name
  ,      APEX_UTIL.GET_LAST_NAME(user_name) achternaam
  ,      REPLACE(sms_pck.raci_gebruiker_functie_string(user_name),':',', ') raci
  ,      email
  ,      date_created datum_aanmaak
  FROM   ( SELECT user_name
           ,      email
           ,      date_created
           FROM   apex_workspace_apex_users
           WHERE  V('APP_USER') = user_name
         )
  ;
  FUNCTION welkom_tabel
  RETURN VARCHAR2
  IS
    l_retval VARCHAR2(32767);
  BEGIN
    l_retval := l_retval||HTF.TABLEOPEN ( cborder => '0'
                  , cattributes => 'cellpadding="0" cellspacing="0" class="t12standard" summary=""'
                  );
    FOR r_a IN a
    LOOP
      l_retval := l_retval||HTF.TABLEROWOPEN;
      l_retval := l_retval||HTF.TABLEHEADER ( cvalue      => 'Welkom '||r_a.achternaam||','
                                            , cattributes => 'width="1000" align="left"'
                                            , ccolspan    => 2
                                            );
      l_retval := l_retval||HTF.TABLEROWCLOSE;
      l_retval := l_retval||HTF.TABLEROWOPEN;
      l_retval := l_retval||HTF.TABLEDATA ( cvalue => g_spatie
                                          )
      ;
      l_retval := l_retval||HTF.TABLEDATA ( cvalue => g_spatie
                                          )
      ;
      l_retval := l_retval||HTF.TABLEROWCLOSE;
      l_retval := l_retval||HTF.TABLEROWOPEN;
      l_retval := l_retval||HTF.TABLEDATA ( cvalue => 'Email'
                                          , cattributes => 'align="left"'
                                          )
      ;
      l_retval := l_retval||HTF.TABLEDATA ( cvalue      => r_a.email
                                          , cattributes => 'align="left"'
                                          )
      ;
      l_retval := l_retval||HTF.TABLEROWCLOSE;
      l_retval := l_retval||HTF.TABLEROWOPEN;
      l_retval := l_retval||HTF.TABLEDATA ( cvalue => 'Autorisaties'
                                          , cattributes => 'align="left"'
                                          )
      ;
      l_retval := l_retval||HTF.TABLEDATA ( cvalue => r_a.raci
                                          , cattributes => 'align="left"'
                                          )
      ;
      l_retval := l_retval||HTF.TABLEROWCLOSE;
      l_retval := l_retval||HTF.TABLEROWOPEN;
      l_retval := l_retval||HTF.TABLEDATA ( cvalue => 'Beheerders'
                                          , cattributes => 'align="left"'
                                          )
      ;
      l_retval := l_retval||HTF.TABLEDATA ( cvalue      => beheerders
                                          , cattributes => 'align="left"'
                                          )
      ;
      l_retval := l_retval||HTF.TABLEROWCLOSE;
    END LOOP;
    l_retval := l_retval||HTF.TABLECLOSE;
    RETURN l_retval;
  END;
BEGIN
  HTP.TABLEOPEN ( cborder => '0'
                , cattributes => 'cellpadding="0" cellspacing="0" class="t12standard" summary=""'
                )
  ;
  HTP.TABLEROWOPEN;
  HTP.TABLEHEADER ( cvalue      => welkom_tabel
                  , cattributes => 'valign="top"'
                  )
  ;
  HTP.TABLEHEADER ( cvalue => HTF.IMG ( curl => V('WORKSPACE_IMAGES')||'isms_cyclus.JPG'
                                      , cattributes => 'align="left" width="200" height="200"'
                                      )
                  )
  ;
  HTP.TABLEROWCLOSE;
  HTP.TABLECLOSE;
END;
--
--
PROCEDURE verwijder_niet_gewijzigde_obw
IS
  /**************************************************************************
  * DESCRIPTION soms zijn er wijzig record aangemaakt zonder dat deze wijzigingen
  * bevatten deze kunnen dus worden verwijderd
  *
  * PARAMETERS
  * ==========
  * NAME              TYPE     DESCRIPTION
  * ----------------- -------- ---------------------------------------------
  *
  * HISTORY
  * =======
  * VERSION DATE       AUTHOR(S)       DESCRIPTION
  * ------- ---------- --------------- --------------------------
  *   1.0   05-08-2011 FBO             Initiele versie
  *************************************************************************/
  CURSOR a
  IS
  SELECT id
  FROM   sms_obw_wijzig
  ;
  l_id_tab dbms_sql.number_table;
  l_aantal PLS_INTEGER;
BEGIN
  OPEN a;
  FETCH a BULK COLLECT INTO l_id_tab;
  CLOSE a;
  FOR i IN 1..l_id_tab.COUNT
  LOOP
    SELECT COUNT(*)
    INTO   l_aantal
    FROM   TABLE (sms_pck.wijzigingen_obw (l_id_tab(i)))
    WHERE  ROWNUM < 2
    ;
    IF l_aantal = 0
    THEN
      wijzigingen_obw_niet_akkoord ( pin_obw_id => l_id_tab(i)
                                   )
      ;
    END IF;
  END LOOP;
END;
--
--
PROCEDURE verwijder_niet_gewijzigde_dct
IS
  /**************************************************************************
  * DESCRIPTION soms zijn er wijzig record aangemaakt zonder dat deze wijzigingen
  * bevatten deze kunnen dus worden verwijderd
  *
  * PARAMETERS
  * ==========
  * NAME              TYPE     DESCRIPTION
  * ----------------- -------- ---------------------------------------------
  *
  * HISTORY
  * =======
  * VERSION DATE       AUTHOR(S)       DESCRIPTION
  * ------- ---------- --------------- --------------------------
  *   1.0   05-08-2011 FBO             Initiele versie
  *************************************************************************/
BEGIN
  DELETE
  FROM   sms_documenten_wijzig
  WHERE  id     IN ( SELECT dctw_id
                 FROM   ( SELECT dctw.id dctw_id
                          ,      dct.id dct_id
                          ,      dctw.creation_date
                          ,      dctw.update_date
                          FROM   sms_documenten_wijzig dctw
                          ,      sms_documenten dct
                          WHERE  dct.id (+) = dctw.id
                        )
                 WHERE  creation_date = update_date
                 AND    dct_id IS NOT NULL
               )
  ;
END;
--
--
PROCEDURE werk_cae_string_in_bae ( p_bvg_id sms_bevindingen.id%TYPE
                                 )
IS
  /**************************************************************************
  * DESCRIPTION omdat gewerkt wordt met een shuttle wordt op deze manier gezorgd
  * dat de kinderen tabel sms_bevinding_acties goed wordt gesynchroniseerd
  *
  * PARAMETERS
  * ==========
  * NAME              TYPE     DESCRIPTION
  * ----------------- -------- ---------------------------------------------
  *
  * HISTORY
  * =======
  * VERSION DATE       AUTHOR(S)       DESCRIPTION
  * ------- ---------- --------------- --------------------------
  *   1.0   05-08-2011 FBO             Initiele versie
  *************************************************************************/
 l_bevinding_record sms_bevindingen%ROWTYPE := sms_bevindingen_record (pin_bvg_id => p_bvg_id);
 l_cae_id_tab dbms_sql.varchar2s;
BEGIN
  l_cae_id_tab := splits_string_met_delimeter ( p_string    => l_bevinding_record.cae_lijst
                                              , p_delimiter => ':'
                                              )
  ;
  DELETE
  FROM   sms_bevinding_acties
  WHERE  bvg_id = p_bvg_id
  ;
  FORALL i IN 1..l_cae_id_tab.COUNT
    INSERT INTO sms_bevinding_acties (bvg_id,cae_id) VALUES (p_bvg_id,l_cae_id_tab(i));
END;
--
--
FUNCTION sms_audits_record ( pin_adt_id sms_audits.id%TYPE
                           )
RETURN sms_audits%ROWTYPE
IS
  /**************************************************************************
  * DESCRIPTION ophalen record ahv primary key
  *
  *
  * PARAMETERS
  * ==========
  * NAME              TYPE     DESCRIPTION
  * ----------------- -------- ---------------------------------------------
  *pin_adt_id                 IN PK=programmanummer ID
  *
  * HISTORY
  * =======
  * VERSION DATE       AUTHOR(S)       DESCRIPTION
  * ------- ---------- --------------- --------------------------
  *   1.0   05-08-2011 FBO             Initiele versie
  *************************************************************************/
  CURSOR a
  IS
  SELECT *
  FROM   sms_audits
  WHERE  id = pin_adt_id
  ;
  lt_sms_audits sms_audits%ROWTYPE;
BEGIN
  OPEN a;
  FETCH a INTO lt_sms_audits;
  CLOSE a;
  RETURN lt_sms_audits;
END;
--
--
FUNCTION audit_naam  ( pin_adt_id sms_audits.id%TYPE
                     )
RETURN VARCHAR2
IS
  /**************************************************************************
  * DESCRIPTION naam van de audit
  *
  *
  * PARAMETERS
  * ==========
  * NAME              TYPE     DESCRIPTION
  * ----------------- -------- ---------------------------------------------
  *pin_adt_id                 IN PK=programmanummer ID
  *
  * HISTORY
  * =======
  * VERSION DATE       AUTHOR(S)       DESCRIPTION
  * ------- ---------- --------------- --------------------------
  *   1.0   05-08-2011 FBO             Initiele versie
  *************************************************************************/
  lt_sms_audits sms_audits%ROWTYPE;
BEGIN
  lt_sms_audits := sms_audits_record ( pin_adt_id => pin_adt_id
                                     )
  ;
  RETURN lt_sms_audits.omschrijving;
END;
--
--
FUNCTION bepaal_maatregel  ( p_bvg_id sms_bevindingen.id%TYPE
                           , p_dct_id sms_documenten.id%TYPE
                           , p_cte_id sms_controles.id%TYPE
                           )
RETURN sms_obw.id%TYPE
IS
  /**************************************************************************
  * DESCRIPTION bepalen onderliggende maatregel. Deze bestaat niet voor document
  *
  *
  * PARAMETERS
  * ==========
  * NAME              TYPE     DESCRIPTION
  * ----------------- -------- ---------------------------------------------
  * pin_bvg_id              IN PK=programmanummer ID bevindingen
  * pin_dct_id              IN PK=programmanummer ID document
  * pin_cte_id              IN PK=programmanummer ID controle
  * RETURN                 OUT maatregel
  *
  * HISTORY
  * =======
  * VERSION DATE       AUTHOR(S)       DESCRIPTION
  * ------- ---------- --------------- --------------------------
  *   1.0   05-08-2011 FBO             Initiele versie
  *************************************************************************/
  l_retval sms_obw.id%TYPE;
BEGIN
  IF p_bvg_id IS NOT NULL
  THEN
    l_retval := sms_bevindingen_record  ( pin_bvg_id => p_bvg_id
                                        ).obw_id;
  END IF;
  IF p_dct_id IS NOT NULL
  THEN
    l_retval := NULL;
  END IF;
  IF p_cte_id IS NOT NULL
  THEN
    l_retval := sms_controles_record  ( pin_cte_id => p_cte_id
                                      ).obw_id;
  END IF;
  RETURN l_retval;
END;
--
--
FUNCTION bepaal_obw_eigenaar ( p_obw_id sms_obw.id%TYPE
                             )
RETURN VARCHAR2
IS
  /**************************************************************************
  * DESCRIPTION
  *
  * PARAMETERS
  * ==========
  * NAME              TYPE     DESCRIPTION
  * ----------------- -------- ---------------------------------------------
  * p_obw_id             IN pk OBW
  * RETURN                     RACI van de eigenaar
  *
  * HISTORY
  * =======
  * VERSION DATE       AUTHOR(S)       DESCRIPTION
  * ------- ---------- --------------- --------------------------
  *   1.0   05-08-2011 FBO             Initiele versie
  *************************************************************************/
BEGIN
  RETURN functie_naam(sms_obw_record (pin_obw_id => p_obw_id).rai_id_eigenaar);
END;
--
--
FUNCTION bepaal_obw_beheerder ( p_obw_id sms_obw.id%TYPE
                              )
RETURN VARCHAR2
IS
  /**************************************************************************
  * DESCRIPTION
  *
  * PARAMETERS
  * ==========
  * NAME              TYPE     DESCRIPTION
  * ----------------- -------- ---------------------------------------------
  * p_obw_id             IN pk OBW
  * RETURN                     RACI van de beheerder
  *
  * HISTORY
  * =======
  * VERSION DATE       AUTHOR(S)       DESCRIPTION
  * ------- ---------- --------------- --------------------------
  *   1.0   05-08-2011 FBO             Initiele versie
  *************************************************************************/
BEGIN
  RETURN functie_naam(sms_obw_record (pin_obw_id => p_obw_id).rai_id_beheerder);
END;
--
--
FUNCTION bepaal_doc_eigenaar ( pin_dct_id sms_documenten.id%TYPE
                             )
RETURN VARCHAR2
IS
  /**************************************************************************
  * DESCRIPTION
  *
  * PARAMETERS
  * ==========
  * NAME              TYPE     DESCRIPTION
  * ----------------- -------- ---------------------------------------------
  * pin_dct_id              IN pk document
  * RETURN                     RACI van de eigenaar
  *
  * HISTORY
  * =======
  * VERSION DATE       AUTHOR(S)       DESCRIPTION
  * ------- ---------- --------------- --------------------------
  *   1.0   05-08-2011 FBO             Initiele versie
  *************************************************************************/
BEGIN
  RETURN functie_naam(sms_documenten_record (pin_dct_id => pin_dct_id).rai_id_eigenaar);
END;
--
--
FUNCTION bepaal_doc_beheerder ( pin_dct_id sms_documenten.id%TYPE
                              )
RETURN VARCHAR2
IS
  /**************************************************************************
  * DESCRIPTION
  *
  * PARAMETERS
  * ==========
  * NAME              TYPE     DESCRIPTION
  * ----------------- -------- ---------------------------------------------
  * pin_dct_id              IN pk document
  * RETURN                     RACI van de beheerder
  *
  * HISTORY
  * =======
  * VERSION DATE       AUTHOR(S)       DESCRIPTION
  * ------- ---------- --------------- --------------------------
  *   1.0   05-08-2011 FBO             Initiele versie
  *************************************************************************/
BEGIN
  RETURN functie_naam(sms_documenten_record (pin_dct_id => pin_dct_id).rai_id);
END;
--
--
FUNCTION geef_rai_id ( p_functie sms_raci.functie%TYPE
                     )
RETURN sms_raci.id%TYPE
IS
  /**************************************************************************
  * DESCRIPTION
  *
  * PARAMETERS
  * ==========
  * NAME              TYPE     DESCRIPTION
  * ----------------- -------- ---------------------------------------------
  * p_functie               IN functieomschrijving
  * RETURN                     RACI id behorende bij functie
  *
  * HISTORY
  * =======
  * VERSION DATE       AUTHOR(S)       DESCRIPTION
  * ------- ---------- --------------- --------------------------
  *   1.0   05-08-2011 FBO             Initiele versie
  *************************************************************************/
  l_retval sms_raci.id%TYPE;
BEGIN
  SELECT MAX(id)
  INTO   l_retval
  FROM   sms_raci
  WHERE  functie = p_functie
  ;
  RETURN l_retval;
END;
--
--
FUNCTION sms_applicatie_register_record ( p_applicatie sms_APPLICATIE_REGISTER.applicatie%TYPE
                                        , p_variabele sms_APPLICATIE_REGISTER.variabele%TYPE
                                        )
RETURN sms_applicatie_register%ROWTYPE
IS
  /**************************************************************************
  * DESCRIPTION ophalen record ahv primary key
  * 
  *
  * PARAMETERS
  * ==========
  * NAME              TYPE     DESCRIPTION
  * ----------------- -------- ---------------------------------------------
  *
  * HISTORY
  * =======
  * VERSION DATE       AUTHOR(S)       DESCRIPTION
  * ------- ---------- --------------- --------------------------
  *   1.0   05-08-2011 FBO             Initiele versie
  *************************************************************************/
  CURSOR a
  IS
  SELECT *
  FROM   sms_applicatie_register
  WHERE  variabele  = p_variabele
  AND    applicatie = p_applicatie
  ;
  lt_sms_applicatie_register sms_applicatie_register%ROWTYPE;
BEGIN
  OPEN a;
  FETCH a INTO lt_sms_applicatie_register;
  CLOSE a;
  RETURN lt_sms_applicatie_register;
END;
--
--
FUNCTION register_waarde ( p_applicatie sms_APPLICATIE_REGISTER.applicatie%TYPE
                         , p_variabele sms_APPLICATIE_REGISTER.variabele%TYPE
                         )
RETURN sms_applicatie_register.waarde%TYPE
IS
BEGIN
  RETURN sms_applicatie_register_record ( p_applicatie => p_applicatie
                                        , p_variabele  => p_variabele
                                        ).waarde
  ;                                        
END;                         
--
--
PROCEDURE welkome_tekst
IS
  /**************************************************************************
  * DESCRIPTION tekst op home pagina
  * 
  *
  * PARAMETERS
  * ==========
  * NAME              TYPE     DESCRIPTION
  * ----------------- -------- ---------------------------------------------
  *
  * HISTORY
  * =======
  * VERSION DATE       AUTHOR(S)       DESCRIPTION
  * ------- ---------- --------------- --------------------------
  *   1.0   12-04-2012 FBO             Initiele versie
  *************************************************************************/
BEGIN
  htp.p(register_waarde('SMS','WELKOMTEKST'));
--  htp.p('<br/>Gebruiker: '||APEX_UTIL.GET_LAST_NAME(V('APP_USER')));  
--  htp.p('<br/>Autorisatie: '||REPLACE(sms_pck.raci_gebruiker_functie_string(V('APP_USER')),':',', ')
--       )
--  ;  
END;
--
--
PROCEDURE security_incident_tekst
IS
  /**************************************************************************
  * DESCRIPTION tekst op home pagina
  * 
  *
  * PARAMETERS
  * ==========
  * NAME              TYPE     DESCRIPTION
  * ----------------- -------- ---------------------------------------------
  *
  * HISTORY
  * =======
  * VERSION DATE       AUTHOR(S)       DESCRIPTION
  * ------- ---------- --------------- --------------------------
  *   1.0   12-04-2012 FBO             Initiele versie
  *************************************************************************/
BEGIN
  htp.p(register_waarde('SMS','SECURITY_INCIDENT'));
END;
--
--
PROCEDURE dictu_ib_org_tekst
IS
  /**************************************************************************
  * DESCRIPTION tekst op home pagina
  * 
  *
  * PARAMETERS
  * ==========
  * NAME              TYPE     DESCRIPTION
  * ----------------- -------- ---------------------------------------------
  *
  * HISTORY
  * =======
  * VERSION DATE       AUTHOR(S)       DESCRIPTION
  * ------- ---------- --------------- --------------------------
  *   1.0   12-04-2012 FBO             Initiele versie
  *************************************************************************/
BEGIN
  htp.p(register_waarde('SMS','IB_ORGANISATIE'));
END;
--
--
PROCEDURE delete_obw ( p_obw_id  sms_obw.id%TYPE
                     )
IS
  /**************************************************************************
  * DESCRIPTION fysiek verwijderen obw met kinderen
  * 
  *
  * PARAMETERS
  * ==========
  * NAME              TYPE     DESCRIPTION
  * ----------------- -------- ---------------------------------------------
  *
  * HISTORY
  * =======
  * VERSION DATE       AUTHOR(S)       DESCRIPTION
  * ------- ---------- --------------- --------------------------
  *   1.0   12-04-2012 FBO             Initiele versie
  *   1.1   16-04-2012 FBO             sms_obw_normen toegevoegd
  *************************************************************************/
BEGIN
  DELETE 
  FROM   sms_obw_wijzig
  WHERE  id = p_obw_id
  ;
  DELETE 
  FROM   sms_obw_normen
  WHERE  obw_id = p_obw_id
  ;
  DELETE 
  FROM   sms_obw_processen
  WHERE  obw_id = p_obw_id
  ;
  DELETE 
  FROM   sms_documenten_obw_wijzig
  WHERE  obw_id = p_obw_id
  ;
  DELETE 
  FROM   sms_documenten_obw
  WHERE  obw_id = p_obw_id
  ;
  DELETE 
  FROM   sms_controles_wijzig
  WHERE  obw_id = p_obw_id
  ;
  DELETE 
  FROM   sms_controles
  WHERE  obw_id = p_obw_id
  ;
  DELETE 
  FROM   sms_bevindingen
  WHERE  obw_id = p_obw_id
  ;
  DELETE 
  FROM   sms_obw
  WHERE  id = p_obw_id
  ;
END;
--
--
PROCEDURE geef_html ( p_tekst VARCHAR2
                     )
IS
  /**************************************************************************
  * DESCRIPTION
  * 
  *
  * PARAMETERS
  * ==========
  * NAME              TYPE     DESCRIPTION
  * ----------------- -------- ---------------------------------------------
  *
  * HISTORY
  * =======
  * VERSION DATE       AUTHOR(S)       DESCRIPTION
  * ------- ---------- --------------- --------------------------
  *   1.0   12-04-2012 FBO             Initiele versie
  *************************************************************************/
BEGIN                     
--    htp.p(replace(p_tekst,CHR(10),'<br/>'));
  htp.p(p_tekst);
END;
--
--
PROCEDURE verwerk_nrm_string_in_onm ( p_obw_id sms_obw.id%TYPE
                                    )
IS
  /**************************************************************************
  * DESCRIPTION omdat gewerkt wordt met een shuttle wordt op deze manier gezorgd
  * dat de kinderen tabel sms_obw_normen goed wordt gesynchroniseerd
  *
  * PARAMETERS
  * ==========
  * NAME              TYPE     DESCRIPTION
  * ----------------- -------- ---------------------------------------------
  *
  * HISTORY
  * =======
  * VERSION DATE       AUTHOR(S)       DESCRIPTION
  * ------- ---------- --------------- --------------------------
  *   1.0   16-04-2012 FBO             Initiele versie
  *************************************************************************/
 l_obw_record sms_obw%ROWTYPE := sms_obw_record (pin_obw_id => p_obw_id);
 l_nrm_id_tab dbms_sql.varchar2s;
BEGIN
  l_nrm_id_tab := splits_string_met_delimeter ( p_string    => l_obw_record.nrm_ids
                                              , p_delimiter => ':'
                                              )
  ;
  DELETE
  FROM   sms_obw_normen
  WHERE  obw_id = p_obw_id
  ;
  FORALL i IN 1..l_nrm_id_tab.COUNT
    INSERT INTO sms_obw_normen (obw_id,nrm_id) VALUES (p_obw_id,l_nrm_id_tab(i));
END;
--
--
PROCEDURE verwerk_pcs_string_in_ops ( p_obw_id sms_obw.id%TYPE
                                    )
IS
  /**************************************************************************
  * DESCRIPTION omdat gewerkt wordt met een shuttle wordt op deze manier gezorgd
  * dat de kinderen tabel sms_obw_processen goed wordt gesynchroniseerd
  *
  * PARAMETERS
  * ==========
  * NAME              TYPE     DESCRIPTION
  * ----------------- -------- ---------------------------------------------
  *
  * HISTORY
  * =======
  * VERSION DATE       AUTHOR(S)       DESCRIPTION
  * ------- ---------- --------------- --------------------------
  *   1.0   16-04-2012 FBO             Initiele versie
  *************************************************************************/
 l_obw_record sms_obw%ROWTYPE := sms_obw_record (pin_obw_id => p_obw_id);
 l_pcs_id_tab dbms_sql.varchar2s;
BEGIN
  l_pcs_id_tab := splits_string_met_delimeter ( p_string    => l_obw_record.pcs_ids
                                              , p_delimiter => ':'
                                              )
  ;
  DELETE
  FROM   sms_obw_processen
  WHERE  obw_id = p_obw_id
  ;
  FORALL i IN 1..l_pcs_id_tab.COUNT
    INSERT INTO sms_obw_processen (obw_id,pcs_id) VALUES (p_obw_id,l_pcs_id_tab(i));
END;
--
--
FUNCTION sms_risicos_record ( pin_rso_id sms_risicos.id%TYPE
                           )
RETURN sms_risicos%ROWTYPE
IS
  /**************************************************************************
  * DESCRIPTION ophalen record ahv primary key
  *
  *
  * PARAMETERS
  * ==========
  * NAME              TYPE     DESCRIPTION
  * ----------------- -------- ---------------------------------------------
  *pin_rso_id                 IN PK=programmanummer ID
  *
  * HISTORY
  * =======
  * VERSION DATE       AUTHOR(S)       DESCRIPTION
  * ------- ---------- --------------- --------------------------
  *   1.0   05-08-2011 FBO             Initiele versie
  *************************************************************************/
  CURSOR a
  IS
  SELECT *
  FROM   sms_risicos
  WHERE  id = pin_rso_id
  ;
  lt_sms_risicos sms_risicos%ROWTYPE;
BEGIN
  OPEN a;
  FETCH a INTO lt_sms_risicos;
  CLOSE a;
  RETURN lt_sms_risicos;
END;
--
--
FUNCTION sms_risico_naam ( pin_rso_id sms_risicos.id%TYPE
                         )
RETURN VARCHAR2
IS
  /**************************************************************************
  * DESCRIPTION ophalen record ahv primary key
  *
  *
  * PARAMETERS
  * ==========
  * NAME              TYPE     DESCRIPTION
  * ----------------- -------- ---------------------------------------------
  *pin_rso_id                 IN PK=programmanummer ID
  *
  * HISTORY
  * =======
  * VERSION DATE       AUTHOR(S)       DESCRIPTION
  * ------- ---------- --------------- --------------------------
  *   1.0   05-08-2011 FBO             Initiele versie
  *************************************************************************/
  lt_sms_risicos sms_risicos%ROWTYPE := sms_risicos_record ( pin_rso_id => pin_rso_id
                                                           )
  ;
BEGIN
  RETURN sms_risico_analyses_record ( pin_rae_id => lt_sms_risicos.rae_id).omschrijving_kort||CHR(32)||lt_sms_risicos.korte_omschrijving;
END;
--
--
FUNCTION sms_behandelplannen_record ( pin_bpn_id sms_behandelplannen.id%TYPE
                                    )
RETURN sms_behandelplannen%ROWTYPE
IS
  /**************************************************************************
  * DESCRIPTION ophalen record ahv primary key
  *
  *
  * PARAMETERS
  * ==========
  * NAME              TYPE     DESCRIPTION
  * ----------------- -------- ---------------------------------------------
  * pin_bpn_id              IN PK sms_behandelplannen_record
  *
  * HISTORY
  * =======
  * VERSION DATE       AUTHOR(S)       DESCRIPTION
  * ------- ---------- --------------- --------------------------
  *   1.0   11-05-2012 FBO             Initiele versie
  *************************************************************************/
  CURSOR a
  IS
  SELECT *
  FROM   sms_behandelplannen
  WHERE  id = pin_bpn_id
  ;
  l_sms_behandelplannen_record sms_behandelplannen%ROWTYPE;
BEGIN
  OPEN a;
  FETCH a INTO l_sms_behandelplannen_record;
  CLOSE a;
  RETURN l_sms_behandelplannen_record;
END;
--
--
FUNCTION behandelplan_naam ( pin_bpn_id sms_behandelplannen.id%TYPE
                           )
RETURN VARCHAR2
IS
  /**************************************************************************
  * DESCRIPTION ophalen record ahv primary key
  *
  *
  * PARAMETERS
  * ==========
  * NAME              TYPE     DESCRIPTION
  * ----------------- -------- ---------------------------------------------
  * pin_bpn_id              IN PK sms_behandelplannen_record
  *
  * HISTORY
  * =======
  * VERSION DATE       AUTHOR(S)       DESCRIPTION
  * ------- ---------- --------------- --------------------------
  *   1.0   11-05-2012 FBO             Initiele versie
  *************************************************************************/
  l_sms_behandelplannen_record sms_behandelplannen%ROWTYPE := sms_behandelplannen_record ( pin_bpn_id => pin_bpn_id
                                                                                         )
  ;
BEGIN
  RETURN l_sms_behandelplannen_record.omschrijving_kort;
END;
--
--

FUNCTION obw_bij_risico_litanie ( pin_rso_id sms_risicos.id%TYPE
                                )
RETURN VARCHAR2
IS
  /**************************************************************************
  * DESCRIPTION ophalen alle obw waaraan risico's zijn gekoppeld
  *
  *
  * PARAMETERS
  * ==========
  * NAME              TYPE     DESCRIPTION
  * ----------------- -------- ---------------------------------------------
  * pin_rso_id              IN PK sms_risicos
  *
  * HISTORY
  * =======
  * VERSION DATE       AUTHOR(S)       DESCRIPTION
  * ------- ---------- --------------- --------------------------
  *   1.0   11-05-2012 FBO             Initiele versie
  *************************************************************************/
  l_retval VARCHAR2(1000);
BEGIN
  SELECT RTRIM (XMLAGG (XMLELEMENT (e, maatregel ( pin_obw_id => onm.obw_id) || ',')).EXTRACT ('//text()'), ',')
  INTO   l_retval
  FROM   sms_obw_normen onm
  ,      sms_normen nrm
  WHERE  onm.nrm_id = nrm.id
  AND    nrm.rso_id = pin_rso_id
  ;
  RETURN l_retval;
END;
--
--
FUNCTION behandelplan_bij_risico ( pin_rso_id sms_risicos.id%TYPE
                                 )
RETURN VARCHAR2
IS
  /**************************************************************************
  * DESCRIPTION ophalen behandelplan bij risiso
  *
  *
  * PARAMETERS
  * ==========
  * NAME              TYPE     DESCRIPTION
  * ----------------- -------- ---------------------------------------------
  * pin_rso_id              IN PK sms_risicos
  *
  * HISTORY
  * =======
  * VERSION DATE       AUTHOR(S)       DESCRIPTION
  * ------- ---------- --------------- --------------------------
  *   1.0   11-05-2012 FBO             Initiele versie
  *************************************************************************/
  CURSOR a
  IS
  SELECT sms_pck.behandelplan_naam ( pin_bpn_id => nrm.bpn_id) plan
  FROM   sms_normen nrm
  WHERE  nrm.rso_id = pin_rso_id
  ;
  l_retval VARCHAR2(100);
BEGIN
  OPEN a;
  FETCH a INTO l_retval;
  CLOSE a;
  RETURN l_retval;
END;
--
--
FUNCTION sms_projecten_record ( pin_pjt_id sms_projecten.id%TYPE
                              )
RETURN sms_projecten%ROWTYPE
IS
  /**************************************************************************
  * DESCRIPTION ophalen record ahv primary key
  *
  *
  * PARAMETERS
  * ==========
  * NAME              TYPE     DESCRIPTION
  * ----------------- -------- ---------------------------------------------
  *pin_pjt_id                 IN PK=programmanummer ID
  *
  * HISTORY
  * =======
  * VERSION DATE       AUTHOR(S)       DESCRIPTION
  * ------- ---------- --------------- --------------------------
  *   1.0   18-05-2012 FBO             Initiele versie
  *************************************************************************/
  CURSOR a
  IS
  SELECT *
  FROM   sms_projecten
  WHERE  id = pin_pjt_id
  ;
  lt_sms_projecten sms_projecten%ROWTYPE;
BEGIN
  OPEN a;
  FETCH a INTO lt_sms_projecten;
  CLOSE a;
  RETURN lt_sms_projecten;
END;
--
--
FUNCTION projecten_naam ( pin_pjt_id sms_projecten.id%TYPE
                        )
RETURN VARCHAR2
IS
  /**************************************************************************
  * DESCRIPTION ophalen record ahv primary key
  *
  *
  * PARAMETERS
  * ==========
  * NAME              TYPE     DESCRIPTION
  * ----------------- -------- ---------------------------------------------
  *pin_pjt_id                 IN PK=programmanummer ID
  *
  * HISTORY
  * =======
  * VERSION DATE       AUTHOR(S)       DESCRIPTION
  * ------- ---------- --------------- --------------------------
  *   1.0   18-05-2012 FBO             Initiele versie
  *************************************************************************/
  lt_sms_projecten sms_projecten%ROWTYPE := sms_projecten_record ( pin_pjt_id => pin_pjt_id);
BEGIN
  RETURN lt_sms_projecten.projectnaam;
END;
--
--
FUNCTION sms_organisaties_record ( pin_oge_id sms_organisaties.id%TYPE
                                 )
RETURN sms_organisaties%ROWTYPE
IS
  /**************************************************************************
  * DESCRIPTION ophalen record ahv primary key
  *
  *
  * PARAMETERS
  * ==========
  * NAME              TYPE     DESCRIPTION
  * ----------------- -------- ---------------------------------------------
  *pin_oge_id                 IN PK=programmanummer ID
  *
  * HISTORY
  * =======
  * VERSION DATE       AUTHOR(S)       DESCRIPTION
  * ------- ---------- --------------- --------------------------
  *   1.0   18-05-2012 FBO             Initiele versie
  *************************************************************************/
  CURSOR a
  IS
  SELECT *
  FROM   sms_organisaties
  WHERE  id = pin_oge_id
  ;
  lt_sms_organisaties sms_organisaties%ROWTYPE;
BEGIN
  OPEN a;
  FETCH a INTO lt_sms_organisaties;
  CLOSE a;
  RETURN lt_sms_organisaties;
END;
--
--
FUNCTION organisaties_naam ( pin_oge_id sms_organisaties.id%TYPE
                           )
RETURN VARCHAR2
IS
  /**************************************************************************
  * DESCRIPTION ophalen record ahv primary key
  *
  *
  * PARAMETERS
  * ==========
  * NAME              TYPE     DESCRIPTION
  * ----------------- -------- ---------------------------------------------
  *pin_oge_id                 IN PK=programmanummer ID
  *
  * HISTORY
  * =======
  * VERSION DATE       AUTHOR(S)       DESCRIPTION
  * ------- ---------- --------------- --------------------------
  *   1.0   18-05-2012 FBO             Initiele versie
  *************************************************************************/
  lt_sms_organisaties sms_organisaties%ROWTYPE := sms_organisaties_record ( pin_oge_id => pin_oge_id);
BEGIN
  RETURN lt_sms_organisaties.afkorting;
END;
--
--
FUNCTION is_ib_specialist
RETURN BOOLEAN
IS
  /**************************************************************************
  * DESCRIPTION
  *
  * PARAMETERS
  * ==========
  * NAME              TYPE     DESCRIPTION
  * ----------------- -------- ---------------------------------------------
  * RETURN                     TRUE=apex gebruiker is IB-specialist
  *
  * HISTORY
  * =======
  * VERSION DATE       AUTHOR(S)       DESCRIPTION
  * ------- ---------- --------------- --------------------------
  *   1.0   08-08-2012 FBO             Initiele versie
  *************************************************************************/
  l_aantal PLS_INTEGER;
  l_retval BOOLEAN := FALSE;
BEGIN
    IF is_beheerder
    THEN
      l_retval := TRUE;
    ELSE 
    SELECT COUNT(*)
    INTO   l_aantal
    FROM   sms_gebruiker_raci gri
    WHERE  sms_gebruikers_id ( p_windows_user => V('APP_USER')) = gri.gbr_id
    AND    gri.rai_id IN ( SELECT id
                           FROM   sms_raci
                           WHERE  functie LIKE ('IB SPECIALIST'||'%')
                         )
    AND    ROWNUM < 2
    ;
    l_retval := (l_aantal=1);
  END IF;
  RETURN l_retval;
END;
--
--
FUNCTION account_is_locked ( p_user_name VARCHAR2
                           )
RETURN VARCHAR2
IS
  l_retval VARCHAR2(1) := 'N';
BEGIN
    IF apex_util.GET_ACCOUNT_LOCKED_STATUS(p_user_name)
    THEN
    l_retval := 'J';
    END IF;
    RETURN l_retval;
END;
--
--
FUNCTION rollen_bij_medewer_lit ( pin_mwr_id sms_gebruikers.id%TYPE
                                 )
RETURN VARCHAR2
IS
  /**************************************************************************
  * DESCRIPTION ophalen rollen bij medewerkers
  *
  *
  * PARAMETERS
  * ==========
  * NAME              TYPE     DESCRIPTION
  * ----------------- -------- ---------------------------------------------
  * pin_rso_id              IN PK sms_risicos
  *
  * HISTORY
  * =======
  * VERSION DATE       AUTHOR(S)       DESCRIPTION
  * ------- ---------- --------------- --------------------------
  *   1.0   11-05-2012 FBO             Initiele versie
  *************************************************************************/
  l_retval VARCHAR2(1000);
BEGIN
  SELECT RTRIM (XMLAGG (XMLELEMENT (e, rolnaam ( pin_rol_id => mrl.rol_id) || ',')).EXTRACT ('//text()'), ',')
  INTO   l_retval
  FROM   sms_gebruiker_rollen mrl
  WHERE  gbr_id = pin_mwr_id
  ;
  RETURN l_retval;
END;
--
--
FUNCTION obw_bij_documenten ( pin_dct_id sms_documenten.id%TYPE
                            )
RETURN VARCHAR2
IS
  /**************************************************************************
  * DESCRIPTION
  *
  * PARAMETERS
  * ==========
  * NAME              TYPE     DESCRIPTION
  * ----------------- -------- ---------------------------------------------
  * pin_obw_id           IN PK OBW wijzig
  * RETURN                     string met documenten bij OBW
  *
  * HISTORY
  * =======
  * VERSION DATE       AUTHOR(S)       DESCRIPTION
  * ------- ---------- --------------- --------------------------
  *   1.0   05-08-2011 FBO             Initiele versie
  *************************************************************************/
  l_retval VARCHAR2(32767);
BEGIN
  SELECT LISTAGG(maatregel ( dow.obw_id), ', ') WITHIN GROUP (ORDER BY obw_id)
  INTO   l_retval
  FROM   sms_documenten_obw dow
  WHERE  dow.dct_id = pin_dct_id
  ;
  RETURN l_retval;
END;
--
--
FUNCTION sms_fout_boodschappen_record ( pin_boodschap sms_fout_boodschappen.boodschap%TYPE
                                      )
RETURN sms_fout_boodschappen%ROWTYPE
IS
  /**************************************************************************
  * DESCRIPTION ophalen record ahv primary key
  *
  *
  * PARAMETERS
  * ==========
  * NAME              TYPE     DESCRIPTION
  * ----------------- -------- ---------------------------------------------
  *pin_fbg_id                 IN PK=programmanummer ID
  *
  * HISTORY
  * =======
  * VERSION DATE       AUTHOR(S)       DESCRIPTION
  * ------- ---------- --------------- --------------------------
  *   1.0   05-08-2011 FBO             Initiele versie
  *************************************************************************/
  CURSOR a
  IS
  SELECT *
  FROM   sms_fout_boodschappen
  WHERE  boodschap = pin_boodschap
  ;
  lt_sms_fout_boodschappen sms_fout_boodschappen%ROWTYPE;
BEGIN
  OPEN a;
  FETCH a INTO lt_sms_fout_boodschappen;
  CLOSE a;
  RETURN lt_sms_fout_boodschappen;
END;
--
--    
PROCEDURE maak_foutlog ( p_apex_error         IN OUT apex_error.t_error_result
                       , p_error              IN OUT apex_error.t_error
                       , p_fout_boodschap            sms_fout_boodschappen.boodschap%TYPE
                       , p_foutlog_id            OUT PLS_INTEGER
                       , p_functionele_boodschap OUT sms_fout_boodschappen.functionele_boodschap%TYPE
                       )
IS
  l_sms_fout_boodschappen_record sms_fout_boodschappen%ROWTYPE := sms_fout_boodschappen_record ( pin_boodschap => p_fout_boodschap
                                                                                               )
  ;
  PRAGMA AUTONOMOUS_TRANSACTION;
BEGIN
  if  p_apex_error.page_item_name is null 
  and p_apex_error.column_alias is null 
  then
    apex_error.auto_set_associated_item ( p_error        => p_error
                                        , p_error_result => p_apex_error
                                        )
    ;
  end if;
  INSERT INTO sms_foutenlog ( boodschap
                            , fout_boodschap
                            , additional_info
                            , display_location
                            , page_item_name
                            , column_alias
                            )
  VALUES                    ( p_apex_error.message
                            , p_fout_boodschap
                            , p_apex_error.additional_info
                            , p_apex_error.display_location
                            , p_apex_error.page_item_name
                            , p_apex_error.column_alias
                            )
  RETURNING id INTO p_foutlog_id
  ;
  IF l_sms_fout_boodschappen_record.id IS NULL
  THEN
    INSERT INTO sms_fout_boodschappen ( boodschap 
                                      )
    VALUES                            ( p_fout_boodschap
                                      )
    ;
  ELSE
    p_functionele_boodschap := l_sms_fout_boodschappen_record.functionele_boodschap;
  END IF;
  COMMIT;
END;
--
--
FUNCTION is_constraint_violation ( p_error     apex_error.t_error
                                 )
RETURN BOOLEAN
IS
  l_retval BOOLEAN := FALSE;
BEGIN
  --   -) ORA-00001: unique constraint violated
  --   -) ORA-02091: transaction rolled back (-> can hide a deferred constraint)
  --   -) ORA-02290: check constraint violated
  --   -) ORA-02291: integrity constraint violated - parent key not found
  --   -) ORA-02292: integrity constraint violated - child record found
  IF p_error.ora_sqlcode IN (-1, -2091, -2290, -2291, -2292) 
  THEN
    l_retval := TRUE;
  END IF;
  RETURN l_retval;
END;
--
--
FUNCTION access_denied ( p_apex_error_code VARCHAR2
                        )
RETURN BOOLEAN
IS
  l_retval BOOLEAN := FALSE;
BEGIN
  if p_apex_error_code = 'APEX.AUTHORIZATION.ACCESS_DENIED'
  then
    l_retval := TRUE;
  end if;
  RETURN l_retval;
END;
--
--                   
FUNCTION apex_error_handling ( p_error IN OUT apex_error.t_error 
                             )
RETURN apex_error.t_error_result
is
  l_result                apex_error.t_error_result;
  l_reference_id          PLS_INTEGER;
  l_constraint_name       varchar2(255);
  l_constraint_violation  BOOLEAN;
  l_fout_boodschap        sms_fout_boodschappen.boodschap%TYPE;
  l_functionele_boodschap sms_fout_boodschappen.functionele_boodschap%TYPE;
  l_access_denied         BOOLEAN;
  l_ora_fout              BOOLEAN;
--
--
BEGIN
  l_result := apex_error.init_error_result ( p_error => p_error 
                                           )
  ;
  l_constraint_violation := is_constraint_violation ( p_error => p_error 
                                                    )
  ;
  l_access_denied        := access_denied ( p_apex_error_code => p_error.apex_error_code 
                                          )
  ;
  IF NOT l_access_denied AND l_constraint_violation
  THEN
    l_fout_boodschap := apex_error.extract_constraint_name ( p_error => p_error 
                                                           )
    ;
    l_ora_fout := (l_fout_boodschap IS NOT NULL);
  ELSIF NOT l_access_denied
  THEN
    l_fout_boodschap := apex_error.get_first_ora_error_text ( p_error => p_error 
                                                            )
    ;
    l_ora_fout := (l_fout_boodschap IS NOT NULL);
  END IF;
  IF NOT l_access_denied
  AND l_ora_fout
  THEN
    maak_foutlog ( p_apex_error            => l_result
                 , p_error                 => p_error
                 , p_fout_boodschap        => l_fout_boodschap
                 , p_foutlog_id            => l_reference_id
                 , p_functionele_boodschap => l_functionele_boodschap
                 )
    ;
  END IF;
  IF p_error.is_internal_error 
  AND NOT l_access_denied 
  THEN
    l_result.message         := 'An unexpected internal application error has occurred. '||
                                'Please get in contact with XXX and provide '||
                                'reference# '||to_char(l_reference_id, '999G999G999G990')||
                                ' for further investigation.';
    l_result.additional_info := null;
  ELSIF NOT l_access_denied 
  AND l_ora_fout
  THEN
    l_result.display_location := CASE
                                   WHEN l_result.display_location = apex_error.c_on_error_page then apex_error.c_inline_in_notification
                                   ELSE l_result.display_location
                                 END;
    IF l_functionele_boodschap IS NOT NULL
    THEN
      l_result.message := l_functionele_boodschap;
    ELSE
      l_result.message := l_fout_boodschap;        
    END IF;
  END IF;
  RETURN l_result;
END apex_error_handling;
--
--
PROCEDURE log_gebruiker
IS
BEGIN
    UPDATE sms_gebruikers
    SET    last_login_datum = SYSDATE
  ,      pre_last_login_datum = last_login_datum
  WHERE  WINDOWS_USER = V('APP_USER')
  ;
END;
--
--
FUNCTION alleen_beheerder_inloggen ( p_gebruiker VARCHAR2
                                   )
RETURN BOOLEAN
IS
  l_retval BOOLEAN := TRUE;
BEGIN
    IF register_waarde('SMS','ALLEEN_BEHEERDER') = 'J'
    AND NOT is_beheerder(p_gebruiker)
    THEN
    l_retval := FALSE;
    END IF;
  RETURN l_retval;
END;
--
--
FUNCTION documentstring_naar_tekst ( p_dct_ids sms_documenten.dct_ids_vervangt%TYPE
                                   )
RETURN VARCHAR2
IS
  /**************************************************************************
  * DESCRIPTION omdat gewerkt wordt met een shuttle wordt op deze manier gezorgd
  * dat de kinderen tabel sms_obw_documenten goed wordt gesynchroniseerd
  *
  * PARAMETERS
  * ==========
  * NAME              TYPE     DESCRIPTION
  * ----------------- -------- ---------------------------------------------
  *
  * HISTORY
  * =======
  * VERSION DATE       AUTHOR(S)       DESCRIPTION
  * ------- ---------- --------------- -------------------------
  *   1.0   16-04-2012 FBO             Initiele versie
  *************************************************************************/
 l_document_tekst_string VARCHAR2(32767);
 l_dct_id_tab dbms_sql.varchar2s;
BEGIN
  l_dct_id_tab := splits_string_met_delimeter ( p_string    => p_dct_ids
                                              , p_delimiter => ':'
                                              )
  ;
  FOR i IN 1..l_dct_id_tab.COUNT
  LOOP
    l_document_tekst_string := l_document_tekst_string||doc_naam ( pin_dct_id => l_dct_id_tab(i))||g_komma;
  END LOOP;
  RETURN RTRIM(l_document_tekst_string,g_komma);
END;
--
--
FUNCTION sms_gebruikers_record ( p_windows_user sms_gebruikers.windows_user%TYPE
                              )
RETURN sms_gebruikers%ROWTYPE
IS
  /**************************************************************************
  * DESCRIPTION ophalen record ahv primary key
  *
  *
  * PARAMETERS
  * ==========
  * NAME              TYPE     DESCRIPTION
  * ----------------- -------- ---------------------------------------------
  *pin_gbr_id                 IN PK=programmanummer ID
  *
  * HISTORY
  * =======
  * VERSION DATE       AUTHOR(S)       DESCRIPTION
  * ------- ---------- --------------- --------------------------
  *   1.0   10-11-2013 FBO             Initiele versie
  *************************************************************************/
  CURSOR a
  IS
  SELECT *
  FROM   sms_gebruikers
  WHERE  windows_user = UPPER(p_windows_user)
  ;
  lt_sms_gebruikers sms_gebruikers%ROWTYPE;
BEGIN
  OPEN a;
  FETCH a INTO lt_sms_gebruikers;
  CLOSE a;
  RETURN lt_sms_gebruikers;
END;
--
--
FUNCTION sms_gebruikers_id ( p_windows_user sms_gebruikers.windows_user%TYPE
                           )
RETURN sms_gebruikers.id%TYPE
IS
BEGIN
    RETURN sms_gebruikers_record ( p_windows_user => p_windows_user ).id;
END;
--
--
FUNCTION check_bestaat_regelgeving ( p_regelgeving VARCHAR2
                                   )
RETURN BOOLEAN
IS
  /**************************************************************************
  * DESCRIPTION regelgeving moet bestaan in register check in scherm nieuwe regelgeving
  *
  * PARAMETERS
  * ==========
  * NAME              TYPE     DESCRIPTION
  * ----------------- -------- ---------------------------------------------
  *
  * HISTORY
  * =======
  * VERSION DATE       AUTHOR(S)       DESCRIPTION
  * ------- ---------- --------------- --------------------------
  *   1.0   19-04-2014 FBO             Initiele versie
  *************************************************************************/
  l_retval PLS_INTEGER;
BEGIN
  SELECT COUNT(*)
  INTO   l_retval
  FROM   sms_applicatie_register
  WHERE  variabele  LIKE 'REGELGEVING%'
  AND    applicatie = 'SMS'
  AND    waarde= p_regelgeving
  ;
  RETURN ( l_retval > 0 );
END;
--
--
FUNCTION check_regelg_reeds_geladen
RETURN BOOLEAN
IS
  /**************************************************************************
  * DESCRIPTION regelgeving mag slechts 1x geladen worden check in scherm nieuwe regelgeving
  *
  * PARAMETERS
  * ==========
  * NAME              TYPE     DESCRIPTION
  * ----------------- -------- ---------------------------------------------
  *
  * HISTORY
  * =======
  * VERSION DATE       AUTHOR(S)       DESCRIPTION
  * ------- ---------- --------------- --------------------------
  *   1.0   19-04-2014 FBO             Initiele versie
  *************************************************************************/
  l_retval PLS_INTEGER;
BEGIN
    SELECT COUNT(*)
    INTO   l_retval
    FROM   sms_iso_hoofdstukken ihk
    WHERE  EXISTS ( SELECT 'x' 
                    FROM   sms_imp_nieuwe_regelgeving nrg 
                    WHERE  nrg.jaar = ihk.jaar 
                    AND    nrg.regelgeving = ihk.regelgeving
                  )
  ;
  RETURN ( l_retval > 0 );
END;
--
--

PROCEDURE verwerk_nieuwe_regelgeving
IS
  /**************************************************************************
  * DESCRIPTION via de schermen wordt een dataload uitgevoerd op de tabel SMS_IMP_NIEUWE_REGELGEVING
  * deze kan in scherm 
  *
  *
  * PARAMETERS
  * ==========
  * NAME              TYPE     DESCRIPTION
  * ----------------- -------- ---------------------------------------------
  *
  * HISTORY
  * =======
  * VERSION DATE       AUTHOR(S)       DESCRIPTION
  * ------- ---------- --------------- --------------------------
  *   1.0   19-04-2014 FBO             Initiele versie
  *************************************************************************/
BEGIN
  INSERT INTO SMS_ISO_HOOFDSTUKKEN ( hoofdstuk_nr
                                   , hoofdstuk_titel
                                   , jaar
                                   , regelgeving
  )
  SELECT DISTINCT   
         hoofdstuk_nr
  ,      hoofdstuk_titel
  ,      jaar
  ,      regelgeving
  FROM   sms_imp_nieuwe_regelgeving
  ;
  INSERT INTO sms_iso_secties ( sectie_nr
                              , sectie_titel
                              , sectie_doel
                              , ihk_id
                              )
  SELECT DISTINCT 
         sectie_nr
  ,      sectie_titel
  ,      sectie_doel
  ,      ( SELECT id 
           FROM   sms_iso_hoofdstukken ihk 
           WHERE  ihk.hoofdstuk_nr = inr.hoofdstuk_nr 
           AND    ihk.regelgeving=inr.regelgeving 
           AND    inr.jaar = ihk.jaar
         )
  FROM   sms_imp_nieuwe_regelgeving inr
  ;
  INSERT INTO sms_iso_paragrafen ( paragraaf_nr
                                 , paragraaf_titel
                                 , norm
                                 , ise_id
  )
  SELECT DISTINCT
         paragraaf_nr
  ,      paragraaf_titel
  ,      norm
  ,      ( SELECT ise.id 
           FROM   sms_iso_secties ise
           ,      sms_iso_hoofdstukken ihk 
           WHERE  ihk.id = ise.ihk_id 
           AND    ise.sectie_nr=inr.sectie_nr 
           AND    ise.sectie_doel=inr.sectie_doel 
           AND    ihk.hoofdstuk_nr=inr.hoofdstuk_nr 
           AND    ihk.regelgeving=inr.regelgeving 
           AND    inr.jaar=ihk.jaar
         )
  FROM   sms_imp_nieuwe_regelgeving inr
  ;
END;
--
--
END sms_pck;

/
