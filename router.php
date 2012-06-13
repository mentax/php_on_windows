<?php

//var_dump( $_SERVER );
$sPath = $_SERVER['DOCUMENT_ROOT'].$_SERVER['REQUEST_URI'];
$sHttp  = 'http://'.$_SERVER['HTTP_HOST'].$_SERVER['REQUEST_URI'];

if( substr( $sPath, -1 ) != '/' ){
	$sPath .= '/';
}
if( substr( $sHttp, -1 ) != '/' ){
	$sHttp .= '/';
}


if( file_exists( $sPath ) && is_dir( $sPath ) 
	&& !file_exists( $sPath . 'index.php' ) ) {

	echo "<html><head><meta charset='utf-8'></head><body>";

	echo '<h2>'.$sPath.'</h2>';
	echo '<h2>'.$sHttp.'</h2>';
	echo '<ul>';
	foreach( scandir( $sPath ) as $sEntry ) {
		if( $sEntry == '.' ){
			continue;
		}
		echo ' <li><a href="'. $sHttp . $sEntry .'">'. $sEntry .'</a></li>';
	}
	echo '</ul>';
 
	echo '<div style="font-size: 11px; margin-top: 50px; border-top: 1px solid">php '. phpversion() .'</div>';
	echo '</body>';
}
else {
	return false;
}