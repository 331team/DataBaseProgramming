<%@ page contentType="text/html; charset=UTF-8"%>
<%@ include file="dbConfig.jsp" %>
<!DOCTYPE html>
<html>
<head>
<meta charset="EUC-KR">
<title>수강신청 입력</title>
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
<tr><th>과목번호</th><th>분반</th><th>과목명</th><th>교수명</th><th>강의시간</th><th>장소</th><th>학점</th><th>취소</th>
<%
Statement stmt = null;
try {
	stmt = myConn.createStatement();
}catch(SQLException ex){
	System.err.println("SQLException : " + ex.getMessage());
}

String mySQL = "SELECT c.c_id, c.c_id_no, c.c_name, c.c_unit, p.p_name, t.t_day, t.t_startTime, t.t_endTime, t.t_where FROM course c, teach t, professor p WHERE c.c_id = t.c_id AND c.c_id_no = t.c_id_no AND c.c_id=t.c_id AND p.p_id = t.p_id AND (c.c_id, c.c_id_no) IN (SELECT c_id, c_id_no FROM enroll WHERE s_id = '" + session_id + "')";

ResultSet rs = stmt.executeQuery(mySQL);
if(rs != null){
	int i=0;
	while(rs.next()){
		i++;
		String c_id = rs.getString("c_id");
		int c_id_no = rs.getInt("c_id_no");
		String c_name = rs.getString("c_name");
		int c_unit = rs.getInt("c_unit");
		String p_name = rs.getString("p_name");
		String t_day = rs.getString("t_day");
		String t_startTime = rs.getString("t_startTime");
		String t_endTime = rs.getString("t_endTime");
		String t_where = rs.getString("t_where");
		String startTime_hh = t_startTime.substring(0,2);
		String startTime_min = t_startTime.substring(2,4);
		String endTime_hh = t_endTime.substring(0,2);
		String endTime_min = t_endTime.substring(2,4);
		String time = t_day + " " + startTime_hh + ":" + startTime_min + " ~ " + endTime_hh + ":" + endTime_min;
		if(i%2==0){
%>		
		<tr onmouseover="this.style.background='skyblue'" onmouseout="this.style.background='white'">   <!--마우스 효과-->
<%		} else{
%>
		<tr onmouseover="this.style.background='skyblue'" onmouseout="this.style.background='#f2f2f2'">   <!--마우스 효과-->
<%		}%> 
			<td align="center"><%=c_id %></td><td align="center"><%=c_id_no %></td>
			<td align="center"><%=c_name %></td><td align="center"><%=p_name %></td>
			<td align="center"><%=time %></td><td align="center"><%=t_where %></td><td align="center"><%=c_unit %></td>
			<td align="center"><a href="delete_verify.jsp?c_id=<%=c_id %>&c_id_no=<%=c_id_no %>">취소</a></td>
	 	</tr>
 
<%
	}
} else{
%>
	<tr> <td align="center">신청한 강의가 없습니다.</td> </tr>
<%
}
stmt.close();
myConn.close();
%>

</table>


</body>
</html>