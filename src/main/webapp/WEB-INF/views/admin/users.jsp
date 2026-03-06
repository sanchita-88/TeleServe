<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<c:set var="ctx" value="${pageContext.request.contextPath}"/>
<c:set var="pageTitle" value="User Management" scope="request"/>
<jsp:include page="/WEB-INF/views/shared/_header.jsp"/>
  <h1>User management</h1>
  <c:if test="${not empty sessionScope.flashError}">
    <div class="flash error"><c:out value="${sessionScope.flashError}"/></div>
    <c:remove var="flashError" scope="session"/>
  </c:if>

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
            <td><c:out value="${u.userId}"/></td>
            <td><c:out value="${u.fullName}"/></td>
            <td><c:out value="${u.email}"/></td>
            <td><c:out value="${u.phone}"/></td>
            <td><c:out value="${u.role}"/></td>
            <td><c:out value="${u.status}"/></td>
            <td class="actions">
              <c:choose>
                <c:when test="${u.status == 'ACTIVE'}">
                  <form method="post" action="${ctx}/admin/users" class="inline-form">
                    <input type="hidden" name="userId" value="${u.userId}"/>
                    <input type="hidden" name="action" value="suspend"/>
                    <button type="submit" class="btn btn-small btn-danger">Suspend</button>
                  </form>
                </c:when>
                <c:otherwise>
                  <form method="post" action="${ctx}/admin/users" class="inline-form">
                    <input type="hidden" name="userId" value="${u.userId}"/>
                    <input type="hidden" name="action" value="activate"/>
                    <button type="submit" class="btn btn-small">Activate</button>
                  </form>
                </c:otherwise>
              </c:choose>
            </td>
          </tr>
        </c:forEach>
      </tbody>
    </table>
  </div>

  <nav class="pagination" aria-label="User list pages">
    <c:set var="pr" value="${userResult}"/>
    <c:set var="currentPage" value="${pr.currentPage}"/>
    <c:set var="totalPages" value="${pr.totalPages}"/>
    <c:choose>
      <c:when test="${currentPage > 1}">
        <a href="${ctx}/admin/users?page=${currentPage - 1}" class="btn btn-small">Previous</a>
      </c:when>
      <c:otherwise>
        <span class="btn btn-small disabled">Previous</span>
      </c:otherwise>
    </c:choose>
    <span class="page-info">Page <c:out value="${currentPage}"/> of <c:out value="${totalPages}"/></span>
    <c:choose>
      <c:when test="${currentPage < totalPages}">
        <a href="${ctx}/admin/users?page=${currentPage + 1}" class="btn btn-small">Next</a>
      </c:when>
      <c:otherwise>
        <span class="btn btn-small disabled">Next</span>
      </c:otherwise>
    </c:choose>
  </nav>

  <style>
    .table-wrap { overflow-x: auto; margin-top: 1rem; background: #fff; border-radius: 8px; box-shadow: 0 1px 3px rgba(0,0,0,0.1); }
    .data-table { width: 100%; border-collapse: collapse; }
    .data-table th, .data-table td { padding: 0.75rem 1rem; text-align: left; border-bottom: 1px solid #eee; }
    .data-table th { background: #f8f9fa; font-weight: 600; color: #1a1a2e; }
    .data-table tbody tr:hover { background: #f8f9fa; }
    .actions .inline-form { display: inline; }
    .actions .btn { margin: 0; }
    .btn-danger { background: #dc3545; }
    .btn-danger:hover { background: #c82333; }
    .pagination { display: flex; align-items: center; gap: 1rem; margin-top: 1rem; flex-wrap: wrap; }
    .page-info { color: #666; font-size: 0.95rem; }
    .pagination .btn { text-decoration: none; padding: 0.4rem 0.75rem; background: #1a1a2e; color: #fff; border-radius: 4px; font-size: 0.9rem; border: none; cursor: pointer; }
    .pagination .btn:hover:not(.disabled) { background: #16213e; }
    .pagination .btn.disabled { background: #ccc; color: #666; cursor: not-allowed; }
  </style>
<jsp:include page="/WEB-INF/views/shared/_footer.jsp"/>
