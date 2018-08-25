var map;
function initMap() {
  map = new google.maps.Map(document.getElementById('map'), {
    center: {lat: 23.743747, lng: 121.007050},
    zoom: 7
  });

  

  var geocoder = new google.maps.Geocoder();
  google.maps.event.addListener(map, 'click', function(event) {
    geocoder.geocode({
      'latLng': event.latLng
    }, function(results, status) {
      if (status == google.maps.GeocoderStatus.OK) {
        if (results[0]) {
            document.getElementById("address").value = results[0].formatted_address;
            document.getElementById("lat").value = event.latLng.lat();
            document.getElementById("lng").value = event.latLng.lng();
        }
        else{
            document.getElementById("address").value = "No results";
        }
      }
    });
  });
 
}

