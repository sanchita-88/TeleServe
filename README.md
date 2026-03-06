# TeleServe — Telecom Customer Self-Care Portal

A Java EE web application for telecom customer self-care: registration, login, plan recharge, usage view, and admin management of users and plans.

## Tech stack

- **Java EE** (Servlets, JSP, JSTL, Filters, Listeners)
- **Plain JDBC** for database access
- **No frameworks** (no Spring); plain CSS (no Bootstrap)

## Structure

- `src/main/java/com/teleserve/` — model, dao, service, controller, filter, util, exception, listener
- `src/main/webapp/` — web root; `WEB-INF/views/` for JSPs
- `WEB-INF/web.xml` — context params (DB), welcome file, error pages
- `WEB-INF/db.properties` — placeholder DB config (app reads from `web.xml` context-params)
- `WEB-INF/logging.properties` — Java Util Logging config

## Setup

1. Create a MySQL database and user (e.g. database `teleserve`, user `teleserve_user`).
2. Run the schema scripts to create `users`, `plans`, `recharges`, `usage_logs` (or equivalent) tables.
3. Set context-params in `WEB-INF/web.xml` (or override via your container) for `db.url`, `db.user`, `db.password`, `db.driver`.
4. Deploy the application to a Servlet 4.0 container (e.g. Tomcat 9+).
5. Optional: set `-Djava.util.logging.config.file` to `WEB-INF/logging.properties` for logging.

## Usage

- **Guests:** `/register`, `/login`
- **Users:** `/user/dashboard`, `/user/recharge`, `/user/history`
- **Admins:** `/admin/dashboard`, `/admin/users`, `/admin/plans`

Root `/` redirects to `/login`.

## Known Limitations

- **Mock data only** — The application does not integrate with a real telecom network. Usage and plan data are stored and computed from in-app data only.
- **No real telecom network integration** — Recharges, usage, and plan validity are simulated. There is no connection to actual billing or network systems.
- **Plan suggestion is rule-based logic, not ML** — The “suggested plan” on the user dashboard is computed with simple rules (e.g. utilization, plan limits), not machine learning or predictive models.
