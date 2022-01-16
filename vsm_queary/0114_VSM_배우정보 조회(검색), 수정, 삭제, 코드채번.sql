					-- 제목: 주연배우목록조회
					-- 작성자: 김보영
					-- 작성일: 2021-01-12
					-- 배우코드, 영화명, 생년월일, 등록자
						WITH TMP_KWD_LIST AS (
					                    SELECT TRIM(REGEXP_SUBSTR(:ACT_NM, '[^,]+', 1, LEVEL)) AS KEYWORD
					                    FROM DUAL
					                    CONNECT BY TRIM(REGEXP_SUBSTR(:ACT_NM, '[^,]+', 1, LEVEL)) IS NOT NULL
					                 )
						SELECT      A.ACT_CD
						        ,   A.ACT_NM
						        ,   A.ACT_BIRTH
						        ,   A.CRE_ID
						        ,   B.MANAGE_NM
						FROM VSM_ACT_INFO A

						LEFT OUTER JOIN VSM_MANAGER B
						ON B.MANAGE_CD = A.CRE_ID

							WHERE 1=1
		 					#if ( $STDATE && $STDATE != "")
		                        AND A.ACT_BIRTH >= TO_DATE(:STDATE ,'YYYY-MM-DD')
		                    #end

		                    #if ( $LADATE && $LADATE != "")
		                        AND A.ACT_BIRTH <= TO_DATE(:LADATE ,'YYYY-MM-DD')
		                    #end
						AND EXISTS(SELECT * FROM TMP_KWD_LIST B WHERE A.ACT_NM LIKE '%' || B.KEYWORD || '%')

						ORDER BY A.ACT_CD

					-- 주연배우목록에서 수정하기
						MERGE INTO VSM_ACT_INFO T -- merge를 할 대상 테이블
						USING (
						        SELECT
						               :ACT_CD ACT_CD
						             , :ACT_NM ACT_NM
	                                 , :ACT_BIRTH ACT_BIRTH
						             , :G_EMPL_NO CRE_ID
						             , :G_EMPL_NO UPT_ID
						             , SYSDATE CRE_DT
						             , SYSDATE UPT_DT
						        FROM DUAL
						        ) S
						ON (
						       S.ACT_CD = T.ACT_CD
						    )
						WHEN MATCHED THEN
						    UPDATE
						       SET
						              T.ACT_NM           = S.ACT_NM
						            , T.ACT_BIRTH        = S.ACT_BIRTH
						            , T.UPT_ID           = S.UPT_ID
						            , T.UPT_DT           = S.UPT_DT
						WHEN NOT MATCHED THEN
						    INSERT (  T.ACT_CD
						            , T.ACT_NM
						            , T.ACT_BIRTH
						            , T.CRE_ID
						            , T.UPT_ID
						            , T.CRE_DT
						            , T.UPT_DT )
						    VALUES (  S.ACT_CD
						            , S.ACT_NM
						            , S.ACT_BIRTH
						            , S.CRE_ID
						            , S.UPT_ID
						            , S.CRE_DT
						            , S.UPT_DT )

					-- 배우코드 채번
						SELECT 'actor' || TRIM(TO_CHAR(SEQ_ACT.NEXTVAL, '00000')) ACT_CD FROM DUAL

					-- 배우정보 삭제
					DELETE FROM VSM_ACT_INFO A
					WHERE A.ACT_CD = :ACT_CD
					AND NOT EXISTS(SELECT * FROM VSM_MOVIE_INFO B WHERE B.ACT_CD = :ACT_CD)	