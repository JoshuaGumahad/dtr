<?php
header('Content-Type: application/json');
header("Access-Control-Allow-Origin: *");

include 'connection-pdo.php';

$sql = "SELECT
            tbl_employeelogs.logs_id,
            tbl_employeelogs.log_type,
            tbl_employeelogs.log_time,
            tbl_employee.employee_id,
            tbl_employee.employee_fullname
        FROM
            tbl_employeelogs
        INNER JOIN
            tbl_employee ON tbl_employeelogs.employee_id = tbl_employee.employee_id
        ORDER BY
            tbl_employeelogs.log_time DESC";

$stmt = $conn->prepare($sql);
$stmt->execute();
$returnValue = $stmt->fetchAll(PDO::FETCH_ASSOC);

echo json_encode($returnValue);
?>