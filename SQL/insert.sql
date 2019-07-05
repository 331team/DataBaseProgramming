/*요일비교*/
CREATE OR REPLACE FUNCTION compareDay
	(t_day1   IN   VARCHAR2,
	 t_day2   IN   VARCHAR2)

RETURN NUMBER
IS
	i     		NUMBER:=1;

BEGIN
	FOR i IN 1..LENGTH(t_day1) LOOP
	    IF(INSTR(t_day2, SUBSTR(t_day1,i,1),1,1)!=0)
	    THEN RETURN 1;
	    END IF;
	END LOOP;
	
     	RETURN 0;

END;
/

/*시간비교*/
CREATE OR REPLACE FUNCTION compareTime
	(StudentId IN VARCHAR2,
	new_startTime IN NUMBER,
	new_endTime IN NUMBER,
	t_day2 IN VARCHAR2)
RETURN NUMBER
IS	
	compare NUMBER;
	day VARCHAR2(10);
	startTime NUMBER;
	endTime NUMBER;
	CURSOR enroll_list IS
		SELECT *
		FROM enroll
		WHERE s_id = StudentId;

BEGIN
	FOR enr IN enroll_list LOOP
		SELECT t_day, TO_NUMBER(t_startTime), TO_NUMBER(t_endTime)
		INTO day, startTime, endTime
		FROM teach
		WHERE enr.c_id = c_id AND enr.c_id_no = c_id_no;
		compare := compareDay(day, t_day2);
		IF(compare=1)
		THEN
			DBMS_OUTPUT.PUT_LINE('startTime:'||startTime||'& endTime:' || endTime);
			IF(NOT(((new_startTime<=startTime) AND (new_endTime<=startTime)) OR ((new_startTime>=endTime) AND (new_endTime>=endTime))))
			THEN
				RETURN 1;
			END IF;
		END IF;
	END LOOP;
	RETURN 0;
END;
/

/*학생 수강 신청*/
CREATE OR REPLACE PROCEDURE InsertEnroll(sStudentId IN VARCHAR2,
					sCourseId IN VARCHAR2,
					nCourseIdNo IN NUMBER,
					result OUT VARCHAR2)
IS
	too_many_sumCourseUnit     EXCEPTION;
	duplicate_courses		 EXCEPTION;
	too_many_students  	 EXCEPTION;
	duplicate_time		 EXCEPTION;
	nYear			 NUMBER;
	nSemester		 NUMBER;
	nSumCourseUnit		 NUMBER;
	nCourseUnit		 NUMBER;
	nCnt			 NUMBER;
	nTeachMAX		 NUMBER;
	startTime   		 NUMBER;
	endTime  		 NUMBER;
	new_startTime   		 NUMBER;
	new_endTime    		 NUMBER;
	compare   		 NUMBER;
	t_day1  		 VARCHAR(10);
	t_day2  		 VARCHAR(10);
BEGIN
	result:='';
	
	DBMS_OUTPUT.PUT_LINE('#');
	DBMS_OUTPUT.PUT_LINE(sStudentID || '님이 과목번호 ' || sCourseId || ',분반' ||
			TO_CHAR(nCourseIdNo) ||'의 수강 등록을 요청하였습니다.');
	/*년도, 학기 알아내기*/
	nYear := Date2EnrollYear(SYSDATE);
	nSemester := Date2EnrollSemester(SYSDATE);
	DBMS_OUTPUT.PUT_LINE('year:' || nYear);
	DBMS_OUTPUT.PUT_LINE('semester: '|| nsemester);

	/*에러 처리1: 최대학점 초과여부*/
	SELECT SUM(c.c_unit)
	INTO nSumCourseUnit
	FROM course c, enroll e
	WHERE e.s_id = sStudentId and e.e_year = nYear and e.e_semester = nSemester
		and e.c_id = c.c_id and e.c_id_no = c.c_id_no;

	DBMS_OUTPUT.PUT_LINE('c_unit:' || nSumCourseUnit);

	SELECT c_unit
	INTO nCourseUnit
	FROM course
	WHERE c_id = sCourseId and c_id_no = nCourseIdNo;
	
	IF(nSumCourseUnit + nCourseUnit > 18)
	THEN
		RAISE too_many_sumCourseUnit;
	END IF;
	
	/*에러 처리 2 : 동일한 과목 신청여부*/
	SELECT COUNT(*)
	INTO nCnt
	FROM enroll
	WHERE s_id = sStudentId and c_id = sCourseId;
	DBMS_OUTPUT.PUT_LINE('course:'|| nCnt);
	IF (nCnt > 0)
	THEN
		RAISE duplicate_courses;
	END IF;	

	/*에러 처리 3 : 수강신청 인원 초과 여부*/
	SELECT t_max
	INTO nTeachMax
	FROM teach
	WHERE t_year = nYear and t_semester = nSemester and c_id = sCourseId and c_id_no = nCourseIdNo;
	DBMS_OUTPUT.PUT_LINE('count:' || nTeachMax);	
	SELECT COUNT(*)
	INTO nCnt
	FROM enroll
	WHERE e_year = nYear and e_semester = nSemester and c_id = sCourseId and c_id_no = nCourseIdNo;
	DBMS_OUTPUT.PUT_LINE('count:' || nCnt);	

	IF(nCnt >= nTeachMax)
	THEN
		RAISE too_many_students;
	END IF;

	/*에러 처리 4 : 신청한 과목들 시간 중복 여부*/
	
	SELECT TO_NUMBER(t_startTime), TO_NUMBER(t_endTime), TO_CHAR(t_day)
	INTO new_startTime, new_endTime, t_day2
	FROM teach
	WHERE c_id = sCourseId and c_id_no = nCourseIdNo;
	
	compare := compareTime(sStudentId, new_startTime, new_endTime, t_day2);
	DBMS_OUTPUT.PUT_LINE('compare' || compare);
	IF(compare=1)
	THEN 
		RAISE duplicate_time;
	
	END IF;

	/*수강 신청 등록*/
	INSERT INTO enroll VALUES (sStudentId, sCourseId, nCourseIdNo, nYear, nSemester);
	COMMIT;
	result:='수강신청이 완료되었습니다';
	EXCEPTION
		WHEN too_many_sumCourseUnit THEN
			result := '최대학점을 초과하였습니다';
			
		WHEN duplicate_courses THEN
			result := '이미 등록된 과목을 신청하였습니다';
			
		WHEN too_many_students THEN
			result := '수강신청 인원이 초과되어 등록이 불가능합니다';
			
		WHEN duplicate_time THEN
			result := '이미 등록된 과목 중 중복되는 시간이 존재합니다';
			
		WHEN OTHERS THEN
			ROLLBACK;
			result := SQLCODE;
END;
/
