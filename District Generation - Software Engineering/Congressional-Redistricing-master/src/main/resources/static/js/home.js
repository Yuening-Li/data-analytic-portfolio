var map;
function initMap() {
	map = new google.maps.Map(document.getElementById('map'), {
		zoom : 4,
		center : new google.maps.LatLng(40, -96),
		fullscreenControl: true,
		fullscreenControlOptions: {
	        position: google.maps.ControlPosition.TOP_RIGHT
	    },
	    mapTypeControl: false,
	    streetViewControl: false
		
	});
	map.data.loadGeoJson('./json/states.json');
	map.data.setStyle(function(feature) {
		var d = feature.getProperty('density');
		var color = getColor(d);
		return {
			fillColor : color,
			strokeWeight : 1,
			fillOpacity: 0.8
		};
	});

	map.data.addListener('mouseover', function(event) {
		map.data.revertStyle();
		map.data.overrideStyle(event.feature, {
			strokeWeight : 3
		});
		document.getElementById('text').innerHTML =
		'<h6>US Population Density</h6>' +  
		        '<b>' +  event.feature.getProperty('name') + '</b><br />' +  event.feature.getProperty('density') + ' people / mi<sup>2</sup>';
	});

	map.data.addListener('mouseout', function(event) {
		document.getElementById('text').innerHTML = '<h6>US Population Density</h6>' + 'Hover over a state';
		map.data.revertStyle();
	});
	
	// Create a div to hold the control.
	var info = document.createElement('div');
	info.setAttribute("id", "info");
	var controlUI = document.createElement('div');
	  controlUI.style.backgroundColor = '#fff';
	  controlUI.style.border = '2px solid #fff';
	  controlUI.style.borderRadius = '3px';
	  controlUI.style.boxShadow = '0 2px 6px rgba(0,0,0,.3)';
	  controlUI.style.cursor = 'pointer';
	  controlUI.style.marginBottom = '22px';
	  controlUI.style.textAlign = 'left';
	  info.appendChild(controlUI);

	  // Set CSS for the control interior.
	  var controlText = document.createElement('div');
	  controlText.setAttribute("id", "text");
	  controlText.style.color = 'rgb(25,25,25)';
	  controlText.style.fontFamily = 'Roboto,Arial,sans-serif';
	  controlText.style.fontSize = '14px';
	  controlText.style.lineHeight = '20px';
	  controlText.style.paddingLeft = '5px';
	  controlText.style.paddingRight = '5px';
	  controlText.innerHTML = '<h6>US Population Density</h6>' + 'Hover over a state';
	  controlUI.appendChild(controlText);

	map.controls[google.maps.ControlPosition.TOP_LEFT].push(info);
}

function getColor(d) {
	return d > 1000 ? '#800026' : d > 500 ? '#BD0026'
			: d > 200 ? '#E31A1C' : d > 100 ? '#FC4E2A'
					: d > 50 ? '#FD8D3C' : d > 20 ? '#FEB24C'
							: d > 10 ? '#FED976' : '#FFEDA0';
}