/*�ð� ��ġ�� �� Check*/
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
/*��� �ߺ�*/
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
	DBMS_OUTPUT.PUT_LINE(sProfessorId || '���� �����ȣ ' || sCourseId || ',�й�' ||
			TO_CHAR(nCourseIdNo) ||'�� ���� ������ ��û�Ͽ����ϴ�.');
	/*�⵵, �б� �˾Ƴ���*/
	nYear := Date2EnrollYear(SYSDATE);
	nSemester := Date2EnrollSemester(SYSDATE);
	DBMS_OUTPUT.PUT_LINE('year:' || nYear);
	DBMS_OUTPUT.PUT_LINE('semester: '|| nsemester);

	/*���� ó�� 1 : ���� �ð� ���ǽ� �ߺ�*/
	
	compare := PlaceCompare(new_startTime, new_endTime,t_day2, place);
	DBMS_OUTPUT.PUT_LINE('compare' || compare);
	IF(compare=1)
	THEN 
		RAISE duplicate_place;
	
	END IF;
	compare:=0;

	/*���� ó�� 2 : ���� ����� �ð� �ߺ� ����*/
	
	compare := compareTimeProfessor(sProfessorId, new_startTime, new_endTime, t_day2);
	DBMS_OUTPUT.PUT_LINE('compare' || compare);
	IF(compare=1)
	THEN 
		RAISE duplicate_time;
	
	END IF;

	/*���� ��û ���*/
	INSERT INTO teach VALUES (sProfessorId, sCourseId, nCourseIdNo, nYear, nSemester, t_day2, new_startTime, new_endTime, place, max);
	COMMIT;
	result:='���� ������ �Ϸ�Ǿ����ϴ�';
	EXCEPTION
			
		WHEN duplicate_place THEN
			result := '���ǽ� ����� �Ұ��մϴ�.';
			
		WHEN duplicate_time THEN
			result := '�̹� ��ϵ� ���� �� �ߺ��Ǵ� �ð��� �����մϴ�';
			
		WHEN OTHERS THEN
			ROLLBACK;
			result := '��Ÿ';
END;
/