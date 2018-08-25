<?php


    require_once('./connectDB.php');

    $arr_postdata = array();

    $type = $_GET["type"];
    $region = $_GET["region"];

    if($type == 0){
        $type = "policeoffice";
    }
    else if($type == 1){
        $type = "firestation";
    }
    else if($type == 2){
        $type = "hospital";
    }

    $arr_postdata = [$type, $region];

    $DataBase = new DBClass();

    $DataBase->search($arr_postdata);

?>