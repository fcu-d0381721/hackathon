<!DOCTYPE html>
<html lang="en">

<head>
	<title>警急通報面板</title>
	<meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1">
    
    
	<link rel="icon" type="image/png" href="./images/icons/siren.png" />
	<link rel="stylesheet" type="text/css" href="css/util.css">
	<link rel="stylesheet" type="text/css" href="css/main.css">
    <link rel="stylesheet" href="css/style.css">
	<script src="https://ajax.googleapis.com/ajax/libs/jquery/3.3.1/jquery.min.js"></script>
	<script src="https://maxcdn.bootstrapcdn.com/bootstrap/4.1.0/js/bootstrap.min.js"></script>
    <script src="https://cdnjs.cloudflare.com/ajax/libs/popper.js/1.14.0/umd/popper.min.js"></script>
	<link rel="stylesheet" href="https://maxcdn.bootstrapcdn.com/bootstrap/4.1.0/css/bootstrap.min.css">
    <link rel="stylesheet" href="css/apple.css">
    <script type="text/javascript" language="javascript" src="./map.js" charset="utf-8"></script>
    
	<script language="JavaScript">
		function addZero(i) {
			if (i < 10) {
				i = "0" + i;
			}
			return i;
		}
    function show(){ 
        var date = new Date(); //日期对象 
        var now = ""; 
        now = date.getFullYear()+"/"; //读英文就行了 
        now = now + (date.getMonth()+1)+"/"; //取月的时候取的是当前月-1如果想取当前月+1就可以了 
        now = now + date.getDate()+" "; 
        now = now + addZero(date.getHours())+":"; 
        now = now + addZero(date.getMinutes())+":"; 
        now = now + addZero(date.getSeconds()); 
        document.getElementById("nowDiv").innerHTML = now; //div的html是now这个字符串 
        setTimeout("show()",1000); //设置过1000毫秒就是1秒，调用show方法 
        return now;
    }
	</script>



</head>
	
<body onLoad="show()">

	
<nav class="navbar navbar-expand-lg navbar-dark bg-dark">
  <a class="navbar-brand" href="#">警急通報面板</a>
  <button class="navbar-toggler" type="button" data-toggle="collapse" data-target="#navbarSupportedContent" aria-controls="navbarSupportedContent" aria-expanded="false" aria-label="Toggle navigation">
    <span class="navbar-toggler-icon"></span>
  </button>

  <div class="collapse navbar-collapse" id="navbarSupportedContent">
    <ul class="navbar-nav mr-auto">
      <li class="nav-item active">
        <a class="nav-link" href="./index.php">主頁<span class="sr-only">(current)</span></a>
      </li>
      <li class="nav-item dropdown">
        <a class="nav-link dropdown-toggle" href="#" id="navbarDropdown" role="button" data-toggle="dropdown" aria-haspopup="true" aria-expanded="false">
          相關連結
        </a>
        <div class="dropdown-menu" aria-labelledby="navbarDropdown">
          <a class="dropdown-item" href="#">緊急通報</a>
          <a class="dropdown-item" href="#">地圖查詢</a>
          <!-- <div class="dropdown-divider"></div>
          <a class="dropdown-item" href="#">Something else here</a>
        </div> -->
      </li>
    </ul>
	<form class="form-inline my-2 my-lg-0">
      <input class="form-control mr-sm-2" type="search" placeholder="案號" aria-label="Search">
      <input type="button" class="btn btn-danger navbar-btn" name="test" id="滿載通報" value="案號查詢">
	</form>
	<li class="nav-item">
      <a><div id="nowDiv"></div></a>
	</li>
  </div>
</nav>
<div class="container">
    <div class="card-deck" style="margin-top: 100px;">
        <div class = "card border-success">
            <div id="map"></div>
        </div>
        <div class="card border-primary">
            <form action="post.php" method="post">
                <div class="form-group row">
                    <label class="sr-only" for="">使用者名稱</label>
                    <div class="input-group mb-2">
                        <div class="input-group-prepend">
                            <div class="input-group-text">使用者名稱</div>
                        </div>
                        <input type="text" id="user" name="user" class="form-control"  placeholder="">
                    </div>
                </div>
                <div class="form-group row">
                    <label class="sr-only" for="">地址</label>
                    <div class="input-group mb-2">
                        <div class="input-group-prepend">
                            <div class="input-group-text">地址</div>
                        </div>
                        <input type="text" id="address" name="address" class="form-control"   placeholder="點擊地圖">
                    </div>
                </div>
                <div class="form-group row">
                    <label class="sr-only" for="">座標地點</label>
                    <div class="input-group mb-2">
                        <div class="input-group-prepend">
                            <div class="input-group-text">座標地點</div>
                        </div>
                        <input type="text" id="lat" name="lat" class="form-control"   placeholder="點擊地圖">
                        <input type="text" id="lng" name="lng" class="form-control"   placeholder="點擊地圖">
                    </div>
                </div>
                <div class="form-group row">
                    <label class="sr-only" for="">事件描述</label>
                    <div class="input-group mb-2 ">
                        <div class="input-group-prepend">
                            <div class="input-group-text">事件描述</div>
                        </div>
                        <input type="text" id="event" name="event" class="form-control"   placeholder="">	
                    </div>
                </div>
                <div class="form-group row">
                    <label class="sr-only" for="">通報單位</label>
                    <div class="input-group mb-2 ">
                        <div class="input-group-prepend">
                            <div class="input-group-text">通報單位</div>
                        </div>
                        <select  class="form-control" id="situation_lv1" name="type" >
                            <option value="">請選擇</option>
                            <option value="0">警察局</option>
                            <option value="1">消防局</option>
                            <option value="2">醫院</option>
                        </select>	
                    </div>
                </div>
                <button type="submit" class="btn btn-primary butt">Submit</button>
            </form>
        </div>
    </div>
</div>


</body>
<script src="https://maps.googleapis.com/maps/api/js?key=AIzaSyA_iuKOAiNi_6mLHiMDrtiacUrzT36gcbY&callback=initMap"
    async defer></script>
    <!-- <script type="text/javascript" src="http://maps.googleapis.com/maps/api/js?sensor=false"> -->


</html>