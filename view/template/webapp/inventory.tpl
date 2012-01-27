<!doctype html>
<html>
<head>
    <meta charset="UTF-8" />
    <title>UBP IControl &beta;</title>
    <style type="text/css" media="screen">@import "view/template/webapp/jqtouch/jqtouch.css";</style>
    <style type="text/css" media="screen">@import "view/template/webapp/themes/jqt/theme.css";</style>
    <script src="view/template/webapp/jqtouch/jquery-1.4.2.js" type="text/javascript" charset="utf-8"></script>
    <script src="view/template/webapp//jqtouch/jqtouch.js" type="application/x-javascript" charset="utf-8"></script>
    <script type="text/javascript" charset="utf-8">
        var jQT = new $.jQTouch({
            icon: 'view/template/webapp/images/jqtouch.png',
            icon4: 'view/template/webapp/images/jqtouch4.png',
            addGlossToIcon: false,
            startupScreen: 'view/template/webapp/images/ubp_startup.jpg',
            statusBar: 'black',
            preloadImages: [
                'view/template/webapp/themes/jqt/img/activeButton.png',
                'view/template/webapp/themes/jqt/img/back_button.png',
                'view/template/webapp/themes/jqt/img/back_button_clicked.png',
                'view/template/webapp/themes/jqt/img/blueButton.png',
                'view/template/webapp/themes/jqt/img/button.png',
                'view/template/webapp/themes/jqt/img/button_clicked.png',
                'view/template/webapp/themes/jqt/img/grayButton.png',
                'view/template/webapp/themes/jqt/img/greenButton.png',
                'view/template/webapp/themes/jqt/img/redButton.png',
                'view/template/webapp/themes/jqt/img/whiteButton.png',
                'view/template/webapp/themes/jqt/img/loading.gif'
                ]
        });
        // Some sample Javascript functions:
        $(function(){
            // Show a swipe event on swipe test
            $('#swipeme').swipe(function(evt, data) {
                $(this).html('You swiped <strong>' + data.direction + '/' + data.deltaX +':' + data.deltaY + '</strong>!');
                $(this).parent().after('<li>swiped!</li>')

            });
            $('#tapme').tap(function(){
                $(this).parent().after('<li>tapped!</li>')
            })
            $('a[target="_blank"]').click(function() {
                if (confirm('This link opens in a new window.')) {
                    return true;
                } else {
                    return false;
                }
            });
            // Page animation callback events
            $('#pageevents').
                bind('pageAnimationStart', function(e, info){ 
                    $(this).find('.info').append('Started animating ' + info.direction + '&hellip; ');
                }).
                bind('pageAnimationEnd', function(e, info){
                    $(this).find('.info').append(' finished animating ' + info.direction + '.<br /><br />');
                });
            // Page animations end with AJAX callback event, example 1 (load remote HTML only first time)
            $('#callback').bind('pageAnimationEnd', function(e, info){
                // Make sure the data hasn't already been loaded (we'll set 'loaded' to true a couple lines further down)
                if (!$(this).data('loaded')) {
                    // Append a placeholder in case the remote HTML takes its sweet time making it back
                    // Then, overwrite the "Loading" placeholder text with the remote HTML
                    $(this).append($('<div>Loading</div>').load('ajax.html .info', function() {        
                        // Set the 'loaded' var to true so we know not to reload
                        // the HTML next time the #callback div animation ends
                        $(this).parent().data('loaded', true);  
                    }));
                }
            });
            // Orientation callback event
            $('#jqt').bind('turn', function(e, data){
                $('#orient').html('Orientation: ' + data.orientation);
            });
            $('#play_movie').bind('tap', function(){
                $('#movie').get(0).play();
                $(this).removeClass('active');
            });
            
            $('#video').bind('pageAnimationStart', function(e, info){
                $('#movie').css('display', 'none');
            }).bind('pageAnimationEnd', function(e, info){
                if (info.direction == 'in')
                {
                    $('#movie').css('display', 'block');
                }
            })
        });
    </script>
    <style type="text/css" media="screen">
        #jqt.fullscreen #home .info {
            display: none;
        }
        div#jqt #about {
            padding: 100px 10px 40px;
            text-shadow: rgba(255, 255, 255, 0.3) 0px -1px 0;
            font-size: 13px;
            text-align: center;
            background: #161618;
        }
        div#jqt #about p {
            margin-bottom: 8px;
        }
        div#jqt #about a {
            color: #fff;
            font-weight: bold;
            text-decoration: none;
        }
    </style>
</head>
<body>
<div id="jqt">
  <div id="about" class="selectable">
          <h1>UBP Icontrol</h1>
          <p><strong>UniversalBeauty IControl</strong><br />Version 1.0<br />
              <a href="http://www.universalbeauty.com">By IT Team</a></p>
          <p><em>Manage powerful UBP Control</em></p>
          <p>
              <a target="_blank" href="#">UBP on Twitter</a>
          </p>
          <p><br /><br /><a href="#" class="grayButton goback">Close</a></p>
  </div>
  <div id="home" class="current">
      <div class="toolbar">
          <h1>UBP IControl</h1>
          <a class="button slideup" id="infoButton" href="#about">About</a>
      </div>
      <ul class="rounded">
          <li class="arrow"><a href="#inventory">Inventory</a></li>
          <li class="arrow"><a href="#oem">OEM</a></li>
      </ul>
      <ul class="individual">
          <li><a href="#">Email</a></li>
          <li><a target="_blank" href="http://www.universalbeauty.com">Homepage</a></li>
      </ul>
  </div>

<?php 
include('view/template/webapp/include/inventory.tpl');
include('view/template/webapp/include/oem.tpl');
?>

</div>






</body>
</html>