<?php
echo'<nav class="navbar navbar-default navbar-inverse" role="navigation">';
    echo'<div class="container-fluid">';
        echo'<!-- Brand and toggle get grouped for better mobile display -->';
        echo'<div class="navbar-header">';
            echo'<button type="button" class="navbar-toggle collapsed" data-toggle="collapse" data-target="#bs-example-navbar-collapse-1">';
                echo'<span class="sr-only">Toggle navigation</span>';
                echo'<span class="icon-bar"></span>';
                echo'<span class="icon-bar"></span>';
                echo'<span class="icon-bar"></span>';
            echo'</button>';
            echo'<a class="navbar-brand" href="#">醫院端介面</a>';
        echo'</div>';

    // Collect the nav links, forms, and other content for toggling
    echo'<div class="collapse navbar-collapse" id="bs-example-navbar-collapse-1">';
        // echo'<ul class="nav navbar-nav">';
        //     echo'<li class="active"><a href="#">Link</a></li>';
        // echo'</ul>';
        echo'<form class="navbar-form navbar-left" role="search">';
            echo'<div class="form-group">';
                echo'<input type="text" class="form-control" placeholder="Search">';
            echo'</div>';
            echo'<button type="submit" class="btn btn-default">Submit</button>';
        echo'</form>';
        echo'<ul class="nav navbar-nav navbar-right">';
            echo'<li><p class="navbar-text">Already have an account?</p></li>';
            echo'<li class="dropdown">';
                echo'<a href="#" class="dropdown-toggle" data-toggle="dropdown"><b>Login</b> <span class="caret"></span></a>';
                    echo'<ul id="login-dp" class="dropdown-menu">';
                        echo'<li>';
                            echo'<div class="row">';
							    echo'<div class="col-md-12">';
								    echo'Login via';
                                    echo'<div class="social-buttons">';
									    echo'<a href="#" class="btn btn-fb"><i class="fa fa-facebook"></i> Facebook</a>';
									    echo'<a href="#" class="btn btn-tw"><i class="fa fa-twitter"></i> Twitter</a>';
                                    echo'</div>';
                                echo'or';
                                    echo'<form class="form" role="form" method="post" action="login" accept-charset="UTF-8" id="login-nav">';
                                        echo'<div class="form-group">';
                                            echo'<label class="sr-only" for="exampleInputEmail2">Email address</label>';
                                            echo'<input type="email" class="form-control" id="exampleInputEmail2" placeholder="Email address" required>';
                                        echo'</div>';
										echo'<div class="form-group">';
                                            echo'<label class="sr-only" for="exampleInputPassword2">Password</label>';
                                            echo'<input type="password" class="form-control" id="exampleInputPassword2" placeholder="Password" required>';
                                            echo'<div class="help-block text-right"><a href="">Forget the password ?</a></div>';
                                        echo'</div>';
										echo'<div class="form-group">';
                                            echo'<button type="submit" class="btn btn-primary btn-block">Sign in</button>';
                                        echo'</div>';
										echo'<div class="checkbox">';
                                            echo'<label>';
                                            echo'<input type="checkbox"> keep me logged-in';
                                            echo'</label>';
                                        echo'</div>';
                                    echo'</form>';
                                echo'</div>';
                                echo'<div class="bottom text-center">';
								    echo'New here ? <a href="#"><b>Join Us</b></a>';
                                echo'</div>';
                            echo'</div>';
                        echo'</li>';
                    echo'</ul>';
                 echo'</li>';
            echo'</ul>';
        echo'</div>';
    echo'</div>';
echo'</nav>';

// function GetSystemTime(){
//     $datetime = date ("Y-m-d H:i:s" , mktime(date('H')+8, date('i'), date('s'), date('m'), date('d'), date('Y'))) ; 
//     echo $datetime ;
// }
?>