<%@ page language="java" contentType="text/html; charset=UTF-8"%>
<%@ page import="java.sql.*"%>
<%
	String dbdriver = "oracle.jdbc.driver.OracleDriver";
	String dburl = "jdbc:oracle:thin:@localhost:1521:orcl";
	String user = "db17331";
	String password = "ora";
	Class.forName(dbdriver);
	Connection myConn=DriverManager.getConnection(dburl, user, password);
%>