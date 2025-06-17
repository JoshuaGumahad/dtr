<?php 
    header('Content-Type: application/json');
    header("Access-Control-Allow-Origin: *");

    include 'connection-pdo.php';

    $userid = $_POST['userid'];
    $fullname = $_POST['fullname'];
    $age = $_POST['age'];
    $gender = $_POST['gender'];
    $address = $_POST['address'];

    $sql = "INSERT INTO tbl_employee(user_id, employee_fullname, employee_age, employee_gender, employee_address) ";
    $sql .= "VALUES (:userid, :fullname, :age, :gender, :address)";
    $stmt = $conn->prepare($sql);
    $stmt->bindParam(':userid', $userid);
    $stmt->bindParam(':fullname', $fullname);
    $stmt->bindParam(':age', $age);
    $stmt->bindParam(':gender', $gender);
    $stmt->bindParam(':address', $address);
    
    $stmt->execute();
    $returnValue = $stmt->rowCount() > 0 ? 1 : 0;

    echo json_encode($returnValue);
?>