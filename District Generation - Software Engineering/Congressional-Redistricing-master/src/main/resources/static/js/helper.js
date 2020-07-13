var pop;
var comp;
var partisan;
var gap;

function run() {
	var formData = {
		population : $("#popInput").val(),
		compactness : $("#compInput").val(),
		partisian : $("#fairInput").val(),
		gap : $("#gapInput").val(),
		methodFlag : $('#methodFlag').find(":selected").text(),
		id : stateId,
		num: $("#num").val()
	}

	$.ajax({
		type : "POST",
		contentType : "application/json",
		url : "/run",
		async: true,
		data : JSON.stringify(formData),
		success : function(result) {
			console.log(result);
			document.getElementById("runButton").disabled = false;
		}
	});
}

function saveWeights() {
	pop = $("#popInput").val();
	comp = $("#compInput").val();
	partisan = $("#fairInput").val();
	gap = $("#gapInput").val();
	
}

function loadWeights() {
	document.getElementById("popInput").setAttribute("value", pop);
	
	document.getElementById("compInput").setAttribute("value", comp);
	
	document.getElementById("fairInput").setAttribute("value", partisan);
	
	document.getElementById("gapInput").setAttribute("value", gap);
}



function renderSa() {
	setInterval(function() {
		$.ajax({
			type : "GET",
			contentType : "application/json",
			url : "/renderSa",
			async: false,
			success : function(result) {
				if (result.length > 0) {
					console.log(result.length);
					for (var i = 0; i < result.length; i++) {
						map.data.forEach(function(feature) {
							feature.setProperty("strokeWeight", result[i].strokeWeight);
							if (result[i].precinctId === feature.getProperty("GEOID10")) {
								feature.setProperty("COLOR", result[i].color);
								feature.setProperty("DISTRICT",result[i].districtId);
							}
						});
					}
				}
			}
		});
	}, 300);
}

function renderRg() {
	setInterval(function() {
		$.ajax({
			type : "GET",
			contentType : "application/json",
			url : "/renderRg",
			success : function(result) {
				if (result.length > 0) {
					map.data.forEach(function(feature) {
						feature.setProperty("DISTRICT", 0);
						feature.setProperty("COLOR", "white");
					});
					for (var i = 0; i < result.length; i++) {
						map.data.forEach(function(feature) {
							feature.setProperty("strokeWeight", result[i].strokeWeight);
							if (result[i].precinctId === feature.getProperty("GEOID10")) {
								feature.setProperty("COLOR", result[i].color);
								feature.setProperty("DISTRICT",result[i].districtId);
							}
						});
					}
				}
			}
		});
	}, 300);
}

function listenOnSa() {
	setInterval(function() {
		$.ajax({
			type : "GET",
			contentType : "application/json",
			url : "/listenOnSa",
			success : function(result) {
				if (result.length > 0) {
					for (var i = 0; i < result.length; i++) {
						map.data.forEach(function(feature) {
							if (result[i].precinctId === feature.getProperty("GEOID10")) {

								feature.setProperty("DISTRICT",result[i].districtId);
								feature.setProperty("COLOR", result[i].color);
								feature.setProperty("strokeWeight", 1.5);
							}
						});
						$('#console').append(result[i].msg); 
					}
				}
			}
		});
	}, 2000);
}

function listenOnRg() {
	setInterval(function() {
		$.ajax({
			type : "GET",
			contentType : "application/json",
			url : "/listenOnRg",
			success : function(result) {
				if (result.length > 0) {
					for (var i = 0; i < result.length; i++) {
						map.data.forEach(function(feature) {
							if (result[i].precinctId === feature.getProperty("GEOID10")) {
								feature.setProperty("DISTRICT", result[i].districtId);
								feature.setProperty("COLOR", result[i].color);
								//feature.setProperty("strokeWeight", 2);
							}
						});
						$('#console').append(result[i].msg); 
					}
				}
			}
		});
	}, 300);
}

function update() {
	setInterval(function() {
		$.ajax({
			type : "GET",
			contentType : "application/json",
			url : "/update",
			success : function(result) {
				if (result.populations.length > 0) {
					var str = '<h6>District Informations</h6>';
					
					for (var i = 0; i < result.populations.length; i++) {
						var num = i + 1;
						str = str + '<b>District ' + num + ':</b> '
						+ result.populations[i] + ' ' + result.scores[i]
						+ '<br>';

					}
					
					document.getElementById('legendText').innerHTML = str;
				}
			}
		});
	}, 2000);
}

function pause() {
	$.ajax({
		type : "GET",
		contentType : "application/json",
		url : "/pause",
		success : function(result) {
			console.log(result);
		}
	});
}

function resume() {
	$.ajax({
		type : "GET",
		contentType : "application/json",
		url : "/resume",
		success : function(result) {
			console.log(result);
		}
	});
}

function stop() {
	$.ajax({
		type : "GET",
		contentType : "application/json",
		url : "/stop",
		success : function(result) {
			console.log(result);
		}
	});
}
