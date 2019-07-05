<%@ page contentType="text/html; charset=UTF-8"%>
<%@ page import="java.sql.*"%>
<%@ include file="dbConfig.jsp" %>

<html>
<head><title>수강신청 사용자 정보 수정</title>
<style>
#userpw{
   font-family : gothic;
}
</style>
</head>
<body>
<%@ include file="top.jsp" %>
<div id="containerwrap" style="width:60%; margin : 0 auto;">
   <div id="container">
      <div class="section_title">
         <h1 align = "center">
            <span>회원 정보 수정</span>
         </h1>
      </div>
      <div id="content" class="login">
         <div class="login_box">
            <form method="post" action="update_verify.jsp">
               <fieldset>
                  <div width="40%">
                     <h2 align="center">회원 정보 수정을 위해 정보를 입력해주세요.</h2>
                     <table class="inputTable" align="center" width="50%" border="center">
                        <%
                        String pwd = null;
                        String name = null;
                        String major = null;
                        String mySQL = null;
                        ResultSet rs;
                        Statement stmt = myConn.createStatement();
                        if(session_id==null){
                        %>
                        <script>
                           alert("로그인이 필요합니다.");
                           location.href = "login.jsp";
                        </script>
                        <%
                        }else{
                           if(isStudent){ /*학생*/
                              mySQL = "select s_pwd,s_name, s_major from student where s_id='" + session_id + "'";
                              rs = stmt.executeQuery(mySQL);
                              if(rs != null){
                                 if(rs.next()){
                                    pwd = rs.getString("s_pwd");
                                    name = rs.getString("s_name");
                                    major = rs.getString("s_major");
                                 }
                              }
                           } else{ /*교수*/
                              mySQL = "select p_pwd, p_name, p_major from professor where p_id='" + session_id + "'";
                              rs = stmt.executeQuery(mySQL);
                              if(rs != null){
                                 if(rs.next()){
                                    pwd = rs.getString("p_pwd");
                                    name = rs.getString("p_name");
                                    major = rs.getString("p_major");
                                 }
                              }
                           }
                        }
                        %>
                        <tbody>
                        <tr>
                        <td width="30%">학번</td>
                        <td width="70%" class="input"><%=session_id %><input type="hidden"
                                                      id ="userid" name="userid" title="아이디" value="<%=session_id %>"
                                                      /></td>
                        </tr>
                        <tr>
                           <td>비밀번호</td>
                           <td class="input"><input type="password" id="userpw"
                                             name="userpw" title="비밀번호"
                                             value="<%=pwd%>"/></td>
                        </tr>
                        <tr>
                           <td>이름</td>
                           <td class="input"><%=name %><input type="hidden" id="usermajor"
                                             name="usermajor" title="이름" value="<%=name %>"
                                              readonly/></td>
                        </tr>
                        <tr>
                           <td>전공</td>
                           <td class="input"><%=major %><input type="hidden" id="usermajor"
                                             name="usermajor" title="전공" value="<%=major %>"
                                              readonly/></td>
                        </tr>
                        <tr>
                           <td  align="center" colspan="2"><input type="submit" value="수정 완료">&nbsp;&nbsp;&nbsp;<input type="reset" value="취소" style="width :70px;"></td>
                        </tr>
                        </tbody>
                     </table>
                  
                  </div>
               </fieldset>
               
               <%
               stmt.close();
               myConn.close();
               %>
            </form>
         </div>
      </div>
   </div>
</div>


</body>


</html>
