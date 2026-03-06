<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<c:set var="ctx" value="${pageContext.request.contextPath}"/>
<c:set var="pageTitle" value="Recharge History" scope="request"/>
<jsp:include page="/WEB-INF/views/shared/_header.jsp"/>
  <h1>Recharge history</h1>

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
            <td><c:out value="${r.rechargedAt}"/></td>
            <td><c:out value="${r.plan.name}"/></td>
            <td><fmt:formatNumber value="${r.amountPaid}" type="currency" currencyCode="INR"/></td>
            <td><c:out value="${r.expiryDate}"/></td>
            <td><c:out value="${r.status}"/></td>
          </tr>
        </c:forEach>
      </tbody>
    </table>
  </div>

  <nav class="pagination" aria-label="Recharge history pages">
    <c:set var="pr" value="${rechargeResult}"/>
    <c:set var="currentPage" value="${pr.currentPage}"/>
    <c:set var="totalPages" value="${pr.totalPages}"/>
    <c:choose>
      <c:when test="${currentPage > 1}">
        <a href="${ctx}/user/history?page=${currentPage - 1}" class="btn btn-small">Previous</a>
      </c:when>
      <c:otherwise>
        <span class="btn btn-small disabled">Previous</span>
      </c:otherwise>
    </c:choose>
    <span class="page-info">Page <c:out value="${currentPage}"/> of <c:out value="${totalPages}"/></span>
    <c:choose>
      <c:when test="${currentPage < totalPages}">
        <a href="${ctx}/user/history?page=${currentPage + 1}" class="btn btn-small">Next</a>
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
    .pagination { display: flex; align-items: center; gap: 1rem; margin-top: 1rem; flex-wrap: wrap; }
    .page-info { color: #666; font-size: 0.95rem; }
    .pagination .btn { text-decoration: none; padding: 0.4rem 0.75rem; background: #1a1a2e; color: #fff; border-radius: 4px; font-size: 0.9rem; border: none; cursor: pointer; }
    .pagination .btn:hover:not(.disabled) { background: #16213e; }
    .pagination .btn.disabled { background: #ccc; color: #666; cursor: not-allowed; }
  </style>
<jsp:include page="/WEB-INF/views/shared/_footer.jsp"/>
