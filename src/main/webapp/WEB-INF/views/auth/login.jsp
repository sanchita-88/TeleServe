<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<c:set var="ctx" value="${pageContext.request.contextPath}"/>
<c:set var="pageTitle" value="Login" scope="request"/>
<jsp:include page="/WEB-INF/views/shared/_header.jsp"/>
  <div class="auth-card">
    <h1>Sign in</h1>
    <c:if test="${not empty errorMessage}">
      <div class="flash error"><c:out value="${errorMessage}"/></div>
    </c:if>
    <form method="post" action="${ctx}/login" class="auth-form">
      <label for="email">Email</label>
      <input type="email" id="email" name="email" required autocomplete="email" placeholder="you@example.com"/>
      <label for="password">Password</label>
      <input type="password" id="password" name="password" required autocomplete="current-password"/>
      <button type="submit" class="btn">Sign in</button>
    </form>
    <p class="auth-link">Don't have an account? <a href="${ctx}/register">Register</a></p>
  </div>
  <style>
    .auth-card { max-width: 360px; margin: 2rem auto; padding: 2rem; background: #fff; border-radius: 8px; box-shadow: 0 1px 3px rgba(0,0,0,0.1); }
    .auth-card h1 { margin: 0 0 1.5rem; font-size: 1.5rem; }
    .auth-form { display: flex; flex-direction: column; gap: 1rem; }
    .auth-form label { font-weight: 500; }
    .auth-form input { padding: 0.5rem 0.75rem; border: 1px solid #ccc; border-radius: 4px; font-size: 1rem; }
    .auth-form input:focus { outline: none; border-color: #1a1a2e; }
    .auth-form .btn { padding: 0.6rem 1rem; background: #1a1a2e; color: #fff; border: none; border-radius: 4px; font-size: 1rem; cursor: pointer; margin-top: 0.25rem; }
    .auth-form .btn:hover { background: #16213e; }
    .auth-link { margin-top: 1.5rem; text-align: center; color: #666; }
    .auth-link a { color: #1a1a2e; }
  </style>
<jsp:include page="/WEB-INF/views/shared/_footer.jsp"/>
