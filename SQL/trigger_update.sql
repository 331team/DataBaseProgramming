/*학생 사용자 정보 수정 trigger*/
CREATE OR REPLACE TRIGGER BeforeUpdateStudent BEFORE
UPDATE ON student
FOR EACH ROW

DECLARE
 	length_check 	EXCEPTION;
	invalid_value 	EXCEPTION;
	nLength 		NUMBER;
	nBlank 		NUMBER;

BEGIN
 	nLength := LENGTH(:new.s_pwd);
 	IF (nLength<4)
 	THEN RAISE length_check;
	END IF;

	nBlank := INSTR(:new.s_pwd, ' ', 1, 1);
	IF(nBlank!=0)
	THEN RAISE invalid_value;
	END IF;

 	EXCEPTION
 		WHEN length_check THEN
 			RAISE_APPLICATION_ERROR(-20002, '암호 길이 짧음');
  	 	WHEN invalid_value THEN
   			RAISE_APPLICATION_ERROR(-20003, '암호 공란 존재');
     		WHEN OTHERS THEN
    			DBMS_OUTPUT.PUT_LINE(SQLERRM);
END;
/


/*교수 사용자 정보 수정 trigger*/
CREATE OR REPLACE TRIGGER BeforeUpdateProfessor BEFORE
UPDATE ON professor
FOR EACH ROW

DECLARE
 	length_check 	EXCEPTION;
	invalid_value 	EXCEPTION;
	nLength 		NUMBER;
	nBlank 		NUMBER;

BEGIN
 	nLength := LENGTH(:new.p_pwd);
 	IF (nLength<4)
 	THEN RAISE length_check;
	END IF;

	nBlank := INSTR(:new.p_pwd, ' ', 1, 1);
	IF(nBlank!=0)
	THEN RAISE invalid_value;
	END IF;

 	EXCEPTION
 		WHEN length_check THEN
 			RAISE_APPLICATION_ERROR(-20002, '암호 길이 짧음');
  	 	WHEN invalid_value THEN
   			RAISE_APPLICATION_ERROR(-20003, '암호 공란 존재');
     		WHEN OTHERS THEN
    			DBMS_OUTPUT.PUT_LINE(SQLERRM);
END;
/