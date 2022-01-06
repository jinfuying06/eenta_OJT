-- 테이프별 최근 대여일자
SELECT
    A.TAPE_CD
,   MAX(A.RENT_DATE)
FROM VSM_RENT_RECORD A
GROUP BY A.TAPE_CD;

-- 영화별 최근 대여일자(영화별 마지막으로 대여된 일자) 가져오기
SELECT
      B.MOVIE_CD
, MAX(A.RENT_DATE)
FROM VSM_RENT_RECORD A

LEFT OUTER JOIN VSM_TAPE_INFO B
ON B.TAPE_CD = A.TAPE_CD

GROUP BY B.MOVIE_CD;

--------------------------------------------------------------------------------
-- VSM_RENT_RECORD 전체 표시, TAPE_CD, MOVIE_CD, RENT_DATE, 대여순번(ROWNUM 사용)
-- ROWNUM은 ORDER BY의 영향을 받지 않고, 물리적인 ROW의 순서를 표시한다.
-- ROW_NUMBER() OVER(여기에 기존 ORDER BY를 넣으면 영향을 받는다)
SELECT
     A.TAPE_CD
,    A.RENT_DATE
,    B.MOVIE_CD
,    ROWNUM
,    ROW_NUMBER() OVER (ORDER BY A.RENT_DATE DESC)
FROM VSM_RENT_RECORD A

LEFT OUTER JOIN VSM_TAPE_INFO B
ON B.TAPE_CD = A.TAPE_CD

ORDER BY A.RENT_DATE DESC

--------------------------------------------------------------------------------
-- 쿼리를 짜기 전에 데이터가 어떻게 나올지를 머리 속에 떠올려보고 쿼리를 짠다.
-- TAPE_CD 별로 순서를 매길 때
-- ROW_NUMBER() OVER (PATIRION BY ~별로 해당하는 컬럼명)
-- ROW_NUMBER() OVER (PARTITION BY A.TAPE_CD ORDER BY A.RENT_DATE DESC)
-- -> TAPE_CD별로 번호를 매기고 RENT_DATE를 역순으로 정렬한다.
SELECT
     A.TAPE_CD
,    A.RENT_DATE
,    B.MOVIE_CD
,    ROW_NUMBER() OVER (PARTITION BY A.TAPE_CD ORDER BY A.RENT_DATE DESC)
FROM VSM_RENT_RECORD A

LEFT OUTER JOIN VSM_TAPE_INFO B
ON B.TAPE_CD = A.TAPE_CD

ORDER BY A.TAPE_CD, A.RENT_DATE DESC

-------------------------------------------------------------------------------
-- 영화별로 번호 매기기
SELECT
     A.TAPE_CD
,    A.RENT_DATE
,    B.MOVIE_CD
,    ROW_NUMBER() OVER (PARTITION BY A.MOVIE_CD ORDER BY A.RENT_DATE DESC)
FROM VSM_RENT_RECORD A

LEFT OUTER JOIN VSM_TAPE_INFO B
ON B.TAPE_CD = A.TAPE_CD

-- ORDER BY B.MOVIE_CD DESC

-------------------------------------------------------------------------------
-- 아래의 데이터 중 RM이 1인 것만 끄집어내기
-- ALIAS 명은 WHERE절에 사용할 수 없다.
SELECT *
FROM (
         SELECT A.TAPE_CD
              , A.RENT_DATE
              , B.MOVIE_CD
              , ROW_NUMBER() OVER (PARTITION BY A.MOVIE_CD ORDER BY A.RENT_DATE DESC) RN
         FROM VSM_RENT_RECORD A

         LEFT OUTER JOIN VSM_TAPE_INFO B
         ON B.TAPE_CD = A.TAPE_CD
     )
WHERE RN = 1

-------------------------------------------------------------------------------
select * from vsm_rent_record
-- DBMS의 트랜잰션 관리
    -- 1.insert into ~ values~
INSERT INTO SEMAP.VSM_RENT_RECORD (RENT_DATE, TAPE_CD, CUSTOM_CD, RETURN_DUE_DATE, RETURN_DATE, RENT_ID, RETURN_ID, CRE_ID, UPT_ID, CRE_DT, UPT_DT, CO_RETURN_CHECK, MOVIE_CD)
VALUES (TO_DATE('2021-12-01', 'YYYY-MM-DD HH24:MI:SS'), 'tape000005', 'custom0001', TO_DATE('2021-12-08', 'YYYY-MM-DD HH24:MI:SS'), TO_DATE('2021-12-03', 'YYYY-MM-DD HH24:MI:SS'), 'MGR0000001', 'MGR0000001', 'MGR0000001', 'MGR0000001', TO_DATE('2021-12-01', 'YYYY-MM-DD HH24:MI:SS'), TO_DATE('2021-12-04', 'YYYY-MM-DD HH24:MI:SS'), '06000', 'movie00002');

    -- 2. insert into ~ select ~ from dual
INSERT INTO SEMAP.VSM_MOVIE_INFO (MOVIE_CD, MOVIE_NM, CO_MOVIE_CATE_CD, ACT_CD, CO_MOVIE_TYPE_CD, CRE_ID, UPT_ID, CRE_DT, UPT_DT)
SELECT 'movie00007', '알라딘', '01004', null, '00001', 'MGR0000001', 'MGR0000001', SYSDATE, SYSDATE
FROM DUAL;

    -- Update(데이터 내용 수정)
UPDATE VSM_MOVIE_INFO
SET MOVIE_NM = '스파이더맨:노웨이홈'
WHERE MOVIE_CD = MOVIE00005

    -- Delete(컬럼 내 데이터 삭제)
DELETE FROM VSM_MOVIE_INFO
WHERE MOVIE_CD = 'MOVIE00008'

-------------------------------------------------------------------------------
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
        FROM DUAL -- 서브쿼리 (입력을 받아오고싶으면 파라미터라이징<:쿼리명> 을 해주면 된다.) USING안에 입력하는 컬럼명에는 ALIAS를 줄 것.
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
