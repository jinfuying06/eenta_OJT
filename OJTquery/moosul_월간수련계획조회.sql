				  WITH BASE_DATE AS (
                        SELECT
                        :S_DT || '-01' S_DT
                        , TO_CHAR(LAST_DAY(:S_DT || '-01'), 'YYYY-MM-DD') E_DT
                        FROM DUAL
                  )
				  , DATE_LIST AS (
				        SELECT TO_DATE(S_DT,'YYYY-MM-DD') + (LEVEL - 1) DT FROM BASE_DATE

				        CONNECT BY LEVEL <= TO_DATE(E_DT,'YYYY-MM-DD') - TO_DATE(S_DT,'YYYY-MM-DD') + 1
				  )
				  , TEST_OPER_STU_CNT AS (
				    SELECT TEST_OPER_CD, COUNT(STU_CD) STU_CNT FROM TEST_OPER_DTL
				    WHERE GYM_CD = :GYM_CD
				    GROUP BY TEST_OPER_CD
				  )
				  , TRAIN_GRP_STU_CNT AS (
				                             SELECT A.TRAIN_GRP_CD, B.GYM_CD, COUNT(STU_CD) STU_CNT FROM TRAIN_GRP_STU A
				                             LEFT OUTER JOIN TRAIN_GRP B
				                             ON B.TRAIN_GRP_CD = A.TRAIN_GRP_CD
				                             WHERE B.GYM_CD = :GYM_CD
				                             GROUP BY A.TRAIN_GRP_CD, B.GYM_CD
				                        )
				  , TEST_OPER_LIST AS (
				  SELECT
				       TO_CHAR(B.DT, 'YYYY-MM-DD') DT, A.TEST_OPER_TLT TITLE, NVL(C.STU_CNT,0) STU_CNT, 0 TP
				       , ROW_NUMBER() over (PARTITION BY B.DT ORDER BY NVL(C.STU_CNT,0)) RN
				  FROM TEST_OPER A
				  INNER JOIN DATE_LIST B
				  ON B.DT >= A.TEST_OPER_ST_DT AND B.DT <= A.TEST_OPER_ED_DT
				  LEFT OUTER JOIN TEST_OPER_STU_CNT C
				  ON C.TEST_OPER_CD = A.TEST_OPER_CD
				  WHERE A.GYM_CD = :GYM_CD
				  )
				, TRAIN_PLAN_LIST AS (
				    SELECT A.*
				           , ROW_NUMBER() over (PARTITION BY A.DT ORDER BY NVL(A.STU_CNT,0) DESC) RN
				    FROM  (SELECT TO_CHAR(C.TRAIN_PLAN_DT, 'YYYY-MM-DD') DT
                               , B.CURR_NM TITLE
                               , SUM(NVL(D.STU_CNT,0)) STU_CNT , 1 TP

                              FROM TRAIN_PLAN_CURR A
                              CROSS JOIN BASE_DATE BD
                              LEFT OUTER JOIN TRAIN_CURR B
                              ON B.CURR_CD = A.CURR_CD
                              LEFT OUTER JOIN TRAIN_PLAN C
                              ON C.TRAIN_PLAN_CD = A.TRAIN_PLAN_CD
                              LEFT OUTER JOIN TRAIN_GRP_STU_CNT D
                              ON D.TRAIN_GRP_CD = C.TRAIN_GRP_CD
                              WHERE B.GYM_CD = :GYM_CD
                              AND C.TRAIN_PLAN_DT >= BD.S_DT AND C.TRAIN_PLAN_DT <= BD.E_DT
                              AND TRAIN_PLAN_FIN_YN = 'Y'
				              GROUP BY TO_CHAR(C.TRAIN_PLAN_DT, 'YYYY-MM-DD'), B.CURR_NM
                                ) A
				           )

				, ALL_LIST AS (
				  SELECT
				        DT
				        , TITLE
				        , STU_CNT
				        , TP
				        , RN
				 FROM TEST_OPER_LIST
				 UNION ALL
				 SELECT
				      DT
				      , TITLE
				      , STU_CNT
				      , TP
				      , RN
				FROM TRAIN_PLAN_LIST

				)
				, CAL_LIST AS(
				    SELECT
				         A.DT ST_DT
				         , A.DT ED_DT
				         , A.TITLE
				         , A.STU_CNT
				         , A.TP
				         , A.RN
				    FROM ALL_LIST A
				    LEFT OUTER JOIN TEST_OPER_LIST B
				    ON B.DT = A.DT AND B.TP = 0 AND B.RN = 1
				    WHERE (A.TP = 0 AND A.RN = 1)
				       OR (A.TP = 1 AND (     (B.DT IS NULL AND A.RN <= 4)
				                      OR (B.DT IS NOT NULL AND A.RN <= 3)
				                          ) )
				  )
				    SELECT
				      ROW_NUMBER() OVER (ORDER BY ST_DT) ID
				    , ST_DT
				    , ED_DT
				    , LISTAGG(TITLE, '@#$') WITHIN GROUP(ORDER BY TP, RN) TITLES
				FROM CAL_LIST
				GROUP BY  ST_DT, ED_DT