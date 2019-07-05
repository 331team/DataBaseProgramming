CREATE OR REPLACE PROCEDURE InsertTeach(professorId IN NUMBER,
				pCourseId IN VARCHAR2,
        pCourseIdNo IN NUMBER,
        pCourseName IN VARCHAR2,
        pCourseUnit IN NUMBER,
        pCourseMax IN NUMBER,
        pTeachDay IN NUMBER,
        pTeachTime IN NUMBER,
        pTeachWhere IN VARCHAR2,
				re	OUT VARCHAR2)
IS
  exist_course	EXCEPTION;
  professor_already_have_course		EXCEPTION;
  where_already_have_course		EXCEPTION;
  friday_not_start_oclock EXCEPTION;
  
  nYear				NUMBER;
  nSemester			NUMBER;  
  nCountCourse		NUMBER;
  nProfessorCourse NUMBER;
  nWhereCourse NUMBER;
  nExistCourse NUMBER;

BEGIN
  re := '';

DBMS_OUTPUT.put_line('#');
DBMS_OUTPUT.put_line(professorId || '님이 과목번호 ' || pCourseId ||
', 분반 ' || TO_CHAR(pCourseIdNo) || '의 수강 등록을 요청하였습니다.');
/* 년도, 학기 알아내기 */
  nYear := Date2EnrollYear(SYSDATE);
  nSemester := Date2EnrollSemester(SYSDATE);

/* 에러 처리 1 : 이미 있는 수업 */
  SELECT count(*)
  INTO nCountCourse
  FROM teach
  WHERE c_id = pCourseId and c_id_no = pCourseIdNo and t_semester = nSemester and t_year = nYear;
  
  IF (nCountCourse>0)
  THEN
    RAISE exist_Course;
  END IF;

  /* 에러 처리 2 : 교수님이 같은 시간, 같은 요일에 강의 있는 경우 */
  SELECT COUNT(*)
  INTO	 nProfessorCourse
  FROM   teach
  WHERE  p_id=professorId and t_time = pTeachTime  and t_day = pTeachDay and t_semester = nSemester and t_year = nYear;

  IF (nProfessorCourse > 0)
  THEN
     RAISE  professor_already_have_course;
  END IF;

  /* 에러 처리 3 : 수업 장소에 같은 시간, 같은 요일에 강의 있는 경우 */
  SELECT count(*)
  INTO	 nWhereCourse
  FROM   teach
  WHERE  t_year= nYear and t_semester = nSemester 
  and t_where = pTeachWhere and t_time = pTeachTime and t_day = pTeachDay;

  IF (nWhereCourse>0)
  THEN
     RAISE where_already_have_course;
  END IF;

   /* 에러 처리 4 : 금요일인데 정시 시작 아니고 다른 시간 시작일 경우  */
  IF (pTeachDay = 3 and MOD(pTeachTime,2) = 0)
  THEN
    RAISE friday_not_start_oclock;
  END IF;
  
/* 수업 등록 */
  SELECT count(*)
  INTO nExistCourse
  FROM course
  WHERE c_id = pCourseId and c_id_no = pCourseIdNo;
  IF (nExistCourse<=0)
  THEN
    INSERT INTO course values(pCourseId, pCourseIdNo,pCourseUnit,pCourseName);
  END IF;
  INSERT INTO teach values(pCourseId, pCourseIdNo, professorId, nYear, nSemester, pTeachTime, pTeachDay, pCourseMax, pTeachWhere);
  COMMIT;
  re := '수업 등록이 완료되었습니다.';
  

EXCEPTION
  WHEN exist_course	THEN
	re := '이미 존재하는 수업입니다. 분반을 달리하거나, 다른 강의 번호를 입력해주세요.';
  WHEN professor_already_have_course	THEN
	re := '해당 시간은 이미 강의가 있습니다. 시간이나 요일을 다시 선택해주세요.';
  WHEN where_already_have_course	THEN
	re := '해당 장소에는 이미 같은 시간에 강의가 있습니다.';
  WHEN friday_not_start_oclock	THEN
	re := '금요일은 정시에 시작해야 합니다. 시간을 다시 선택해주세요.';
  WHEN OTHERS THEN
        ROLLBACK;
        re := SQLCODE;
END;
/
