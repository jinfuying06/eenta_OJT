-- 영화정보목록에서 수정하기

MERGE INTO VSM_MOVIE_INFO T -- merge를 할 대상 테이블
USING (
        SELECT
               :MOVIE_CD MOVIE_CD
             , :MOVIE_NM MOVIE_NM
             , :CO_MOVIE_CATE_CD CO_MOVIE_CATE_CD
             , :CO_MOVIE_TYPE_CD CO_MOVIE_TYPE_CD
             , :ACT_CD ACT_CD
             , :CRE_ID CRE_ID
             , 'MGR0000001' UPT_ID
             , SYSDATE CRE_DT
             , SYSDATE UPT_DT

        FROM DUAL
        ) S
ON (
       S.MOVIE_CD = T.MOVIE_CD
    )
WHEN MATCHED THEN
    UPDATE
       SET
              T.MOVIE_NM         = S.MOVIE_NM
            , T.CO_MOVIE_CATE_CD = S.CO_MOVIE_CATE_CD
       		, T.CO_MOVIE_TYPE_CD = S.CO_MOVIE_TYPE_CD
            , T.ACT_CD           = S.ACT_CD
            , T.UPT_ID           = S.UPT_ID
            , T.UPT_DT           = S.UPT_DT