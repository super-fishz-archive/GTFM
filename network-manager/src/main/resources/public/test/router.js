/**
 * 
 */

function insertRouter(){
	var sampleData = {
		"ip" : "123.123.123.123",
		"defaultGateway" : "123.123.123.1",
		"dnsServer" : "123.123.123.2",
		"subnetMask" : "255.255.255.0",
		"physicalRange" : "100",
		"buildingSeq" : 1,
		"roomSeq" : 1,
		"memo" : "no comment"};
	
	$.ajax({
		"url" : "/data/router",
		"type" : "post",
		"datatype" : "json",
		"headers" : {
			"Content-Type" : "application/json; charset=utf-8"
		},
		"data" : JSON.stringify(sampleData),
		"success" : function(result){
			alert(JSON.stringify(result));
		}
	});
}

function deleteRouter(){
	$.ajax({
		"url" : "/data/router/1",
		"type" : "delete",
		"datatype" : "json",
		"success" : function(result){
			alert(JSON.stringify(result));
		}
	});
}

function selectRouter(){
	$.ajax({
		"url" : "/data/router",
		"type" : "get",
		"success" : function(result){
			alert(JSON.stringify(result));
		}
	});
}