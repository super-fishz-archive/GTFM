/**
 * 
 */

function insertBuilding(){
	var sampleData = {
		"buildingName" : "ASDASD"};
	
	$.ajax({
		"url" : "/data/building",
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

function deleteBuilding(){
	$.ajax({
		"url" : "/data/building/1",
		"type" : "delete",
		"datatype" : "json",
		"success" : function(result){
			alert(JSON.stringify(result));
		}
	});
}

function selectBuilding(){
	$.ajax({
		"url" : "/data/building",
		"type" : "get",
		"success" : function(result){
			alert(JSON.stringify(result));
		}
	});
}