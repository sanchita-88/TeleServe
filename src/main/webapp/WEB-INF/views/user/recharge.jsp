<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<c:set var="ctx" value="${pageContext.request.contextPath}"/>
<c:set var="pageTitle" value="Recharge — TeleServe" scope="request"/>
<jsp:include page="/WEB-INF/views/shared/_header.jsp"/>

  <div class="dash-header" style="animation: fadeInUp 0.5s ease-out both;">
    <div>
      <h1 class="page-title">Choose a Plan</h1>
      <p class="page-subtitle">Select the best plan for your needs</p>
    </div>
    <div class="dash-badge">
      <svg width="16" height="16" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"><polyline points="13 2 3 14 12 14 11 22 21 10 12 10 13 2"/></svg>
      Recharge
    </div>
  </div>

  <c:if test="${not empty errorMessage}">
    <div class="flash error"><c:out value="${errorMessage}"/></div>
  </c:if>

  <div class="plans-grid">
    <c:forEach var="plan" items="${plans}" varStatus="loop">
      <div class="plan-card" style="--animation-delay: ${loop.index * 100}ms;">
        <div class="plan-card-top">
          <c:if test="${not empty plan.category}">
            <span class="plan-category"><c:out value="${plan.category}"/></span>
          </c:if>
          <h2><c:out value="${plan.name}"/></h2>
          <div class="plan-price-wrap">
            <span class="plan-price"><fmt:formatNumber value="${plan.price}" type="currency" currencyCode="INR"/></span>
          </div>
        </div>
        <div class="plan-card-body">
          <div class="plan-feature">
            <div class="plan-feature-icon feature-data">
              <svg width="16" height="16" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"><path d="M21 16V8a2 2 0 0 0-1-1.73l-7-4a2 2 0 0 0-2 0l-7 4A2 2 0 0 0 3 8v8a2 2 0 0 0 1 1.73l7 4a2 2 0 0 0 2 0l7-4A2 2 0 0 0 21 16z"/></svg>
            </div>
            <div>
              <span class="feature-value"><c:out value="${plan.dataGb}"/> GB</span>
              <span class="feature-label">Data</span>
            </div>
          </div>
          <div class="plan-feature">
            <div class="plan-feature-icon feature-validity">
              <svg width="16" height="16" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"><rect x="3" y="4" width="18" height="18" rx="2" ry="2"/><line x1="16" y1="2" x2="16" y2="6"/><line x1="8" y1="2" x2="8" y2="6"/><line x1="3" y1="10" x2="21" y2="10"/></svg>
            </div>
            <div>
              <span class="feature-value"><c:out value="${plan.validityDays}"/> Days</span>
              <span class="feature-label">Validity</span>
            </div>
          </div>
        </div>
        <form method="post" action="${ctx}/user/recharge" class="plan-form">
          <input type="hidden" name="planId" value="${plan.planId}"/>
          <button type="submit" class="btn-recharge">
            <svg width="16" height="16" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"><polyline points="13 2 3 14 12 14 11 22 21 10 12 10 13 2"/></svg>
            Recharge Now
          </button>
        </form>
      </div>
    </c:forEach>
  </div>

  <c:if test="${empty plans}">
    <section class="card" style="animation: fadeInUp 0.6s ease-out both; animation-delay: 0.1s;">
      <div class="empty-state">
        <svg width="48" height="48" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="1.5" stroke-linecap="round" stroke-linejoin="round"><polyline points="13 2 3 14 12 14 11 22 21 10 12 10 13 2"/></svg>
        <p>No plans available at the moment.</p>
        <span class="empty-hint">Check back later for new offers</span>
      </div>
    </section>
  </c:if>

  <style>
    .dash-header {
      display: flex;
      align-items: flex-start;
      justify-content: space-between;
      flex-wrap: wrap;
      gap: 1rem;
      margin-bottom: 1.5rem;
    }

    .dash-badge {
      display: flex;
      align-items: center;
      gap: 0.4rem;
      padding: 0.4rem 0.9rem;
      background: linear-gradient(135deg, rgba(79,70,229,0.08), rgba(6,182,212,0.08));
      color: var(--primary);
      font-size: 0.8rem;
      font-weight: 600;
      border-radius: 20px;
      border: 1px solid rgba(79,70,229,0.15);
    }

    .plans-grid {
      display: grid;
      grid-template-columns: repeat(auto-fill, minmax(270px, 1fr));
      gap: 1.25rem;
    }

    .plan-card {
      background: var(--bg-card);
      border-radius: var(--radius-lg);
      padding: 0;
      box-shadow: var(--shadow-md);
      border: 1.5px solid var(--border);
      display: flex;
      flex-direction: column;
      transition: var(--transition);
      overflow: hidden;
      animation: fadeInUp 0.6s ease-out both;
      animation-delay: var(--animation-delay, 0ms);
    }

    .plan-card:hover {
      box-shadow: var(--shadow-lg), 0 0 20px rgba(79,70,229,0.08);
      transform: translateY(-4px);
      border-color: rgba(79,70,229,0.2);
    }

    .plan-card-top {
      padding: 1.5rem 1.5rem 1.25rem;
      border-bottom: 1px solid var(--border);
      position: relative;
    }

    .plan-category {
      display: inline-block;
      font-size: 0.7rem;
      font-weight: 700;
      color: var(--primary);
      text-transform: uppercase;
      letter-spacing: 0.05em;
      padding: 0.2rem 0.6rem;
      background: rgba(79,70,229,0.06);
      border-radius: 8px;
      margin-bottom: 0.6rem;
    }

    .plan-card h2 {
      font-family: 'Plus Jakarta Sans', sans-serif;
      font-size: 1.15rem;
      font-weight: 700;
      color: var(--text);
      margin: 0 0 0.75rem;
    }

    .plan-price-wrap {
      display: flex;
      align-items: baseline;
      gap: 0.25rem;
    }

    .plan-price {
      font-family: 'Plus Jakarta Sans', sans-serif;
      font-size: 1.75rem;
      font-weight: 800;
      color: var(--primary);
      letter-spacing: -0.02em;
    }

    .plan-card-body {
      padding: 1.25rem 1.5rem;
      display: flex;
      flex-direction: column;
      gap: 0.85rem;
      flex: 1;
    }

    .plan-feature {
      display: flex;
      align-items: center;
      gap: 0.75rem;
    }

    .plan-feature-icon {
      width: 36px; height: 36px;
      border-radius: 10px;
      display: flex;
      align-items: center;
      justify-content: center;
      flex-shrink: 0;
    }

    .feature-data {
      background: rgba(6,182,212,0.08);
      color: #06b6d4;
    }

    .feature-validity {
      background: rgba(245,158,11,0.08);
      color: #f59e0b;
    }

    .feature-value {
      display: block;
      font-family: 'Plus Jakarta Sans', sans-serif;
      font-size: 0.95rem;
      font-weight: 700;
      color: var(--text);
    }

    .feature-label {
      display: block;
      font-size: 0.75rem;
      color: var(--text-muted);
      margin-top: 0.05rem;
    }

    .plan-form {
      padding: 0 1.5rem 1.5rem;
      margin-top: auto;
    }

    .btn-recharge {
      width: 100%;
      display: flex;
      align-items: center;
      justify-content: center;
      gap: 0.5rem;
      padding: 0.7rem 1.25rem;
      background: linear-gradient(135deg, var(--primary) 0%, var(--primary-dark) 100%);
      color: #fff;
      border: none;
      border-radius: 10px;
      font-size: 0.9rem;
      font-weight: 600;
      font-family: 'DM Sans', sans-serif;
      cursor: pointer;
      transition: var(--transition);
    }

    .btn-recharge:hover {
      transform: translateY(-1px);
      box-shadow: 0 6px 20px rgba(79,70,229,0.3);
    }

    .btn-recharge svg {
      transition: transform 0.3s ease;
    }

    .btn-recharge:hover svg {
      transform: scale(1.15);
    }

    .empty-state {
      display: flex;
      flex-direction: column;
      align-items: center;
      gap: 0.75rem;
      padding: 2.5rem 1rem;
      color: var(--text-light);
      text-align: center;
    }

    .empty-state svg { opacity: 0.4; }
    .empty-state p { font-size: 0.9rem; color: var(--text-muted); margin: 0; }

    .empty-hint {
      font-size: 0.8rem;
      color: var(--text-light);
    }

    @media (max-width: 640px) {
      .plans-grid { grid-template-columns: 1fr; }
    }
  </style>
<jsp:include page="/WEB-INF/views/shared/_footer.jsp"/>