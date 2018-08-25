<?php

    require_once('./backend_modal.php');

    $result=[];

    if($DataBase->temp_select_modal_result){
        
        foreach($DataBase->temp_select_modal_result as $select_index => $select_result){
        if($select_result['selected'] == 0){
            $result[]=$select_result['ID'];  
        }
        }    
        require_once('./update_modal.php'); //將selected設定為1
    }
    echo json_encode($result);

?>