<?php
/**
 * CRM Rebuild Installer v1.0
 * Recreates Dashboards, fixes login redirects, keeps DB config safe.
 */
ini_set('display_errors', 1);
error_reporting(E_ALL);
$root = __DIR__ . '/leadscrm';
$dashDir = $root . '/Dashboards';
$loginFile = $root . '/pages/login.php';
$configDB = $root . '/config/db.php';

if (!is_dir($root)) {
    die("❌ leadscrm folder not found at: $root");
}
@mkdir($dashDir, 0755, true);
echo "<h3>CRM Rebuild Installer</h3><pre>";

/* Backup any old dashboards */
if (is_dir($dashDir) && count(glob("$dashDir/*.php")) > 0) {
    $backup = $dashDir . '_backup_' . date('Ymd_His');
    rename($dashDir, $backup);
    mkdir($dashDir);
    echo "🔹 Old Dashboards backed up to: $backup\n";
}

/* Common dashboard template */
$template = <<<'PHP'
<?php
session_start();
require_once __DIR__ . '/../config/db.php';
ini_set('display_errors',1); error_reporting(E_ALL);
if (empty($_SESSION['user_id'])) { header("Location: /leadscrm/pages/login.php"); exit; }
$role = strtolower($_SESSION['role'] ?? '');
if (stripos($role, '{role_keyword}') === false && stripos($role, 'admin') === false) {
    echo "<h3>Access denied for role: $role</h3>"; exit;
}
$username = $_SESSION['username'] ?? 'User';
function getCount($conn,$t){$r=@$conn->query("SELECT COUNT(*) c FROM `$t`");return $r&&($x=$r->fetch_assoc())?(int)$x['c']:0;}
$leads=getCount($conn,'leads');$users=getCount($conn,'users');$act=getCount($conn,'activity_log');
?>
<!doctype html><html><head><meta charset="utf-8"><title>{Role} Dashboard</title>
<link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet"></head>
<body class="bg-light"><nav class="navbar navbar-dark bg-primary p-3">
<span class="navbar-brand">CRM - {Role}</span>
<div class="text-white">Logged in: <b><?php echo htmlspecialchars($username); ?></b>
<a href="/leadscrm/pages/logout.php" class="btn btn-sm btn-light ms-3">Logout</a></div></nav>
<div class="container my-4"><h3>{Role} Dashboard</h3>
<div class="row mb-4">
<div class="col"><div class="card p-3"><b>Total Leads:</b> <?php echo $leads;?></div></div>
<div class="col"><div class="card p-3"><b>Total Users:</b> <?php echo $users;?></div></div>
<div class="col"><div class="card p-3"><b>Activity Logs:</b> <?php echo $act;?></div></div></div>
<p>Navigation:</p>
<a href="/leadscrm/Dashboards/admin_dashboard.php" class="btn btn-outline-primary">Admin</a>
<a href="/leadscrm/Dashboards/billing_dashboard.php" class="btn btn-outline-secondary">Billing</a>
<a href="/leadscrm/Dashboards/sales_dashboard.php" class="btn btn-outline-success">Sales</a>
<a href="/leadscrm/Dashboards/qc_dashboard.php" class="btn btn-outline-warning">QC</a>
<a href="/leadscrm/Dashboards/owner_dashboard.php" class="btn btn-outline-info">Owner</a>
</div></body></html>
PHP;

/* Create dashboards */
$roles = [
 ['admin_dashboard.php','admin','Admin'],
 ['billing_dashboard.php','billing','Billing'],
 ['sales_dashboard.php','sales','Sales'],
 ['qc_dashboard.php','qc','QC'],
 ['owner_dashboard.php','owner','Owner'],
];
foreach($roles as $r){
  [$file,$kw,$role] = $r;
  $content = str_replace(['{role_keyword}','{Role}'],[$kw,$role],$template);
  file_put_contents("$dashDir/$file",$content);
  echo "✅ Created $file\n";
}

/* Patch login redirect logic */
if (file_exists($loginFile)) {
  $login = file_get_contents($loginFile);
  if (strpos($login, 'role_redirect') === false) {
    $patch = <<<'PATCH'
if (!empty($_SESSION['role'])) {
  $r = strtolower($_SESSION['role']);
  if (strpos($r,'admin')!==false) header("Location: /leadscrm/Dashboards/admin_dashboard.php");
  elseif (strpos($r,'billing')!==false) header("Location: /leadscrm/Dashboards/billing_dashboard.php");
  elseif (strpos($r,'sales')!==false) header("Location: /leadscrm/Dashboards/sales_dashboard.php");
  elseif (strpos($r,'qc')!==false) header("Location: /leadscrm/Dashboards/qc_dashboard.php");
  elseif (strpos($r,'owner')!==false) header("Location: /leadscrm/Dashboards/owner_dashboard.php");
  exit;
}
PATCH;
    $login = str_replace('session_start();', "session_start();\n// role_redirect\n$patch", $login);
    file_put_contents($loginFile, $login);
    echo "✅ Patched login.php for role-based redirect.\n";
  } else {
    echo "ℹ️ login.php already patched.\n";
  }
} else {
  echo "⚠️ login.php not found.\n";
}

echo "\n🎉 Rebuild complete! Test URLs:\n";
foreach($roles as $r){echo " - /leadscrm/Dashboards/{$r[0]}\n";}
echo "Then DELETE this file for security.\n";
?>
