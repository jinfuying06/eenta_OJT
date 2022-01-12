-- 제목: 대여목록조회
-- 작성자: 김보영
-- 작성일: 2021-12-22
-- 대여일시 테이프번호 영화제목 고객명 전화번호 반납예정일 반납여부 대여처리자

SELECT      A.RENT_DATE
        ,   A.TAPE_CD
        ,   A.MOVIE_CD
        ,   B.MOVIE_NM 
        ,   A.CUSTOM_CD
        ,   C.CUSTOM_NM
        ,   C.CUSTOM_TEL
        ,   A.RETURN_DUE_DATE
        ,   A.CO_RETURN_CHECK
        ,   D.CO_CD_NM RETURN_CHECK
        ,   CASE WHEN A.RETURN_DATE IS NOT NULL
                 THEN '반납'
                 WHEN A.RENT_DATE IS NOT NULL AND A.RETURN_DATE IS NULL
                 THEN '미납'
                 END RETURN_CHECKING
        ,   A.CRE_ID
FROM VSM_RENT_RECORD A

LEFT OUTER JOIN VSM_MOVIE_INFO  B
ON B.MOVIE_CD = A.MOVIE_CD 

LEFT OUTER JOIN VSM_CUSTOM_INFO C
ON C.CUSTOM_CD = A.CUSTOM_CD

LEFT OUTER JOIN VSM_CO_CD D
ON D.CO_CD = A.CO_RETURN_CHECK

UPDATE VSM_CUSTOM_INFO SET CUSTOM_TEL = '010-8888-7777' WHERE CUSTOM_NM = '한효주'