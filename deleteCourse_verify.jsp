<%@ page contentType="text/html; charset=UTF-8"%>
<%@ page import="java.sql.*"%>
<%@ include file="top.jsp" %>
<%@ include file="dbConfig.jsp" %>
<html>
<head><title>수강신청</title></head>
<body>

<%

	try{
		 String c_id = request.getParameter("c_id");
		 int c_id_no = Integer.parseInt(request.getParameter("c_id_no"));
		 String sql1 = "DELETE FROM enroll WHERE c_id='" + c_id + "' AND c_id_no=" + c_id_no;
		 String sql2 = "DELETE FROM teach WHERE c_id='" + c_id + "' AND c_id_no=" + c_id_no;
		 String sql3 = "DELETE FROM course WHERE c_id='" + c_id + "' AND c_id_no=" + c_id_no;
		 Statement stmt = myConn.prepareStatement(sql1);
		 stmt.executeUpdate(sql1);
		 stmt = myConn.prepareStatement(sql2);
		 stmt.executeUpdate(sql2);
		 stmt = myConn.prepareStatement(sql3);
		 stmt.executeUpdate(sql3);
		 
	} catch(SQLException ex){
		
%>
		<script>
			alert("오류");
			location.href = "deleteCourse.jsp";
		</script>	
<%
	}
%>
<script>
	alert("수강 취소되었습니다");
	location.href = "deleteCourse.jsp";
</script>

</body>