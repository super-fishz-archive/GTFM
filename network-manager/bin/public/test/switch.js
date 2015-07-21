/**
 * 
 */

function insertSwitch(){
	var sampleData = {
		"routerSeq" : 1,
		"ip" : "123.123.1.1",
		"memo" : "no comment"};
	
	$.ajax({
		"url" : "/data/switch",
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

function deleteSwitch(){
	$.ajax({
		"url" : "/data/switch/1",
		"type" : "delete",
		"datatype" : "json",
		"success" : function(result){
			alert(JSON.stringify(result));
		}
	});
}

function selectSwitch(){
	$.ajax({
		"url" : "/data/switch",
		"type" : "get",
		"success" : function(result){
			alert(JSON.stringify(result));
		}
	});
}