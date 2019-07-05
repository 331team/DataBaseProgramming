<%@ page contentType="text/html; charset=UTF-8"%>
<%@ include file="dbConfig.jsp" %>
<!DOCTYPE html>
<html>
   <head>
      <meta charset="EUC-KR">
      <title>강의 개설</title>
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
   <table width="75%" align="center" id="p_insert_table" style="font-size:12px">
      <br>
         <tr>
            <th style="padding-top: 1%; padding-bottom: 1%;">과목명</th>
            <th>학점</th>
            <th>인원</th>
            <th>요일</th>
            <th>시간</th>
            <th>장소</th>
         </tr>
         <tr></tr><tr></tr><tr></tr>
         <tr></tr><tr></tr><tr></tr>
         <tr>
         <form action="insertCourse_verify.jsp" method="post">
            <td align="center"><input type="text" name="class_name" id="in"></td>
            <td align="center"><input type="text" style="width:50px;" name="class_unit" id="in"></td>
            <td align="center"><input type="text" name="class_max" style="width:50px;" id="in"></td>
            <td align="center">
               <input type="checkbox" name="class_day" id="day" value="mon">월
               <input type="checkbox" name="class_day" id="day" value="tue">화 
               <input type="checkbox" name="class_day" id="day" value="wed">수 
               <input type="checkbox" name="class_day" id="day" value="thu">목 
               <input type="checkbox" name="class_day" id="day" value="fri">금
            </td>
            <td align="center">
                  <input type="text" name="class_st_h" id="time" style="font-size: 1em; width:25pt;" placeholder="09">
                  :
                  <input type="text" name="class_st_m" id="time" style="font-size: 1em; width:25pt;" placeholder="00">
                  ~
                  <input type="text" name="class_end_h" id="time" style="font-size: 1em; width:25pt;" placeholder="10">
                  :
                  <input type="text" name="class_end_m" id="time" style="font-size: 1em; width:25pt;" placeholder="00">
            </td> 
            <td align="center"><input type="text" name="class_place" id="in" style="width:100px" placeholder="명신관000"></td>   
         </tr>
         <tr></tr>
         <tr></tr>
         <tr>
            <td colspan="6" align="center"><input type="submit" value="개설" id="in_b">
            <input type="reset" value="취소" id="in_b">
            </td>
         </form>
         </tr>
         </table>
</body>
</html>
