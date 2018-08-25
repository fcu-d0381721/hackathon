<?php

require_once('./connectDB.php');
$DataBase = new DBClass();
$DataBase->select_modal();

//$DataBase->update_modal($DataBase->select_modal_result);
$DataBase->disconnect();

?>