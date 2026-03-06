<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<c:set var="ctx" value="${pageContext.request.contextPath}"/>
<c:set var="pageTitle" value="Error" scope="request"/>
<jsp:include page="/WEB-INF/views/shared/_header.jsp"/>
  <div class="error-box">
    <h1>Something went wrong</h1>
    <p class="error-message"><c:out value="${errorMessage}" default="An unexpected error occurred."/></p>
    <p><a href="${ctx}/user/dashboard" class="btn">Go to Dashboard</a>
       <c:if test="${sessionScope.currentUser == null}">
         <a href="${ctx}/login" class="btn btn-secondary">Go to Login</a>
       </c:if>
    </p>
  </div>
  <style>
    .error-box { text-align: center; padding: 2rem; background: #fff; border-radius: 8px; box-shadow: 0 1px 3px rgba(0,0,0,0.1); }
    .error-box h1 { margin: 0 0 1rem; font-size: 1.5rem; color: #721c24; }
    .error-message { color: #333; margin-bottom: 1.5rem; }
    .btn { display: inline-block; padding: 0.5rem 1rem; background: #1a1a2e; color: #fff; text-decoration: none; border-radius: 4px; margin: 0 0.25rem; }
    .btn:hover { background: #16213e; }
    .btn-secondary { background: #6c757d; }
    .btn-secondary:hover { background: #5a6268; }
  </style>
<jsp:include page="/WEB-INF/views/shared/_footer.jsp"/>
