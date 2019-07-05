CREATE OR REPLACE TRIGGER BeforeUpdateStudent BEFORE
UPDATE ON students
FOR EACH ROW

DECLARE
  underflow_length		EXCEPTION;
  invalid_value		EXCEPTION;
  nLength			NUMBER;
  nBlank			NUMBER;

BEGIN
  nLength := length(:new.s_pwd);
	IF (nLength<4)
  	THEN RAISE underflow_length;
	END IF;
  IF (:new.s_pwd = replace(:new.s_pwd,' ',''))
    THEN nBlank := 0;
  ELSE nBlank :=1;
  END IF;
  IF (nBlank!=0)
    THEN RAISE invalid_value;
  END IF;
	/* 채워 넣자 */
	
  EXCEPTION
    WHEN underflow_length THEN
      RAISE_APPLICATION_ERROR(-20002, '암호 길이 짧음');
    WHEN invalid_value THEN
      RAISE_APPLICATION_ERROR(-20003,  '암호 공란 존재');
    WHEN OTHERS THEN 
      DBMS_OUTPUT.PUT_LINE(SQLERRM);
      
END;
/

