<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<c:set var="ctx" value="${pageContext.request.contextPath}"/>
<c:set var="pageTitle" value="Register — TeleServe" scope="request"/>
<jsp:include page="/WEB-INF/views/shared/_header.jsp"/>
  <div class="auth-card">
    <div class="auth-icon">
      <svg width="48" height="48" viewBox="0 0 48 48" fill="none">
        <rect width="48" height="48" rx="14" fill="url(#regGrad)" fill-opacity="0.1"/>
        <path d="M20 21c2.76 0 5-2.24 5-5s-2.24-5-5-5-5 2.24-5 5 2.24 5 5 5zm0-8c1.65 0 3 1.35 3 3s-1.35 3-3 3-3-1.35-3-3 1.35-3 3-3zm0 10c-3.33 0-10 1.67-10 5v3h20v-3c0-3.33-6.67-5-10-5zm-8 6c.22-1.16 4.18-3 8-3s7.78 1.84 8 3H12zm20-7v-3h3v-2h-3v-3h-2v3h-3v2h3v3h2z" fill="url(#regGrad)"/>
        <defs><linearGradient id="regGrad" x1="0" y1="0" x2="48" y2="48"><stop stop-color="#4f46e5"/><stop offset="1" stop-color="#06b6d4"/></linearGradient></defs>
      </svg>
    </div>
    <h1>Create account</h1>
    <p class="auth-subtitle">Join TeleServe to manage your telecom services</p>
    <c:if test="${not empty errorMessage}">
      <div class="flash error"><c:out value="${errorMessage}"/></div>
    </c:if>
    <form method="post" action="${ctx}/register" class="auth-form">
      <div class="form-group">
        <label for="fullName">Full name</label>
        <div class="input-wrapper">
          <svg class="input-icon" width="18" height="18" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"><path d="M20 21v-2a4 4 0 0 0-4-4H8a4 4 0 0 0-4 4v2"/><circle cx="12" cy="7" r="4"/></svg>
          <input type="text" id="fullName" name="fullName" required autocomplete="name" placeholder="John Doe" value="<c:out value="${fullName}"/>"/>
        </div>
      </div>
      <div class="form-group">
        <label for="phone">Phone number</label>
        <div class="input-wrapper">
          <svg class="input-icon" width="18" height="18" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"><path d="M22 16.92v3a2 2 0 0 1-2.18 2 19.79 19.79 0 0 1-8.63-3.07 19.5 19.5 0 0 1-6-6 19.79 19.79 0 0 1-3.07-8.67A2 2 0 0 1 4.11 2h3a2 2 0 0 1 2 1.72c.127.96.361 1.903.7 2.81a2 2 0 0 1-.45 2.11L8.09 9.91a16 16 0 0 0 6 6l1.27-1.27a2 2 0 0 1 2.11-.45c.907.339 1.85.573 2.81.7A2 2 0 0 1 22 16.92z"/></svg>
          <input type="tel" id="phone" name="phone" required autocomplete="tel" placeholder="e.g. 9876543210" value="<c:out value="${phone}"/>"/>
        </div>
      </div>
      <div class="form-group">
        <label for="email">Email address</label>
        <div class="input-wrapper">
          <svg class="input-icon" width="18" height="18" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"><rect x="2" y="4" width="20" height="16" rx="2"/><path d="m22 7-8.97 5.7a1.94 1.94 0 0 1-2.06 0L2 7"/></svg>
          <input type="email" id="email" name="email" required autocomplete="email" placeholder="you@example.com" value="<c:out value="${email}"/>"/>
        </div>
      </div>
      <div class="form-group">
        <label for="password">Password</label>
        <div class="input-wrapper">
          <svg class="input-icon" width="18" height="18" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"><rect x="3" y="11" width="18" height="11" rx="2" ry="2"/><path d="M7 11V7a5 5 0 0 1 10 0v4"/></svg>
          <input type="password" id="password" name="password" required autocomplete="new-password" placeholder="Choose a strong password"/>
        </div>
      </div>
      <button type="submit" class="btn">
        Create account
        <svg width="18" height="18" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"><path d="M5 12h14"/><path d="m12 5 7 7-7 7"/></svg>
      </button>
    </form>
    <div class="auth-divider"><span>or</span></div>
    <p class="auth-link">Already have an account? <a href="${ctx}/login">Sign in</a></p>
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
    .form-group:nth-child(2) { animation-delay: 0.15s; }
    .form-group:nth-child(3) { animation-delay: 0.2s; }
    .form-group:nth-child(4) { animation-delay: 0.25s; }

    .auth-form .btn {
      animation: fadeInUp 0.5s ease-out both;
      animation-delay: 0.35s;
    }
  </style>
<jsp:include page="/WEB-INF/views/shared/_footer.jsp"/>