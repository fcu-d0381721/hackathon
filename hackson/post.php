<?php


    require_once('./connectDB.php');
    require_once('./firebase.php');

    date_default_timezone_set('Asia/Taipei');

    $DataBase = new DBClass();
    $firebase = new firebase();

    $event_note = substr(md5(rand()),0,15);
    $address = $_POST["address"];
    $user = $_POST["user"];
    $lat = $_POST["lat"];
    $lng = $_POST["lng"];
    $event = $_POST["event"];
    $type = $_POST["type"];
    $status = 0;

    $datetime= date("Y/m/d H:i:s");

    $arr_postdata = array();

    $arr_postdata = [$event_note, $type, $user, $event, $lng, $lat, $status, $address];

    $DataBase->post_insert($arr_postdata);
    
    $firebase_data = array(
        "description" => $event,
        "id" => $event_note,
        "latitude" => $lat,
        "longitude" => $lng,
        "process" => $status,
        "time" => $datetime,
        "type" => $type,
        "user_id" => $user,
    );
    $json_firebase_data = json_encode($firebase_data);

    $firebase->define_node($event_note);
    $firebase->put($json_firebase_data);
    $firebase->close();

    header("location: ./map.php")

?>