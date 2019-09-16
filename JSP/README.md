# Database Programming Project
> ## database structure
![](https://user-images.githubusercontent.com/35582991/60696408-92130280-9f20-11e9-837c-1403397c5426.png)
> ## Source code
> ### main
#### main.jsp / top.jsp / dbConfig.jpg
첫 화면
```java
<%@include  file="top.jsp"%>
```
로그인 전 / 후
```java
<% if (session_id != null) { %>
<tr> <td align="center"><%=session_id%>님 방문을 환영합니다.</td> </tr>
<% } else { %>
<tr> <td align="center">로그인한 후 사용하세요.</td> </tr>
<% } %>
```
---
교수와 학생에 따라 내용 변화
```java
String session_id = (String) session.getAttribute("user");
if (session_id == null)
	log = "<a href=login.jsp>로그인</a>";
else {
	isStudent = (boolean) session.getAttribute("student");
	log = "<a href=logout.jsp>로그아웃</a>";
}
```
Tomcat 이용한 드라이버 연결
```java
Class.forName(dbdriver);
Connection myConn=DriverManager.getConnection(dburl, user, password);
```
---
>  ### login
#### login.jsp / login_verify.jsp / logout.jsp
![](https://user-images.githubusercontent.com/35582991/60696413-9c350100-9f20-11e9-91fb-6f16282eb8cc.png)
학생 / 교수 구분 & 저장된 DB에서 일치하는 ID/PW 불러오기
```java
String mySQL="select s_id from student where s_id='" + userID + "'and s_pwd='" + userPassword + "'";
ResultSet rs = stmt.executeQuery(mySQL);
if(rs.next()){ /*학생인 경우*/
	session.setAttribute("user", userID);
	session.setAttribute("student", true);
	response.sendRedirect("main.jsp");
}
else{ /*교수인 경우*/
	mySQL="select p_id from professor where p_id='" + userID + "'and p_pwd='" + userPassword + "'";
	rs = stmt.executeQuery(mySQL);
	if(rs.next()){
		session.setAttribute("user", userID);
		session.setAttribute("student", false);
		response.sendRedirect("main.jsp");
	}
	else response.sendRedirect("login.jsp");
}
```
---
> ### 사용자 정보 수정
#### update.jsp / update_verify.jsp
![](https://user-images.githubusercontent.com/35582991/60696422-af47d100-9f20-11e9-8674-3b0fd4a07e83.png)
student / professor table 에서 해당 ID 사용자의 정보 불러오기
```java
if(isStudent){ /*학생*/
	mySQL = "select s_pwd,s_name, s_major from student where s_id='" + session_id + "'";
	rs = stmt.executeQuery(mySQL);
	...
} else{ /*교수*/
	mySQL = "select p_pwd, p_name, p_major from professor where p_id='" + session_id + "'";
	rs = stmt.executeQuery(mySQL);
	...
}
```
![](https://user-images.githubusercontent.com/35582991/60696430-ba026600-9f20-11e9-8706-6b7152748025.png)
UPDATE query 사용해 사용자 정보 수정
query 수행 시 트리거 발생
```java
if(isStudent)
	sql = "UPDATE student set s_pwd=? where s_id = ?";
else
	sql = "UPDATE professor set p_pwd=? where p_id = ?";
		...
catch(SQLException ex){
	String sMessage;
	if(ex.getErrorCode()==20002) sMessage="암호는 4자리 이상이어야 합니다";
	else if(ex.getErrorCode()==20003) sMessage="암호에 공간은 입력되지 않습니다";
	else sMessage="잠시 후 다시 시도하십시오";
}
```
---
> ### 수강신청
#### insert.jsp / insert_verify.jsp
![](https://user-images.githubusercontent.com/35582991/60696440-c8508200-9f20-11e9-819e-f597e61fe6be.png)
학과별 검색 기능
```java
<FORM name='frm' method='GET' action='./insert.jsp'>
<SELECT name='col'> <!-- 검색 컬럼 -->
	<OPTION value='0'>전체</OPTION>
	<OPTION value='1'<%=keyfield.equals("1")?"selected":""%>>컴퓨터과학과</OPTION>
		...
	<OPTION value='9'<%=keyfield.equals("9")?"selected":""%>>환경디자인과</OPTION>
</SELECT>
<button type='submit'>검색</button>
</FORM>
		...
String mySQL = "SELECT c.c_id, c.c_id_no, c.c_name, c.c_unit, p.p_name, t.t_day, t.t_startTime, t.t_endTime, t.t_where FROM course c, teach t, professor p WHERE c.c_id = t.c_id AND c.c_id_no = t.c_id_no AND c.c_id=t.c_id AND p.p_id = t.p_id AND (c.c_id, c.c_id_no) NOT IN (SELECT c_id, c_id_no FROM enroll WHERE s_id = '" + session_id + "')";
if(index!=0){ // '전체'가 아닌 경우 - 학과별 검색
	mySQL = mySQL + " AND p.p_major='" + major[index] + "'";
}
 ```
![](https://user-images.githubusercontent.com/35582991/60696450-d1d9ea00-9f20-11e9-9091-7f28640eb8b8.png)
InsertEnroll 프로시저 사용해 예외 처리
```java
CallableStatement cstmt = myConn.prepareCall("{call InsertEnroll(?,?,?,?)}");
cstmt.setString(1, session_id);
cstmt.setString(2, c_id);
cstmt.setInt(3, Integer.parseInt(c_id_no));
cstmt.registerOutParameter(4, java.sql.Types.VARCHAR);
cstmt.execute();
result = cstmt.getString(4);
```
---
> ### 강의 개설
#### insertCourse.jsp / insertCourse_verify.jsp
![](https://user-images.githubusercontent.com/35582991/60696475-ec13c800-9f20-11e9-811d-3ec836b423d6.png)

![](https://user-images.githubusercontent.com/35582991/60696480-f6ce5d00-9f20-11e9-9aa0-e12bf466469f.png)

---
> ### 수강신청 취소
#### delete.jsp / delete_verify.jsp
![](https://user-images.githubusercontent.com/35582991/60696488-02218880-9f21-11e9-826e-21a26401b834.png)

---
> #### 강의 개설 취소
#### deleteCourse.jsp / deleteCourse_verify.jsp
![](https://user-images.githubusercontent.com/35582991/60696502-0b125a00-9f21-11e9-8140-af0a90e7ab38.png)

---
> ### 수강신청 조회
#### select.jsp
![](https://user-images.githubusercontent.com/35582991/60696524-15345880-9f21-11e9-987e-07c2ffb15527.png)

---
> ### 강의 개설 조회
#### updateCourse.jsp / updateCourse_verify.jsp
![](https://user-images.githubusercontent.com/35582991/60696541-1d8c9380-9f21-11e9-9fb6-821b9ff7bfa9.png)

---
> ### 시간표
#### student_time_table.jsp / professor_time_table.jsp
![](https://user-images.githubusercontent.com/35582991/60696546-25e4ce80-9f21-11e9-96b5-5ec8836a4c18.png)