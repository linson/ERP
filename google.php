<!DOCTYPE html>
<html>
<head>
<meta name="viewport" content="initial-scale=1.0, user-scalable=no" />
<meta http-equiv="content-type" content="text/html; charset=UTF-8"/>
<title>Google Maps JavaScript API v3 Example: Info Window Simple</title>
<link href="http://code.google.com/apis/maps/documentation/javascript/examples/default.css" rel="stylesheet" type="text/css" />
<script type="text/javascript" src="http://jqueryui.com/jquery-1.5.1.js"></script>
<script type="text/javascript" src="http://maps.googleapis.com/maps/api/js?sensor=false"></script>

<script type="text/javascript">
  function initialize() {
    var myLatlng = new google.maps.LatLng(-25.363882,131.044922);
    var myOptions = {
      zoom: 9,
      center: myLatlng,
      mapTypeId: google.maps.MapTypeId.ROADMAP
    }
    var map = new google.maps.Map(document.getElementById("map_canvas"), myOptions);

    // get contentString from Ajax
    var infowindow = new google.maps.InfoWindow();
    var marker = new google.maps.Marker({
        position: myLatlng,
        map: map,
        title: 'test'
    });

    google.maps.event.addListener(marker,'click',function() {
      load_infowindow(map,marker);
    });

    google.maps.event.addListener(map,'click',function(e){
      placeMarker(e.latLng);
    });

    var clickContent = "<a id='clickInfo'>click</a>";
    function placeMarker(loc){
      var clickMarker = new google.maps.Marker({
        position:loc,
        map:map
      });
      map.panTo(loc);
      infowindow.setContent(clickContent);
      //google.maps.event.addListener(infowindow,'closeclick',closeMarker);
      /*
      var clickInfo = document.getElementById('clickInfo');
debugger;
      clickInfo.onClick = function(){
        alert('ccc');
      };
      */
      infowindow.open(map,clickMarker);
    }

    function closeMarker(){
      alert('closeclick fired');
    }

    function load_infowindow(map,marker){
//console.log('load_infowindow');
      $.ajax({
        url:'google_ajax.php',
        success:function(data){
          infowindow.setContent(data);
          infowindow.open(map,marker);
        }
      });
    }
  }
</script>
</head>
<body onload="initialize()">
  <div id="map_canvas"></div>
</body>
</html>
