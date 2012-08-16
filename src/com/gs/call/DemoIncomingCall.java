package com.gs.call;

import java.io.IOException;
import java.io.PrintWriter;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import com.gs.bean.twilio.IncomingCallBean;
import com.gs.common.Configuration;
import com.gs.common.Constants;
import com.twilio.sdk.verbs.TwiMLResponse;

public class DemoIncomingCall extends HttpServlet {
	/**
	 * 
	 */
	private static final long serialVersionUID = 4602825715164087568L;
	Logger appLogging = LoggerFactory.getLogger("AppLogging");
	Configuration applicationConfig = Configuration
			.getInstance(Constants.APPLICATION_PROP);

	public void doGet(HttpServletRequest request, HttpServletResponse response)
			throws ServletException, IOException {

		CallResponse callResponse = performTask(request);

		response.setContentType("text/xml");
		PrintWriter out = response.getWriter();

		TwiMLResponse twimlResp = callResponse.getResponse();
		out.println(twimlResp.toXML());
	}

	public void doPost(HttpServletRequest request, HttpServletResponse response)
			throws ServletException, IOException {

		CallResponse callResponse = performTask(request);

		response.setContentType("text/xml");
		PrintWriter out = response.getWriter();

		TwiMLResponse twimlResp = callResponse.getResponse();
		out.println(twimlResp.toXML());
	}

	private CallResponse performTask(HttpServletRequest request) {
		CallResponse callResponse = new CallResponse();
		String sCallType = request.getParameter("incoming_call_type");
		String sCallTask = request.getParameter("task_incoming_call");

		IncomingCallManager incominManager = new IncomingCallManager();

		IncomingCallBean incomingCallBean = incominManager
				.getIncomingCallRequest(request);

		if ("demo_get_event_num".equalsIgnoreCase(sCallType)) {
			if (incomingCallBean != null && incomingCallBean.getTo() != null
					&& !"".equalsIgnoreCase(incomingCallBean.getTo())) {

				int iNumOfAttempts = incomingCallBean.getCallAttemptNumber();

				if (iNumOfAttempts <= 2) {
					incomingCallBean
							.setCallType(Constants.CALL_TYPE.DEMO_GATHER_EVENT_NUM);
				} else {
					incomingCallBean
							.setCallType(Constants.CALL_TYPE.DEMO_ERROR_HANGUP);
				}

				callResponse = incominManager.processCall(incomingCallBean);
			}
		} else if ("demo_get_secret_key".equalsIgnoreCase(sCallType)) {
			if (incomingCallBean != null && incomingCallBean.getTo() != null
					&& !"".equalsIgnoreCase(incomingCallBean.getTo())) {
				int iNumOfAttempts = incomingCallBean.getCallAttemptNumber();

				if (iNumOfAttempts <= 2) {
					incomingCallBean
							.setCallType(Constants.CALL_TYPE.DEMO_GATHER_SECRET_KEY);
				} else {
					incomingCallBean
							.setCallType(Constants.CALL_TYPE.DEMO_ERROR_HANGUP);
				}
				callResponse = incominManager.processCall(incomingCallBean);
			}
		} else if ("demo_rsvp_ans".equalsIgnoreCase(sCallType)) {
			if (incomingCallBean != null && incomingCallBean.getTo() != null
					&& !"".equalsIgnoreCase(incomingCallBean.getTo())) {
				int iNumOfAttempts = incomingCallBean.getCallAttemptNumber();

				if (iNumOfAttempts <= 2) {
					incomingCallBean
							.setCallType(Constants.CALL_TYPE.DEMO_GATHER_RSVP_NUM);
				} else {
					incomingCallBean
							.setCallType(Constants.CALL_TYPE.DEMO_ERROR_HANGUP);
				}
				callResponse = incominManager.processCall(incomingCallBean);
			}
		} else {
			if (incomingCallBean != null && incomingCallBean.getTo() != null
					&& !"".equalsIgnoreCase(incomingCallBean.getTo())) {
				incomingCallBean
						.setCallType(Constants.CALL_TYPE.DEMO_FIRST_REQUEST);
				appLogging.info("demo incoming request entry : "
						+ incomingCallBean.getTo());
				callResponse = incominManager.processCall(incomingCallBean);
			}
		}
		return callResponse;
	}
}