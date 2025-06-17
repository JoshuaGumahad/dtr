<?php 
    header('Content-Type: application/json');
    header("Access-Control-Allow-Origin: *");

    include 'connection-pdo.php';

    date_default_timezone_set('Asia/Manila');
    $employeeId = $_POST['employee_id'];
    $logType = $_POST['log_type'];

    $currentDateTime = date("Y-m-d h:i:s A");

    $sql = "INSERT INTO tbl_employeelogs (employee_id, log_type, log_time) VALUES (:employee_id, :log_type, :log_time)";
    
    $stmt = $conn->prepare($sql);
    $stmt->bindParam(':employee_id', $employeeId, PDO::PARAM_INT);
    $stmt->bindParam(':log_type', $logType, PDO::PARAM_STR);
    $stmt->bindParam(':log_time', $currentDateTime, PDO::PARAM_STR);

    $stmt->execute();
    $returnValue = $stmt->rowCount() > 0 ? 1 : 0;

    echo json_encode($returnValue);
?>