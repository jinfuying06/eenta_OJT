-- 제목: 고객정보조회
-- 작성자: 김보영
-- 작성일: 2021-12-22
-- 고객번호, 이름, 전화번호, 주소, 연체유무, 연체료, 고객등록일
-- 연체유무 및 연체 정보를 VSM_RENT_RECORD를 이용하여 파악하기

SELECT      A.CUSTOM_CD
        ,   A.CUSTOM_NM
        ,   A.CUSTOM_TEL
        ,   A.CUSTOM_ADDRESS
        ,   A.CO_LATE_FEE_INFO
        ,   B.CO_CD_NM LATE_FEE_INFO
        ,   A.LATE_FEE
        ,   REG_DATE
FROM VSM_CUSTOM_INFO A

LEFT OUTER JOIN VSM_CO_CD B
ON B.CO_CD = A.CO_LATE_FEE_INFO