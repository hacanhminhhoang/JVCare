package com.jvcare.filter;

import javax.servlet.*;
import javax.servlet.annotation.WebFilter;
import javax.servlet.http.*;
import java.io.IOException;

@WebFilter(urlPatterns = {"/admin/*", "/doctor/*", "/patient/*"})
public class AuthFilter implements Filter {
    
    @Override
    public void init(FilterConfig filterConfig) throws ServletException {
        // Initialization code if needed
    }
    
    @Override
    public void doFilter(ServletRequest request, ServletResponse response, FilterChain chain) 
            throws IOException, ServletException {
        
        HttpServletRequest httpRequest = (HttpServletRequest) request;
        HttpServletResponse httpResponse = (HttpServletResponse) response;
        HttpSession session = httpRequest.getSession(false);
        
        String loginURI = httpRequest.getContextPath() + "/login";
        boolean isLoggedIn = (session != null && session.getAttribute("user") != null);
        boolean isLoginRequest = httpRequest.getRequestURI().equals(loginURI);
        boolean isStaticResource = httpRequest.getRequestURI().contains("/css/") || 
                                   httpRequest.getRequestURI().contains("/js/") ||
                                   httpRequest.getRequestURI().contains("/images/");
        
        if (isLoggedIn || isLoginRequest || isStaticResource) {
            chain.doFilter(request, response);
        } else {
            httpResponse.sendRedirect(loginURI);
        }
    }
    
    @Override
    public void destroy() {
        // Cleanup code if needed
    }
}
