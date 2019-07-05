<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<link href="http://fonts.googleapis.com/earlyaccess/jejugothic.css" rel="stylesheet">
<% String session_id = (String) session.getAttribute("user");
boolean isStudent = true;

String log;
if (session_id == null)
   log = "<a href=login.jsp>로그인</a>";
else {
   isStudent = (boolean) session.getAttribute("student");
   log = "<a href=logout.jsp>로그아웃</a>";
}%>
<style>
*{
   font-family: 'Jeju Gothic', sans-serif;
   position: relative;
}
a {
   color : #fff;
   text-decoration : none;
   font-family: 'Jeju Gothic', sans-serif;
}
a:visited{
   color:#fff;
   text-decoration : none;
   font-family: 'Jeju Gothic', sans-serif;
   }
h1{
   color :rgb(13,45,132);
}
table {
    border-collapse: collapse;
  }
th, td {
    align: center;
    padding: 10px;
    font-family: 'Jeju Gothic', sans-serif;
  }
 .menu td:hover{
    background: #4d69b7;  
 }

</style>

<body>
<a style="color:black;" href="main.jsp">
<table align="center">
   <tr>
   <td><img src="images/snow.jpg" width="70px"></td>
   <td><h1 align="center">숙명여자대학교 수강신청페이지</h1></td>
   <td><img src="images/snow.jpg" width="70px"></td>
   </tr>
</table>
</a>
<table class="menu" width="80%" align="center" bgcolor="#0d2d84" id="menu">
<td align="center"><b><%=log%></b></td>
<%
if(isStudent){ %>
   <td align="center"><b><a href="update.jsp">사용자 정보 수정</span></b></td>
   <td align="center"><b><a href="insert.jsp?col=0">수강 신청</b></td>
   <td align="center"><b><a href="delete.jsp">수강 신청 취소</b></td>
   <td align="center"><b><a href="select.jsp">수강 신청 조회</b></td>
   <td align="center"><b><a href="student_time_table.jsp">시간표</b></td>
<%} else{
%>
   <td align="center"><b><a href="update.jsp">사용자 정보 수정</b></td>
   <td align="center"><b><a href="insertCourse.jsp">강의 개설</b></td>
   <td align="center"><b><a href="deleteCourse.jsp">강의 개설 취소</b></td>
   <td align="center"><b><a href="updateCourse.jsp">강의 개설 조회</b></td>
   <td align="center"><b><a href="professor_time_table.jsp">시간표</b></td>
<%} %>
</tr>
</table>

</body>