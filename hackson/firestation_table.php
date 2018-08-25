<?php


require_once('./connectDB.php');
$DataBase = new DBClass();

if(@$arr_id = $_POST['unclosed_id']){
    
    $DataBase->update_unclosed($arr_id);
}

if(@$arr_id = $_POST['closed_id']){
    
    $DataBase->update_closed($arr_id);
}

$DataBase->select();

//print_r($DataBase->select_result);
echo "<div class='inform5'><div class='inform1'>通報中</div></div>";
echo "<form action='./firestation.php' method='post'>";
    echo "<table class = 'table table-striped'>";
        echo "<thead>";
            echo" <tr>";
                echo" <th>案號</th>";
                echo" <th>通報者</th>";
                echo" <th>事件描述</th>";
                echo" <th>地址</th>";
                echo" <th>通知時間</th>";
            echo "</tr>";
        echo "</thead>";
        echo "<tbody>";
                foreach($DataBase->select_result as $select_index => $select_result){
                    $column = 0;
                    if($select_result['status'] == 0 && $select_result['type'] == 1){
                        echo "<tr>";
                        foreach($select_result as $select_result_value){
                            $column++;
                            if($column != 2 && $column != 6 && $column != 7){
                                echo "<td class='column$column'>$select_result_value</td>";
                            }
                        
                        }
                        echo "<td><input type='checkbox' class='button icon' name='unclosed_id[]' value='$select_result[ID]'></td>";
                        echo "</tr>";
                    }
                }
        echo" </tbody>";
    echo "</table>";

 
    echo "<input type='submit' class='button imgClass' name='unclosed' value='' style='background-image:url(./images/icons/down.png);background-color:white'></input>";
    echo "<div class='inform6'><div class='inform1'>已受理</div></div>";
  

echo "</form>";
$arr_id = array();

echo "<form action='./firestation.php' method='post'>";
    echo "<table class = 'table table-striped'>";
        echo "<thead>";
            echo" <tr>";
            echo" <th>案號</th>";
            echo" <th>通報者</th>";
            echo" <th>事件描述</th>";
            echo" <th>地址</th>";
            echo" <th>通知時間</th>";
            echo "</tr>";
        echo "</thead>";
        echo "<tbody>";
            foreach($DataBase->select_result as $select_index => $select_result){
                $column = 0;
                if($select_result['status'] == 1 && $select_result['type'] == 1){
                    echo "<tr>";
                    foreach($select_result as $select_result_value){
                        $column++;
                        if($column != 2 && $column != 6 && $column != 7){
                            echo "<td class='column$column'>$select_result_value</td>";
                        }
                    
                    }
                    echo "<td><input type='checkbox' class='button icon' name='unclosed_id[]' value='$select_result[ID]'></td>";
                    echo "</tr>";
                }
            }
        echo" </tbody>";
    echo "</table>";
 
    echo "<input type='submit' class='button imgClass' name='closed' value='' style='background-image:url(./images/icons/up.png);background-color:white'></input>";
  
echo "</form>";

$DataBase->disconnect();


?>