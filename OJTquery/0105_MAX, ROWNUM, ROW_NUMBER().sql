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
