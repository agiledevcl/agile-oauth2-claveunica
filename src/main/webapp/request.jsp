<%
/*
	 * Ejemplo de implementación ClaveUnica
	 * Author: Rodrigo Zenteno
	 * Agile Ingeniería & Consultoría
	 * www.claveunica.cl     
 */
%>

<%@page import="java.util.Arrays"%>
<%@page import="java.util.Map"%>
<%@page import="com.google.api.client.auth.oauth2.AuthorizationCodeFlow" %>
<%@page import="com.google.api.client.auth.oauth2.BearerToken" %>
<%@page import="com.google.api.client.http.BasicAuthentication" %>
<%@page import="com.google.api.client.http.GenericUrl" %>
<%@page import="com.google.api.client.http.HttpTransport" %>
<%@page import="com.google.api.client.http.javanet.NetHttpTransport" %>
<%@page import="com.google.api.client.json.JsonFactory" %>
<%@page import="com.google.api.client.json.jackson2.JacksonFactory" %>

<%		
	String SECRET="[YOUR CLIENT SECRET]";
	String ID="[YOUR CLIENT ID]";	
	HttpTransport HTTP_TRANSPORT = new NetHttpTransport();
	JsonFactory JSON_FACTORY = JacksonFactory.getDefaultInstance();
	String AUTHORIZATION_SERVER_URL = "https://www.claveunica.cl/oauth2/auth";
	String TOKEN_SERVER_URL = "https://www.claveunica.cl/oauth2/token";
	String returnToUrl="";
	AuthorizationCodeFlow authorization = (AuthorizationCodeFlow) pageContext.getAttribute("authorizationCodeFlow", PageContext.APPLICATION_SCOPE);	
	GenericUrl tokenServerUrl=new GenericUrl(TOKEN_SERVER_URL);	
	if(authorization == null){
		authorization=new AuthorizationCodeFlow.Builder(BearerToken.authorizationHeaderAccessMethod(),  HTTP_TRANSPORT, JSON_FACTORY, tokenServerUrl, new BasicAuthentication(ID, SECRET), ID, AUTHORIZATION_SERVER_URL).setScopes(Arrays.asList("basico")).build();
		pageContext.setAttribute("authorizationCodeFlow", authorization, PageContext.APPLICATION_SCOPE);
	}
	String realm = request.getScheme() + "://" + request.getServerName() + (request.getServerPort()==443?"":(":" + request.getServerPort())) + request.getContextPath();
	returnToUrl = realm + "/return.jsp";
	pageContext.setAttribute("returnToUrl", returnToUrl, PageContext.APPLICATION_SCOPE);
	String url = authorization.newAuthorizationUrl().setState("xyz")
	        .setRedirectUri(returnToUrl).build();
	response.sendRedirect(url);	
  
%>
