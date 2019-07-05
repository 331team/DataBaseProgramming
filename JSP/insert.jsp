<%@ page contentType="text/html; charset=UTF-8"%>
<%@ include file="dbConfig.jsp" %>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
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

<% String keyfield= request.getParameter("col"); %>
<br>
<br>
<DIV class='aside_menu' align ="center">
  <FORM name='frm' method='GET' action='./insert.jsp'>
    
      <SELECT name='col'> <!-- 검색 컬럼 -->
        <OPTION value='0'>전체</OPTION>
        <OPTION value='1'<%=keyfield.equals("1")?"selected":""%>>컴퓨터과학과</OPTION>
        <OPTION value='2'<%=keyfield.equals("2")?"selected":""%>>통계학과</OPTION>
        <OPTION value='3'<%=keyfield.equals("3")?"selected":""%>>법학부</OPTION>
        <OPTION value='4'<%=keyfield.equals("4")?"selected":""%>>경제학부</OPTION>
        <OPTION value='5'<%=keyfield.equals("5")?"selected":""%>>무용과</OPTION>
        <OPTION value='6'<%=keyfield.equals("6")?"selected":""%>>식품영양학과</OPTION>
        <OPTION value='7'<%=keyfield.equals("7")?"selected":""%>>작곡과</OPTION>
        <OPTION value='8'<%=keyfield.equals("8")?"selected":""%>>한국어문학부</OPTION>
        <OPTION value='9'<%=keyfield.equals("9")?"selected":""%>>환경디자인과</OPTION>
        <!-- <OPTION value='5'>제목+내용</OPTION>-->
      </SELECT>
      <button type='submit'>검색</button>    
    
  </FORM>
  <DIV class='menu_line' style='clear: both;'></DIV>
</DIV>

<table width="75%" align="center" border>
<br>
<tr><th>과목번호</th><th>분반</th><th>과목명</th><th>교수명</th><th>강의시간</th><th>장소</th><th>학점</th><th>신청</th>

<%
String [] major = {"모두", "컴퓨터과학과", "통계학과", "법학부", "경제학부", "무용과", "식품영양학과", "작곡과", "한국어문학부", "환경디자인과"};
int index = Integer.parseInt(keyfield);

Statement stmt = null;
try {
	stmt = myConn.createStatement();
}catch(SQLException ex){
	System.err.println("SQLException : " + ex.getMessage());
}

String mySQL = "SELECT c.c_id, c.c_id_no, c.c_name, c.c_unit, p.p_name, t.t_day, t.t_startTime, t.t_endTime, t.t_where FROM course c, teach t, professor p WHERE c.c_id = t.c_id AND c.c_id_no = t.c_id_no AND c.c_id=t.c_id AND p.p_id = t.p_id AND (c.c_id, c.c_id_no) NOT IN (SELECT c_id, c_id_no FROM enroll WHERE s_id = '" + session_id + "')";
if(index!=0){
	mySQL = mySQL + " AND p.p_major='" + major[index] + "'";
}

ResultSet rs = stmt.executeQuery(mySQL);
int i=0;
if(rs != null){
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
			<td align="center"><a href="insert_verify.jsp?c_id=<%=c_id %>&c_id_no=<%=Integer.toString(c_id_no)%>">신청</a></td>
	 	</tr>
 
<% 
	}
} else{
%>
	<tr> <td align="center">강의가 없습니다.</td> </tr>
<%
}
stmt.close();
myConn.close();

%>

</table>


</body>
</html>
