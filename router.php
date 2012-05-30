<?php

//var_dump( $_SERVER );
$sPath = $_SERVER['DOCUMENT_ROOT'].$_SERVER['REQUEST_URI'];
$sHttp  = 'http://'.$_SERVER['HTTP_HOST'].$_SERVER['REQUEST_URI'];

if( file_exists( $sPath ) && is_dir( $sPath ) && !file_exists( $sPath . 'index.php' ) ) {
	echo '<h1>Dir list</h1>';
	echo '<h2>'.$sPath.'</h2>';
	echo '<h2>'.$sHttp.'</h2>';
	echo '<ul>';
	foreach( scandir( $sPath ) As $sEntry ) {
		echo ' <li><a href="'.$sHttp.$sEntry.'/">'.$sEntry.'</a></li>';
	}
	echo '</ul>';
}
else {
	return false;
}