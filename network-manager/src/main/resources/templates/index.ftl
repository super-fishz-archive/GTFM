<div class="container-fluid">

      <div class="starter-template">
        <h1><span class="title">종합강의동</span> 장비 보유 현황</h1>
        <p class="lead">Router, Switch, PC에 대한 간략한 정보</p>
      </div>

        <h4>Router Status <small class="title">종합강의동</small></h4>
        <div class="table-responsive">
            <table class="table table-bordered table-striped">
                <colgroup>
                    <col class="col-lg-3">
                    <col class="col-lg-2">
                    <col class="col-lg-3">
                    <col class="col-lg-3">
                </colgroup>
                <thead>
                    <tr class="alt">
                        <th>Router Name</th>
                        <th>Location</th>
                        <th>IP Address</th>
                        <th>Subnet Mask</th>
                    </tr>
                </thead>
                <tbody id="routerStatusTbody">
                <!-- 
                    <tr>
                        <td><code>Ja1_Router</code> </td>
                        <td>202호</td>
                        <td>192.168.1.1</td>
                        <td>255.255.255.0</td>
                    </tr>
                    <tr class="alt">
                        <td><code>Ja2_Router</code> </td>
                        <td>101호</td>
                        <td>192.168.2.1</td>
                        <td>255.255.255.0</td> -->
                    </tr>
                </tbody>
            </table>
        </div>

        <h4>Switch Status <small class="title">종합강의동</small></h4>
        <div class="table-responsive">
            <table class="table table-bordered table-striped">
                <colgroup>
                    <col class="col-lg-3">
                    <col class="col-lg-2">
                    <col class="col-lg-3">
                    <col class="col-lg-3">
                </colgroup>
                <thead>
                    <tr class="alt">
                        <th>Switch Name</th>
                        <th>Location</th>
                        <th>IP Address</th>
                    </tr>
                </thead>
                <tbody id="switchStatusTbody">
                <!-- 
                    <tr>
                        <td><code>Ja1_Switch</code> </td>
                        <td>202호</td>
                        <td>192.168.1.254</td>
                        <td>255.255.255.0</td>
                    </tr>
                    <tr class="alt">
                        <td><code>Ja2_Switch</code> </td>
                        <td>101호</td>
                        <td>192.168.2.254</td>
                        <td>255.255.255.0</td>
                    </tr>
                </tbody>
                -->
            </table>
        </div>
        <h4>PC Status <small class="title">종합강의동</small></h4>
        <div class="bs-example bs-example-type">
            <table class="table">
                <thead>
                    <tr>
                        <th>ID</th>
                        <th>Location</th>
                        <th>IP Address</th>
                    </tr>
                </thead>
                <tbody id="pcStatusTbody">
                	<!-- 
                    <tr class="active alt">
                        <td>1</td>
                        <td>Column content</td>
                        <td>Column content</td>
                        <td>Column content</td>
                        <td></td>         
                    </tr>
                    <tr>
                        <td>2</td>
                        <td>Column content</td>
                        <td>Column content</td>
                        <td>Column content</td>
                        <td></td> 
                    </tr>
                    <tr class="success alt">
                        <td>3</td>
                        <td>Column content</td>
                        <td>Column content</td>
                        <td>Column content</td>
                        <td></td> 
                    </tr>
                    <tr>
                        <td>4</td>
                        <td>Column content</td>
                        <td>Column content</td>
                        <td>Column content</td>
                        <td></td> 
                    </tr>
                    <tr class="info alt">
                        <td>5</td>
                        <td>Column content</td>
                        <td>Column content</td>
                        <td>Column content</td>
                        <td></td> 
                    </tr>
                    <tr>
                        <td>6</td>
                        <td>Column content</td>
                        <td>Column content</td>
                        <td>Column content</td>
                        <td></td> 
                    </tr>
                    <tr class="warning alt">
                        <td>7</td>
                        <td>Column content</td>
                        <td>Column content</td>
                        <td>Column content</td>
                        <td></td> 
                    </tr>
                    <tr>
                        <td>8</td>
                        <td>Column content</td>
                        <td>Column content</td>
                        <td>Column content</td>
                        <td></td> 
                    </tr>
                    <tr class="danger alt">
                        <td>9</td>
                        <td>Column content</td>
                        <td>Column content</td>
                        <td>Column content</td>
                        <td></td> 
                    </tr>
                    -->
                </tbody>
            </table>
        </div>
        <div class="bs-example_html_code">
            <pre class="highlight"><code><span class="c">&lt;!-- On rows --&gt;</span>
<span class="nt">&lt;tr</span> <span class="na">class=</span><span class="s">"active"</span><span class="nt">&gt;</span>...<span class="nt">&lt;/tr&gt;</span>
<span class="nt">&lt;tr</span> <span class="na">class=</span><span class="s">"success"</span><span class="nt">&gt;</span>...<span class="nt">&lt;/tr&gt;</span>
<span class="nt">&lt;tr</span> <span class="na">class=</span><span class="s">"warning"</span><span class="nt">&gt;</span>...<span class="nt">&lt;/tr&gt;</span>
<span class="nt">&lt;tr</span> <span class="na">class=</span><span class="s">"danger"</span><span class="nt">&gt;</span>...<span class="nt">&lt;/tr&gt;</span>
<span class="nt">&lt;tr</span> <span class="na">class=</span><span class="s">"info"</span><span class="nt">&gt;</span>...<span class="nt">&lt;/tr&gt;</span>
<span class="c">&lt;!-- On cells (`td` or `th`) --&gt;</span>
<span class="nt">&lt;tr&gt;</span>
            <span class="nt">&lt;td</span> <span class="na">class=</span><span class="s">"active"</span><span class="nt">&gt;</span>...<span class="nt">&lt;/td&gt;</span>
            <span class="nt">&lt;td</span> <span class="na">class=</span><span class="s">"success"</span><span class="nt">&gt;</span>...<span class="nt">&lt;/td&gt;</span>
            <span class="nt">&lt;td</span> <span class="na">class=</span><span class="s">"warning"</span><span class="nt">&gt;</span>...<span class="nt">&lt;/td&gt;</span>
            <span class="nt">&lt;td</span> <span class="na">class=</span><span class="s">"danger"</span><span class="nt">&gt;</span>...<span class="nt">&lt;/td&gt;</span>
            <span class="nt">&lt;td</span> <span class="na">class=</span><span class="s">"info"</span><span class="nt">&gt;</span>...<span class="nt">&lt;/td&gt;</span>
<span class="nt">&lt;/tr&gt;</span></code></pre>
        </div>
        <p>&nbsp;</p>
        
        
  <script>
  function getUrlParameter(sParam)
  {
      var sPageURL = window.location.search.substring(1);
      var sURLVariables = sPageURL.split('&');
      for (var i = 0; i < sURLVariables.length; i++) 
      {
          var sParameterName = sURLVariables[i].split('=');
          if (sParameterName[0] == sParam) 
          {
              return sParameterName[1];
          }
      }
  }    
  
  $(document).ready(function(){
	var building = getUrlParameter("building");
	if (!building) {
		window.location.search = "?building=1";
	}
	getUrlParameter("building");
	
	setTitle();
	setRouterStatus();
	setSwitchStatus();
	setPcStatus();
  });
  
  function setTitle(){
	var url = "/data/building/" + getUrlParameter("building");
	$.ajax({
		"url" : url,
		"type" : "get",
		"datatype" : "json",
		"success" : function(result){
			$(".title").text(result["buildingName"]);	
		}
	});
  }
  
  function setRouterStatus(){
	  var url = "/data/router/in-building/" + getUrlParameter("building");
	  $.ajax({
		  "url" : url,
		  "type" : "get",
		  "datatype" : "json",
		  "success" : function(resultData){
			  var tbody = $("#routerStatusTbody");
			  for(var i=0 ; i < resultData.length ; i++){
				var result = resultData[i];
			  	tbody.append("<tr class='alt'><td>" 
			  			+ result["seq"] + "</td><td>"
			  			+ result["roomName"] + "</td><td>"
			  			+ result["ip"] + "</td><td>"
			  			+ result["subnetMask"] + "</td></tr>");
			  }
		  }
	  });
  }
  
  function setSwitchStatus(){
	  var url = "/data/switch/in-building/" + getUrlParameter("building");
	  $.ajax({
		  "url" : url,
		  "type" : "get",
		  "datatype" : "json",
		  "success" : function(resultData){
			  var tbody = $("#switchStatusTbody");
			  for(var i=0 ; i < resultData.length ; i++){
				var result = resultData[i];
			  	tbody.append("<tr class='alt'><td>" 
			  			+ result["seq"] + "</td><td>"
			  			+ result["roomName"] + "</td><td>"
			  			+ result["ip"] + "</td></tr>");
			  }
		  }
	  });
  }
  
  function setPcStatus(){
	  var url ="/data/pc/in-building/" + getUrlParameter("building");
	  $.ajax({
		  "url" : url,
		  "type" : "get",
		  "datatype" : "json",
		  "success" : function(resultData){
			  var tbody = $("#pcStatusTbody");
			  for(var i=0 ; i < resultData.length ; i++){
				var result = resultData[i];
			  	tbody.append("<tr class='alt'><td>" 
			  			+ result["seq"] + "</td><td>"
			  			+ result["roomName"] + "</td><td>"
			  			+ result["ip"] + "</td></tr>");
			  }
		  }
	  });
  }
  </script>