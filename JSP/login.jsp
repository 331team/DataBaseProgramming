<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head> <meta charset="UTF-8">
<title>수강신청 시스템 로그인</title> 
<link href="http://fonts.googleapis.com/earlyaccess/jejugothic.css" rel="stylesheet">
<style>
table {
    border-collapse: collapse;
  }
th, td {
    align: center;
    padding: 10px;
  }
  

 tr:nth-child(even){background-color: #f2f2f2}
  th {
  background-color: #0061ff;
  color: white;
}
.pass{
   font-family : gothic;
}
</style>
</head>
<body>
<%@ include file="top.jsp" %>
<br><br>
<table width="50%" align="center" bgcolor="#0061ff" >
<tr> <td style="color:white;"><div align="center">아이디와 패스워드를 입력하세요 </div></td>
</table>
<table width="50%"  align="center">
<form method="post" action="login_verify.jsp">
<tr>
<td><div align="center">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;아이디</div></td>
<td><div align="center">
<input type="text" name="userID">
</div></td>
</tr>
<tr>
<td><div align="center">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;패스워드</div></td>
<td><div align="center">
<input type="password" name="userPassword" class="pass">
</div></td></tr>
<tr>
<td colspan=2><div align="center">
<INPUT TYPE="SUBMIT" NAME="Submit" VALUE="로그인"> 
<INPUT TYPE="RESET" VALUE="취소">
</div></td></tr>
</form>
</table>
</body>
</html>
