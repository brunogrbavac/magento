<?php
$mysqli = new mysqli('db', 'root', 'root', 'magento', 3306);

if ($mysqli->connect_error) {
    die('Connect Error (' . $mysqli->connect_errno . ') ' . $mysqli->connect_error);
}

$mysqli->query('CREATE TABLE myTable (content VARCHAR(50))');
$mysqli->query("INSERT INTO myTable (content) VALUES ('Hello world.')");

$mysqli->close();