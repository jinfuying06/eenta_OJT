INSERT INTO vsm_co_cd (
            CO_CD,	GRP_CD,	CO_CD_NM,	CRE_ID,	UPT_ID,	CRE_DT,	UPT_DT)
SELECT '00000'  CO_CD, '00' GRP_CD,'일반' CO_CD_NM, 'MGR0000000' CRE_ID, 'MGR0000000' UPT_ID, sysdate 	CRE_DT, sysdate	UPT_DT from dual

union all select '00001', '00','최신', 'MGR0000000', 'MGR0000000', sysdate, sysdate from dual
union all select '01000', '01','액션', 'MGR0000000', 'MGR0000000', sysdate, sysdate from dual
union all select '01001', '01','코미디', 'MGR0000000', 'MGR0000000', sysdate, sysdate from dual
union all select '01002', '01','멜로', 'MGR0000000', 'MGR0000000', sysdate, sysdate from dual
union all select '01003', '01','SF', 'MGR0000000', 'MGR0000000', sysdate, sysdate from dual
union all select '01004', '01','판타지', 'MGR0000000', 'MGR0000000', sysdate, sysdate from dual
union all select '01005', '01','다큐', 'MGR0000000', 'MGR0000000', sysdate, sysdate from dual
union all select '01006', '01','드라마', 'MGR0000000', 'MGR0000000', sysdate, sysdate from dual
union all select '02000', '02','BETA', 'MGR0000000', 'MGR0000000', sysdate, sysdate from dual
union all select '02001', '02','VHS', 'MGR0000000', 'MGR0000000', sysdate, sysdate from dual
union all select '03000', '03','사장', 'MGR0000000', 'MGR0000000', sysdate, sysdate from dual
union all select '03001', '03','매니저', 'MGR0000000', 'MGR0000000', sysdate, sysdate from dual
union all select '03002', '03','알바', 'MGR0000000', 'MGR0000000', sysdate, sysdate from dual
union all select '04000', '04','대여가능', 'MGR0000000', 'MGR0000000', sysdate, sysdate from dual
union all select '04001', '04','대여중', 'MGR0000000', 'MGR0000000', sysdate, sysdate from dual
union all select '05000', '05','연체없음', 'MGR0000000', 'MGR0000000', sysdate, sysdate from dual
union all select '05001', '05','연체중', 'MGR0000000', 'MGR0000000', sysdate, sysdate from dual