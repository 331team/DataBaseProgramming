CREATE OR REPLACE FUNCTION DATE2EnrollYear(dDate IN DATE)
	RETURN NUMBER
IS	
	date_year VARCHAR(5);
	nyear NUMBER;
BEGIN
	
	date_year := TO_CHAR(dDate, 'YYYY');
	nyear := TO_NUMBER(date_year);

	RETURN nyear;
END;
/

CREATE OR REPLACE FUNCTION DATE2EnrollSemester(dDate IN DATE)
	RETURN NUMBER
IS
	date_month VARCHAR(3);
	nmonth NUMBER;
	nSemester NUMBER;
BEGIN
	date_month := TO_CHAR(dDate, 'MM');
	nmonth := TO_NUMBER(date_month);
	
	IF(nmonth>=11 and nmonth<=4)
	THEN nSemester := 1;
	ELSE nSemester := 2;
	END IF;
	
	RETURN nSemester;
END;
/