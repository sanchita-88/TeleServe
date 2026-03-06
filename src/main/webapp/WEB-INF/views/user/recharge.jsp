<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<c:set var="ctx" value="${pageContext.request.contextPath}"/>
<c:set var="pageTitle" value="Recharge" scope="request"/>
<jsp:include page="/WEB-INF/views/shared/_header.jsp"/>
  <h1>Choose a plan</h1>
  <c:if test="${not empty errorMessage}">
    <div class="flash error"><c:out value="${errorMessage}"/></div>
  </c:if>

  <div class="plans-grid">
    <c:forEach var="plan" items="${plans}">
      <div class="plan-card">
        <h2><c:out value="${plan.name}"/></h2>
        <p class="plan-price"><fmt:formatNumber value="${plan.price}" type="currency" currencyCode="INR"/></p>
        <p><strong>Data:</strong> <c:out value="${plan.dataGb}"/> GB</p>
        <p><strong>Validity:</strong> <c:out value="${plan.validityDays}"/> days</p>
        <c:if test="${not empty plan.category}">
          <p><strong>Category:</strong> <c:out value="${plan.category}"/></p>
        </c:if>
        <form method="post" action="${ctx}/user/recharge" class="plan-form">
          <input type="hidden" name="planId" value="${plan.planId}"/>
          <button type="submit" class="btn">Recharge</button>
        </form>
      </div>
    </c:forEach>
  </div>

  <c:if test="${empty plans}">
    <p class="empty-msg">No plans available at the moment.</p>
  </c:if>

  <style>
    .plans-grid { display: grid; grid-template-columns: repeat(auto-fill, minmax(240px, 1fr)); gap: 1.5rem; margin-top: 1rem; }
    .plan-card { background: #fff; border-radius: 8px; padding: 1.25rem; box-shadow: 0 1px 3px rgba(0,0,0,0.1); display: flex; flex-direction: column; }
    .plan-card h2 { margin: 0 0 0.5rem; font-size: 1.2rem; color: #1a1a2e; }
    .plan-price { font-size: 1.25rem; font-weight: 700; margin: 0 0 1rem; color: #0f3460; }
    .plan-card p { margin: 0.35rem 0; font-size: 0.95rem; }
    .plan-form { margin-top: auto; padding-top: 1rem; }
    .plan-form .btn { width: 100%; padding: 0.6rem 1rem; background: #1a1a2e; color: #fff; border: none; border-radius: 4px; font-size: 1rem; cursor: pointer; }
    .plan-form .btn:hover { background: #16213e; }
    .empty-msg { margin-top: 1rem; color: #666; }
  </style>
<jsp:include page="/WEB-INF/views/shared/_footer.jsp"/>
