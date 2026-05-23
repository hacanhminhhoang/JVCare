// Quản lý trạng thái delay để không gọi API liên tục (Debounce)
let searchTimeout;

function performSearch(query, type = "all") {
  clearTimeout(searchTimeout);
  const searchResultsDiv = document.getElementById("searchResults");

  // Chỉ tìm kiếm khi nhập từ 2 ký tự trở lên
  if (query.trim().length < 2) {
    if (searchResultsDiv) searchResultsDiv.style.display = "none";
    return;
  }

  // Đợi 300ms sau khi ngừng gõ phím mới bắt đầu tìm kiếm
  searchTimeout = setTimeout(() => {
    // Có thể gọi showLoading() từ notifications.js ở đây nếu muốn

    fetch(`/JVCare_MVC/search?q=${encodeURIComponent(query)}&type=${type}`)
      .then((response) => response.json())
      .then((data) => {
        renderSearchResults(data);
      })
      .catch((error) => {
        console.error("Lỗi tìm kiếm:", error);
      });
  }, 300);
}

function renderSearchResults(data) {
  const searchResultsDiv = document.getElementById("searchResults");
  if (!searchResultsDiv) return;

  let html = '<div class="list-group shadow">';

  // Hiển thị kết quả Bệnh nhân
  if (data.patients && data.patients.length > 0) {
    html += `<div class="list-group-item bg-light fw-bold">Bệnh nhân (${data.patients.length})</div>`;
    data.patients.forEach((p) => {
      html += `<a href="/JVCare_MVC/doctor/patients?id=${p.id}" class="list-group-item list-group-item-action">
                        <i class="bi bi-person"></i> ${p.name} - ${p.phone}
                     </a>`;
    });
  }

  // Hiển thị kết quả Lịch hẹn
  if (data.appointments && data.appointments.length > 0) {
    html += `<div class="list-group-item bg-light fw-bold mt-2">Lịch hẹn (${data.appointments.length})</div>`;
    data.appointments.forEach((a) => {
      html += `<a href="/JVCare_MVC/doctor/appointments/detail?id=${a.id}" class="list-group-item list-group-item-action">
                        <i class="bi bi-calendar-check"></i> [${a.date}] ${a.patientName}
                     </a>`;
    });
  }

  if (html === '<div class="list-group shadow">') {
    html +=
      '<div class="list-group-item text-muted">Không tìm thấy kết quả nào</div>';
  }

  html += "</div>";
  searchResultsDiv.innerHTML = html;
  searchResultsDiv.style.display = "block";
}

// Bắt sự kiện click ra ngoài để ẩn khung tìm kiếm
document.addEventListener("click", function (e) {
  const searchInput = document.getElementById("searchInput");
  const searchResultsDiv = document.getElementById("searchResults");

  if (
    searchInput &&
    searchResultsDiv &&
    !searchInput.contains(e.target) &&
    !searchResultsDiv.contains(e.target)
  ) {
    searchResultsDiv.style.display = "none";
  }
});
