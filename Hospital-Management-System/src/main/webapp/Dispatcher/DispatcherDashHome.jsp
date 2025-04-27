<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Dispatcher Dashboard</title>
    <style>
        * { margin: 0; padding: 0; box-sizing: border-box; font-family: 'Segoe UI', sans-serif; }
        body { background: linear-gradient(135deg, #667eea 0%, #764ba2 100%); min-height: 100vh; padding: 20px; }
        .dashboard-container { background: white; padding: 40px; border-radius: 15px; box-shadow: 0 10px 30px rgba(0, 0, 0, 0.1); max-width: 1200px; margin: 0 auto; }
        .dashboard-header { text-align: center; margin-bottom: 40px; }
        .dashboard-header h1 { color: #333; font-size: 28px; margin-bottom: 10px; }
        .section { margin-bottom: 40px; }
        .section h2 { color: #333; font-size: 22px; margin-bottom: 20px; }
        table { width: 100%; border-collapse: collapse; margin-bottom: 20px; }
        th, td { padding: 15px; text-align: left; border-bottom: 1px solid #eee; }
        th { background: #f5f5f5; color: #333; }
        td { color: #555; }
        .dispatch-btn { padding: 10px 20px; background: linear-gradient(135deg, #667eea 0%, #764ba2 100%); border: none; border-radius: 8px; color: white; font-weight: 600; cursor: pointer; transition: transform 0.2s ease; }
        .dispatch-btn:hover { transform: translateY(-2px); }
        .message { text-align: center; margin-bottom: 20px; font-size: 16px; }
        .error { color: #ff4444; }
        .success { color: #00C851; }
        .logout-link { display: block; text-align: center; margin-top: 20px; }
        .logout-link a { color: #764ba2; text-decoration: none; font-weight: 600; }
        .logout-link a:hover { text-decoration: underline; }
    </style>
</head>
<body>
    <%
        if (session.getAttribute("dispatcherId") == null) {
            response.sendRedirect(request.getContextPath() + "/dispatcher/login");
            return;
        }
    %>
    <div class="dashboard-container">
        <div class="dashboard-header">
            <h1>Dispatcher Dashboard</h1>
        </div>

        <c:if test="${not empty errorMessage}">
            <div class="message error">${errorMessage}</div>
        </c:if>
        <c:if test="${not empty successMessage}">
            <div class="message success">${successMessage}</div>
        </c:if>

        <!-- Pending Bookings Section -->
        <div class="section">
            <h2>Pending Ambulance Bookings</h2>
            <c:if test="${empty pendingBookings}">
                <p>No pending bookings available.</p>
            </c:if>
            <c:if test="${not empty pendingBookings}">
                <table>
                    <thead>
                        <tr>
                            <th>Booking ID</th>
                            <th>Patient ID</th>
                            <th>Pickup Location</th>
                            <th>Drop-off Location</th>
                            <th>Date</th>
                            <th>Time</th>
                            <th>Action</th>
                        </tr>
                    </thead>
                    <tbody>
                        <c:forEach var="booking" items="${pendingBookings}">
                            <tr>
                                <td>${booking.bookingId}</td>
                                <td>${booking.patientId}</td>
                                <td>${booking.pickupLocation}</td>
                                <td>${booking.dropLocation}</td>
                                <td>${booking.bookingDate}</td>
                                <td>${booking.bookingTime}</td>
                                <td>
                                    <form action="${pageContext.request.contextPath}/dispatcher" method="POST">
                                        <input type="hidden" name="action" value="dispatch">
                                        <input type="hidden" name="bookingId" value="${booking.bookingId}">
                                        <select name="ambulanceId" required>
                                            <option value="" disabled selected>Select Ambulance</option>
                                            <c:forEach var="ambulance" items="${availableAmbulances}">
                                                <option value="${ambulance.id}">
                                                    ${ambulance.id} (${ambulance.type})
                                                </option>
                                            </c:forEach>
                                        </select>
                                        <button type="submit" class="dispatch-btn">Dispatch</button>
                                    </form>
                                </td>
                            </tr>
                        </c:forEach>
                    </tbody>
                </table>
            </c:if>
        </div>

        <!-- Available Ambulances Section -->
        <div class="section">
            <h2>Available Ambulances</h2>
            <c:if test="${empty availableAmbulances}">
                <p>No ambulances available.</p>
            </c:if>
            <c:if test="${not empty availableAmbulances}">
                <table>
                    <thead>
                        <tr>
                            <th>Ambulance ID</th>
                            <th>Type</th>
                            <th>Driver Name</th>
                            <th>Driver Contact</th>
                            <th>Status</th>
                        </tr>
                    </thead>
                    <tbody>
                        <c:forEach var="ambulance" items="${availableAmbulances}">
                            <tr>
                                <td>${ambulance.id}</td>
                                <td>${ambulance.type}</td>
                                <td>${ambulance.driverName}</td>
                                <td>${ambulance.driverContact}</td>
                                <td>${ambulance.status}</td>
                            </tr>
                        </c:forEach>
                    </tbody>
                </table>
            </c:if>
        </div>

        <div class="logout-link">
            <a href="${pageContext.request.contextPath}/dispatcher?action=logout">Logout</a>
        </div>
    </div>
</body>
</html>