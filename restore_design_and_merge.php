<?php
/**
 * restore_design_and_merge.php
 * - Restores original design files (Dashboards + assets) from either:
 *    - uploaded zip at /home/emglavox/upload_orig_design.zip  (OPTION B)
 *    - or the latest Dashboards_backup_* folder on server   (OPTION A)
 * - Applies PDO compatibility fixes to php files in Dashboards
 * - Writes a log to leadscrm/restore_design_log.txt
 *
 * USAGE:
 * 1) If you have a ZIP of the old design, upload it to /home/emglavox/upload_orig_design.zip via cPanel/FTP.
 * 2) Place this PHP file in site root and open in browser.
 * 3) Confirm the output. Then DELETE this file.
 */
ini_set('display_errors',1);
error_reporting(E_ALL);

$root = __DIR__;
$leads = $root . '/leadscrm';
$log = $leads . '/restore_design_log.txt';
function logit($s){ global $log; $t = date('Y-m-d H:i:s') . " - " . $s . PHP_EOL; echo nl2br(htmlspecialchars($t)); file_put_contents($log,$t,FILE_APPEND); }

echo "<h3>Restore & Merge Original Design</h3><pre>";
if (!is_dir($leads)) { die("ERROR: leadscrm not found at $leads\n"); }
logit("Found leadscrm at $leads");

// 1) Determine source: uploaded zip or server backup
$uploaded_zip = $root . '/upload_orig_design.zip';
$backup_folder = null;
if (file_exists($uploaded_zip)) {
    logit("Found uploaded zip: $uploaded_zip (using it as source)");
    // extract zip to temp
    $tmp = sys_get_temp_dir() . '/orig_design_' . time();
    @mkdir($tmp, 0755, true);
    $zip = new ZipArchive();
    if ($zip->open($uploaded_zip) === true) {
        $zip->extractTo($tmp);
        $zip->close();
        logit("Extracted uploaded zip to $tmp");
        // find leadscrm/Dashboards inside extracted
        $found = glob($tmp . '/*/leadscrm/Dashboards', GLOB_ONLYDIR);
        if (!$found) $found = glob($tmp . '/leadscrm/Dashboards', GLOB_ONLYDIR);
        if ($found) $backup_folder = $found[0];
        else {
            // fallback: search for Dashboards dir anywhere in tmp
            $all = new RecursiveIteratorIterator(new RecursiveDirectoryIterator($tmp));
            foreach ($all as $f) {
                if ($f->isDir() && basename($f) === 'Dashboards') { $backup_folder = $f->getPathname(); break; }
            }
        }
        if (!$backup_folder) { logit("ERROR: Could not find leadscrm/Dashboards inside uploaded ZIP."); echo "</pre>"; exit; }
    } else { logit("ERROR: Failed to open uploaded zip."); echo "</pre>"; exit; }
} else {
    // find latest Dashboards_backup_*
    $backs = glob($leads . '/Dashboards_backup_*', GLOB_ONLYDIR);
    if (!$backs) {
        logit("ERROR: No uploaded zip and no Dashboards_backup_* found. Nothing to restore."); echo "</pre>"; exit;
    }
    usort($backs, function($a,$b){ return filemtime($b) - filemtime($a); });
    $backup_folder = $backs[0];
    logit("Using server backup folder: $backup_folder");
}

// 2) Backup current Dashboards (if exists)
$current = $leads . '/Dashboards';
$ts = date('Ymd_His');
if (is_dir($current)) {
    $before = $leads . '/Dashboards_before_restore_' . $ts;
    if (!rename($current, $before)) { logit("ERROR: Could not move current Dashboards to $before"); echo "</pre>"; exit; }
    logit("Moved current Dashboards to: $before");
}

// 3) Copy backup -> leadscrm/Dashboards
function rr_copy($src,$dst){
    if (!is_dir($dst)) mkdir($dst,0755,true);
    $it = new RecursiveIteratorIterator(new RecursiveDirectoryIterator($src, RecursiveDirectoryIterator::SKIP_DOTS), RecursiveIteratorIterator::SELF_FIRST);
    foreach($it as $item){
        $sub = substr($item->getPathname(), strlen($src)+1);
        $target = rtrim($dst,'/').'/'.$sub;
        if ($item->isDir()){
            @mkdir($target,0755,true);
        } else {
            copy($item->getPathname(), $target);
            @chmod($target, 0644);
        }
    }
}
rr_copy($backup_folder, $current);
logit("Copied files from $backup_folder to $current");

// 4) Apply PDO fixes to PHP files inside Dashboards only
$changed = 0;
$files = glob($current . '/*.php');
foreach ($files as $f) {
    $orig = file_get_contents($f);
    $mod = $orig;
    // replace fetch_assoc
    $mod = str_replace('->fetch_assoc()', '->fetch(PDO::FETCH_ASSOC)', $mod);
    $mod = str_replace('fetch_assoc()', 'fetch(PDO::FETCH_ASSOC)', $mod); // safety
    // replace mysqli-style getCount functions
    if (strpos($mod, 'function getCount') !== false) {
        $mod = preg_replace(
            '/function\s+getCount\s*\([^)]*\)\s*\{[^}]*\}/s',
            "function getCount(\$conn, \$table) {\n    try {\n        \$stmt = \$conn->query(\"SELECT COUNT(*) AS cnt FROM `\$table`\");\n        \$row = \$stmt->fetch(PDO::FETCH_ASSOC);\n        return (int)(\$row['cnt'] ?? 0);\n    } catch (Exception \$e) {\n        return 0;\n    }\n}",
            $mod
        );
    }
    if ($mod !== $orig) { file_put_contents($f,$mod); $changed++; logit("Patched PDO in: " . basename($f)); }
}
logit("PDO patching complete, files changed: $changed");

// 5) Apply perms best-effort
function rr_chmod($path){ $it=new RecursiveIteratorIterator(new RecursiveDirectoryIterator($path)); foreach($it as $i){ @chmod($i->getPathname(), $i->isDir()?0755:0644); } }
rr_chmod($current);
logit("Permissions set (best-effort)");

// 6) Final listing & instructions
$listing = array_map('basename', glob($current . '/*'));
logit("Files now in Dashboards: " . implode(', ', $listing));
logit("Test URLs:");
logit(" - /leadscrm/pages/login.php");
logit(" - /leadscrm/Dashboards/admin_dashboard.php");
logit("Log file: $log");
logit("If you uploaded a zip and you no longer need it, delete /home/emglavox/upload_orig_design.zip");

// Done
echo "\nFinished. DELETE this file for security.\n</pre>";
?>
