<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<c:set var="ctx" value="${pageContext.request.contextPath}"/>
<c:set var="pageTitle" value="Login — TeleServe" scope="request"/>
<jsp:include page="/WEB-INF/views/shared/_header.jsp"/>
  <div class="auth-card">
    <div class="auth-icon">
      <svg width="48" height="48" viewBox="0 0 48 48" fill="none">
        <rect width="48" height="48" rx="14" fill="url(#iconGrad)" fill-opacity="0.1"/>
        <path d="M24 14c-3.87 0-7 3.13-7 7 0 2.68 1.5 5 3.71 6.18C17.31 28.58 15 31.52 15 35h2c0-3.87 3.13-7 7-7s7 3.13 7 7h2c0-3.48-2.31-6.42-5.71-7.82C29.5 26 31 23.68 31 21c0-3.87-3.13-7-7-7zm0 2c2.76 0 5 2.24 5 5s-2.24 5-5 5-5-2.24-5-5 2.24-5 5-5z" fill="url(#iconGrad)"/>
        <defs><linearGradient id="iconGrad" x1="0" y1="0" x2="48" y2="48"><stop stop-color="#4f46e5"/><stop offset="1" stop-color="#06b6d4"/></linearGradient></defs>
      </svg>
    </div>
    <h1>Welcome back</h1>
    <p class="auth-subtitle">Sign in to manage your telecom services</p>
    <c:if test="${not empty errorMessage}">
      <div class="flash error"><c:out value="${errorMessage}"/></div>
    </c:if>
    <form method="post" action="${ctx}/login" class="auth-form">
      <div class="form-group">
        <label for="email">Email address</label>
        <div class="input-wrapper">
          <svg class="input-icon" width="18" height="18" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"><rect x="2" y="4" width="20" height="16" rx="2"/><path d="m22 7-8.97 5.7a1.94 1.94 0 0 1-2.06 0L2 7"/></svg>
          <input type="email" id="email" name="email" required autocomplete="email" placeholder="you@example.com"/>
        </div>
      </div>
      <div class="form-group">
        <label for="password">Password</label>
        <div class="input-wrapper">
          <svg class="input-icon" width="18" height="18" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"><rect x="3" y="11" width="18" height="11" rx="2" ry="2"/><path d="M7 11V7a5 5 0 0 1 10 0v4"/></svg>
          <input type="password" id="password" name="password" required autocomplete="current-password" placeholder="Enter your password"/>
        </div>
      </div>
      <div class="remember-group">
        <label class="remember-label">
          <input type="checkbox" name="rememberMe" class="remember-check"/>
          <span class="remember-box"></span>
          Remember me for 30 days
        </label>
      </div>
      <button type="submit" class="btn">
        Sign in
        <svg width="18" height="18" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"><path d="M5 12h14"/><path d="m12 5 7 7-7 7"/></svg>
      </button>
    </form>
    <div class="auth-divider"><span>or</span></div>
    <p class="auth-link">Don't have an account? <a href="${ctx}/register">Create one for free</a></p>
  </div>
  <style>
    .auth-icon {
      margin-bottom: 1.25rem;
      animation: fadeInUp 0.5s ease-out both;
    }

    .input-wrapper {
      position: relative;
      display: flex;
      align-items: center;
    }

    .input-icon {
      position: absolute;
      left: 0.85rem;
      color: var(--text-light);
      pointer-events: none;
      transition: var(--transition);
    }

    .input-wrapper input {
      padding-left: 2.75rem !important;
      width: 100%;
    }

    .input-wrapper:focus-within .input-icon {
      color: var(--primary);
    }

    .auth-form .btn {
      display: flex;
      align-items: center;
      justify-content: center;
      gap: 0.5rem;
    }

    .auth-form .btn svg {
      transition: transform 0.3s ease;
    }

    .auth-form .btn:hover svg {
      transform: translateX(3px);
    }

    .auth-divider {
      display: flex;
      align-items: center;
      margin: 1.5rem 0;
      gap: 1rem;
    }

    .auth-divider::before,
    .auth-divider::after {
      content: '';
      flex: 1;
      height: 1px;
      background: var(--border);
    }

    .auth-divider span {
      font-size: 0.8rem;
      color: var(--text-light);
      text-transform: uppercase;
      letter-spacing: 0.05em;
    }

    .form-group {
      animation: fadeInUp 0.5s ease-out both;
    }

    .form-group:nth-child(1) { animation-delay: 0.1s; }
    .form-group:nth-child(2) { animation-delay: 0.2s; }

    .auth-form .btn {
      animation: fadeInUp 0.5s ease-out both;
      animation-delay: 0.3s;
    }
    .remember-group {
      margin-top: 0.25rem;
      animation: fadeInUp 0.5s ease-out both;
      animation-delay: 0.25s;
    }

    .remember-label {
      display: flex;
      align-items: center;
      gap: 0.5rem;
      font-size: 0.85rem;
      color: var(--text-muted);
      cursor: pointer;
      user-select: none;
    }

    .remember-check {
      display: none;
    }

    .remember-box {
      width: 18px; height: 18px;
      border: 1.5px solid var(--border);
      border-radius: 5px;
      display: flex;
      align-items: center;
      justify-content: center;
      transition: var(--transition);
      flex-shrink: 0;
      background: #f8fafc;
    }

    .remember-check:checked + .remember-box {
      background: var(--primary);
      border-color: var(--primary);
    }

    .remember-check:checked + .remember-box::after {
      content: '';
      width: 5px; height: 9px;
      border: solid #fff;
      border-width: 0 2px 2px 0;
      transform: rotate(45deg);
      margin-bottom: 2px;
    }
  </style>
<jsp:include page="/WEB-INF/views/shared/_footer.jsp"/>