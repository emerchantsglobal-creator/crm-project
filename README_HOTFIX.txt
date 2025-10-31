
SMART CRM HOTFIX (2025-09-17)
--------------------------------
1) Run the SQL at: migrations/migrate_to_smart_crm.sql
   - Adds missing columns (users.username, users.owner_id, leads.status, leads.owner_id)
   - Creates a dme_leads view for the Owner AI widget
   - Adds helpful indexes
2) Deploy these files by replacing the corresponding paths on your server:
   - leadscrm/includes/bootstrap.php
   - leadscrm/pages/login.php
   - leadscrm/owner/owner_dashboard.php
   - leadscrm/config/openai_config.php
   - leadscrm/owner/owner_prediction_ai.php
3) Configure AI:
   - Set the environment variable OPENAI_API_KEY on your hosting if you want cloud AI responses.
   - Without a key, owner_prediction_ai.php still returns heuristic scores for UI continuity.
4) Post-deploy smoke tests:
   - Login as Admin, Owner, Sales (verify dashboards load)
   - Owner dashboard shows KPIs + recent leads
   - Submit a lead; confirm it appears for Owner and Admin
   - AI predictions endpoint: /leadscrm/owner/owner_prediction_ai.php (should return JSON)
