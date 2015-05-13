<%
    /*
   	 * Ejemplo de implementación ClaveUnica
 	 * Author: Rodrigo Zenteno
 	 * Agile Ingeniería & Consultoría
 	 * www.claveunica.cl     
     */
%>

<%@page import="com.google.api.client.auth.oauth2.AuthorizationCodeFlow" %>
<%@page import="com.google.api.client.auth.oauth2.TokenResponse" %>
<%@page import="com.google.api.client.auth.oauth2.Credential" %>
<%@page import="com.google.api.client.auth.oauth2.BearerToken" %>
<%@page import="com.google.api.client.http.HttpRequest" %>
<%@page import="com.google.api.client.http.HttpRequestFactory" %>
<%@page import="com.google.api.client.http.HttpRequestInitializer" %>
<%@page import="com.google.api.client.http.HttpTransport" %>
<%@page import="com.google.api.client.http.javanet.NetHttpTransport" %>
<%@page import="com.google.api.client.json.JsonObjectParser" %>
<%@page import="com.google.api.client.json.JsonFactory" %>
<%@page import="com.google.api.client.json.jackson2.JacksonFactory" %>
<%@page import="com.google.api.client.http.GenericUrl" %>
<%

String TOKEN_SERVER_URL = "https://www.claveunica.cl/oauth2/token";
String RESOURCE_SERVER_URL="https://apis.modernizacion.cl/registrocivil/informacionpersonal/v1/info.php?access_token=";
	AuthorizationCodeFlow authorization = (AuthorizationCodeFlow) pageContext.getAttribute("authorizationCodeFlow", PageContext.APPLICATION_SCOPE);
	String authorizationCode=request.getParameter("code");
	String returnToUrl = (String) pageContext.getAttribute("returnToUrl", PageContext.APPLICATION_SCOPE);
	HttpTransport HTTP_TRANSPORT = new NetHttpTransport();
	final JsonFactory JSON_FACTORY = JacksonFactory.getDefaultInstance();	
	TokenResponse tokenResponse=authorization.newTokenRequest(authorizationCode).setRedirectUri(returnToUrl).execute();	
	final Credential credential=new Credential(BearerToken.authorizationHeaderAccessMethod()).setAccessToken(tokenResponse.getAccessToken());
	HttpRequestFactory requestFactory =
	          HTTP_TRANSPORT.createRequestFactory(new HttpRequestInitializer() {	        	  
	            public void initialize(HttpRequest request) throws java.io.IOException {
	              credential.initialize(request);
	              request.setParser(new JsonObjectParser(JSON_FACTORY));
	            }
	          });
	HttpRequest requested = requestFactory.buildGetRequest(new GenericUrl(RESOURCE_SERVER_URL+tokenResponse.getAccessToken()));
	String respuesta = requested.execute().parseAsString();
	out.print(respuesta);
%>
