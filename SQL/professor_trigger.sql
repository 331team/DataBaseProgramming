create or replace TRIGGER BeforeUpdateProfessor BEFORE
UPDATE ON professor
FOR EACH ROW

DECLARE
  underflow_length		EXCEPTION;
  invalid_value		EXCEPTION;
  nLength			NUMBER;
  nBlank			NUMBER;

BEGIN
  nLength := length(:new.p_pwd);
	IF (nLength<4)
  	THEN RAISE underflow_length;
	END IF;
  IF (:new.p_pwd = replace(:new.p_pwd,' ',''))
    THEN nBlank := 0;
  ELSE nBlank :=1;
  END IF;
  IF (nBlank!=0)
    THEN RAISE invalid_value;
  END IF;
	
  EXCEPTION
    WHEN underflow_length THEN
      RAISE_APPLICATION_ERROR(-20002, '비밀번호가 너무 짧습니다.');
    WHEN invalid_value THEN
      RAISE_APPLICATION_ERROR(-20003,  '비밀번호에 공란은 입력되지 않습니다.');
    WHEN OTHERS THEN 
      DBMS_OUTPUT.PUT_LINE(SQLERRM);
      
END;
