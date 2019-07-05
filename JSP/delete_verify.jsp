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
		 Statement stmt = null;
		 String sql = null;
		 sql = "DELETE FROM enroll WHERE c_id='" + c_id + "' AND c_id_no=" + c_id_no;
		 stmt = myConn.prepareStatement(sql);
		 stmt.executeUpdate(sql);
		 
	} catch(SQLException ex){

%>
		<script>
			alert("오류");
			location.href = "delete.jsp";
		</script>	
<%
	}
%>
<script>
	alert("수강 취소되었습니다");
	location.href = "delete.jsp";
</script>

</body>
