<%@ page contentType="text/html; charset=UTF-8"%>
<%@ page import="java.sql.*"%>
<%@ include file="top.jsp" %>
<%@ include file="dbConfig.jsp" %>
<html>
<head><title>강의 조회 및 변경</title></head>
<body>

<%
/*인원수*/
int max = 0;
String t_max=request.getParameter("t_max");
if(t_max==""){
%>
<script>
alert("인원수를 입력해주세요");
location.href="updateCourse.jsp";
</script>
<%
} else{
   try{
      max = Integer.parseInt(t_max); 
      System.out.println(max);
   } catch(NumberFormatException e){
%>
      <script>
      alert("숫자 형식으로 입력해주세요");
      location.href="updateCourse.jsp";
      </script>
<%      
      System.out.println(max);}
   }


   try{
       String c_id = request.getParameter("c_id");
       int c_id_no = Integer.parseInt(request.getParameter("c_id_no"));
       System.out.println(c_id+" "+c_id_no+" "+max);
       PreparedStatement pstmt = null;
       String sql = null;
       sql = "UPDATE teach set t_max=? where c_id = ? AND c_id_no = ?";
       pstmt = myConn.prepareStatement(sql);
       pstmt.setInt(1, max);
       pstmt.setString(2, c_id);
       pstmt.setInt(3, c_id_no);
       pstmt.executeUpdate();
       
   } catch(SQLException ex){
%>

<%
   }
%>
<script>
   alert("변경이 완료되었습니다.");
   location.href = "main.jsp";
</script>

</body>
