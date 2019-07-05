CREATE TABLE STUDENTS (
    s_id NUMBER(10) CONSTRAINT s_pk PRIMARY KEY,
    s_pwd VARCHAR(20),
    s_name VARCHAR(10),
    s_major VARCHAR(20),
    s_addr VARCHAR(30),
    s_email VARCHAR(50)
 );
 
 CREATE TABLE PROFESSOR (
    p_id NUMBER(10) CONSTRAINT p_pk PRIMARY KEY,
    p_pwd VARCHAR(20),
    p_name VARCHAR(10),
    p_major VARCHAR(20),
    p_email VARCHAR(50)
 );
 
CREATE TABLE COURSE (
    c_id VARCHAR(4),
    c_id_no NUMBER(2),
    c_unit NUMBER(1),
    c_name VARCHAR(30),
    CONSTRAINT c_pk PRIMARY KEY(c_id, c_id_no) 
 );
 
CREATE TABLE teach (
    c_id VARCHAR(4),
    c_id_no NUMBER(2),
    p_id NUMBER(10),
    t_year NUMBER(4),
    t_semester NUMBER(1),
    t_time NUMBER(2),
    t_day NUMBER(1),
    t_max NUMBER(3),
    t_where VARCHAR(20),
    CONSTRAINT t_c_id_fk FOREIGN KEY (c_id,c_id_no) REFERENCES COURSE(c_id,c_id_no),
    CONSTRAINT t_p_id_fk FOREIGN KEY (p_id) REFERENCES PROFESSOR(p_id),
    CONSTRAINT t_pk PRIMARY KEY(c_id, c_id_no, t_year, t_semester)
 );
 
 CREATE TABLE enroll (
    s_id NUMBER(10) ,
    c_id VARCHAR(4),
    c_id_no NUMBER(2),
    e_year NUMBER(4),
    e_semester NUMBER(1),
    CONSTRAINT e_s_id_pk FOREIGN KEY (s_id) REFERENCES STUDENTS(s_id),
    CONSTRAINT e_c_id_pk FOREIGN KEY (c_id,c_id_no,e_year,e_semester) REFERENCES teach(c_id,c_id_no,t_year,t_semester)
     ON DELETE RESTRICT ON UPDATE CASCADE,
    CONSTRAINT e_pk PRIMARY KEY(s_id, c_id,e_year, e_semester)
 );

 CREATE TABLE BOARD(
    b_no NUMBER(10) CONSTRAINT b_pk PRIMARY KEY,
    b_name VARCHAR2(20),
    b_pwd VARCHAR2(20),
    b_title VARCHAR2(20) NOT NULL,
    p_name VARCHAR2(20),
    b_content VARCHAR2(1000),
    b_regdate VARCHAR2(10),
    b_hit NUMBER(10)
);

CREATE SEQUENCE b_no
    START WITH 1
    INCREMENT BY 1
    MAXVALUE 9999999999;
  
CREATE TABLE COMMENTTABLE(
    comment_id VARCHAR(20),
    comment_content VARCHAR(100),
    comment_ref NUMBER(10),
    CONSTRAINT comment_fk FOREIGN KEY (comment_ref) REFERENCES BOARD(b_no)
);

commit;
