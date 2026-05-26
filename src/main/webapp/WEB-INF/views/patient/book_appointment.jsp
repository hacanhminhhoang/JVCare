<%@ page contentType="text/html;charset=UTF-8" %>

<html>
<head>
    <title>Đặt lịch khám</title>
</head>
<body>

<h2>Đặt lịch khám</h2>

<%
    String error = (String) request.getAttribute("error");
    String success = (String) request.getAttribute("success");
%>

<% if (error != null) { %>
    <p style="color:red;"><%= error %></p>
<% } %>

<% if (success != null) { %>
    <p style="color:green;"><%= success %></p>
<% } %>

<form method="post">

    <label>Ngày khám:</label>
    <input type="date"
           name="appointmentDate"
           required>

    <br><br>

    <label>Giờ khám:</label>
    <input type="time"
           name="appointmentTime"
           required>

    <br><br>

    <label>Lý do khám:</label>
    <textarea name="reason"></textarea>

    <br><br>

    <button type="submit">
        Đặt lịch
    </button>

</form>

</body>
</html>