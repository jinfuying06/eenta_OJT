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
					
					SELECT  A.TAPE_CD
					,       A.MOVIE_CD
					,       B.MOVIE_NM
					,       B.ACT_CD
					,       C.ACT_NM
					,       A.CO_TAPE_TYPE_CD
					,       D.CO_CD_NM CO_TAPE_TYPE_NM
					,       CASE
					        WHEN E.RENT_DATE IS NOT NULL AND E.RETURN_DATE IS NULL
					        THEN 'X'
					        ELSE 'O'
					        END RENT_ABILITY
					FROM VSM_TAPE_INFO A
					
					LEFT OUTER JOIN VSM_MOVIE_INFO B
					ON B.MOVIE_CD = A.MOVIE_CD
					
					LEFT OUTER JOIN VSM_ACT_INFO C
					ON C.ACT_CD = B.ACT_CD
					
					LEFT OUTER JOIN VSM_CO_CD D
					ON D.CO_CD = A.CO_TAPE_TYPE_CD
					
					LEFT OUTER JOIN T_RENT_GRP E
					ON E.TAPE_CD = A.TAPE_CD
					
					WHERE NVL(A.TAPE_CD, ' ') LIKE '%' || :TAPE_CD || '%'
					AND EXISTS(
								SELECT * FROM T_MOVIE_LIST F
					            WHERE B.MOVIE_NM LIKE '%' || F.KEYWORD || '%'
					            )
					ORDER BY A.TAPE_CD

					-- 제목: 테이프 종류
					-- 작성자: 김보영
					-- 작성일: 2021-01-10

					SELECT CO_CD TAPE_TYPE_CD
					,      CO_CD_NM TAPE_TYPE_NM
					FROM VSM_CO_CD WHERE GRP_CD = '02'
					ORDER BY CO_CD

					-- 테이프목록에서 수정하기
						MERGE INTO VSM_TAPE_INFO T
						USING (
						        SELECT
						               :TAPE_CD TAPE_CD
						             , :MOVIE_CD MOVIE_CD
	                                 , :CO_TAPE_TYPE_CD CO_TAPE_TYPE_CD
						             , :G_EMPL_NO CRE_ID
						             , :G_EMPL_NO UPT_ID
						             , SYSDATE CRE_DT
						             , SYSDATE UPT_DT
						        FROM DUAL
						        ) S
						ON (
						       S.TAPE_CD = T.TAPE_CD
						    )
						WHEN MATCHED THEN
						    UPDATE
						       SET
						        	  T.MOVIE_CD           = S.MOVIE_CD
						            , T.CO_TAPE_TYPE_CD  = S.CO_TAPE_TYPE_CD
						            , T.UPT_ID           = S.UPT_ID
						            , T.UPT_DT           = S.UPT_DT
						WHEN NOT MATCHED THEN
						    INSERT (  T.TAPE_CD
						            , T.MOVIE_CD
						            , T.CO_TAPE_TYPE_CD
						            , T.CRE_ID
						            , T.UPT_ID
						            , T.CRE_DT
						            , T.UPT_DT )
						    VALUES (  S.TAPE_CD
						            , S.MOVIE_CD
						            , S.CO_TAPE_TYPE_CD
						            , S.CRE_ID
						            , S.UPT_ID
						            , S.CRE_DT
						            , S.UPT_DT )

					-- 테이프코드 채번
						SELECT 'tape' || TRIM(TO_CHAR(SEQ_TAPE.NEXTVAL, '000000')) TAPE_CD FROM DUAL

					--  테이프 정보 삭제
                    DELETE FROM VSM_TAPE_INFO A
					WHERE A.TAPE_CD = :TAPE_CD
					AND NOT EXISTS(SELECT * FROM VSM_RENT_RECORD B WHERE B.TAPE_CD = :TAPE_CD)