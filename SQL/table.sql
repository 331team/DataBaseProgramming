CREATE TABLE professor(
	p_id VARCHAR(10) NOT NULL,
	p_pwd VARCHAR2(20),
	p_name VARCHAR2(20),
	p_major VARCHAR(20),
	PRIMARY KEY (p_id)
);

CREATE TABLE student(
	s_id VARCHAR(10) NOT NULL,
	s_pwd VARCHAR(30),
	s_major VARCHAR(30),
	s_name VARCHAR(10),
	PRIMARY KEY (s_id)
);

CREATE TABLE course(
	c_id 		VARCHAR(10) NOT NULL,
	c_id_no 	NUMBER(3) NOT NULL,
	c_name 		VARCHAR2(20),
	c_unit 		NUMBER,
	PRIMARY KEY (c_id, c_id_no)
);

CREATE TABLE enroll(
	s_id 		VARCHAR(10) NOT NULL,
	c_id 		VARCHAR(10) NOT NULL,
	c_id_no 	NUMBER(3) NOT NULL,
	e_year 		NUMBER,
	e_semester 	NUMBER,
	FOREIGN KEY (c_id, c_id_no) REFERENCES course(c_id, c_id_no) ON DELETE CASCADE,
	FOREIGN KEY (s_id) REFERENCES student(s_id) ON DELETE CASCADE
);

CREATE TABLE teach(
	p_id            VARCHAR(10) NOT NULL,
	c_id 		VARCHAR(10) NOT NULL,
	c_id_no 	NUMBER(3) NOT NULL,
	t_year 		NUMBER,
	t_semester 	NUMBER,
	t_day 		VARCHAR(10),
	t_startTime     VARCHAR(20),
	t_endTime       VARCHAR(20),
	t_where         VARCHAR2(20),
	t_max           NUMBER,
	FOREIGN KEY (c_id, c_id_no) REFERENCES course(c_id, c_id_no) ON DELETE CASCADE,
	FOREIGN KEY (p_id) REFERENCES professor(p_id) ON DELETE CASCADE
);