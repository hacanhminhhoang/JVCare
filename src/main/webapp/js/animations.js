/**
 * animations.js — CarePoint UI Animation Utilities
 */

/* ── Animated Number Counter ── */
function animateCounter(el, target, duration = 1200) {
    const start = 0;
    const startTime = performance.now();
    const isPercent = String(target).includes('%');
    const num = parseFloat(String(target).replace('%', '').replace(/,/g, ''));

    function update(now) {
        const elapsed = now - startTime;
        const progress = Math.min(elapsed / duration, 1);
        // Ease out cubic
        const eased = 1 - Math.pow(1 - progress, 3);
        const current = Math.round(eased * num);
        el.textContent = current.toLocaleString('vi-VN') + (isPercent ? '%' : '');
        if (progress < 1) requestAnimationFrame(update);
    }
    requestAnimationFrame(update);
}

/* ── Skeleton → Real Content ── */
function removeSkeleton(delay = 800) {
    setTimeout(() => {
        document.querySelectorAll('.skeleton-card').forEach(card => {
            card.style.transition = 'opacity 0.4s ease';
            card.style.opacity = '0';
            setTimeout(() => { card.style.display = 'none'; }, 400);
        });
        document.querySelectorAll('.skeleton-row').forEach(row => {
            row.style.transition = 'opacity 0.3s ease';
            row.style.opacity = '0';
            setTimeout(() => { row.style.display = 'none'; }, 300);
        });
        document.querySelectorAll('[data-real]').forEach(el => {
            el.style.opacity = '0';
            el.style.display = '';
            el.style.transition = 'opacity 0.4s ease';
            requestAnimationFrame(() => { el.style.opacity = '1'; });
        });
    }, delay);
}

/* ── Intersection Observer (animate on scroll) ── */
function initScrollAnimations() {
    const observer = new IntersectionObserver((entries) => {
        entries.forEach(entry => {
            if (entry.isIntersecting) {
                entry.target.style.animation = 'pageIn 0.5s cubic-bezier(0.22,1,0.36,1) both';
                observer.unobserve(entry.target);
            }
        });
    }, { threshold: 0.1 });

    document.querySelectorAll('.stat-card, .table-container, .info-card, .admin-widget').forEach(el => {
        observer.observe(el);
    });
}

/* ── Counter Init (auto-detect .counter-value) ── */
function initCounters() {
    document.querySelectorAll('.counter-value').forEach(el => {
        const raw = el.textContent.trim();
        if (raw && raw !== '-') animateCounter(el, raw);
    });
}

/* ── Toast Notification ── */
function showToast(message, type = 'info', duration = 3500) {
    let container = document.getElementById('toast-container');
    if (!container) {
        container = document.createElement('div');
        container.id = 'toast-container';
        document.body.appendChild(container);
    }
    const icons = { success: '✅', error: '❌', info: 'ℹ️', warning: '⚠️' };
    const toast = document.createElement('div');
    toast.className = `toast ${type}`;
    toast.innerHTML = `<span>${icons[type] || icons.info}</span><span>${message}</span>`;
    container.appendChild(toast);
    setTimeout(() => {
        toast.style.animation = 'toastOut 0.35s ease forwards';
        setTimeout(() => toast.remove(), 350);
    }, duration);
}

/* ── Init on DOMContentLoaded ── */
document.addEventListener('DOMContentLoaded', () => {
    initScrollAnimations();
    initCounters();
});
