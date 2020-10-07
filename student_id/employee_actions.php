<?php
    $servername = "localhost";
    $username = "root";
    $password = "";
    $dbname = "test";
    $table = "testdb";

    $action = $_POST['action'];

    // Create connection
    $conn = new mysqli($servername, $username, $password, $dbname);
    // Check connection
    if ($conn->connect_error) {
        die("Connection failed: " . $conn->connect_error);
    }

    if('CREATE_TABLE' == $action){
        $sql = "CREATE TABLE IF NOT EXISTS $table (
            id INT(6) UNSIGNED AUTO_INCREMENT PRIMARY KEY,
            first_name VARCHAR(30) NOT NULL,
            last_name VARCHAR(30) NOT NULL,
			password VARCHAR(30) NOT NULL,
			school VARCHAR(30) NOT NULL,
			district VARCHAR(30) NOT NULL,
            )";
        if ($conn->query($sql) === TRUE) {
            echo "success";
        } else {
            echo "error";
        }
        $conn->close();
        return;
    }

    if('GET_ALL' == $action){
        $dbdata = array();
        $sql = "SELECT id, first_name, last_name , password , school , district FROM $table ORDER BY id DESC";
        $result = $conn->query($sql);
        if ($result->num_rows > 0) {
            while($row = $result->fetch_assoc()) {
                $dbdata[]=$row;
            }
            echo json_encode($dbdata);
        } else {
            echo "error";
        }
        $conn->close();
        return;
    }

    if('ADD_EMP' == $action){
        $first_name = $_POST['first_name'];
        $last_name = $_POST['last_name'];
		$pass_word = $_POST['password'];
		$school = $_POST['school'];
		$district = $_POST['district'];
        $sql = "INSERT INTO $table (first_name, last_name , password,school,district) VALUES('$first_name', '$last_name' , '$pass_word', '$school' , '$district')";
        $result = $conn->query($sql);
        echo 'success';
        return;
    }

    if('UPDATE_EMP' == $action){
        $emp_id = $_POST['id'];
        $first_name = $_POST['first_name'];
        $last_name = $_POST['last_name'];
		$pass_word = $_POST['password'];
		$school = $_POST['school'];
		$district = $_POST['district'];
        $sql = "UPDATE $table SET first_name = '$first_name', last_name = '$last_name' , password = '$pass_word' , school = '$school' , district = '$district' WHERE id = $emp_id";
        if ($conn->query($sql) === TRUE) {
            echo "success";
        } else {
            echo "error";
        }
        $conn->close();
        return;
    }

    if('DELETE_EMP' == $action){
        $emp_id = $_POST['id'];
        $sql = "DELETE FROM $table WHERE id = $emp_id";
        if ($conn->query($sql) === TRUE) {
            echo "success";
        } else {
            echo "error";
        }
        $conn->close();
        return;
    }
    
	if('SEARCH_DATA' == $action){
		$first_name = $_POST['first_name'];
        $last_name = $_POST['last_name'];
		$pass_word = $_POST['password'];
        $sql = "SELECT * FROM $table WHERE first_name = '$first_name' and last_name = '$last_name' and password = '$pass_word'";
        $result = $conn->query($sql);
        if ($result->num_rows > 0) {
            while($row = $result->fetch_assoc()) {
                $dbdata[]=$row;
            }
            echo json_encode($dbdata);
        } else {
            echo "error";
        }
        $conn->close();
        return;
    }
	
	if('GET_DATA' == $action){
		$id = $_POST['id'];
        $sql = "SELECT id,first_name,last_name,school,district FROM $table WHERE id = '$id'";
        $result = $conn->query($sql);
        if ($result->num_rows > 0) {
            while($row = $result->fetch_assoc()) {
                $dbdata[]=$row;
            }
			echo "receiving data";
            echo json_encode($dbdata);
        } else {
            echo "error";
        }
        $conn->close();
        return;
    }
	
?>
