					-- 테이프목록조회
					WITH T_MOVIE_LIST AS (
					                       SELECT TRIM(REGEXP_SUBSTR(:MOVIE_NM, '[^,]+', 1, LEVEL)) AS KEYWORD
					                       FROM DUAL
					                       CONNECT BY TRIM(REGEXP_SUBSTR(:MOVIE_NM, '[^,]+', 1, LEVEL)) IS NOT NULL
					                      )

					,    T_RENT_GRP AS
					    ( SELECT * FROM
					       (SELECT TAPE_CD, RENT_DATE, RETURN_DATE,
					                ROW_NUMBER() OVER(
					                    PARTITION BY TAPE_CD
					                    ORDER BY RENT_DATE DESC
					                    ) RENT_AB
					        FROM VSM_RENT_RECORD
					        )
					    WHERE RENT_AB = 1
					    )
					,   T_MOVIE_GRP AS (
					    SELECT A1.MOVIE_CD
					        , A1.MOVIE_NM
					        , A1.ACT_CD
					        , A3.ACT_NM
					        , A1.CO_MOVIE_TYPE_CD
					        , A2.CO_CD_NM
					    FROM VSM_MOVIE_INFO A1

					    LEFT OUTER JOIN VSM_ACT_INFO A3
					    ON A3.ACT_CD = A1.ACT_CD
					    LEFT OUTER JOIN VSM_CO_CD A2
					    ON A2.CO_CD = A1.CO_MOVIE_TYPE_CD
                    )

					SELECT  A.TAPE_CD
					,       F.MOVIE_CD
					,       F.MOVIE_NM
					,       F.CO_MOVIE_TYPE_CD
					,       F.CO_CD_NM CO_MOVIE_TYPE_NM
					,       F.ACT_CD
					,       F.ACT_NM
					,       A.CO_TAPE_TYPE_CD
					,       CO1.CO_CD_NM CO_TAPE_TYPE_NM
					,       CASE
					        WHEN E.RENT_DATE IS NOT NULL AND E.RETURN_DATE IS NULL
					        THEN 'X'
					        ELSE 'O'
					        END RENT_ABILITY
					FROM VSM_TAPE_INFO A

					LEFT OUTER JOIN VSM_MOVIE_INFO B
					ON B.MOVIE_CD = A.MOVIE_CD

					LEFT OUTER JOIN VSM_CO_CD CO1
					ON CO1.CO_CD = A.CO_TAPE_TYPE_CD

					LEFT OUTER JOIN T_RENT_GRP E
					ON E.TAPE_CD = A.TAPE_CD

					LEFT OUTER JOIN T_MOVIE_GRP F
					ON F.MOVIE_CD = B.MOVIE_CD

					WHERE NVL(A.TAPE_CD, ' ') LIKE '%' || :TAPE_CD || '%'
					AND EXISTS(
								SELECT * FROM T_MOVIE_LIST F
					            WHERE B.MOVIE_NM LIKE '%' || F.KEYWORD || '%'
					            )
					ORDER BY A.TAPE_CD