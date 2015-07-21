/**
 * 
 */

function insertPc(){
	var sampleData = {
		"roomSeq" : 1,
		"memo" : "no comment"};
	
	$.ajax({
		"url" : "/data/pc",
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

function deletePc(){
	$.ajax({
		"url" : "/data/pc/1",
		"type" : "delete",
		"datatype" : "json",
		"success" : function(result){
			alert(JSON.stringify(result));
		}
	});
}

function selectPc(){
	$.ajax({
		"url" : "/data/pc",
		"type" : "get",
		"success" : function(result){
			alert(JSON.stringify(result));
		}
	});
}