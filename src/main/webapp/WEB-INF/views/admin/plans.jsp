<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<c:set var="ctx" value="${pageContext.request.contextPath}"/>
<c:set var="pageTitle" value="Plan Management — TeleServe" scope="request"/>
<jsp:include page="/WEB-INF/views/shared/_header.jsp"/>

  <div class="dash-header" style="animation: fadeInUp 0.5s ease-out both;">
    <div>
      <h1 class="page-title">Plan Management</h1>
      <p class="page-subtitle">Create and manage your telecom plans</p>
    </div>
    <div class="dash-badge">
      <svg width="16" height="16" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"><rect x="2" y="7" width="20" height="14" rx="2" ry="2"/><path d="M16 21V5a2 2 0 0 0-2-2h-4a2 2 0 0 0-2 2v16"/></svg>
      Plans
    </div>
  </div>

  <c:if test="${not empty sessionScope.flashError}">
    <div class="flash error"><c:out value="${sessionScope.flashError}"/></div>
    <c:remove var="flashError" scope="session"/>
  </c:if>

  <section class="card add-plan-card" style="animation: fadeInUp 0.6s ease-out both; animation-delay: 0.1s;">
    <div class="card-header">
      <div class="card-header-icon card-header-icon-add">
        <svg width="20" height="20" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"><circle cx="12" cy="12" r="10"/><line x1="12" y1="8" x2="12" y2="16"/><line x1="8" y1="12" x2="16" y2="12"/></svg>
      </div>
      <h2>Add New Plan</h2>
    </div>
    <form method="post" action="${ctx}/admin/plans" class="plan-form">
      <input type="hidden" name="action" value="create"/>
      <div class="form-row">
        <label for="name">Plan Name</label>
        <div class="input-wrapper">
          <svg class="input-icon" width="16" height="16" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"><path d="M4 9h16"/><path d="M4 15h16"/><path d="M10 3 8 21"/><path d="M14 3l-2 18"/></svg>
          <input type="text" id="name" name="name" required placeholder="e.g. Monthly 2GB"/>
        </div>
      </div>
      <div class="form-row">
        <label for="price">Price (INR)</label>
        <div class="input-wrapper">
          <svg class="input-icon" width="16" height="16" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"><line x1="12" y1="1" x2="12" y2="23"/><path d="M17 5H9.5a3.5 3.5 0 0 0 0 7h5a3.5 3.5 0 0 1 0 7H6"/></svg>
          <input type="number" id="price" name="price" step="0.01" min="0" required placeholder="99.00"/>
        </div>
      </div>
      <div class="form-row">
        <label for="dataGb">Data (GB)</label>
        <div class="input-wrapper">
          <svg class="input-icon" width="16" height="16" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"><path d="M21 16V8a2 2 0 0 0-1-1.73l-7-4a2 2 0 0 0-2 0l-7 4A2 2 0 0 0 3 8v8a2 2 0 0 0 1 1.73l7 4a2 2 0 0 0 2 0l7-4A2 2 0 0 0 21 16z"/></svg>
          <input type="number" id="dataGb" name="dataGb" step="0.01" min="0" required placeholder="2"/>
        </div>
      </div>
      <div class="form-row">
        <label for="validityDays">Validity (days)</label>
        <div class="input-wrapper">
          <svg class="input-icon" width="16" height="16" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"><rect x="3" y="4" width="18" height="18" rx="2" ry="2"/><line x1="16" y1="2" x2="16" y2="6"/><line x1="8" y1="2" x2="8" y2="6"/><line x1="3" y1="10" x2="21" y2="10"/></svg>
          <input type="number" id="validityDays" name="validityDays" min="1" required placeholder="30"/>
        </div>
      </div>
      <div class="form-row">
        <label for="category">Category</label>
        <div class="input-wrapper">
          <svg class="input-icon" width="16" height="16" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"><path d="M20.59 13.41l-7.17 7.17a2 2 0 0 1-2.83 0L2 12V2h10l8.59 8.59a2 2 0 0 1 0 2.82z"/><line x1="7" y1="7" x2="7.01" y2="7"/></svg>
          <input type="text" id="category" name="category" placeholder="e.g. Data"/>
        </div>
      </div>
      <div class="form-row form-row-btn">
        <button type="submit" class="btn btn-create">
          <svg width="18" height="18" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"><line x1="12" y1="5" x2="12" y2="19"/><line x1="5" y1="12" x2="19" y2="12"/></svg>
          Create Plan
        </button>
      </div>
    </form>
  </section>

  <section class="card plans-list-card" style="animation: fadeInUp 0.6s ease-out both; animation-delay: 0.2s;">
    <div class="card-header">
      <div class="card-header-icon card-header-icon-list">
        <svg width="20" height="20" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"><line x1="8" y1="6" x2="21" y2="6"/><line x1="8" y1="12" x2="21" y2="12"/><line x1="8" y1="18" x2="21" y2="18"/><line x1="3" y1="6" x2="3.01" y2="6"/><line x1="3" y1="12" x2="3.01" y2="12"/><line x1="3" y1="18" x2="3.01" y2="18"/></svg>
      </div>
      <h2>Active Plans</h2>
      <span class="plan-count">${fn:length(activePlans)} plans</span>
    </div>
    <div class="table-wrap">
      <table class="data-table">
        <thead>
          <tr>
            <th>Name</th>
            <th>Price</th>
            <th>Data</th>
            <th>Validity</th>
            <th>Category</th>
            <th>Status</th>
            <th>Actions</th>
          </tr>
        </thead>
        <tbody>
          <c:forEach var="p" items="${activePlans}">
            <tr>
              <td class="td-name"><c:out value="${p.name}"/></td>
              <td class="td-price"><fmt:formatNumber value="${p.price}" type="currency" currencyCode="INR"/></td>
              <td><c:out value="${p.dataGb}"/> GB</td>
              <td><c:out value="${p.validityDays}"/> days</td>
              <td>
                <span class="badge badge-info"><c:out value="${p.category}"/></span>
              </td>
              <td>
                <c:choose>
                  <c:when test="${p.active}">
                    <span class="badge badge-success">Active</span>
                  </c:when>
                  <c:otherwise>
                    <span class="badge badge-error">Inactive</span>
                  </c:otherwise>
                </c:choose>
              </td>
              <td class="actions">
                <c:if test="${p.active}">
                  <form method="post" action="${ctx}/admin/plans" class="inline-form">
                    <input type="hidden" name="action" value="deactivate"/>
                    <input type="hidden" name="planId" value="${p.planId}"/>
                    <button type="submit" class="btn btn-small btn-danger">
                      <svg width="14" height="14" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"><circle cx="12" cy="12" r="10"/><line x1="15" y1="9" x2="9" y2="15"/><line x1="9" y1="9" x2="15" y2="15"/></svg>
                      Deactivate
                    </button>
                  </form>
                </c:if>
              </td>
            </tr>
          </c:forEach>
        </tbody>
      </table>
    </div>
    <c:if test="${empty activePlans}">
      <div class="empty-state">
        <svg width="48" height="48" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="1.5" stroke-linecap="round" stroke-linejoin="round"><path d="M21 16V8a2 2 0 0 0-1-1.73l-7-4a2 2 0 0 0-2 0l-7 4A2 2 0 0 0 3 8v8a2 2 0 0 0 1 1.73l7 4a2 2 0 0 0 2 0l7-4A2 2 0 0 0 21 16z"/><polyline points="3.27 6.96 12 12.01 20.73 6.96"/><line x1="12" y1="22.08" x2="12" y2="12"/></svg>
        <p>No plans yet. Create one above to get started.</p>
      </div>
    </c:if>
  </section>

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

    .card-header-icon-add { background: rgba(16,185,129,0.08); color: #10b981; }
    .card-header-icon-list { background: rgba(79,70,229,0.08); color: var(--primary); }

    .plan-count {
      font-size: 0.8rem;
      font-weight: 600;
      color: var(--text-muted);
      padding: 0.25rem 0.7rem;
      background: #f1f5f9;
      border-radius: 12px;
    }

    .add-plan-card { margin-bottom: 1.5rem; }

    .plan-form {
      display: grid;
      grid-template-columns: repeat(auto-fill, minmax(200px, 1fr));
      gap: 1rem;
      align-items: end;
    }

    .plan-form .form-row { display: flex; flex-direction: column; gap: 0.35rem; }
    .plan-form .form-row label { font-size: 0.825rem; font-weight: 600; color: var(--text); }

    .plan-form .input-wrapper { position: relative; display: flex; align-items: center; }

    .plan-form .input-icon {
      position: absolute;
      left: 0.75rem;
      color: var(--text-light);
      pointer-events: none;
      transition: var(--transition);
    }

    .plan-form .input-wrapper input {
      padding: 0.6rem 0.75rem 0.6rem 2.5rem;
      border: 1.5px solid var(--border);
      border-radius: 10px;
      font-size: 0.9rem;
      font-family: 'DM Sans', sans-serif;
      color: var(--text);
      background: #f8fafc;
      transition: var(--transition);
      outline: none;
      width: 100%;
    }

    .plan-form .input-wrapper input::placeholder { color: var(--text-light); }

    .plan-form .input-wrapper input:focus {
      border-color: var(--primary);
      background: #fff;
      box-shadow: 0 0 0 3px rgba(79,70,229,0.1);
    }

    .plan-form .input-wrapper:focus-within .input-icon { color: var(--primary); }

    .form-row-btn { display: flex; align-items: flex-end; }

    .btn-create {
      padding: 0.6rem 1.25rem;
      background: linear-gradient(135deg, #10b981 0%, #059669 100%);
      color: #fff;
      border: none;
      border-radius: 10px;
      font-size: 0.9rem;
      font-weight: 600;
      font-family: 'DM Sans', sans-serif;
      cursor: pointer;
      transition: var(--transition);
      display: flex;
      align-items: center;
      gap: 0.4rem;
      white-space: nowrap;
    }

    .btn-create:hover {
      transform: translateY(-1px);
      box-shadow: 0 4px 14px rgba(16,185,129,0.35);
    }

    .table-wrap { overflow-x: auto; }
    .td-name { font-weight: 600; color: var(--text); }
    .td-price { font-family: 'Plus Jakarta Sans', sans-serif; font-weight: 700; color: var(--primary); }
    .actions .inline-form { display: inline; }

    .btn-small {
      padding: 0.35rem 0.75rem;
      font-size: 0.8rem;
      border: none;
      border-radius: 8px;
      font-weight: 600;
      font-family: 'DM Sans', sans-serif;
      cursor: pointer;
      transition: var(--transition);
      display: inline-flex;
      align-items: center;
      gap: 0.3rem;
    }

    .btn-danger { background: rgba(239,68,68,0.08); color: #ef4444; }
    .btn-danger:hover { background: #ef4444; color: #fff; }

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

    @media (max-width: 640px) {
      .plan-form { grid-template-columns: 1fr; }
    }
  </style>
<jsp:include page="/WEB-INF/views/shared/_footer.jsp"/>