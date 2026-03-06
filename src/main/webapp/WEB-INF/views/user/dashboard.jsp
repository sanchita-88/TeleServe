<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<c:set var="ctx" value="${pageContext.request.contextPath}"/>
<c:set var="pageTitle" value="Dashboard" scope="request"/>
<jsp:include page="/WEB-INF/views/shared/_header.jsp"/>
  <h1>My Dashboard</h1>

  <div class="dashboard-grid">
    <section class="card user-card">
      <h2>Account</h2>
      <dl>
        <dt>Name</dt>
        <dd><c:out value="${user.fullName}"/></dd>
        <dt>Email</dt>
        <dd><c:out value="${user.email}"/></dd>
        <dt>Phone</dt>
        <dd><c:out value="${user.phone}"/></dd>
      </dl>
    </section>

    <section class="card plan-card">
      <h2>Current plan</h2>
      <c:choose>
        <c:when test="${not empty currentPlan}">
          <p class="plan-name"><c:out value="${currentPlan.name}"/></p>
          <p><strong>Data:</strong> <c:out value="${currentPlan.dataGb}"/> GB</p>
          <p><strong>Validity:</strong> <c:out value="${currentPlan.validityDays}"/> days</p>
          <p><strong>Price:</strong> <fmt:formatNumber value="${currentPlan.price}" type="currency" currencyCode="INR"/></p>
          <a href="${ctx}/user/recharge" class="btn btn-small">Change plan</a>
        </c:when>
        <c:otherwise>
          <p>No active plan.</p>
          <a href="${ctx}/user/recharge" class="btn btn-small">Choose a plan</a>
        </c:otherwise>
      </c:choose>
    </section>

    <section class="card usage-card">
      <h2>Data usage</h2>
      <p class="usage-avg">Daily average: <strong><fmt:formatNumber value="${dailyAvgUsageGb}" maxFractionDigits="2"/> GB</strong></p>
      <div class="progress-wrap">
        <span class="progress-label">Plan utilization</span>
        <div class="progress-bar" role="progressbar" aria-valuenow="${utilizationPercent}" aria-valuemin="0" aria-valuemax="100">
          <div class="progress-fill" style="width: ${utilizationPercent}%;"></div>
        </div>
        <span class="progress-value"><fmt:formatNumber value="${utilizationPercent}" maxFractionDigits="1"/>%</span>
      </div>
    </section>

    <c:if test="${not empty suggestedPlan}">
      <section class="card suggestion-card">
        <h2>Suggested plan</h2>
        <p class="plan-name"><c:out value="${suggestedPlan.name}"/></p>
        <p><strong>Data:</strong> <c:out value="${suggestedPlan.dataGb}"/> GB</p>
        <p><strong>Validity:</strong> <c:out value="${suggestedPlan.validityDays}"/> days</p>
        <p><strong>Price:</strong> <fmt:formatNumber value="${suggestedPlan.price}" type="currency" currencyCode="INR"/></p>
        <form method="post" action="${ctx}/user/recharge" class="inline-form">
          <input type="hidden" name="planId" value="${suggestedPlan.planId}"/>
          <button type="submit" class="btn btn-small">Recharge with this plan</button>
        </form>
      </section>
    </c:if>
  </div>

  <style>
    .dashboard-grid { display: grid; grid-template-columns: repeat(auto-fill, minmax(260px, 1fr)); gap: 1.5rem; margin-top: 1rem; }
    .card { background: #fff; border-radius: 8px; padding: 1.25rem; box-shadow: 0 1px 3px rgba(0,0,0,0.1); }
    .card h2 { margin: 0 0 1rem; font-size: 1.1rem; color: #1a1a2e; border-bottom: 1px solid #eee; padding-bottom: 0.5rem; }
    .card dl { margin: 0; }
    .card dt { font-size: 0.8rem; color: #666; margin-top: 0.5rem; }
    .card dd { margin: 0.15rem 0 0; }
    .plan-name { font-weight: 600; margin: 0 0 0.5rem; }
    .card p { margin: 0.35rem 0; }
    .btn { display: inline-block; padding: 0.5rem 1rem; background: #1a1a2e; color: #fff; text-decoration: none; border-radius: 4px; border: none; font-size: 0.9rem; cursor: pointer; margin-top: 0.75rem; }
    .btn:hover { background: #16213e; }
    .btn-small { padding: 0.4rem 0.75rem; font-size: 0.85rem; }
    .usage-avg { margin-bottom: 0.75rem; }
    .progress-wrap { display: flex; flex-wrap: wrap; align-items: center; gap: 0.5rem; }
    .progress-label { flex: 0 0 100%; font-size: 0.9rem; color: #666; }
    .progress-bar { flex: 1; min-width: 120px; height: 1.25rem; background: #e9ecef; border-radius: 4px; overflow: hidden; }
    .progress-fill { height: 100%; background: #1a1a2e; border-radius: 4px; transition: width 0.2s ease; }
    .progress-value { font-weight: 600; min-width: 3ch; }
    .inline-form { margin-top: 0.75rem; }
  </style>
<jsp:include page="/WEB-INF/views/shared/_footer.jsp"/>
