-- MERGE INTO 대상테이블 ALIAS명 USING ( 서브쿼리 ) ON ( S와 T의 일치조건 ) ; USING 안에서 반환하는 데이터를 대상 테이블에 INSERT 하거나 UPDATE한다.
-- 'INSERT 혹은 UPDATE 한다'의 의미 :  서브쿼리에 관한 데이터가 대상테이블에 들어 있으면 수정하고(UPDATE) 없으면 채운다(INSERT). -> 이걸 판단해주는 것이 ON절
-- , . : ; & || / \ @
-- T : TARGET TABLE , S : SOURCE
-- WHEN MATCHED THEN : UPDATE 문 작성
-- WHEN NOT MATCHED THEN : INSERT문 작성
-- CRE_ID, CRE_DT는 INSERT할 때만 사용한다. (UPDATE에는 사용하지 않는다)
MERGE INTO VSM_MOVIE_INFO T -- merge를 할 대상 테이블
USING (
        SELECT :MOVIE_CD MOVIE_CD
             , :MOVIE_NM MOVIE_NM
             , :CO_MOVIE_CATE_CD CO_MOVIE_CATE_CD
             , null ACT_CD
             , '00001' CO_MOVIE_TYPE_CD
             , 'MGR0000001' CRE_ID
             , 'MGR0000001' UPT_ID
             , SYSDATE CRE_DT
             , SYSDATE UPT_DT
        FROM DUAL -- 서브쿼리 (입력을 받아오고싶으면 파라미터라이징<:쿼리명> 을 해주면 된다.), USING안에 입력하는 컬럼명에는 ALIAS를 줄 것.
        ) S
ON (
       S.MOVIE_CD = T.MOVIE_CD
    )

WHEN NOT MATCHED THEN
    INSERT (MOVIE_CD
            , MOVIE_NM
            , CO_MOVIE_CATE_CD
            , ACT_CD
            , CO_MOVIE_TYPE_CD
            , CRE_ID
            , UPT_ID
            , CRE_DT
            , UPT_DT)
    VALUES (S.MOVIE_CD
            , S.MOVIE_NM
            , S.CO_MOVIE_CATE_CD
            , S.ACT_CD
            , S.CO_MOVIE_TYPE_CD
            , S.CRE_ID
            , S.UPT_ID
            , S.CRE_DT
            , S.UPT_DT)

WHEN MATCHED THEN
    UPDATE
       SET    T.CO_MOVIE_TYPE_CD = S.CO_MOVIE_TYPE_CD
            , T.CO_MOVIE_CATE_CD = S.CO_MOVIE_CATE_CD
            , T.ACT_CD           = S.ACT_CD
            , T.MOVIE_NM         = S.MOVIE_NM
            , T.UPT_ID           = S.UPT_ID
            , T.UPT_DT           = S.UPT_DT

-------------------------------------------------------------------------------
-- 이렇게 해야할 것을 하드코딩이 아닌 입력을 받아 판단하여 간편하게 넣을 수 있도록 한게 merge문이다.
INSERT INTO VSM_MOVIE_INFO(MOVIE_CD, MOVIE_NM, CO_MOVIE_CATE_CD, ACT_CD, CO_MOVIE_TYPE_CD, CRE_ID, UPT_ID, CRE_DT, UPT_DT)
SELECT :MOVIE_CD, :MOVIE_NM, '01004', null, '00001', 'MGR0000001', 'MGR0000001', SYSDATE, SYSDATE
FROM DUAL

SELECT * FROM SYST_MNU
