<?php
require_once 'src/HelloInterface.php';
require_once 'src/Hello.php';

use Silarhi\Hello;

$hello = new Hello();
echo $hello->display();

