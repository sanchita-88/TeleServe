<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<c:set var="ctx" value="${pageContext.request.contextPath}"/>
<c:set var="pageTitle" value="User Management — TeleServe" scope="request"/>
<jsp:include page="/WEB-INF/views/shared/_header.jsp"/>

  <div class="dash-header" style="animation: fadeInUp 0.5s ease-out both;">
    <div>
      <h1 class="page-title">User Management</h1>
      <p class="page-subtitle">View and manage registered users</p>
    </div>
    <div class="dash-badge">
      <svg width="16" height="16" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"><path d="M16 21v-2a4 4 0 0 0-4-4H6a4 4 0 0 0-4 4v2"/><circle cx="9" cy="7" r="4"/><path d="M22 21v-2a4 4 0 0 0-3-3.87"/><path d="M16 3.13a4 4 0 0 1 0 7.75"/></svg>
      Users
    </div>
  </div>

  <c:if test="${not empty sessionScope.flashError}">
    <div class="flash error"><c:out value="${sessionScope.flashError}"/></div>
    <c:remove var="flashError" scope="session"/>
  </c:if>

  <section class="card" style="animation: fadeInUp 0.6s ease-out both; animation-delay: 0.1s;">
    <div class="card-header">
      <div class="card-header-icon card-header-icon-users">
        <svg width="20" height="20" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"><path d="M16 21v-2a4 4 0 0 0-4-4H6a4 4 0 0 0-4 4v2"/><circle cx="9" cy="7" r="4"/><path d="M22 21v-2a4 4 0 0 0-3-3.87"/><path d="M16 3.13a4 4 0 0 1 0 7.75"/></svg>
      </div>
      <h2>All Users</h2>
      <span class="page-indicator">Page <c:out value="${userResult.currentPage}"/> of <c:out value="${userResult.totalPages}"/></span>
    </div>
    <div class="table-wrap">
      <table class="data-table">
        <thead>
          <tr>
            <th>ID</th>
            <th>Name</th>
            <th>Email</th>
            <th>Phone</th>
            <th>Role</th>
            <th>Status</th>
            <th>Actions</th>
          </tr>
        </thead>
        <tbody>
          <c:forEach var="u" items="${userResult.data}">
            <tr>
              <td class="td-id">#<c:out value="${u.userId}"/></td>
              <td>
                <div class="user-cell">
                  <div class="user-avatar"><c:out value="${u.fullName.substring(0,1)}"/></div>
                  <span class="td-name"><c:out value="${u.fullName}"/></span>
                </div>
              </td>
              <td class="td-email"><c:out value="${u.email}"/></td>
              <td><c:out value="${u.phone}"/></td>
              <td>
                <c:choose>
                  <c:when test="${u.role == 'ADMIN'}">
                    <span class="badge badge-admin">
                      <svg width="12" height="12" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2.5" stroke-linecap="round" stroke-linejoin="round"><path d="M12 22s8-4 8-10V5l-8-3-8 3v7c0 6 8 10 8 10z"/></svg>
                      Admin
                    </span>
                  </c:when>
                  <c:otherwise>
                    <span class="badge badge-info">User</span>
                  </c:otherwise>
                </c:choose>
              </td>
              <td>
                <c:choose>
                  <c:when test="${u.status == 'ACTIVE'}">
                    <span class="badge badge-success">
                      <span class="status-dot status-dot-active"></span>
                      Active
                    </span>
                  </c:when>
                  <c:otherwise>
                    <span class="badge badge-error">
                      <span class="status-dot status-dot-suspended"></span>
                      Suspended
                    </span>
                  </c:otherwise>
                </c:choose>
              </td>
              <td class="actions">
                <c:choose>
                  <c:when test="${u.status == 'ACTIVE'}">
                    <form method="post" action="${ctx}/admin/users" class="inline-form">
                      <input type="hidden" name="userId" value="${u.userId}"/>
                      <input type="hidden" name="action" value="suspend"/>
                      <button type="submit" class="btn btn-small btn-danger">
                        <svg width="14" height="14" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"><circle cx="12" cy="12" r="10"/><line x1="15" y1="9" x2="9" y2="15"/><line x1="9" y1="9" x2="15" y2="15"/></svg>
                        Suspend
                      </button>
                    </form>
                  </c:when>
                  <c:otherwise>
                    <form method="post" action="${ctx}/admin/users" class="inline-form">
                      <input type="hidden" name="userId" value="${u.userId}"/>
                      <input type="hidden" name="action" value="activate"/>
                      <button type="submit" class="btn btn-small btn-activate">
                        <svg width="14" height="14" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"><path d="M22 11.08V12a10 10 0 1 1-5.93-9.14"/><polyline points="22 4 12 14.01 9 11.01"/></svg>
                        Activate
                      </button>
                    </form>
                  </c:otherwise>
                </c:choose>
              </td>
            </tr>
          </c:forEach>
        </tbody>
      </table>
    </div>
  </section>

  <nav class="pagination" aria-label="User list pages" style="animation: fadeInUp 0.6s ease-out both; animation-delay: 0.2s;">
    <c:set var="pr" value="${userResult}"/>
    <c:set var="currentPage" value="${pr.currentPage}"/>
    <c:set var="totalPages" value="${pr.totalPages}"/>
    <c:choose>
      <c:when test="${currentPage > 1}">
        <a href="${ctx}/admin/users?page=${currentPage - 1}" class="page-btn">
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
        <a href="${ctx}/admin/users?page=${currentPage + 1}" class="page-btn">
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

    .card-header-icon-users {
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

    .user-cell {
      display: flex;
      align-items: center;
      gap: 0.6rem;
    }

    .user-avatar {
      width: 32px; height: 32px;
      border-radius: 8px;
      background: linear-gradient(135deg, var(--primary), var(--accent));
      color: #fff;
      font-size: 0.8rem;
      font-weight: 700;
      display: flex;
      align-items: center;
      justify-content: center;
      flex-shrink: 0;
      text-transform: uppercase;
    }

    .td-id {
      font-family: 'Plus Jakarta Sans', sans-serif;
      font-weight: 600;
      color: var(--text-muted);
      font-size: 0.85rem;
    }

    .td-name { font-weight: 600; color: var(--text); }

    .td-email { color: var(--text-muted); font-size: 0.875rem; }

    .badge-admin {
      background: linear-gradient(135deg, rgba(79,70,229,0.08), rgba(79,70,229,0.12));
      color: var(--primary);
      display: inline-flex;
      align-items: center;
      gap: 0.3rem;
    }

    .status-dot {
      width: 6px; height: 6px;
      border-radius: 50%;
      display: inline-block;
    }

    .status-dot-active {
      background: #10b981;
      box-shadow: 0 0 4px rgba(16,185,129,0.5);
    }

    .status-dot-suspended {
      background: #ef4444;
      box-shadow: 0 0 4px rgba(239,68,68,0.5);
    }

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

    .btn-danger {
      background: rgba(239,68,68,0.08);
      color: #ef4444;
    }

    .btn-danger:hover {
      background: #ef4444;
      color: #fff;
    }

    .btn-activate {
      background: rgba(16,185,129,0.08);
      color: #10b981;
    }

    .btn-activate:hover {
      background: #10b981;
      color: #fff;
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

    .page-info {
      font-size: 0.85rem;
      color: var(--text-muted);
    }

    .page-info strong {
      color: var(--text);
    }

    @media (max-width: 640px) {
      .pagination { gap: 0.5rem; }
      .page-btn { padding: 0.4rem 0.75rem; font-size: 0.8rem; }
    }
  </style>
<jsp:include page="/WEB-INF/views/shared/_footer.jsp"/>