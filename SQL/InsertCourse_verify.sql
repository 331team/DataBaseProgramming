/*시간 겹치는 지 Check*/
CREATE OR REPLACE FUNCTION compareTimeProfessor
	(ProfessorId IN VARCHAR2,
	new_startTime IN NUMBER,
	new_endTime IN NUMBER,
	t_day2 IN VARCHAR2)
RETURN NUMBER
IS	
	compare NUMBER;
	day VARCHAR2(10);
	startTime NUMBER;
	endTime NUMBER;
	CURSOR teach_list IS
		SELECT *
		FROM teach
		WHERE p_id = ProfessorId AND t_year = Date2EnrollYear(SYSDATE) AND t_semester = Date2EnrollSemester(SYSDATE);
BEGIN
	FOR tch IN teach_list LOOP
		SELECT t_day, TO_NUMBER(t_startTime), TO_NUMBER(t_endTime)
		INTO day, startTime, endTime
		FROM teach
		WHERE tch.c_id = c_id AND tch.c_id_no = c_id_no;
		compare := compareDay(day, t_day2);
		IF(compare=1)
		THEN
			IF(NOT(((new_startTime<=startTime) AND (new_endTime<=startTime)) OR ((new_startTime>=endTime) AND (new_endTime>=endTime))))
			THEN
				RETURN 1;
			END IF;
		END IF;
	END LOOP;
	RETURN 0;
END;
/
/*장소 중복*/
CREATE OR REPLACE FUNCTION PlaceCompare
	(new_startTime IN NUMBER,
	new_endTime IN NUMBER,
	t_day2 IN VARCHAR2,
	new_place IN VARCHAR2)
RETURN NUMBER
IS	
	compare NUMBER;
	day VARCHAR2(10);
	startTime NUMBER;
	endTime NUMBER;
	place VARCHAR2(10);
	CURSOR teach_list IS
		SELECT *
		FROM teach
		WHERE t_year = Date2EnrollYear(SYSDATE) AND t_semester = Date2EnrollSemester(SYSDATE);
BEGIN
	FOR tch IN teach_list LOOP
		SELECT t_day, TO_NUMBER(t_startTime), TO_NUMBER(t_endTime), t_where
		INTO day, startTime, endTime, place
		FROM teach
		WHERE tch.c_id = c_id AND tch.c_id_no = c_id_no;
		compare := compareDay(day, t_day2);
		IF(compare=1)
		THEN
			IF(NOT(((new_startTime<=startTime) AND (new_endTime<=startTime)) OR ((new_startTime>=endTime) AND (new_endTime>=endTime))))
			THEN
				IF(new_place=place) THEN
					RETURN 1;
				END IF;
			END IF;
		END IF;
	END LOOP;
	RETURN 0;
END;
/


CREATE OR REPLACE PROCEDURE InsertCourseVerify(sProfessorId IN VARCHAR2,
					sCourseId IN VARCHAR2,
					nCourseIdNo IN NUMBER,
					t_day2 IN VARCHAR2,
					new_startTime IN VARCHAR2,
					new_endTime IN VARCHAR2,
					place IN VARCHAR2,
					max IN NUMBER,
					result OUT VARCHAR2)
IS
	duplicate_place  	 EXCEPTION;
	duplicate_time		 EXCEPTION;
	nYear    		 NUMBER;
	nSemester		 NUMBER;
	nCnt    		 NUMBER;
	startTime   		 NUMBER;
	endTime  		 NUMBER;
	compare   		 NUMBER;
	
BEGIN
	result:='';
	
	DBMS_OUTPUT.PUT_LINE('#');
	DBMS_OUTPUT.PUT_LINE(sProfessorId || '님이 과목번호 ' || sCourseId || ',분반' ||
			TO_CHAR(nCourseIdNo) ||'의 강의 개설을 요청하였습니다.');
	/*년도, 학기 알아내기*/
	nYear := Date2EnrollYear(SYSDATE);
	nSemester := Date2EnrollSemester(SYSDATE);
	DBMS_OUTPUT.PUT_LINE('year:' || nYear);
	DBMS_OUTPUT.PUT_LINE('semester: '|| nsemester);

	/*에러 처리 1 : 같은 시간 강의실 중복*/
	
	compare := PlaceCompare(new_startTime, new_endTime,t_day2, place);
	DBMS_OUTPUT.PUT_LINE('compare' || compare);
	IF(compare=1)
	THEN 
		RAISE duplicate_place;
	
	END IF;
	compare:=0;

	/*에러 처리 2 : 개설 과목들 시간 중복 여부*/
	
	compare := compareTimeProfessor(sProfessorId, new_startTime, new_endTime, t_day2);
	DBMS_OUTPUT.PUT_LINE('compare' || compare);
	IF(compare=1)
	THEN 
		RAISE duplicate_time;
	
	END IF;

	/*수강 신청 등록*/
	INSERT INTO teach VALUES (sProfessorId, sCourseId, nCourseIdNo, nYear, nSemester, t_day2, new_startTime, new_endTime, place, max);
	COMMIT;
	result:='강의 개설이 완료되었습니다';
	EXCEPTION
			
		WHEN duplicate_place THEN
			result := '강의실 사용이 불가합니다.';
			
		WHEN duplicate_time THEN
			result := '이미 등록된 과목 중 중복되는 시간이 존재합니다';
			
		WHEN OTHERS THEN
			ROLLBACK;
			result := '기타';
END;
/