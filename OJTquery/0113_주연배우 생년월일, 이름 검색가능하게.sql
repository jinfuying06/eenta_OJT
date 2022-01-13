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