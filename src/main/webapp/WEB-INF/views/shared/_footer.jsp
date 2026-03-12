<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
  </main>
  <footer class="app-footer">
    <div class="footer-inner">
      <div class="footer-brand">
        <span class="footer-dot"></span>
        TeleServe
      </div>
      <p>&copy; <span id="year"></span> TeleServe &mdash; Telecom Customer Self-Care Portal</p>
    </div>
  </footer>
  <style>
    .app-footer {
      margin-top: auto;
      padding: 1.5rem 2rem;
      background: linear-gradient(135deg, #1e1b4b 0%, #312e81 100%);
      color: rgba(255,255,255,0.5);
      font-size: 0.825rem;
      text-align: center;
      position: relative;
    }

    .app-footer::before {
      content: '';
      position: absolute;
      top: 0; left: 0;
      width: 100%; height: 1px;
      background: linear-gradient(90deg, transparent, #67e8f9, #818cf8, transparent);
      opacity: 0.3;
    }

    .footer-inner {
      display: flex;
      flex-direction: column;
      align-items: center;
      gap: 0.5rem;
    }

    .footer-brand {
      display: flex;
      align-items: center;
      gap: 0.4rem;
      font-family: 'Plus Jakarta Sans', sans-serif;
      font-weight: 700;
      font-size: 0.95rem;
      color: rgba(255,255,255,0.7);
    }

    .footer-dot {
      width: 6px; height: 6px;
      background: #06b6d4;
      border-radius: 50%;
      box-shadow: 0 0 6px rgba(6,182,212,0.5);
    }

    .app-footer p { margin: 0; }
  </style>
  <script>
    document.getElementById('year').textContent = new Date().getFullYear();
  </script>
</body>
</html>