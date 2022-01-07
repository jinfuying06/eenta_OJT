-- 제목: 대여목록조회
-- 작성자: 김보영
-- 작성일: 2022-01-06
-- 대여일시 테이프번호 영화제목 고객명 전화번호 반납예정일 반납여부 대여처리자

WITH TMP_KWD_LIST AS (
                    SELECT TRIM(REGEXP_SUBSTR(:MOVIE_NM, '[^,]+', 1, LEVEL)) AS KEYWORD
                    FROM DUAL
                    CONNECT BY TRIM(REGEXP_SUBSTR(:MOVIE_NM, '[^,]+', 1, LEVEL)) IS NOT NULL
                 )
SELECT      A.RENT_DATE
        ,   A.TAPE_CD
        ,   A.MOVIE_CD
        ,   B.MOVIE_NM
        ,   A.CUSTOM_CD
        ,   C.CUSTOM_NM
        ,   C.CUSTOM_TEL
        ,   A.RETURN_DUE_DATE
        ,   CASE WHEN A.RETURN_DATE IS NOT NULL
                THEN '반납'
                 WHEN A.RENT_DATE IS NOT NULL AND A.RETURN_DATE IS NULL
                 THEN '미납'
                 END RETURN_CHECKING
        ,   A.RENT_ID
FROM VSM_RENT_RECORD A

LEFT OUTER JOIN VSM_MOVIE_INFO  B
ON B.MOVIE_CD = A.MOVIE_CD

LEFT OUTER JOIN VSM_CUSTOM_INFO C
ON C.CUSTOM_CD = A.CUSTOM_CD

					WHERE 1=1
 					#if ( $STDATE && $STDATE != "")
                        AND A.RENT_DATE >= TO_DATE(:STDATE ,'YYYY-MM-DD')
                    #end

                    #if ( $LADATE && $LADATE != "")
                        AND A.RENT_DATE <= TO_DATE(:LADATE ,'YYYY-MM-DD')
                    #end
AND EXISTS(SELECT * FROM TMP_KWD_LIST D WHERE B.MOVIE_NM LIKE '%' || D.KEYWORD || '%')