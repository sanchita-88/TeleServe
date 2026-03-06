# MODULE 10 — Final Review

## 1. Every file with its path

### Project root
| Path | Description |
|------|-------------|
| `README.md` | Project description, setup, Known Limitations |
| `.gitignore` | Build, IDE, OS, logs |
| `MODULE10-FINAL-REVIEW.md` | This audit |

### Web application
| Path | Description |
|------|-------------|
| `src/main/webapp/index.html` | Welcome redirect to login |
| `src/main/webapp/WEB-INF/web.xml` | Context params (DB), welcome file, error pages |
| `src/main/webapp/WEB-INF/db.properties` | Placeholder DB config |
| `src/main/webapp/WEB-INF/logging.properties` | Java Util Logging config |
| `src/main/webapp/WEB-INF/views/shared/_header.jsp` | Shared header + nav + flash |
| `src/main/webapp/WEB-INF/views/shared/_footer.jsp` | Shared footer |
| `src/main/webapp/WEB-INF/views/shared/error.jsp` | Generic error page |
| `src/main/webapp/WEB-INF/views/auth/login.jsp` | Login form |
| `src/main/webapp/WEB-INF/views/auth/register.jsp` | Registration form |
| `src/main/webapp/WEB-INF/views/user/dashboard.jsp` | User dashboard (cards, usage, suggestion) |
| `src/main/webapp/WEB-INF/views/user/recharge.jsp` | Plan grid + POST forms |
| `src/main/webapp/WEB-INF/views/user/history.jsp` | Paginated recharge history |
| `src/main/webapp/WEB-INF/views/admin/dashboard.jsp` | Admin stats cards |
| `src/main/webapp/WEB-INF/views/admin/users.jsp` | Paginated users + suspend/activate |
| `src/main/webapp/WEB-INF/views/admin/plans.jsp` | Plan list + add form + deactivate |

### Java source (controller, dao, filter, util, exception, listener, model, service)
| Path | Description |
|------|-------------|
| `src/main/java/com/teleserve/controller/auth/LoginServlet.java` | GET/POST login |
| `src/main/java/com/teleserve/controller/auth/RegisterServlet.java` | GET/POST register |
| `src/main/java/com/teleserve/controller/auth/LogoutServlet.java` | GET logout |
| `src/main/java/com/teleserve/controller/user/DashboardServlet.java` | User dashboard |
| `src/main/java/com/teleserve/controller/user/RechargeServlet.java` | Plan list + process recharge |
| `src/main/java/com/teleserve/controller/user/RechargeHistoryServlet.java` | Paginated history |
| `src/main/java/com/teleserve/controller/admin/AdminDashboardServlet.java` | Admin stats |
| `src/main/java/com/teleserve/controller/admin/UserManagementServlet.java` | User list + status update |
| `src/main/java/com/teleserve/controller/admin/PlanManagementServlet.java` | Plan list + create + deactivate |
| `src/main/java/com/teleserve/dao/UserDAO.java` | User CRUD + pagination |
| `src/main/java/com/teleserve/dao/PlanDAO.java` | Plan CRUD |
| `src/main/java/com/teleserve/dao/RechargeDAO.java` | Recharge + pagination |
| `src/main/java/com/teleserve/dao/UsageLogDAO.java` | Usage log + aggregation |
| `src/main/java/com/teleserve/filter/AuthFilter.java` | Protect /user/*, /admin/* |
| `src/main/java/com/teleserve/util/DBConnection.java` | DB singleton from context |
| `src/main/java/com/teleserve/util/PasswordUtil.java` | Hash/verify (PBKDF2) |
| `src/main/java/com/teleserve/util/SessionUtil.java` | Session user helpers |
| `src/main/java/com/teleserve/util/PaginationUtil.java` | Offset, total pages |
| `src/main/java/com/teleserve/util/AppLogger.java` | Logger factory |
| `src/main/java/com/teleserve/exception/DAOException.java` | DAO layer exception |
| `src/main/java/com/teleserve/exception/ServiceException.java` | Service layer exception |
| `src/main/java/com/teleserve/listener/AppContextListener.java` | DB + DAOs + services init |
| `src/main/java/com/teleserve/model/DashboardStats.java` | Admin stats POJO |
| `src/main/java/com/teleserve/service/AdminService.java` | Admin dashboard logic |

**Note:** The codebase also references `User`, `Plan`, `Recharge`, `PaginatedResult`, `UsageLog`, `AuthService`, `PlanService`, `RechargeService`, `UsageAnalyticsService`. If those live in the same project, add their paths under `model/` and `service/` accordingly.

---

## 2. Flagged hardcoded values

| Location | Value | Suggestion |
|----------|--------|------------|
| `WEB-INF/web.xml` | `db.url` = `jdbc:mysql://localhost:3306/teleserve?...` | Move to env or external config (e.g. JNDI or properties file loaded at startup). |
| `WEB-INF/web.xml` | `db.user` = `teleserve_user`, `db.password` = `change_me` | Do not commit real credentials; use placeholders and override via env/system properties or secret store. |
| `WEB-INF/db.properties` | Same DB URL, user, password | Same as above; treat as reference/placeholder only. |
| `AuthFilter.java` | `"/login"` redirect path | Consider a single constant or config (e.g. `login.path`) for reuse. |
| `AuthFilter.java` | `"admin"` role name | Consider a constant (e.g. `Role.ADMIN`) or config. |
| `UserManagementServlet.java` | `PAGE_SIZE = 10` | Could be context-param or config property for consistency with other pagination. |
| `PaginationUtil.java` | Default `pageSize = 10` | Same as above. |
| `SessionUtil.java` | `"currentUser"` session key | Optional: constant in one place if reused outside JSPs. |
| JSPs / `_header.jsp` | `#1a1a2e`, `960px`, etc. | Optional: CSS variables or a small theme file for branding/layout. |

---

## 3. JSPs: no Java logic

- **Check:** Grep for `<% ... %>`, `<%= %>`, `<%!` in all `*.jsp` under `WEB-INF/views/`.
- **Result:** Only valid JSP directives appear (`<%@ page ... %>`, `<%@ taglib ... %>`). No scriptlets or expression scriptlets.
- **Conclusion:** No JSP contains Java logic; views use JSTL only (`c:if`, `c:choose`, `c:forEach`, `c:out`, `fmt:formatNumber`, etc.).

---

## 4. Servlets: no SQL

- **Check:** Grep for SQL keywords (`SELECT`, `INSERT`, `UPDATE`, `DELETE`, `FROM `, `WHERE `) in `com.teleserve.controller` (all servlets).
- **Result:** No matches in the controller package.
- **Conclusion:** No servlet contains SQL; all data access is in the DAO layer (`UserDAO`, `PlanDAO`, `RechargeDAO`, `UsageLogDAO`).

---

## 5. Three improvements toward Spring Boot migration

1. **Replace ServletContext and manual wiring with Spring context**  
   Move DAO and service creation from `AppContextListener` into `@Configuration` classes and `@Bean` methods (or component scan). Replace `getServletContext().getAttribute("authService")` (and similar) in servlets with `@Autowired` (or constructor injection). Replace `DBConnection.init(ServletContext)` with Spring’s `DataSource` (e.g. `DataSourceAutoConfiguration` and `application.properties`). Use `@Controller` + `@GetMapping`/`@PostMapping` instead of `HttpServlet` subclasses, and keep the same URL patterns and request/response behavior.

2. **Externalize config and use a single DataSource abstraction**  
   Replace `web.xml` context-params and `db.properties` with `application.properties`/`application.yml` (e.g. `spring.datasource.url`, `username`, `password`, `driver-class-name`). Use environment-specific profiles or env variables for credentials. Introduce a single `DataSource` bean used by all DAOs; optionally replace raw JDBC with `JdbcTemplate` or Spring Data repositories for a clearer path to JPA later.

3. **Replace JSP + JSTL with a template engine and optional SPA**  
   Introduce Spring MVC view resolution with Thymeleaf or FreeMarker (or a REST API + front-end). Map current JSPs to template names and keep the same request attributes (e.g. `stats`, `userResult`, `rechargeResult`). Move flash/session handling to `RedirectAttributes` and `@SessionAttribute` where appropriate. This keeps the same UX while aligning with typical Spring Boot stacks and prepares for an optional future move to a REST API + React/Vue/Angular.
