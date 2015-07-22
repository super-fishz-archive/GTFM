    <script>
        var name, dr, nt, sb, dns, ex1, ex2;
        function DHCP_INPUT(name, dr, nt, sb, dns, ex1, ex2) {
            var a = [];
            $('#dhcp input[type="text"]').each(function () {
                if ($(this).attr("id") == "DHCP_NAME") {
                    a.push("ip dhcp pool " + this.value);
                }
                else if ($(this).attr("id") == "Dafault_Router") {
                    a.push("default-router " + this.value);
                }
                else if ($(this).attr("id") == "Network") {
                    a.push("network " + this.value + " " + $(Subnet_Mask).val());
                }
                else if ($(this).attr("id") == "DNS_Server") {
                    a.push("dns-sever " + this.value);
                }
                else if ($(this).attr("id") == "Excluded_Address1") {
                    a.push("ip dhcp excluded-address " + this.value);
                }
                else if ($(this).attr("id") == "Excluded_Address2") {
                    a.push("ip dhcp excluded-address " + this.value);
                }
            });
           var b =  a.join("\n");
            alert(b);
          
            
            $.ajax({
                method: "POST",
                url: "/data/building/",
                data: b,
                datatype : "json"
            })
  .done(function (msg) {
      alert("Data Saved: " + msg);
  });
  
            
        
            
            
        };
        
    </script>


      <!-- Modal -->
      <div id="myModal" class="modal fade" role="dialog">
          <div class="modal-dialog">

              <!-- Modal content-->
              <div class="modal-content">
                  <div class="modal-header">
                      <button type="button" class="close" data-dismiss="modal">&times;</button>
                      <h4 class="modal-title">DHCP Server 설정하기</h4>
                  </div>
                  <div class="modal-body">
                      <div class="table-responsive">
                          <table class="table table-bordered table-striped" id="dhcp">
                              <colgroup>
                                  <col class="col-lg-3">
                                  <col class="col-lg-3">
                              </colgroup>
                              <thead>
                                  <tr class="alt">
                                      <th>Entity</th>
                                      <th>Input</th>
                                  </tr>
                              </thead>
                              <tbody>
                                  <tr>
                                      <td>DHCP NAME</td>
                                      <td><input id="DHCP_NAME" class="span12" type="text" value=""></td>
                                  </tr>
                                  <tr class="alt">
                                      <td>Default Router</td>
                                      <td><input id="Default_Router" class="span12" type="text" value=""></td>
                                  </tr>
                                  <tr class="alt">
                                      <td>Network</td>
                                      <td><input id="Network" class="span12" type="text" value=""></td>
                                  </tr>
                                  <tr class="alt">
                                      <td>Subnet Mask</td>
                                      <td><input id="Subnet_Mask" class="span12" type="text" value=""></td>
                                  </tr>
                                  <tr class="alt">
                                      <td>DNS Sever</td>
                                      <td><input id="DNS_Server" class="span12" type="text" value=""></td>
                                  </tr>
                                  <tr class="alt">
                                      <td>Excluded Address1</td>
                                      <td><input id="Excluded_Address1" class="span12" type="text" value=""></td>
                                  </tr>
                                  <tr class="alt">
                                      <td>Excluded Address2</td>
                                      <td><input id="Excluded_Address2"  class="span12" type="text" value=""></td>
                                  </tr>
                              </tbody>
                          </table>
                      </div>

                  </div>
                  <div class="modal-footer">
                      <button class="btn btn-primary" type="button" onclick="DHCP_INPUT()">Apply</button>
                      <button type="button" class="btn btn-default" data-dismiss="modal">Close</button>
                  </div>
              </div>

          </div>
      </div>


    <div class="container-fluid">

      <div class="starter-template">
        <h1>자연과학대학 라우터 정보창</h1>
        <p class="lead">Router Status</p>
      </div>

        <div class="row">
            <div class="col-md-10 left">
                <h4>JA1_Router<small>자연과학대학교</small></h4>
            </div>
            <div class="col-md-2 right">
                <!-- Trigger the modal with a button -->
                <button type="button" class="btn btn-default" data-toggle="modal" data-target="#myModal">DHCP SERVER</button>
            </div>
        </div>
        <div class="table-responsive">
            <table class="table table-bordered table-striped">
                <colgroup>
                    <col class="col-lg-3">
                    <col class="col-lg-5">

                </colgroup>
                <thead>
                    <tr class="alt">
                        <th>속성</th>
                        <th>정보</th>

                    </tr>
                </thead>
                <tbody>
                    <tr>
                        <td><code>IP 대역</code> </td>
                        <td>192.168.1.0</td>
                    </tr>
                    <tr class="alt">
                        <td><code>Gateway</code> </td>
                        <td>192.168.1.254</td>
                    </tr>
                    <tr class="alt">
                        <td><code>Subnet</code></td>
                        <td>255.255.255.0</td>
                    </tr>
                    <tr class="alt">
                        <td><code>Location</code></td>
                        <td>101호</td>
                    </tr>
                </tbody>
            </table>
        </div>


        <div class="row">
            <div class="col-md-10 left">
                <h4>JA2_Router<small>자연과학대학교</small></h4>
            </div>
            <div class="col-md-2 right">
                <!-- Trigger the modal with a button -->
                <button type="button" class="btn btn-default" data-toggle="modal" data-target="#myModal">DHCP SERVER</button>
            </div>
        </div>
        
        <div class="table-responsive">
            <table class="table table-bordered table-striped">
                <colgroup>
                    <col class="col-lg-3">
                    <col class="col-lg-5">
                </colgroup>
                <thead>
                    <tr class="alt">
                        <th>속성</th>
                        <th>정보</th>
                    </tr>
                </thead>
                <tbody>
                    <tr>
                        <td><code>IP 대역</code> </td>
                        <td>192.168.2.0</td>
                    </tr>
                    <tr class="alt">
                        <td><code>Gateway</code> </td>
                        <td>192.168.2.254</td>
                    </tr>
                    <tr class="alt">
                        <td><code>Subnet</code></td>
                        <td>255.255.255.0</td>
                    </tr>
                    <tr class="alt">
                        <td><code>Location</code></td>
                        <td>202호</td>
                    </tr>
                </tbody>
            </table>
        </div>