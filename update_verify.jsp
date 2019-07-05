<%@ page contentType="text/html; charset=UTF-8"%>
<%@ page import="java.sql.*"%>
<%@ include file="top.jsp" %>
<%@ include file="dbConfig.jsp" %>
<html>
<head><title>수강신청 사용자 정보 수정</title></head>
<body>

<%

	try{
		 String pwd = request.getParameter("userpw");
		 PreparedStatement pstmt = null;
		 String sql = null;
		 if(isStudent)
		 	sql = "UPDATE student set s_pwd=? where s_id = ?";
		 else
			sql = "UPDATE professor set p_pwd=? where p_id = ?";
		 pstmt = myConn.prepareStatement(sql);
		 pstmt.setString(1, pwd);
		 pstmt.setString(2, session_id);
		 pstmt.executeUpdate();
		 
	} catch(SQLException ex){
		String sMessage;
		if(ex.getErrorCode()==20002) sMessage="암호는 4자리 이상이어야 합니다";
		else if(ex.getErrorCode()==20003) sMessage="암호에 공간은 입력되지 않습니다";
		else sMessage="잠시 후 다시 시도하십시오";
%>
		<script>
			alert("<%= sMessage %>");
			location.href = "update.jsp";
		</script>	
<%
	}
%>
<script>
	alert("변경이 완료되었습니다.");
	location.href = "main.jsp";
</script>

</body>
