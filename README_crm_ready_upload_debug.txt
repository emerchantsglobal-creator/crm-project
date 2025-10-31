READY-TO-UPLOAD CRM PACKAGE (DEBUG ENABLED)
Deploy path: /home/emglavox/crm.emglobalbposervices.com/

1. Upload folders/files into that path (index.php, .htaccess, leadscrm/, etc.).
2. Verify /leadscrm/config/db.php contains correct credentials.
3. Set permissions:
   cd /home/emglavox/crm.emglobalbposervices.com
   chown -R www-data:www-data .
   chmod -R 755 .
   chmod -R 775 leadscrm/uploads leadscrm/cache leadscrm/logs
4. Import DB:
   mysql -u emglavox_crmuser -p emglavox_leadscrm < emglavox_leadscrm_modified_for_import.sql
5. Access in browser:
   https://crm.emglobalbposervices.com/
   (PHP debug is ON — turn off later by commenting error_reporting lines.)
