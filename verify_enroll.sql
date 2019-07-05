CREATE OR REPLACE PROCEDURE SelectTimeTable (sStudentId IN NUMBER,
              student_course OUT SYS_REFCURSOR,
              sumCourse OUT NUMBER,
              sumUnit OUT NUMBER)
IS
  nYear       NUMBER;
  nSemester   NUMBER;
BEGIN
  nYear := Date2EnrollYear(SYSDATE);
  nSemester := Date2EnrollSemester(SYSDATE);
  OPEN student_course FOR
    SELECT c.c_id, c.c_id_no, c.c_name, c.c_unit, t.t_where, t.t_time, t.t_day 
    from teach t, course c, enroll e
    where e.e_year= nYear and e.e_semester = nSemester and t.c_id = c.c_id and c.c_id = e.c_id and t.c_id_no = c.c_id_no and c.c_id_no = e.c_id_no and s_id=sStudentId;
  select COUNT(*)
  into sumCourse
  from enroll
  where e_year = nYear and e_semester = nSemester and s_id = sStudentId;
  
  select SUM(c.c_unit)
  into sumUnit
  from enroll e, course c
  where e.e_year = nYear and e.e_semester = nSemester and e.s_id = sStudentId and e.c_id = c.c_id and e.c_id_no = c.c_id_no;
 
 DBMS_OUTPUT.PUT_LINE('총 '||sumCourse||' 과목과 총 '||sumUnit||' 학점을 신청하였습니다.');
 
END;
/
