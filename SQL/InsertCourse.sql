/*과목번호와 분반 받아오기*/
CREATE OR REPLACE PROCEDURE InsertCourse
	(cname IN VARCHAR2,
	cunit IN NUMBER,
	pid IN VARCHAR2,
	cid OUT VARCHAR2,
	cidno OUT NUMBER)
	
IS
	/*현재 과목이 개설되어 있는지(teach에 있는지) 분반 남아있는지*/
	CURSOR teach_course IS
		SELECT c.c_id, c.c_id_no
		FROM course c, teach t
		WHERE c.c_name = cname AND 
		      (c.c_id, c.c_id_no) NOT IN (SELECT c.c_id, c.c_id_no FROM course c, teach t 
						    WHERE t.c_id=c.c_id AND t.c_id_no=c.c_id_no
						         AND t.t_year = Date2EnrollYear(SYSDATE) AND t.t_semester = Date2EnrollSemester(SYSDATE));
	/*과목은 있으나 분반 새로 개설할 경우*/
	CURSOR new_cidno IS
		SELECT c_id, c_id_no
		FROM course c
		WHERE c.c_name = cname;

	/*과목 새로 개설*/
	CURSOR new_cid(major professor.p_major%TYPE) IS
		SELECT c.c_id
		FROM course c, teach t, professor p
		WHERE c.c_id = t.c_id AND p.p_id = t.p_id AND p.p_major = major
		ORDER BY c.c_id;
	
	CURSOR new_cid_(C course.c_id%TYPE) IS
		SELECT c_id
		FROM course
		WHERE SUBSTR(c_id,1,1)=C;

	pmajor professor.p_major%TYPE;
	course_id course.c_id%TYPE;
	v_id course.c_id%TYPE;
	v_id_no course.c_id_no%TYPE;
	
	nCnt NUMBER;
	
BEGIN
	SELECT COUNT(*)
	INTO nCnt
	FROM course
	WHERE c_name=cname;
	DBMS_OUTPUT.PUT_LINE('yes');
	/*개설된 강의가 있을 경우*/
	IF (nCnt>0) THEN
		OPEN teach_course;
		FETCH teach_course INTO v_id, v_id_no;
		IF teach_course%FOUND THEN
			cid := v_id; cidno := v_id_no;
		/*새로운 분반 개설*/
		ELSE
			OPEN new_cidno;
			LOOP 
				FETCH new_cidno INTO v_id, v_id_no;
				EXIT WHEN new_cidno%NOTFOUND;
			END LOOP;
			cid := v_id; cidno := v_id_no+1;
			INSERT INTO course VALUES(cid, cidno, cname, cunit);
			CLOSE new_cidno;
			DBMS_OUTPUT.PUT_LINE('---');
		END IF;
		
		CLOSE teach_course;
	/*새로운 강의 개설*/
	ELSE
		/*교수 전공*/
		SELECT p_major
		INTO pmajor
		FROM professor
		WHERE p_id = pid;
		DBMS_OUTPUT.PUT_LINE(pmajor);
		/*new_cid(major)*/
		FOR new IN new_cid(pmajor) LOOP
			v_id := new.c_id;	
		END LOOP;
		FOR new IN new_cid_(SUBSTR(v_id,1,1)) LOOP
			v_id := new.c_id;
		DBMS_OUTPUT.PUT_LINE('C:' || v_id);	
		END LOOP;
		DBMS_OUTPUT.PUT_LINE('v_id:' || v_id);
		cid := LPAD(TO_CHAR(TO_NUMBER(SUBSTR(v_id, 2, 3) + 1)), 3, '0');
		cid := concat(SUBSTR(v_id, 1, 1), cid);
		DBMS_OUTPUT.PUT_LINE(cid);
		cidno := 1;
		INSERT INTO course VALUES(cid, cidno, cname, cunit);
	END IF;
	COMMIT;
END;
/

SET serveroutput on;

DECLARE
	cid VARCHAR2(20) := '';
	cidno NUMBER := 0;
BEGIN
	InsertCourse('자료구조', 3, '1704', cid, cidno);
	DBMS_OUTPUT.PUT_LINE('cid: ' || cid);
	DBMS_OUTPUT.PUT_LINE('cidno: ' || cidno);
END;
/