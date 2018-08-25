<!DOCTYPE html>
<html lang="en">

<head>
	<title>警局端監控面版</title>
	<meta charset="UTF-8">
	<meta name="viewport" content="width=device-width, initial-scale=1">
	<!--===============================================================================================-->
	<link rel="icon" type="image/png" href="./images/icons/police-car.png" />
	<!--===============================================================================================-->
	<!-- <link rel="stylesheet" type="text/css" href="vendor/bootstrap/css/bootstrap.min.css"> -->
	<!--===============================================================================================-->
	<!-- <link rel="stylesheet" type="text/css" href="fonts/font-awesome-4.7.0/css/font-awesome.min.css"> -->
	<!--===============================================================================================-->
	<!-- <link rel="stylesheet" type="text/css" href="vendor/animate/animate.css"> -->
	<!--===============================================================================================-->
	<!-- <link rel="stylesheet" type="text/css" href="vendor/select2/select2.min.css"> -->
	<!--===============================================================================================-->
	<!-- <link rel="stylesheet" type="text/css" href="vendor/perfect-scrollbar/perfect-scrollbar.css"> -->
	<!--===============================================================================================-->
	<link rel="stylesheet" type="text/css" href="css/util.css">
	<link rel="stylesheet" type="text/css" href="css/main.css">
	<!--===============================================================================================-->
	<link rel="stylesheet" href="css/style.css">
	<!--===============================================================================================-->
	<!-- <link rel="stylesheet" href="css/bootstrap.css"> -->
	<!-- <link rel="stylesheet" href="https://maxcdn.bootstrapcdn.com/bootstrap/4.0.0/css/bootstrap.min.css" integrity="sha384-Gn5384xqQ1aoWXA+058RXPxPg6fy4IWvTNh0E263XmFcJlSAwiGgFAW/dAiS6JXm" crossorigin="anonymous"> -->
	<script src="https://ajax.googleapis.com/ajax/libs/jquery/3.3.1/jquery.min.js"></script>
	<script src="https://maxcdn.bootstrapcdn.com/bootstrap/4.1.0/js/bootstrap.min.js"></script>
  <script src="https://cdnjs.cloudflare.com/ajax/libs/popper.js/1.14.0/umd/popper.min.js"></script>
	<link rel="stylesheet" href="https://maxcdn.bootstrapcdn.com/bootstrap/4.1.0/css/bootstrap.min.css">
  <!-- <script type="text/javascript" language="javascript" src="./modal.js" charset="utf-8"></script>-->


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

  
    $.getScript( "./modal.js", function() {
			loadphp();
			//modal();
		});
		



	</script>


</head>
	
<body onLoad="show()">

	
<nav class="navbar navbar-expand-lg navbar-dark bg-dark">
  <a class="navbar-brand" href="#">警局端監控面版</a>
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
          <a class="dropdown-item" href="./map.php">緊急通報</a>
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


  <div id="police_table" style="margin: 35px;">
    <?php include './police_table.php'; ?>
  </div>

  <div id="modal"></div>
  <div id="update_modal"></div>

	<div class="modal fade" id="alertModal" role="dialog">
		<div class="modal-dialog">
			<div class="modal-content">
				<div class="modal-header">
					<h4 class="modal-title">Warning</h4>
				</div>
        <div class="modal-body" id="alertModalContent">--------------------------</div>
				<div class="modal-footer">
					<button type="button" class="btn btn-default" id="closemodal" data-dismiss="modal">Close</button>
				</div>
			</div>
		</div>
	</div>


  





</body>

</html>