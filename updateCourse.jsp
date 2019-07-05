<%@ page contentType="text/html; charset=UTF-8"%>
<%@ include file="dbConfig.jsp" %>
<!DOCTYPE html>
<html>
<head>
<meta charset="EUC-KR">
<title>강의 조회 및 변경</title>
<style>
table {
    border-collapse: collapse;
  }
th, td {
    align: center;
    padding: 10px;
    font-family: 'Jeju Gothic', sans-serif;
  }
  
*{
  font-family:  'Jeju Gothic', sans-serif;
  }
 tr:nth-child(even){background-color: #f2f2f2}
  th {
  background-color: #0061ff;
  color: white;
}
</style>
</head>
<body>
<%@ include file="top.jsp" %>
<% if(session_id==null) response.sendRedirect("login.jsp"); %>


<table width="75%" align="center" border>
<br>
<tr><th>과목번호</th><th>분반</th><th>과목명</th><th>인원수</th><th>강의시간</th><th>장소</th><th>학점</th><th>신청인원</th><th>변경</th>
<%
Statement stmt = null;
Statement stmt2 = null;
try {
   stmt = myConn.createStatement();
   stmt2 = myConn.createStatement();
}catch(SQLException ex){
   System.err.println("SQLException : " + ex.getMessage());
}


String mySQL = "SELECT c.c_id, c.c_id_no, c.c_name, c.c_unit, t.t_day, t.t_startTime, t.t_endTime, t.t_where, t.t_max FROM course c, teach t, professor p WHERE c.c_id = t.c_id AND c.c_id_no = t.c_id_no AND p.p_id = t.p_id AND (c.c_id, c.c_id_no) IN (SELECT c_id, c_id_no FROM teach WHERE p_id = '" + session_id + "')";


ResultSet rs = stmt.executeQuery(mySQL);
if(rs != null){
   int i=0;
   while(rs.next()){
      i++;
      String c_id = rs.getString("c_id");
      int c_id_no = rs.getInt("c_id_no");
      String c_name = rs.getString("c_name");
      int c_unit = rs.getInt("c_unit");
      String t_day = rs.getString("t_day");
      String t_startTime = rs.getString("t_startTime");
      String t_endTime = rs.getString("t_endTime");
      String t_where = rs.getString("t_where");
      int t_max = rs.getInt("t_max");
      String startTime_hh = t_startTime.substring(0,2);
      String startTime_min = t_startTime.substring(2,4);
      String endTime_hh = t_endTime.substring(0,2);
      String endTime_min = t_endTime.substring(2,4);
      String time = t_day + " " + startTime_hh + ":" + startTime_min + " ~ " + endTime_hh + ":" + endTime_min;
      String mySQL2="select COUNT(*) as total from enroll where c_id='"+c_id+"' and c_id_no="+c_id_no;
      ResultSet rs2 = stmt2.executeQuery(mySQL2);
      int total = 0;
      if(rs2 != null){
         rs2.next();
         total = rs2.getInt("total");
      }
      
      if(i%2==0){
%>      
      <tr onmouseover="this.style.background='skyblue'" onmouseout="this.style.background='white'">
      <form action="updateCourse_verify.jsp" method="post" name="updateFrm">   <!--마우스 효과-->
<%      } else{
%>
      <tr onmouseover="this.style.background='skyblue'" onmouseout="this.style.background='#f2f2f2'">
      <form action="updateCourse_verify.jsp" method="post" name="updateFrm">   <!--마우스 효과-->
<%      }%>
         <td align="center"><input type="hidden" name="c_id" value="<%=c_id %>"><%=c_id %></td>
         <td align="center"><input type="hidden" name="c_id_no" value="<%=c_id_no%>"><%=c_id_no %></td>
         <td align="center"><input type="hidden" name="c_name" value="<%=c_name%>"><%=c_name %></td>
         <td align="center"><input type="text" name="t_max" id = "t_max" value="<%=t_max %>" size="5">명</td>
         <td align="center"><input type="hidden" name="time" value="<%=time%>"><%=time %></td>
         <td align="center"><input type="hidden" name="t_where" value="<%=t_where%>"><%=t_where %></td>
         <td align="center"><input type="hidden" name="c_unit" value="<%=c_unit%>"><%=c_unit %></td>
         <td align="center"><input type="hidden" name="total" value="<%=total%>"><%=total %></td>
         <td align="center"><input type="submit" value="변경"></td>
       </form>
       </tr>
 
<%
   }
} else{
%>
   <tr> <td align="center">개설한 강의가 없습니다.</td> </tr>
<%
}
stmt.close();
myConn.close();
%>


</table>




</body>
</html>