/**
 * Toast notifications using SweetAlert2
 * Requires: <script src="https://cdn.jsdelivr.net/npm/sweetalert2@11"></script>
 */

function showSuccess(message) {
  Swal.fire({
    icon: "success",
    title: "Thành công!",
    text: message,
    timer: 3000,
    showConfirmButton: false,
    toast: true,
    position: "top-end",
  });
}

function showError(message) {
  Swal.fire({
    icon: "error",
    title: "Lỗi!",
    text: message,
    timer: 3000,
    showConfirmButton: false,
    toast: true,
    position: "top-end",
  });
}

function showInfo(message) {
  Swal.fire({
    icon: "info",
    title: "Thông báo",
    text: message,
    timer: 3000,
    showConfirmButton: false,
    toast: true,
    position: "top-end",
  });
}

function confirmDelete(message, callback) {
  Swal.fire({
    title: "Xác nhận xóa?",
    text: message || "Bạn có chắc muốn xóa? Hành động này không thể hoàn tác!",
    icon: "warning",
    showCancelButton: true,
    confirmButtonColor: "#d33",
    cancelButtonColor: "#3085d6",
    confirmButtonText: "Xóa",
    cancelButtonText: "Hủy",
  }).then((result) => {
    if (result.isConfirmed && callback) {
      callback();
    }
  });
}

function showLoading(message) {
  Swal.fire({
    title: message || "Đang xử lý...",
    allowOutsideClick: false,
    didOpen: () => {
      Swal.showLoading();
    },
  });
}

function hideLoading() {
  Swal.close();
}
