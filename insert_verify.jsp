<%@ page contentType="text/html; charset=UTF-8"%>
<%@ page import="java.sql.*"%>
<%@ include file="top.jsp" %>
<%@ include file="dbConfig.jsp" %>
<html>
<head><title>수강신청</title></head>
<body>

<%
	String result = null;
	try{
		 String c_id = request.getParameter("c_id");
		 String c_id_no = request.getParameter("c_id_no");
		 CallableStatement cstmt = myConn.prepareCall("{call InsertEnroll(?,?,?,?)}");
		 cstmt.setString(1, session_id);
		 cstmt.setString(2, c_id);
		 cstmt.setInt(3, Integer.parseInt(c_id_no));
		 cstmt.registerOutParameter(4, java.sql.Types.VARCHAR);
		 cstmt.execute();
		 result = cstmt.getString(4); 
		 System.out.println(result);
		 %>
         <script>   
            alert("<%=result%>");
            location.href="insert.jsp?col=0";
         </script>
         <%
	} catch(SQLException ex){
%>		
		<script>
			alert("<%=result%>");
			location.href = "insert.jsp?col=0";
		</script>		
<%
	}
%>
<script>
	alert(<%=result%>);
	location.href = "insert.jsp?col=0";
</script>

</body>