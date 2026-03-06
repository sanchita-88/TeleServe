<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<c:set var="ctx" value="${pageContext.request.contextPath}"/>
<c:set var="pageTitle" value="Admin Dashboard" scope="request"/>
<jsp:include page="/WEB-INF/views/shared/_header.jsp"/>
  <h1>Admin dashboard</h1>

  <div class="stats-grid">
    <section class="stat-card">
      <h2>Total users</h2>
      <p class="stat-value"><c:out value="${stats.totalUsers}"/></p>
    </section>
    <section class="stat-card">
      <h2>Total recharges</h2>
      <p class="stat-value"><c:out value="${stats.totalRecharges}"/></p>
    </section>
    <section class="stat-card">
      <h2>Total revenue</h2>
      <p class="stat-value"><fmt:formatNumber value="${stats.totalRevenue}" type="currency" currencyCode="INR"/></p>
    </section>
  </div>

  <style>
    .stats-grid { display: grid; grid-template-columns: repeat(auto-fill, minmax(200px, 1fr)); gap: 1.5rem; margin-top: 1rem; }
    .stat-card { background: #fff; border-radius: 8px; padding: 1.5rem; box-shadow: 0 1px 3px rgba(0,0,0,0.1); }
    .stat-card h2 { margin: 0 0 0.5rem; font-size: 1rem; font-weight: 600; color: #666; }
    .stat-value { margin: 0; font-size: 1.75rem; font-weight: 700; color: #1a1a2e; }
  </style>
<jsp:include page="/WEB-INF/views/shared/_footer.jsp"/>
