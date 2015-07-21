/**
 * 
 */

function insertRoom(){
	var sampleData = {
		"roomName" : "ABC",
		"buildingSeq" : 1,
		"memo" : "no comment"};
	
	$.ajax({
		"url" : "/data/room",
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

function deleteRoom(){
	$.ajax({
		"url" : "/data/room/1",
		"type" : "delete",
		"datatype" : "json",
		"success" : function(result){
			alert(JSON.stringify(result));
		}
	});
}

function selectRoom(){
	$.ajax({
		"url" : "/data/room",
		"type" : "get",
		"success" : function(result){
			alert(JSON.stringify(result));
		}
	});
}