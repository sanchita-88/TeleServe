<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
  </main>
  <footer class="app-footer">
    <p>&copy; <span id="year"></span> TeleServe &mdash; Telecom Customer Self-Care Portal</p>
  </footer>
  <style>
    .app-footer { margin-top: 2rem; padding: 1rem 1.5rem; background: #1a1a2e; color: #aaa; font-size: 0.875rem; text-align: center; }
    .app-footer p { margin: 0; }
  </style>
  <script>
    document.getElementById('year').textContent = new Date().getFullYear();
  </script>
</body>
</html>
