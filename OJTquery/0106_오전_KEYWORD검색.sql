SELECT '스파' KEYWORD FROM DUAL
UNION ALL
SELECT '인터' KEYWORD FROM DUAL
UNION ALL
SELECT '이언' KEYWORD FROM DUAL

-- 컴마(,)로 나눠진 단어를 하나의 테이블에 넣을 수 있는 기능

SELECT TRIM(REGEXP_SUBSTR('스파,인터,이언','[^,]+', 1, LEVEL)) AS
FROM DUAL KEYWORD
CONNECT BY TRIM(REGEXP_SUBSTR('스파,인터,이언','[^,]+', 1, LEVEL)) IS NOT NULL

-- LIKE '%파이%' -> 파이가 앞이든 뒤든 어디에 있어도 찾는 거
-- 파이% 파이~로 되는. %파이 ~파이 로 되는

----------------------------------------------------------------------------------------
-- 영화목록조회에서 영화명으로 여러개 검색하고 싶을 때
WITH KWD_LIST AS (
                    SELECT TRIM(REGEXP_SUBSTR(:KEYWORD, '[^,]+', 1, LEVEL)) AS KEYWORD
                    FROM DUAL
                    CONNECT BY TRIM(REGEXP_SUBSTR(:KEYWORD, '[^,]+', 1, LEVEL)) IS NOT NULL
                 )
-- SELECT * FROM KWD_LIST

SELECT *
FROM VSM_MOVIE_INFO A

WHERE EXISTS(
                SELECT *
                FROM KWD_LIST B
                WHERE A.MOVIE_NM LIKE '%' || B.KEYWORD || '%'
           )

----------------------------------------------------------------------------------

-- 영화목록조회에서 주연배우명으로 영화를 검색할 때
WITH KWD_LIST AS (
    SELECT TRIM(REGEXP_SUBSTR(:KEYWORD, '[^,]+', 1, LEVEL)) AS KEYWORD
    FROM DUAL
    CONNECT BY TRIM(REGEXP_SUBSTR(:KEYWORD, '[^,]+', 1, LEVEL)) IS NOT NULL
                )

SELECT  A.MOVIE_CD
,       A.MOVIE_NM
,       A.ACT_CD
,       B.ACT_NM
FROM VSM_MOVIE_INFO A

LEFT OUTER JOIN VSM_ACT_INFO B
ON B.ACT_CD = A.ACT_CD

WHERE EXISTS(SELECT * FROM KWD_LIST C WHERE B.ACT_NM LIKE '%' || C.KEYWORD || '%')