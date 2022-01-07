-- 0106 오후 OJT
-- 영화이름 검색 두번쨰 방식(조인을 사용한 방법)
WITH KWD_LIST AS (
                    SELECT TRIM(REGEXP_SUBSTR(:KEYWORD, '[^,]+', 1, LEVEL)) AS KEYWORD
                    FROM DUAL
                    CONNECT BY TRIM(REGEXP_SUBSTR(:KEYWORD, '[^,]+', 1, LEVEL)) IS NOT NULL
                 )

,   TMP_MATCH_LIST AS (
                        SELECT DISTINCT A.MOVIE_CD
                        FROM VSM_MOVIE_INFO A

                        LEFT OUTER JOIN KWD_LIST B
                        ON A.MOVIE_NM LIKE '%' || B.KEYWORD || '%'

                        WHERE B.KEYWORD IS NOT NULL
                        )
SELECT * FROM VSM_MOVIE_INFO A
INNER JOIN TMP_MATCH_LIST B
ON B.MOVIE_CD = A.MOVIE_CD

---------------------------------------------------------------------------
WITH TMP_KWD_LIST AS (
                    SELECT TRIM(REGEXP_SUBSTR(:KEYWORD, '[^,]+', 1, LEVEL)) AS KEYWORD
                    FROM DUAL
                    CONNECT BY TRIM(REGEXP_SUBSTR(:KEYWORD, '[^,]+', 1, LEVEL)) IS NOT NULL
                 )
, KWD_LIST AS(
                SELECT * FROM TMP_KWD_LIST
                WHERE KEYWORD IS NOT NULL
            )
-- SELECT * FROM KWD_LIST
,   TMP_MATCH_LIST AS (
                        SELECT DISTINCT A.MOVIE_CD
                        FROM VSM_MOVIE_INFO A

                        INNER JOIN KWD_LIST B
                        ON A.MOVIE_NM
                            LIKE '%' || B.KEYWORD || '%'
                        )
SELECT * FROM VSM_MOVIE_INFO A
INNER JOIN TMP_MATCH_LIST B
ON B.MOVIE_CD = A.MOVIE_CD

-----------------------------------------------------------------------------------
WITH TMP_KWD_LIST AS (

                    SELECT TRIM(REGEXP_SUBSTR(:KEYWORD, '[^,]+', 1, LEVEL)) AS KEYWORD
                    FROM DUAL
                    CONNECT BY TRIM(REGEXP_SUBSTR(:KEYWORD, '[^,]+', 1, LEVEL)) IS NOT NULL
                 )
, KWD_LIST AS(
                SELECT * FROM TMP_KWD_LIST
                WHERE KEYWORD IS NOT NULL
            )
-- SELECT * FROM KWD_LIST
,   TMP_MATCH_LIST AS (
                        SELECT DISTINCT A.MOVIE_CD
                        FROM VSM_MOVIE_INFO A

                        LEFT OUTER JOIN KWD_LIST B
                        ON A.MOVIE_NM
                            LIKE '%' || B.KEYWORD || '%'
                            WHERE NOT EXISTS ( SELECT * FROM KWD_LIST )
                                    OR (EXISTS(SELECT * FROM KWD_LIST)
                                    AND B.KEYWORD IS NOT NULL)
                        )
SELECT * FROM VSM_MOVIE_INFO A
INNER JOIN TMP_MATCH_LIST B
ON B.MOVIE_CD = A.MOVIE_CD