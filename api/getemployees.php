<?php 
    header('Content-Type: application/json');
    header("Access-Control-Allow-Origin: *");

    include 'connection-pdo.php';

    $userid = $_GET['userid'];

    $sql = "SELECT * FROM tbl_employee WHERE user_id = :userid ";
    $sql .= "ORDER BY employee_fullname";
    $stmt = $conn->prepare($sql);
    $stmt->bindParam(':userid', $userid);
    $stmt->execute();
    $returnValue = $stmt->fetchAll(PDO::FETCH_ASSOC);

    echo json_encode($returnValue);
?>


