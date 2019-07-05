CREATE OR REPLACE FUNCTION Date2EnrollYear(dDate IN DATE)
RETURN NUMBER
IS
	ryear NUMBER;
	monn NUMBER;
BEGIN
	ryear := TO_NUMBER(TO_CHAR(dDate, 'YYYY'));
	monn := TO_NUMBER(TO_CHAR(dDate, 'MM'));

	IF (monn >= 1 AND monn <= 10) THEN RETURN ryear;
	ELSE RETURN ryear+1;
	END IF;
END;
/

CREATE OR REPLACE FUNCTION Date2EnrollSemester(dDate IN DATE)
RETURN NUMBER
IS
	rseme NUMBER;
	monn NUMBER;
BEGIN
	monn := TO_NUMBER(TO_CHAR(dDate, 'MM'));

	IF (monn >= 5 AND monn <= 10) THEN rseme := 2;
	ELSE rseme := 1;
	END IF;

	RETURN rseme;
END;
/
