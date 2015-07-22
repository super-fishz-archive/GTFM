 <!-- Modal -->
    <div id="myModal" class="modal fade" role="dialog">
        <div class="modal-dialog">

            <!-- Modal content-->
            <div class="modal-content">
                <div class="modal-header">
                    <button type="button" class="close" data-dismiss="modal">&times;</button>
                    <h4 class="modal-title">PC IP Status</h4>
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
                                    <th>Output</th>
                                </tr>
                            </thead>
                            <tbody>
                                <tr>
                                    <td>PC Number</td>
                                    <td><span id="PC_Num"></span></td>
                                </tr>
                                <tr class="alt">
                                    <td>IP address</td>
                                    <td><span id="IP_Add"></span></td>
                                </tr>
                                <tr class="alt">
                                    <td>Subnet Mask</td>
                                    <td><span id="Sub"></span></td>
                                </tr>
                                <tr class="alt">
                                    <td>Gateway</td>
                                    <td><span id="GateWay"></span></td>
                                </tr>
                                <tr class="alt">
                                    <td>DNS Sever</td>
                                    <td><span id="DS1"></span></td>
                                </tr>
                                <tr class="alt">
                                    <td>Sub DNS Sever</td>
                                    <td><span id="DS2"></span></td>
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
            <h1>101호</h1>
            <p class="lead">과학기술대학</p>
        </div>
        <div class="row">
            <div class="col-md-10 left">
                <h4>101호 PC Status<small>과학기술대학</small></h4>
            </div>
        </div>
        <div class="table-responsive">
            <table class="table table-bordered table-striped">
                <colgroup>
                    <col class="col-lg-3">
                    <col class="col-lg-3">
                    <col class="col-lg-3">
                    <col class="col-lg-3">

                </colgroup>

                <tbody id="pcBody">
                    <tr>
                        <td align="center"><button id="Ja1" type="button" class="btn btn-default" data-toggle="modal" data-target="#myModal">1</button></td>
                        <td align="center"><button id="Ja2" type="button" class="btn btn-default" data-toggle="modal" data-target="#myModal">2</button></td>
                        <td align="center"><button id="Ja3" type="button" class="btn btn-default" data-toggle="modal" data-target="#myModal">3</button></td>
                        <td align="center"><button id="Ja4" type="button" class="btn btn-default" data-toggle="modal" data-target="#myModal">4</button></td>
                    </tr>
                    <tr class="alt">
                        <td align="center"><button id="Ja5"  type="button" class="btn btn-default" data-toggle="modal" data-target="#myModal">5</button></td>
                        <td align="center"><button id="Ja6"  type="button" class="btn btn-default" data-toggle="modal" data-target="#myModal">6</button></td>
                        <td align="center"><button id="Ja7"  type="button" class="btn btn-default" data-toggle="modal" data-target="#myModal">7</button></td>
                        <td align="center"><button id="Ja8"  type="button" class="btn btn-default" data-toggle="modal" data-target="#myModal">8</button></td>
                    </tr>
                    <tr class="alt">
                        <td align="center"><button id="Ja9"  type="button" class="btn btn-default" data-toggle="modal" data-target="#myModal">9</button></td>
                        <td align="center"><button id="Ja10" type="button" class="btn btn-default" data-toggle="modal" data-target="#myModal">10</button></td>
                        <td align="center"><button id="Ja11" type="button" class="btn btn-default" data-toggle="modal" data-target="#myModal">11</button></td>
                        <td align="center"><button id="Ja12" type="button" class="btn btn-default" data-toggle="modal" data-target="#myModal">12</button></td>
                    </tr>
                    <tr class="alt">
                        <td align="center"><button id="Ja13" type="button" class="btn btn-default" data-toggle="modal" data-target="#myModal">13</button></td>
                        <td align="center"><button id="Ja14" type="button" class="btn btn-default" data-toggle="modal" data-target="#myModal">14</button></td>
                        <td align="center"><button id="Ja15" type="button" class="btn btn-default" data-toggle="modal" data-target="#myModal">15</button></td>
                        <td align="center"><button id="Ja16" type="button" class="btn btn-default" data-toggle="modal" data-target="#myModal">16</button></td>
                    </tr>
                    <tr class="alt">
                        <td align="center"><button id="Ja17" type="button" class="btn btn-default" data-toggle="modal" data-target="#myModal">17</button></td>
                        <td align="center"><button id="Ja18" type="button" class="btn btn-default" data-toggle="modal" data-target="#myModal">18</button></td>
                        <td align="center"><button id="Ja19" type="button" class="btn btn-default" data-toggle="modal" data-target="#myModal">19</button></td>
                        <td align="center"><button id="Ja20" type="button" class="btn btn-default" data-toggle="modal" data-target="#myModal">20</button></td>
                    </tr>
                    <tr class="alt">
                        <td align="center"><button id="Ja21" type="button" class="btn btn-default" data-toggle="modal" data-target="#myModal">21</button></td>
                        <td align="center"><button id="Ja22" type="button" class="btn btn-default" data-toggle="modal" data-target="#myModal">22</button></td>
                        <td align="center"><button id="Ja23" type="button" class="btn btn-default" data-toggle="modal" data-target="#myModal">23</button></td>
                        <td align="center"><button id="Ja24" type="button" class="btn btn-default" data-toggle="modal" data-target="#myModal">24</button></td>
                    </tr>
                    <tr class="alt">
                        <td align="center"><button id="Ja25" type="button" class="btn btn-default" data-toggle="modal" data-target="#myModal">25</button></td>
                        <td align="center"><button id="Ja26" type="button" class="btn btn-default" data-toggle="modal" data-target="#myModal">26</button></td>
                        <td align="center"><button id="Ja27" type="button" class="btn btn-default" data-toggle="modal" data-target="#myModal">27</button></td>
                        <td align="center"><button id="Ja28" type="button" class="btn btn-default" data-toggle="modal" data-target="#myModal">28</button></td>
                    </tr>
                    <tr class="alt">
                        <td align="center"><button id="Ja29" type="button" class="btn btn-default" data-toggle="modal" data-target="#myModal">29</button></td>
                        <td align="center"><button id="Ja30" type="button" class="btn btn-default" data-toggle="modal" data-target="#myModal">30</button></td>
                        <td align="center"><button id="Ja31" type="button" class="btn btn-default" data-toggle="modal" data-target="#myModal">31</button></td>
                        <td align="center"><button id="Ja32" type="button" class="btn btn-default" data-toggle="modal" data-target="#myModal">32</button></td>
                    </tr>
                    <tr class="alt">
                        <td align="center"><button id="Ja33" type="button" class="btn btn-default" data-toggle="modal" data-target="#myModal">33</button></td>
                        <td align="center"><button id="Ja34" type="button" class="btn btn-default" data-toggle="modal" data-target="#myModal">34</button></td>
                        <td align="center"><button id="Ja35" type="button" class="btn btn-default" data-toggle="modal" data-target="#myModal">35</button></td>
                        <td align="center"><button id="Ja36" type="button" class="btn btn-default" data-toggle="modal" data-target="#myModal">36</button></td>
                    </tr>
                    <tr class="alt">
                        <td align="center"><button id="Ja37" type="button" class="btn btn-default" data-toggle="modal" data-target="#myModal">37</button></td>
                        <td align="center"><button id="Ja38" type="button" class="btn btn-default" data-toggle="modal" data-target="#myModal">38</button></td>
                        <td align="center"><button id="Ja39" type="button" class="btn btn-default" data-toggle="modal" data-target="#myModal">39</button></td>
                        <td align="center"><button id="Ja40" type="button" class="btn btn-default" data-toggle="modal" data-target="#myModal">40</button></td>
                    </tr>
                   
                </tbody>
            </table>
        </div>