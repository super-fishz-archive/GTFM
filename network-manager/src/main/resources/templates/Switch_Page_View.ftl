<div class="container-fluid">
		<div class="starter-template">
        	<h1>자연과학대학 스위치 정보창</h1>
        	<p class="lead">Switch Status</p>
                	<h4 align="left">JA1_SWITCH 주소할당 상태<small>자연과학대학교</small></h4>

<script>
function viewPage(self) {
	var target = $(self).data("target");
	
	
		$("#tabs_parent div.list-group").css("display", "none");
		$('#' + target).css("display", "block");

}
</script>
                <div class="row" id="tabs_parent">
<ul class="nav nav-tabs">
  <li role="presentation" class="active"><a href="#" data-target="tab_static" onclick="viewPage(this)")>Static</a></li>
  <li role="presentation"><a href="#" data-target="tab_dhcp" onclick="viewPage(this)" >DHCP Network</a></li>
</ul>
			<div class="list-group" id="tab_static">
  				<a href="#" class="list-group-item" data-toggle="modal" data-target="#myModal">1 static</a>
  				<a href="#" class="list-group-item" data-toggle="modal" data-target="#myModal">2</a>
  				<a href="#" class="list-group-item" data-toggle="modal" data-target="#myModal">3</a>
  				<a href="#" class="list-group-item" data-toggle="modal" data-target="#myModal">4</a>
  				<a href="#" class="list-group-item" data-toggle="modal" data-target="#myModal">5</a>
			</div>
			<div class="list-group" id="tab_dhcp" style="display:none">
  				<a href="#" class="list-group-item" data-toggle="modal" data-target="#myModal">1 dhcp</a>
  				<a href="#" class="list-group-item" data-toggle="modal" data-target="#myModal">2</a>
  				<a href="#" class="list-group-item" data-toggle="modal" data-target="#myModal">3</a>
  				<a href="#" class="list-group-item" data-toggle="modal" data-target="#myModal">4</a>
  				<a href="#" class="list-group-item" data-toggle="modal" data-target="#myModal">5</a>
			</div>
				</div><!-- /.row -->
				
      		</div>
      	</div>
      	
      	<!-- Button trigger modal -->

<!-- Modal -->
<div class="modal fade" id="myModal" tabindex="-1" role="dialog" aria-labelledby="myModalLabel">
  <div class="modal-dialog" role="document">
    <div class="modal-content">
      <div class="modal-header">
        <button type="button" class="close" data-dismiss="modal" aria-label="Close"><span aria-hidden="true">&times;</span></button>
        <h4 class="modal-title" id="myModalLabel" align="center">ICP/IPv4 정보</h4>
      </div>
      <div class="modal-body">
        <table class="table table-striped">
        <tr>
            <td>IP address</td>
            <td width="10"><div align="center">:</div></td>
            <td>_________________</td>
        </tr>
        <tr>
            <td>Subnet mask</td>
            <td width="10"><div align="center">:</div></td>
            <td>_________________</td>
        </tr>
        <tr>
        	<td>Default gateway</td>
        	<td width="10"><div align="center">:</div></td>
        	<td>_________________</td>
        </tr>
        <tr>
        	<td>DNS server</td>
        	<td width="10"><div align="center">:</div></td>
        	<td>_________________</td>
        </tr>
        <tr>
        	<td> Sub DNS</td>
        	<td width="10"><div align="center">:</div></td>
        	<td>_________________</td>
        </tr>
        </table>
      </div>
      <div class="modal-footer">
        <button type="button" class="btn btn-default" data-dismiss="modal">Close</button>
        <button type="button" class="btn btn-primary">해당장소로 이동</button>
      </div>
    </div>
  </div>
</div>
