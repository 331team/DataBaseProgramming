<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
 <%@ page import="java.sql.*"%>
<%@ include file="dbConfig.jsp" %>
<!DOCTYPE html>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<link href="http://fonts.googleapis.com/earlyaccess/jejugothic.css" rel="stylesheet">
<title>시간표</title>
<style>
.table_style1 {
   width: 750px;
   margin-left: auto;
   margin-right: auto;
   font-family: 'Jeju Gothic', sans-serif;
}
.table_style1{
   width: 620px;
   margin-top: 20px;
   text-align: center;
}
button { width: 80px; height: 25px; }
div{
   border: 1px solid;
   text-align: center;
   font-family: 'Jeju Gothic', sans-serif;
}
option{
   font-family: 'Jeju Gothic', sans-serif;
}
.schedule {
   position: relative; 
   width: 620px; 
   margin-left: auto;
   margin-right: auto;
   border-color: #D8D8D8;
   font-size:15px;
}
.time{
   width:20px;
   height:78px;
   border-color: #D8D8D8;
}
.course{
   width: 120px;
   position: absolute;
   border-color: #D8D8D8;
}
</style>
</head>
<body>
<%@ include file="top.jsp" %>


<%!
public int getDayValue(String str){
   if(str.equals("월"))
      return 0;
   else if(str.equals("화"))
      return 1;
   else if(str.equals("수"))
      return 2;
   else if(str.equals("목"))
      return 3;
   else if(str.equals("금"))
      return 4;
   else return -1;
}
%>
<% if(session_id == null) response.sendRedirect("login.jsp"); %>
<%
String studentID = session_id;

String date = (new java.util.Date()).toLocaleString();

System.out.println(date);
int year = Integer.parseInt(date.substring(0,4)); int semester = Integer.parseInt(date.substring(6,7));
if(semester>=11 && year<=4)
   semester = 1;
else semester = 2;
System.out.println("semester: " + semester + "   year: " + year);

int totalEnrolledClass = 0;
int totalEnrolledUnit = 0;
String color[] = {"#00d0ff", "#00a9ff", "#0083ff", "#0061ff", "#002aff", "#3b00ff", "#00ffff", "#2252d6"};

Statement stmt = myConn.createStatement();
String mySQL = "select * from enroll where s_id = '" + studentID + "' and e_year = " + year + " and e_semester = " + semester;
ResultSet myResultSet = stmt.executeQuery(mySQL);
%>
<table align="center" class="table_style1">
   <tr>
   <td><pre>년도: <%=year %>     학기: <%=semester %></pre></td></tr></table>
<script>
   document.getElementById("yearSelect").value = <%= year%>;
   document.getElementById("semesterSelect").value = <%= semester %>;
</script>
<table border= "1" class="table_style1">
   <tr><td width="2px"></td><td>월</td><td>화</td><td>수</td><td>목</td><td>금</td></tr>
</table>
<div class="schedule">
<%
   int endHr = 14;
   int y = 0;
   while(myResultSet.next() != false){
      String c_id="", c_id_no="", c_name="", t_day="", t_startTime="", t_endTime="", t_where="";
      int c_unit=0;
      c_id = myResultSet.getString("c_id");
      c_id_no = myResultSet.getString("c_id_no");
      Statement stmt2 = myConn.createStatement();
      String mySQL2 = "select * from course where c_id = '" + c_id + "' and c_id_no = '" + c_id_no + "'";
      ResultSet myResultSet2 = stmt2.executeQuery(mySQL2);
      if(myResultSet2.next()){
         c_name =  myResultSet2.getString("c_name");
         c_unit =  myResultSet2.getInt("c_unit");
      }else{
         %>course table을 불러올 수 없음<%
         break;
      }
      
      mySQL2 = "select * from teach where c_id='" + c_id + "' and c_id_no = '" + c_id_no + "' and t_year = " + year + " and t_semester = " + semester;
      myResultSet2 = stmt2.executeQuery(mySQL2);
      if(myResultSet2.next()){
         t_day =  myResultSet2.getString("t_day");
         t_startTime =  myResultSet2.getString("t_startTime");
         t_endTime =  myResultSet2.getString("t_endTime");
         t_where =  myResultSet2.getString("t_where");
      }else{
         %>teach table을 불러올 수 없음<%
         break;
      }
      //시작시간 : 시
      int hr = Integer.parseInt(t_startTime.substring(0,2))*60;
      //시작시간 : 분
      int min = Integer.parseInt(t_startTime.substring(2,4));
      int startTime = (hr+min-540)/15;
      
      if(endHr < hr/60)
         endHr = hr/60 + 3;
      hr = Integer.parseInt(t_endTime)/100*60;
      min = Integer.parseInt(t_endTime)%100;
      int endTime = (hr+min-540)/15;
      
      int startPos = (startTime)*20;
      int height = (endTime - startTime)*20;
      
      int len = t_day.length();
      for(int i=0; i<len; i+=1){
         int dayPos = 20 + 120*getDayValue(t_day.substring(i, i+1));
         %><div class="course" style="top:<%=startPos%>px; left:<%=dayPos%>px; height:<%=height%>px; 
         background-color:<%=color[totalEnrolledClass%8]%>">
            <br><%=c_name%><br><%=t_where%><br><%=t_startTime%><br><%=t_endTime%>
         </div><%
      }
      totalEnrolledClass += 1;
      totalEnrolledUnit += c_unit;
   }
   for(int i=9; i<=endHr; i++){%>
   <div class="time" style="top:<%=y%>; left:0;"><%=i%></div><%
      y += 80;
}
%> 
</div>
<table>
   <tr><td width= "65%"></td><td>총 수강과목: <%= totalEnrolledClass %></td><td>총 수강학점: <%= totalEnrolledUnit %></td></tr>
</table>

</body>
</html>