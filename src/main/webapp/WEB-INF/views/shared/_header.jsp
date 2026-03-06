<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<c:set var="ctx" value="${pageContext.request.contextPath}"/>
<c:set var="user" value="${sessionScope.currentUser}"/>
<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <title><c:out value="${pageTitle}" default="TeleServe"/></title>
  <style>
    * { box-sizing: border-box; }
    body { margin: 0; font-family: system-ui, -apple-system, sans-serif; font-size: 15px; line-height: 1.5; color: #333; background: #f5f5f5; }
    .app-header { background: #1a1a2e; color: #eee; padding: 0.75rem 1.5rem; display: flex; align-items: center; justify-content: space-between; flex-wrap: wrap; gap: 0.75rem; }
    .app-header a { color: #eee; text-decoration: none; }
    .app-header a:hover { text-decoration: underline; }
    .brand { font-weight: 700; font-size: 1.25rem; }
    .nav { display: flex; align-items: center; gap: 1.25rem; }
    .flash { padding: 0.5rem 1rem; margin: 0 1.5rem 1rem; border-radius: 4px; }
    .flash.success { background: #d4edda; color: #155724; border: 1px solid #c3e6cb; }
    .flash.error { background: #f8d7da; color: #721c24; border: 1px solid #f5c6cb; }
    .content { max-width: 960px; margin: 0 auto; padding: 1.5rem; }
  </style>
</head>
<body>
  <header class="app-header">
    <a href="${ctx}/user/dashboard" class="brand">TeleServe</a>
    <nav class="nav">
      <c:choose>
        <c:when test="${user != null}">
          <c:if test="${user.role == 'ADMIN'}">
            <a href="${ctx}/admin/dashboard">Admin</a>
            <a href="${ctx}/admin/users">Users</a>
            <a href="${ctx}/admin/plans">Plans</a>
          </c:if>
          <c:if test="${user.role == 'ADMIN'}">
            <a href="${ctx}/user/dashboard">Dashboard</a>
            <a href="${ctx}/user/recharge">Recharge</a>
            <a href="${ctx}/user/history">History</a>
          </c:if>
          <span><c:out value="${user.fullName}"/></span>
          <a href="${ctx}/logout">Logout</a>
        </c:when>
        <c:otherwise>
          <a href="${ctx}/login">Login</a>
          <a href="${ctx}/register">Register</a>
        </c:otherwise>
      </c:choose>
    </nav>
  </header>
  <c:if test="${not empty sessionScope.flashMessage}">
    <div class="flash success"><c:out value="${sessionScope.flashMessage}"/></div>
    <c:remove var="flashMessage" scope="session"/>
  </c:if>
  <main class="content">
