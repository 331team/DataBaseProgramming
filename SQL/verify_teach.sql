CREATE OR REPLACE PROCEDURE SelectTimeTableProfessor (pProfessorId IN NUMBER,
              professor_course OUT SYS_REFCURSOR,
              sumCourse OUT NUMBER,
              sumUnit OUT NUMBER)
IS
  nYear       NUMBER;
  nSemester   NUMBER;
BEGIN
  nYear := Date2EnrollYear(SYSDATE);
  nSemester := Date2EnrollSemester(SYSDATE);
  OPEN professor_course FOR
    SELECT c.c_id, c.c_id_no, c.c_name, c.c_unit, t.t_where, t.t_time, t.t_day 
    from teach t, course c
    where t.t_year= nYear and t.t_semester = nSemester and t.c_id = c.c_id and t.c_id_no = c.c_id_no and p_id=pProfessorId;
  select COUNT(*)
  into sumCourse
  from teach
  where t_year = nYear and t_semester = nSemester and p_id = pProfessorId;
  
  select SUM(c.c_unit)
  into sumUnit
  from teach t, course c
  where t.t_year = nYear and t.t_semester = nSemester and t.p_id = pProfessorId and t.c_id = c.c_id and t.c_id_no = c.c_id_no;
 
 DBMS_OUTPUT.PUT_LINE('총 '||sumCourse||' 과목과 총 '||sumUnit||' 학점을 수업합니다.');
 
END;
/
