CREATE OR REPLACE PROCEDURE DBMM_N.AnalyzeObject(mest_par IN VARCHAR2)
IS
  v_sql       VARCHAR2(4000);
  mest_code   NUMBER;
  objname_par VARCHAR2(3);
  last_year   DATE := Trunc(SYSDATE - interval '1' year, 'YEAR');
BEGIN
    SELECT mest
    INTO   mest_code
    FROM   dp_sprobjcode
    WHERE  Upper(Trim(objfullname)) = Upper(Trim(mest_par));

    objname_par := Getobjectnamebymest(mest_code);

    FOR rec IN (SELECT sprpl.mest         AS mest,
                       sprpl.plast        AS plast_sprl,
                       sprpl.gor          AS gor_sprl,
                       sprpl.comment_     AS comment_sprpl,
                       sortplast.plast    AS plast_sortplast,
                       sortplast.comment_ AS comment_sortplast,
                       sortplast.hor      AS hor_sortplast,
                       obj.plast          AS plast_obj,
                       obr.strat_id       AS stratid_sprobr,
                       obr.pl_1           AS pl1_obr,
                       class.cd_1         AS cd1_class,
                       class.ne_1         AS ne1_class,
                       CASE
                         WHEN sprpl.comment_ = sortplast.comment_
                              AND sprpl.mest IN ( mest_code ) THEN NULL
                         ELSE 'no'
                       END                AS comment_is_equal,
                       CASE
                         WHEN sprpl.plast = sortplast.plast
                              AND sprpl.plast = obr.strat_id
                              AND sprpl.mest IN ( mest_code ) THEN NULL
                         ELSE 'no'
                       END                AS code_plast_is_equal,
                       CASE
                         WHEN sprpl.gor IN (SELECT gor
                                            FROM   dp_sprpl
                                            WHERE  plast <> gor
                                                   AND sprpl.mest IN
                                                       ( mest_code ))
                       THEN '+'
                         ELSE NULL
                       END                AS check_gor_obr_prnt_wmw_prnt,
                       CASE
                         WHEN obr.pl_1 = class.cd_1
                               OR ( obr.pl_1 IS NULL
                                    AND class.cd_1 IS NULL ) THEN NULL
                         ELSE 'no'
                       END                AS ois_code_is_equal,
                       CASE
                         WHEN Row_number()
                                over(
                                  PARTITION BY sprpl.comment_
                                  ORDER BY sprpl.comment_) > 1 THEN 'no'
                         ELSE NULL
                       END                AS not_duplicate,
                       CASE
                         WHEN EXISTS (SELECT plast
                                      FROM   dp_adr
                                      WHERE  plast = sprpl.plast
                                             AND Substr(nwell_id, 1, 2) IN (
                                                 mest_code )) THEN
                         NULL
                         ELSE 'no'
                       END                AS data_in_adr,
                       CASE
                         WHEN EXISTS (SELECT plast
                                      FROM   dp_fnd
                                      WHERE  plast = sprpl.plast
                                             AND Substr(nwell_id, 1, 2) IN (
                                                 mest_code )
                                             AND datecr >= Trunc(
                                                 SYSDATE - interval
                                                 '1' year,
                                                           'YEAR'))
                       THEN NULL
                         ELSE 'no'
                       END                AS data_in_fnd,
                       CASE
                         WHEN EXISTS (SELECT mm_code
                                      FROM   mv_eobj_spr2
                                      WHERE  mm_code = sprpl.plast
                                             AND mest IN ( mest_code )) THEN
                         NULL
                         ELSE 'no'
                       END                AS pl_in_wmw_spr,
                       CASE
                         WHEN EXISTS (SELECT strat_id_parent
                                      FROM   dp_sprobr sprobr
                                      WHERE  mest IN ( mest_code )
                                             AND sprpl.plast = sprobr.strat_id
                                             AND strat_id_parent IS NOT NULL)
                       THEN
                         'no'
                         ELSE NULL
                       END                AS pl_in_wmw_havent_parent
                FROM   dp_sprpl sprpl
                       full join dp_sortplast sortplast
                              ON sprpl.plast = sortplast.plast
                       full join dp_sprobj obj
                              ON sprpl.plast = obj.plast
                                 AND obj.objname = objname_par
                       left join mv_eobj_spr2 mvobj
                              ON mvobj.mm_code = sprpl.plast
                                 AND mvobj.mest IN ( mest_code )
                       left join dp_sprobr obr
                              ON sortplast.plast = obr.strat_id
                                 AND obr.mest IN ( mest_code/* select mest */
                                                 /* from mest_object */ )
                       full join class
                              ON obr.pl_1 = class.cd_1
                WHERE  sprpl.mest = ( mest_code )
                UNION ALL
                SELECT NULL      AS mest,
                       NULL      AS plast_sprpl,
                       NULL      AS gor_sprpl,
                       '-'       AS comment_sprpl,
                       NULL      AS plast_sortplast,
                       NULL      AS comment_sortplast,
                       NULL      AS hor_sortplast,
                       obj.plast AS plast_obj,
                       NULL      AS stratid_sprobr,
                       NULL      AS pl1_obr,
                       NULL      AS cd1_class,
                       NULL      AS ne1_class,
                       '-'       AS comment_is_equal,
                       '-'       AS code_plast_is_equal,
                       NULL      AS check_gor_obr_prnt_wmw_prnt,
                       '-'       AS ois_code_is_equal,
                       '-'       AS not_duplicate,
                       '-'       AS data_in_adr,
                       '-'       AS data_in_fnd,
                       '-'       AS pl_in_wmw_spr,
                       '-'       AS pl_in_wmw_havent_parent
                FROM   dp_sprobj obj
                       left join dp_sprpl sprpl
                              ON obj.plast = sprpl.plast
                                 AND sprpl.mest IN ( mest_code )
                WHERE  sprpl.plast IS NULL
                       AND obj.objname = objname_par
                ORDER  BY comment_sprpl,
                          plast_sprl,
                          plast_obj,
                          comment_is_equal,
                          code_plast_is_equal,
                          not_duplicate,
                          data_in_fnd,
                          data_in_adr DESC) LOOP
        dbms_output.Put_line('mest='
                             || rec.mest
                             || ', plast_sprl='
                             || rec.plast_sprl
                             || ', gor_sprl='
                             || rec.gor_sprl
                             || ', comment_sprpl='
                             || rec.comment_sprpl
                             || ', plast_sortplast='
                             || rec.plast_sortplast
                             || ', comment_sortplast='
                             || rec.comment_sortplast
                             || ', hor_sortplast='
                             || rec.hor_sortplast
                             || ', plast_obj='
                             || rec.plast_obj
                             || ', stratid_sprobr='
                             || rec.stratid_sprobr
                             || ', pl1_obr='
                             || rec.pl1_obr
                             || ', cd1_class='
                             || rec.cd1_class
                             || ', ne1_class='
                             || rec.ne1_class
                             || ', comment_is_equal='
                             || rec.comment_is_equal
                             || ', code_plast_is_equal='
                             || rec.code_plast_is_equal
                             || ', check_gor_obr_prnt_wmw_prnt='
                             || rec.check_gor_obr_prnt_wmw_prnt
                             || ', ois_code_is_equal='
                             || rec.ois_code_is_equal
                             || ', not_duplicate='
                             || rec.not_duplicate
                             || ', data_in_adr='
                             || rec.data_in_adr
                             || ', data_in_fnd='
                             || rec.data_in_fnd
                             || ', pl_in_wmw_spr='
                             || rec.pl_in_wmw_spr
                             || ', pl_in_wmw_havent_parent='
                             || rec.pl_in_wmw_havent_parent);
    END LOOP;
END; 
/

