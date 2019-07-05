<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*"%>
<%@ include file="dbConfig.jsp" %>
<%


String userID=request.getParameter("userID");
String userPassword=request.getParameter("userPassword");

//...

Statement stmt = myConn.createStatement();
//...
String mySQL="select s_id from student where s_id='" + userID + "'and s_pwd='" + userPassword + "'";

//...
ResultSet rs = stmt.executeQuery(mySQL);

if(rs.next()){	/*학생인 경우*/
	session.setAttribute("user", userID); 
	session.setAttribute("student", true);
	response.sendRedirect("main.jsp"); 
}
else{	/*교수인 경우*/
	mySQL="select p_id from professor where p_id='" + userID + "'and p_pwd='" + userPassword + "'";
	rs = stmt.executeQuery(mySQL);
	if(rs.next()){
		session.setAttribute("user", userID); 
		session.setAttribute("student", false);
		response.sendRedirect("main.jsp");
	}
	else response.sendRedirect("login.jsp");
}
rs.close();
stmt.close();
myConn.close();
%>
