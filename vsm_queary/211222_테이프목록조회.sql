-- 제목: 테이프목록조회
-- 작성자: 김보영
-- 작성일: 2021-12-22
-- 테이프번호, 영화코드, 영화제목, 주연배우, 테이프방식, 대여가능여부, 등록자
-- 대여가능여부 만들기(마지막 대여 기록 가져와야함)

WITH T_RENT_GRP AS 
    ( SELECT * FROM (SELECT TAPE_CD, RENT_DATE, RETURN_DATE, ROW_NUMBER() OVER
    ( PARTITION BY TAPE_CD
      ORDER BY RENT_DATE DESC 
    )RENT_AB
      FROM VSM_RENT_RECORD)
      WHERE RENT_AB = 1  
    ) 
SELECT      A.TAPE_CD
        ,   A.MOVIE_CD
        ,   B.MOVIE_NM 
        ,   A.ACT_CD
        ,   C.ACT_NM
        ,   A.CO_TAPE_TYPE_CD 
        ,   CO1.CO_CD_NM CO_TAPE_TYPE_NM
        ,   E.RENT_DATE
        ,   E.RETURN_DATE
        ,   CASE 
         WHEN E.RENT_DATE IS NOT NULL AND E.RETURN_DATE IS NULL
         THEN '대여불가'
         ELSE '대여가능'
         END RENT_ABILITY
        ,   A.CRE_ID
        ,   D.MANAGE_NM
FROM VSM_TAPE_INFO A

LEFT OUTER JOIN VSM_MOVIE_INFO B
ON B.MOVIE_CD = A.MOVIE_CD

LEFT OUTER JOIN VSM_ACT_INFO C
ON C.ACT_CD = A.ACT_CD

LEFT OUTER JOIN VSM_CO_CD CO1
ON CO1.CO_CD = A.CO_TAPE_TYPE_CD

LEFT OUTER JOIN VSM_MANAGER D
ON D.MANAGE_CD = A.CRE_ID

LEFT OUTER JOIN T_RENT_GRP E
ON E.TAPE_CD = A.TAPE_CD

ORDER BY A.TAPE_CD ASC