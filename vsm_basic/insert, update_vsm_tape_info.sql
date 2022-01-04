INSERT INTO vsm_tape_info (
            TAPE_CD,	MOVIE_CD,	CO_TAPE_TYPE_CD,	CRE_ID,	UPT_ID,	CRE_DT,	UPT_DT)
SELECT 'tape000000'  TAPE_CD, 'movie00000' MOVIE_CD, 02000 CO_TAPE_TYPE_CD, 'MGR0000000' CRE_ID, 'MGR0000000' UPT_ID, sysdate 	CRE_DT, sysdate	UPT_DT from dual
union all select 'tape000001', 'movie00000', 02001, 'MGR0000000', 'MGR0000000', sysdate, sysdate from dual
union all select 'tape000002', 'movie00001', 02000, 'MGR0000000', 'MGR0000000', sysdate, sysdate from dual
union all select 'tape000003', 'movie00001', 02000, 'MGR0000000', 'MGR0000000', sysdate, sysdate from dual
union all select 'tape000004', 'movie00001', 02001, 'MGR0000001', 'MGR0000001', sysdate, sysdate from dual
union all select 'tape000005', 'movie00002', 02001, 'MGR0000002', 'MGR0000002', sysdate, sysdate from dual
union all select 'tape000006', 'movie00003', 02000, 'MGR0000001', 'MGR0000001', sysdate, sysdate from dual
union all select 'tape000007', 'movie00004', 02001, 'MGR0000001', 'MGR0000001', sysdate, sysdate from dual;

UPDATE vsm_tape_info
    SET CO_TAPE_TYPE_CD = '02001' WHERE CO_TAPE_TYPE_CD = 2001;

UPDATE vsm_tape_info
    SET CO_TAPE_TYPE_CD = '02000' WHERE CO_TAPE_TYPE_CD = 2000;    
    