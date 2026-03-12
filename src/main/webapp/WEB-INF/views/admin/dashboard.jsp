<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<c:set var="ctx" value="${pageContext.request.contextPath}"/>
<c:set var="pageTitle" value="Admin Dashboard — TeleServe" scope="request"/>
<jsp:include page="/WEB-INF/views/shared/_header.jsp"/>

  <div class="dash-header">
    <div>
      <h1 class="page-title">Admin Dashboard</h1>
      <p class="page-subtitle">Overview of your platform metrics</p>
    </div>
    <div class="dash-badge">
      <svg width="16" height="16" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"><path d="M12 22s8-4 8-10V5l-8-3-8 3v7c0 6 8 10 8 10z"/></svg>
      Admin
    </div>
  </div>

  <div class="stats-grid">
    <section class="stat-card">
      <div class="stat-icon stat-icon-users">
        <svg width="22" height="22" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"><path d="M16 21v-2a4 4 0 0 0-4-4H6a4 4 0 0 0-4 4v2"/><circle cx="9" cy="7" r="4"/><path d="M22 21v-2a4 4 0 0 0-3-3.87"/><path d="M16 3.13a4 4 0 0 1 0 7.75"/></svg>
      </div>
      <div class="stat-content">
        <p class="stat-label">Total Users</p>
        <p class="stat-value"><c:out value="${stats.totalUsers}"/></p>
      </div>
      <div class="stat-trend stat-trend-up">
        <svg width="14" height="14" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2.5" stroke-linecap="round" stroke-linejoin="round"><polyline points="23 6 13.5 15.5 8.5 10.5 1 18"/><polyline points="17 6 23 6 23 12"/></svg>
      </div>
    </section>

    <section class="stat-card">
      <div class="stat-icon stat-icon-recharges">
        <svg width="22" height="22" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"><polyline points="13 2 3 14 12 14 11 22 21 10 12 10 13 2"/></svg>
      </div>
      <div class="stat-content">
        <p class="stat-label">Total Recharges</p>
        <p class="stat-value"><c:out value="${stats.totalRecharges}"/></p>
      </div>
      <div class="stat-trend stat-trend-up">
        <svg width="14" height="14" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2.5" stroke-linecap="round" stroke-linejoin="round"><polyline points="23 6 13.5 15.5 8.5 10.5 1 18"/><polyline points="17 6 23 6 23 12"/></svg>
      </div>
    </section>

    <section class="stat-card">
      <div class="stat-icon stat-icon-revenue">
        <svg width="22" height="22" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"><line x1="12" y1="1" x2="12" y2="23"/><path d="M17 5H9.5a3.5 3.5 0 0 0 0 7h5a3.5 3.5 0 0 1 0 7H6"/></svg>
      </div>
      <div class="stat-content">
        <p class="stat-label">Total Revenue</p>
        <p class="stat-value"><fmt:formatNumber value="${stats.totalRevenue}" type="currency" currencyCode="INR"/></p>
      </div>
      <div class="stat-trend stat-trend-up">
        <svg width="14" height="14" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2.5" stroke-linecap="round" stroke-linejoin="round"><polyline points="23 6 13.5 15.5 8.5 10.5 1 18"/><polyline points="17 6 23 6 23 12"/></svg>
      </div>
    </section>
  </div>

  <style>
    .dash-header {
      display: flex;
      align-items: flex-start;
      justify-content: space-between;
      flex-wrap: wrap;
      gap: 1rem;
      animation: fadeInUp 0.5s ease-out both;
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

    .stats-grid {
      display: grid;
      grid-template-columns: repeat(auto-fill, minmax(260px, 1fr));
      gap: 1.25rem;
      margin-top: 1.5rem;
    }

    .stat-card {
      background: var(--bg-card);
      border-radius: var(--radius);
      padding: 1.5rem;
      box-shadow: var(--shadow-md);
      border: 1px solid var(--border);
      display: flex;
      align-items: flex-start;
      gap: 1rem;
      transition: var(--transition);
      position: relative;
      overflow: hidden;
      animation: fadeInUp 0.6s ease-out both;
    }

    .stat-card:nth-child(1) { animation-delay: 0.1s; }
    .stat-card:nth-child(2) { animation-delay: 0.2s; }
    .stat-card:nth-child(3) { animation-delay: 0.3s; }

    .stat-card:hover {
      box-shadow: var(--shadow-lg);
      transform: translateY(-3px);
      border-color: rgba(79,70,229,0.15);
    }

    .stat-card::after {
      content: '';
      position: absolute;
      bottom: 0; left: 0; right: 0;
      height: 3px;
      background: linear-gradient(90deg, var(--primary), var(--accent));
      opacity: 0;
      transition: var(--transition);
    }

    .stat-card:hover::after { opacity: 1; }

    .stat-icon {
      width: 48px; height: 48px;
      border-radius: 12px;
      display: flex;
      align-items: center;
      justify-content: center;
      flex-shrink: 0;
    }

    .stat-icon-users {
      background: rgba(79,70,229,0.08);
      color: var(--primary);
    }

    .stat-icon-recharges {
      background: rgba(245,158,11,0.08);
      color: #f59e0b;
    }

    .stat-icon-revenue {
      background: rgba(16,185,129,0.08);
      color: #10b981;
    }

    .stat-content { flex: 1; min-width: 0; }

    .stat-card .stat-label {
      font-size: 0.8rem;
      color: var(--text-muted);
      font-weight: 500;
      text-transform: uppercase;
      letter-spacing: 0.04em;
      margin: 0 0 0.35rem;
    }

    .stat-card .stat-value {
      font-family: 'Plus Jakarta Sans', sans-serif;
      font-size: 1.6rem;
      font-weight: 800;
      color: var(--text);
      letter-spacing: -0.02em;
      margin: 0;
      line-height: 1.2;
    }

    .stat-trend {
      align-self: flex-start;
      padding: 0.3rem;
      border-radius: 6px;
      display: flex;
      align-items: center;
    }

    .stat-trend-up {
      background: rgba(16,185,129,0.08);
      color: #10b981;
    }

    @media (max-width: 640px) {
      .stats-grid { grid-template-columns: 1fr; }
      .dash-header { flex-direction: column; }
    }
  </style>
<jsp:include page="/WEB-INF/views/shared/_footer.jsp"/>