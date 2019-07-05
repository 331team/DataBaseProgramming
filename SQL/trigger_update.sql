/*�л� ����� ���� ���� trigger*/
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
 			RAISE_APPLICATION_ERROR(-20002, '��ȣ ���� ª��');
  	 	WHEN invalid_value THEN
   			RAISE_APPLICATION_ERROR(-20003, '��ȣ ���� ����');
     		WHEN OTHERS THEN
    			DBMS_OUTPUT.PUT_LINE(SQLERRM);
END;
/


/*���� ����� ���� ���� trigger*/
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
 			RAISE_APPLICATION_ERROR(-20002, '��ȣ ���� ª��');
  	 	WHEN invalid_value THEN
   			RAISE_APPLICATION_ERROR(-20003, '��ȣ ���� ����');
     		WHEN OTHERS THEN
    			DBMS_OUTPUT.PUT_LINE(SQLERRM);
END;
/