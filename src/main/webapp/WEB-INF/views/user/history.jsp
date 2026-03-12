<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<c:set var="ctx" value="${pageContext.request.contextPath}"/>
<c:set var="pageTitle" value="Recharge History — TeleServe" scope="request"/>
<jsp:include page="/WEB-INF/views/shared/_header.jsp"/>

  <div class="dash-header" style="animation: fadeInUp 0.5s ease-out both;">
    <div>
      <h1 class="page-title">Recharge History</h1>
      <p class="page-subtitle">View all your past recharges and transactions</p>
    </div>
    <div class="dash-badge">
      <svg width="16" height="16" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"><circle cx="12" cy="12" r="10"/><polyline points="12 6 12 12 16 14"/></svg>
      History
    </div>
  </div>

  <section class="card" style="animation: fadeInUp 0.6s ease-out both; animation-delay: 0.1s;">
    <div class="card-header">
      <div class="card-header-icon icon-history">
        <svg width="20" height="20" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"><polyline points="1 4 1 10 7 10"/><path d="M3.51 15a9 9 0 1 0 2.13-9.36L1 10"/></svg>
      </div>
      <h2>Transactions</h2>
      <span class="page-indicator">Page <c:out value="${rechargeResult.currentPage}"/> of <c:out value="${rechargeResult.totalPages}"/></span>
    </div>
    <div class="table-wrap">
      <table class="data-table">
        <thead>
          <tr>
            <th>Date</th>
            <th>Plan</th>
            <th>Amount</th>
            <th>Expiry</th>
            <th>Status</th>
          </tr>
        </thead>
        <tbody>
          <c:forEach var="r" items="${rechargeResult.data}">
            <tr>
              <td class="td-date">
                <svg width="14" height="14" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"><rect x="3" y="4" width="18" height="18" rx="2" ry="2"/><line x1="16" y1="2" x2="16" y2="6"/><line x1="8" y1="2" x2="8" y2="6"/><line x1="3" y1="10" x2="21" y2="10"/></svg>
                <c:out value="${r.rechargedAt}"/>
              </td>
              <td class="td-plan"><c:out value="${r.plan.name}"/></td>
              <td class="td-amount"><fmt:formatNumber value="${r.amountPaid}" type="currency" currencyCode="INR"/></td>
              <td class="td-expiry"><c:out value="${r.expiryDate}"/></td>
              <td>
                <c:choose>
                  <c:when test="${r.status == 'ACTIVE'}">
                    <span class="badge badge-success">
                      <span class="status-dot status-dot-active"></span>
                      Active
                    </span>
                  </c:when>
                  <c:when test="${r.status == 'EXPIRED'}">
                    <span class="badge badge-expired">
                      <span class="status-dot status-dot-expired"></span>
                      Expired
                    </span>
                  </c:when>
                  <c:otherwise>
                    <span class="badge badge-info"><c:out value="${r.status}"/></span>
                  </c:otherwise>
                </c:choose>
              </td>
            </tr>
          </c:forEach>
        </tbody>
      </table>
    </div>
    <c:if test="${empty rechargeResult.data}">
      <div class="empty-state">
        <svg width="48" height="48" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="1.5" stroke-linecap="round" stroke-linejoin="round"><polyline points="1 4 1 10 7 10"/><path d="M3.51 15a9 9 0 1 0 2.13-9.36L1 10"/></svg>
        <p>No recharges yet.</p>
        <a href="${ctx}/user/recharge" class="btn-start">
          <svg width="16" height="16" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"><polyline points="13 2 3 14 12 14 11 22 21 10 12 10 13 2"/></svg>
          Make your first recharge
        </a>
      </div>
    </c:if>
  </section>

  <nav class="pagination" aria-label="Recharge history pages" style="animation: fadeInUp 0.6s ease-out both; animation-delay: 0.2s;">
    <c:set var="pr" value="${rechargeResult}"/>
    <c:set var="currentPage" value="${pr.currentPage}"/>
    <c:set var="totalPages" value="${pr.totalPages}"/>
    <c:choose>
      <c:when test="${currentPage > 1}">
        <a href="${ctx}/user/history?page=${currentPage - 1}" class="page-btn">
          <svg width="16" height="16" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"><polyline points="15 18 9 12 15 6"/></svg>
          Previous
        </a>
      </c:when>
      <c:otherwise>
        <span class="page-btn disabled">
          <svg width="16" height="16" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"><polyline points="15 18 9 12 15 6"/></svg>
          Previous
        </span>
      </c:otherwise>
    </c:choose>
    <span class="page-info">Page <strong><c:out value="${currentPage}"/></strong> of <strong><c:out value="${totalPages}"/></strong></span>
    <c:choose>
      <c:when test="${currentPage < totalPages}">
        <a href="${ctx}/user/history?page=${currentPage + 1}" class="page-btn">
          Next
          <svg width="16" height="16" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"><polyline points="9 18 15 12 9 6"/></svg>
        </a>
      </c:when>
      <c:otherwise>
        <span class="page-btn disabled">
          Next
          <svg width="16" height="16" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"><polyline points="9 18 15 12 9 6"/></svg>
        </span>
      </c:otherwise>
    </c:choose>
  </nav>

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
      font-size: 1.1rem;
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

    .icon-history {
      background: rgba(79,70,229,0.08);
      color: var(--primary);
    }

    .page-indicator {
      font-size: 0.8rem;
      font-weight: 600;
      color: var(--text-muted);
      padding: 0.25rem 0.7rem;
      background: #f1f5f9;
      border-radius: 12px;
    }

    .table-wrap { overflow-x: auto; }

    .td-date {
      display: flex;
      align-items: center;
      gap: 0.4rem;
      color: var(--text-muted);
      font-size: 0.875rem;
      white-space: nowrap;
    }

    .td-date svg { color: var(--text-light); flex-shrink: 0; }

    .td-plan { font-weight: 600; color: var(--text); }

    .td-amount {
      font-family: 'Plus Jakarta Sans', sans-serif;
      font-weight: 700;
      color: var(--primary);
    }

    .td-expiry { color: var(--text-muted); font-size: 0.875rem; }

    .status-dot {
      width: 6px; height: 6px;
      border-radius: 50%;
      display: inline-block;
    }

    .status-dot-active {
      background: #10b981;
      box-shadow: 0 0 4px rgba(16,185,129,0.5);
    }

    .status-dot-expired {
      background: #94a3b8;
      box-shadow: 0 0 4px rgba(148,163,184,0.4);
    }

    .badge-expired {
      background: #f1f5f9;
      color: #64748b;
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

    .btn-start {
      display: inline-flex;
      align-items: center;
      gap: 0.4rem;
      padding: 0.5rem 1rem;
      background: linear-gradient(135deg, var(--primary) 0%, var(--primary-dark) 100%);
      color: #fff;
      border-radius: 10px;
      font-size: 0.85rem;
      font-weight: 600;
      font-family: 'DM Sans', sans-serif;
      text-decoration: none;
      transition: var(--transition);
    }

    .btn-start:hover {
      transform: translateY(-1px);
      box-shadow: 0 4px 14px rgba(79,70,229,0.35);
    }

    .pagination {
      display: flex;
      align-items: center;
      justify-content: center;
      gap: 1rem;
      margin-top: 1.25rem;
      flex-wrap: wrap;
    }

    .page-btn {
      display: inline-flex;
      align-items: center;
      gap: 0.35rem;
      padding: 0.5rem 1rem;
      background: var(--bg-card);
      color: var(--text);
      border: 1.5px solid var(--border);
      border-radius: 10px;
      font-size: 0.85rem;
      font-weight: 600;
      font-family: 'DM Sans', sans-serif;
      text-decoration: none;
      cursor: pointer;
      transition: var(--transition);
    }

    .page-btn:hover:not(.disabled) {
      border-color: var(--primary);
      color: var(--primary);
      background: rgba(79,70,229,0.04);
    }

    .page-btn.disabled {
      color: var(--text-light);
      cursor: not-allowed;
      opacity: 0.5;
    }

    .page-info { font-size: 0.85rem; color: var(--text-muted); }
    .page-info strong { color: var(--text); }

    @media (max-width: 640px) {
      .pagination { gap: 0.5rem; }
      .page-btn { padding: 0.4rem 0.75rem; font-size: 0.8rem; }
    }
  </style>
<jsp:include page="/WEB-INF/views/shared/_footer.jsp"/>