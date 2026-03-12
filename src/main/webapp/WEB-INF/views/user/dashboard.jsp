<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<c:set var="ctx" value="${pageContext.request.contextPath}"/>
<c:set var="pageTitle" value="Dashboard — TeleServe" scope="request"/>
<jsp:include page="/WEB-INF/views/shared/_header.jsp"/>

  <div class="dash-header" style="animation: fadeInUp 0.5s ease-out both;">
    <div>
      <h1 class="page-title">My Dashboard</h1>
      <p class="page-subtitle">Welcome back, <c:out value="${user.fullName}"/></p>
    </div>
  </div>

  <div class="dashboard-grid">

    <section class="card account-card" style="animation: fadeInUp 0.6s ease-out both; animation-delay: 0.1s;">
      <div class="card-header">
        <div class="card-header-icon icon-account">
          <svg width="20" height="20" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"><path d="M20 21v-2a4 4 0 0 0-4-4H8a4 4 0 0 0-4 4v2"/><circle cx="12" cy="7" r="4"/></svg>
        </div>
        <h2>Account</h2>
      </div>
      <div class="account-info">
        <div class="account-avatar">${fn:substring(user.fullName, 0, 1)}</div>
        <div class="account-details">
          <div class="account-row">
            <span class="account-label">Name</span>
            <span class="account-value"><c:out value="${user.fullName}"/></span>
          </div>
          <div class="account-row">
            <span class="account-label">Email</span>
            <span class="account-value"><c:out value="${user.email}"/></span>
          </div>
          <div class="account-row">
            <span class="account-label">Phone</span>
            <span class="account-value"><c:out value="${user.phone}"/></span>
          </div>
        </div>
      </div>
    </section>

    <section class="card plan-card" style="animation: fadeInUp 0.6s ease-out both; animation-delay: 0.15s;">
      <div class="card-header">
        <div class="card-header-icon icon-plan">
          <svg width="20" height="20" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"><rect x="2" y="7" width="20" height="14" rx="2" ry="2"/><path d="M16 21V5a2 2 0 0 0-2-2h-4a2 2 0 0 0-2 2v16"/></svg>
        </div>
        <h2>Current Plan</h2>
      </div>
      <c:choose>
        <c:when test="${not empty currentPlan}">
          <div class="plan-highlight">
            <span class="plan-name"><c:out value="${currentPlan.name}"/></span>
            <span class="plan-price"><fmt:formatNumber value="${currentPlan.price}" type="currency" currencyCode="INR"/></span>
          </div>
          <div class="plan-details">
            <div class="plan-detail">
              <svg width="16" height="16" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"><path d="M21 16V8a2 2 0 0 0-1-1.73l-7-4a2 2 0 0 0-2 0l-7 4A2 2 0 0 0 3 8v8a2 2 0 0 0 1 1.73l7 4a2 2 0 0 0 2 0l7-4A2 2 0 0 0 21 16z"/></svg>
              <span><c:out value="${currentPlan.dataGb}"/> GB Data</span>
            </div>
            <div class="plan-detail">
              <svg width="16" height="16" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"><rect x="3" y="4" width="18" height="18" rx="2" ry="2"/><line x1="16" y1="2" x2="16" y2="6"/><line x1="8" y1="2" x2="8" y2="6"/><line x1="3" y1="10" x2="21" y2="10"/></svg>
              <span><c:out value="${currentPlan.validityDays}"/> Days Validity</span>
            </div>
          </div>
          <a href="${ctx}/user/recharge" class="btn-change">
            Change plan
            <svg width="16" height="16" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"><path d="M5 12h14"/><path d="m12 5 7 7-7 7"/></svg>
          </a>
        </c:when>
        <c:otherwise>
          <div class="empty-plan">
            <svg width="40" height="40" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="1.5" stroke-linecap="round" stroke-linejoin="round"><rect x="2" y="7" width="20" height="14" rx="2" ry="2"/><path d="M16 21V5a2 2 0 0 0-2-2h-4a2 2 0 0 0-2 2v16"/></svg>
            <p>No active plan</p>
            <a href="${ctx}/user/recharge" class="btn-change">
              Choose a plan
              <svg width="16" height="16" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"><path d="M5 12h14"/><path d="m12 5 7 7-7 7"/></svg>
            </a>
          </div>
        </c:otherwise>
      </c:choose>
    </section>

    <section class="card usage-card" style="animation: fadeInUp 0.6s ease-out both; animation-delay: 0.2s;">
      <div class="card-header">
        <div class="card-header-icon icon-usage">
          <svg width="20" height="20" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"><polyline points="22 12 18 12 15 21 9 3 6 12 2 12"/></svg>
        </div>
        <h2>Data Usage</h2>
      </div>
      <div class="usage-stat">
        <span class="usage-label">Daily Average</span>
        <span class="usage-value"><fmt:formatNumber value="${dailyAvgUsageGb}" maxFractionDigits="2"/> GB</span>
      </div>
      <div class="progress-section">
        <div class="progress-top">
          <span class="progress-label">Plan Utilization</span>
          <span class="progress-value"><fmt:formatNumber value="${utilizationPercent}" maxFractionDigits="1"/>%</span>
        </div>
        <div class="progress-bar" role="progressbar" aria-valuenow="${utilizationPercent}" aria-valuemin="0" aria-valuemax="100" style="--progress-width: ${utilizationPercent}%;">
          <div class="progress-fill"></div>
        </div>
        <div class="progress-hint">
          <c:choose>
            <c:when test="${utilizationPercent < 50}">
              <span class="hint-good">Plenty of data remaining</span>
            </c:when>
            <c:when test="${utilizationPercent < 80}">
              <span class="hint-warn">Usage is moderate</span>
            </c:when>
            <c:otherwise>
              <span class="hint-high">Running low on data</span>
            </c:otherwise>
          </c:choose>
        </div>
      </div>
    </section>

    <c:if test="${not empty suggestedPlan}">
      <section class="card suggestion-card" style="animation: fadeInUp 0.6s ease-out both; animation-delay: 0.25s;">
        <div class="card-header">
          <div class="card-header-icon icon-suggest">
            <svg width="20" height="20" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"><polygon points="12 2 15.09 8.26 22 9.27 17 14.14 18.18 21.02 12 17.77 5.82 21.02 7 14.14 2 9.27 8.91 8.26 12 2"/></svg>
          </div>
          <h2>Recommended</h2>
          <span class="suggest-badge">For You</span>
        </div>
        <div class="plan-highlight">
          <span class="plan-name"><c:out value="${suggestedPlan.name}"/></span>
          <span class="plan-price"><fmt:formatNumber value="${suggestedPlan.price}" type="currency" currencyCode="INR"/></span>
        </div>
        <div class="plan-details">
          <div class="plan-detail">
            <svg width="16" height="16" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"><path d="M21 16V8a2 2 0 0 0-1-1.73l-7-4a2 2 0 0 0-2 0l-7 4A2 2 0 0 0 3 8v8a2 2 0 0 0 1 1.73l7 4a2 2 0 0 0 2 0l7-4A2 2 0 0 0 21 16z"/></svg>
            <span><c:out value="${suggestedPlan.dataGb}"/> GB Data</span>
          </div>
          <div class="plan-detail">
            <svg width="16" height="16" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"><rect x="3" y="4" width="18" height="18" rx="2" ry="2"/><line x1="16" y1="2" x2="16" y2="6"/><line x1="8" y1="2" x2="8" y2="6"/><line x1="3" y1="10" x2="21" y2="10"/></svg>
            <span><c:out value="${suggestedPlan.validityDays}"/> Days Validity</span>
          </div>
        </div>
        <form method="post" action="${ctx}/user/recharge" class="inline-form">
          <input type="hidden" name="planId" value="${suggestedPlan.planId}"/>
          <button type="submit" class="btn-recharge">
            <svg width="16" height="16" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"><polyline points="13 2 3 14 12 14 11 22 21 10 12 10 13 2"/></svg>
            Recharge Now
          </button>
        </form>
      </section>
    </c:if>

  </div>

  <style>
    .dash-header {
      display: flex;
      align-items: flex-start;
      justify-content: space-between;
      flex-wrap: wrap;
      gap: 1rem;
      margin-bottom: 0.5rem;
    }

    .dashboard-grid {
      display: grid;
      grid-template-columns: repeat(auto-fill, minmax(280px, 1fr));
      gap: 1.25rem;
      margin-top: 1rem;
    }

    .card-header {
      display: flex;
      align-items: center;
      gap: 0.75rem;
      margin-bottom: 1.25rem;
      padding-bottom: 1rem;
      border-bottom: 1px solid var(--border);
    }

    .card-header h2 {
      font-family: 'Plus Jakarta Sans', sans-serif;
      font-size: 1rem;
      font-weight: 700;
      color: var(--text);
      margin: 0;
      flex: 1;
    }

    .card-header-icon {
      width: 36px; height: 36px;
      border-radius: 10px;
      display: flex;
      align-items: center;
      justify-content: center;
      flex-shrink: 0;
    }

    .icon-account { background: rgba(79,70,229,0.08); color: var(--primary); }
    .icon-plan { background: rgba(245,158,11,0.08); color: #f59e0b; }
    .icon-usage { background: rgba(6,182,212,0.08); color: #06b6d4; }
    .icon-suggest { background: rgba(16,185,129,0.08); color: #10b981; }

    .account-info { display: flex; gap: 1rem; align-items: flex-start; }

    .account-avatar {
      width: 48px; height: 48px;
      border-radius: 12px;
      background: linear-gradient(135deg, var(--primary), var(--accent));
      color: #fff;
      font-size: 1.2rem;
      font-weight: 700;
      display: flex;
      align-items: center;
      justify-content: center;
      flex-shrink: 0;
      text-transform: uppercase;
    }

    .account-details { flex: 1; }

    .account-row { display: flex; flex-direction: column; margin-bottom: 0.6rem; }
    .account-row:last-child { margin-bottom: 0; }

    .account-label {
      font-size: 0.7rem;
      font-weight: 600;
      color: var(--text-light);
      text-transform: uppercase;
      letter-spacing: 0.04em;
    }

    .account-value { font-size: 0.9rem; font-weight: 500; color: var(--text); margin-top: 0.1rem; }

    .plan-highlight {
      display: flex;
      align-items: center;
      justify-content: space-between;
      margin-bottom: 1rem;
    }

    .plan-name {
      font-family: 'Plus Jakarta Sans', sans-serif;
      font-size: 1.1rem;
      font-weight: 700;
      color: var(--text);
    }

    .plan-price {
      font-family: 'Plus Jakarta Sans', sans-serif;
      font-size: 1.25rem;
      font-weight: 800;
      color: var(--primary);
    }

    .plan-details { display: flex; flex-direction: column; gap: 0.5rem; margin-bottom: 1rem; }

    .plan-detail {
      display: flex;
      align-items: center;
      gap: 0.5rem;
      font-size: 0.875rem;
      color: var(--text-muted);
    }

    .plan-detail svg { color: var(--text-light); }

    .btn-change {
      display: inline-flex;
      align-items: center;
      gap: 0.4rem;
      padding: 0.5rem 1rem;
      background: rgba(79,70,229,0.06);
      color: var(--primary);
      border: 1.5px solid rgba(79,70,229,0.15);
      border-radius: 10px;
      font-size: 0.85rem;
      font-weight: 600;
      font-family: 'DM Sans', sans-serif;
      text-decoration: none;
      transition: var(--transition);
      cursor: pointer;
    }

    .btn-change:hover { background: var(--primary); color: #fff; border-color: var(--primary); }
    .btn-change svg { transition: transform 0.3s ease; }
    .btn-change:hover svg { transform: translateX(3px); }

    .empty-plan {
      display: flex;
      flex-direction: column;
      align-items: center;
      text-align: center;
      gap: 0.75rem;
      padding: 1rem 0;
      color: var(--text-light);
    }

    .empty-plan p { margin: 0; color: var(--text-muted); font-size: 0.9rem; }

    .usage-stat {
      display: flex;
      align-items: center;
      justify-content: space-between;
      margin-bottom: 1.25rem;
      padding: 0.75rem 1rem;
      background: rgba(6,182,212,0.04);
      border-radius: 10px;
      border: 1px solid rgba(6,182,212,0.1);
    }

    .usage-label { font-size: 0.825rem; color: var(--text-muted); font-weight: 500; }

    .usage-value {
      font-family: 'Plus Jakarta Sans', sans-serif;
      font-size: 1.1rem;
      font-weight: 800;
      color: #06b6d4;
    }

    .progress-section { display: flex; flex-direction: column; gap: 0.5rem; }
    .progress-top { display: flex; justify-content: space-between; align-items: center; }
    .progress-label { font-size: 0.825rem; color: var(--text-muted); font-weight: 500; }

    .progress-value {
      font-family: 'Plus Jakarta Sans', sans-serif;
      font-size: 0.9rem;
      font-weight: 700;
      color: var(--text);
    }

    .progress-bar {
      width: 100%;
      height: 10px;
      background: #e2e8f0;
      border-radius: 10px;
      overflow: hidden;
    }

    .progress-fill {
      height: 100%;
      width: var(--progress-width);
      background: linear-gradient(90deg, var(--primary), var(--accent));
      border-radius: 10px;
      transition: width 1s cubic-bezier(0.4, 0, 0.2, 1);
    }

    .progress-hint { font-size: 0.775rem; }
    .hint-good { color: #10b981; }
    .hint-warn { color: #f59e0b; }
    .hint-high { color: #ef4444; font-weight: 600; }

    .suggestion-card {
      border: 1.5px solid rgba(16,185,129,0.15);
      background: linear-gradient(135deg, #ffffff 0%, #f0fdf4 100%);
    }

    .suggest-badge {
      font-size: 0.7rem;
      font-weight: 700;
      color: #10b981;
      padding: 0.2rem 0.6rem;
      background: rgba(16,185,129,0.08);
      border-radius: 12px;
      text-transform: uppercase;
      letter-spacing: 0.04em;
    }

    .btn-recharge {
      display: inline-flex;
      align-items: center;
      gap: 0.4rem;
      padding: 0.6rem 1.25rem;
      background: linear-gradient(135deg, #10b981 0%, #059669 100%);
      color: #fff;
      border: none;
      border-radius: 10px;
      font-size: 0.875rem;
      font-weight: 600;
      font-family: 'DM Sans', sans-serif;
      cursor: pointer;
      transition: var(--transition);
    }

    .btn-recharge:hover {
      transform: translateY(-1px);
      box-shadow: 0 4px 14px rgba(16,185,129,0.35);
    }

    .inline-form { margin-top: 0; }

    @media (max-width: 640px) {
      .dashboard-grid { grid-template-columns: 1fr; }
      .account-info { flex-direction: column; align-items: center; text-align: center; }
    }
  </style>
<jsp:include page="/WEB-INF/views/shared/_footer.jsp"/>