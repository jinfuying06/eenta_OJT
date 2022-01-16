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
						,	 T_MOVIE_GRP2 AS (   SELECT E.MOVIE_CD
						                            ,   COUNT(F.TAPE_CD) RENT_CNT
						                    FROM VSM_RENT_RECORD F

						                    LEFT OUTER JOIN VSM_TAPE_INFO E
						                    ON E.TAPE_CD = F.TAPE_CD
						                    GROUP BY E.MOVIE_CD
						                )
						,		KWD_LIST AS (
						                    SELECT TRIM(REGEXP_SUBSTR(:MOVIE_NM, '[^,]+', 1, LEVEL)) AS KEYWORD
						                    FROM DUAL
						                    CONNECT BY TRIM(REGEXP_SUBSTR(:MOVIE_NM, '[^,]+', 1, LEVEL)) IS NOT NULL
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
									        ,   NVL(D.TAPE_CNT, 0) TAPE_CNT
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

									WHERE NVL(B.ACT_NM, ' ') LIKE '%' || :ACT_NM || '%'
									AND EXISTS(
									            SELECT *
									            FROM KWD_LIST H
									            WHERE A.MOVIE_NM LIKE '%' || H.KEYWORD || '%'
									           )
									 ORDER BY A.MOVIE_CD

					-- 제목: 영화장르
					-- 작성자: 김보영
					-- 작성일: 2021-01-10

					SELECT CO_CD MV_CATE_CD
					,      CO_CD_NM MV_CATE_NM
					FROM VSM_CO_CD WHERE GRP_CD = '01'
					ORDER BY CO_CD

					-- 제목: 영화구분
					-- 작성자: 김보영
					-- 작성일: 2021-01-10

					SELECT CO_CD MV_TYPE_CD
					,      CO_CD_NM MV_TYPE_NM
					FROM VSM_CO_CD WHERE GRP_CD = '00'
					ORDER BY CO_CD

					-- 영화정보목록에서 수정하기

					MERGE INTO VSM_MOVIE_INFO T -- merge를 할 대상 테이블
					USING (
					        SELECT
					               :MOVIE_CD MOVIE_CD
					             , :MOVIE_NM MOVIE_NM
					             , :CO_MOVIE_CATE_CD CO_MOVIE_CATE_CD
					             , :CO_MOVIE_TYPE_CD CO_MOVIE_TYPE_CD
					             , :ACT_CD ACT_CD
					             , :G_EMPL_NO CRE_ID
					             , :G_EMPL_NO UPT_ID
					             , SYSDATE CRE_DT
					             , SYSDATE UPT_DT
					        FROM DUAL
					        ) S
					ON (
					       S.MOVIE_CD = T.MOVIE_CD
					    )
					WHEN MATCHED THEN
					    UPDATE
					       SET
					              T.MOVIE_NM         = S.MOVIE_NM
					            , T.CO_MOVIE_CATE_CD = S.CO_MOVIE_CATE_CD
					       		, T.CO_MOVIE_TYPE_CD = S.CO_MOVIE_TYPE_CD
					            , T.ACT_CD           = S.ACT_CD
					            , T.UPT_ID           = S.UPT_ID
					            , T.UPT_DT           = S.UPT_DT
					WHEN NOT MATCHED THEN
					    INSERT (  T.MOVIE_CD
					            , T.MOVIE_NM
					            , T.CO_MOVIE_CATE_CD
					            , T.CO_MOVIE_TYPE_CD
					            , T.ACT_CD
					            , T.CRE_ID
					            , T.UPT_ID
					            , T.CRE_DT
					            , T.UPT_DT )
					    VALUES (  S.MOVIE_CD
					            , S.MOVIE_NM
					            , S.CO_MOVIE_CATE_CD
					            , S.CO_MOVIE_TYPE_CD
					            , S.ACT_CD
					            , S.CRE_ID
					            , S.UPT_ID
					            , S.CRE_DT
					            , S.UPT_DT )

					-- 영화정보목록에서 삭제하기
					DELETE FROM VSM_MOVIE_INFO A
					WHERE A.MOVIE_CD = :MOVIE_CD
					AND NOT EXISTS(SELECT * FROM VSM_TAPE_INFO B WHERE B.MOVIE_CD = A.MOVIE_CD)

					-- 영화코드 채번
					SELECT 'movie' || TRIM(TO_CHAR(SEQ_MOVIE.NEXTVAL, '00000')) MOVIE_CD FROM DUAL