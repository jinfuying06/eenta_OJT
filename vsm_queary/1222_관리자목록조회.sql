-- 제목: 관리자목록조회
-- 작성자: 김보영
-- 작성일: 2021-12-22
-- 관리자코드, 관리자명, 관리자유형, 전화번호

SELECT      A.MANAGE_CD
        ,   A.MANAGE_NM
        ,   A.CO_MANAGE_TYPE_CD
        ,   B.CO_CD_NM MANAGE_TYPE_NM
        ,   A.MANAGE_TEL
FROM VSM_MANAGER A

LEFT OUTER JOIN VSM_CO_CD B
ON B.CO_CD = A.CO_MANAGE_TYPE_CD