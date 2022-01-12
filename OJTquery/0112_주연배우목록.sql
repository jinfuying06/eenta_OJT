MERGE INTO VSM_ACT_INFO T -- merge를 할 대상 테이블
USING (
        SELECT
               :ACT_CD ACT_CD
             , :ACT_NM ACT_NM
             ,	TO_DATE(:ACT_BIRTH, 'YYYY-MM-DD') ACT_BIRTH
             , :CRE_ID CRE_ID
             , 'MGR0000000' UPT_ID
             , SYSDATE CRE_DT
             , SYSDATE UPT_DT
        FROM DUAL
        ) S
ON (
       S.ACT_CD = T.ACT_CD
    )
WHEN MATCHED THEN
    UPDATE
       SET
              T.ACT_NM           = S.ACT_NM
            , T.ACT_BIRTH        = S.ACT_BIRTH
            , T.UPT_ID           = S.UPT_ID
            , T.UPT_DT           = S.UPT_DT
WHEN NOT MATCHED THEN
    INSERT (  T.ACT_CD
            , T.ACT_NM
            , T.ACT_BIRTH
            , T.CRE_ID
            , T.UPT_ID
            , T.CRE_DT
            , T.UPT_DT )
    VALUES (  S.ACT_CD
            , S.ACT_NM
            , S.ACT_BIRTH
            , S.CRE_ID
            , S.UPT_ID
            , S.CRE_DT
            , S.UPT_DT )


select * from VSM_ACT_INFO

-- seq.act 에서 act_cd 채번
SELECT 'actor' || TRIM(TO_CHAR(SEQ_ACT.NEXTVAL, '00000')) ACT_CD FROM DUAL