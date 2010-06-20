$(document).ready(function(){

	function port_pin () {
		var port = $('[name=port]:checked').attr('value');
		var pin = $('[name=pin]:checked').attr('value');
		return "/"+port+"/"+pin;
	};

	$('[name=port],[name=pin]').click(function(obj){
		$('[name=direction],[name=state]').removeAttr('checked') });

	$('[name=state]').click(function(obj){
		$('[name=direction][value=O]').click();
		$.ajax({ type: 'PUT', url: port_pin() , data: "state="+this.value });
	});

	$('[name=direction][value=I]').click(function(obj){
		$.getJSON(port_pin(), function(data) {
			$('[name=state][value='+data.bit+']').attr('checked',true);
		});
	});

	$('[name=channel]').click(function(obj){
		var ch = obj.currentTarget.value;
		function plot () {
			$.getJSON('ch/'+ch, function (data) {
				$.plot($(".plot"), [data], {});
			});
		}
		plot();
		$(".plot").unbind('click').click(plot);
	});

	$('#slider').slider({
		min: 660,
		max: 2140,
		value: 1400,
		step: 20,
		animate: true,
		slide: function(event, ui) {
			$.ajax({ type: 'PUT', url: 'slide' , data: "state="+ui.value });
		}
	});

});