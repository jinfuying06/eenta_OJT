-- 제목: 영화목록조회
-- 작성자: 김보영
-- 작성일: 2021-12-21
-- 영화코드, 영화명, 영화장르, 영화구분, 주연배우, 등록자, 테이프 개수, 대여기록횟수
-- NVL(값, 널인경우 표시값)

WITH T_MOVIE_GRP AS (   SELECT      MOVIE_CD
                            ,   COUNT(TAPE_CD) TAPE_CNT 
                    FROM VSM_TAPE_INFO
                    GROUP BY MOVIE_CD
                )
,
    T_MOVIE_GRP2 AS (   SELECT E.MOVIE_CD
                            ,   COUNT(F.TAPE_CD) RENT_CNT
                    FROM VSM_RENT_RECORD F

                    LEFT OUTER JOIN VSM_TAPE_INFO E
                    ON E.TAPE_CD = F.TAPE_CD
                    GROUP BY E.MOVIE_CD 
                )    

SELECT      A.MOVIE_CD
        ,   A.MOVIE_NM
        ,   A.CO_MOVIE_CATE_CD
        ,   CO1.CO_CD_NM CO_MOVIE_CATE_NM
        ,   A.CO_MOVIE_TYPE_CD
        ,   CO2.CO_CD_NM CO_MOVIE_TYPE_NM
        ,   A.ACT_CD
        ,   B.ACT_NM 
        ,   A.CRE_ID
        ,   C.MANAGE_NM
        ,   D.TAPE_CNT TAPE_CNT 
        ,   NVL(G.RENT_CNT, 0) RENT_CNT
FROM VSM_MOVIE_INFO A

LEFT OUTER JOIN VSM_CO_CD CO1
ON CO1.CO_CD = A.CO_MOVIE_CATE_CD

LEFT OUTER JOIN VSM_CO_CD CO2
ON CO2.CO_CD = A.CO_MOVIE_TYPE_CD

LEFT OUTER JOIN VSM_ACT_INFO B
ON B.ACT_CD = A.ACT_CD

LEFT OUTER JOIN VSM_MANAGER C
ON C.MANAGE_CD = A.CRE_ID

LEFT OUTER JOIN  T_MOVIE_GRP D
ON D.MOVIE_CD = A.MOVIE_CD

LEFT OUTER JOIN T_MOVIE_GRP2 G
ON G.MOVIE_CD = A.MOVIE_CD

WHERE A.MOVIE_NM LIKE '%' || :MOVIE_NM || '%' AND B.ACT_NM LIKE '%' || :ACT_NM || '%'

------------------------------------------
SELECT      MOVIE_CD
        ,   COUNT(TAPE_CD) TAPE_CNT 
FROM VSM_TAPE_INFO
GROUP BY MOVIE_CD

--영화별로 생성한 사람이 몇명인지
SELECT      MOVIE_CD
        ,   COUNT(DISTINCT CRE_ID) CRE_ID_CNT
FROM VSM_TAPE_INFO
GROUP BY MOVIE_CD

-- 두 개이상의 값 중에 널이 아닌 첫번째 값을 표현해줌
SELECT COALESCE(NULL, NULL, 'A', 'B'), COALESCE(NULL, 'A', NULL), COALESCE(NULL, 'B', 'A'), COALESCE('C', 'B', 'A') FROM DUAL;