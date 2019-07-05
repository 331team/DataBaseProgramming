<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*"%>
<%@ include file="dbConfig.jsp" %>
<%@ include file="top.jsp" %>
<!DOCTYPE html>
<html>
<head></head>
<body>
<% /*과목명*/
	request.setCharacterEncoding("UTF-8");
	String name=request.getParameter("class_name");
	if(name==""){
%>
	<script>
	alert("과목명을 입력해주세요");
	location.href="insertCourse.jsp";
	</script>
<%
	} else{System.out.println(name);}
%>

<% /*학점*/
	int unit = 0;
	String class_unit=request.getParameter("class_unit");
	if(class_unit==""){
%>
	<script>
	alert("학점을 입력해주세요");
	location.href="insertCourse.jsp";
	</script>
<%
	} else{
		try{
			unit = Integer.parseInt(class_unit); 
			System.out.println(unit);
		} catch(NumberFormatException e){
%>
			<script>
			alert("숫자 형식으로 입력해주세요");
			location.href="insertCourse.jsp";
			</script>
<%		
			;
		}
	}
%>

<% /*인원수*/
	int max = 0;
	String class_max=request.getParameter("class_max");
	if(class_max==""){
%>
	<script>
	alert("인원수를 입력해주세요");
	location.href="insertCourse.jsp";
	</script>
<%
	} else{
		try{
			max = Integer.parseInt(class_max); 
			System.out.println(unit);
		} catch(NumberFormatException e){
%>
			<script>
			alert("숫자 형식으로 입력해주세요");
			location.href="insertCourse.jsp";
			</script>
<%		
			System.out.println(max);}
		}
%>

<% /*시간*/
	String start_h = request.getParameter("class_st_h");
	String start_m = request.getParameter("class_st_m");
	String end_h = request.getParameter("class_end_h");
	String end_m = request.getParameter("class_end_m");
	String start = start_h + start_m;
	String end = end_h + end_m;
	System.out.println(start);
	System.out.println(end);
%>


<% /*요일*/
	String class_day="";
	String[] days=request.getParameterValues("class_day");
	if(days==null){ /*요일 선택 안 한 경우 경고*/
%>
		<script>
		alert("요일을 선택해주세요");
		location.href="insertCourse.jsp";
		</script>
<%
	}else{
		class_day="";
		for (String day : days){
			switch(day){
			case "mon" :
				day = "월";
				break;
			case "tue" :
				day = "화";
				break;
			case "wed" :
				day = "수";
				break;
			case "thu" :
				day = "목";
				break;
			case "fri" :
				day = "금";
				break;
			}
			if(day==days[0])
				class_day = day;
			else
				class_day = class_day + day;
		}
		System.out.println(class_day);
	}
%>

<% /*강의실*/
	String where=request.getParameter("class_place");
	if(where==""){
%>
		<script>
		alert("강의실을 입력해주세요");
		location.href="insertCourse.jsp";
		</script>
<%
	} else{;}
%>

<%/*SQL*/
	String result="";
	String c_id="";
	int c_id_no=0;
	String sql1 = "{call insertCourse(?,?,?,?,?)}";
	String sql2 = "{call insertCourseVerify(?,?,?,?,?,?,?,?,?)}";
	CallableStatement cstmt = myConn.prepareCall(sql1);
	try{
		cstmt.setString(1, name);
		cstmt.setInt(2, unit);
		cstmt.setString(3, session_id);
		cstmt.registerOutParameter(4, java.sql.Types.VARCHAR);
		cstmt.registerOutParameter(5, java.sql.Types.INTEGER);
		cstmt.execute();
		c_id = cstmt.getString(4); 
		c_id_no = cstmt.getInt(5); 
		System.out.println("c_id: " + c_id + "c_id_no : " + c_id_no);
		cstmt = myConn.prepareCall(sql2);
		cstmt.setString(1, session_id);
		cstmt.setString(2, c_id);
		cstmt.setInt(3, c_id_no);
		cstmt.setString(4, class_day);
		cstmt.setString(5, start);
		cstmt.setString(6, end);
		cstmt.setString(7, where);
		cstmt.setInt(8, max);
		cstmt.registerOutParameter(9, java.sql.Types.VARCHAR);
		cstmt.execute();
		result = cstmt.getString(9); 
		System.out.println("---------------");
		System.out.println(result);
		if(!result.equals("강의 개설이 완료되었습니다") || class_day=="" || start=="" || end=="" || where=="" || max==0){
			System.out.print("delete");
			PreparedStatement pstmt = myConn.prepareStatement("DELETE FROM teach WHERE c_id=? AND c_id_no=?");
			pstmt.setString(1, c_id);
			pstmt.setInt(2, c_id_no);
			pstmt.execute();
			pstmt = myConn.prepareStatement("DELETE FROM course WHERE c_id=? AND c_id_no=?");
			pstmt.setString(1, c_id);
			pstmt.setInt(2, c_id_no);
			pstmt.execute();
%>
<%
		}
		
	} catch(Exception ex){
		System.out.println("error");		
		
	}finally{	
%>
		<script>
		alert("<%=result%>");
		location.href="updateCourse.jsp";
		</script>
<%
		
	}
%>
</body>
</html>
