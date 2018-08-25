<?php


    require_once('./connectDB.php');

    // $url = "http://geocoding.sgis.tw/position.php?lat=25.0392215&lng=121.61585049999998";

    $ID = substr(md5(rand()),0,15);

    $type = $_GET["type"];
    $user = $_GET["user"];
    $description = $_GET["description"];
    // $addr = $_GET["addr"];
    $status = $_GET["status"];
    $lat = $_GET["lat"];
    $lng = $_GET["lng"];


    if($lat && $lng){
        $url = "http://geocoding.sgis.tw/position.php?lat=".$lat."&lng=".$lng;
        $content = file_get_contents($url);
        $resultData = json_decode($content, true);
        if($resultData['fulladdr']){
            $addr = $resultData['fulladdr'];
        }
        else{
            exit;
        }
    }

    else{
        exit;
    }

    $arr_postdata = array();

    $arr_postdata = [$ID, $type, $user, $description, $lng, $lat, $status, $addr];

   

    $DataBase = new DBClass();

    $DataBase->post_insert($arr_postdata);




?>