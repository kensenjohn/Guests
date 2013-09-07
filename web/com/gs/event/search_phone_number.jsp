<%@ page import="com.gs.common.*"%>
<%@ page import="java.util.*"%>
<%@ page import="com.gs.manager.event.*"%>
<%@ page import="com.gs.bean.*"%>
<%@ page import="org.slf4j.Logger" %>
<%@ page import="org.slf4j.LoggerFactory" %>

<jsp:include page="../common/header_top.jsp"/>
<%@include file="../common/security.jsp"%>
<jsp:include page="../common/header_bottom.jsp"/>

<link rel="stylesheet" type="text/css" href="/web/css/msgBoxLight.css" media="screen" >
<body style="height:auto;">
	<%
		Logger jspLogging = LoggerFactory.getLogger(Constants.JSP_LOGS);
        Logger appLogging = LoggerFactory.getLogger(Constants.APP_LOGS);
		String sEventId = ParseUtil.checkNull(request.getParameter("event_id"));
		String sAdminId = ParseUtil.checkNull(request.getParameter("admin_id"));


        PurchaseTransactionBean purchaseTransactionBean = new PurchaseTransactionBean();
        purchaseTransactionBean.setAdminId(sAdminId);
        purchaseTransactionBean.setEventId(sEventId);

        PurchaseTransactionManager purchaseTransactionManager = new PurchaseTransactionManager();
        PurchaseTransactionBean purchaseResponseTransactionBean = purchaseTransactionManager.getPurchaseTransactionByEventAdmin(purchaseTransactionBean);

        boolean isRSVPNumberSelectedPreviously = false;
        boolean isSeatingNumberSelectedPreviously = false;
        if(purchaseResponseTransactionBean!=null && !"".equalsIgnoreCase(purchaseResponseTransactionBean.getRsvpTelNumber())
                && !"".equalsIgnoreCase(purchaseResponseTransactionBean.getSeatingTelNumber()))
        {
            String sUnformattedRSVPText = purchaseResponseTransactionBean.getRsvpTelNumber().replaceAll(" ","").replace(")","").replace("(","");
            String sUnformattedSeatingText = purchaseResponseTransactionBean.getSeatingTelNumber().replaceAll(" ","").replace(")","").replace("(","");

            TelNumberManager telNumManager = new TelNumberManager();

            TelNumberMetaData searchRsvpTelNumberMetaData = new TelNumberMetaData();
            searchRsvpTelNumberMetaData.setTextPatternSearch( sUnformattedRSVPText  );
            ArrayList<TelNumberBean> arrRSVPTelNumberBean  = telNumManager.searchTelNumber(searchRsvpTelNumberMetaData,Constants.EVENT_TASK.RSVP.getTask());
            if( arrRSVPTelNumberBean!=null && !arrRSVPTelNumberBean.isEmpty()) {
                isRSVPNumberSelectedPreviously = true;
            }
            appLogging.info("RSVP number : "  + sUnformattedRSVPText + " Result after search : " + arrRSVPTelNumberBean );

            TelNumberMetaData searchSeatingtelNumberMetaData = new TelNumberMetaData();
            searchSeatingtelNumberMetaData.setTextPatternSearch( sUnformattedSeatingText );
            ArrayList<TelNumberBean> arrSeatingTelNumberBean  = telNumManager.searchTelNumber(searchSeatingtelNumberMetaData,Constants.EVENT_TASK.SEATING.getTask());
            if( arrRSVPTelNumberBean!=null && !arrRSVPTelNumberBean.isEmpty()) {
                isSeatingNumberSelectedPreviously = true;
            }
            appLogging.info("Seating number : "  + sUnformattedSeatingText + " Result after search : " + arrSeatingTelNumberBean );
        }

        String sRsvpNumber = "Loading new number ..";
        String sSeatingNumber = "Loading new number ..";
        if(isRSVPNumberSelectedPreviously){
            if(purchaseResponseTransactionBean.getRsvpTelNumber()!=null && !"".equalsIgnoreCase(purchaseResponseTransactionBean.getRsvpTelNumber()))
            {
                sRsvpNumber = ParseUtil.checkNull(purchaseResponseTransactionBean.getRsvpTelNumber());
            }
        }

        if(isSeatingNumberSelectedPreviously){
            if(purchaseResponseTransactionBean.getSeatingTelNumber()!=null && !"".equalsIgnoreCase(purchaseResponseTransactionBean.getSeatingTelNumber()))
            {
                sSeatingNumber = ParseUtil.checkNull(purchaseResponseTransactionBean.getSeatingTelNumber());
            }
        }

	%>
    <jsp:include page="/web/com/gs/common/top_nav_fancybox.jsp"/>
	<div  class="fnbx_scratch_area">
               <div class="row">
                <div class="offset1 span11">
                    <jsp:include page="breadcrumb_shopping_cart.jsp">
                        <jsp:param name="active_now" value="search_phone_number.jsp" />
                    </jsp:include>
                </div>
               </div>
				<div class="row">
				  <div class="offset1 span11">
				  	<div class="row">
				  		<div class="span10">
				  			<h2>Personalize your phone number</h2>
				  		</div>
				  	</div>
				  	<div class="row">
				  		<div class="span10">
				  			&nbsp;
				  		</div>
				  	</div>
				  	 <div class="row">
				  	 	 <div class="span8">
				  	 	 	<h4>Seating</h4>
				  	 	 </div>
				  	 </div>
				    <div class="row">
				      <div class="offset1 span2"><span class="fld_name_small">Phone Number:</span></div>
                      <%

                      %>
				      <div class="span2"><span id="seating_gen_num" class="fld_txt"><%=sSeatingNumber%></span></div>
				      <div class="span3" id="div_seating_search" style="display:none;"><span id="seating_search" class="fld_link_txt">Customize  number</span></div>
				    </div>
				     <div class="row" id="seating_numbers_gen"  style="display:none;">
				     	<div class="offset1 span10">
							<form id="frm_seating_numbers"  style="margin-bottom:5px" > 
								<div class="row">
									<div class="span6">
										<span>&nbsp; </span>
									</div>
								</div>
								<div class="row">
									<div class="span6">
										<span class="fld_name_small">Search for</span>
									</div>
								</div>
								<div class="row">
									<div class="offset1 span2" style="margin-top:6px;">
										<span class="fld_txt_small"  style="float:right;">Area Code:</span>
									</div>
									<div class="span1"  style="margin-left:10px;"><input type="text" id="seating_area_code" name="seating_area_code" style="margin-left: 10px;" /></div>
								</div>
								<div class="row">
									<div class="offset1 span2">
										<span class="fld_txt_small"  style="float:right;">Contains:</span>
									</div>
									<div class="span1"  style="margin-left:10px;">
										<input type="text" id="seating_text_pattern" name="seating_text_pattern"  style="margin-left: 10px;"/>
									</div>
								</div>
								<div class="row">
									<div class="offset2 span2" >
										 <button id="gen_seating_tel_num" name="gen_seating_tel_num" type="button" class="btn btn-small span3">Search</button>
									</div>
								</div>
								<input type="hidden" name="admin_id" id="admin_id" value="<%=sAdminId%>"/>
								<input type="hidden" name="event_id" id="event_id" value="<%=sEventId%>"/>
				    	 	</form>
				    	 </div>
				     </div>	
				    <div class="row">
				  		<div class="span10">
				  			&nbsp;
				  		</div>
				  	</div>
				  	 <div class="row">
				  	 	 <div class="span8">
				  	 	 	<h4>RSVP</h4>
				  	 	 </div>
				  	 </div>
				    <div class="row">
				    	 <div class="offset1 span2"><span class="fld_name_small">Phone Number:</span></div>
				      	<div class="span2"><span id="rsvp_gen_num"><%=sRsvpNumber%></span></div>
				     	<div class="span3" id="div_rsvp_search" style="display:none;"><span id="rsvp_search" class="fld_link_txt">Customize  number</span></div>
				    </div>	
				    <div class="row" id="rsvp_numbers_gen"  style="display:none;">
				     	<div class="offset1 span10">
							<form id="frm_rsvp_numbers"  style="margin-bottom:5px" >
								<div class="row">
									<div class="span6">
										<span>&nbsp; </span>
									</div>
								</div>
								<div class="row">
									<div class="span6">
										<span class="fld_name_small">Search for</span>
									</div>
								</div>
								<div class="row">
									<div class="offset1 span2" style="margin-top:6px;">
										<span class="fld_txt_small"  style="float:right;">Area Code:</span>
									</div>
									<div class="span1"  style="margin-left:10px;"><input type="text" id="rsvp_area_code" name="rsvp_area_code" style="margin-left: 10px;" /></div>
								</div>
								<div class="row">
									<div class="offset1 span2">
										<span class="fld_txt_small"  style="float:right;">Contains:</span>
									</div>
									<div class="span1"  style="margin-left:10px;">
										<input type="text" id="rsvp_contains" name="rsvp_contains"  style="margin-left: 10px;"/>
									</div>
								</div>
								<div class="row">
									<div class="offset2 span2" >
										 <button id="gen_rsvp_tel_num" name="gen_rsvp_tel_num" type="button" class="btn btn-small span3">Search</button>
									</div>
								</div>
								<input type="hidden" name="admin_id" id="admin_id" value="<%=sAdminId%>"/>
								<input type="hidden" name="event_id" id="event_id" value="<%=sEventId%>"/>
				    	 	</form>
				    	 </div>
				     </div>
				  <div class="span8">
				  	<div class="row">
				  		&nbsp;
				  	</div>
				  </div>
				  <div class="span8">
				  	<div class="row">
				  		<div class="span8">
				  			<button id="bt_get_pricing_option" name="bt_get_pricing_option" type="button" class="btn">Show me the pricing options </button>
				  		</div>
				   	</div>
				  </div>
                      <div class="span8">
                          <div class="row">
                              &nbsp;
                          </div>
                      </div>
                      <div class="span8">
                          <div class="row">
                              &nbsp;
                          </div>
                      </div>
				</div>
			</div>
			</div>
			<form id="frm_telnum_bill_address" id="frm_telnum_bill_address">
					<input type="hidden" id="admin_id" name="admin_id"  value="<%=sAdminId%>"/>
					<input type="hidden" id="event_id" name="event_id" value="<%=sEventId%>"/>
					
					<input type="hidden" id="pass_thru_rsvp_num" name="pass_thru_rsvp_num" value=""/>
					<input type="hidden" id="pass_thru_seating_num" name="pass_thru_seating_num" value=""/>
					<input type="hidden" id="referrer_source" name="referrer_source" value="search_phone_number.jsp"/>
					<input type="hidden" id="pass_thru_action" name="pass_thru_action" value="true"/>
					
			</form>
            <form id="frm_process_purchase_transaction" id="frm_process_purchase_transaction">
                <input type="hidden" id="admin_id" name="admin_id"  value="<%=sAdminId%>"/>
                <input type="hidden" id="event_id" name="event_id" value="<%=sEventId%>"/>
                <input type="hidden" id="purchase_transact_rsvp_num" name="purchase_transact_rsvp_num" value=""/>
                <input type="hidden" id="purchase_transact_seating_num" name="purchase_transact_seating_num" value=""/>
            </form>
			<div id="loading_wheel" style="display:none;">
				<img src="/web/img/wheeler.gif">
			</div>
</body>

<script type="text/javascript" src="/web/js/jquery.msgBox.js"></script>
<script type="text/javascript">

var  varEventId= '<%=sEventId%>';
var varAdminId = '<%=sAdminId%>';

var varSeatingNumType = '<%=Constants.EVENT_TASK.SEATING.getTask()%>';
var varRsvpNumType = '<%=Constants.EVENT_TASK.RSVP.getTask()%>';

var varIsSignedIn = <%=isSignedIn%>;

var varIsNumberSelectedPreviously = <%=(isRSVPNumberSelectedPreviously||isSeatingNumberSelectedPreviously)%>;

	$(document).ready(function() {

        if(!varIsNumberSelectedPreviously)
        {
            $("#loading_wheel").show();
            loadPhoneNumber();
        }
        else
        {
            $("#div_seating_search").show();
            $("#div_rsvp_search").show();

            enablePassThruButton();
        }


		
		//$("#bt_custom_seating_num").click(getCustomSeatingNums);
		
		$("#gen_seating_tel_num").click(genSeatingTelNum);
		$("#gen_rsvp_tel_num").click(genRsvpTelNum);
		
		//$("#save_tel_num").click();
		
		$('#rsvp_search').toggle(function() {
				$("#rsvp_numbers_gen").slideDown();
		}, function() {
				$("#rsvp_numbers_gen").slideUp();
		});
		
		$('#seating_search').toggle(function() {
			$("#seating_numbers_gen").slideDown();
		}, function() {
				$("#seating_numbers_gen").slideUp();
		});
	});
	
	function enablePassThruButton()
	{
		$('#bt_get_pricing_option').bind('click',passthruForm);
	}
	function disablePassThruButton()
	{
		$('#bt_get_pricing_option').unbind('click');
	}
	
	function passthruForm()
	{
        if( varIsSignedIn )
        {
            $('#purchase_transact_rsvp_num').val( $("#rsvp_gen_num").text() );
            $('#purchase_transact_seating_num').val( $("#seating_gen_num").text() );


            var actionUrl = "proc_search_phone_number.jsp";
            var methodType = "POST";
            var dataString = $('#frm_process_purchase_transaction').serialize();


            phoneNumberData(actionUrl,dataString,methodType,processPurchaseTransactions);
        }
        else
        {
            $("#frm_telnum_bill_address").attr('action',"/web/com/gs/common/credential.jsp");
            $("#frm_telnum_bill_address").attr('method','POST');
            $("#frm_telnum_bill_address").submit();
        }
	}

    function processPurchaseTransactions(jsonResult)
    {
        if(jsonResult!=undefined)
        {
            var varResponseObj = jsonResult.response;
            if(jsonResult.status == 'error'  && varResponseObj !=undefined )
            {
                var varIsMessageExist = varResponseObj.is_message_exist;
                if(varIsMessageExist == true)
                {
                    var jsonResponseMessage = varResponseObj.messages;
                    var varArrErrorMssg = jsonResponseMessage.error_mssg;
                    displayMssgBoxMessages( varArrErrorMssg , true);
                }
            }
            else if( jsonResult.status == 'ok' && varResponseObj !=undefined)
            {
                $('#pass_thru_rsvp_num').val( $("#rsvp_gen_num").text() );
                $('#pass_thru_seating_num').val( $("#seating_gen_num").text() );

                if( varIsSignedIn )
                {
                    $("#frm_telnum_bill_address").attr('action','/web/com/gs/event/pricing_plan.jsp');
                    $("#frm_telnum_bill_address").attr('method','POST');


                    $("#frm_telnum_bill_address").submit();
                }
            }
            else
            {
                alert("Please try again later.");
            }
        }
    }
	function getCustomSeatingNums()
	{
		disablePassThruButton();
		searchMoreNumbers(varSeatingNumType,customSeatingNumResult);
	}
	
	function searchMoreNumbers(numType, callbackmethod)
	{
		var actionUrl = "proc_load_phone_numbers.jsp";
		var methodType = "POST";
		var dataString = $("#frm_tel_numbers").serialize();
		dataString = dataString + "&num_type="+numType +"&custom_num_gen=true";
		
		phoneNumberData(actionUrl,dataString,methodType,callbackmethod);
	}
	function loadPhoneNumber()
	{
		var actionUrl = "proc_load_phone_numbers.jsp";
		var methodType = "POST";
		var dataString = "admin_id="+varAdminId+"&event_id="+varEventId+'&get_new_phone_num=true';
		
		
		phoneNumberData(actionUrl,dataString,methodType,displayPhoneNumbers);
	}
	function phoneNumberData(actionUrl,dataString,methodType,callBackMethod)
	{
		$.ajax({
			  url: actionUrl ,
			  type: methodType ,
			  dataType: "json",
			  data: dataString ,
			  success: callBackMethod,
			  error:function(a,b,c)
			  {
				  alert(a.responseText + ' = ' + b + " = " + c);
			  }
			});
	}
	function displayPhoneNumbers(jsonResult)
	{
		//alert('status = '+jsonResult.status);
		if(jsonResult!=undefined)
		{
			var varResponseObj = jsonResult.response;
			if(jsonResult.status == 'error'  && varResponseObj !=undefined )
			{
				
				var varIsMessageExist = varResponseObj.is_message_exist;
				if(varIsMessageExist == true)
				{
					var jsonResponseMessage = varResponseObj.messages;
					var varArrErrorMssg = jsonResponseMessage.error_mssg;
                    displayMssgBoxMessages( varArrErrorMssg , true);
				}
				
			}
			else if( jsonResult.status == 'ok' && varResponseObj !=undefined)
			{
				var varIsPayloadExist = varResponseObj.is_payload_exist;
				//alert(varIsPayloadExist);
				
				if(varIsPayloadExist == true)
				{
					var jsonResponseObj = varResponseObj.payload;
					processTelNumbers( jsonResponseObj );
				}
                else
                {
                    displayMssgBoxAlert("There were no telephone numbers available for the search parameters.",true);
                }
			}
			else
			{
                displayMssgBoxAlert("Please try again later.",true);
			}
		}
		else
		{
            displayMssgBoxAlert("Please try again later.",true);
		}
		$("#loading_wheel").hide();
		enablePassThruButton();
	}

	function customSeatingNumResult(jsonResult)
	{
		if(jsonResult!=undefined)
		{
			var varResponseObj = jsonResult.response;
			if(jsonResult.status == 'error'  && varResponseObj !=undefined )
			{
				
				var varIsMessageExist = varResponseObj.is_message_exist;
				if(varIsMessageExist == true)
				{
					var jsonResponseMessage = varResponseObj.messages;
					var varArrErrorMssg = jsonResponseMessage.error_mssg
					displayMssgBoxMessages( varArrErrorMssg , true);
				}
				
			}
			else if( jsonResult.status == 'ok' && varResponseObj !=undefined)
			{
				
				var varIsPayloadExist = varResponseObj.is_payload_exist;
				//alert('after searching for number - payload exists = ' + varIsPayloadExist);
				if(varIsPayloadExist == true)
				{
					var jsonResponseObj = varResponseObj.payload;
					processTelNumbers( jsonResponseObj );
				}
			}
			else
			{
				displayMssgBoxAlert("Please try again later.",true);
			}
		}
		else
		{
			displayMssgBoxAlert("Please try again later.",true);
		}
		enablePassThruButton();
	}
	function processTelNumbers( jsonResponseObj )
	{
		var varTelNumbers= jsonResponseObj.telnumbers;
        if(varTelNumbers != undefined )
        {
            var totalRows = varTelNumbers.num_of_rows;
            if(totalRows!=undefined)
            {
                var varTelNumList = varTelNumbers.telnum_array;
                if(varTelNumList!=undefined)
                {
                    var varIsSeatingFound = false;
                    var varIsRsvpFound = false;
                    for(var iRow = 0; iRow < totalRows ; iRow++ )
                    {
                        var telNumBean = varTelNumList[iRow];

                        //alert('tel number = ' + telNumBean.telnum);
                        if(telNumBean.telnum_type == varSeatingNumType)
                        {
                            $("#div_seating_search").show();
                            $("#seating_gen_num").text(telNumBean.human_telnum);
                            varIsSeatingFound = true;
                        }
                        if(telNumBean.telnum_type == varRsvpNumType)
                        {
                            $("#div_rsvp_search").show();
                            $("#rsvp_gen_num").text(telNumBean.human_telnum);
                            varIsRsvpFound = true;
                        }
                    }
                    if(varIsSeatingFound==true && varIsRsvpFound==true)
                    {

                    }
                    else if(varIsSeatingFound==true || varIsRsvpFound==true)
                    {
                        $("#loading_wheel").hide();
                        displayMssgBoxAlert('Success!! Please click on \"Search\" again to get a new number.', false);
                    }
                }

            }
        }
        else
        {
            displayMssgBoxAlert('We could not find a valid telephone number with the area code provided.', true);
        }

	}
	function displayMssgBoxAlert(varMessage, isError)
	{
		var varTitle = 'Status';
		var varType = 'info';
		if(isError)
		{
			varTitle = 'Error';
			varType = 'error';
		}
		else
		{
			varTitle = 'Status';	
			varType = 'info';
		}
		
		if(varMessage!='')
		{
			$.msgBox({
                title: varTitle,
                content: varMessage,
                type: varType
            });
		}
	}
	
	function displayMssgBoxMessages(varArrMessages, isError)
	{
		if(varArrMessages!=undefined)
		{
			
				
			var varMssg = '';
			var isFirst = true;
			for(var i = 0; i<varArrMessages.length; i++)
			{
				if(isFirst == false)
				{
					varMssg = varMssg + '\n';
				}
				varMssg = varMssg + varArrMessages[i].text;
			}
			
			if(varMssg!='')
			{
                displayMssgBoxAlert(varMssg,isError);
			}
		}
		

	}
	/*function displayMessages(varArrMessages)
	{
		if(varArrMessages!=undefined)
		{
			for(var i = 0; i<varArrMessages.length; i++)
			{
				alert( varArrMessages[i].text );
			}
		}
	}*/
	function genSeatingTelNum()
	{
        $("#loading_wheel").show();
		disablePassThruButton();
		var actionUrl = "proc_load_phone_numbers.jsp";
		var methodType = "POST";
		var dataString = $("#frm_seating_numbers").serialize();
		dataString = dataString + '&num_type='+varSeatingNumType+'&custom_num_gen=true';
		
		phoneNumberData(actionUrl,dataString,methodType,displayPhoneNumbers);
	}
	function  genRsvpTelNum()
	{
        $("#loading_wheel").show();
		disablePassThruButton();
		var actionUrl = "proc_load_phone_numbers.jsp";
		var methodType = "POST";
		var dataString = $("#frm_rsvp_numbers").serialize();
		dataString = dataString + '&num_type='+varRsvpNumType+'&custom_num_gen=true';
		
		phoneNumberData(actionUrl,dataString,methodType,displayPhoneNumbers);
	}
</script>
<jsp:include page="../common/footer_bottom_fancybox.jsp"/> 
</html>