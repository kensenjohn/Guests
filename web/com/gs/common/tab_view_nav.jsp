<%@ page import="com.gs.common.*" %>
<%
	String sAdminId = ParseUtil.checkNull(request.getParameter("admin_id"));
%>
<div class="horiz_nav" style="padding:1px; margin-left:10px" id="div_tab_nav">
	<ul  class="nav_tab_menu">
		<li  id="li_event_summary" >
			<a  id="event_summary_tab"   class="active">Event Summary</a>
		</li>
		<li id="li_table_view">
			<a id="table_view_tab" >Tables</a>
		</li>
		<li  id="li_guest_view" >
			<a  id="guest_view_tab">Invited Guests</a>
		</li>
		<li  id="li_phone_num" >
			<a  id="phone_num_tab">Phone Number</a>
		</li>
	</ul>
</div>