<?php
// Check if form is submitted
if ($_SERVER["REQUEST_METHOD"] == "POST") {
    // Collect form data
    $name = $_POST['name'];
    $age = $_POST['age'];
    $level = $_POST['level'];
    $device = $_POST['device'];
    $uid = $_POST['uid'];

    // Prepare data to be written to file
    $data = "Name: $name\nAge: $age\nLevel: $level\nDevice: $device\nUID: $uid\n\n";

    // Append data to a file named "data.txt"
    $file = fopen("data.txt", "a");
    fwrite($file, $data);
    fclose($file);

    // Redirect back to the form page after submission
    header("Location: index.html");
    exit();
}
?>
