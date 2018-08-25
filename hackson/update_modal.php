<?php

require_once('./connectDB.php');
require_once('./backend_modal.php');
$DataBase = new DBClass();
$DataBase->select_modal();

//print_r($DataBase->select_modal_result);

$DataBase->update_modal($DataBase->select_modal_result);
$DataBase->disconnect();

?>