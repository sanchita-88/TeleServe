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
  <link rel="preconnect" href="https://fonts.googleapis.com">
  <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
  <link href="https://fonts.googleapis.com/css2?family=DM+Sans:opsz,wght@9..40,300..700&family=Plus+Jakarta+Sans:wght@500;600;700;800&display=swap" rel="stylesheet">
  <style>
    *, *::before, *::after { box-sizing: border-box; margin: 0; padding: 0; }

    :root {
      --primary: #4f46e5;
      --primary-dark: #3730a3;
      --primary-light: #818cf8;
      --accent: #06b6d4;
      --accent-light: #67e8f9;
      --bg: #f0f4ff;
      --bg-card: #ffffff;
      --text: #1e293b;
      --text-muted: #64748b;
      --text-light: #94a3b8;
      --border: #e2e8f0;
      --success-bg: #ecfdf5;
      --success-text: #065f46;
      --success-border: #a7f3d0;
      --error-bg: #fef2f2;
      --error-text: #991b1b;
      --error-border: #fecaca;
      --shadow-md: 0 4px 6px -1px rgba(0,0,0,0.07), 0 2px 4px -2px rgba(0,0,0,0.05);
      --shadow-lg: 0 10px 25px -5px rgba(0,0,0,0.08), 0 8px 10px -6px rgba(0,0,0,0.04);
      --shadow-glow: 0 0 20px rgba(79,70,229,0.15);
      --radius: 12px;
      --radius-lg: 16px;
      --transition: 0.3s cubic-bezier(0.4, 0, 0.2, 1);
    }

    body {
      font-family: 'DM Sans', system-ui, sans-serif;
      font-size: 15px;
      line-height: 1.6;
      color: var(--text);
      background: var(--bg);
      min-height: 100vh;
      display: flex;
      flex-direction: column;
    }

    .app-header {
      background: linear-gradient(135deg, #1e1b4b 0%, #312e81 50%, #1e1b4b 100%);
      color: #fff;
      padding: 0 2rem;
      display: flex;
      align-items: center;
      justify-content: space-between;
      flex-wrap: wrap;
      gap: 0.75rem;
      height: 64px;
      position: sticky;
      top: 0;
      z-index: 100;
      box-shadow: 0 4px 20px rgba(30,27,75,0.3);
      animation: headerSlide 0.6s ease-out;
    }

    @keyframes headerSlide {
      from { transform: translateY(-100%); opacity: 0; }
      to { transform: translateY(0); opacity: 1; }
    }

    .app-header::after {
      content: '';
      position: absolute;
      bottom: 0; left: 0;
      width: 100%; height: 1px;
      background: linear-gradient(90deg, transparent, var(--accent-light), var(--primary-light), transparent);
      opacity: 0.4;
    }

    .brand {
      font-family: 'Plus Jakarta Sans', sans-serif;
      font-weight: 800;
      font-size: 1.35rem;
      text-decoration: none;
      color: #fff;
      display: flex;
      align-items: center;
      gap: 0.5rem;
    }

    .brand::before {
      content: '';
      width: 8px; height: 8px;
      background: var(--accent);
      border-radius: 50%;
      box-shadow: 0 0 8px var(--accent), 0 0 16px rgba(6,182,212,0.4);
      animation: pulse 2s ease-in-out infinite;
    }

    @keyframes pulse {
      0%, 100% { opacity: 1; transform: scale(1); }
      50% { opacity: 0.7; transform: scale(1.2); }
    }

    .nav { display: flex; align-items: center; gap: 0.25rem; }

    .nav a, .nav span {
      color: rgba(255,255,255,0.8);
      text-decoration: none;
      font-size: 0.875rem;
      font-weight: 500;
      padding: 0.4rem 0.85rem;
      border-radius: 8px;
      transition: var(--transition);
    }

    .nav a:hover {
      color: #fff;
      background: rgba(255,255,255,0.1);
    }

    .nav .user-name {
      color: var(--accent-light);
      font-weight: 600;
      font-size: 0.8rem;
      padding: 0.3rem 0.75rem;
      background: rgba(6,182,212,0.1);
      border: 1px solid rgba(6,182,212,0.2);
      border-radius: 20px;
    }

    .nav .nav-logout {
      color: rgba(255,255,255,0.6);
      font-size: 0.8rem;
    }

    .nav .nav-logout:hover {
      color: #fca5a5;
      background: rgba(239,68,68,0.1);
    }

    .flash {
      padding: 0.75rem 1.25rem;
      margin: 1rem auto;
      max-width: 960px;
      border-radius: var(--radius);
      font-size: 0.9rem;
      font-weight: 500;
      animation: flashIn 0.5s ease-out;
    }

    .flash.success { background: var(--success-bg); color: var(--success-text); border: 1px solid var(--success-border); }
    .flash.error { background: var(--error-bg); color: var(--error-text); border: 1px solid var(--error-border); }

    @keyframes flashIn {
      from { opacity: 0; transform: translateY(-10px); }
      to { opacity: 1; transform: translateY(0); }
    }

    .content {
      max-width: 960px;
      margin: 0 auto;
      padding: 2rem 1.5rem;
      flex: 1;
      width: 100%;
    }

    @keyframes fadeInUp {
      from { opacity: 0; transform: translateY(20px); }
      to { opacity: 1; transform: translateY(0); }
    }

    .auth-card {
      max-width: 420px;
      margin: 3rem auto;
      padding: 2.5rem;
      background: var(--bg-card);
      border-radius: var(--radius-lg);
      box-shadow: var(--shadow-lg), var(--shadow-glow);
      border: 1px solid rgba(79,70,229,0.08);
      animation: cardAppear 0.7s cubic-bezier(0.16, 1, 0.3, 1) both;
      position: relative;
      overflow: hidden;
    }

    .auth-card::before {
      content: '';
      position: absolute;
      top: 0; left: 0; right: 0;
      height: 4px;
      background: linear-gradient(90deg, var(--primary), var(--accent), var(--primary-light));
      background-size: 200% 100%;
      animation: gradientSlide 3s ease-in-out infinite;
    }

    @keyframes gradientSlide {
      0%, 100% { background-position: 0% 50%; }
      50% { background-position: 100% 50%; }
    }

    @keyframes cardAppear {
      from { opacity: 0; transform: translateY(30px) scale(0.97); }
      to { opacity: 1; transform: translateY(0) scale(1); }
    }

    .auth-card h1 {
      font-family: 'Plus Jakarta Sans', sans-serif;
      font-weight: 700;
      font-size: 1.65rem;
      margin-bottom: 0.35rem;
    }

    .auth-card .auth-subtitle {
      color: var(--text-muted);
      font-size: 0.9rem;
      margin-bottom: 1.75rem;
    }

    .auth-form { display: flex; flex-direction: column; gap: 0.25rem; }

    .auth-form .form-group {
      display: flex;
      flex-direction: column;
      gap: 0.35rem;
      margin-bottom: 0.75rem;
    }

    .auth-form label {
      font-weight: 600;
      font-size: 0.825rem;
    }

    .auth-form input {
      padding: 0.7rem 1rem;
      border: 1.5px solid var(--border);
      border-radius: 10px;
      font-size: 0.95rem;
      font-family: 'DM Sans', sans-serif;
      color: var(--text);
      background: #f8fafc;
      transition: var(--transition);
      outline: none;
    }

    .auth-form input::placeholder { color: var(--text-light); }

    .auth-form input:focus {
      border-color: var(--primary);
      background: #fff;
      box-shadow: 0 0 0 3px rgba(79,70,229,0.1);
    }

    .auth-form .btn {
      padding: 0.75rem 1.5rem;
      background: linear-gradient(135deg, var(--primary) 0%, var(--primary-dark) 100%);
      color: #fff;
      border: none;
      border-radius: 10px;
      font-size: 0.95rem;
      font-weight: 600;
      font-family: 'DM Sans', sans-serif;
      cursor: pointer;
      margin-top: 0.5rem;
      transition: var(--transition);
    }

    .auth-form .btn:hover {
      transform: translateY(-1px);
      box-shadow: 0 6px 20px rgba(79,70,229,0.35);
    }

    .auth-form .btn:active { transform: translateY(0); }

    .auth-link {
      margin-top: 1.75rem;
      text-align: center;
      color: var(--text-muted);
      font-size: 0.875rem;
    }

    .auth-link a {
      color: var(--primary);
      font-weight: 600;
      text-decoration: none;
    }

    .auth-link a:hover { text-decoration: underline; }

    .card {
      background: var(--bg-card);
      border-radius: var(--radius);
      padding: 1.5rem;
      box-shadow: var(--shadow-md);
      border: 1px solid var(--border);
      transition: var(--transition);
    }

    .card:hover {
      box-shadow: var(--shadow-lg);
      transform: translateY(-2px);
    }

    .card-grid {
      display: grid;
      grid-template-columns: repeat(auto-fit, minmax(260px, 1fr));
      gap: 1.25rem;
      margin-top: 1.5rem;
    }

    .stat-value {
      font-family: 'Plus Jakarta Sans', sans-serif;
      font-size: 1.75rem;
      font-weight: 800;
      color: var(--primary);
    }

    .stat-label {
      font-size: 0.825rem;
      color: var(--text-muted);
      font-weight: 500;
      margin-top: 0.25rem;
    }

    .page-title {
      font-family: 'Plus Jakarta Sans', sans-serif;
      font-size: 1.65rem;
      font-weight: 700;
      margin-bottom: 0.25rem;
    }

    .page-subtitle {
      color: var(--text-muted);
      font-size: 0.925rem;
      margin-bottom: 1.5rem;
    }

    .data-table { width: 100%; border-collapse: collapse; font-size: 0.9rem; }

    .data-table th {
      text-align: left;
      padding: 0.75rem 1rem;
      background: #f8fafc;
      color: var(--text-muted);
      font-weight: 600;
      font-size: 0.8rem;
      text-transform: uppercase;
      letter-spacing: 0.05em;
      border-bottom: 2px solid var(--border);
    }

    .data-table td {
      padding: 0.75rem 1rem;
      border-bottom: 1px solid var(--border);
    }

    .data-table tbody tr:hover { background: rgba(79,70,229,0.02); }

    .badge {
      display: inline-block;
      padding: 0.2rem 0.65rem;
      font-size: 0.75rem;
      font-weight: 600;
      border-radius: 20px;
    }

    .badge-success { background: var(--success-bg); color: var(--success-text); }
    .badge-error { background: var(--error-bg); color: var(--error-text); }
    .badge-info { background: #eff6ff; color: #1e40af; }

    /* ===== ANIMATED GRADIENT WAVES ===== */
    .bg-waves {
      position: fixed;
      top: 0; left: 0;
      width: 100%; height: 100%;
      z-index: -1;
      pointer-events: none;
      overflow: hidden;
      background: linear-gradient(-45deg, #e0e7ff, #f0f4ff, #cffafe, #ede9fe, #e0f2fe, #f0f4ff);
      background-size: 400% 400%;
      animation: gradientWave 12s ease infinite;
    }

    .bg-waves::before {
      content: '';
      position: absolute;
      top: 0; left: 0;
      width: 100%; height: 100%;
      background: linear-gradient(135deg, rgba(79,70,229,0.08) 0%, transparent 40%, rgba(6,182,212,0.08) 60%, transparent 100%);
      background-size: 300% 300%;
      animation: gradientWave 8s ease infinite reverse;
    }

    .bg-waves::after {
      content: '';
      position: absolute;
      top: 0; left: 0;
      width: 100%; height: 100%;
      background: linear-gradient(225deg, transparent 0%, rgba(129,140,248,0.06) 30%, transparent 50%, rgba(6,182,212,0.06) 70%, transparent 100%);
      background-size: 350% 350%;
      animation: gradientWave 15s ease infinite;
    }

    @keyframes gradientWave {
      0% { background-position: 0% 50%; }
      25% { background-position: 50% 0%; }
      50% { background-position: 100% 50%; }
      75% { background-position: 50% 100%; }
      100% { background-position: 0% 50%; }
    }

    @media (max-width: 640px) {
      .app-header { padding: 0.75rem 1rem; height: auto; }
      .nav { gap: 0.15rem; flex-wrap: wrap; }
      .nav a, .nav span { font-size: 0.8rem; padding: 0.3rem 0.6rem; }
      .content { padding: 1.25rem 1rem; }
      .auth-card { margin: 1.5rem auto; padding: 1.75rem; }
      .card-grid { grid-template-columns: 1fr; }
    }
  </style>
</head>
<body>
  <div class="bg-waves"></div>
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
          <c:if test="${user.role != 'ADMIN'}">
            <a href="${ctx}/user/dashboard">Dashboard</a>
            <a href="${ctx}/user/recharge">Recharge</a>
            <a href="${ctx}/user/history">History</a>
          </c:if>
          <span class="user-name"><c:out value="${user.fullName}"/></span>
          <a href="${ctx}/logout" class="nav-logout">Logout</a>
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