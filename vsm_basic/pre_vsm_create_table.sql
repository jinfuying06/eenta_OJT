CREATE TABLE vsm_custom_info(
CUSTOM_CD VARCHAR2(10) Not Null ,
CUSTOM_NM VARCHAR2(50) ,
CUSTOM_ADDRESS VARCHAR2(50) , 
CUSTOM_TEL VARCHAR2(20) , 
LATE_FEE_INFO VARCHAR2(10) , 
LATE_FEE NUMBER , 
REG_DATE DATE , 
CONSTRAINT vsm_custom_info PRIMARY KEY(custom_cd));

CREATE TABLE vsm_act_info(
ACT_CD VARCHAR2(10) Not Null, 
MOVIE_CD VARCHAR2(50) , 
ACT_BIRTH DATE , 
CONSTRAINT vsm_act_info PRIMARY KEY(act_cd));

CREATE TABLE vsm_tape_info(
TAPE_CD VARCHAR2(10) Not Null, 
MOVIE_CD VARCHAR2(10) , 
RENT_ABILITY VARCHAR2(5) , 
CO_RECORD_SYS VARCHAR2(10) Not Null, 
CONSTRAINT vsm_tape_info PRIMARY KEY(tape_cd), FOREIGN KEY(movie_cd) REFERENCES vsm_movie_info(movie_cd));

CREATE TABLE vsm_rent_record (
RENT_DATE DATE Not Null, 
TAPE_CD VARCHAR2(10) Not Null, 
CUSTOM_CD VARCHAR2(10) Not Null, 
RETURN_DUE_DATE DATE , 
RETURN_DATE DATE , 
RENT_ID VARCHAR2(10) , 
RETRUN_ID VARCHAR2(10) , 
CONSTRAINT vsm_rent_record PRIMARY KEY(rent_date), FOREIGN KEY(tape_cd) REFERENCES vsm_tape_info(tape_cd));