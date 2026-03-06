<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<c:set var="ctx" value="${pageContext.request.contextPath}"/>
<c:set var="pageTitle" value="Plan Management" scope="request"/>
<jsp:include page="/WEB-INF/views/shared/_header.jsp"/>
  <h1>Plan management</h1>
  <c:if test="${not empty sessionScope.flashError}">
    <div class="flash error"><c:out value="${sessionScope.flashError}"/></div>
    <c:remove var="flashError" scope="session"/>
  </c:if>

  <section class="card add-plan-card">
    <h2>Add plan</h2>
    <form method="post" action="${ctx}/admin/plans" class="plan-form">
      <input type="hidden" name="action" value="create"/>
      <div class="form-row">
        <label for="name">Name</label>
        <input type="text" id="name" name="name" required placeholder="e.g. Monthly 2GB"/>
      </div>
      <div class="form-row">
        <label for="price">Price (INR)</label>
        <input type="number" id="price" name="price" step="0.01" min="0" required placeholder="99.00"/>
      </div>
      <div class="form-row">
        <label for="dataGb">Data (GB)</label>
        <input type="number" id="dataGb" name="dataGb" step="0.01" min="0" required placeholder="2"/>
      </div>
      <div class="form-row">
        <label for="validityDays">Validity (days)</label>
        <input type="number" id="validityDays" name="validityDays" min="1" required placeholder="30"/>
      </div>
      <div class="form-row">
        <label for="category">Category</label>
        <input type="text" id="category" name="category" placeholder="e.g. Data"/>
      </div>
      <div class="form-row">
        <button type="submit" class="btn">Create plan</button>
      </div>
    </form>
  </section>

  <section class="card plans-list-card">
    <h2>Plans</h2>
    <div class="table-wrap">
      <table class="data-table">
        <thead>
          <tr>
            <th>Name</th>
            <th>Price</th>
            <th>Data (GB)</th>
            <th>Validity</th>
            <th>Category</th>
            <th>Active</th>
            <th>Actions</th>
          </tr>
        </thead>
        <tbody>
          <c:forEach var="p" items="${activePlans}">
            <tr>
              <td><c:out value="${p.name}"/></td>
              <td><fmt:formatNumber value="${p.price}" type="currency" currencyCode="INR"/></td>
              <td><c:out value="${p.dataGb}"/></td>
              <td><c:out value="${p.validityDays}"/> days</td>
              <td><c:out value="${p.category}"/></td>
              <td><c:out value="${p.active ? 'Yes' : 'No'}"/></td>
              <td class="actions">
                <c:if test="${p.active}">
                  <form method="post" action="${ctx}/admin/plans" class="inline-form">
                    <input type="hidden" name="action" value="deactivate"/>
                    <input type="hidden" name="planId" value="${p.planId}"/>
                    <button type="submit" class="btn btn-small btn-danger">Deactivate</button>
                  </form>
                </c:if>
              </td>
            </tr>
          </c:forEach>
        </tbody>
      </table>
    </div>
    <c:if test="${empty activePlans}">
      <p class="empty-msg">No plans yet. Add one above.</p>
    </c:if>
  </section>

  <style>
    .add-plan-card { margin-bottom: 1.5rem; }
    .add-plan-card h2, .plans-list-card h2 { margin: 0 0 1rem; font-size: 1.1rem; color: #1a1a2e; border-bottom: 1px solid #eee; padding-bottom: 0.5rem; }
    .plan-form { display: grid; grid-template-columns: repeat(auto-fill, minmax(180px, 1fr)); gap: 1rem; align-items: end; }
    .form-row { display: flex; flex-direction: column; gap: 0.25rem; }
    .form-row label { font-size: 0.9rem; font-weight: 500; color: #555; }
    .form-row input { padding: 0.5rem 0.75rem; border: 1px solid #ccc; border-radius: 4px; font-size: 1rem; }
    .form-row input:focus { outline: none; border-color: #1a1a2e; }
    .plan-form .btn { padding: 0.6rem 1rem; background: #1a1a2e; color: #fff; border: none; border-radius: 4px; font-size: 1rem; cursor: pointer; }
    .plan-form .btn:hover { background: #16213e; }
    .table-wrap { overflow-x: auto; margin-top: 0.5rem; }
    .data-table { width: 100%; border-collapse: collapse; }
    .data-table th, .data-table td { padding: 0.75rem 1rem; text-align: left; border-bottom: 1px solid #eee; }
    .data-table th { background: #f8f9fa; font-weight: 600; color: #1a1a2e; }
    .data-table tbody tr:hover { background: #f8f9fa; }
    .actions .inline-form { display: inline; }
    .btn-danger { background: #dc3545; }
    .btn-danger:hover { background: #c82333; }
    .empty-msg { margin-top: 1rem; color: #666; }
  </style>
<jsp:include page="/WEB-INF/views/shared/_footer.jsp"/>
