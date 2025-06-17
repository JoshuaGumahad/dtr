<?php
// FILEPATH: /d:/xampp/htdocs/flutter/api/connection-pdo.php
    $host = "localhost";
    $dbname = "dtrdb";
    $username = "root";
    $password = "";

    try {
        $conn = new PDO("mysql:host=$host;dbname=$dbname", $username, $password);
        $conn->setAttribute(PDO::ATTR_ERRMODE, PDO::ERRMODE_EXCEPTION);
        // echo "Connected successfully";
    } catch (PDOException $e) {
        echo "Connection failed: " . $e->getMessage();
    }
    
?>
