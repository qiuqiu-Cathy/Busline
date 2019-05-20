<%@ page import="java.util.ArrayList" %>
<%@ page import="java.util.List" %>
<%@ page import="com.qiu.shu.busline.domain.Line" %>
<%@ page language="java" contentType="text/html; charset=UTF-8"
		 pageEncoding="UTF-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
	<title>公交线路优化首页</title>
	<script type = "text/javascript"  src="js/jquery-3.4.0.js"></script>
    <script type = "text/javascript"  src="js/leaflet-ant-path.js"></script>

	<link rel="stylesheet" href="https://unpkg.com/leaflet@1.4.0/dist/leaflet.css"
		  integrity="sha512-puBpdR0798OZvTTbP4A8Ix/l+A4dHDD0DGqYW6RQ+9jxkRFclaxxQb/SJAWZfWAkuyeQUytO7+7N4QKrDh+drA=="
		  crossorigin=""/>
	<script src="https://unpkg.com/leaflet@1.4.0/dist/leaflet.js"
			integrity="sha512-QVftwZFqvtRNi0ZyCtsznlKSWOStnDORoefr1enyq5mVL4tmKB3S/EnC3rRJcxCPavG10IcrVGSmPh6Qw5lwrg=="
			crossorigin=""></script>
	<script src="https://cdn.jsdelivr.net/npm/leaflet.chinesetmsproviders@1.0.22/src/leaflet.ChineseTmsProviders.min.js"></script>

	<style type="text/css">
			#map{
				margin-left:200px;
				margin-top:30px;
				margin-bottom: 5px;
				width:1000px;
				height: 480px;
			 }
			.content{
				position: fixed; top:100px; width: 100px;height: 100px;
			}
            #addLine { /* 新建线路弹框的页面*/
                width: 60px; /*宽度*/
                height: 100px; /*高度*/
                background: #fff; /*背景色*/
                display: none; /*隐藏*/
                position: fixed;
                top: 100px;
            }
            #startNew{ /* 新增线路-开始的弹框的页面*/
                width: 60px; /*宽度*/
                height: 100px; /*高度*/
                background: #fff; /*背景色*/
                display: none; /*隐藏*/
                position: fixed;
                top: 100px;
            }
            #continueNew{ /* 新增线路-继续的弹框的页面*/
                width: 60px; /*宽度*/
                height: 100px; /*高度*/
                background: #fff; /*背景色*/
                display: none; /*隐藏*/
                position: fixed;
                top: 100px;
            }
            #addStop { /* 新建线路-添加站点至线路 添加原有站点和新站点（初始站点）的弹框的页面*/
                width: 60px; /*宽度*/
                height: 100px; /*高度*/
                background: #fff; /*背景色*/
                display: none; /*隐藏*/
                position: fixed;
                top: 100px;
            }
            #addCoord { /* 新建线路-开始-添加拐点至线路 弹框的页面*/
                width: 60px; /*宽度*/
                height: 100px; /*高度*/
                background: #fff; /*背景色*/
                display: none; /*隐藏*/
                position: fixed;
                top: 100px;
            }
            #continueAddCoord { /* 新建线路-继续-添加拐点至线路 弹框的页面*/
                width: 60px; /*宽度*/
                height: 100px; /*高度*/
                background: #fff; /*背景色*/
                display: none; /*隐藏*/
                position: fixed;
                top: 100px;
            }
            #correctLine { /* 修改线路的弹框的页面*/
                width: 60px; /*宽度*/
                height: 100px; /*高度*/
                background: #fff; /*背景色*/
                display: none; /*隐藏*/
                position: fixed;
                top: 100px;
            }
            #startCorrect{ /* 开始修改 线路的弹框的页面*/
                width: 60px; /*宽度*/
                height: 100px; /*高度*/
                background: #fff; /*背景色*/
                display: none; /*隐藏*/
                position: fixed;
                top: 70px;
            }
            #deleteLine{ /* 删除线路的弹框的页面*/
                width: 60px; /*宽度*/
                height: 100px; /*高度*/
                background: #fff; /*背景色*/
                display: none; /*隐藏*/
                position: fixed;
                top: 100px;
            }


	</style>
</head>

<body>
	<div><h2>欢迎进入公交线路优化仿真实验平台</h2></div>
	<div id ="map"></div>
</body>
<%
	//获取request域中的有效线路信息
    List<Line> linesResult = (List<Line>)request.getAttribute("linesResult");
%>

<div class = "wrap">
	<div id='form' class = "content">

        公交线路 :<input type="text" id="queryLineName"/>
        <input type="button" value="线路查询" onclick="queryLine()"/>
        <input type="button" value="线路站点显示" onclick="queryLineOfStops()">

        <p><input type="button" value="站点覆盖率查询" onclick="stopCoverage()"/></p>

        <p><input type="button" value="所有站点显示" onclick="stopShow()"/></p>

        <p><input type="text" id ="measure" autocomplete="on"/>
        <input type="button" value="米内居民区站点覆盖率查询" onclick="neighbourCoverageQuery()"></p>

        <p><input type="button" value="线路删除" onclick="deleteLine()"></p>

        <p><input type="button"  value="新建线路" onclick="newLine()"></p>

        <p><input type="button"  value="修改线路" onclick="correctLine()"></p>

        <div class="layui-input-inline">
            <button  class="layui-btn layui-btn-fluid" type="button" @click="LineOptimization"><i class="layui-icon">&#xe615;</i>线路优化</button>
        </div>

        <div class="layui-input-inline">
            <button  class="layui-btn layui-btn-fluid" type="button" @click=""><i class="layui-icon">&#xe615;</i>优化前后对比</button>
            <!--直接跳转到一个展示页面进行对比？  -->
        </div>
	</div>

<%--    删除线路弹出框div--%>
    <div id="deleteLine" title="删除线路" style="">
        <div style="width:500px;height: 40px;">
            <h3>删除线路</h3>
            <form>
<%--                <label class="col-sm-2 control-label">删除线路名 </label>--%>
                <div class="col-sm-4">
                    <select name="deleteID" id="deleteID" class="text input-large form-control">
                        <option value="">请选择要删除公交线路名</option>
                    </select>
                    <p><input type="button" value="查看该线路及站点" onclick="queryLineByID()"></p>
                    <p><input type="button" value="删除该线路" onclick="deleteLineByID()"></p>
                    <p><input type="button" value="返回" onclick="deleteBack()">
                </div>
            </form>
        </div>
    </div>


<%--    新建线路所有弹出框div--%>
    <div id="dealAddLineDiv">
        <%--        新建线路弹出框的div--%>
        <div id="addLine" title="新建线路"  style="" >
            <div style="width:500px;height: 40px;">
                <h3>新建线路</h3>
                <form>
                    <p>新建的线路名：</p>
                    <p><input type="text" id="newLineName" /></p>
<%--                    点击后直接显示线路添加界面--%>
                    <p><input type="button" value="开始" onclick="startNew()">
<%--                        返回主页面--%>
                        <input type="button" value="返回" onclick="addLineBack()"></p>
                    <label class="col-sm-2 control-label">在建线路 </label>
                    <div class="col-sm-4">
                        <select name="continueAddLineName" id="continueAddLineName" class="text input-large form-control">
                            <option value="">请选择在建的公交线路</option>
                        </select>
<%--                        显示线路添加界面及已添加的线路和站点信息显示--%>
                        <p><input type="button" value="继续" onclick="continueNew()"></p>

                    </div>
                </form>
            </div>
        </div>

<%--    新建线路-开始弹出框--%>
        <div id="startNew" title="开始新建线路"  style="" >
            <div style="width:500px;height: 40px;">
                <h3>添加站点或拐点至线路</h3>
                <form>
                    <p><input type="button" value="添加站点至线路" onclick="addStop()">
                    <p><input type="button" value="添加拐点至线路" onclick="addCoord()">
                        <%--                        返回新建线路主页面--%>
                    <input type="button" value="返回" onclick="addBack()"></p>
                </form>
            </div>
        </div>

        <%--    新建线路-继续弹出框--%>
        <div id="continueNew" title="继续新建线路"  style="" >
            <div style="width:500px;height: 40px;">
                <h3>继续添加站点或拐点</h3>
                <form>
                    <p><input type="button" value="添加站点至线路" onclick="continueLineByID()">
                    <p><input type="button" value="添加拐点至线路" onclick="continueAddCoord()">
<%--                    参考addCoord--%>
                        <%--                        返回新建线路主页面--%>
                        <input type="button" value="返回" onclick="addBack()"></p>
                </form>
            </div>
        </div>

    <%--        新建线路-开始-添加站点的弹出框div--%>
        <div id="addStop" title="添加站点"  style="" >
            <div style="width:500px;height: 40px;">
                <h3>添加站点</h3>
                <form>
                    <input type="checkbox" name="old" id="old"/>原有站点
                    <input type="checkbox" name="new" id="new"/>新站点
                    <p>站点名：</p>
                    <p><input type="text" id="addStationName" /></p>
                    <p>经纬度(原有可不填)：x,y</p>
                    <p><input type="text" id="addStationLocation"></p>
                    <p>站点顺序:</p>
                    <p><input type="text" id="sequence"></p>
<%--                    根据checkbox的值选择添加原有站点还是新站点，返回新建视图，显示目前已添加的站点组成的线路，status为2，在建--%>
                    <p><input type="button"  value="保存为在建" onclick="saveForContinue()"></p>
<%--                    根据checkbox的值选择添加原有站点还是新站点，返回添加站点的视图，保存添加的站点，刷新目前已添加的站点组成的线路--%>
                    <p><input type="button"  value="保存并继续添加站点" onclick="saveAndContinue()"></p>
<%--                    根据checkbox的值选择添加原有站点还是新站点，返回新建视图，显示已添加完毕的站点组成的线路，status为3，新建完成--%>
                    <p><input type="button" value="保存并继续添加拐点" onclick="saveAndAddCoord()"></p>
                    <p><input type="button"  value="完成" onclick="saveAndEnd()"></p>
                </form>
            </div>
        </div>

        <%--        新建线路-开始-添加拐点至线路 的弹出框div--%>
        <div id="addCoord" title="添加拐点至线路"  style="" >
            <div style="width:500px;height: 40px;">
                <h3>添加拐点至线路</h3>
                <form>
                    <p>拐点经纬度：x,y</p>
                    <p><input type="text" id="addCoordLoc"></p>
                    <p>添加至站点顺序为 后</p>
                    <p><input type="text" id="stopSequence"></p>
<%--                    保存拐点至线路，跳转至开始添加页面，线路展示--%>
                    <p><input type="button"  value="保存该拐点" onclick="saveCoord()"></p>
                    <p><input type="button"  value="返回" onclick="startNew()"></p>
                </form>
            </div>
        </div>

        <%--        新建线路-继续-添加拐点至线路 的弹出框div--%>
        <div id="continueAddCoord" title="添加拐点至线路"  style="" >
            <div style="width:500px;height: 40px;">
                <h3>添加拐点至线路</h3>
                <form>
                    <p>拐点经纬度：x,y</p>
                    <p><input type="text" id="continueAddCoordLoc"></p>
                    <p>添加至站点顺序为 后</p>
                    <p><input type="text" id="continueStopSequence"></p>
                    <%--                    保存拐点至线路，跳转至继续添加页面，线路展示，参考saveCoord()--%>
                    <p><input type="button"  value="保存该拐点" onclick="continueSaveCoord()"></p>
                    <p><input type="button"  value="返回" onclick="continueNew()"></p>
                </form>
            </div>
        </div>



    </div>




<%--    修改线路所有弹出框div--%>
    <div id = "correctLineDiv">
        <%--        修改线路弹出框的div--%>
        <div id="correctLine" title="修改线路"  style="" >
            <div style="width:500px;height: 40px;">
                <h3>修改线路</h3>
                <form>
                    <label class="col-sm-2 control-label">现有及新建完毕线路</label>
                    <div class="col-sm-4">
                        <select name="correctLineID" id="correctLineID" class="text input-large form-control">
                            <option value="">请选择需要修改的公交线路</option>
                        </select>
                        <p><input type="button" value="查看该线路走向及站点和拐点" onclick="getLineByID()"></p>
                    </div>
                    <p><input type="button" value="开始修改" onclick="startCorrect()"></p>
                    <p><input type="button" value="返回" onclick="correctLineBack()"></p>
                </form>
            </div>
        </div>

<%--            修改线路-开始修改的弹出框div--%>
            <div id="startCorrect" title="修改线路" style="">
                <div style="width:500px;height: 40px;">
                    <h3>修改站点</h3>
                    <form>
                        <p>添加或替换站点时请选择！！</p>
                        <input type="checkbox" name="oldStop" id="oldStop"/>原有站点
                        <input type="checkbox" name="newStop" id="newStop"/>新站点
                        <p>站点名（必填）：</p>
                        <p><input type="text" id="correctStationName" /></p>
                        <p>经纬度(新站点需填)：x,y</p>
                        <p><input type="text" id="correctStationLocation"></p>
                        <p>站点顺序（必填）:</p>
                        <p><input type="text" id="correctSequence"></p>
                        <%--    根据给到的站点名以及站点顺序，删除该线路的中的该站点 更改line的coord、stops以及station中的buslines  地图展示删除该站点后的线路图 页面跳转到开始修改后的页面--%>
                        <p><input type="button"  value="删除该站点" onclick="deleteStation()"></p>
                        <%--    根据checkbox的值区分新站点/老站点 新站点需要名字、loc、顺序 老站点需要名字、顺序， 把原先该顺序的站点往后顺延，更改line的coord、stops以及stationd的buslines 地图展示添加站点后的线路图 页面跳转到开始修改后的页面--%>
                        <p><input type="button"  value="添加该站点至线路" onclick="addStationToLine()"></p>
                        <%--    根据checkbox的值选择添加原有站点还是新站点，用新老站点替换原顺序站点，更改line的coord、stops以及station中的buslines 地图展示效果 页面跳转到开始修改后的页面--%>
                        <p><input type="button"  value="替换原顺序站点" onclick="replaceStation()"></p>
                        <%--   返回修改线路的初始页面--%>
                        <p><input type="button" value="返回" onclick="backToCorrectMore()"></p>
                    </form>
                </div>
            </div>

    </div>



<%--    控制右侧地图--%>
	<script>
        document.oncontextmenu = function(){
            return false;
        }
		var normalm = L.tileLayer.chinaProvider('GaoDe.Normal.Map', {
			maxZoom: 18,
			minZoom: 5
		});
		var imgm = L.tileLayer.chinaProvider('GaoDe.Satellite.Map', {
			maxZoom: 18,
			minZoom: 5
		});
		var imga = L.tileLayer.chinaProvider('GaoDe.Satellite.Annotion', {
			maxZoom: 18,
			minZoom: 5
		});
		var normal = L.layerGroup([normalm]) ,
            queryLineMap=L.layerGroup([normalm]),
            stationCoverageMap=L.layerGroup([normalm]),
            stationMap=L.layerGroup([normalm]),
        neighbourCoverageMap = L.layerGroup([normalm]),
            underConstructionMap = L.layerGroup([normalm]),
            correctLineMap = L.layerGroup([normalm]),
        image = L.layerGroup([imgm, imga]);

		var baseLayers = {
			"有效线路展示": normal, //上面放置了所有有效的线路图展示
            "线路查询层":queryLineMap,
			"站点覆盖率展示":stationCoverageMap,
            "站点信息层":stationMap,
            "居民区站点覆盖率展示层":neighbourCoverageMap,
            "在建线路展示层":underConstructionMap,
            "修改线路展示层":correctLineMap,
			"影像": image
		}
		var map = L.map("map", {
			//center: [31.39, 121.26],
			center: [31.283503,121.312477],
			zoom: 12,
			layers: [normal],
			zoomControl: false
		});
		L.control.layers(baseLayers, null).addTo(map);
		L.control.zoom({
			zoomInTitle: '放大',
			zoomOutTitle: '缩小'
		}).addTo(map);
        L.control.scale().addTo(map);  //比例尺
		L.control.attribution({ position: 'bottomleft', prefix: 'myMap' }).addTo(map); //添加地图名
		map.on('click', showMapPosition);    //点击地图
		//map.on('dblclick',addPoint);             //双击地图
		//map.off('click', showMapPosition); //关闭该事件
		function showMapPosition(e)
		{
			alert(e.latlng);
		}

		function addPoint(e)
		{
			var marker = L.marker([e.latlng.lat, e.latlng.lng]).addTo(map);
		}


		//所有有效线路的显示风格
		var myStyle = {
			"color": "#ff0000",
			"weight": 3,
			"opacity": 0.15
		};
        var styleClick = {
            "color": "#ff0000",
            "weight": 17,
            "opacity": 0.85
        };
		//展示所有有效线路在 normal图层（有效线路展示层）
        <%
            for(Line line:linesResult){
        %>
            var myLines = eval(<%=line.getCoordinates()%>);
            var myLayer = L.geoJSON().addTo(normal);
            myLayer.addData(myLines);
            var lines = L.geoJSON(myLines, {
                style: myStyle
            }).addTo(normal);
            lines.bindPopup("<%=line.getLineName()%>");
            //lines.bindPopup(<html><input type="submit" value="线路删除">)
        <% }
        %>
        var len = $("path.leaflet-interactive").length
        console.log("length = " ,len)
        document.oncontextmenu = function(){
            return false;
        }
        //右键某条线路，该线路会变红（还存在如何取消变红效果）
        for(var i=0;i<len;i++)
        {
            var xx = $("path.leaflet-interactive")[i]
            xx.onmousedown = function(e){
                if (e.button == 2 ){
                    console.log(xx)
                    this.setAttribute("stroke-opacity",1)
                    this.setAttribute("stroke-width",5)
                    console.log(this)
                }
            }
        }


		//首页公交线路查询-实现输入线路名称展示在线路展示层的异步查询，用两个颜色表示一条线路的a-b和b-a
		function queryLine() {
            var layers=[];
			var $queryLineName = $("#queryLineName").val();
			$.ajax({
				url:"LineQueryServlet",
				data:"queryLineName="+$queryLineName,
				dataType:"json",
				success:function (result,testStatus) {
					if((result!=null) && (result!="false")){
						var arrayData =eval(result);
						var style1 = {//查询线路展示的风格
							"color": "#FF00FF",
							"weight": 3,
							"opacity": 0.9
						};
                        var style2 = {//查询线路展示的风格
                            "color": "#4876FF",
                            "weight": 3,
                            "opacity": 0.9
                        };

						var queryLayer = L.geoJSON().addTo(queryLineMap);
						// var testline = {"coordinates":[[121.321175,31.238354],[121.32116,31.238213],[121.320656,31.238203],[121.31767,31.23825],[121.31712,31.238264],[121.31702,31.238268],[121.315155,31.23832],[121.315125,31.23829]],"type": "LineString"};
						for(var i=0;i<arrayData.length;i++) {
							console.log(arrayData[i])
							queryLayer.addData([arrayData[i]]);
							if(i%2==0) {
                               var line = L.geoJSON([arrayData[i]], {
                                    style: style1
                                }).addTo(queryLineMap);
                                //line.bindPopup("线路名称")

                            }else{
                                L.geoJSON([arrayData[i]], {
                                        style: style2
                                    }).addTo(queryLineMap);
                            }
							//使其直接跳转到线路查询层
                            $("div.leaflet-control-layers-base").children().eq(1).children().eq(0).children().eq(0).click()
						}
					}
					else{
						alert("该线路不存在，请重新输入！！")
					}
				},
				error:function(xhr,errorMessage,e){
					alert("系统异常！！")
				}
			})
		}

        //线路站点显示 首页
        function queryLineOfStops() {
            var $queryLineName = $("#queryLineName").val();
            $.ajax({
                url:"LineQueryLikeNameStopsListServlet",
                data:"queryLineName="+$queryLineName,
                dataType:"json",
                success:function (data) {
                    console.log(data)
                    var stopsList = data;
                    console.log(stopsList);
                    var num = stopsList.length;//有几条公交就有多少
                    console.log(num)
                    for(var i=0;i<num;i++)
                    {
                        var stops= eval(stopsList[i])
                        console.log(stops)
                        var len = stops.length;
                        console.log(len)
                        for(var j=0;j<len;j++) {
                            var stopLocation = stops[j].location;
                            //console.log("stopLoction：" + stopLocation)
                            //arraydate[i].location alert的格式为array(2) stopLocation alert的格式为 x,y！！故需通过eval()进行转换
                            var stationId = stops[j].id
                            var stationName = stops[j].name
                            var stationLoc = stops[j].location
                            var stationSequence = stops[j].sequence
                            var marker = L.marker(stopLocation)
                                .addTo(queryLineMap)
                                .bindPopup(stationId + " " + stationName + " 站点经纬度:" + stationLoc + " 站点顺序：" + stationSequence)
                                .openPopup();
                            //console.log(stationName)
                        }
                    }
                    //跳转至线路查询层
                    $("div.leaflet-control-layers-base").children().eq(1).children().eq(0).children().eq(0).click()
                },
                error:function(xhr,errorMessage,e){
                    alert("系统异常！！")
                }
            })
        }

        //站点覆盖率查询 按钮的实现
		function stopCoverage() {
			$.ajax({
				url:"StationServlet",
				dataType:"json",
				success:function (data) {
					//alert(data)
					var arraydata = eval(data);
					//alert(arraydata);
					var i;
					var len = arraydata.length;
					for(i=0;i<len;i++)
					{
						var stopLocation = eval(arraydata[i].location);
						//arraydate[i] alert的格式为[x,y] stopLocation alert的格式为 x,y！！故需通过eval()进行转换
						L.circle(stopLocation, {
							color: '#D1EEEE',
							weight: 0,
							fillColor: '#9932CC',
							radius: 1500,
							fillOpacity: 0.1
						}).addTo(stationCoverageMap)
					}
					//跳转至站点覆盖层
                    $("div.leaflet-control-layers-base").children().eq(2).children().eq(0).children().eq(0).click()
				},
				error:function(xhr,errorMessage,e){
					alert("系统异常！！")
				}
			})
		}

		//站点显示 按钮的实现
        function stopShow() {
            $.ajax({
                url:"StationServlet",
                dataType:"json",
                success:function (data) {
                    var arraydata = eval(data);
                    var len = arraydata.length;
                    for(var i=0;i<len;i++)
                    {
                        var stopLocation = eval(arraydata[i].location);
                        //将所有有效站点展示在有效线路层
                        var stationName=arraydata[i].stationName
                        var stationLoc=arraydata[i].location
                        var marker = L.marker(stopLocation)
                            .addTo(stationMap)
                            .bindPopup(stationName+" "+stationLoc)
                            .openPopup();
                        console.log(stationName)
                    }
                    //跳转至站点信息层
                    $("div.leaflet-control-layers-base").children().eq(3).children().eq(0).children().eq(0).click()
                },
                error:function(xhr,errorMessage,e){
                    alert("系统异常！！")
                }
            })
        }

		//查询x米内居民区附近拥有的站点数量覆盖率图
        function neighbourCoverageQuery() {
            var $measure = $("#measure").val();
            $.ajax({
                url:"NeighbourCoverageServlet",
                data:"measure="+$measure,
                dataType:"json",
                success:function (data) {
                    var obj = eval(data);
                    var len = obj.length;
                    var layers=[];
                    layers.length=0;
                    for(var i=0;i<len;i++)
                    {
                        var neighbourLoc = obj[i].location;
                        //console.log(neighbourLoc)  //"31.2131321,121.2112123"字符串形式
                        neighbourLoc = "[" + neighbourLoc + "]";
                        var loc = eval(neighbourLoc);
                        //console.log("loc:"+loc)
                        if(obj[i].number==0){
                            L.circle(loc, {
                                color: '#D1EEEE',
                                weight: 0,
                                fillColor: '#FF3030',
                                radius: $measure,
                                fillOpacity: 0.08
                            }).addTo(neighbourCoverageMap)
                        }
                        else if(obj[i].number<=2){
                            L.circle(loc, {
                                color: '#D1EEEE',
                                weight: 0,
                                fillColor: '#FF3030',
                                radius: $measure,
                                fillOpacity: 0.1
                            }).addTo(neighbourCoverageMap)
                        }else if(obj[i].number>=3 && obj[i].number<=5){
                            L.circle(loc, {
                                color: '#D1EEEE',
                                weight: 0,
                                fillColor: '#FF3030',
                                radius: $measure,
                                fillOpacity: 0.15
                            }).addTo(neighbourCoverageMap)
                        }else if(obj[i].number>5){
                            L.circle(loc, {
                                color: '#D1EEEE',
                                weight: 0,
                                fillColor: '#FF3030',
                                radius: $measure,
                                fillOpacity: 0.2
                            }).addTo(neighbourCoverageMap)
                        }
                    }
                    //跳转至居民区覆盖率层
                    $("div.leaflet-control-layers-base").children().eq(4).children().eq(0).children().eq(0).click()
                    //alert("【绿色及蓝色】表示站点数小于等于两个！！【红色及橙色】表示站点数大于等于三个！！")
                },
                error:function(xhr,errorMessage,e){
                    alert("系统异常！！")
                }
            })
        }

	</script>

<%--    控制新建线路弹出框等--%>
    <script type="text/javascript">
        var global_add_line;
        var global_add_markers = [];
        //添加线路
        function newLine() {
            document.getElementById('addLine').style.display='block';
            document.getElementById('startNew').style.display='none';
            document.getElementById('form').style.display='none';
        }

        //添加线路 返回
        function addLineBack() {
            document.getElementById('startNew').style.display='none';
            document.getElementById('addLine').style.display='none';
            document.getElementById('form').style.display='block';
        }

        //添加线路-开始-返回
        function addBack() {
            document.getElementById('startNew').style.display='none';
            document.getElementById('addLine').style.display='block';
            document.getElementById('form').style.display='none';
            document.getElementById('continueNew').style.display='none';
        }

        //添加线路 开始
        function startNew() {
            document.getElementById('startNew').style.display='block';
            document.getElementById('addLine').style.display='none';
            document.getElementById('form').style.display='none';
            document.getElementById('continueNew').style.display='none';
            document.getElementById('addCoord').style.display='none';
            document.getElementById('continueAddCoord').style.display='none';
        }

        //添加线路 继续
        function continueNew() {
            document.getElementById('continueNew').style.display='block';
            document.getElementById('addLine').style.display='none';
            document.getElementById('form').style.display='none';
            document.getElementById('startNew').style.display='none';
            document.getElementById('addCoord').style.display='none';
            document.getElementById('continueAddCoord').style.display='none';
        }

        //添加线路-开始-添加拐点至线路
        function addCoord() {
            document.getElementById('addCoord').style.display='block';
            document.getElementById('continueAddCoord').style.display='none';
            document.getElementById('continueNew').style.display='none';
            document.getElementById('addLine').style.display='none';
            document.getElementById('form').style.display='none';
            document.getElementById('startNew').style.display='none';
        }

        //添加线路 继续 添加拐点至线路
        function continueAddCoord() {
            var $continueAddLineName=$('#continueAddLineName').val();
            document.getElementById('addCoord').style.display='none';
            document.getElementById('continueAddCoord').style.display='block';
            document.getElementById('continueNew').style.display='none';
            document.getElementById('addLine').style.display='none';
            document.getElementById('form').style.display='none';
            document.getElementById('startNew').style.display='none';
            //根据在建列表的选择，显示正在建设中的线路
            $.ajax({
                url:"LineQueryByNameServlet",
                data:"lineName="+$continueAddLineName,
                dataType:"json",
                success:function (result,testStatus) {
                    var lineData = eval(result) ;//Object形式
                    console.log(lineData)
                    var line = JSON.parse(lineData.coordinates) //字符串转对象
                    console.log(line)
                    var style = {//查询线路展示的风格
                        "color": "#ff0000",
                        "weight": 2,
                        "opacity": 0.55
                    };
                    if(global_add_line!=null){
                        underConstructionMap.removeLayer(global_add_line);
                    }
                    global_add_line = L.geoJSON([line], {
                        style: style
                    }).addTo(underConstructionMap);

                    //显示站点
                    var stops= JSON.parse(lineData.stops);
                    var len = stops.length;
                    if(global_add_markers.length > 0){
                        for(var i = 0;i < global_add_markers.length; i++ ){
                            underConstructionMap.removeLayer(global_add_markers[i]);
                        }
                        global_add_markers = [];
                    }
                    for(var j=0;j<len;j++) {
                        var stopLocation = stops[j].location;
                        var stationId = stops[j].id;
                        var stationName = stops[j].name;
                        var stationLoc = stops[j].location;
                        var stationSequence = stops[j].sequence;
                        global_add_markers[j] = L.marker(stopLocation)
                            .addTo(underConstructionMap)
                            .bindPopup(stationId + " " + stationName + " 站点经纬度:" + stationLoc + " 站点顺序：" + stationSequence)
                            .openPopup();
                    }
                    //跳转至在建线路展示层
                    $("div.leaflet-control-layers-base").children().eq(5).children().eq(0).children().eq(0).click()
                },
                error:function(xhr,errorMessage,e){
                    alert("系统异常！！")
                }
            })
        }

        //添加线路-开始 添加站点 展示所有有效站点+对输入的车站名进行保存，新增数据库
        function addStop(){
            var $newLineName = $("#newLineName").val();
            $.ajax({
                url:"AddStopStartServlet",
                data:"newLineName="+$newLineName,
                dataType:"json",
                success:function (data) {
                   // console.log(data)
                    if(data=="0"){
                        alert("新增线路失败！！")
                    }else if(data=="2"){
                        alert("该线路名已经存在！！请在在建列表中查看或是修改线路名")
                    }else {
                        alert("开始新建该线路！！")
                        document.getElementById('addStop').style.display='block';
                        document.getElementById('addLine').style.display='none';
                        document.getElementById('startNew').style.display='none';
                        document.getElementById('form').style.display='none';
                        var arraydata = eval(data);
                        var len = arraydata.length;
                        for (var i = 0; i < len; i++) {
                            var stopLocation = eval(arraydata[i].location);
                            //将所有有效站点展示在有效线路层
                            var stationName = arraydata[i].stationName
                            var stationLoc = arraydata[i].location
                            var marker = L.marker(stopLocation)
                                .addTo(stationMap)
                                .bindPopup(stationName + " " + stationLoc)
                                .openPopup();
                            //console.log(stationName)
                        }
                        //跳转至站点信息层
                        $("div.leaflet-control-layers-base").children().eq(3).children().eq(0).children().eq(0).click()
                    }
                },
                error:function(xhr,errorMessage,e){
                    alert("系统异常！！")
                }
            })
        }

        //添加线路-开始-添加拐点至线路-保存该拐点 XXX
        function saveCoord(){
            var $newLineName = $("#newLineName").val();
            var $addCoordLoc = $("#addCoordLoc").val(); //x,y
            var $stopSequence = $("#stopSequence").val(); //拐点添加至该站点之后
            var obj = JSON.stringify({
                'lineName':$newLineName,
                'loc': $addCoordLoc,
                'sequence': $stopSequence
            });
            console.log(obj);
            $.ajax({
                url:"AddCoordServlet",
                data:"obj="+ obj,
                dataType:"json",
                success:function (data) {
                    // console.log(data)
                    if(data=="0"){
                        alert("新增线路失败！！")
                    }else if(data=="2"){
                        alert("该线路名已经存在！！请在在建列表中查看或是修改线路名")
                    }else {
                        alert("开始新建该线路！！")
                        document.getElementById('addStop').style.display='block';
                        document.getElementById('addLine').style.display='none';
                        document.getElementById('startNew').style.display='none';
                        document.getElementById('form').style.display='none';
                        var arraydata = eval(data);
                        var len = arraydata.length;
                        for (var i = 0; i < len; i++) {
                            var stopLocation = eval(arraydata[i].location);
                            //将所有有效站点展示在有效线路层
                            var stationName = arraydata[i].stationName
                            var stationLoc = arraydata[i].location
                            var marker = L.marker(stopLocation)
                                .addTo(stationMap)
                                .bindPopup(stationName + " " + stationLoc)
                                .openPopup();
                            //console.log(stationName)
                        }
                        //跳转至在建线路展示层
                        $("div.leaflet-control-layers-base").children().eq(5).children().eq(0).children().eq(0).click()
                    }
                },
                error:function(xhr,errorMessage,e){
                    alert("系统异常！！")
                }
            })
        }


        //添加线路-继续-添加拐点至线路-保存该拐点
        function continueSaveCoord(){
            var $continueAddLineName = $('#continueAddLineName').val(); //在建线路名
            var $addCoordLoc = $('#continueAddCoordLoc').val();//x,y
            var $stopSequence = $('#continueStopSequence').val();//拐点添加至该站点之后
            var obj = JSON.stringify({
                'lineName':$continueAddLineName,
                'loc': $addCoordLoc,
                'sequence': $stopSequence
            });
            console.log(obj);
            $.ajax({
                url:"AddCoordServlet",
                data:"obj="+ obj,
                type: "post",
                dataType:"json",
                success:function (result,testStatus) {
                    var lineData = eval(result) ;//Object形式
                    var line = JSON.parse(lineData.coordinates) //字符串转对象
                    var style = {//查询线路展示的风格
                        "color": "#ff0000",
                        "weight": 2,
                        "opacity": 0.55
                    };
                    if(global_add_line!=null){//清空之前图层中所有的线路
                        underConstructionMap.removeLayer(global_add_line)
                    }
                    global_add_line = L.geoJSON([line], { style: style}).addTo(underConstructionMap);

                    //显示站点
                    var stops= JSON.parse(lineData.stops)
                    var len = stops.length;
                    if(global_add_markers.length>0){
                        for(var i = 0;i<global_add_markers.length;i++){
                            underConstructionMap.removeLayer(global_add_markers[i]);
                        }
                        global_add_markers = [];
                    }
                    for(var j=0;j<len;j++) {
                        var stopLocation = stops[j].location;
                        var stationId = stops[j].id
                        var stationName = stops[j].name
                        var stationLoc = stops[j].location
                        var stationSequence = stops[j].sequence
                        global_add_markers[j] = L.marker(stopLocation)
                            .addTo(underConstructionMap)
                            .bindPopup(stationId + " " + stationName + " 站点经纬度:" + stationLoc + " 站点顺序：" + stationSequence)
                            .openPopup();
                    }
                    continueNew();
                    alert("拐点已添加至线路")
                    //跳转至在建线路展示层
                    $("div.leaflet-control-layers-base").children().eq(5).children().eq(0).children().eq(0).click()
                },
                error:function(xhr,errorMessage,e){
                    alert("系统异常！！")
                }
            })

        }


        //下拉在建中的线路列表
        $(function() {
            $.ajax({
                type: 'post',
                url: "QueryUnderConstructLineServlet",
                dataType: "json",
                //data: {pid: 0},
                success: function (data) {
                    // console.log(data);
                    $("#continueAddLineName").empty();
                    $("#continueAddLineName").append("<option value=''>请选择在建的公交线路</option>");
                    for (var i = 0; i < data.length; i++) {
                        $("#continueAddLineName").append('<option value=' + data[i].lineName + '>' + data[i].lineName + '</option>');
                    }
                }
            });
        })

        //添加线路-保存为在建  根据checkBox保存线路的站点 展示刚才保存的站点线路图在地图上 status=2
        function saveForContinue() {
            console.log("保存为在建"+ global_add_line)
            document.getElementById('addLine').style.display='block';
            document.getElementById('addStop').style.display='none';
            document.getElementById('form').style.display='none';
            document.getElementById('startNew').style.display='none';
            // 选中返回true，未选中返回false
            var $continueAddLineName=$('#continueAddLineName').val();
            var $newLineName=$("#newLineName").val();
            var $lineName = null;
            if($continueAddLineName==""){
                $lineName = $newLineName
            }else if($newLineName==""){
                $lineName = $continueAddLineName
            }
            var oldChecked = $('#old').is(":checked");
            var newChecked = $('#new').is(":checked");
            var $addStationName = $("#addStationName").val();
            var $addStationLocation = $("#addStationLocation").val();
            var $sequence = $("#sequence").val();
            if(oldChecked && (!newChecked)) {
                var obj = JSON.stringify({
                    'type':"oldStop",
                    'lineName':$lineName,
                    'name': $addStationName,
                    'loc': $addStationLocation ,
                    'sequence': $sequence
                });
                //将原有站点的信息添加到线路的coord列、stops列，并将目前该线路的线路图展现在在建线路展示层中
                $.ajax({
                    url: "AddOldStopToLineServlet",
                    type: "post",
                    data: "obj="+ obj,
                    dataType: "json",
                    success:function (result,testStatus) {
                        var lineData = eval(result) ;//Object形式
                        var line = JSON.parse(lineData.coordinates) //字符串转对象
                        var style = {//查询线路展示的风格
                            "color": "#ff0000",
                            "weight": 2,
                            "opacity": 0.55
                        };
                        if(global_add_line!=null){//清空之前图层中所有的线路
                            underConstructionMap.removeLayer(global_add_line)
                        }
                        global_add_line = L.geoJSON([line], {
                            style: style
                        }).addTo(underConstructionMap);

                        //显示站点
                        var stops= JSON.parse(lineData.stops)
                        var len = stops.length;
                        if(global_add_markers.length>0){
                            for(var i = 0;i<global_add_markers.length;i++){
                                underConstructionMap.removeLayer(global_add_markers[i]);
                            }
                            global_add_markers = [];
                        }
                        for(var j=0;j<len;j++) {
                            var stopLocation = stops[j].location;
                            var stationId = stops[j].id
                            var stationName = stops[j].name
                            var stationLoc = stops[j].location
                            var stationSequence = stops[j].sequence
                            global_add_markers[j] = L.marker(stopLocation)
                                .addTo(underConstructionMap)
                                .bindPopup(stationId + " " + stationName + " 站点经纬度:" + stationLoc + " 站点顺序：" + stationSequence)
                                .openPopup();
                        }
                        newLine();
                        alert("原有站点添加成功！线路已保存为在建状态")
                        //跳转至在建线路展示层
                        $("div.leaflet-control-layers-base").children().eq(5).children().eq(0).children().eq(0).click()
                    },
                    error:function(xhr,errorMessage,e){
                        alert("系统异常！！")
                    }
                })
            }else if(newChecked && (!oldChecked)){
                var obj = JSON.stringify({
                    'type':"newStop",
                    'lineName':$lineName,
                    'name': $addStationName,
                    'loc': $addStationLocation ,
                    'sequence': $sequence
                });
                console.log(newChecked)
                console.log(obj)
                //将新建的站点信息保存至station表，同时将新建的站点的信息添加到线路的coord列、stops列，并将目前该线路的线路图展现在在建线路展示层中
                $.ajax({
                    url: "AddNewStopToLineServlet",
                    type: "post",
                    data: "obj="+ obj,
                    dataType: "json",
                    success:function (result,testStatus) {
                        var lineData = eval(result) ;//Object形式
                        //console.log(lineData)
                        var line = JSON.parse(lineData.coordinates) //字符串转对象
                        //console.log(line)
                        var style = {//查询线路展示的风格
                            "color": "#ff0000",
                            "weight": 2,
                            "opacity": 0.55
                        };
                        if(global_add_line!=null){
                            underConstructionMap.removeLayer(global_add_line)
                        }
                        global_add_line = L.geoJSON([line], {
                            style: style
                        }).addTo(underConstructionMap);

                        //显示站点
                        var stops= JSON.parse(lineData.stops)
                        var len = stops.length;
                        if(global_add_markers.length>0){
                            for(var i=0; i<global_add_markers.length;i++){
                                underConstructionMap.removeLayer(global_add_markers[i])
                            }
                            global_add_markers =[];
                        }
                        for(var j=0;j<len;j++) {
                            var stopLocation = stops[j].location;
                            var stationId = stops[j].id
                            var stationName = stops[j].name
                            var stationLoc = stops[j].location
                            var stationSequence = stops[j].sequence
                            global_add_markers[j] = L.marker(stopLocation)
                                .addTo(underConstructionMap)
                                .bindPopup(stationId + " " + stationName + " 站点经纬度:" + stationLoc + " 站点顺序：" + stationSequence)
                                .openPopup();
                            //console.log(stationName)
                        }
                        alert("新站点添加成功！线路已经保存为在建状态")
                        //跳转至在建线路展示层
                        $("div.leaflet-control-layers-base").children().eq(5).children().eq(0).children().eq(0).click()
                    },
                    error:function(xhr,errorMessage,e){
                        alert("系统异常！！")
                    }
                })
            }else{
                alert("请选择添加的站点是原有站点还是新站点！！")
                document.getElementById('addStop').style.display='block';
                document.getElementById('addLine').style.display='none';
                document.getElementById('startNew').style.display='none';
                document.getElementById('form').style.display='none';
            }
        }


        //添加线路-保存并继续 根据checkBox保存线路的站点 展示刚才保存的站点到线路 页面保持继续添加站点
        function saveAndContinue() {
            document.getElementById('addStop').style.display='block';
            document.getElementById('addLine').style.display='none';
            document.getElementById('form').style.display='none';

            var $continueAddLineName=$('#continueAddLineName').val();
            console.log($continueAddLineName=="")
            var $newLineName=$("#newLineName").val();
            console.log($newLineName=="")
            var $lineName = null;
            if($continueAddLineName==""){
                $lineName = $newLineName
            }else if($newLineName==""){
                $lineName = $continueAddLineName
            }
            var oldChecked = $('#old').is(":checked");
            var newChecked = $('#new').is(":checked");
            var $addStationName = $("#addStationName").val();
            var $addStationLocation = $("#addStationLocation").val();
            var $sequence = $("#sequence").val();

            if(oldChecked && (!newChecked)) { //如果选择的是原有站点
                var obj = JSON.stringify({
                    'type':"oldStop",
                    'lineName':$lineName,
                    'name': $addStationName,
                    'loc': $addStationLocation ,
                    'sequence': $sequence
                });
                console.log(oldChecked)
                console.log(obj)
                //将原有站点的信息添加到线路的coord列、stops列，并将目前该线路的线路图展现在在建线路展示层中
                $.ajax({
                    url: "AddOldStopToLineServlet",
                    type: "post",
                    data: "obj="+ obj,
                    dataType: "json",
                    success:function (result,testStatus) {
                        var lineData = eval(result) ;//Object形式
                        console.log(lineData)
                        var line = JSON.parse(lineData.coordinates) //字符串转对象
                        console.log(line)
                        var style = {//查询线路展示的风格
                            "color": "#ff0000",
                            "weight": 2,
                            "opacity": 0.55
                        };
                        var queryLayer = L.geoJSON().addTo(underConstructionMap);
                        queryLayer.addData([line]);
                        if(global_add_line!=null){//清空之前图层的线路
                            underConstructionMap.removeLayer(global_add_line);
                        }
                        global_add_line = L.geoJSON([line], {
                            style: style
                        }).addTo(underConstructionMap);

                        //显示站点
                        var stops= JSON.parse(lineData.stops)
                        //console.log(stops)
                        if(global_add_markers.length>0){ //清空之前图层中留下的站点
                            for(var i = 0;i<global_add_markers.length;i++){
                                underConstructionMap.removeLayer(global_add_markers[i]);
                            }
                            global_add_markers = [];
                        }
                        var len = stops.length;
                        console.log(len)
                        for(var j=0;j<len;j++) {
                            var stopLocation = stops[j].location;
                            var stationId = stops[j].id
                            var stationName = stops[j].name
                            var stationLoc = stops[j].location
                            var stationSequence = stops[j].sequence
                            global_add_markers[j] = L.marker(stopLocation)
                                .addTo(underConstructionMap)
                                .bindPopup(stationId + " " + stationName + " 站点经纬度:" + stationLoc + " 站点顺序：" + stationSequence)
                                .openPopup();
                            //console.log(stationName)
                        }
                        alert("原有站点添加成功！请继续添加站点")
                        //跳转至在建线路展示层
                        $("div.leaflet-control-layers-base").children().eq(5).children().eq(0).children().eq(0).click()
                    },
                    error:function(xhr,errorMessage,e){
                        alert("系统异常！！")
                    }
                })
            }else if(newChecked && (!oldChecked)){
                var obj = JSON.stringify({
                    'type':"newStop",
                    'lineName':$lineName,
                    'name': $addStationName,
                    'loc': $addStationLocation ,
                    'sequence': $sequence
                });
                console.log(newChecked)
                console.log(obj)
                //将新建的站点信息保存至station表，同时将新建的站点的信息添加到线路的coord列、stops列，并将目前该线路的线路图展现在在建线路展示层中
                $.ajax({
                    url: "AddNewStopToLineServlet",
                    type: "post",
                    data: "obj="+ obj,
                    dataType: "json",
                    success:function (result,testStatus) {
                        var lineData = eval(result) ;//Object形式
                        console.log(lineData)
                        var line = JSON.parse(lineData.coordinates) //字符串转对象
                        console.log(line)
                        var style = {//查询线路展示的风格
                            "color": "#ff0000",
                            "weight": 2,
                            "opacity": 0.55
                        };
                        if(global_add_line!=null){//清空之前图层的线路
                            underConstructionMap.removeLayer(global_add_line);
                        }
                        var queryLayer = L.geoJSON().addTo(underConstructionMap);
                        queryLayer.addData([line]);
                        global_add_line = L.geoJSON([line], {
                            style: style
                        }).addTo(underConstructionMap);

                        //显示站点
                        var stops= JSON.parse(lineData.stops)
                        var len = stops.length;
                        if(global_add_markers.length>0){ //清空之前图层中留下的站点
                            for(var i = 0;i<global_add_markers.length;i++){
                                underConstructionMap.removeLayer(global_add_markers[i]);
                            }
                            global_add_markers = [];
                        }
                        for(var j=0;j<len;j++) {
                            var stopLocation = stops[j].location;
                            var stationId = stops[j].id
                            var stationName = stops[j].name
                            var stationLoc = stops[j].location
                            var stationSequence = stops[j].sequence
                            global_add_markers[j] = L.marker(stopLocation)
                                .addTo(underConstructionMap)
                                .bindPopup(stationId + " " + stationName + " 站点经纬度:" + stationLoc + " 站点顺序：" + stationSequence)
                                .openPopup();
                            //console.log(stationName)
                        }
                        alert("新站点添加成功！请继续添加站点")
                        //跳转至在建线路展示层
                        $("div.leaflet-control-layers-base").children().eq(5).children().eq(0).children().eq(0).click()
                    },
                    error:function(xhr,errorMessage,e){
                        alert("系统异常！！")
                    }
                })
            }else{
                alert("请选择添加的站点是原有站点还是新站点！！")
                document.getElementById('addStop').style.display='block';
                document.getElementById('addLine').style.display='none';
                document.getElementById('form').style.display='none';
            }
        }

        //添加线路-完成 根据checkBox保存线路的站点 展示刚才保存的站点到线路status=3
        function saveAndEnd() {
            document.getElementById('addLine').style.display='block';
            document.getElementById('addStop').style.display='none';
            document.getElementById('form').style.display='none';

            var $continueAddLineName=$('#continueAddLineName').val();
            console.log($continueAddLineName=="")
            var $newLineName=$("#newLineName").val();
            console.log($newLineName=="")
            var $lineName = null;
            if($continueAddLineName==""){
                $lineName = $newLineName
            }else if($newLineName==""){
                $lineName = $continueAddLineName
            }
            var oldChecked = $('#old').is(":checked");
            var newChecked = $('#new').is(":checked");
            var $addStationName = $("#addStationName").val();
            var $addStationLocation = $("#addStationLocation").val();
            var $sequence = $("#sequence").val();
            console.log("是否原有站点"+oldChecked)
            console.log("是否新站点"+newChecked)
            if(oldChecked && (!newChecked)) {
                var obj = JSON.stringify({
                    'type':"oldStopEND",
                    'lineName':$lineName,
                    'name': $addStationName,
                    'loc': $addStationLocation ,
                    'sequence': $sequence
                });
                console.log(oldChecked)
                console.log(obj)
                //将原有站点的信息添加到线路的coord列、stops列，并将目前该线路的线路图展现在在建线路展示层中
                $.ajax({
                    url: "AddOldStopToLineServlet",
                    type: "post",
                    data: "obj="+ obj,
                    dataType: "json",
                    success:function (result,testStatus) {
                        var lineData = eval(result) ;//Object形式
                        console.log(lineData)
                        var line = JSON.parse(lineData.coordinates) //字符串转对象
                        console.log(line)
                        var style = {//查询线路展示的风格
                            "color": "#ff0000",
                            "weight": 2,
                            "opacity": 0.55
                        };
                        var queryLayer = L.geoJSON().addTo(underConstructionMap);
                        queryLayer.addData([line]);
                        L.geoJSON([line], {
                            style: style
                        }).addTo(underConstructionMap);

                        //显示站点
                        var stops= JSON.parse(lineData.stops)
                        console.log(stops)
                        var len = stops.length;
                        console.log(len)
                        for(var j=0;j<len;j++) {
                            var stopLocation = stops[j].location;
                            var stationId = stops[j].id
                            var stationName = stops[j].name
                            var stationLoc = stops[j].location
                            var stationSequence = stops[j].sequence
                            var marker = L.marker(stopLocation)
                                .addTo(underConstructionMap)
                                .bindPopup(stationId + " " + stationName + " 站点经纬度:" + stationLoc + " 站点顺序：" + stationSequence)
                                .openPopup();
                            //console.log(stationName)
                        }
                        alert("原有站点添加成功！线路已保存完毕")
                        //跳转至在建线路展示层
                        $("div.leaflet-control-layers-base").children().eq(5).children().eq(0).children().eq(0).click()
                    },
                    error:function(xhr,errorMessage,e){
                        alert("系统异常！！")
                    }
                })
            }else if(newChecked && (!oldChecked)){
                var obj = JSON.stringify({
                    'type':"newStopEND",
                    'lineName':$lineName,
                    'name': $addStationName,
                    'loc': $addStationLocation ,
                    'sequence': $sequence
                });
                console.log(newChecked)
                console.log(obj)
                //将新建的站点信息保存至station表，同时将新建的站点的信息添加到线路的coord列、stops列，并将目前该线路的线路图展现在在建线路展示层中
                $.ajax({
                    url: "AddNewStopToLineServlet",
                    type: "post",
                    data: "obj="+ obj,
                    dataType: "json",
                    success:function (result,testStatus) {
                        var lineData = eval(result) ;//Object形式
                        console.log(lineData)
                        var line = JSON.parse(lineData.coordinates) //字符串转对象
                        console.log(line)
                        var style = {//查询线路展示的风格
                            "color": "#ff0000",
                            "weight": 2,
                            "opacity": 0.55
                        };
                        var queryLayer = L.geoJSON().addTo(underConstructionMap);
                        queryLayer.addData([line]);
                        L.geoJSON([line], {
                            style: style
                        }).addTo(underConstructionMap);

                        //显示站点
                        var stops= JSON.parse(lineData.stops)
                        console.log(stops)
                        var len = stops.length;
                        console.log(len)
                        for(var j=0;j<len;j++) {
                            var stopLocation = stops[j].location;
                            var stationId = stops[j].id
                            var stationName = stops[j].name
                            var stationLoc = stops[j].location
                            var stationSequence = stops[j].sequence
                            var marker = L.marker(stopLocation)
                                .addTo(underConstructionMap)
                                .bindPopup(stationId + " " + stationName + " 站点经纬度:" + stationLoc + " 站点顺序：" + stationSequence)
                                .openPopup();
                            //console.log(stationName)
                        }
                        alert("新站点添加成功！线路已经保存完毕")
                        //跳转至在建线路展示层
                        $("div.leaflet-control-layers-base").children().eq(5).children().eq(0).children().eq(0).click()
                    },
                    error:function(xhr,errorMessage,e){
                        alert("系统异常！！")
                    }
                })
            }else{
                alert("请选择添加的站点是原有站点还是新站点！！")
                document.getElementById('addStop').style.display='block';
                document.getElementById('addLine').style.display='none';
                document.getElementById('form').style.display='none';
            }
        }


        //添加线路 在建线路-继续 根据下拉选择在建线路的线路图 页面保持继续添加站点
        function continueLineByID() {
            var $continueAddLineName=$('#continueAddLineName').val();
            document.getElementById('addStop').style.display = 'block';
            document.getElementById('addLine').style.display = 'none';
            document.getElementById('form').style.display = 'none';
            document.getElementById('continueNew').style.display='none';

            alert("在建线路的现有站点及线路图请在 在建线路层查看！！")
            $.ajax({
                url:"LineQueryByNameServlet",
                data:"lineName="+$continueAddLineName,
                dataType:"json",
                success:function (result,testStatus) {
                    var lineData = eval(result) ;//Object形式
                    console.log(lineData)
                    var line = JSON.parse(lineData.coordinates) //字符串转对象
                    console.log(line)
                    var style = {//查询线路展示的风格
                        "color": "#ff0000",
                        "weight": 2,
                        "opacity": 0.55
                    };
                    if(global_add_line!=null){
                        underConstructionMap.removeLayer(global_add_line);
                    }
                    global_add_line = L.geoJSON([line], {
                        style: style
                    }).addTo(underConstructionMap);

                    //显示站点
                    var stops= JSON.parse(lineData.stops)
                    var len = stops.length;
                    if(global_add_markers.length > 0){
                        for(var i = 0;i < global_add_markers.length; i++ ){
                            underConstructionMap.removeLayer(global_add_markers[i]);
                        }
                        global_add_markers = [];
                    }
                    for(var j=0;j<len;j++) {
                        var stopLocation = stops[j].location;
                        var stationId = stops[j].id
                        var stationName = stops[j].name
                        var stationLoc = stops[j].location
                        var stationSequence = stops[j].sequence
                        global_add_markers[j] = L.marker(stopLocation)
                            .addTo(underConstructionMap)
                            .bindPopup(stationId + " " + stationName + " 站点经纬度:" + stationLoc + " 站点顺序：" + stationSequence)
                            .openPopup();
                    }
                    //跳转至线路查询层
                    $("div.leaflet-control-layers-base").children().eq(5).children().eq(0).children().eq(0).click()
                },
                error:function(xhr,errorMessage,e){
                    alert("系统异常！！")
                }
            })
            stopShow();
        }


    </script>

<%--    控制修改线路弹出框等--%>
    <script type="text/javascript">
        //修改线路
        function correctLine() {
            document.getElementById('correctLine').style.display='block';
            document.getElementById('form').style.display='none';
        }

        //下拉 现有及新建完毕线路 列表
        $(function() {
            $.ajax({
                type: 'post',
                url: "QueryAllLinesServlet",
                dataType: "json",
                //data: {pid: 0},
                success: function (data) {
                    // console.log(data);
                    $("#correctLineID").empty();
                    $("#correctLineID").append("<option value=''>请选择需要修改的公交线路</option>");
                    for (var i = 0; i < data.length; i++) {
                        $("#correctLineID").append('<option value=' + data[i].id + '>' + data[i].lineName + '</option>');
                    }
                }
            });
        })

        var global_correct_line =null;
        var global_correct_markers=[];
        var global_correct_coords = [];
        var global_tmp_stop_marker =  null;
        //修改线路-查看该线路走向及站点和拐点
        function getLineByID() {
            var $correctLineID = $("#correctLineID").val();
            $.ajax({
                url:"LineQueryByIDServlet",
                data:"queryLineID="+$correctLineID,
                dataType:"json",
                success:function (result,testStatus) {
                    var lineData = eval(result) ;//Object形式
                    var line = JSON.parse(lineData.coordinates) //字符串转对象
                    var style = {//查询线路展示的风格
                        "color": "#ff0000",
                        "weight": 2,
                        "opacity": 0.55
                    };

                    if(global_correct_line!=null) {//若当前图层上有线路则清空原有线路
                        correctLineMap.removeLayer(global_correct_line)
                    }
                    global_correct_line = L.geoJSON([line], {
                        style: style
                    }).addTo(correctLineMap);
                    // console.log(global_correct_line)
                    //显示站点
                    var stops= JSON.parse(lineData.stops)
                    //console.log('stops',stops.length)
                    var len = stops.length;
                    if(global_correct_markers.length > 0) {//若当前图层有其他线路的站点标记则清空
                        for(var j=0;j<global_correct_markers.length;j++) {
                            correctLineMap.removeLayer(global_correct_markers[j])
                        }
                    }
                    global_correct_markers = [];
                    //console.log('global_current_markers clear size ' + global_correct_markers.length)
                    for(var j=0;j<len;j++) {
                        var stopLocation = stops[j].location;
                        var stationId = stops[j].id
                        var stationName = stops[j].name
                        var stationLoc = stops[j].location
                        var stationSequence = stops[j].sequence
                        var stop = L.marker(stopLocation)
                            .addTo(correctLineMap)
                            .bindPopup(stationId + " " + stationName + " 站点经纬度:" + stationLoc + " 站点顺序：" + stationSequence)
                            .openPopup();
                        global_tmp_stop_marker = stop;
                        global_correct_markers[j] = stop
                    }
                    //console.log('final global marker size  = ' + global_correct_markers.length)
                    //显示线路拐点
                    $.ajax({
                        url:"GetCoordByID",
                        data:"queryLineID="+$correctLineID,
                        dataType:"json",
                        success:function (data) {
                            // console.log(data)
                             var arraydata = eval(data);
                            // console.log(arraydata);
                            var len = arraydata.length;
                            if (global_correct_coords.length > 0 ){//若当前展示图层上有其他线路的coord则先清空
                                for (var i = 0 ; i< global_correct_coords.length ; i++){
                                    correctLineMap.removeLayer(global_correct_coords[i])
                                }
                                global_correct_coords = [];
                            }
                            for(var i=0;i<len;i++)
                            {
                                var stopLoc = arraydata[i]; //array[2]  0: 31.238547 1: 121.3208
                                //console.log(stopLoc)
                                global_correct_coords[i] = L.circle(stopLoc, {
                                    color: '#D1EEEE',
                                    weight: 0,
                                    fillColor: '#FF0000',
                                    radius: 10,
                                    fillOpacity: 1
                                }).addTo(correctLineMap)
                            }
                            // //跳转至修改线路展示层
                            // $("div.leaflet-control-layers-base").children().eq(6).children().eq(0).children().eq(0).click()
                        },
                        error:function(xhr,errorMessage,e){
                            alert("系统异常！！")
                        }
                    })
                    //跳转至修改层
                    $("div.leaflet-control-layers-base").children().eq(6).children().eq(0).children().eq(0).click()
                },
                error:function(xhr,errorMessage,e){
                    alert("系统异常！！")
                }
            })

        }

        //修改线路-查看线路拐点
        // function getCoord() {
        //     var $correctLineID = $("#correctLineID").val();
        //     $.ajax({
        //         url:"GetCoordByID",
        //         data:"queryLineID="+$correctLineID,
        //         dataType:"json",
        //         success:function (data) {
        //             console.log(data)
        //             var arraydata = eval(data);
        //             console.log(arraydata);
        //             var len = arraydata.length;
        //             for(var i=0;i<len;i++)
        //             {
        //                 var stopLoc = arraydata[i]; //array[2]  0: 31.238547 1: 121.3208
        //                 //console.log(stopLoc)
        //                 L.circle(stopLoc, {
        //                     color: '#D1EEEE',
        //                     weight: 0,
        //                     fillColor: '#FF0000',
        //                     radius: 10,
        //                     fillOpacity: 1
        //                 }).addTo(correctLineMap)
        //             }
        //             //跳转至修改线路展示层
        //             $("div.leaflet-control-layers-base").children().eq(6).children().eq(0).children().eq(0).click()
        //         },
        //         error:function(xhr,errorMessage,e){
        //             alert("系统异常！！")
        //         }
        //     })
        //
        // }

        //修改线路-返回
        function correctLineBack() {
            document.getElementById('correctLine').style.display='none';
            document.getElementById('form').style.display='block';
        }

        //修改线路-开始修改
        function startCorrect() {
            document.getElementById('startCorrect').style.display='block';
            document.getElementById('correctLine').style.display='none';
        }

        //修改线路-开始修改-返回 返回继续修改其他线路
        function backToCorrectMore() {
            document.getElementById('startCorrect').style.display='none';
            document.getElementById('correctLine').style.display='block';
            document.getElementById('form').style.display='none';
        }

        //修改线路-删除站点
        function deleteStation(){
            var $correctLineID = $("#correctLineID").val();
            var $correctStationName = $("#correctStationName").val();
            var $correctSequence = $("#correctSequence").val();

            var obj = JSON.stringify({
                'lineID':$correctLineID,
                'name': $correctStationName,
                'sequence': $correctSequence
            });
            console.log(obj)
            $.ajax({
                url: "DeleteStationServlet",
                //参考AddOldStopToLineServlet
                type: "post",
                data: "obj="+ obj,
                dataType: "json",
                success:function (result,testStatus) {
                    var lineData = eval(result) ;//Object形式
                    console.log(lineData)
                    var line = JSON.parse(lineData.coordinates) //字符串转对象
                    console.log(line)
                    var style = {//查询线路展示的风格
                        "color": "#ff0000",
                        "weight": 2,
                        "opacity": 0.55
                    };
                    var queryLayer = L.geoJSON().addTo(correctLineMap);
                    queryLayer.addData([line]);
                    L.geoJSON([line], {
                        style: style
                    }).addTo(correctLineMap);

                    //显示站点
                    var stops= JSON.parse(lineData.stops)
                    console.log(stops)
                    var len = stops.length;
                    console.log(len)
                    for(var j=0;j<len;j++) {
                        var stopLocation = stops[j].location;
                        var stationId = stops[j].id
                        var stationName = stops[j].name
                        var stationLoc = stops[j].location
                        var stationSequence = stops[j].sequence
                        var marker = L.marker(stopLocation)
                            .addTo(correctLineMap)
                            .bindPopup(stationId + " " + stationName + " 站点经纬度:" + stationLoc + " 站点顺序：" + stationSequence)
                            .openPopup();
                        //console.log(stationName)
                    }
                    alert("原有站点添加成功！线路已保存为在建状态")

                    //跳转至修改线路展示层
                    $("div.leaflet-control-layers-base").children().eq(6).children().eq(0).children().eq(0).click()
                },
                error:function(xhr,errorMessage,e){
                    alert("系统异常！！")
                }
            })
        }


    </script>

<%--    控制删除线路的弹出框等--%>
    <script type="text/javascript">
        //删除线路 按钮的界面显示
        function deleteLine() {
            document.getElementById('deleteLine').style.display='block';
            document.getElementById('form').style.display='none';
        }
        //删除公交查询的下拉列表
        $(function() {
            $.ajax({
                type: 'post',
                url: "QueryAllLinesServlet",
                dataType: "json",
                //data: {pid: 0},
                success: function (data) {
                    // console.log(data);
                    $("#deleteID").empty();
                    $("#deleteID").append("<option value=''>请选择需要删除的公交线路</option>");
                    for (var i = 0; i < data.length; i++) {
                        $("#deleteID").append('<option value=' + data[i].id + '>' + data[i].lineName + '</option>');
                    }
                }
            });
        })

        //删除该线路 -查看该线路及站点
        function queryLineByID() {
            var $deleteID = $("#deleteID").val();
            $.ajax({
                url:"LineQueryByIDServlet",
                data:"queryLineID="+$deleteID,
                dataType:"json",
                success:function (result,testStatus) {
                    var lineData = eval(result) ;//Object形式
                    console.log(lineData)
                    var line = JSON.parse(lineData.coordinates) //字符串转对象
                    console.log(line)
                    var style = {//查询线路展示的风格
                        "color": "#ff0000",
                        "weight": 2,
                        "opacity": 0.55
                    };
                    var queryLayer = L.geoJSON().addTo(queryLineMap);
                    queryLayer.addData([line]);
                    L.geoJSON([line], {
                        style: style
                    }).addTo(queryLineMap);

                    //显示站点
                    var stops= JSON.parse(lineData.stops)
                    console.log(stops)
                    var len = stops.length;
                    console.log(len)
                    for(var j=0;j<len;j++) {
                        var stopLocation = stops[j].location;
                        var stationId = stops[j].id
                        var stationName = stops[j].name
                        var stationLoc = stops[j].location
                        var stationSequence = stops[j].sequence
                        var marker = L.marker(stopLocation)
                            .addTo(queryLineMap)
                            .bindPopup(stationId + " " + stationName + " 站点经纬度:" + stationLoc + " 站点顺序：" + stationSequence)
                            .openPopup();
                        //console.log(stationName)
                    }
                    //跳转至线路查询层
                    $("div.leaflet-control-layers-base").children().eq(1).children().eq(0).children().eq(0).click()
                },
                error:function(xhr,errorMessage,e){
                    alert("系统异常！！")
                }
            })
        }

        //删除线路 根据下拉列表传递的ID进行删除
        function deleteLineByID() {
            var $deleteID = $("#deleteID").val();
            $.ajax({
                url:"DeleteLineByIdServlet",
                data:"id="+$deleteID,
                dataType:"json",
                success:function (result,testStatus) {
                    console.log(result)
                    if(result=="1"){
                        alert("该线路删除成功！！")
                    }else if(result=="0"){
                        alert("该线路删除失败")
                    }
                    //跳转至线路查询层
                    $("div.leaflet-control-layers-base").children().eq(1).children().eq(0).children().eq(0).click()
                },
                error:function(xhr,errorMessage,e){
                    alert("系统异常！！")
                }
            })
        }

        //删除线路-返回
        function deleteBack() {
            document.getElementById('deleteLine').style.display='none';
            document.getElementById('form').style.display='block';
        }
    </script>
</div>



</html>