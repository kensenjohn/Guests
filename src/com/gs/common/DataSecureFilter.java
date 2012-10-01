package com.gs.common;

import java.io.IOException;
import java.util.Map;
import java.util.Set;

import javax.servlet.Filter;
import javax.servlet.FilterChain;
import javax.servlet.FilterConfig;
import javax.servlet.ServletContext;
import javax.servlet.ServletException;
import javax.servlet.ServletRequest;
import javax.servlet.ServletResponse;
import javax.servlet.http.Cookie;
import javax.servlet.http.HttpServletRequest;

import org.owasp.validator.html.AntiSamy;
import org.owasp.validator.html.CleanResults;
import org.owasp.validator.html.Policy;
import org.owasp.validator.html.PolicyException;
import org.owasp.validator.html.ScanException;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

public class DataSecureFilter implements Filter {

	private static final Logger appLogging = LoggerFactory
			.getLogger("AppLogging");
	Configuration applicationConfig = Configuration
					.getInstance(Constants.APPLICATION_PROP);
	private static final Logger breadCrumbLogging = LoggerFactory
				.getLogger("BreadcrumbLogging");

	private String sSecurityPolicy = "";
	private boolean isSecureFilterEnabled = false;
	private Policy owsapiPolicy = null;
	private boolean trackBreadcrumb = false;

	@Override
	public void destroy() {
		appLogging.info("Killing the Security Filter");
		owsapiPolicy = null;

	}

	@Override
	public void doFilter(ServletRequest servReq, ServletResponse servResp,
			FilterChain filterChain) throws IOException, ServletException {

		if(trackBreadcrumb)
		{
			HttpServletRequest httpRequest = (HttpServletRequest)servReq;
			String sReferer = httpRequest.getHeader("referer");
			StringBuffer sDestination = httpRequest.getRequestURL();
			
			String sUserId = "";
			String sJSessionId = "";
			
			Cookie[] cookies = httpRequest.getCookies();

			if(cookies!=null)
			{
				for(int cookieCount = 0; cookieCount < cookies.length; cookieCount++) 
				{ 
					Cookie cookie1 = cookies[cookieCount];
			        if (Constants.COOKIE_APP_USERID.equals(cookie1.getName())) {
			        	sUserId = cookie1.getValue();
			        }
			        if ("JSESSIONID".equals(cookie1.getName())) {
			        	sJSessionId = cookie1.getValue();
			        }
				}
			}
			
			breadCrumbLogging.info("\"ui\":\""+sUserId+"\",\"sess\":\""+sJSessionId+"\"\"src\":\""+sReferer+"\",\"dest\":\""+sDestination+"\"");
		}
		
		
		if (isSecureFilterEnabled) {
			Map<String, String[]> reqParams = servReq.getParameterMap();
			if (reqParams != null && !reqParams.isEmpty()) {
				Set<String> setReqParams = reqParams.keySet();

				for (String sKeys : setReqParams) {

					String[] sValue = reqParams.get(sKeys);
					if (sValue != null && sValue.length > 0) {

						AntiSamy as = new AntiSamy();
						try {
							CleanResults cr = as.scan(sValue[0], owsapiPolicy);
							int iNumOfErrors = cr.getNumberOfErrors();
							if (iNumOfErrors > 0) {
								servReq.setAttribute("INSECURE_PARAMS_ERROR",
										"true");
								break;
							}
						} catch (ScanException e) {
							// TODO Auto-generated catch block
							e.printStackTrace();
						} catch (PolicyException e) {
							// TODO Auto-generated catch block
							e.printStackTrace();
						}

					}

				}
			}

		}

		filterChain.doFilter(servReq, servResp);
	}

	ServletContext servletContext = null;

	@Override
	public void init(FilterConfig filterConfig) throws ServletException {
		servletContext = filterConfig.getServletContext();

		sSecurityPolicy = ParseUtil.checkNull(filterConfig
				.getInitParameter(Constants.OWSAPI_POLICY_FILE));
		if (sSecurityPolicy != null && !"".equalsIgnoreCase(sSecurityPolicy)) {
			try {
				owsapiPolicy = Policy.getInstance(Constants.PROP_FILE_PATH
						+ "/" + sSecurityPolicy);
				isSecureFilterEnabled = true;
			} catch (PolicyException e) {
				isSecureFilterEnabled = false;
				appLogging.error("Error loading the policy file from location "
						+ Constants.PROP_FILE_PATH + "/" + sSecurityPolicy);
				appLogging.error(ExceptionHandler.getStackTrace(e));
			}

		} else {
			appLogging
					.error("Security Filter policy file was not specified in the web.xml ");
		}
		
		trackBreadcrumb = ParseUtil.sTob(applicationConfig.get("track_user_breadcrumb"));
		

	}

}
