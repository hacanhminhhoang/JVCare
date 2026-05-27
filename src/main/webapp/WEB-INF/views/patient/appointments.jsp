<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>

<%-- Truyền nội dung của trang appointments vào layout chung --%>
<c:set var="contentPage" value="patient/appointments_content.jsp" scope="request" />
<jsp:include page="/WEB-INF/views/layout.jsp" />