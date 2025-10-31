<?php
// debug_scan.php - automatic error detector
error_reporting(E_ALL);
ini_set('display_errors', 1);

echo "<h2>Server Diagnostic</h2>";

// PHP environment
echo "<h3>PHP Info</h3>";
echo "Version: " . phpversion() . "<br>";

// Config file check
$cfg = __DIR__ . "/config/db.php";
if (file_exists($cfg)) {
    echo "<p><b>Found db.php:</b> $cfg</p>";
    include $cfg;
} else {
    echo "<p style='color:red'>db.php missing at $cfg</p>";
}

// Connection test
if (isset($conn)) {
    if ($conn->connect_error) {
        echo "<p style='color:red'>DB connection failed: " . $conn->connect_error . "</p>";
    } else {
        echo "<p style='color:green'>DB connection successful.</p>";
    }
} else {
    echo "<p style='color:red'>\$conn not defined in db.php</p>";
}

// Scan Dashboards folder for broken files
$dashDir = __DIR__ . "/Dashboards";
echo "<h3>Dashboard Directory Scan</h3>";
if (is_dir($dashDir)) {
    $files = glob($dashDir . "/*.php");
    if ($files) {
        foreach ($files as $f) {
            echo "<li>$f - size: " . filesize($f) . " bytes</li>";
        }
    } else {
        echo "<p>No dashboard PHP files found!</p>";
    }
} else {
    echo "<p style='color:red'>Dashboards directory not found.</p>";
}

// Try including admin_dashboard.php
echo "<h3>Include Test</h3>";
$file = $dashDir . "/admin_dashboard.php";
if (file_exists($file)) {
    echo "<p>Testing include of admin_dashboard.php ...</p>";
    include $file;
} else {
    echo "<p style='color:red'>admin_dashboard.php missing.</p>";
}
?>
