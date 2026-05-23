package com.jvcare.filter;

import com.jvcare.model.User;

import javax.servlet.*;
import javax.servlet.annotation.WebFilter;
import javax.servlet.http.*;
import java.io.IOException;

@WebFilter(urlPatterns = {"/admin/*", "/doctor/*", "/patient/*"})
public class RoleFilter implements Filter {
    
    @Override
    public void doFilter(ServletRequest request, ServletResponse response, FilterChain chain) 
            throws IOException, ServletException {
        
        HttpServletRequest httpRequest = (HttpServletRequest) request;
        HttpServletResponse httpResponse = (HttpServletResponse) response;
        HttpSession session = httpRequest.getSession(false);
        
        if (session != null && session.getAttribute("user") != null) {
            User user = (User) session.getAttribute("user");
            String requestURI = httpRequest.getRequestURI();
            
            boolean hasAccess = false;
            
            if (requestURI.contains("/admin/") && "ADMIN".equals(user.getRole())) {
                hasAccess = true;
            } else if (requestURI.contains("/doctor/") && "DOCTOR".equals(user.getRole())) {
                hasAccess = true;
            } else if (requestURI.contains("/patient/") && "PATIENT".equals(user.getRole())) {
                hasAccess = true;
            }
            
            if (hasAccess) {
                chain.doFilter(request, response);
            } else {
                httpResponse.sendError(HttpServletResponse.SC_FORBIDDEN, 
                    "Bạn không có quyền truy cập trang này");
            }
        } else {
            httpResponse.sendRedirect(httpRequest.getContextPath() + "/login");
        }
    }
    
    @Override
    public void init(FilterConfig filterConfig) throws ServletException {}
    
    @Override
    public void destroy() {}
}
