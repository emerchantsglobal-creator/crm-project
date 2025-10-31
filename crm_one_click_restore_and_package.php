<?php
/**
 * crm_one_click_restore_and_package.php
 * - Restores the latest Dashboards_backup_* to Dashboards/
 * - Applies minimal PDO fixes to files under leadscrm/Dashboards
 * - Creates a zip of the full site: crm_final_fixed_package.zip
 *
 * USAGE:
 * 1. Upload this to /home/emglavox/crm.emglobalbposervices.com/
 * 2. Visit in browser: https://crm.emglobalbposervices.com/crm_one_click_restore_and_package.php
 * 3. Follow on-screen output. Delete the file after success.
 *
 * SECURITY: Delete this file after running.
 */
ini_set('display_errors',1);
error_reporting(E_ALL);

$root = __DIR__;
$leads = $root . '/leadscrm';
$logfile = $leads . '/fix_restore_log.txt';
$zipOut = $root . '/crm_final_fixed_package.zip';

function logline($s) {
    global $logfile;
    $t = date('Y-m-d H:i:s') . " - " . $s . PHP_EOL;
    echo nl2br(htmlspecialchars($t));
    file_put_contents($logfile, $t, FILE_APPEND);
}

echo "<h3>One-click Restore & Package</h3><pre>";
if (!is_dir($leads)) { die("ERROR: leadscrm folder not found at: $leads\n"); }
logline("Found leadscrm at $leads");

// 1) Find latest Dashboards_backup_*
$backups = glob($leads . '/Dashboards_backup_*', GLOB_ONLYDIR);
if (!$backups) {
    logline("ERROR: No Dashboards_backup_* folder found. Aborting (no restore).");
    echo "</pre>";
    exit;
}
usort($backups, function($a,$b){ return filemtime($b) - filemtime($a); });
$latestBackup = $backups[0];
logline("Latest backup located: $latestBackup");

// 2) Backup current Dashboards (if exists)
$currentDash = $leads . '/Dashboards';
$timestamp = date('Ymd_His');
if (is_dir($currentDash)) {
    $moveTo = $leads . '/Dashboards_before_restore_' . $timestamp;
    if (!rename($currentDash, $moveTo)) {
        logline("ERROR: Could not move current Dashboards to $moveTo. Aborting.");
        echo "</pre>";
        exit;
    }
    logline("Moved existing Dashboards to: $moveTo");
} else {
    logline("No current Dashboards folder found — will restore from backup.");
}

// 3) Restore latest backup
if (!rename($latestBackup, $currentDash)) {
    logline("ERROR: Failed to rename $latestBackup -> $currentDash. Aborting.");
    echo "</pre>";
    exit;
}
logline("Restored backup: $latestBackup -> $currentDash");

// 4) Apply PDO fixes only inside leadscrm/Dashboards
$files = glob($currentDash . '/*.php');
if (!$files) {
    logline("WARNING: No PHP files found under $currentDash. (Nothing to fix)");
} else {
    $totalChanged = 0;
    foreach ($files as $file) {
        $orig = file_get_contents($file);
        $modified = $orig;

        // 4a) Replace fetch_assoc() -> fetch(PDO::FETCH_ASSOC)
        // Only literal fetch_assoc() patterns will be replaced
        $modified = str_replace('->fetch_assoc()', '->fetch(PDO::FETCH_ASSOC)', $modified);

        // 4b) Replace common pattern: if ($res && $row = $res->fetch_assoc())
        $modified = str_replace('= $res->fetch_assoc()', '= $res->fetch(PDO::FETCH_ASSOC)', $modified);

        // 4c) If the file contains a getCount() function in mysqli style, replace it with PDO-safe version
        if (strpos($modified, 'function getCount') !== false) {
            // Replace entire getCount function if present (naive but targeted)
            $modified = preg_replace(
                '/function\s+getCount\s*\([^\)]*\)\s*\{[^\}]*\}/s',
                "function getCount(\$conn, \$table) {\n    try {\n        \$stmt = \$conn->query(\"SELECT COUNT(*) AS cnt FROM `\$table`\");\n        \$row = \$stmt->fetch(PDO::FETCH_ASSOC);\n        return (int)(\$row['cnt'] ?? 0);\n    } catch (Exception \$e) {\n        return 0;\n    }\n}",
                $modified
            );
        }

        if ($modified !== $orig) {
            file_put_contents($file, $modified);
            $changes = substr_count($modified, "PDO::FETCH_ASSOC") - substr_count($orig, "PDO::FETCH_ASSOC");
            logline("Patched file: " . basename($file) . " (changes: " . max(1,$changes) . ")");
            $totalChanged++;
        } else {
            logline("No changes needed: " . basename($file));
        }
    }
    logline("Completed PDO patching for Dashboards: $totalChanged files updated.");
}

// 5) Ensure permissions on restored folder
function rr_chown_chmod($path) {
    // best-effort only
    $it = new RecursiveIteratorIterator(new RecursiveDirectoryIterator($path));
    foreach ($it as $f) {
        @chmod($f->getPathname(), is_dir($f->getPathname()) ? 0755 : 0644);
    }
}
rr_chown_chmod($currentDash);
logline("Applied chmod 755 to dirs and 644 to files inside Dashboards (best-effort).");

// 6) Create zip of the whole site
if (file_exists($zipOut)) { @unlink($zipOut); }
$zip = new ZipArchive();
if ($zip->open($zipOut, ZipArchive::CREATE) !== true) {
    logline("ERROR: Could not create zip at $zipOut");
    echo "</pre>";
    exit;
}
$base = realpath($root);
$filesToZip = new RecursiveIteratorIterator(
    new RecursiveDirectoryIterator($base),
    RecursiveIteratorIterator::LEAVES_ONLY
);
foreach ($filesToZip as $name => $file) {
    if (!$file->isFile()) continue;
    $filePath = $file->getRealPath();
    $relativePath = substr($filePath, strlen($base) + 1);
    // Avoid zipping some system files if any
    if (strpos($relativePath, 'crm_final_fixed_package.zip') !== false) continue;
    $zip->addFile($filePath, basename($base) . '/' . $relativePath);
}
$zip->close();
$size = filesize($zipOut);
logline("Created final zip: $zipOut (size: " . round($size/1024/1024,2) . " MB)");

// 7) Summary & next steps
logline("DONE. Please test your site now:");
logline(" - Login: /leadscrm/pages/login.php");
logline(" - Admin Dashboard: /leadscrm/Dashboards/admin_dashboard.php");
logline(" - Backup folder (kept): Dashboards_before_restore_$timestamp (if existed)");
logline(" - Log file: $logfile");
logline(" - Final package available at: $zipOut");

// 8) Stop - do not perform more changes
echo "\nFINISHED. DELETE this file for security.\n";
echo "</pre>";
?>
